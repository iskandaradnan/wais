
using Ninject.Modules;
using Ninject.Extensions.Conventions;
using System.Reflection;

namespace CP.Framework.Security.Authentication.ComponentRegistry
{
    public class AuthenticationModule :  NinjectModule
    {
        public override void Load()
        {
            try {
                this.Bind(x => x.FromThisAssembly()
                            .IncludingNonePublicTypes()
                            .SelectAllClasses()
                            .BindAllInterfaces());
            }
            catch(ReflectionTypeLoadException ex)
            {
                var loaderExceptions = ex.LoaderExceptions;
            }
        }

}
}
