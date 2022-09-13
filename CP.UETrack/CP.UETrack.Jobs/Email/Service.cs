//using CP.Framework.Common.Email;
using log4net;
using System;
using System.Reflection;
using System.Timers;
using Topshelf;
using CP.Framework.Common.Email;
using System.Configuration;

namespace email
{
    public class Service
    {
        #region Declaration

        private static readonly ILog Log = LogManager.GetLogger(MethodBase.GetCurrentMethod().DeclaringType);
        private static bool isJobRunning = false, isJobEmailRunning = false;
        Timer _timer;
        //Timer _timer_Email;

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
            Log.InfoFormat("Initializing Email Service...");

            try
            {
                
                double interval = Setting.Interval_Email * 1000;
                LogMessage(string.Format("Config Info: Job is scheduled for every {0} seconds...", Setting.Interval_Email), LogType.Info);

                double interval_Email = Setting.Interval_Scheduler * 1000;
                LogMessage(string.Format("Config Info: Email Job is scheduled for every {0} seconds...", Setting.Interval_Scheduler), LogType.Info);

                _timer = new Timer { Interval =  interval};
                _timer.Elapsed += ServiceJob;
                _timer.Start();

                //_timer_Email = new Timer { Interval = interval_Email };
                //_timer_Email.Elapsed += ServiceJob_Email;
                //_timer_Email.Start();

                LogMessage("Email Service Started by Main Process...", LogType.Info);

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
                    LogMessage("Attempting to stop Email Service...", LogType.Info);
                    _timer.Stop();
                    LogMessage("Email Service Stopped by Main Process!", LogType.Info);
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
                    LogMessage("Starting email service job... ", LogType.Info);
                    var ShowDB = false;
                    bool.TryParse(ConfigurationManager.AppSettings["ShowDB"], out ShowDB);
                    if (ShowDB)
                        LogMessage("Connection String :: " + ConfigurationManager.ConnectionStrings["EmailEntitiesB"].ConnectionString, LogType.Info);
                    var x = new QueueManager();
                    var count = x.ProcessQueue();
                    x = null;
                    isJobRunning = false;
                    LogMessage(string.Format("{0} emails processed!", count), LogType.Info);
                    LogMessage("Email service job completed!", LogType.Info);
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
        //private static void ServiceJob_Email(object sender, ElapsedEventArgs e)
        //{
        //    try
        //    {
        //        if (!isJobEmailRunning)
        //        {
        //            isJobEmailRunning = true;
        //            LogMessage("Starting Scheduled Email service job... ", LogType.Info);
        //            var ShowDB = false;
        //            bool.TryParse(ConfigurationManager.AppSettings["ShowDB"], out ShowDB);
        //            if (ShowDB)
        //            {
        //                LogMessage("Connection String :: " + ConfigurationManager.ConnectionStrings["EmailEntities"].ConnectionString, LogType.Info);
        //            }
        //            var x = new QueueManager();
        //            x.ProcessScheduledEmail();
        //            x = null;
        //            isJobEmailRunning = false;
        //            LogMessage("Scheduled Email processed!", LogType.Info);
        //            LogMessage("Scheduled Email service job completed!", LogType.Info);
        //        }
        //        else
        //        {
        //            LogMessage("Another instance of the job already running... Exiting without running job!", LogType.Info);
        //        }
        //    }
        //    catch (Exception ex)
        //    {
        //        isJobEmailRunning = false;
        //        LogMessage("Exception occured in ServiceJob: " + ex.Message + Environment.NewLine + ex.StackTrace, LogType.Fatal);
        //    }

        //}
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
