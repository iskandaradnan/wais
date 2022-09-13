namespace CP.Framework.Common.Logging
{
    using System;
    using log4net;
    using log4net.Appender;
    using log4net.Config;
    using log4net.Repository.Hierarchy;

    public class Log4NetLogger : ILog4NetLogger
    {
        private static readonly ILog Log = LogManager.GetLogger(typeof(Log4NetLogger).Name);

        private static string defaultFilePath = string.Empty;

        /// <summary>
        /// Static constructor which initialize the XmlConfigurator and store default file path.
        /// </summary>
        public Log4NetLogger()
        {
            XmlConfigurator.Configure();
            SetDefaultFileName();
        }

        /// <summary>
        /// LogMessage which will write the log in last initialized file path.
        /// </summary>
        /// <param name="message"></param>
        /// <param name="level"></param>
        public void LogMessage(string message, Level level)
        {
            if (level == Level.Error && Log.IsErrorEnabled)
            {
                Log.Error(message);
            }
            else if (level == Level.Debug && Log.IsDebugEnabled)
            {
                Log.Debug(message);
            }
            else if (level == Level.Fatal && Log.IsFatalEnabled)
            {
                Log.Fatal(message);
            }
            else if (level == Level.Info && Log.IsInfoEnabled)
            {
                Log.Info(message);
            }
            else if (level == Level.Warn && Log.IsWarnEnabled)
            {
                Log.Warn(message);
            }
        }

        public static void LogEntry(object fileName, string v1, string v2)
        {
            throw new NotImplementedException();
        }

        /// <summary>
        /// LogException which will write the error log in last initialized file path.
        /// </summary>
        /// <param name="ex"></param>
        /// <param name="level"></param>
        public void LogException(Exception ex, Level level)
        {
            if (level == Level.Error && Log.IsErrorEnabled)
            {
                Log.Error(ex.Message, ex);
            }
            else if (level == Level.Debug && Log.IsDebugEnabled)
            {
                Log.Debug(ex.Message, ex);
            }
            else if (level == Level.Fatal && Log.IsFatalEnabled)
            {
                Log.Fatal(ex.Message, ex);
            }
            else if (level == Level.Info && Log.IsInfoEnabled)
            {
                Log.Info(ex.Message, ex);
            }
            else if (level == Level.Warn && Log.IsWarnEnabled)
            {
                Log.Warn(ex.Message, ex);
            }
        }

        /// <summary>
        /// LogMessage which will write the log in specified file path.
        /// </summary>
        /// <param name="message"></param>
        /// <param name="level"></param>
        /// <param name="logFilePath"></param>
        public void LogMessage(string message, Level level, string logFilePath)
        {
            InitiateLogFilePath(logFilePath);

            if (level == Level.Error && Log.IsErrorEnabled)
            {
                Log.Error(message);
            }
            else if (level == Level.Debug && Log.IsDebugEnabled)
            {
                Log.Debug(message);
            }
            else if (level == Level.Fatal && Log.IsFatalEnabled)
            {
                Log.Fatal(message);
            }
            else if (level == Level.Info && Log.IsInfoEnabled)
            {
                Log.Info(message);
            }
            else if (level == Level.Warn && Log.IsWarnEnabled)
            {
                Log.Warn(message);
            }
        }

        /// <summary>
        /// LogException which will write the log in specified file path.
        /// </summary>
        /// <param name="ex"></param>
        /// <param name="level"></param>
        /// <param name="logFilePath"></param>
        public void LogException(Exception ex, Level level, string logFilePath)
        {
            InitiateLogFilePath(logFilePath);

            if (level == Level.Error && Log.IsErrorEnabled)
            {
                Log.Error(ex.Message, ex);
            }
            else if (level == Level.Debug && Log.IsDebugEnabled)
            {
                Log.Debug(ex.Message, ex);
            }
            else if (level == Level.Fatal && Log.IsFatalEnabled)
            {
                Log.Fatal(ex.Message, ex);
            }
            else if (level == Level.Info && Log.IsInfoEnabled)
            {
                Log.Info(ex.Message, ex);
            }
            else if (level == Level.Warn && Log.IsWarnEnabled)
            {
                Log.Warn(ex.Message, ex);
            }
        }

        /// <summary>
        /// This InitiateLogFilePath method will assign the specified log filepath and activate the Appender
        /// </summary>
        /// <param name="logFilePath"></param>
        private static void InitiateLogFilePath(string logFilePath)
        {
            if (!string.IsNullOrEmpty(logFilePath))
            {
                var h = (Hierarchy)LogManager.GetRepository();

                foreach (IAppender appender in h.Root.Appenders)
                {
                    if (appender is RollingFileAppender)
                    {
                        var rollingFileAppender = (RollingFileAppender)appender;
                        var logFileLocation = logFilePath;
                        rollingFileAppender.File = logFileLocation;
                        rollingFileAppender.ActivateOptions();
                        break;
                    }
                }
            }
        }

        public static void LogExit(object fileName, string v1, string v2)
        {
            throw new NotImplementedException();
        }

        /// <summary>
        /// Reset method which re-initialize the default log file path.
        /// </summary>
        public void Reset()
        {
            InitiateLogFilePath(defaultFilePath);
        }

        /// <summary>
        /// Set the default file path locally.
        /// </summary>
        private static void SetDefaultFileName()
        {
            var h = (Hierarchy)LogManager.GetRepository();

            foreach (IAppender appender in h.Root.Appenders)
            {
                if (appender is RollingFileAppender)
                {
                    var rollingFileAppender = (RollingFileAppender)appender;
                    defaultFilePath = rollingFileAppender.File;
                    break;
                }
            }
        }

        
        public void LogEntry(string levelInfo)
        {
            Log.Info((string.Format("Entry {0} : " , levelInfo)));           
        }

        public void LogExit(string levelInfo)
        {
            Log.Info((string.Format("Exit {0} : ", levelInfo)));
        }


        public static void LogEntry(string fileName, String methodName, string levelInfo)
        {
            Log.Info((string.Format("Entry: {0} - {1}- {2}", fileName, methodName, levelInfo)));

        }

        public static void LogExit(string fileName, String methodName, string levelInfo)
        {
            Log.Info((string.Format("Exit: {0} - {1} - {2}", fileName, methodName, levelInfo)));

        }
    }
}
