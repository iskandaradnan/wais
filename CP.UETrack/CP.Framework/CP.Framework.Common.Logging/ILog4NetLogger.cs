using System;

namespace CP.Framework.Common.Logging
{
    public enum Level
    {
        Debug = 0,
        Error = 1,
        Fatal = 2,
        Info = 3,
        Warn = 4
    }

    public interface ILog4NetLogger
    {
        void LogMessage(string message, Level level);

        void LogException(Exception ex, Level level);

        void LogMessage(string message, Level level, string logFilePath);

        void LogException(Exception ex, Level level, string logFilePath);

        void LogEntry(string levelInfo);

        void LogExit(string levelInfo);

        void Reset();

     }
}
