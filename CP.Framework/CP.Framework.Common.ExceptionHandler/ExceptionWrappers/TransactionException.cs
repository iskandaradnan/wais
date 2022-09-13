

using System;

namespace CP.Framework.Common.ExceptionHandler.ExceptionWrappers
{
    public class TransactionException : BaseException
    {
        public TransactionException()
            : base(new Exception("Problem in Transaction"), ExceptionTypes.TransactionException)
        {

        }

        public TransactionException(Exception ex)
            : base(ex, ExceptionTypes.TransactionException)
        {

        }

        public TransactionException(string errormessage)
            : base(new Exception(errormessage), ExceptionTypes.TransactionException)
        {

        }
    }
}
