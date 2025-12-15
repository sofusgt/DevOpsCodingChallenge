var builder = WebApplication.CreateBuilder(args);

// Add services to the container.
builder.Services.AddLogging();

var app = builder.Build();

app.MapGet("/health", (ILogger<Program> logger) =>
{
    logger.LogInformation("Health endpoint hit at {Time}", DateTime.UtcNow);
    return Results.Ok("OK");
});

app.MapGet("/", () => "Hello World!");

app.Run();

public partial class Program { }
