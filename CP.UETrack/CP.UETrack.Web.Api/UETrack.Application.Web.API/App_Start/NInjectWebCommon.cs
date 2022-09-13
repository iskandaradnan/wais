[assembly: WebActivatorEx.PreApplicationStartMethod(typeof(UETrack.Application.Web.API.App_Start.NinjectWebCommon), "Start")]
[assembly: WebActivatorEx.ApplicationShutdownMethodAttribute(typeof(UETrack.Application.Web.API.App_Start.NinjectWebCommon), "Stop")]

namespace UETrack.Application.Web.API.App_Start
{
    using System;
    using System.Web;
    using Microsoft.Web.Infrastructure.DynamicModuleHelper;
    using Ninject;
    using Ninject.Web.Common;
    using Ninject.Modules;
    using System.Collections.Generic;

    public static class NinjectWebCommon
    {
        private static readonly Bootstrapper bootstrapper = new Bootstrapper();

        /// <summary>
        /// Starts the application
        /// </summary>
        public static void Start()
        {
            DynamicModuleUtility.RegisterModule(typeof(OnePerRequestHttpModule));
            DynamicModuleUtility.RegisterModule(typeof(NinjectHttpModule));
            bootstrapper.Initialize(CreateKernel);
        }

        /// <summary>
        /// Stops the application.
        /// </summary>
        public static void Stop()
        {
            bootstrapper.ShutDown();
        }

        /// <summary>
        /// Creates the kernel that will manage your application.
        /// </summary>
        /// <returns>The created kernel.</returns>
        private static IKernel CreateKernel()
        {
            var kernel = new StandardKernel();
            try
            {
                kernel.Bind<Func<IKernel>>().ToMethod(ctx => () => new Bootstrapper().Kernel);
                kernel.Bind<IHttpModule>().To<HttpApplicationInitializationHttpModule>();

                var modules = new List<INinjectModule>
                {
                    new CP.UETrack.BLL.ComponentRegistry.DataModule(),
                    new CP.Framework.Security.Authentication.ComponentRegistry.AuthenticationModule(),
                    new CP.Framework.Common.Audit.ComponentRegistry.AuditModule()
                };

                kernel.Load(modules);

                //System.Web.Http.GlobalConfiguration.Configuration.DependencyResolver = new Ninject.WebApi.DependencyResolver.NinjectDependencyResolver(kernel);

                return kernel;
            }
            catch(Exception ex)
            {
                kernel.Dispose();
                throw;
            }
        }
    }
}

namespace UETrack.Application.Web.API.Infrastructure
{
    using Ninject.Activation;
    using Ninject.Parameters;
    using Ninject.Syntax;
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Web.Http.Dependencies;
    public class NinjectScope : IDependencyScope, IDisposable
    {
        protected IResolutionRoot resolutionRoot;

        public NinjectScope(IResolutionRoot kernel)
        {
            resolutionRoot = kernel;
        }

        public object GetService(Type serviceType)
        {
            var request = resolutionRoot.CreateRequest(serviceType, null, new Parameter[0], true, true);
            return resolutionRoot.Resolve(request).SingleOrDefault();
        }

        public IEnumerable<object> GetServices(Type serviceType)
        {
            var request = resolutionRoot.CreateRequest(serviceType, null, new Parameter[0], true, true);
            return resolutionRoot.Resolve(request).ToList();
        }

        public void Dispose()
        {
            //var disposable = (IDisposable)resolutionRoot;
            //if (disposable != null) disposable.Dispose();
            resolutionRoot = null;
            GC.SuppressFinalize(this);
        }
    }

}

namespace UETrack.Application.Web.API.Infrastructure
{
    using Ninject;
    using System.Web.Http.Dependencies;
    public class NinjectResolver : NinjectScope, IDependencyResolver
    {
        private readonly IKernel _kernel;

        public NinjectResolver(IKernel kernel)
            : base(kernel)
        {
            _kernel = kernel;
        }

        public IDependencyScope BeginScope()
        {
            return new NinjectScope(_kernel.BeginBlock());
        }
    }
}
