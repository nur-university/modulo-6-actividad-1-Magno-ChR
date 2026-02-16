using Nur.Store2025.Security.Config;

namespace api_gateway.Extensions
{
    public static class SecretExtensions
    {
        public static IServiceCollection AddSecrets(this IServiceCollection services, IConfiguration configuration, IHostEnvironment environment)
        {
            var jwtOptions = new JwtOptions();
            configuration.GetSection("Jwt").Bind(jwtOptions);
            services.AddSingleton(jwtOptions);

            return services;
        }
    }
}
