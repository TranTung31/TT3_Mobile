# Hướng dẫn triển khai dịch vụ phân quyền bằng ASP.NET Identity (thuần Identity)

> Tài liệu này mô tả cách đưa **ASP.NET Identity** làm nền tảng **toàn bộ** cho việc quản lý **người dùng – vai trò (role) – quyền (permission)** và **xác thực** trong `SystemService`, **thay thế hoàn toàn Keycloak**.
>
> - Đăng nhập bằng **username + password** do người dùng cung cấp, xác thực bằng Identity (`UserManager.CheckPasswordAsync`).
> - **JWT do chính SystemService phát hành** (symmetric key) sau khi đăng nhập thành công.
> - Giữ nguyên cơ chế **cache quyền bằng Redis** và attribute **`[RequiredPermission]`** đang hoạt động.
>
> Lưu ý: đây là tài liệu hướng dẫn — bạn **phải chỉnh sửa các class** theo hướng dẫn để hiện thực hoá. Tài liệu chỉ dừng ở mức hướng dẫn, không thay đổi code.

---

## Mục lục

1. [Mục tiêu & phạm vi](#1-mục-tiêu--phạm-vi)
2. [Hiện trạng project](#2-hiện-trạng-project)
3. [Kiến trúc đích](#3-kiến-trúc-đích)
4. [Các quyết định thiết kế quan trọng](#4-các-quyết-định-thiết-kế-quan-trọng)
5. [Triển khai từng bước](#5-triển-khai-từng-bước)
6. [Migration cơ sở dữ liệu](#6-migration-cơ-sở-dữ-liệu)
7. [Danh sách file bị ảnh hưởng](#7-danh-sách-file-bị-ảnh-hưởng)
8. [Kiểm thử](#8-kiểm-thử)
9. [Lưu ý & các lỗi thường gặp](#9-lưu-ý--các-lỗi-thường-gặp)
10. [Phụ lục: mã nguồn mẫu đầy đủ](#10-phụ-lục-mã-nguồn-mẫu-đầy-đủ)

---

## 1. Mục tiêu & phạm vi

**Mục tiêu:** dùng ASP.NET Identity (`IdentityUser`, `IdentityRole`, `IdentityDbContext`, `UserManager`, `RoleManager`, `SignInManager`) làm nền tảng **duy nhất** cho:

- `UserManager<ApplicationUser>` quản lý hồ sơ user (username, email, password hash, lockout, security stamp, …).
- `RoleManager<Role>` quản lý role theo chuẩn Identity.
- Đăng nhập bằng **username + password**, phát hành **JWT nội bộ** cho client.
- Bảng `Permission` / `RolePermission` **vẫn là bảng tự định nghĩa** (Identity không có khái niệm permission) — phần mở rộng riêng của hệ thống.
- Luồng phân quyền (`[RequiredPermission]` → `PermissionAuthorizationHandler` → Redis) **không thay đổi hành vi**.

**Phạm vi loại bỏ:** Keycloak — gỡ toàn bộ phần xác thực/dịch vụ/mô hình liên quan (xem mục 2.4).

---

## 2. Hiện trạng project

> Đây là **điểm xuất phát** (mã nguồn hiện tại) — còn sử dụng Keycloak cho xác thực. Toàn bộ phần Keycloak sẽ được **thay thế bằng Identity** theo tài liệu này.

### 2.1. Cấu trúc giải pháp

```
TT3_MobileBE.sln
├── Shared/
│   ├── Shared.Security/        # JWT Bearer + authorization handler + claim enricher
│   │   ├── JwtAuthenticationExtensions.cs
│   │   ├── JwtSettings.cs
│   │   ├── Authorization/
│   │   │   ├── AuthorizationExtensions.cs      # AddPermissionAuthorization()
│   │   │   ├── PermissionAuthorizationHandler.cs
│   │   │   ├── RequiredPermissionAttribute.cs
│   │   │   ├── IJwtClaimsEnricher.cs
│   │   │   └── UserPermissionsJwtClaimsEnricher.cs   # HIỆN LÀ STUB (sẽ xóa)
│   │   ├── Constants/CustomClaimTypes.cs
│   │   └── Permissions/TcdtPermissions.cs      # ~400+ hằng số quyền, 2508 dòng
│   ├── Shared.Redis/Permissions/
│   │   ├── IUserPermissionCacheService.cs
│   │   └── RedisUserPermissionCacheService.cs
│   └── Shared.Contracts/Authentication/CurrentUser.cs
└── SystemService/
    ├── SystemService.Api/                  # Program.cs, Controllers/, Middleware/
    ├── SystemService.Application/          # MediatR CQRS: Features/Auth|Users|Roles|Menus, Services/
    ├── SystemService.Domain/
    │   ├── BaseEntity.cs                   # <TKey> + ShadowBaseEntity (CreatedOnUtc...)
    │   ├── Entities/Users/ApplicationUser.cs
    │   ├── Entities/Authorization/{Role,Permission,RolePermission,ApplicationUserRole}.cs
    │   └── Repositories/ (IUserRepository, IAuthorizationRepositories, ...)
    └── SystemService.Infrastructure/
        ├── Persistence/SystemDbContext.cs
        ├── Persistence/Configurations/ (ApplicationUserConfiguration, ...)
        ├── Persistence/SeedData/ApplicationDbSeeder.cs   # ĐANG RỖNG
        ├── Repositories/ (UserRepository, AuthorizationRepositories.cs, ...)
        ├── Services/ (KeycloakAuthenticationService, ...)
        └── Keycloak/Models/ (UserRepresentation, RoleRepresentation, ...)
```

### 2.2. Trạng thái hiện tại của từng khối

| Thành phần | File | Trạng thái |
|---|---|---|
| Entity `ApplicationUser` | `SystemService.Domain/Entities/Users/ApplicationUser.cs` | `class ApplicationUser : BaseEntity<Guid>` — **không** kế thừa `IdentityUser`; có cột `KeycloakId` |
| Entity `Role` | `SystemService.Domain/Entities/Authorization/Role.cs` | `partial class Role : BaseEntity<Guid>` — **không** kế thừa `IdentityRole`; có cột `KeycloakId` |
| Entity `ApplicationUserRole` | `SystemService.Domain/Entities/Authorization/ApplicationUserRole.cs` | Tự định nghĩa, có khóa chính surrogate `Id` |
| DbContext | `SystemService.Infrastructure/Persistence/SystemDbContext.cs` | `class SystemDbContext : DbContext` — **không** phải `IdentityDbContext` |
| DbContext provider | `SystemService.Infrastructure/DependencyInjection.cs` (dòng 28-37) | `UseSqlServer` với connection string `SystemServiceConnection` |
| Repository chung | `SystemService.Domain/IRepository.cs`, `SystemService.Infrastructure/EfRepository.cs` | **Ràng buộc `where TEntity : BaseEntity<TKey>`** — quan trọng, xem mục 4.3 |
| Đăng ký DI | `SystemService.Infrastructure/DependencyInjection.cs` (`AddInfrastructureServices`) | DbContext, các repository, `IUnitOfWork`, `IAuthenticationService` |
| Xác thực | `Shared/Shared.Security/JwtAuthenticationExtensions.cs` + `SystemService.Api/Program.cs` dòng 33 | **Keycloak OIDC** (`Authority` = realm `tt3-qldt`) → **sẽ thay bằng JWT nội bộ** |
| Phân quyền | `Shared/Shared.Security/Authorization/AuthorizationExtensions.cs` | `AddPermissionAuthorization()`: policy `HasPermission`, `DefaultPolicy`, handler |
| Cache quyền | `Shared/Shared.Redis` | `IUserPermissionCacheService` (Redis cluster, key `permissions:user:<userId>`) |
| Enricher claim | `UserPermissionsJwtClaimsEnricher.cs` | **Stub — trả rỗng → sẽ xóa** (JWT nội bộ sẽ tự có claim `user_id`) |
| Flow login | `SystemService.Application/Features/Auth/Commands/LoginCommand.cs` | Gọi Keycloak lấy token → **sẽ thay bằng Identity + JWT nội bộ** |
| Gán user-role | `CreateUserCommand.cs`, `ApplicationUserRoleRepository.AssignRolesAsync` | Lưu trực tiếp vào bảng `ApplicationUserRole` |
| Sync quyền | `SystemService.Application/Services/IPermissionSyncService.cs` | Chỉ có **interface**, chưa có implementation |
| Seeder | `SystemService.Infrastructure/Persistence/SeedData/ApplicationDbSeeder.cs` | Rỗng; trong `Program.cs` có khối seed đã **comment** (dòng 130-145) tham chiếu `UserManager<ApplicationUser>` |
| Identity | — | **Chưa có package Identity nào** được tham chiếu trong bất kỳ `.csproj` nào |

### 2.3. Luồng phân quyền hiện tại (tóm tắt — sẽ thay thế)

```
[1] Đăng nhập:  LoginCommand → Keycloak /protocol/openid-connect/token
[2] Decode JWT → lấy sub → Provision user vào DB local
[3] Load permissions từ DB (User→Role→RolePermission→Permission.Name)
[4] Cache permissions vào Redis:  permissions:user:<userId> (TTL 720 phút)
[5] Request sau đó: JWT Bearer (Keycloak) → Enricher (đang rỗng)
    → PermissionAuthorizationHandler đọc claim "user_id" → Redis → đối chiếu [RequiredPermission]
[6] Nếu Redis miss → fallback gRPC (hiện trả [] → 403)
```

### 2.4. Các thành phần Keycloak cần gỡ bỏ

| File / Thành phần | Lý do |
|---|---|
| `Shared.Security/JwtAuthenticationExtensions.cs` (phần OIDC) | Đổi sang validate JWT nội bộ bằng symmetric key |
| `SystemService.Infrastructure/Services/KeycloakAuthenticationService.cs`, `IAuthenticationService` | Đăng nhập sẽ do Identity đảm nhiệm |
| `SystemService.Infrastructure/Services/KeycloakSettingsProvider.cs`, `Settings/KeycloakSettings.cs`, `IKeycloakSettingsProvider` | Không còn dùng |
| `SystemService.Application/Services/IKeycloakAdminClient.cs` + `Infrastructure/Keycloak/` (Models, client) | Không còn dùng |
| `Entities/Users/ApplicationUser.cs`, `Entities/Authorization/Role.cs`, `Permission.cs` (cột `KeycloakId`) | Bỏ cột, gỡ khỏi entity + config + repository |
| `Features/Auth/Commands/ExchangeTokenCommand.cs`, `LogoutSidCommand.cs`, `LogoutCommand.cs` | Luồng code exchange / logout theo Keycloak |
| `Features/Users/Commands/CreateKeycloakUserForImportedUserCommand.cs`, `CreateAllKeycloakUserForImportedCommand.cs` + endpoint `create-keycloak*` | Đồng bộ user sang Keycloak — bỏ |
| `Models/Auth/KeycloakTokenResponse.cs` | Thay bằng `AuthTokenResponse` do Identity phát hành |
| Cấu hình `Keycloak` trong `appsettings.json` / `appsettings.Development.json` | Bỏ section |

---

## 3. Kiến trúc đích (thuần Identity)

```
                     ┌─────────────────────────────────────────────────┐
                     │  Client (React)                                │
                     │  POST /api/.../auth/login  (username+password) │
                     └───────────────┬─────────────────────────────────┘
                                     │ JWT do SystemService phát hành
                                     ▼
                     ┌─────────────────────────────────────────────────┐
                     │  SystemService.Api  (Program.cs)                │
                     │   JwtBearer (symmetric key) + UseAuthorization  │
                     └───────────────┬─────────────────────────────────┘
                                     │
            ┌────────────────────────┼────────────────────────────┐
            ▼                        ▼                            ▼
   ┌──────────────────┐    ┌────────────────────┐      ┌───────────────────┐
   │ JwtTokenService  │    │ JwtBearer          │      │ Redis             │
   │ (phát hành JWT)  │    │ OnTokenValidated   │      │ permissions:user  │
   │  · claims        │    │ (validate key)     │      └───────────────────┘
   └──────────────────┘    └────────────────────┘
            ┌────────────────────────┼────────────────────────────┐
            ▼                        ▼                            ▼
   ┌─────────────────────────────────────────────────────────────────┐
   │  SystemDbContext : IdentityDbContext<ApplicationUser, Role,     │
   │                                       Guid>                     │
   │  • Identity chuẩn: Users, Roles, UserRoles, UserClaims,         │
   │    UserLogins, UserTokens, RoleClaims                           │
   │  • Tuỳ biến:     Permissions, RolePermissions, Menus, ...       │
   └─────────────────────────────────────────────────────────────────┘
            │
            ├── UserManager<ApplicationUser>   (provision, password, lockout, roles)
            ├── RoleManager<Role>              (CRUD role)
            └── PermissionSyncService          (sync TcdtPermissions → DB, gán role-permission)
```

**Nguyên tắc:**

1. **Identity chịu trách nhiệm toàn bộ xác thực + phân quyền local.** Không còn Keycloak.
2. Đăng nhập: username + password → `UserManager.CheckPasswordAsync` → **JWT do `JwtTokenService` phát hành** (chứa `user_id`, `is_super_admin`, roles).
3. `ApplicationUser : IdentityUser<Guid>`, `Role : IdentityRole<Guid>`, liên kết user-role dùng `IdentityUserRole<Guid>` chuẩn.
4. Bảng `Permission` / `RolePermission` giữ nguyên (không thuộc Identity).
5. Luồng phân quyền theo permission vẫn qua `[RequiredPermission]` → handler → Redis.

---

## 4. Các quyết định thiết kế quan trọng

### 4.1. Dùng `AddIdentityCore` thay vì `AddIdentity`

- `AddIdentity()` đăng ký **cookie scheme `Identity.Application` làm scheme mặc định** — xung đột với `JwtBearer` (API thuần token). Thứ tự đăng ký trong `Program.cs` dễ gây lỗi khó phát hiện.
- `AddIdentityCore<TUser>()` chỉ đăng ký `UserManager`, `RoleManager`, `SignInManager`, **không** đụng vào default scheme → an toàn cho JWT Bearer. **Khuyến nghị dùng `AddIdentityCore`.**

### 4.2. Liên kết User–Role: dùng `IdentityUserRole<Guid>` (bỏ `ApplicationUserRole` cũ)

- `UserStore` của Identity chỉ hiểu bảng liên kết chuẩn `IdentityUserRole<TKey>` (khóa chính composite `(UserId, RoleId)`). Nếu giữ entity `ApplicationUserRole` có khóa surrogate `Id` thì `UserManager.GetRolesAsync()`, `AddToRolesAsync()` sẽ **không thấy** dữ liệu.
- Vì vậy: xóa entity `ApplicationUserRole`, chuyển navigation sang `ICollection<IdentityUserRole<Guid>>`, viết lại `IApplicationUserRoleRepository` (xem 4.3).
- Các handler đang dùng `GetRolesByUserIdAsync()` (LoginCommand, GetCurrentUserPermissionsQuery) vẫn hoạt động vì interface giữ nguyên chữ ký.

### 4.3. Ràng buộc `IRepository<TEntity, TKey> where TEntity : BaseEntity<TKey>`

- `IRepository<,>` (`SystemService.Domain/IRepository.cs`) và `EfRepository<,>` (`SystemService.Infrastructure/EfRepository.cs`) đều khai báo `where TEntity : BaseEntity<TKey>`.
- Khi `ApplicationUser` / `Role` kế thừa `IdentityUser<Guid>` / `IdentityRole<Guid>` (không còn `BaseEntity`), các repository dùng chung sẽ **không compile**.
- **Giải pháp:** tách `IUserRepository`, `IRoleRepository`, `IApplicationUserRoleRepository` ra khỏi `IRepository<,>` và implement trực tiếp trên `SystemDbContext` (hoặc qua `UserManager`/`RoleManager`). `Permission` / `RolePermission` vẫn kế thừa `BaseEntity<Guid>` nên `PermissionRepository` / `RolePermissionRepository` **giữ nguyên** (chỉ bỏ phần `KeycloakId`).

### 4.4. Password & lockout do Identity quản lý

- Password là **xác thực chính** → dùng `UserManager.CreateAsync(user, password)` khi tạo user, `CheckPasswordAsync` / `SignInManager.PasswordSignInAsync` khi đăng nhập.
- `PasswordHash` được Identity băm bằng `PasswordHasher` — **không bao giờ** lưu password dạng thô.
- Cấu hình chính sách password/lockout hợp lý trong `AddIdentityCore` (xem Bước 8).

### 4.5. Quyền (Permission) không thuộc Identity

- `Permission` / `RolePermission` giữ nguyên thiết kế. `Role` (giờ là `IdentityRole`) liên kết với `RolePermission` bằng `RoleId` (Guid) — không xung đột.

---

## 5. Triển khai từng bước

### Bước 1 — Cài package NuGet

**1a. `SystemService/SystemService.Infrastructure/SystemService.Infrastructure.csproj`** (bắt buộc):

```xml
<PackageReference Include="Microsoft.AspNetCore.Identity.EntityFrameworkCore" Version="8.0.30" />
<PackageReference Include="System.IdentityModel.Tokens.Jwt" Version="8.0.0" />
```

> Version Identity khớp với `Microsoft.EntityFrameworkCore.SqlServer` 8.0.30. Package kéo theo `Microsoft.Extensions.Identity.Core` và `Microsoft.Extensions.Identity.Stores`. `System.IdentityModel.Tokens.Jwt` dùng cho `JwtTokenService` (nếu thiếu, thêm trực tiếp để tránh phụ thuộc ngầm).

**1b. `SystemService/SystemService.Application/SystemService.Application.csproj`** (nếu handler dùng trực tiếp `UserManager<TUser>` / `RoleManager<TRole>`):

```xml
<PackageReference Include="Microsoft.Extensions.Identity.Core" Version="8.0.30" />
```

> File `GetUserDropdownQuery.cs` hiện có sẵn `using Microsoft.AspNetCore.Identity;` (đang là using thừa). Thêm package sẽ khiến using này hợp lệ.

**1c. `Shared/Shared.Security/Shared.Security.csproj`** — giữ nguyên `Microsoft.AspNetCore.Authentication.JwtBearer` 8.0.6 (dùng để validate JWT nội bộ).

---

### Bước 2 — Sửa entity `ApplicationUser`

**File:** `SystemService/SystemService.Domain/Entities/Users/ApplicationUser.cs`

Trước:

```csharp
public class ApplicationUser : BaseEntity<Guid>
{
    public string UserName { get; set; }
    public string Email { get; set; }
    public string KeycloakId { get; set; }       // ← bỏ
    public string FullName { get; set; }
    public Guid? DonViId { get; set; }
    public bool IsSuperAdmin { get; set; }
    public bool IsDelete { get; set; }
    public int LinhVuQuanLy { get; set; }
    public virtual ICollection<ApplicationUserRole> UserRoles { get; set; } = new List<ApplicationUserRole>();
}
```

Sau:

```csharp
using Microsoft.AspNetCore.Identity;
using SystemService.Domain.Entities.Authorization;

namespace SystemService.Domain.Entities.Users;

public class ApplicationUser : IdentityUser<Guid>
{
    public string FullName { get; set; } = string.Empty;
    public Guid? DonViId { get; set; }
    public bool IsSuperAdmin { get; set; }
    public bool IsDelete { get; set; }
    public int LinhVuQuanLy { get; set; }

    // IdentityUser không có 2 trường audit này (đang nằm ở BaseEntity/ShadowBaseEntity),
    // bổ sung lại nếu bạn vẫn cần.
    public DateTime CreatedOnUtc { get; set; }
    public DateTime? UpdatedOnUtc { get; set; }

    public virtual ICollection<IdentityUserRole<Guid>> UserRoles { get; set; } = new List<IdentityUserRole<Guid>>();
}
```

Điểm cần lưu ý:

- **Xóa** khai báo `UserName`, `Email`, `Id` — đã kế thừa từ `IdentityUser<Guid>` (`Id` kiểu `Guid`).
- **Xóa `KeycloakId`** — không còn liên kết với Keycloak.
- `IsDelete` là trường nghiệp vụ, **không** nên trùng với khái niệm lockout/delete của Identity.

---

### Bước 3 — Sửa entity `Role`

**File:** `SystemService/SystemService.Domain/Entities/Authorization/Role.cs`

```csharp
using Microsoft.AspNetCore.Identity;

namespace SystemService.Domain.Entities.Authorization;

public partial class Role : IdentityRole<Guid>
{
    public string? Description { get; set; }
    public bool IsActive { get; set; } = true;

    // Bổ sung lại nếu cần audit (xem Bước 2)
    public DateTime CreatedOnUtc { get; set; }
    public DateTime? UpdatedOnUtc { get; set; }

    public virtual ICollection<RolePermission> RolePermissions { get; set; } = new List<RolePermission>();
    public virtual ICollection<IdentityUserRole<Guid>> UserRoles { get; set; } = new List<IdentityUserRole<Guid>>();
}
```

- `IdentityRole<Guid>` kế thừa sẵn `Id`, `Name`, `NormalizedName`, `ConcurrencyStamp` → **xóa** `required string Name` và `KeycloakId`.

---

### Bước 4 — Sửa entity `Permission` (bỏ `KeycloakId`)

**File:** `SystemService/SystemService.Domain/Entities/Authorization/Permission.cs`

```csharp
public partial class Permission : BaseEntity<Guid>
{
    /// <summary>Tên permission (unique) - ví dụ: "TcdtPermissions.DmDonVi.View"</summary>
    public required string Name { get; set; }

    /// <summary>Mô tả tiếng Việt - ví dụ: "Xem"</summary>
    public string Description { get; set; }

    /// <summary>Đường dẫn nhóm - dùng "|" làm separator để hiển thị tree</summary>
    public string GroupPath { get; set; }

    public bool IsActive { get; set; } = true;

    public virtual ICollection<RolePermission> RolePermissions { get; set; } = new List<RolePermission>();
}
```

> Bỏ `KeycloakId` — không còn đồng bộ quyền với Keycloak. `RolePermission` giữ nguyên.

---

### Bước 5 — Bỏ entity `ApplicationUserRole`

**File:** `SystemService/SystemService.Domain/Entities/Authorization/ApplicationUserRole.cs` → **xóa**.

Navigation `UserRoles` ở `ApplicationUser` và `Role` giờ trỏ tới `IdentityUserRole<Guid>` (đã làm ở Bước 2, 3).

---

### Bước 6 — Sửa `SystemDbContext` thành `IdentityDbContext`

**File:** `SystemService/SystemService.Infrastructure/Persistence/SystemDbContext.cs`

Trước (dòng 11):

```csharp
public class SystemDbContext : DbContext
```

Sau:

```csharp
using Microsoft.AspNetCore.Identity.EntityFrameworkCore;

public class SystemDbContext : IdentityDbContext<ApplicationUser, Role, Guid>
```

Tiếp đó, trong lớp `SystemDbContext`:

- **Xóa** khai báo trùng (IdentityDbContext đã có sẵn):
  ```csharp
  public DbSet<ApplicationUser> Users { get; set; }   // ❌ bỏ
  public DbSet<Role> Roles { get; set; }              // ❌ bỏ
  public DbSet<ApplicationUserRole> ApplicationUserRoles { get; set; } // ❌ bỏ
  ```
- **Giữ nguyên** các DbSet còn lại:
  ```csharp
  public DbSet<Permission> Permissions { get; set; }
  public DbSet<RolePermission> RolePermissions { get; set; }
  public DbSet<ApplicationMenu> ApplicationMenus { get; set; }
  public DbSet<UserTableLayout> UserTableLayouts { get; set; }
  public DbSet<MenuPermission> MenuPermissions { get; set; }
  public DbSet<DmDonVi> DmDonVi { get; set; }
  ```
- **Giữ nguyên** `ConfigureConventions` và `OnModelCreating` — đặc biệt **giữ thứ tự**: gọi `base.OnModelCreating(modelBuilder)` **trước** `ApplyConfigurationsFromAssembly(...)` để các cấu hình `ToTable` của project ghi đè lên tên bảng mặc định của Identity.

> `IdentityDbContext<TUser, TRole, TKey>` tự khởi tạo DbSet: `Users`, `Roles`, `UserRoles`, `UserClaims`, `UserLogins`, `UserTokens`, `RoleClaims`.

---

### Bước 7 — Cập nhật EF configurations

**7a. `Persistence/Configurations/ApplicationUserConfiguration.cs`** — bỏ mapping `UserName`/`Email` (Identity map sẵn) và `KeycloakId`:

```csharp
public class ApplicationUserConfiguration : IEntityTypeConfiguration<ApplicationUser>
{
    public void Configure(EntityTypeBuilder<ApplicationUser> builder)
    {
        builder.ToTable("ApplicationUser");
        builder.HasKey(u => u.Id);

        builder.Property(u => u.FullName).HasMaxLength(500);
        builder.Property(u => u.LinhVuQuanLy).IsRequired();

        // UserName, Email, NormalizedUserName... do IdentityDbContext quản lý (max 256).
    }
}
```

**7b. `Persistence/Configurations/Authorization/RoleConfiguration.cs`** — bỏ `KeycloakId`:

```csharp
public class RoleConfiguration : IEntityTypeConfiguration<Role>
{
    public void Configure(EntityTypeBuilder<Role> builder)
    {
        builder.ToTable("Roles");
        builder.Property(e => e.Description).HasMaxLength(1000);
        // Name / NormalizedName / ConcurrencyStamp do Identity quản lý.
    }
}
```

**7c. `Persistence/Configurations/Authorization/PermissionConfiguration.cs`** — bỏ `KeycloakId`:

```csharp
public class PermissionConfiguration : IEntityTypeConfiguration<Permission>
{
    public void Configure(EntityTypeBuilder<Permission> builder)
    {
        builder.ToTable("Permissions");
        builder.HasKey(e => e.Id);

        builder.Property(e => e.Name).IsRequired().HasMaxLength(500);
        builder.Property(e => e.Description).HasMaxLength(1000);
        builder.Property(e => e.GroupPath).HasMaxLength(1000);
    }
}
```

**7d. `Persistence/Configurations/Authorization/ApplicationUserRoleConfiguration.cs`**

Nếu muốn giữ tên bảng `ApplicationUserRole` (thay vì `AspNetUserRoles`):

```csharp
public class ApplicationUserRoleConfiguration : IEntityTypeConfiguration<IdentityUserRole<Guid>>
{
    public void Configure(EntityTypeBuilder<IdentityUserRole<Guid>> builder)
    {
        builder.ToTable("ApplicationUserRole");
        // PK composite (UserId, RoleId) do Identity thiết lập sẵn.
        builder.HasKey(ur => new { ur.UserId, ur.RoleId });

        // BẮT BUỘC khai báo relationship nối navigation UserRoles (trên ApplicationUser/Role)
        // với FK chuẩn. Nếu chỉ có ToTable, EF tự suy ra relationship mới và sinh FK shadow
        // (UserId1 / RoleId1) → lỗi cảnh báo khi tạo migration.
        builder.HasOne<ApplicationUser>()
               .WithMany(u => u.UserRoles)
               .HasForeignKey(ur => ur.UserId)
               .IsRequired();

        builder.HasOne<Role>()
               .WithMany(r => r.UserRoles)
               .HasForeignKey(ur => ur.RoleId)
               .IsRequired();
    }
}
```

> Bảng cũ có cột `Id` (khóa surrogate) — schema mới khác nên phải **migrate dữ liệu** (xem mục 6).

---

### Bước 8 — Cập nhật repository

> Nguyên tắc: `IUserRepository`, `IRoleRepository`, `IApplicationUserRoleRepository` **tách khỏi** `IRepository<,>`, implement trực tiếp bằng `SystemDbContext`; đồng thời **gỡ các phương thức liên quan Keycloak** (`GetByKeycloakIdAsync`...).

**8a. `SystemService/SystemService.Domain/Repositories/IUserRepository.cs`**

```csharp
public interface IUserRepository
{
    IQueryable<ApplicationUser> Table { get; }

    Task<IPagedList<ApplicationUser>> SearchAsync(string keyword, int pageIndex = 0, int pageSize = int.MaxValue);
    Task<bool> BeUniqueUserName(string userName, Guid? currentId = null, CancellationToken cancellationToken = default);
    Task<bool> BeUniqueEmail(string email, Guid? currentId = null, CancellationToken cancellationToken = default);
    Task<Guid> GetDonViIdByIdAsync(Guid userId);
}
```

**`SystemService/SystemService.Infrastructure/Repositories/UserRepository.cs`** — không kế thừa `EfRepository`:

```csharp
public class UserRepository : IUserRepository
{
    private readonly SystemDbContext _context;

    public UserRepository(SystemDbContext context) => _context = context;

    public IQueryable<ApplicationUser> Table => _context.Users.AsQueryable();

    public async Task<IPagedList<ApplicationUser>> SearchAsync(string keyword, int pageIndex = 0, int pageSize = int.MaxValue)
    {
        var query = Table.Where(c => !c.IsDelete);

        if (!string.IsNullOrWhiteSpace(keyword))
        {
            keyword = keyword.ToLower();
            query = query.Where(u => u.UserName.ToLower().Contains(keyword) ||
                                     u.FullName.ToLower().Contains(keyword) ||
                                     u.Email.ToLower().Contains(keyword));
        }

        return await query.OrderBy(tb => tb.Id).ToPagedListAsync(pageIndex, pageSize);
    }

    public async Task<bool> BeUniqueUserName(string userName, Guid? currentId = null, CancellationToken cancellationToken = default)
    {
        var user = await Table.FirstOrDefaultAsync(c => c.UserName == userName, cancellationToken);
        return user == null || user.Id == currentId;
    }

    public async Task<bool> BeUniqueEmail(string email, Guid? currentId = null, CancellationToken cancellationToken = default)
    {
        var user = await Table.FirstOrDefaultAsync(c => c.Email == email, cancellationToken);
        return user == null || user.Id == currentId;
    }

    public async Task<Guid> GetDonViIdByIdAsync(Guid userId)
    {
        var user = await Table.FirstOrDefaultAsync(c => c.Id == userId);
        return user.DonViId.Value;
    }
}
```

**8b. `SystemService/SystemService.Domain/Repositories/IAuthorizationRepositories.cs`** — gỡ `GetByKeycloakIdAsync`, tách khỏi `IRepository<,>`:

```csharp
public interface IPermissionRepository
{
    IQueryable<Permission> Table { get; }
    Task<Permission?> GetByNameAsync(string name, CancellationToken cancellationToken = default);
    Task<IList<Permission>> GetByNamesAsync(IEnumerable<string> names, CancellationToken cancellationToken = default);
    Task<IList<Permission>> GetAllActiveAsync(CancellationToken cancellationToken = default);
}

public interface IRoleRepository
{
    IQueryable<Role> Table { get; }
    Task<Role?> GetByNameAsync(string name, CancellationToken cancellationToken = default);
    Task<bool> BeUniqueNameAsync(string name, Guid? currentId = null, CancellationToken cancellationToken = default);
    Task<Role?> GetByIdWithPermissionsAsync(Guid id, CancellationToken cancellationToken = default);
    Task<IPagedList<Role>> SearchAsync(string keyword, string name, string desciption, int pageIndex = 0, int pageSize = int.MaxValue);
    Task<IList<Role>> GetByNamesAsync(IEnumerable<string> names, CancellationToken cancellationToken = default);
    Task<IList<Role>> GetByIdsAsync(IEnumerable<Guid> ids, CancellationToken cancellationToken = default);
}

public interface IRolePermissionRepository
{
    IQueryable<RolePermission> Table { get; }
    Task<IList<Permission>> GetPermissionsByRoleIdAsync(Guid roleId, CancellationToken cancellationToken = default);
    Task<IList<Role>> GetRolesByPermissionIdAsync(Guid permissionId, CancellationToken cancellationToken = default);
    Task DeleteByRoleIdAsync(Guid roleId, CancellationToken cancellationToken = default);
    Task<bool> HasPermissionAsync(Guid roleId, Guid permissionId, CancellationToken cancellationToken = default);
    Task AssignPermissionsAsync(Guid roleId, IEnumerable<Guid> permissionIds, CancellationToken cancellationToken = default);
}

public interface IApplicationUserRoleRepository
{
    Task<IList<Role>> GetRolesByUserIdAsync(Guid userId, CancellationToken cancellationToken = default);
    Task<IList<ApplicationUser>> GetUsersByRoleIdAsync(Guid roleId, CancellationToken cancellationToken = default);
    Task DeleteByUserIdAsync(Guid userId, CancellationToken cancellationToken = default);
    Task AssignRolesAsync(Guid userId, IEnumerable<Guid> roleIds, CancellationToken cancellationToken = default);
}
```

**`SystemService/SystemService.Infrastructure/Repositories/AuthorizationRepositories.cs`** — viết lại `RoleRepository`, `PermissionRepository`, `ApplicationUserRoleRepository` (bỏ phần Keycloak):

```csharp
public class RoleRepository : IRoleRepository
{
    private readonly SystemDbContext _context;

    public RoleRepository(SystemDbContext context) => _context = context;

    public IQueryable<Role> Table => _context.Roles.AsQueryable();

    public async Task<Role?> GetByNameAsync(string name, CancellationToken cancellationToken = default)
        => await Table.FirstOrDefaultAsync(r => r.Name == name, cancellationToken);

    public async Task<bool> BeUniqueNameAsync(string name, Guid? currentId = null, CancellationToken cancellationToken = default)
    {
        var role = await Table.FirstOrDefaultAsync(r => r.Name == name, cancellationToken);
        return role == null || role.Id == currentId;
    }

    public async Task<Role?> GetByIdWithPermissionsAsync(Guid id, CancellationToken cancellationToken = default)
        => await Table
            .Include(r => r.RolePermissions)
                .ThenInclude(rp => rp.Permission)
            .FirstOrDefaultAsync(r => r.Id == id, cancellationToken);

    public async Task<IPagedList<Role>> SearchAsync(string keyword, string name, string desciption, int pageIndex = 0, int pageSize = int.MaxValue)
    {
        var query = Table.AsQueryable();

        if (!string.IsNullOrWhiteSpace(keyword))
        {
            keyword = keyword.ToLower();
            query = query.Where(r => r.Name.ToLower().Contains(keyword) ||
                                     (r.Description != null && r.Description.ToLower().Contains(keyword)));
        }
        if (!string.IsNullOrWhiteSpace(name))
        {
            name = name.ToLower();
            query = query.Where(r => r.Name.ToLower().Contains(name));
        }
        if (!string.IsNullOrWhiteSpace(desciption))
        {
            desciption = desciption.ToLower();
            query = query.Where(r => r.Description.ToLower().Contains(desciption));
        }

        return await query.OrderBy(r => r.Name).ToPagedListAsync(pageIndex, pageSize);
    }

    public async Task<IList<Role>> GetByNamesAsync(IEnumerable<string> names, CancellationToken cancellationToken = default)
    {
        var nameList = names.ToList();
        return await Table.Where(r => nameList.Contains(r.Name)).ToListAsync(cancellationToken);
    }

    public async Task<IList<Role>> GetByIdsAsync(IEnumerable<Guid> ids, CancellationToken cancellationToken = default)
    {
        var idList = ids.ToList();
        return await Table.Where(r => idList.Contains(r.Id)).ToListAsync(cancellationToken);
    }
}

public class PermissionRepository : IPermissionRepository
{
    private readonly SystemDbContext _context;

    public PermissionRepository(SystemDbContext context) => _context = context;

    public IQueryable<Permission> Table => _context.Permissions.AsQueryable();

    public async Task<Permission?> GetByNameAsync(string name, CancellationToken cancellationToken = default)
        => await Table.FirstOrDefaultAsync(p => p.Name == name, cancellationToken);

    public async Task<IList<Permission>> GetByNamesAsync(IEnumerable<string> names, CancellationToken cancellationToken = default)
    {
        var nameList = names.ToList();
        return await Table.Where(p => nameList.Contains(p.Name)).ToListAsync(cancellationToken);
    }

    public async Task<IList<Permission>> GetAllActiveAsync(CancellationToken cancellationToken = default)
        => await Table.Where(p => p.IsActive).OrderBy(p => p.Name).ToListAsync(cancellationToken);
}

public class RolePermissionRepository : IRolePermissionRepository
{
    private readonly SystemDbContext _context;

    public RolePermissionRepository(SystemDbContext context) => _context = context;

    public IQueryable<RolePermission> Table => _context.RolePermissions.AsQueryable();

    public async Task<IList<Permission>> GetPermissionsByRoleIdAsync(Guid roleId, CancellationToken cancellationToken = default)
        => await Table
            .Where(rp => rp.RoleId == roleId)
            .Include(rp => rp.Permission)
            .Select(rp => rp.Permission)
            .ToListAsync(cancellationToken);

    public async Task<IList<Role>> GetRolesByPermissionIdAsync(Guid permissionId, CancellationToken cancellationToken = default)
        => await Table
            .Where(rp => rp.PermissionId == permissionId)
            .Include(rp => rp.Role)
            .Select(rp => rp.Role)
            .ToListAsync(cancellationToken);

    public async Task DeleteByRoleIdAsync(Guid roleId, CancellationToken cancellationToken = default)
    {
        var rolePermissions = await Table.Where(rp => rp.RoleId == roleId).ToListAsync(cancellationToken);
        _context.RolePermissions.RemoveRange(rolePermissions);
        await _context.SaveChangesAsync(cancellationToken);
    }

    public async Task<bool> HasPermissionAsync(Guid roleId, Guid permissionId, CancellationToken cancellationToken = default)
        => await Table.AnyAsync(rp => rp.RoleId == roleId && rp.PermissionId == permissionId, cancellationToken);

    public async Task AssignPermissionsAsync(Guid roleId, IEnumerable<Guid> permissionIds, CancellationToken cancellationToken = default)
    {
        var current = await Table.Where(rp => rp.RoleId == roleId).Select(rp => rp.PermissionId).ToListAsync(cancellationToken);
        var target = permissionIds?.ToList() ?? [];

        var toDelete = current.Except(target).ToList();
        if (toDelete.Count != 0)
            _context.RolePermissions.RemoveRange(Table.Where(rp => rp.RoleId == roleId && toDelete.Contains(rp.PermissionId)));

        var toAdd = target.Except(current).ToList();
        if (toAdd.Count != 0)
            await _context.RolePermissions.AddRangeAsync(
                toAdd.Select(permissionId => new RolePermission
                {
                    Id = Guid.NewGuid(),
                    RoleId = roleId,
                    PermissionId = permissionId
                }), cancellationToken);
    }
}

public class ApplicationUserRoleRepository : IApplicationUserRoleRepository
{
    private readonly SystemDbContext _context;

    public ApplicationUserRoleRepository(SystemDbContext context) => _context = context;

    public async Task<IList<Role>> GetRolesByUserIdAsync(Guid userId, CancellationToken cancellationToken = default)
        => await _context.UserRoles
            .Where(ur => ur.UserId == userId)
            .Join(_context.Roles, ur => ur.RoleId, r => r.Id, (ur, r) => r)
            .ToListAsync(cancellationToken);

    public async Task<IList<ApplicationUser>> GetUsersByRoleIdAsync(Guid roleId, CancellationToken cancellationToken = default)
        => await _context.UserRoles
            .Where(ur => ur.RoleId == roleId)
            .Join(_context.Users, ur => ur.UserId, u => u.Id, (ur, u) => u)
            .ToListAsync(cancellationToken);

    public async Task DeleteByUserIdAsync(Guid userId, CancellationToken cancellationToken = default)
    {
        var links = await _context.UserRoles.Where(ur => ur.UserId == userId).ToListAsync(cancellationToken);
        _context.UserRoles.RemoveRange(links);
        await _context.SaveChangesAsync(cancellationToken);
    }

    public async Task AssignRolesAsync(Guid userId, IEnumerable<Guid> roleIds, CancellationToken cancellationToken = default)
    {
        await DeleteByUserIdAsync(userId, cancellationToken);

        var links = roleIds.Distinct()
            .Select(roleId => new IdentityUserRole<Guid> { UserId = userId, RoleId = roleId });

        await _context.UserRoles.AddRangeAsync(links, cancellationToken);
        await _context.SaveChangesAsync(cancellationToken);
    }
}
```

---

### Bước 9 — Đăng ký Identity & JWT trong DI

**File:** `SystemService/SystemService.Infrastructure/DependencyInjection.cs` — trong `AddInfrastructureServices`:

```csharp
using Microsoft.AspNetCore.Identity;
using SystemService.Infrastructure.Services;

// 1. Đăng ký ASP.NET Identity (AddIdentityCore để KHÔNG chiếm default auth scheme - JWT Bearer vẫn là mặc định)
services.AddIdentityCore<ApplicationUser>(options =>
{
    options.User.RequireUniqueEmail = false;        // email không bắt buộc unique (nghiệp vụ hệ thống)
    options.Password.RequireDigit = true;           // password là xác thực thật → đặt chính sách hợp lý
    options.Password.RequireLowercase = true;
    options.Password.RequireUppercase = true;
    options.Password.RequireNonAlphanumeric = false;
    options.Password.RequiredLength = 8;
    options.Lockout.MaxFailedAccessAttempts = 5;    // khóa sau 5 lần sai
    options.Lockout.DefaultLockoutTimeSpan = TimeSpan.FromMinutes(5);
})
.AddRoles<Role>()                       // đăng ký RoleManager<Role>
.AddEntityFrameworkStores<SystemDbContext>()
.AddDefaultTokenProviders();

// 2. Dịch vụ phát hành JWT nội bộ
services.AddScoped<ITokenService, JwtTokenService>();

// 3. Dịch vụ đồng bộ quyền (xem Bước 12)
services.AddScoped<IPermissionSyncService, PermissionSyncService>();

// 4. Xóa đăng ký Keycloak cũ:
//    - bỏ: services.Configure<KeycloakSettings>(...);
//    - bỏ: services.AddHttpClient<IAuthenticationService, KeycloakAuthenticationService>(...);
```

> Không cần `AddAuthentication()`/`AddJwtBearer()` ở Infrastructure — đã do `AddJwtAuthentication()` (Shared.Security) đảm nhiệm ở `Program.cs` (sẽ sửa ở Bước 11).

---

### Bước 10 — Viết lại luồng đăng nhập (`LoginCommand`)

**File:** `SystemService/SystemService.Application/Features/Auth/Commands/LoginCommand.cs`

Username + password do **người dùng truyền lên**, xác thực bằng `UserManager.CheckPasswordAsync`, phát hành JWT nội bộ:

```csharp
using MediatR;
using Microsoft.AspNetCore.Identity;
using Microsoft.Extensions.Logging;
using Shared.Redis.Permissions;
using SystemService.Application.Models.Auth;
using SystemService.Application.Services;
using SystemService.Domain.Entities.Users;
using SystemService.Domain.Repositories;

namespace SystemService.Application.Features.Auth.Commands;

public class LoginCommand : IRequest<AuthTokenResponse>
{
    public string UserName { get; set; } = string.Empty;
    public string Password { get; set; } = string.Empty;
}

public class LoginCommandHandler : IRequestHandler<LoginCommand, AuthTokenResponse>
{
    private readonly UserManager<ApplicationUser> _userManager;
    private readonly ITokenService _tokenService;
    private readonly IApplicationUserRoleRepository _userRoleRepository;
    private readonly IRolePermissionRepository _rolePermissionRepository;
    private readonly IUserPermissionCacheService _userPermissionCacheService;
    private readonly ILogger<LoginCommandHandler> _logger;

    public LoginCommandHandler(
        UserManager<ApplicationUser> userManager,
        ITokenService tokenService,
        IApplicationUserRoleRepository userRoleRepository,
        IRolePermissionRepository rolePermissionRepository,
        IUserPermissionCacheService userPermissionCacheService,
        ILogger<LoginCommandHandler> logger)
    {
        _userManager = userManager;
        _tokenService = tokenService;
        _userRoleRepository = userRoleRepository;
        _rolePermissionRepository = rolePermissionRepository;
        _userPermissionCacheService = userPermissionCacheService;
        _logger = logger;
    }

    public async Task<AuthTokenResponse> Handle(LoginCommand command, CancellationToken cancellationToken)
    {
        // 1. Tìm user theo username
        var user = await _userManager.FindByNameAsync(command.UserName);
        if (user == null || user.IsDelete)
            throw new UnauthorizedException("Tên đăng nhập hoặc mật khẩu không đúng.");

        // 2. Kiểm tra mật khẩu bằng Identity (có tính lockout)
        if (!await _userManager.CheckPasswordAsync(user, command.Password))
        {
            _logger.LogWarning("Đăng nhập thất bại (sai mật khẩu) | UserName={UserName}", command.UserName);
            throw new UnauthorizedException("Tên đăng nhập hoặc mật khẩu không đúng.");
        }

        // 3. Kiểm tra tài khoản có bị khóa không
        if (await _userManager.IsLockedOutAsync(user))
            throw new UnauthorizedException("Tài khoản tạm thời bị khóa do đăng nhập sai nhiều lần.");

        // 4. Phát hành JWT nội bộ
        var token = await _tokenService.CreateTokenAsync(user, cancellationToken);

        // 5. Load permissions từ DB rồi cache vào Redis
        var permissions = await LoadUserPermissionsFromDbAsync(user.Id, cancellationToken);
        await _userPermissionCacheService.SetPermissionsAsync(
            user.Id, permissions, cancellationToken: cancellationToken);

        // 6. Trả về token + thông tin người dùng
        return new AuthTokenResponse
        {
            AccessToken = token.AccessToken,
            ExpiresIn = token.ExpiresIn,
            UserId = user.Id,
            UserName = user.UserName,
            FullName = user.FullName,
            DonViId = user.DonViId,
            LinhVuQuanLy = user.LinhVuQuanLy,
            IsSuperAdmin = user.IsSuperAdmin,
            Roles = (await _userManager.GetRolesAsync(user)).ToList(),
            Permissions = permissions.ToList()
        };
    }

    private async Task<IReadOnlyCollection<string>> LoadUserPermissionsFromDbAsync(
        Guid userId,
        CancellationToken cancellationToken)
    {
        var roles = await _userRoleRepository.GetRolesByUserIdAsync(userId, cancellationToken);
        var permissions = new HashSet<string>(StringComparer.OrdinalIgnoreCase);

        foreach (var role in roles)
        {
            var rolePermissions = await _rolePermissionRepository.GetPermissionsByRoleIdAsync(role.Id, cancellationToken);
            foreach (var permission in rolePermissions)
                if (!string.IsNullOrWhiteSpace(permission.Name))
                    permissions.Add(permission.Name);
        }

        return permissions.ToArray();
    }
}
```

**Model trả về** — tạo `SystemService/SystemService.Application/Models/Auth/AuthTokenResponse.cs` (thay `KeycloakTokenResponse`):

```csharp
namespace SystemService.Application.Models.Auth;

public class AuthTokenResponse
{
    public string AccessToken { get; set; } = string.Empty;
    public int ExpiresIn { get; set; }
    public Guid UserId { get; set; }
    public string? UserName { get; set; }
    public string? FullName { get; set; }
    public Guid? DonViId { get; set; }
    public int LinhVuQuanLy { get; set; }
    public bool IsSuperAdmin { get; set; }
    public List<string> Roles { get; set; } = [];
    public List<string> Permissions { get; set; } = [];
}
```

---

### Bước 11 — Dịch vụ phát hành JWT & cấu hình validate

**11a. Tạo interface `ITokenService`** — `SystemService/SystemService.Application/Services/ITokenService.cs`:

```csharp
using SystemService.Domain.Entities.Users;

namespace SystemService.Application.Services;

public record TokenResult(string AccessToken, int ExpiresIn);

public interface ITokenService
{
    Task<TokenResult> CreateTokenAsync(ApplicationUser user, CancellationToken cancellationToken = default);
}
```

**11b. Tạo `JwtTokenService`** — `SystemService/SystemService.Infrastructure/Services/JwtTokenService.cs`:

```csharp
using System.IdentityModel.Tokens.Jwt;
using System.Security.Claims;
using System.Text;
using Microsoft.AspNetCore.Identity;
using Microsoft.Extensions.Options;
using Microsoft.IdentityModel.Tokens;
using Shared.Security;
using Shared.Security.Constants;
using SystemService.Application.Services;
using SystemService.Domain.Entities.Users;

namespace SystemService.Infrastructure.Services;

public class JwtTokenService : ITokenService
{
    private readonly JwtSettings _jwtSettings;
    private readonly UserManager<ApplicationUser> _userManager;

    public JwtTokenService(IOptions<JwtSettings> jwtSettings, UserManager<ApplicationUser> userManager)
    {
        _jwtSettings = jwtSettings.Value;
        _userManager = userManager;
    }

    public async Task<TokenResult> CreateTokenAsync(ApplicationUser user, CancellationToken cancellationToken = default)
    {
        var securityKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(_jwtSettings.SecretKey));
        var credentials = new SigningCredentials(securityKey, SecurityAlgorithms.HmacSha256);

        var roles = await _userManager.GetRolesAsync(user);

        var claims = new List<Claim>
        {
            new(JwtRegisteredClaimNames.Sub, user.Id.ToString()),
            new(JwtRegisteredClaimNames.UniqueName, user.UserName ?? string.Empty),
            new(CustomClaimTypes.UserId, user.Id.ToString()),
            new(CustomClaimTypes.UserName, user.UserName ?? string.Empty),
            new(CustomClaimTypes.FullName, user.FullName ?? string.Empty),
            new(CustomClaimTypes.IsSuperAdmin, user.IsSuperAdmin ? "true" : "false"),
        };
        claims.AddRange(roles.Select(role => new Claim(ClaimTypes.Role, role)));

        var token = new JwtSecurityToken(
            issuer: _jwtSettings.Issuer,
            audience: _jwtSettings.Audience,
            claims: claims,
            notBefore: DateTime.UtcNow,
            expires: DateTime.UtcNow.AddMinutes(60),
            signingCredentials: credentials);

        return new TokenResult(
            new JwtSecurityTokenHandler().WriteToken(token),
            expiresIn: 3600);
    }
}
```

**11c. Cấu hình `JwtSettings`** — `appsettings.Development.json` (và `appsettings.json`): `SecretKey` hiện đang rỗng, **bắt buộc đặt** chuỗi khóa đối xứng ≥ 32 ký tự:

```json
"JwtSettings": {
  "Issuer": "TT3_SystemService",
  "Audience": "TT3_Client",
  "SecretKey": "Doi-Thu-Khoa-Bi-Mat-IT-Nhat-32-Ky-Tu-123456",
  "AccessTokenLifetimeMinutes": 60
}
```

> Bỏ section `"Keycloak"` khỏi các file cấu hình.

**11d. Sửa validate JWT** — `Shared/Shared.Security/JwtAuthenticationExtensions.cs`: bỏ toàn bộ logic OIDC/Keycloak (`Authority`, `MetadataAddress`, `JwksUri`, `BackchannelHttpHandler`, khối `ExtractRolesFromPrincipal` từ `resource_access`), chuyển sang validate bằng symmetric key:

```csharp
services.AddAuthentication(options =>
    {
        options.DefaultAuthenticateScheme = JwtBearerDefaults.AuthenticationScheme;
        options.DefaultChallengeScheme = JwtBearerDefaults.AuthenticationScheme;
    })
    .AddJwtBearer(options =>
    {
        options.TokenValidationParameters = new TokenValidationParameters
        {
            ValidateIssuer = true,
            ValidIssuer = jwtSettings.Issuer,
            ValidateAudience = true,
            ValidAudience = jwtSettings.Audience,
            ValidateLifetime = true,
            ValidateIssuerSigningKey = true,
            IssuerSigningKey = new SymmetricSecurityKey(Encoding.UTF8.GetBytes(jwtSettings.SecretKey)),
            NameClaimType = JwtRegisteredClaimNames.UniqueName,
            RoleClaimType = ClaimTypes.Role,
        };
    });
```

> **Xóa** khối `OnTokenValidated` (đang đọc `resource_access` của Keycloak và gọi `IJwtClaimsEnricher`) — JWT nội bộ đã chứa sẵn `user_id`, `is_super_admin`, roles.

**11e. Gỡ enricher** — xóa file `Shared.Security/Authorization/UserPermissionsJwtClaimsEnricher.cs` (hoặc giữ interface `IJwtClaimsEnricher` nếu các service khác cần, nhưng bỏ registration trong `AuthorizationExtensions.cs`):

```csharp
// Shared.Security/Authorization/AuthorizationExtensions.cs
// ❌ XÓA khối:
// services.TryAddEnumerable(
//     ServiceDescriptor.Scoped<IJwtClaimsEnricher, UserPermissionsJwtClaimsEnricher>());
```

---

### Bước 12 — Implement `IPermissionSyncService` (đồng bộ quyền, không Keycloak)

**12a. Cắt bớt interface** — `SystemService/SystemService.Application/Services/IPermissionSyncService.cs`: xóa các method Keycloak (`SyncRolesFromKeycloakAsync`, `SyncPermissionsFromKeycloakAsync`) và các comment nhắc Keycloak.

**12b. Tạo implementation** — `SystemService/SystemService.Infrastructure/Services/PermissionSyncService.cs`:

```csharp
using System.ComponentModel;
using System.Reflection;
using Microsoft.AspNetCore.Identity;
using Microsoft.Extensions.Logging;
using Shared.Security.Permissions;
using SystemService.Application.Services;
using SystemService.Domain;
using SystemService.Domain.Entities.Authorization;
using SystemService.Domain.Repositories;

namespace SystemService.Infrastructure.Services;

public class PermissionSyncService : IPermissionSyncService
{
    private readonly RoleManager<Role> _roleManager;
    private readonly IPermissionRepository _permissionRepository;
    private readonly IRolePermissionRepository _rolePermissionRepository;
    private readonly IUnitOfWork _unitOfWork;
    private readonly ILogger<PermissionSyncService> _logger;

    public PermissionSyncService(
        RoleManager<Role> roleManager,
        IPermissionRepository permissionRepository,
        IRolePermissionRepository rolePermissionRepository,
        IUnitOfWork unitOfWork,
        ILogger<PermissionSyncService> logger)
    {
        _roleManager = roleManager;
        _permissionRepository = permissionRepository;
        _rolePermissionRepository = rolePermissionRepository;
        _unitOfWork = unitOfWork;
        _logger = logger;
    }

    public async Task<Role> CreateRoleAsync(string name, string? description = null, CancellationToken cancellationToken = default)
    {
        var role = new Role { Id = Guid.NewGuid(), Name = name, Description = description ?? string.Empty, IsActive = true };
        var result = await _roleManager.CreateAsync(role);
        if (!result.Succeeded)
            throw new InvalidOperationException(
                $"Không thể tạo role {name}: {string.Join(", ", result.Errors.Select(e => e.Description))}");
        return role;
    }

    public async Task<Role?> GetRoleByNameAsync(string name, CancellationToken cancellationToken = default)
        => await _roleManager.FindByNameAsync(name);

    public async Task<Role> UpdateRoleAsync(Guid id, string name, string? description = null, CancellationToken cancellationToken = default)
    {
        var role = await _roleManager.FindByIdAsync(id.ToString())
                   ?? throw new InvalidOperationException($"Role {id} không tồn tại.");
        role.Name = name;
        role.Description = description ?? role.Description;
        var result = await _roleManager.UpdateAsync(role);
        if (!result.Succeeded)
            throw new InvalidOperationException("Không thể cập nhật role.");
        return role;
    }

    public async Task<Role> UpdateRoleWithPermissionsAsync(Guid id, string name, string? description, List<string>? permissions, string originalName, CancellationToken cancellationToken = default)
    {
        var role = await UpdateRoleAsync(id, name, description, cancellationToken);
        if (permissions != null)
            await AssignPermissionsToRoleByNamesAsync(role.Id, permissions, cancellationToken);
        return role;
    }

    public async Task DeleteRoleAsync(Guid id, CancellationToken cancellationToken = default)
    {
        var role = await _roleManager.FindByIdAsync(id.ToString());
        if (role == null) return;
        await _rolePermissionRepository.DeleteByRoleIdAsync(id, cancellationToken);
        await _roleManager.DeleteAsync(role);
    }

    public async Task DeleteRoleByNameAsync(string name, CancellationToken cancellationToken = default)
    {
        var role = await _roleManager.FindByNameAsync(name);
        if (role != null)
            await DeleteRoleAsync(role.Id, cancellationToken);
    }

    public async Task AssignPermissionsToRoleAsync(Guid roleId, IEnumerable<Guid> permissionIds, CancellationToken cancellationToken = default)
    {
        await _rolePermissionRepository.AssignPermissionsAsync(roleId, permissionIds, cancellationToken);
        await _unitOfWork.SaveChangesAsync(cancellationToken);
    }

    public async Task AssignPermissionsToRoleByNamesAsync(Guid roleId, IEnumerable<string> permissionNames, CancellationToken cancellationToken = default)
    {
        var permissions = await _permissionRepository.GetByNamesAsync(permissionNames, cancellationToken);
        await AssignPermissionsToRoleAsync(roleId, permissions.Select(p => p.Id), cancellationToken);
    }

    public async Task RemoveAllPermissionsFromRoleAsync(Guid roleId, CancellationToken cancellationToken = default)
    {
        await _rolePermissionRepository.DeleteByRoleIdAsync(roleId, cancellationToken);
        await _unitOfWork.SaveChangesAsync(cancellationToken);
    }

    public async Task SyncPermissionsFromCodeAsync(CancellationToken cancellationToken = default)
    {
        var fromCode = PermissionReflectionHelper.GetAll();
        var existing = await _permissionRepository.GetAllActiveAsync(cancellationToken);

        foreach (var seed in fromCode)
        {
            if (existing.Any(p => p.Name == seed.Name)) continue;

            await _permissionRepository.InsertAsync(new Permission
            {
                Id = Guid.NewGuid(),
                Name = seed.Name,
                Description = seed.Description,
                GroupPath = seed.GroupPath,   // "|" làm separator, khớp GetPermissionsAsTreeFromDbQuery
                IsActive = true
            });
        }

        await _unitOfWork.SaveChangesAsync(cancellationToken);
        _logger.LogInformation("Đồng bộ xong {Count} permission từ code vào DB.", fromCode.Count);
    }

    public async Task InitializeAsync(CancellationToken cancellationToken = default)
        => await SyncPermissionsFromCodeAsync(cancellationToken);

    public async Task<IList<Permission>> GetPermissionsByRoleIdAsync(Guid roleId, CancellationToken cancellationToken = default)
        => await _rolePermissionRepository.GetPermissionsByRoleIdAsync(roleId, cancellationToken);

    public async Task<IList<Permission>> GetPermissionsByNamesAsync(IEnumerable<string> names, CancellationToken cancellationToken = default)
        => await _permissionRepository.GetByNamesAsync(names, cancellationToken);
}
```

> Ghi chú: `PermissionSyncService` implement `IPermissionRepository.InsertAsync` — trong interface mới (Bước 8b) cần giữ các method CRUD cần thiết (`InsertAsync`, `SaveChangesAsync` qua `IUnitOfWork`). Điều chỉnh interface `IPermissionRepository` cho phù hợp (thêm `Task InsertAsync(Permission entity)`).

**12c. Helper reflection** — `SystemService/SystemService.Infrastructure/Services/PermissionReflectionHelper.cs`:

```csharp
public sealed record PermissionSeed(string Name, string Description, string GroupPath);

public static class PermissionReflectionHelper
{
    public static List<PermissionSeed> GetAll()
    {
        var result = new List<PermissionSeed>();
        foreach (var group in typeof(TcdtPermissions).GetNestedTypes())
            Walk(group, parentPath: null, result);
        return result;
    }

    private static void Walk(Type type, string? parentPath, List<PermissionSeed> result)
    {
        var groupName = type.GetCustomAttribute<DescriptionAttribute>()?.Description ?? type.Name;
        var groupPath = parentPath is null ? groupName : $"{parentPath}|{groupName}";

        foreach (var child in type.GetNestedTypes().Where(t => t.IsClass))
            Walk(child, groupPath, result);

        foreach (var field in type
                     .GetFields(BindingFlags.Public | BindingFlags.Static)
                     .Where(f => f.IsLiteral && f.FieldType == typeof(string)))
        {
            var name = (string?)field.GetValue(null);
            if (string.IsNullOrEmpty(name)) continue;

            var description = field.GetCustomAttribute<DescriptionAttribute>()?.Description ?? field.Name;
            result.Add(new PermissionSeed(name, description, groupPath));
        }
    }
}
```

---

### Bước 13 — Seeder dữ liệu khởi tạo

**File:** `SystemService/SystemService.Infrastructure/Persistence/SeedData/ApplicationDbSeeder.cs`

```csharp
using Microsoft.AspNetCore.Identity;
using Microsoft.Extensions.Logging;
using SystemService.Application.Services;
using SystemService.Domain.Entities.Users;

namespace SystemService.Infrastructure.Persistence.SeedData;

public class ApplicationDbSeeder
{
    private readonly UserManager<ApplicationUser> _userManager;
    private readonly RoleManager<Role> _roleManager;
    private readonly IPermissionSyncService _permissionSyncService;
    private readonly ILogger<ApplicationDbSeeder> _logger;

    public ApplicationDbSeeder(
        UserManager<ApplicationUser> userManager,
        RoleManager<Role> roleManager,
        IPermissionSyncService permissionSyncService,
        ILogger<ApplicationDbSeeder> logger)
    {
        _userManager = userManager;
        _roleManager = roleManager;
        _permissionSyncService = permissionSyncService;
        _logger = logger;
    }

    public async Task SeedDatabaseAsync(CancellationToken cancellationToken = default)
    {
        // 1. Đồng bộ toàn bộ permission từ TcdtPermissions vào bảng Permissions
        await _permissionSyncService.SyncPermissionsFromCodeAsync(cancellationToken);

        // 2. Role SuperAdmin + gán toàn bộ quyền
        const string superAdminRoleName = "SuperAdmin";
        if (await _roleManager.FindByNameAsync(superAdminRoleName) is null)
        {
            var role = await _permissionSyncService.CreateRoleAsync(superAdminRoleName, "Quản trị hệ thống", cancellationToken);
            var allPermissions = await _permissionSyncService.GetPermissionsByNamesAsync(
                PermissionReflectionHelper.GetAll().Select(p => p.Name), cancellationToken);
            await _permissionSyncService.AssignPermissionsToRoleAsync(role.Id, allPermissions.Select(p => p.Id), cancellationToken);
            _logger.LogInformation("Đã tạo role {Role} và gán toàn bộ quyền.", superAdminRoleName);
        }

        // 3. User admin mặc định (tạo bằng Identity kèm password)
        const string adminUserName = "admin";
        if (await _userManager.FindByNameAsync(adminUserName) is null)
        {
            var admin = new ApplicationUser
            {
                Id = Guid.NewGuid(),
                UserName = adminUserName,
                Email = "admin@btc.vn",
                FullName = "Administrator",
                IsSuperAdmin = true,
                IsDelete = false
            };

            var createResult = await _userManager.CreateAsync(admin, "Ab@123456");
            if (!createResult.Succeeded)
                throw new InvalidOperationException(
                    $"Không thể tạo user {adminUserName}: {string.Join(", ", createResult.Errors.Select(e => e.Description))}");

            await _userManager.AddToRoleAsync(admin, superAdminRoleName);
            _logger.LogInformation("Đã tạo user {User}.", adminUserName);
        }
    }
}
```

Đăng ký seeder (scoped) trong `AddInfrastructureServices`:

```csharp
services.AddScoped<ApplicationDbSeeder>();
```

Bỏ comment khối seed trong `SystemService.Api/Program.cs` (dòng 130-145) và sửa lại:

```csharp
using (var scope = app.Services.CreateScope())
{
    var seeder = scope.ServiceProvider.GetRequiredService<ApplicationDbSeeder>();
    await seeder.SeedDatabaseAsync();
}
```

---

### Bước 14 — Cập nhật tạo user (`CreateUserCommand`)

**File:** `SystemService/SystemService.Application/Features/Users/Commands/CreateUserCommand.cs`

Thay toàn bộ luồng Keycloak (`IKeycloakAdminClient`) bằng `UserManager` — user được tạo với **password do người dùng nhập**:

```csharp
public record CreateUserCommand(UserCreateModel Model) : IRequest<Guid>;

public class CreateUserCommandHandler : IRequestHandler<CreateUserCommand, Guid>
{
    private readonly UserManager<ApplicationUser> _userManager;
    private readonly IRoleRepository _roleRepository;
    private readonly IUserPermissionCacheService _userPermissionCacheService;
    private readonly IMapper _mapper;

    // constructor ...

    public async Task<Guid> Handle(CreateUserCommand request, CancellationToken cancellationToken)
    {
        // 1. Tạo user local bằng Identity (password bắt buộc)
        var user = request.Model.ToEntity<ApplicationUser>(_mapper);
        user.Id = Guid.NewGuid();
        user.IsDelete = false;

        var createResult = await _userManager.CreateAsync(user, request.Model.Password);
        if (!createResult.Succeeded)
            throw new BadRequestException(
                string.Join("; ", createResult.Errors.Select(e => e.Description)));

        // 2. Gán role
        if (request.Model.Roles.Any())
        {
            var roleIds = request.Model.Roles
                .Select(roleId => Guid.Parse(roleId)).Distinct().ToList();
            var roles = await _roleRepository.GetByIdsAsync(roleIds, cancellationToken);
            await _userManager.AddToRolesAsync(user, roles.Select(r => r.Name!));
        }

        return user.Id;
    }
}
```

> `CreateKeycloakUserForImportedUserCommand`, `CreateAllKeycloakUserForImportedCommand` và endpoint `create-keycloak*` trong `UsersController` → **xóa**.

---

### Bước 15 — Xóa tham chiếu còn sót

Tìm toàn bộ project các chỗ còn dùng `Keycloak` hoặc `ApplicationUserRole`:

```bash
grep -rn "Keycloak" --include="*.cs" .
grep -rn "ApplicationUserRole" --include="*.cs" .
```

Các nơi chắc chắn có: `ApplicationUser.cs`, `Role.cs`, `Permission.cs`, `SystemDbContext.cs`, `IAuthorizationRepositories.cs`, `AuthorizationRepositories.cs`, các config, `CreateUserCommand.cs`, `AuthController.cs` (`ExchangeToken`, `Logout`), `UsersController.cs` (`create-keycloak*`). Sau khi cập nhật xong, build lại theo mục Kiểm thử.

---

## 6. Migration cơ sở dữ liệu

Hiện project **chưa có thư mục `Migrations`** — đây là migration đầu tiên. Chạy từ thư mục giải pháp:

```bash
dotnet ef migrations add AddIdentityAspNet \
  --project SystemService/SystemService.Infrastructure \
  --startup-project SystemService/SystemService.Api \
  --output-dir Persistence/Migrations
dotnet ef database update \
  --project SystemService/SystemService.Infrastructure \
  --startup-project SystemService/SystemService.Api
```

> **Cảnh báo quan trọng:** `SystemDbContext.ConfigureConventions` hiện đang set column type Oracle (`NUMBER(1)`, `NUMBER(20,4)`, `BINARY_DOUBLE`, `BINARY_FLOAT`) trong khi provider là **SQL Server** (`UseSqlServer`). Migration sẽ sinh các cột `NUMBER(...)` → **SQL Server không chấp nhận** khi `database update`. Trước khi tạo migration, cần xử lý 1 trong 2:
> - (a) Gỡ khối quy ước Oracle nếu hệ thống đã chuyển hẳn sang SQL Server; hoặc
> - (b) Giữ quy ước nhưng tự kiểm tra/sửa SQL sinh ra trong file migration.

### 6.1. Đối chiếu dữ liệu cũ (bảng hiện có)

| Bảng cũ | Bảng mới (Identity) | Thay đổi |
|---|---|---|
| `ApplicationUser` | `ApplicationUser` (giữ tên) | Thêm `NormalizedUserName`, `PasswordHash`, `SecurityStamp`, `ConcurrencyStamp`, `PhoneNumber`, `LockoutEnabled`, `TwoFactorEnabled`...; **bỏ `KeycloakId`** |
| `Roles` | `Roles` (giữ tên) | Thêm `NormalizedName`, `ConcurrencyStamp`; **bỏ `KeycloakId`** |
| `ApplicationUserRole` (PK surrogate `Id`) | `AspNetUserRoles` hoặc `ApplicationUserRole` (PK composite) | Bỏ cột `Id`; thêm PK composite |
| `Permissions` | `Permissions` | **Bỏ cột `KeycloakId`** |

Nếu DB đã có dữ liệu, cần **backfill** — ví dụ cho `ApplicationUser`:

```sql
UPDATE dbo.ApplicationUser SET NormalizedUserName = UPPER(UserName)
WHERE NormalizedUserName IS NULL OR NormalizedUserName = '';

UPDATE dbo.ApplicationUser SET NormalizedEmail = UPPER(Email)
WHERE NormalizedEmail IS NULL AND Email IS NOT NULL;

UPDATE dbo.ApplicationUser SET
    SecurityStamp = NEWID(),
    ConcurrencyStamp = NEWID()
WHERE SecurityStamp IS NULL OR ConcurrencyStamp IS NULL;
```

Và chuyển dữ liệu liên kết user–role từ bảng cũ sang bảng mới:

```sql
INSERT INTO AspNetUserRoles (UserId, RoleId)
SELECT ur.UserId, ur.RoleId
FROM ApplicationUserRole ur;        -- (bảng cũ)
```

> Password cũ (nếu có lưu) không dùng được — user phải được tạo lại qua `UserManager.CreateAsync(user, password)` (Seeder tạo user `admin` với password mặc định).

---

## 7. Danh sách file bị ảnh hưởng

| File | Hành động |
|---|---|
| `SystemService/SystemService.Infrastructure/SystemService.Infrastructure.csproj` | Thêm `Microsoft.AspNetCore.Identity.EntityFrameworkCore` 8.0.30, `System.IdentityModel.Tokens.Jwt` |
| `SystemService/SystemService.Application/SystemService.Application.csproj` | (Tùy chọn) thêm `Microsoft.Extensions.Identity.Core` |
| `SystemService.Domain/Entities/Users/ApplicationUser.cs` | Kế thừa `IdentityUser<Guid>`; xóa `UserName`/`Email`/`KeycloakId`; đổi `UserRoles` |
| `SystemService.Domain/Entities/Authorization/Role.cs` | Kế thừa `IdentityRole<Guid>`; xóa `Name`/`KeycloakId`; đổi `UserRoles` |
| `SystemService.Domain/Entities/Authorization/Permission.cs` | Bỏ `KeycloakId` |
| `SystemService.Domain/Entities/Authorization/ApplicationUserRole.cs` | **Xóa** |
| `SystemService.Infrastructure/Persistence/SystemDbContext.cs` | Kế thừa `IdentityDbContext<ApplicationUser, Role, Guid>`; xóa DbSet trùng |
| `Persistence/Configurations/ApplicationUserConfiguration.cs` | Bỏ map UserName/Email/KeycloakId |
| `Persistence/Configurations/Authorization/RoleConfiguration.cs` | Bỏ KeycloakId |
| `Persistence/Configurations/Authorization/PermissionConfiguration.cs` | Bỏ KeycloakId |
| `Persistence/Configurations/Authorization/ApplicationUserRoleConfiguration.cs` | Đổi sang `IdentityUserRole<Guid>` |
| `SystemService.Domain/Repositories/IUserRepository.cs` | Bỏ `IRepository<,>` |
| `SystemService.Domain/Repositories/IAuthorizationRepositories.cs` | Tách khỏi `IRepository<,>`; bỏ `GetByKeycloakIdAsync` |
| `SystemService.Infrastructure/Repositories/UserRepository.cs` | Implement trực tiếp trên `SystemDbContext` |
| `SystemService.Infrastructure/Repositories/AuthorizationRepositories.cs` | Viết lại; bỏ phần Keycloak |
| `SystemService.Infrastructure/DependencyInjection.cs` | Đăng ký `AddIdentityCore`, `ITokenService`, `IPermissionSyncService`, seeder; **gỡ Keycloak DI** |
| `SystemService.Infrastructure/Services/JwtTokenService.cs` | **Tạo mới** |
| `SystemService.Infrastructure/Services/PermissionSyncService.cs` | **Tạo mới** |
| `SystemService.Infrastructure/Services/PermissionReflectionHelper.cs` | **Tạo mới** |
| `SystemService.Infrastructure/Services/PermissionQueryService.cs` | **Tạo mới** (fallback theo userId, tùy chọn) |
| `SystemService.Infrastructure/Services/KeycloakAuthenticationService.cs` | **Xóa** |
| `SystemService.Infrastructure/Services/KeycloakSettingsProvider.cs`, `Settings/KeycloakSettings.cs` | **Xóa** |
| `SystemService.Infrastructure/Keycloak/` | **Xóa** |
| `SystemService.Application/Services/IKeycloakAdminClient.cs`, `IAuthenticationService`, `IKeycloakSettingsProvider.cs` | **Xóa** (hoặc gỡ khỏi DI) |
| `SystemService.Application/Services/ITokenService.cs` | **Tạo mới** |
| `SystemService.Application/Services/IPermissionSyncService.cs` | Cắt bỏ method Keycloak |
| `Shared/Shared.Security/JwtAuthenticationExtensions.cs` | Bỏ OIDC, validate symmetric key |
| `Shared/Shared.Security/Authorization/AuthorizationExtensions.cs` | Bỏ đăng ký enricher stub |
| `Shared/Shared.Security/Authorization/UserPermissionsJwtClaimsEnricher.cs` | **Xóa** |
| `SystemService.Application/Features/Auth/Commands/LoginCommand.cs` | Viết lại: `UserManager.CheckPasswordAsync` + `JwtTokenService` |
| `SystemService.Application/Features/Auth/Commands/ExchangeTokenCommand.cs`, `LogoutCommand.cs`, `LogoutSidCommand.cs`, `LogoutSidValidator.cs` | **Xóa** |
| `SystemService.Application/Models/Auth/KeycloakTokenResponse.cs` | Thay bằng `AuthTokenResponse` |
| `SystemService.Application/Models/Auth/AuthTokenResponse.cs` | **Tạo mới** |
| `SystemService.Api/Controllers/AuthController.cs` | Chỉ giữ `login`; xóa `token`/`refresh`(Keycloak)/`logout`(sid) |
| `SystemService.Application/Features/Users/Commands/CreateUserCommand.cs` | Dùng `UserManager.CreateAsync(user, password)` |
| `SystemService.Application/Features/Users/Commands/CreateKeycloakUserForImportedUserCommand.cs`, `CreateAllKeycloakUserForImportedCommand.cs` | **Xóa** |
| `SystemService.Application/Features/Users/Commands/ChangePassword*.cs` | Viết lại bằng `UserManager.ChangePasswordAsync` / `ResetPasswordAsync` |
| `SystemService.Api/Controllers/UsersController.cs` | Xóa endpoint `create-keycloak*` |
| `SystemService.Infrastructure/Persistence/SeedData/ApplicationDbSeeder.cs` | Seed bằng `UserManager`/`RoleManager` |
| `SystemService.Api/Program.cs` | Bỏ comment khối seed; dùng `ApplicationDbSeeder` |
| `appsettings.json`, `appsettings.Development.json` | Đặt `JwtSettings.SecretKey`; **bỏ section `Keycloak`** |

> Sau khi sửa, **build toàn bộ giải pháp** và sửa các lỗi biên dịch phát sinh từ các chỗ gọi `IRepository` chung trên `ApplicationUser`/`Role` mà tài liệu chưa liệt kê hết (tìm theo kiểu `IRepository<ApplicationUser, Guid>`, `IRepository<Role, Guid>`, hoặc `IKeycloakAdminClient`, `IAuthenticationService`).

---

## 8. Kiểm thử

1. **Build:** `dotnet build TT3_MobileBE.sln` → 0 lỗi.
2. **Migration:** `dotnet ef database update` thành công (xử lý quy ước Oracle trước).
3. **Seed:** chạy API → user `admin`/`Ab@123456`, role `SuperAdmin`, toàn bộ permissions trong bảng `Permissions` được tạo.
4. **Login bằng username + password:**
   - `POST /api/quan-ly-he-thong/auth/login` `{ "userName": "admin", "password": "Ab@123456" }` → trả `accessToken`, `userId`, `roles`, `permissions`, `isSuperAdmin`.
   - Sai mật khẩu → 401; đúng mật khẩu → Redis có key `permissions:user:<userId>`.
5. **Phân quyền:**
   - Gọi endpoint có `[RequiredPermission(TcdtPermissions.QuanLyHeThong.QuanLyNguoiDung.Edit)]` (vd `PUT /api/quan-ly-he-thong/users/{id}/change-status/{id}`) với user **có** quyền → 200; user **không** có quyền → 403.
   - User `IsSuperAdmin = true` → luôn 200 (policy `SuperAdmin`).
6. **Gán role / đổi quyền:**
   - `RolesController` CRUD role hoạt động; sau khi gán permission cho role, cache Redis của các user thuộc role phải bị xóa (đặt lại) để quyền mới có hiệu lực.
7. **Đổi mật khẩu:** `UserManager.ChangePasswordAsync` hoạt động; mật khẩu cũ không còn dùng được.

---

## 9. Lưu ý & các lỗi thường gặp

1. **Đừng dùng `AddIdentity()`** — nó đăng ký cookie scheme làm default, xung đột với JWT Bearer. Dùng `AddIdentityCore`.
2. **Ràng buộc `where TEntity : BaseEntity<TKey>`** — mọi entity chuyển sang Identity đều không dùng được `IRepository<,>`/`EfRepository<,>`. Phải implement trực tiếp trên `SystemDbContext` hoặc qua `UserManager`/`RoleManager`.
3. **Thứ tự `OnModelCreating`** — giữ `base.OnModelCreating(...)` TRƯỚC `ApplyConfigurationsFromAssembly(...)` để cấu hình `ToTable("Roles")`… ghi đè tên bảng mặc định của Identity.
4. **Quy ước column Oracle vs provider SQL Server** — bắt buộc xử lý trước khi migration (xem mục 6).
5. **`JwtSettings.SecretKey` hiện đang rỗng** — phải đặt khóa đối xứng ≥ 32 ký tự, đồng bộ giữa nơi phát hành (`JwtTokenService`) và nơi validate (`AddJwtBearer`).
6. **Chính sách password/lockout** — vì password là xác thực thật, hãy bật `RequireDigit`/`RequireUpper`/`RequiredLength >= 8` và `Lockout.MaxFailedAccessAttempts`. Password mặc định seeder `Ab@123456` phải thỏa mãn chính sách.
7. **Cache Redis (TTL 720 phút)** — khi đổi role/permission/status của user, phải gọi `RemovePermissionsAsync(userId)` để cache không phục vụ quyền cũ.
8. **Các service khác dùng `Shared.Security`** — nếu đổi `AddJwtAuthentication` sang validate symmetric key, mọi service khác cũng phải dùng cùng `SecretKey` để validate token do `SystemService` phát hành.
9. **Khóa chính `IdentityUserRole<Guid>` là composite** — không được thêm cột `Id` tự tăng nếu muốn `UserStore` hoạt động.
10. **Đổi mật khẩu** — dùng `UserManager.ChangePasswordAsync` (user tự đổi) hoặc `ResetPasswordAsync` (admin reset); **không** thao tác trực tiếp vào `PasswordHash`.

---

## 10. Phụ lục: mã nguồn mẫu đầy đủ

### 10.1. `IPermissionQueryService` (fallback DB cho handler — theo userId)

`Shared/Shared.Security/Authorization/IPermissionQueryService.cs`:

```csharp
namespace Shared.Security.Authorization;

/// <summary>
/// Truy vấn danh sách permission theo userId — implement ở tầng Infrastructure
/// (Shared.Security không được tham chiếu SystemService.Domain).
/// </summary>
public interface IPermissionQueryService
{
    Task<IReadOnlyCollection<string>> GetPermissionNamesByUserIdAsync(
        Guid userId,
        CancellationToken cancellationToken = default);
}
```

`SystemService/SystemService.Infrastructure/Services/PermissionQueryService.cs`:

```csharp
using SystemService.Domain.Repositories;
using Shared.Security.Authorization;

namespace SystemService.Infrastructure.Services;

public class PermissionQueryService : IPermissionQueryService
{
    private readonly IApplicationUserRoleRepository _userRoleRepository;
    private readonly IRolePermissionRepository _rolePermissionRepository;

    public PermissionQueryService(
        IApplicationUserRoleRepository userRoleRepository,
        IRolePermissionRepository rolePermissionRepository)
    {
        _userRoleRepository = userRoleRepository;
        _rolePermissionRepository = rolePermissionRepository;
    }

    public async Task<IReadOnlyCollection<string>> GetPermissionNamesByUserIdAsync(
        Guid userId,
        CancellationToken cancellationToken = default)
    {
        var permissions = new HashSet<string>(StringComparer.OrdinalIgnoreCase);
        var roles = await _userRoleRepository.GetRolesByUserIdAsync(userId, cancellationToken);

        foreach (var role in roles)
        {
            var rolePermissions = await _rolePermissionRepository
                .GetPermissionsByRoleIdAsync(role.Id, cancellationToken);

            foreach (var permission in rolePermissions)
                if (!string.IsNullOrWhiteSpace(permission.Name))
                    permissions.Add(permission.Name);
        }

        return permissions;
    }
}
```

Đăng ký trong `AddInfrastructureServices`:

```csharp
services.AddScoped<IPermissionQueryService, PermissionQueryService>();
```

Sửa `PermissionAuthorizationHandler.LoadPermissionsFromGrpcFallbackAsync` để gọi theo `userId` (claim `user_id` đã có trong JWT nội bộ):

```csharp
private async Task<IReadOnlyCollection<string>> LoadPermissionsFromFallbackAsync(
    AuthorizationHandlerContext context,
    PermissionRequirement requirement,
    Guid localUserId,
    bool hasLocalUserId,
    string path,
    CancellationToken cancellationToken)
{
    if (!hasLocalUserId)
        return null;

    var queryService = context.HttpContext?.RequestServices
        .GetRequiredService<IPermissionQueryService>();
    if (queryService is null)
        return null;

    return await queryService.GetPermissionNamesByUserIdAsync(localUserId, cancellationToken);
}
```

### 10.2. Tóm tắt package cần thêm

| Project | Package | Version |
|---|---|---|
| SystemService.Infrastructure | `Microsoft.AspNetCore.Identity.EntityFrameworkCore` | 8.0.30 |
| SystemService.Infrastructure | `System.IdentityModel.Tokens.Jwt` | 8.0.0 |
| SystemService.Application (tùy chọn) | `Microsoft.Extensions.Identity.Core` | 8.0.30 |

---

*Tài liệu được viết dựa trên trạng thái mã nguồn hiện tại của `TT3_MobileBE` (24 file liên quan trực tiếp đã được khảo sát). Phiên bản này thay thế toàn bộ cơ chế Keycloak bằng ASP.NET Identity thuần (đăng nhập username + password, JWT phát hành nội bộ).*
