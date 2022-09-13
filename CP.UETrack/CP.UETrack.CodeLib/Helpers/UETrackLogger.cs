namespace CP.UETrack.CodeLib.Helpers
{
    using CP.Framework.Common.Logging;
    using System;
    using System.Reflection;

    public static class UETrackLogger
    {
        static Log4NetLogger logger = new Log4NetLogger();

        public static void Log(Exception ex)
        {
            logger.LogException(ex, Level.Error);
            logger.LogMessage(string.Format("AsisLogger ExceptionType: {0}", ex.ToString()), Level.Error);
            logger.LogMessage(string.Format("AsisLogger Message: {0}", ex.Message), Level.Error);
            logger.LogMessage(string.Format("AsisLogger StackTrace: {0}", ex.StackTrace), Level.Error);
            logger.LogMessage("AsisLogger Details:", Level.Error);
            logger.LogException(ex, Level.Error);

            if (ex.InnerException != null)
            {
                var innerEx = ex.InnerException;
                while (innerEx.InnerException != null)
                    innerEx = innerEx.InnerException;

                logger.LogMessage("AsisLogger InnerException:", Level.Error);
                logger.LogMessage(string.Format("AsisLogger Message: {0}", innerEx.Message), Level.Error);
                logger.LogMessage(string.Format("AsisLogger StackTrace: {0}", innerEx.StackTrace), Level.Error);
                logger.LogMessage("AsisLogger Details:", Level.Error);
                logger.LogException(innerEx, Level.Error);
            }

            if (ex is ReflectionTypeLoadException)
            {
                var reflectiontypeLoadEx = ex as ReflectionTypeLoadException;
                logger.LogMessage("AsisLogger LoaderException: ", Level.Error);
                foreach (var loaderEx in reflectiontypeLoadEx.LoaderExceptions)
                    logger.LogMessage(loaderEx.Message, Level.Error);
            }
        }

        public static void Log(string s)
        {
            logger.LogMessage(s, Level.Info);
        }

        public static void Log(string s1, string s2)
        {
            logger.LogMessage(string.Format("{0} - {1}", s1, s2), Level.Info);
        }

        public static void Log(string s1, string s2, string s3)
        {
            logger.LogMessage(string.Format("{0} - {1} - {2}", s1, s2, s3), Level.Info);            
        }


    }

}
