using Owin;

namespace UETrack.Application.Web
{
    public partial class Startup 
    {
        public void Configuration(IAppBuilder app) 
        {
            ConfigureAuth(app);
        }
    }
}
