using Serilog;

var builder = WebApplication.CreateBuilder(args);

// Configure Serilog
var logPath = Environment.GetEnvironmentVariable("LOG_PATH") ?? "logs/app.log";
Log.Logger = new LoggerConfiguration()
    .WriteTo.Console()
    .WriteTo.File(logPath, rollingInterval: RollingInterval.Day)
    .CreateLogger();

builder.Host.UseSerilog();

var app = builder.Build();

app.MapGet("/health", () =>
{
    Log.Information("Health endpoint hit at {Time}", DateTime.UtcNow);
    return Results.Ok("OK");
});

app.Run();

public partial class Program { }
