using Grpc.Core;
using Microsoft.AspNetCore.Hosting;
using Microsoft.AspNetCore.Identity;
using Microsoft.EntityFrameworkCore;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using Shared.Security;
using SystemService.Application.Services;
using SystemService.Domain;
using SystemService.Domain.Entities.Authorization;
using SystemService.Domain.Entities.Users;
using SystemService.Domain.Repositories;
using SystemService.Infrastructure.Persistence;
using SystemService.Infrastructure.Persistence.SeedData;
using SystemService.Infrastructure.Repositories;
using SystemService.Infrastructure.Services;
using SystemService.Infrastructure.Settings;

namespace SystemService.Infrastructure;

public static class DependencyInjection
{
    public static IServiceCollection AddInfrastructureServices(
        this IServiceCollection services,
        IConfiguration configuration,
        IWebHostEnvironment environment)
    {
        services.Configure<KeycloakSettings>(configuration.GetSection("Keycloak"));
        services.Configure<JwtSettings>(configuration.GetSection("JwtSettings"));

        // 1. Đăng ký DbContext
        var connectionString = configuration.GetConnectionString("SystemServiceConnection");
        services.AddDbContext<SystemDbContext>(options =>
        {
            options.UseSqlServer(
                connectionString,
                b =>
                {
                    b.MigrationsAssembly(typeof(SystemDbContext).Assembly.FullName);
                });
        });

        // Đăng ký ASP.NET Identity (AddIdentityCore để KHÔNG chiếm default auth scheme - JWT Bearer vẫn là mặc định)
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

        // Dịch vụ phát hành JWT nội bộ
        services.AddScoped<ITokenService, JwtTokenService>();

        // Dịch vụ đồng bộ quyền (xem Bước 12)
        services.AddScoped<IPermissionSyncService, PermissionSyncService>();
        services.AddScoped<ICurrentUserService, CurrentUserService>();

        // 2. Đăng ký các Repository
        // Đăng ký IRepository<,> chung cho tất cả các entity
        services.AddScoped(typeof(IRepository<,>), typeof(EfRepository<,>));
        services.AddScoped<IUserRepository, UserRepository>();
        services.AddScoped<IApplicationMenuRepository, ApplicationMenuRepository>();
        services.AddScoped<IMenuPermissionRepository, MenuPermissionRepository>();
        services.AddScoped<IKeycloakSettingsProvider, KeycloakSettingsProvider>();
        services.AddScoped<IPermissionRepository, PermissionRepository>();
        services.AddScoped<IRolePermissionRepository, RolePermissionRepository>();
        services.AddScoped<IRoleRepository, RoleRepository>();
        services.AddScoped<IApplicationUserRoleRepository, ApplicationUserRoleRepository>();
        services.AddScoped<IRefreshTokenRepository, RefreshTokenRepository>();

        services.AddScoped<ApplicationDbSeeder>();

        // 3. Đăng ký Unit of Work
        services.AddScoped<IUnitOfWork, UnitOfWork>();

        services.AddHttpClient<IAuthenticationService, KeycloakAuthenticationService>()
            .ConfigurePrimaryHttpMessageHandler(() =>
            {
                return new HttpClientHandler
                {
                    // Bỏ qua lỗi chứng chỉ SSL.
                    // Chỉ sử dụng trong môi trường dev hoặc nội bộ tin cậy.
                    ServerCertificateCustomValidationCallback = (message, cert, chain, errors) =>
                    {
                        // Nếu bạn muốn an toàn hơn, có thể kiểm tra cert.Thumbprint ở đây
                        // để đảm bảo chỉ tin tưởng đúng chứng chỉ của bạn.
                        // For now, we trust all.
                        return true;
                    }
                };
            });

        //Đăng ký hosted service
        //services.AddHostedService<KeycloakPermissionSyncService>();

        // Đăng ký gRPC Clients
        AppContext.SetSwitch("System.Net.Http.SocketsHttpHandler.Http2UnencryptedSupport", true);

        return services;
    }
}
