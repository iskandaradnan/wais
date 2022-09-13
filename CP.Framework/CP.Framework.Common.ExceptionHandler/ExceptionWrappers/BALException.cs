using System;

namespace CP.Framework.Common.ExceptionHandler.ExceptionWrappers
{
    public class BALException : BaseException
    {

        public BALException()
            : base(new Exception("Problem with Business Access Layer"), ExceptionTypes.BalException)
        {

        }

        public BALException(Exception ex)
            : base(ex, ExceptionTypes.BalException)
        {

        }

        public BALException(string errormessage)
            : base(new Exception(errormessage), ExceptionTypes.BalException)
        {

        }

    }
}
