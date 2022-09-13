using log4net;
using System;
using System.Reflection;
using System.Timers;
using Topshelf;
using System.Configuration;
using CP.Framework.Common.SmartAssign.Implementation;

namespace email
{
    public class Service
    {
        #region Declaration

        private static readonly ILog Log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);
        private static bool isJobRunning = false, isJobEmailRunning = false;
        Timer _timer;
        Timer _timer_Email;

        #endregion

        #region Constructor
        public Service()
        {
            log4net.Config.XmlConfigurator.Configure();
        }
        #endregion

        #region Public Methods
        public bool ProcessStart(HostControl aHostControl)
        {
            Log.InfoFormat("Initializing Smart Assign Service...");

            try
            {   
                
                double interval = Setting.Interval * 1000;
                LogMessage(string.Format("Config Info: Job is scheduled for every {0} seconds...", Setting.Interval), LogType.Info);

                _timer = new Timer { Interval =  interval};
                _timer.Elapsed += ServiceJob;
                _timer.Start();

                LogMessage("Smart Assign Service Started by Main Process...", LogType.Info);

                return true;
            }
            catch (Exception ex)
            {
                LogMessage("Fatal error occured: " + ex.Message + Environment.NewLine + ex.StackTrace, LogType.Info);
                throw;
            }

        }

       

        public bool ProcessStop(HostControl aHostControl)
        {
            try
            {
                if (_timer != null)
                {
                    LogMessage("Attempting to stop Smart Assign Service...", LogType.Info);
                    _timer.Stop();
                    _timer_Email.Stop();
                    LogMessage("Smart Assign Service Stopped by Main Process!", LogType.Info);
                }
                return true;
            }
            catch (Exception ex)
            {
                LogMessage("Fatal error occured: " + ex.Message + Environment.NewLine + ex.StackTrace, LogType.Info);
                throw;
            }
        }
      
        private static void ServiceJob(object sender, ElapsedEventArgs e)
        {           
            try
            {
                if (!isJobRunning)
                {
                    isJobRunning = true;
                    LogMessage("Starting Smart Assign service job... ", LogType.Info);
                    var ShowDB = false;
                    bool.TryParse(ConfigurationManager.AppSettings["ShowDB"], out ShowDB);
                    if (ShowDB)
                    {                  
                        LogMessage("Connection String :: " + ConfigurationManager.ConnectionStrings["EmailEntities"].ConnectionString, LogType.Info);
                    }
                    var x = new QueueSmartAssign();
                    var count = x.ProcessSmartAssign();
                    x = null;
                    isJobRunning = false;
                    LogMessage(string.Format("{0} Smart Assign processed!", count), LogType.Info);
                    LogMessage("Smart Assign service job completed!", LogType.Info);
                }
                else
                {
                    LogMessage("Another instance of the job already running... Exiting without running job!", LogType.Info);
                }
            }
            catch (Exception ex)
            {
                isJobRunning = false;
                LogMessage("Exception occured in ServiceJob: " + ex.Message + Environment.NewLine + ex.StackTrace, LogType.Fatal);
            }

        }
        
        private enum LogType
        {
            Debug,
            Info,
            Warning,
            Error,
            Fatal
        }

        private static void LogMessage(string message, LogType logType)
        {
            message = string.Format("{0} - {1}", DateTime.Now, message);

            switch (logType)
            {
                case (LogType.Debug):
                    Log.Debug(message); break;

                case (LogType.Info):
                    Log.Info(message); break;

                case (LogType.Warning):
                    Log.Warn(message); break;

                case (LogType.Error):
                    Log.Error(message); break;

                case (LogType.Fatal):
                    Log.Fatal(message); break;

            }
        }

        #endregion
    }
}
