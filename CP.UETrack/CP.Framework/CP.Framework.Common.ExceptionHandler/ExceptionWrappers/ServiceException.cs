using System;

namespace CP.Framework.Common.ExceptionHandler.ExceptionWrappers
{
    public class ServiceException : BaseException
    {

        public ServiceException()
            : base(new Exception("Problem with Service Layer"), ExceptionTypes.ServiceException)
        {

        }

        public ServiceException(Exception ex)
            : base(ex, ExceptionTypes.ServiceException)
        {

        }

        public ServiceException(string errormessage)
            : base(new Exception(errormessage), ExceptionTypes.ServiceException)
        {

        }
    }
}
