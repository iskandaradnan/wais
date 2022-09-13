

namespace CP.Framework.Data.ComponentRegistry
{
    using Ninject.Modules;

    public class DataContextModule : NinjectModule
    {
        public override void Load()
        {
            //Bind<IASISWebDatabaseEntities>().To<ASISWebDatabaseEntities>();
        }
    }
}