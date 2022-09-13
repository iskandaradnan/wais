using System;
using System.Net;

namespace CP.Framework.Common.ExceptionHandler.ExceptionWrappers
{
    public class HTTPException : BaseException
    {
        public HTTPException(Exception ex)
           : base(new Exception("Problem with web request : " + ex), ExceptionTypes.HTTPException)
        {

        }

        public HTTPException(WebException ex)
            : base(new Exception("Problem with web request : " + ex), ExceptionTypes.HTTPException)
        {

        }
    }
}
