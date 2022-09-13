using CP.Framework.Common.ExceptionHandler.ExceptionWrappers;
using CP.Framework.Common.Logging;
using CP.UETrack.DAL.DataAccess.Contracts.QAP;
using CP.UETrack.Model;
using CP.UETrack.Model.QAP;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using UETrack.DAL;

namespace CP.UETrack.DAL.DataAccess.Implementations.QAP
{
    public class QAPDashboardDAL : IQAPDashboardDAL
    {
        private readonly string _FileName = nameof(QAPDashboardDAL);
        readonly UserDetailsModel _UserSession = new SessionHelper().UserSession();

        public QAPDashboardTypeDropdown Load()
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
                var QAPDashboardTypeDropdown = new QAPDashboardTypeDropdown();

                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_Dropdown_Others";
                        cmd.Parameters.AddWithValue("@pTablename", "Service");
                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);

                        if (ds.Tables.Count != 0)
                        {                            
                            QAPDashboardTypeDropdown.QAPDashboardServiceTypeData = dbAccessDAL.GetLovRecords(ds.Tables[0]);
                        }
                    }
                }

                Log4NetLogger.LogExit(_FileName, nameof(Load), Level.Info.ToString());
                return QAPDashboardTypeDropdown;
            }
            catch (DALException dalex)
            {
                throw new DALException(dalex);
            }
            catch (Exception)
            {
                throw;
            }
        }

        public QAPDashboardModel Get(int Year)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
            try
            {
                var dbAccessDAL = new DBAccessDAL();
                var QAPIndicatorObj = new QAPDashboardModel();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pFacilityId", _UserSession.FacilityId.ToString());
                parameters.Add("@pYear", Year.ToString());
                DataTable dt = dbAccessDAL.GetDataTable("uspFM_QAP_DashBoard", parameters, DataSetparameters);
                if (dt != null && dt.Rows.Count > 0)
                {
                    QAPIndicatorObj.Year = Year;
                    QAPIndicatorObj.QAPIndicatorId = Convert.ToInt16(dt.Rows[0]["QAPIndicatorId"]);                                        
                    //QAPIndicatorObj.Timestamp = Convert.ToBase64String((byte[])(dt.Rows[0]["Timestamp"]));
                }
                DataSet dt1 = dbAccessDAL.GetDataSet("uspFM_QAP_DashBoard", parameters, DataSetparameters);
                if (dt1 != null && dt1.Tables.Count > 0)
                {
                    QAPIndicatorObj.QAPBarChartListData = (from n in dt1.Tables[0].AsEnumerable()
                                                           select new ItemQAPBarChartList
                                                           {
                                                               Year = Year,
                                                               QAPIndicatorId = Convert.ToInt32(n["QAPIndicatorId"]),
                                                               IndicatorCode = Convert.ToString(n["IndicatorCode"]),
                                                               ExceptedPercentage = Convert.ToDecimal(n["ExceptedPercentage"]),
                                                               ActualPercentage=Convert.ToDecimal(n["ActualPercentage"]),
                                                           }).ToList();
                }
                Log4NetLogger.LogExit(_FileName, nameof(Get), Level.Info.ToString());
                return QAPIndicatorObj;

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

        public QAPDashboardModel GetLineChart(int Month)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(GetLineChart), Level.Info.ToString());
            try
            {
                var dbAccessDAL = new DBAccessDAL();
                var QAPDashObj = new QAPDashboardModel();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pFacilityId", _UserSession.FacilityId.ToString());
                parameters.Add("@pNoOfMonth", Month.ToString());
                DataTable dt = dbAccessDAL.GetDataTable("uspFM_QAP_DashBoard_Chart", parameters, DataSetparameters);
                if (dt != null && dt.Rows.Count > 0)
                {
                    QAPDashObj.Month = Month;
                    QAPDashObj.FacilityId = _UserSession.FacilityId;
                    //QAPIndicatorObj.Timestamp = Convert.ToBase64String((byte[])(dt.Rows[0]["Timestamp"]));
                }
                DataSet dt1 = dbAccessDAL.GetDataSet("uspFM_QAP_DashBoard_Chart", parameters, DataSetparameters);
                if (dt1 != null && dt1.Tables.Count > 0)
                {
                    QAPDashObj.QAPLineChartListData = (from n in dt1.Tables[0].AsEnumerable()
                                                           select new ItemQAPLineChartList
                                                           {
                                                               Month= Month,
                                                               Year = Convert.ToInt32(n["Year"]),
                                                               MonthName = Convert.ToString(n["MonthName"]),
                                                               B1 = Convert.ToDecimal(n["B1"]),
                                                               B2 = Convert.ToDecimal(n["B2"]),
                                                               B1Percent = Convert.ToDecimal(n["B1Percent"]),
                                                               B2Percent = Convert.ToDecimal(n["B2Percent"]),
                                                           }).ToList();
                }
                Log4NetLogger.LogExit(_FileName, nameof(GetLineChart), Level.Info.ToString());
                return QAPDashObj;

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
