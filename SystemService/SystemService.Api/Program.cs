using Microsoft.AspNetCore.ResponseCompression;
using Shared.Observability;
using Shared.Redis;
using Shared.Security;
using Shared.Security.Authorization;
using SystemService.Api.Middleware;
using SystemService.Application;
using SystemService.Infrastructure;
using SystemService.Infrastructure.Persistence.SeedData;

var builder = WebApplication.CreateBuilder(args);

AppContext.SetSwitch("System.Net.Http.SocketsHttpHandler.Http2UnencryptedSupport", true);

builder.WebHost.ConfigureKestrel(options =>
{
  // JWT nhiều permission (~400+) làm Authorization header vượt mặc định 32KB -> 431
  options.Limits.MaxRequestHeadersTotalSize = 128 * 1024;
  options.Limits.MaxRequestHeaderCount = 200;
});

// Cấu hình logging tập trung
builder.Host.AddCustomSerilog();

// Add services to the container.
builder.Services.AddApplicationServices();
builder.Services.AddInfrastructureServices(builder.Configuration, builder.Environment);

// Đăng ký HttpContextAccessor
builder.Services.AddHttpClient();
builder.Services.AddHttpContextAccessor();

// Thêm cấu hình xác thực JWT từ Shared.Security
builder.Services.AddJwtAuthentication(builder.Configuration, builder.Environment);

// Thêm cấu hình OpenTelemetry
builder.Services.AddCustomOpenTelemetry(builder.Configuration);

// Đăng ký Redis dùng chung cho permission cache
builder.Services.AddSharedRedis(builder.Configuration);

// Đăng ký dịch vụ phân quyền động
builder.Services.AddPermissionAuthorization();

// --- Định nghĩa chính sách CORS ---
const string MyAllowSpecificOrigins = "_myAllowSpecificOrigins";
builder.Services.AddCors(options =>
{
  options.AddPolicy(name: MyAllowSpecificOrigins,
      policy =>
      {
        // Thay đổi URL này thành URL của React App
        policy.WithOrigins("http://localhost:3000", "http://app.qltcdt.btc.vn", "http://14.248.82.118:43000", "http://10.0.0.86:3030",
                  "http://app.qltcdt2.btc.vn", "https://app.qltcdt2.btc.vn", "http://10.0.0.218:30080",
                  "http://app2.qltcdt.btc.vn", "https://app.qltcdt.btc.vn",
                  "https://app2.qltcdt.btc.vn")
              .AllowAnyHeader()
              .AllowAnyMethod()
              .AllowCredentials();
      });
});

// Thêm dịch vụ kiểm tra sức khỏe
builder.Services.AddHealthChecks();

// Thêm dịch vụ cho Controllers và cấu hình JSON
builder.Services.AddControllers()
    .AddJsonOptions(options =>
    {
      var jsonOptions = options.JsonSerializerOptions;

      // 1. Tự động chuyển đổi tên thuộc tính sang camelCase (e.g., MyProperty -> myProperty)
      jsonOptions.PropertyNamingPolicy = System.Text.Json.JsonNamingPolicy.CamelCase;

      // 2. Chuyển đổi Enum thành chuỗi thay vì số (e.g., MyEnum.Value -> "Value")
      //jsonOptions.Converters.Add(new System.Text.Json.Serialization.JsonStringEnumConverter());

      // 3. Bỏ qua các thuộc tính có giá trị null khi serialize
      jsonOptions.DefaultIgnoreCondition = System.Text.Json.Serialization.JsonIgnoreCondition.WhenWritingNull;

      // 4. Cho phép đọc số từ chuỗi khi deserialize
      //jsonOptions.NumberHandling = System.Text.Json.Serialization.JsonNumberHandling.AllowReadingFromString;
    });

// Cấu hình Swagger/OpenAPI để Scalar sử dụng
builder.Services.AddEndpointsApiExplorer();
builder.Services.AddSwaggerGen(options =>
{
  // Thêm thông tin chung cho tài liệu API
  options.SwaggerDoc("v1", new Microsoft.OpenApi.Models.OpenApiInfo
  {
    Version = "v1",
    Title = "System Management API",
    Description = "API for managing System"
  });

  // Cấu hình để hỗ trợ JWT Bearer Authentication trong UI
  options.AddSecurityDefinition("Bearer", new Microsoft.OpenApi.Models.OpenApiSecurityScheme
  {
    In = Microsoft.OpenApi.Models.ParameterLocation.Header,
    Description = "Please enter a valid token",
    Name = "Authorization",
    Type = Microsoft.OpenApi.Models.SecuritySchemeType.Http,
    BearerFormat = "JWT",
    Scheme = "Bearer"
  });

  options.AddSecurityRequirement(new Microsoft.OpenApi.Models.OpenApiSecurityRequirement
    {
        {
            new Microsoft.OpenApi.Models.OpenApiSecurityScheme
            {
                Reference = new Microsoft.OpenApi.Models.OpenApiReference
                {
                    Type = Microsoft.OpenApi.Models.ReferenceType.SecurityScheme,
                    Id = "Bearer"
                }
            },
            new string[] { }
        }
    });
});
builder.Services.AddResponseCompression(options =>
{
  options.EnableForHttps = true;
  options.MimeTypes = ResponseCompressionDefaults.MimeTypes.Concat(["application/json"]);
});

var app = builder.Build();

await using (var scope = app.Services.CreateAsyncScope())
{
    var seeder = scope.ServiceProvider.GetRequiredService<ApplicationDbSeeder>();
    await seeder.SeedDatabaseAsync();
}

// Đăng ký middleware xử lý exception ở đầu pipeline
app.UseMiddleware<ExceptionHandlerMiddleware>();


// Cấu hình cho môi trường Development
//if (app.Environment.IsDevelopment())
//{
app.UseSwagger();

// Chuyển hướng trang chủ đến giao diện Scalar
app.UseSwaggerUI(options =>
{
  // Đặt Swagger UI làm trang chủ
  //options.RoutePrefix = string.Empty;
  // Chỉ định đường dẫn đến file swagger.json
  options.SwaggerEndpoint("/swagger/v1/swagger.json", "System API v1");
});

//}
// Configure the HTTP request pipeline.
//app.UseHttpsRedirection();
app.UseRouting();

// Kích hoạt CORS
app.UseCors(MyAllowSpecificOrigins);

app.UseAuthentication();
app.UseAuthorization();

// Thêm endpoint kiểm tra sức khỏe
app.MapHealthChecks("/health").AllowAnonymous();

// Thêm middleware để routing tới các controllers
app.MapControllers();

// Mở endpoint /metrics cho Prometheus cào dữ liệu K8s
app.MapCustomObservabilityEndpoints();

app.Run();
