using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CP.Framework.Common.ExceptionHandler.ExceptionWrappers
{
    public class ConcurrencyException : BaseException
    {
        public ConcurrencyException()
            : base(new Exception("Problem with Data Access Layer"), ExceptionTypes.ConcurrencyException)
        {

        }

        public ConcurrencyException(Exception ex)
            : base(ex, ExceptionTypes.ConcurrencyException)
        {

        }

        public ConcurrencyException(string errormessage)
            : base(new Exception(errormessage), ExceptionTypes.ConcurrencyException)
        {

        }
    }
}
