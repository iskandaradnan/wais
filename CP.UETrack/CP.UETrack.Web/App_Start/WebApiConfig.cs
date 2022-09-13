namespace UETrack.Application.Web
{
    using Newtonsoft.Json;
    using Newtonsoft.Json.Converters;
    using Newtonsoft.Json.Serialization;
    using System.Web.Http;

    public static class WebApiConfig
    {
        public static void Register(HttpConfiguration config)
        {

            config.Filters.Add(new Helpers.ErrorHelperApi());

            config.MapHttpAttributeRoutes();

            config.Routes.MapHttpRoute(
                name: "ApiSubmits",
                routeTemplate: "api/{controller}"
            );

            config.Routes.MapHttpRoute(
                name: "ApiDefault",
                routeTemplate: "api/{controller}/{id}",
                defaults: new { id = RouteParameter.Optional }
                );

            config.Routes.MapHttpRoute(
                name: "ApiAction",
                routeTemplate: "api/{controller}/{action}/{name}"
                );
            config.Formatters.JsonFormatter.SerializerSettings = new JsonSerializerSettings()
            {
                ContractResolver = new DefaultContractResolver()
                {
                    IgnoreSerializableAttribute = true
                }
            };
            config.Formatters.JsonFormatter.SerializerSettings.DateFormatString = "dd/MM/yyyy HH:mm";
            config.Formatters.JsonFormatter.SerializerSettings.Converters = new[] { new StringEnumConverter() };

        }
    }
}
