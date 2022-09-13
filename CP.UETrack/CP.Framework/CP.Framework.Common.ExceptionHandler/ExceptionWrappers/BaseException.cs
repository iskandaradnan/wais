using CP.Framework.Common.Logging;
using System;
using System.Reflection;

namespace CP.Framework.Common.ExceptionHandler.ExceptionWrappers
{
    public class BaseException : Exception
    {
        public BaseException(Exception ex, ExceptionTypes et) : base(ex.Message, ex)
        {
            var log = new Log4NetLogger();
            
            log.LogEntry("Begin: BaseException");
            
            log.LogMessage(string.Format("ExceptionType: {0}", et.ToString()), Level.Error);
            log.LogMessage(string.Format("Message: {0}", ex.Message), Level.Error);
            log.LogMessage(string.Format("StackTrace: {0}", ex.StackTrace), Level.Error);
            log.LogMessage("Details:", Level.Error);
            log.LogException(ex, Level.Error);

            if (ex.InnerException != null)
            {
                var innerEx = ex.InnerException;
                while (innerEx.InnerException != null)
                    innerEx = innerEx.InnerException;

                log.LogMessage("InnerException:", Level.Error);
                log.LogMessage(string.Format("Message: {0}", innerEx.Message), Level.Error);
                log.LogMessage(string.Format("StackTrace: {0}", innerEx.StackTrace), Level.Error);
                log.LogMessage("Details:", Level.Error);
                log.LogException(innerEx, Level.Error);
            }

            if (ex is ReflectionTypeLoadException)
            {
                var reflectiontypeLoadEx = ex as ReflectionTypeLoadException;
                log.LogMessage("LoaderException: ", Level.Error);                
                foreach (var loaderEx in reflectiontypeLoadEx.LoaderExceptions)                                    
                    log.LogMessage(loaderEx.Message, Level.Error);
            }

            log.LogExit("End: BaseException");
            log.LogExit("--------------------------------------------");
        }

    }
}
