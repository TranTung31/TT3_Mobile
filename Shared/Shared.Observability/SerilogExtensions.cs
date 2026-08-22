using Microsoft.Extensions.Hosting;
using Serilog;
using Serilog.Enrichers.Span;
using Serilog.Formatting.Compact;

namespace Shared.Observability;

public static class SerilogExtensions
{
    public static IHostBuilder AddCustomSerilog(this IHostBuilder host)
    {
        host.UseSerilog((context, services, configuration) =>
        {
            
            var serviceName = context.HostingEnvironment.ApplicationName;

            configuration
                .ReadFrom.Configuration(context.Configuration)
                .ReadFrom.Services(services)
                .Enrich.FromLogContext()
                .Enrich.WithMachineName()
                .Enrich.WithEnvironmentName()
                .Enrich.WithProcessId() // Ghi lại ID của process
                .Enrich.WithThreadId()  // Ghi lại ID của thread
                .Enrich.WithSpan()      // Ghi TraceId và SpanId từ OpenTelemetry vào Log
                .Enrich.WithProperty("service.name", serviceName) // Phân biệt log của service nào
                .Enrich.WithProperty("service.environment", context.HostingEnvironment.EnvironmentName);


            // 1. Ghi ra Console (K8s sẽ tự động bắt stdout này)
            if (context.HostingEnvironment.IsDevelopment())
            {
                configuration.WriteTo.Console();
            }
            else
            {
                // Môi trường K8s: Ghi dạng JSON để hệ thống gom log (FluentBit/Promtail) dễ bóc tách nếu cần
                configuration.WriteTo.Console(new RenderedCompactJsonFormatter());
            }

            // 2. Tùy chọn ghi trực tiếp về máy chủ Seq qua mạng nội bộ K8s
            var seqUrl = context.Configuration["Observability:SeqUrl"];
            var seqApiKey = context.Configuration["Observability:SeqApiKey"];
            if (!string.IsNullOrWhiteSpace(seqUrl))
            {
                configuration.WriteTo.Seq(seqUrl, apiKey: seqApiKey);
            }
        });

        return host;
    }
}

