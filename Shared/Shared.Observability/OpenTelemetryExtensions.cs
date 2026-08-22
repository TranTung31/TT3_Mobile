using Microsoft.AspNetCore.Builder;
using Microsoft.AspNetCore.Routing;
using Microsoft.Extensions.Configuration;
using Microsoft.Extensions.DependencyInjection;
using OpenTelemetry.Metrics;
using OpenTelemetry.Resources;
using OpenTelemetry.Trace;

namespace Shared.Observability;

public static class OpenTelemetryExtensions
{
    public static IServiceCollection AddCustomOpenTelemetry(this IServiceCollection services, IConfiguration configuration)
    {
        var serviceName = configuration["OpenTelemetry:ServiceName"] ?? "UnknownService";
        var otlpEndpoint = configuration["Observability:OtlpEndpoint"];
        var otlpHeaders = configuration["Observability:OtlpHeaders"];

        services.AddOpenTelemetry()
            .ConfigureResource(resource => resource.AddService(serviceName))
            .WithTracing(tracing =>
            {
                tracing
                    .AddAspNetCoreInstrumentation(options =>
                    {
                        options.RecordException = true; // Tự động ghi lại exception vào trace
                    })
                    .AddHttpClientInstrumentation()
                    .AddEntityFrameworkCoreInstrumentation(options =>
                    {
                        options.SetDbStatementForText = true; // Lưu câu query Oracle vào trace
                    });

                // Đẩy Trace qua OTLP (Tới Seq, Jaeger, hoặc Elastic APM đều được, tùy thuộc vào OtlpEndpoint)
                if (!string.IsNullOrEmpty(otlpEndpoint))
                {
                    tracing.AddOtlpExporter(options =>
                    {
                        options.Endpoint = new Uri(otlpEndpoint);

                        if (!string.IsNullOrEmpty(otlpHeaders))
                        {
                            options.Headers = otlpHeaders;
                        }
                    });
                }
            })
            .WithMetrics(metrics =>
            {
                metrics
                    .AddAspNetCoreInstrumentation()
                    .AddHttpClientInstrumentation()
                    .AddRuntimeInstrumentation() // Monitor CPU, RAM, GC của Container
                    // Thêm dòng này để OpenTelemetry lắng nghe các bộ đếm từ Driver Oracle
                    .AddMeter("Oracle.ManagedDataAccess")
                    // Thu thập metric native của Entity Framework Core
                    .AddMeter("Microsoft.EntityFrameworkCore");

                // Expose endpoint /metrics cho Prometheus
                metrics.AddPrometheusExporter();
            });

        return services;
    }
    public static IEndpointRouteBuilder MapCustomObservabilityEndpoints(this IEndpointRouteBuilder endpoints)
    {
        // Kích hoạt endpoint http://<service-ip>/metrics
        endpoints.MapPrometheusScrapingEndpoint();
        return endpoints;
    }
}

