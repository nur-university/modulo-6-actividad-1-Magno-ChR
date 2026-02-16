using api_gateway.Access;
using HealthChecks.UI.Client;
using Microsoft.AspNetCore.Diagnostics.HealthChecks;

namespace api_gateway.Extensions
{
    public static class ApplicationBuilderExtensions
    {
        public static IApplicationBuilder UseSwaggerWithUi(this WebApplication app)
        {
            app.UseSwagger();
            app.UseSwaggerUI();

            return app;
        }

        public static IApplicationBuilder UseSwaggerWithUiWithConsul(this WebApplication app)
        {
            app.UseSwagger();
            app.UseSwaggerUI(options =>
            {
                options.SwaggerEndpoint("/swagger/v1/swagger.json", "API Gateway");
            });

            return app;
        }

        public static IApplicationBuilder UseHealthChecks(this WebApplication app)
        {
            app.MapHealthChecks("/health", new HealthCheckOptions
            {
                ResponseWriter = UIResponseWriter.WriteHealthCheckUIResponse
            });

            app.MapHealthChecksUI(options =>
            {
                options.UIPath = "/health-ui";
            });

            return app;
        }

        public static IApplicationBuilder UseAdvancedScopeAuthorization(this WebApplication app)
        {
            app.UseMiddleware<AdvancedScopeAuthorizationMiddleware>();
            return app;
        }

        public static IApplicationBuilder UseCorrelationId(this WebApplication app)
        {
            app.Use(async (context, next) =>
            {
                context.Request.Headers["X-Correlation-Id"] = Guid.NewGuid().ToString();
                await next();
            });
            return app;
        }
    }
}
