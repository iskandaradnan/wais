namespace CP.UETrack.BLL.ComponentRegistry
{
    using Ninject.Modules;
    using Ninject.Extensions.Conventions;
    public class BusinessModule : NinjectModule
    {
        public override void Load()
        {
                this.Bind(x => x.FromThisAssembly()
                         .IncludingNonePublicTypes()
                         .SelectAllClasses()
                         .BindAllInterfaces());
        }
    }
} 
