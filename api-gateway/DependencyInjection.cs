using api_gateway.Access;
using api_gateway.Extensions;
using api_gateway.Services;
using Microsoft.IdentityModel.Tokens;
using Microsoft.OpenApi.Models;
using Nur.Store2025.Security.Config;
using System.Text;
using Yarp.ReverseProxy.Configuration;

namespace api_gateway
{
    public static class DependencyInjection
    {

        public static void AddServices(this IServiceCollection services, IConfiguration configuration, IHostEnvironment environment)
        {
            // Configurar JWT Bearer (si ya lo hace otra librería, no registrar aquí)
            var jwtSection = configuration.GetSection("Jwt");
            var secretKey = jwtSection["SecretKey"];
            var issuer = jwtSection["Issuer"];
            var audience = jwtSection["Audience"];

            services.AddSecrets(configuration, environment)
                .AddSecurityAccessRules(configuration)

                .AddEndpointsApiExplorer()
                .AddSwaggerGen(c =>
                {
                    c.SwaggerDoc("v1", new OpenApiInfo
                    {
                        Title = "API Gateway",
                        Version = "v1"
                    });

                    var securityScheme = new OpenApiSecurityScheme
                    {
                        Name = "Bearer",
                        BearerFormat = "JWT",
                        Scheme = "bearer",
                        Description = "JWT Authorization header using the Bearer scheme.",
                        In = ParameterLocation.Header,
                        Type = SecuritySchemeType.Http,
                    };

                    c.AddSecurityDefinition("Bearer", securityScheme);

                    var securityRequirement = new OpenApiSecurityRequirement
                    {
                        {
                            new OpenApiSecurityScheme
                            {
                                Reference = new OpenApiReference
                                {
                                    Type = ReferenceType.SecurityScheme,
                                    Id = "Bearer"
                                }
                            },
                            Array.Empty<string>()
                        }
                    };

                    c.AddSecurityRequirement(securityRequirement);
                })
                .AddControllers();

            services.AddScoped<ITokenGeneratorService, TokenGeneratorService>();
            services.AddHttpClient();

            services.AddReverseProxy()
                .LoadFromConfig(configuration.GetSection("ReverseProxy"));

            services.AddObservability();
        }
    }
}
