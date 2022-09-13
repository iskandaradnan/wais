using Autofac;
using Autofac.Integration.WebApi;
using System.Reflection;
using System.Web.Http;
using System.Web.Mvc;


namespace ASIS.Application.Web
{
    public class AutofacConfig
    {
        //public static IContainer AppContainer { get; set; }
        public static void RegisterComponents()
        {
            var builder = new ContainerBuilder();
            var config = new HttpConfiguration();
            builder.RegisterApiControllers(Assembly.GetExecutingAssembly());
            builder.RegisterWebApiFilterProvider(config);

            // Create the container
            var container = builder.Build();

            // Set the dependency resolver for MVC
            config.DependencyResolver= new AutofacWebApiDependencyResolver(container);
            
            //// Set up the FluentValidation provider factory and add it as a Model validator
            //var fluentValidationModelValidatorProvider = new FluentValidationModelValidatorProvider(new AutofacValidatorFactory(container));
            //ModelValidatorProviders.Providers.Add(fluentValidationModelValidatorProvider);
            //DataAnnotationsModelValidatorProvider.AddImplicitRequiredAttributeForValueTypes = false;
            //fluentValidationModelValidatorProvider.AddImplicitRequiredValidator = false;

        }
    }
}