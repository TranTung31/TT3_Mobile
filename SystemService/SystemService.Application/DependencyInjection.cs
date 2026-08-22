using FluentValidation;
using MediatR;
using Microsoft.Extensions.DependencyInjection;
using System.Reflection;
using SystemService.Application.Behaviors;

namespace SystemService.Application;

public static class DependencyInjection
{
    /// <summary>
    /// Đăng ký các dịch vụ của tầng Application vào DI container.
    /// </summary>
    /// <param name="services">IServiceCollection</param>
    /// <returns>IServiceCollection</returns>
    public static IServiceCollection AddApplicationServices(this IServiceCollection services)
    {
        // Đăng ký AutoMapper
        services.AddAutoMapper(Assembly.GetExecutingAssembly());

        // Tự động tìm và đăng ký tất cả các Validator trong Assembly
        services.AddValidatorsFromAssembly(Assembly.GetExecutingAssembly());

        // Đăng ký MediatR và cấu hình pipeline
        services.AddMediatR(cfg =>
        {
            cfg.RegisterServicesFromAssembly(Assembly.GetExecutingAssembly());

            // Đăng ký pipeline behavior để tự động validate
            cfg.AddBehavior(typeof(IPipelineBehavior<,>), typeof(ValidationBehaviour<,>));
        });

        return services;
    }
}
