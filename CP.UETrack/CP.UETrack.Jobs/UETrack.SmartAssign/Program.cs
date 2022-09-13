using log4net;
using System;
using Topshelf;

namespace email
{
    class Program
    {
       // private static readonly ILog Log = LogManager.GetLogger(typeof(Object));

        static void Main()
        {
            try
            {
                HostFactory.Run(x =>
                {
                    x.Service<Service>(s =>
                    {
                        s.ConstructUsing(name => new Service());
                        s.WhenStarted((svc, hc) => svc.ProcessStart(hc));
                        s.WhenStopped((svc, hc) => svc.ProcessStop(hc));
                    });

                    x.RunAsLocalSystem();

                    x.SetDescription("UETrack Smart Assign Service");
                    x.SetDisplayName("UETrack.SmartAssign");
                    x.SetServiceName("UETrack.Services.SmartAssign");
                });

            }
            catch (Exception ex)
            {

                Log.Fatal("Fatal error occures " + ex.Message + Environment.NewLine + ex.StackTrace);
                throw;
            }
        }
    }
}
