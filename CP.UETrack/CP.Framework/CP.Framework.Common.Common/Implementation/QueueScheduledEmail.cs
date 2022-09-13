namespace CP.Framework.Common.SmartAssign.Implementation
{
    using Logging;
    using System;
    using System.Data;
    using System.Data.SqlClient;
    using Common;

    public class QueueScheduledEmail
    {
        private readonly Log4NetLogger _logger;
        private int processedCount = 0;
        public QueueScheduledEmail()
        {
            _logger = new Log4NetLogger();
        }

    }
}
