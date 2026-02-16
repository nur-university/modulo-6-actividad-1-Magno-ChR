namespace api_gateway.Extensions
{
    public static class ObservabilityExtensions
    {
        public static IServiceCollection AddObservability(this IServiceCollection services)
        {
            services.AddHealthChecks();

            services.AddHealthChecksUI(setupSettings: setup =>
            {
                setup.SetEvaluationTimeInSeconds(10);
                setup.MaximumHistoryEntriesPerEndpoint(50);
            })
            .AddInMemoryStorage();

            return services;
        }
    }
}
