

namespace CP.Application.IOC
{
    public class IoCFactory
    {
        public IContainer GetContainer(string name)
        {
            return new AutofacContainer();
        }
    }
}
