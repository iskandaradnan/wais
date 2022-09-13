using System;

namespace CP.Framework.Common.ExceptionHandler.ExceptionWrappers
{
    public class GeneralException : BaseException
    {
        public GeneralException()
            : base(new Exception("General Exception"), ExceptionTypes.GeneralException)
        {

        }

        public GeneralException(Exception ex)
            : base(ex, ExceptionTypes.GeneralException)
        {

        }

        public GeneralException(string errormessage)
            : base(new Exception(errormessage), ExceptionTypes.GeneralException)
        {

        }
    }
}
