using System;

namespace CP.Framework.Common.ExceptionHandler.ExceptionWrappers
{
    public class DALException : BaseException
    {

        public DALException()
            : base(new Exception("Problem with Data Access Layer"), ExceptionTypes.DalException)
        {

        }

        public DALException(Exception ex)
            : base(ex, ExceptionTypes.DalException)
        {

        }

        public DALException(string errormessage)
            : base(new Exception(errormessage), ExceptionTypes.DalException)
        {

        }
    }
}
