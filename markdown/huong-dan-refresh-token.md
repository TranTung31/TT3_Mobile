# Hướng dẫn triển khai cơ chế Refresh Token cho SystemService (ASP.NET Identity + JWT nội bộ)

> **Mục đích:** Khi **access token** hết hạn (API trả `401 Unauthorized`), client gọi
> `POST /api/quan-ly-he-thong/auth/refresh` với **refresh token** để lấy **access token mới**
> (kèm một refresh token mới — cơ chế *rotation*), không cần bắt người dùng đăng nhập lại.
>
> Lưu ý: đây là tài liệu **hướng dẫn** — bạn **phải tự chỉnh sửa các class** theo hướng dẫn để hiện thực hoá.
> Tài liệu không thay đổi code.

---

## Mục lục

1. [Mục tiêu & phạm vi](#1-mục-tiêu--phạm-vi)
2. [Hiện trạng project](#2-hiện-trạng-project)
3. [Luồng hoạt động](#3-luồng-hoạt-động)
4. [Quyết định thiết kế](#4-quyết-định-thiết-kế)
5. [Triển khai từng bước](#5-triển-khai-từng-bước)
6. [Kiểm thử](#6-kiểm-thử)
7. [Lưu ý & các lỗi thường gặp](#7-lưu-ý--các-lỗi-thường-gặp)
8. [Danh sách file bị ảnh hưởng](#8-danh-sách-file-bị-ảnh-hưởng)
9. [Phụ lục: phương án tối giản bằng `IdentityUserToken`](#9-phụ-lục-phương-án-tối-giản-bằng-identityusertoken)

---

## 1. Mục tiêu & phạm vi

- **Access token** (JWT) có thời gian sống ngắn (mặc định 60 phút) — nếu hết hạn mà không có cơ chế refresh, người dùng bị buộc đăng nhập lại, rất khó chịu với SPA/React.
- **Refresh token** là token dài hạn (7 ngày), **chỉ dùng cho endpoint `/auth/refresh`**, không được đưa vào Authorization header gọi API thường.
- Mỗi lần refresh phải **rotate** (cấp token mới, vô hiệu hoá token cũ) để giảm thiểu rủi ro lộ token.
- Triển khai **thuần Identity + JWT nội bộ**, **không phụ thuộc Keycloak** (phù hợp hướng dẫn trước: `huong-dan-phan-quyen-aspnet-identity.md`).

---

## 2. Hiện trạng project

| Thành phần | File | Trạng thái |
|---|---|---|
| `LoginCommand` | `SystemService.Application/Features/Auth/Commands/LoginCommand.cs` | Đã xác thực bằng `UserManager.CheckPasswordAsync` + phát hành access token bằng `ITokenService`, **nhưng `AuthTokenResponse.RefreshToken` chưa được gán** |
| `AuthTokenResponse` | `SystemService.Application/Models/Auth/AuthTokenResponse.cs` | **Đã có sẵn trường `RefreshToken`** — chỉ cần điền giá trị |
| `RefreshTokenCommand` | `SystemService.Application/Features/Auth/Commands/RefreshTokenCommand.cs` | Vẫn là stub, trả `KeycloakTokenResponse`, dùng `IAuthenticationService` (Keycloak) → **cần viết lại** |
| `JwtTokenService` | `SystemService.Infrastructure/Services/JwtTokenService.cs` | Hardcode `expires = 60 phút`, `ExpiresIn = 3600`; chưa đọc `JwtSettings.ExpirationInMinutes` |
| `JwtSettings` | `Shared/Shared.Security/JwtSettings.cs` | **Đã có sẵn `RefreshTokenExpirationDays`** |
| `appsettings.Development.json` | — | Cấu hình dùng key `AccessTokenLifetimeMinutes` nhưng class `JwtSettings` lại có property `ExpirationInMinutes` → **lệch key**, cần căn chỉnh |
| `AuthController` | `SystemService.Api/Controllers/AuthController.cs` | Đã có endpoint `POST /auth/refresh` nhưng khai báo trả `ApiResponseModel<KeycloakTokenResponse>` |
| `LogoutCommand` / `LogoutSidCommand` | `Features/Auth/Commands/` | Đang gọi `IKeycloakAdminClient` (Keycloak) → nên viết lại để **thu hồi refresh token** ở DB |
| Identity | `IdentityDbContext<ApplicationUser, Role, Guid>` | Đã có bảng `AspNetUserTokens` + `AddDefaultTokenProviders()` trong DI |

> **Tóm tắt:** phần xác thực đã chuyển sang Identity, phần refresh token vẫn còn sót lại code Keycloak. Tài liệu này hướng dẫn bổ sung phần còn thiếu.

---

## 3. Luồng hoạt động

```
[Đăng nhập]
 Client ── POST /auth/login {userName, password} ──▶ SystemService
                                                       │ UserManager.CheckPasswordAsync
                                                       │ sinh accessToken (JWT) + refreshToken
                                                       │ lưu refreshToken (bảng RefreshToken)
        ◀── { accessToken, refreshToken, expiresIn, ... } ──┘

[Sử dụng API]
 Client ── Authorization: Bearer <accessToken> ──▶ API ──▶ 200 OK (access token còn hạn)
 Client ── Authorization: Bearer <accessToken> ──▶ API ──▶ 401 (hết hạn)

[Refresh token]
 Client ── POST /auth/refresh {refreshToken} ──▶ SystemService
                                                  │ tra hash trong bảng RefreshToken
                                                  │ kiểm tra hết hạn / đã thu hồi
                                                  │ UserManager.IsLockedOutAsync
                                                  │ tạo accessToken mới + rotate refreshToken
        ◀── { accessToken mới, refreshToken mới, ... } ──┘

[Logout]
 Client ── POST /auth/logout ──▶ SystemService ──▶ thu hồi (revoke) toàn bộ refresh token của user
```

---

## 4. Quyết định thiết kế

1. **Dùng bảng `RefreshToken` riêng** thay vì bảng `IdentityUserToken`.
   - `IdentityUserToken` **không có cột hết hạn / thu hồi**, và PK là `(UserId, LoginProvider, Name)` nên **mỗi user chỉ giữ được 1 token** (không hỗ trợ đa thiết bị), lại không có index tra theo token.
   - Giống tinh thần hiện tại: `Permission` / `RolePermission` là bảng **tự định nghĩa** nằm cạnh Identity; refresh token cũng vậy — **Identity lo xác thực/roles/permissions, bảng `RefreshToken` chỉ lưu "phiên đăng nhập"**.
2. **Lưu hash SHA-256 của token** trong DB (`TokenHash`), không lưu plaintext — nếu DB bị lộ, token không dùng lại được.
3. **Rotation bắt buộc**: mỗi lần refresh, cấp refresh token mới và **revoke token cũ** (đặt `RevokedAtUtc`). Nếu kẻ gian dùng lại token cũ → bị từ chối (`401`) — vì token cũ đã bị thu hồi, không cần lưu token thay thế.
4. **TTL** đọc từ `JwtSettings.RefreshTokenExpirationDays` (mặc định 7 ngày).
5. **Access token** vẫn do `ITokenService.CreateTokenAsync` phát hành; chỉ sửa để đọc thời gian sống từ cấu hình thay vì hardcode.
6. **Thu hồi khi đổi mật khẩu / logout**: gỡ refresh token để phiên cũ mất hiệu lực.

---

## 5. Triển khai từng bước

### Bước 1 — Căn chỉnh cấu hình JWT

**`Shared/Shared.Security/JwtSettings.cs`** — đã có sẵn:

```csharp
public class JwtSettings
{
    public const string SectionName = "JwtSettings";
    public string? Authority { get; set; }        // (có thể bỏ - thuộc Keycloak)
    public string SecretKey { get; set; } = string.Empty;
    public string Issuer { get; set; } = string.Empty;
    public string Audience { get; set; } = string.Empty;
    public string MetadataAddress { get; set; } = string.Empty;  // (có thể bỏ)
    public string JwksUri { get; set; } = string.Empty;          // (có thể bỏ)
    public int ExpirationInMinutes { get; set; }
    public int RefreshTokenExpirationDays { get; set; }
}
```

**`appsettings.Development.json` / `appsettings.json`** — dùng đúng tên property, thêm `RefreshTokenExpirationDays`:

```json
"JwtSettings": {
  "Issuer": "TT3_SystemService",
  "Audience": "TT3_Client",
  "SecretKey": "Doi-Thu-Khoa-Bi-Mat-IT-Nhat-32-Ky-Tu-123456",
  "ExpirationInMinutes": 60,
  "RefreshTokenExpirationDays": 7
}
```

> ⚠️ Hiện tại config đang ghi `AccessTokenLifetimeMinutes` nhưng class lại là `ExpirationInMinutes` → **đổi sang `ExpirationInMinutes`** cho khớp.

---

### Bước 2 — Sửa `JwtTokenService` đọc thời gian sống từ cấu hình

**`SystemService/SystemService.Infrastructure/Services/JwtTokenService.cs`** — thay 2 chỗ hardcode:

```csharp
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

    // Đọc từ config thay vì hardcode 60
    var lifetimeMinutes = _jwtSettings.ExpirationInMinutes > 0 ? _jwtSettings.ExpirationInMinutes : 60;

    var token = new JwtSecurityToken(
        issuer: _jwtSettings.Issuer,
        audience: _jwtSettings.Audience,
        claims: claims,
        notBefore: DateTime.UtcNow,
        expires: DateTime.UtcNow.AddMinutes(lifetimeMinutes),
        signingCredentials: credentials);

    return new TokenResult(
        new JwtSecurityTokenHandler().WriteToken(token),
        ExpiresIn: lifetimeMinutes * 60);
}
```

---

### Bước 3 — Tạo entity `RefreshToken`

**Tạo `SystemService/SystemService.Domain/Entities/Auth/RefreshToken.cs`:**

```csharp
using SystemService.Domain.Entities.Users;

namespace SystemService.Domain.Entities.Auth;

/// <summary>
/// Refresh token cho JWT — bảng tự định nghĩa (giống Permission/RolePermission),
/// nằm cạnh ASP.NET Identity chứ không phải khái niệm của Identity.
/// </summary>
public class RefreshToken : BaseEntity<Guid>
{
    public Guid UserId { get; set; }
    public virtual ApplicationUser User { get; set; }

    /// <summary>Hash SHA-256 của chuỗi token trả cho client (không lưu plaintext).</summary>
    public string TokenHash { get; set; } = string.Empty;

    public DateTime ExpiresAtUtc { get; set; }

    /// <summary>Thời điểm thu hồi (null = còn hiệu lực).</summary>
    public DateTime? RevokedAtUtc { get; set; }

    public bool IsActive => RevokedAtUtc == null && ExpiresAtUtc > DateTime.UtcNow;
}
```

> `CreatedOnUtc` / `UpdatedOnUtc` đã có sẵn ở `ShadowBaseEntity` (mà `BaseEntity<Guid>` kế thừa) nên không cần khai báo thêm `CreatedAtUtc`.

---

### Bước 4 — EF Configuration + Migration

**Tạo `SystemService/SystemService.Infrastructure/Persistence/Configurations/Auth/RefreshTokenConfiguration.cs`:**

```csharp
using Microsoft.EntityFrameworkCore;
using Microsoft.EntityFrameworkCore.Metadata.Builders;
using SystemService.Domain.Entities.Auth;

namespace SystemService.Infrastructure.Persistence.Configurations.Auth;

public class RefreshTokenConfiguration : IEntityTypeConfiguration<RefreshToken>
{
    public void Configure(EntityTypeBuilder<RefreshToken> builder)
    {
        builder.ToTable("RefreshToken");
        builder.HasKey(x => x.Id);

        builder.Property(x => x.TokenHash).HasMaxLength(128).IsRequired();
        builder.HasIndex(x => x.TokenHash).IsUnique();   // tra cứu nhanh theo hash

        builder.HasOne(x => x.User)
               .WithMany(u => u.RefreshTokens)             // navigation trên ApplicationUser
               .HasForeignKey(x => x.UserId)
               .OnDelete(DeleteBehavior.Cascade);         // xoá user → xoá luôn refresh token
    }
}
```

**Bổ sung navigation trên `ApplicationUser`** (`SystemService.Domain/Entities/Users/ApplicationUser.cs`):

```csharp
using SystemService.Domain.Entities.Auth;

public class ApplicationUser : IdentityUser<Guid>
{
    // ... các property hiện có ...

    public virtual ICollection<RefreshToken> RefreshTokens { get; set; } = new List<RefreshToken>();
}
```

`SystemDbContext.OnModelCreating` đã có `ApplyConfigurationsFromAssembly(...)` nên **không cần sửa gì thêm**.

**Migration** (chạy từ thư mục giải pháp):

```bash
dotnet ef migrations add AddRefreshToken \
  --project SystemService/SystemService.Infrastructure \
  --startup-project SystemService/SystemService.Api \
  --output-dir Persistence/Migrations

dotnet ef database update \
  --project SystemService/SystemService.Infrastructure \
  --startup-project SystemService/SystemService.Api
```

> ✅ Khối quy ước Oracle (`NUMBER(1)`, `BINARY_DOUBLE`...) trong `SystemDbContext.ConfigureConventions` **đã được gỡ** — SQL Server dùng mapping mặc định (bool→`bit`, decimal→`decimal(18,2)`, double→`float`, float→`real`).

---

### Bước 5 — Repository

**Tạo `SystemService/SystemService.Domain/Repositories/IRefreshTokenRepository.cs`:**

```csharp
using SystemService.Domain.Entities.Auth;

namespace SystemService.Domain.Repositories;

public interface IRefreshTokenRepository
{
    Task<RefreshToken?> GetByTokenHashAsync(string tokenHash, CancellationToken cancellationToken = default);

    /// <summary>Danh sách refresh token còn hiệu lực của một user (dùng khi logout).</summary>
    Task<IList<RefreshToken>> GetActiveByUserIdAsync(Guid userId, CancellationToken cancellationToken = default);

    Task InsertAsync(RefreshToken entity, CancellationToken cancellationToken = default);

    /// <summary>Đánh dấu thu hồi (chưa SaveChanges — handler tự gọi IUnitOfWork).</summary>
    void Revoke(RefreshToken entity);

    /// <summary>Xoá token hết hạn (dọn dẹp định kỳ hoặc gọi lúc refresh).</summary>
    Task<int> DeleteExpiredAsync(CancellationToken cancellationToken = default);
}
```

**Tạo `SystemService/SystemService.Infrastructure/Repositories/RefreshTokenRepository.cs`:**

```csharp
using Microsoft.EntityFrameworkCore;
using SystemService.Domain;
using SystemService.Domain.Entities.Auth;
using SystemService.Domain.Repositories;
using SystemService.Infrastructure.Persistence;

namespace SystemService.Infrastructure.Repositories;

public class RefreshTokenRepository : IRefreshTokenRepository
{
    private readonly SystemDbContext _context;

    public RefreshTokenRepository(SystemDbContext context) => _context = context;

    public Task<RefreshToken?> GetByTokenHashAsync(string tokenHash, CancellationToken cancellationToken = default)
        => _context.Set<RefreshToken>().FirstOrDefaultAsync(x => x.TokenHash == tokenHash, cancellationToken);

    public Task<IList<RefreshToken>> GetActiveByUserIdAsync(Guid userId, CancellationToken cancellationToken = default)
        => _context.Set<RefreshToken>()
            .Where(x => x.UserId == userId && x.RevokedAtUtc == null && x.ExpiresAtUtc > DateTime.UtcNow)
            .ToListAsync(cancellationToken);

    public async Task InsertAsync(RefreshToken entity, CancellationToken cancellationToken = default)
        => await _context.Set<RefreshToken>().AddAsync(entity, cancellationToken);

    public void Revoke(RefreshToken entity)
    {
        entity.RevokedAtUtc = DateTime.UtcNow;
    }

    public Task<int> DeleteExpiredAsync(CancellationToken cancellationToken = default)
        => _context.Set<RefreshToken>()
            .Where(x => x.ExpiresAtUtc <= DateTime.UtcNow)
            .ExecuteDeleteAsync(cancellationToken);
}
```

**Đăng ký DI** trong `SystemService/SystemService.Infrastructure/DependencyInjection.cs` (`AddInfrastructureServices`):

```csharp
services.AddScoped<IRefreshTokenRepository, RefreshTokenRepository>();
```

---

### Bước 6 — Helper sinh/hash refresh token

**Tạo `SystemService/SystemService.Application/Services/RefreshTokenHelper.cs`:**

```csharp
using System.Security.Cryptography;
using System.Text;

namespace SystemService.Application.Services;

public static class RefreshTokenHelper
{
    /// <summary>Sinh chuỗi token ngẫu nhiên 64 bytes (đủ mạnh, không đoán được).</summary>
    public static string Generate()
        => Convert.ToBase64String(RandomNumberGenerator.GetBytes(64));

    /// <summary>Hash SHA-256 — chỉ lưu hash vào DB.</summary>
    public static string Hash(string token)
        => Convert.ToHexString(SHA256.HashData(Encoding.UTF8.GetBytes(token)));
}
```

---

### Bước 7 — Sửa `LoginCommand` trả về refresh token

**`SystemService/SystemService.Application/Features/Auth/Commands/LoginCommand.cs`** — thêm `IRefreshTokenRepository` và `IOptions<JwtSettings>` vào constructor, sau bước tạo access token:

```csharp
// 4. Phát hành JWT nội bộ
var token = await _tokenService.CreateTokenAsync(user, cancellationToken);

// 4.1 Sinh + lưu refresh token (bảng RefreshToken)
var refreshTokenValue = RefreshTokenHelper.Generate();
await _refreshTokenRepository.InsertAsync(new RefreshToken
{
    Id = Guid.NewGuid(),
    UserId = user.Id,
    TokenHash = RefreshTokenHelper.Hash(refreshTokenValue),
    ExpiresAtUtc = DateTime.UtcNow.AddDays(_jwtSettings.RefreshTokenExpirationDays),
    CreatedOnUtc = DateTime.UtcNow
}, cancellationToken);
await _unitOfWork.SaveChangesAsync(cancellationToken);

// 5. Load permissions từ DB rồi cache vào Redis
var permissions = await LoadUserPermissionsFromDbAsync(user.Id, cancellationToken);

// 6. Trả về token + thông tin người dùng
return new AuthTokenResponse
{
    AccessToken = token.AccessToken,
    RefreshToken = refreshTokenValue,           // ← điền vào trường đã có sẵn
    ExpiresIn = token.ExpiresIn,
    UserId = user.Id,
    UserName = user.UserName,
    FullName = user.FullName,
    DonViId = user.DonViId,
    IsSuperAdmin = user.IsSuperAdmin,
    Roles = (await _userManager.GetRolesAsync(user)).ToList(),
    Permissions = permissions.ToList()
};
```

Các using cần thêm:

```csharp
using Microsoft.Extensions.Options;
using Shared.Security;
using SystemService.Domain.Entities.Auth;
```

> `LoginCommand` đã inject sẵn `IUnitOfWork`; thêm `IRefreshTokenRepository` và `IOptions<JwtSettings>`.

---

### Bước 8 — Viết lại `RefreshTokenCommand`

**`SystemService/SystemService.Application/Features/Auth/Commands/RefreshTokenCommand.cs`** — bỏ `IAuthenticationService`/`KeycloakTokenResponse`, thay bằng Identity + bảng `RefreshToken`:

```csharp
using MediatR;
using Microsoft.AspNetCore.Identity;
using Microsoft.Extensions.Logging;
using Microsoft.Extensions.Options;
using Shared.Redis.Permissions;
using Shared.Security;
using SystemService.Application.Exceptions;
using SystemService.Application.Models.Auth;
using SystemService.Application.Services;
using SystemService.Domain;
using SystemService.Domain.Entities.Auth;
using SystemService.Domain.Entities.Users;
using SystemService.Domain.Repositories;

namespace SystemService.Application.Features.Auth.Commands;

public record RefreshTokenCommand(string RefreshToken) : IRequest<AuthTokenResponse>;

public class RefreshTokenCommandHandler : IRequestHandler<RefreshTokenCommand, AuthTokenResponse>
{
    private readonly UserManager<ApplicationUser> _userManager;
    private readonly ITokenService _tokenService;
    private readonly IRefreshTokenRepository _refreshTokenRepository;
    private readonly IApplicationUserRoleRepository _userRoleRepository;
    private readonly IRolePermissionRepository _rolePermissionRepository;
    private readonly IUserPermissionCacheService _userPermissionCacheService;
    private readonly IUnitOfWork _unitOfWork;
    private readonly JwtSettings _jwtSettings;
    private readonly ILogger<RefreshTokenCommandHandler> _logger;

    public RefreshTokenCommandHandler(
        UserManager<ApplicationUser> userManager,
        ITokenService tokenService,
        IRefreshTokenRepository refreshTokenRepository,
        IApplicationUserRoleRepository userRoleRepository,
        IRolePermissionRepository rolePermissionRepository,
        IUserPermissionCacheService userPermissionCacheService,
        IUnitOfWork unitOfWork,
        IOptions<JwtSettings> jwtSettings,
        ILogger<RefreshTokenCommandHandler> logger)
    {
        _userManager = userManager;
        _tokenService = tokenService;
        _refreshTokenRepository = refreshTokenRepository;
        _userRoleRepository = userRoleRepository;
        _rolePermissionRepository = rolePermissionRepository;
        _userPermissionCacheService = userPermissionCacheService;
        _unitOfWork = unitOfWork;
        _jwtSettings = jwtSettings.Value;
        _logger = logger;
    }

    public async Task<AuthTokenResponse> Handle(RefreshTokenCommand request, CancellationToken cancellationToken)
    {
        // 1. Tra cứu refresh token theo hash + kiểm tra hạn dùng / chưa bị thu hồi
        var stored = await _refreshTokenRepository.GetByTokenHashAsync(
            RefreshTokenHelper.Hash(request.RefreshToken), cancellationToken);
        if (stored == null || !stored.IsActive)
            throw new UnauthorizedException("Refresh token không hợp lệ hoặc đã hết hạn.");

        // 2. Tìm user và kiểm tra trạng thái tài khoản
        var user = await _userManager.FindByIdAsync(stored.UserId.ToString());
        if (user == null || user.IsDeleted)
            throw new UnauthorizedException("Người dùng không tồn tại.");

        if (await _userManager.IsLockedOutAsync(user))
            throw new UnauthorizedException("Tài khoản đã bị khóa.");

        // 3. Phát hành access token mới
        var token = await _tokenService.CreateTokenAsync(user, cancellationToken);

        // 4. Rotate refresh token: thu hồi token cũ, cấp token mới
        var newRefreshToken = RefreshTokenHelper.Generate();
        _refreshTokenRepository.Revoke(stored);
        await _refreshTokenRepository.InsertAsync(new RefreshToken
        {
            Id = Guid.NewGuid(),
            UserId = user.Id,
            TokenHash = RefreshTokenHelper.Hash(newRefreshToken),
            ExpiresAtUtc = DateTime.UtcNow.AddDays(_jwtSettings.RefreshTokenExpirationDays),
            CreatedOnUtc = DateTime.UtcNow
        }, cancellationToken);
        await _unitOfWork.SaveChangesAsync(cancellationToken);

        // 5. Load permissions + refresh cache Redis
        var permissions = await LoadUserPermissionsFromDbAsync(user.Id, cancellationToken);
        await _userPermissionCacheService.SetPermissionsAsync(user.Id, permissions, cancellationToken: cancellationToken);

        // 6. Trả về token mới
        return new AuthTokenResponse
        {
            AccessToken = token.AccessToken,
            RefreshToken = newRefreshToken,
            ExpiresIn = token.ExpiresIn,
            UserId = user.Id,
            UserName = user.UserName,
            FullName = user.FullName,
            DonViId = user.DonViId,
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

> **Phát hiện dùng lại token (reuse detection):** nếu cùng một refresh token được gửi lần thứ hai (sau khi đã rotate), `stored.RevokedAtUtc != null` → `IsActive = false` → trả `401`. Tốt hơn, có thể log `_logger.LogWarning(...)` khi phát hiện để biết khả năng lộ token.

> **Dọn token hết hạn:** có thể gọi `await _refreshTokenRepository.DeleteExpiredAsync(cancellationToken)` ở đầu handler (định kỳ) hoặc dùng `IHostedService`.

---

### Bước 9 — Sửa `AuthController`

**`SystemService/SystemService.Api/Controllers/AuthController.cs`** — đổi kiểu trả về của `refresh`:

```csharp
[HttpPost("refresh")]
[AllowAnonymous]
[ProducesResponseType(typeof(ApiResponseModel<AuthTokenResponse>), StatusCodes.Status200OK)]
public async Task<IActionResult> Refresh([FromBody] RefreshTokenCommand command)
{
    var result = await Mediator.Send(command);
    return Ok(ApiResponseModel.Success(result));
}
```

---

### Bước 10 — Viết lại `LogoutCommand` thu hồi refresh token

**`SystemService/SystemService.Application/Features/Auth/Commands/LogoutCommand.cs`** — thay `IKeycloakAdminClient` bằng việc thu hồi token trong DB:

```csharp
public class LogoutCommandHandler : IRequestHandler<LogoutCommand, bool>
{
    private readonly UserManager<ApplicationUser> _userManager;
    private readonly IRefreshTokenRepository _refreshTokenRepository;
    private readonly IUnitOfWork _unitOfWork;
    private readonly ICurrentUserService _currentUserService;

    // constructor ...

    public async Task<bool> Handle(LogoutCommand request, CancellationToken cancellationToken)
    {
        var currentUserId = _currentUserService.UserId;   // đổi theo shape của ICurrentUserService
        if (currentUserId == null)
            return false;

        foreach (var refreshToken in await _refreshTokenRepository.GetActiveByUserIdAsync(currentUserId.Value, cancellationToken))
            _refreshTokenRepository.Revoke(refreshToken);

        await _unitOfWork.SaveChangesAsync(cancellationToken);
        return true;
    }
}
```

> `LogoutSidCommand` (theo Keycloak) có thể giữ lại hoặc xoá tuỳ kế hoạch dọn Keycloak.

---

### Bước 11 — (Khuyến nghị) Thu hồi refresh token khi đổi mật khẩu

Khi admin reset hoặc user đổi mật khẩu (`ChangePasswordCommand`, `ChangePasswordByAdminCommand`, `ChangePasswordAsync`), nên thu hồi toàn bộ refresh token của user để phiên cũ không còn dùng được:

```csharp
foreach (var refreshToken in await _refreshTokenRepository.GetActiveByUserIdAsync(user.Id, cancellationToken))
    _refreshTokenRepository.Revoke(refreshToken);

await _unitOfWork.SaveChangesAsync(cancellationToken);
```

---

### Bước 12 — (Tùy chọn) Client SPA: axios interceptor

Khi access token hết hạn (`401`), tự động gọi refresh một lần rồi replay request:

```ts
import axios from 'axios';

const api = axios.create({ baseURL: '/api/quan-ly-he-thong' });

api.interceptors.response.use(
  (response) => response,
  async (error) => {
    const original = error.config;
    const refreshToken = localStorage.getItem('refreshToken');

    if (error.response?.status === 401 && !original._retry && refreshToken) {
      original._retry = true;

      try {
        const { data } = await api.post('/auth/refresh', { refreshToken });
        const { accessToken, refreshToken: newRefreshToken } = data.data;

        localStorage.setItem('accessToken', accessToken);
        localStorage.setItem('refreshToken', newRefreshToken);

        original.headers.Authorization = `Bearer ${accessToken}`;
        return api(original);
      } catch {
        localStorage.removeItem('accessToken');
        localStorage.removeItem('refreshToken');
        window.location.href = '/login';   // refresh thất bại → đăng nhập lại
        return Promise.reject(error);
      }
    }

    return Promise.reject(error);
  }
);
```

> **An toàn:** lý tưởng nhất là lưu token trong memory (không localStorage) hoặc dùng **HttpOnly cookie** cho refresh token. Nếu phải dùng localStorage, nhớ xoá khi logout/refresh thất bại.

---

## 6. Kiểm thử

1. **Đăng nhập:** `POST /api/quan-ly-he-thong/auth/login` `{ "userName": "admin", "password": "Ab@123456" }` → phản hồi có **cả `accessToken` và `refreshToken`**.
2. **Kiểm tra DB:** bảng `RefreshToken` có 1 dòng, cột `TokenHash` không phải plaintext, `ExpiresAtUtc ≈ now + 7 ngày`.
3. **Refresh thành công:** `POST /api/quan-ly-he-thong/auth/refresh` `{ "refreshToken": "<token ở bước 1>" }` → trả `accessToken` mới + `refreshToken` mới (khác token cũ).
4. **Reuse detection:** dùng **lại refresh token cũ** ở bước 3 → `401`.
5. **Access token hết hạn:** gọi API bình thường với access token đã sửa `exp` về quá khứ (hoặc set `ExpirationInMinutes` nhỏ như 1) → `401`; sau đó refresh → có token mới → gọi lại API → `200`.
6. **Logout:** gọi `/auth/logout` → dùng refresh token → `401`.
7. **Khóa tài khoản:** login sai 5 lần → `IsLockedOutAsync` = true → refresh → `401`.

---

## 7. Lưu ý & các lỗi thường gặp

1. **`JwtSettings.SecretKey`** phải ≥ 32 ký tự và **đồng nhất** giữa `JwtTokenService` (phát hành) và `AddJwtBearer` (validate) — sai key → JWT không xác thực được.
2. **Đừng lưu refresh token plaintext trong DB** — luôn lưu `SHA256(token)`; khi client gửi token, hash rồi so sánh.
3. **Rotation**: sau mỗi lần refresh phải **revoke token cũ**; nếu client không cập nhật refresh token mới thì lần refresh kế tiếp sẽ `401`.
4. **Race khi mở nhiều tab / request song song**: nếu client gửi nhiều request refresh đồng thời với cùng một refresh token, cả hai đều thành công (mỗi cái sinh một token mới) — không mất phiên, nhưng nên **serialize refresh phía client** (dùng chung một promise refresh duy nhất) để chỉ một request refresh chạy tại một thời điểm và giảm rác trên bảng `RefreshToken`.
5. **`IdentityUserToken` không có cột hết hạn** — nếu chọn phương án tối giản (phụ lục), phải tự nhúng hạn dùng vào giá trị token hoặc chấp nhận không ép TTL.
6. **Migration Oracle/SQL Server**: quy ước column Oracle (`NUMBER(1)`, `BINARY_DOUBLE`...) đã được gỡ khỏi `SystemDbContext.ConfigureConventions` — SQL Server giờ dùng mapping mặc định khi tạo migration.
7. **Thời gian sống**: access token ngắn (30–60 phút), refresh token dài hơn (7 ngày). Nếu hệ thống nhạy cảm, giảm `RefreshTokenExpirationDays` và **thu hồi khi đổi mật khẩu** (Bước 11).
8. **Cache Redis**: sau refresh, nếu permissions của user thay đổi, `SetPermissionsAsync` sẽ ghi đè — đã làm ở Bước 8.

---

## 8. Danh sách file bị ảnh hưởng

| File | Hành động |
|---|---|
| `Shared/Shared.Security/JwtSettings.cs` | Giữ nguyên (đã có `RefreshTokenExpirationDays`); có thể gỡ field Keycloak |
| `appsettings.json` / `appsettings.Development.json` | Đổi `AccessTokenLifetimeMinutes` → `ExpirationInMinutes`; thêm `RefreshTokenExpirationDays` |
| `SystemService.Infrastructure/Services/JwtTokenService.cs` | Đọc `ExpirationInMinutes` thay vì hardcode 60 |
| `SystemService.Domain/Entities/Auth/RefreshToken.cs` | **Tạo mới** |
| `SystemService.Domain/Entities/Users/ApplicationUser.cs` | Thêm navigation `ICollection<RefreshToken> RefreshTokens` |
| `SystemService.Infrastructure/Persistence/Configurations/Auth/RefreshTokenConfiguration.cs` | **Tạo mới** |
| `SystemService.Domain/Repositories/IRefreshTokenRepository.cs` | **Tạo mới** |
| `SystemService.Infrastructure/Repositories/RefreshTokenRepository.cs` | **Tạo mới** |
| `SystemService.Infrastructure/DependencyInjection.cs` | Đăng ký `IRefreshTokenRepository` |
| `SystemService.Application/Services/RefreshTokenHelper.cs` | **Tạo mới** |
| `SystemService.Application/Features/Auth/Commands/LoginCommand.cs` | Sinh + lưu refresh token, gán vào `AuthTokenResponse.RefreshToken` |
| `SystemService.Application/Features/Auth/Commands/RefreshTokenCommand.cs` | **Viết lại** (bỏ Keycloak, trả `AuthTokenResponse`) |
| `SystemService.Api/Controllers/AuthController.cs` | Đổi kiểu trả về endpoint `refresh` sang `AuthTokenResponse` |
| `SystemService.Application/Features/Auth/Commands/LogoutCommand.cs` | Thu hồi refresh token trong DB |
| `SystemService.Application/Features/Auth/Commands/ChangePassword*.cs` | (Khuyến nghị) thu hồi refresh token khi đổi mật khẩu |

---

## 9. Phụ lục: phương án tối giản bằng `IdentityUserToken`

Nếu **không muốn thêm bảng mới**, có thể tận dụng bảng `AspNetUserTokens` (Identity) qua `UserManager`:

- **Lưu** (mỗi user **chỉ 1** refresh token — do PK composite `(UserId, LoginProvider, Name)`):

```csharp
var refreshTokenValue = RefreshTokenHelper.Generate();
await _userManager.SetAuthenticationTokenAsync(
    user,
    RefreshTokenHelper.LoginProvider,     // ví dụ "SystemService.RefreshTokenProvider"
    RefreshTokenHelper.TokenName,         // ví dụ "RefreshToken"
    refreshTokenValue);
```

- **Tra cứu theo token** (không có sẵn trong `UserManager`, cần query trực tiếp `_context.UserTokens` — thêm method vào một repository trong Infrastructure):

```csharp
public async Task<Guid?> GetUserIdByRefreshTokenAsync(string refreshToken, CancellationToken cancellationToken = default)
{
    return await _context.UserTokens
        .Where(t => t.LoginProvider == "SystemService.RefreshTokenProvider"
                 && t.Name == "RefreshToken"
                 && t.Value == refreshToken)
        .Select(t => (Guid?)t.UserId)
        .FirstOrDefaultAsync(cancellationToken);
}
```

- **Thu hồi / xoay vòng**:

```csharp
await _userManager.RemoveAuthenticationTokenAsync(user, provider, name);   // logout
await _userManager.SetAuthenticationTokenAsync(user, provider, name, newToken);  // rotate (ghi đè)
```

**Hạn chế của phương án này:**

1. Bảng `IdentityUserToken` **không có cột hết hạn / thu hồi** → phải tự nhúng hạn dùng vào chuỗi token (ví dụ `{expiryTicks}:{random}`) rồi tự kiểm tra, hoặc chấp nhận không ép TTL.
2. **1 user chỉ giữ được 1 refresh token** — không hỗ trợ đa thiết bị / nhiều phiên.
3. Không có index tra theo token (PK là `(UserId, Provider, Name)`) → truy vấn phải scan bảng `UserTokens`.
4. Nếu lưu plaintext token thì DB bị lộ là dùng được ngay.

> **Kết luận:** phương án bảng `RefreshToken` riêng (phần chính của tài liệu) đáng chi phí hơn vì đầy đủ rotation, revocation, TTL và đa thiết bị — đúng mô hình chuẩn của JWT refresh token.

---

*Tài liệu viết dựa trên trạng thái mã nguồn hiện tại của `TT3_MobileBE` (auth đã chuyển sang ASP.NET Identity + JWT nội bộ; phần refresh token còn lại code Keycloak).*
