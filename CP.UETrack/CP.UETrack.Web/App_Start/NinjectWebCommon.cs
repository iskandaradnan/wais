[assembly: WebActivator.PreApplicationStartMethod(typeof(UETrack.Application.Web.App_Start.NinjectWebCommon), "Start")]
[assembly: WebActivator.ApplicationShutdownMethodAttribute(typeof(UETrack.Application.Web.App_Start.NinjectWebCommon), "Stop")]

namespace UETrack.Application.Web.App_Start
{
    using Microsoft.Web.Infrastructure.DynamicModuleHelper;
    using Ninject;
    using Ninject.Modules;
    using Ninject.Web.Common;
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Web;


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
            kernel.Bind<Func<IKernel>>().ToMethod(ctx => () => new Bootstrapper().Kernel);
            kernel.Bind<IHttpModule>().To<HttpApplicationInitializationHttpModule>();

            var modules = new List<INinjectModule>
            {
                new CP.Framework.Security.Authentication.ComponentRegistry.AuthenticationModule(),
                new CP.Framework.Common.Audit.ComponentRegistry.AuditModule()
            };
            kernel.Load(modules); 

            System.Web.Http.GlobalConfiguration.Configuration.DependencyResolver = new Infrastructure.NinjectResolver(kernel);
            return kernel;
        }
    }
}



namespace UETrack.Application.Web.Infrastructure
{
    using Ninject.Activation;
    using Ninject.Parameters;
    using Ninject.Syntax;
    using System;
    using System.Collections.Generic;
    using System.Linq;
    using System.Web.Http.Dependencies;
    public class NinjectScope : IDependencyScope
    {
        protected IResolutionRoot resolutionRoot;

        public NinjectScope(IResolutionRoot kernel)
        {
            resolutionRoot = kernel;
        }

        public object GetService(Type serviceType)
        {
            IRequest request = resolutionRoot.CreateRequest(serviceType, null, new Parameter[0], true, true);
            return resolutionRoot.Resolve(request).SingleOrDefault();
        }

        public IEnumerable<object> GetServices(Type serviceType)
        {
            IRequest request = resolutionRoot.CreateRequest(serviceType, null, new Parameter[0], true, true);
            return resolutionRoot.Resolve(request).ToList();
        }

        public void Dispose()
        {
            //IDisposable disposable = (IDisposable)resolutionRoot;
            //if (disposable != null) disposable.Dispose();
            resolutionRoot = null;
        }
    }

}

namespace UETrack.Application.Web.Infrastructure
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