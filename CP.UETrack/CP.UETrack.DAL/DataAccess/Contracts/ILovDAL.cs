using CP.UETrack.DAL.Model;
using System;
using System.Collections.Generic;

namespace CP.UETrack.DAL.DataAccess
{
    public interface ILovDAL
    {
        /// <summary>
        /// Get the lovlist based on lovkey value from the cache, used to fill the dropdown.
        /// </summary>
        /// <typeparam name="AsisSysLovMst"></typeparam>
        /// <param name="lovKeyValue"></param>        
        /// <returns>IEnumerable<T> where T is base on generic type</returns>
        IEnumerable<T> GetLov<T>(string lovKeyValue,bool isSelect=true) where T : class;

        /// <summary>
        /// Get dynamic lovlist of year value.
        /// </summary>
        /// <returns>IEnumerable<SelectListLookup></returns>
        IEnumerable<T> GetYearLov<T>(int currentYear) where T : class;

        /// <summary>
        /// Fetch all records(records used to fill the dropdown) from database and set in cache when the login page load.
        /// </summary>        
        IEnumerable<UETrackSysLovMst> GeCachedData();
    }
}
