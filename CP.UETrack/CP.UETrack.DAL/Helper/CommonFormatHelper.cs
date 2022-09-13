using System;
using System.Data;

namespace CP.UETrack.DAL.DataAccess
{
    public static class CommonFormatHelper
    {

        public static DateTime getCommonDateFormat(DateTime dateTime) {

           // return dateTime.Date;
            return dateTime;
        }

        public static DateTime returnCommonDateFormat(DateTime dateTime)
        {
             return dateTime.Date;            
        }
    }
}