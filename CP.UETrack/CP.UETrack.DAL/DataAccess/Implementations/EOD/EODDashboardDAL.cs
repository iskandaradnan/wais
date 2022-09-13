using CP.UETrack.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using CP.Framework.Common.Logging;
using CP.Framework.Common.ExceptionHandler.ExceptionWrappers;
using CP.UETrack.Models;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using UETrack.DAL;
using System.Dynamic;
using CP.UETrack.DAL.DataAccess.Implementation;
using CP.UETrack.Model.BEMS;

namespace CP.UETrack.DAL.DataAccess
{
   
    public class EODDashboardDAL : IEODDashboardDAL
    {
        private readonly string _FileName = nameof(EODDashboardDAL);
        readonly UserDetailsModel _UserSession = new SessionHelper().UserSession();

        public EODDashboardDAL()
        {

        }
        public EODDashboardViewModel Load(int Year, int Month)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
            try
            {
                var dbAccessDAL = new DBAccessDAL();
                EODDashboardViewModel entity = new EODDashboardViewModel();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pFromYear", Year.ToString());
                parameters.Add("@pFromMonth", Month.ToString());
                parameters.Add("@pToYear", Year.ToString());
                parameters.Add("@pToMonth", Month.ToString());
                parameters.Add("@pFacilityId", Convert.ToString(_UserSession.FacilityId));

                DataSet dt = dbAccessDAL.GetDataSet("uspFM_EngEOD_DashBoard", parameters, DataSetparameters);
                if (dt != null && dt.Tables[0].Rows.Count > 0)
                {

                    entity.DashboardGridData = (from n in dt.Tables[0].AsEnumerable()
                                                 select new DashboardGrid
                                                 {
                                                     CategorySystemId = Convert.ToInt32(n["CategorySystemId"]),
                                                     CategorySystemName = Convert.ToString(n["CategorySystemName"]),
                                                     Pass = Convert.ToInt32(n["Pass"]),
                                                     Fail = Convert.ToInt32(n["Fail"]),                                                     
                                                 }).ToList();

                }
                return entity;
            }
            catch (DALException dalex)
            {
                throw new DALException(dalex);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }


        public EODDashboardViewModel getChartData(int NoofMonths, int FacilityId)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
            try
            {
                var dbAccessDAL = new DBAccessDAL();
                EODDashboardViewModel entity = new EODDashboardViewModel();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pNoOfMonth", NoofMonths.ToString());
                parameters.Add("@pFacilityId", Convert.ToString(_UserSession.FacilityId));

                DataSet dt = dbAccessDAL.GetDataSet("uspFM_EngEOD_DashBoard_Chart", parameters, DataSetparameters);
                if (dt != null && dt.Tables[0].Rows.Count > 0)
                {

                    entity.DashboardGridData = (from n in dt.Tables[0].AsEnumerable()
                                                select new DashboardGrid
                                                {
                                                    Month = Convert.ToInt32(n["Month"]),
                                                    MonthName = Convert.ToString(n["MonthName"]),
                                                    Year = Convert.ToInt32(n["Year"]),
                                                    Pass = Convert.ToInt32(n["BEMSPassCount"]),
                                                    Fail = Convert.ToInt32(n["BEMSFailCount"]),
                                                    Total = Convert.ToInt32(n["BEMSTotalCount"]),
                                                    PassPerc = Convert.ToDecimal(n["BEMSPassPercentage"]),
                                                }).ToList();

                }
                return entity;
            }
            catch (DALException dalex)
            {
                throw new DALException(dalex);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
    }
}
