using CP.UETrack.DAL.DataAccess.Contracts.KPI;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using CP.UETrack.Model.KPI;
using CP.UETrack.Model;
using CP.Framework.Common.Logging;
using CP.UETrack.Models;
using System.Data.SqlClient;
using System.Data;
using UETrack.DAL;
using CP.Framework.Common.ExceptionHandler.ExceptionWrappers;

namespace CP.UETrack.DAL.DataAccess.Implementations.KPI
{
    public class KPIDashboardDAL: IKPIDashboardDAL
    {
        private readonly string _FileName = nameof(KPIDashboardDAL);
        readonly UserDetailsModel _UserSession = new SessionHelper().UserSession();

        public KPIDashboardModel Get(int Year)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
            try
            {
                var dbAccessDAL = new DBAccessDAL();
                var KPIDashboardObj = new KPIDashboardModel();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pFacilityId", Convert.ToString(_UserSession.FacilityId));
                parameters.Add("@pYear", Convert.ToString(Year));
               
                DataTable dt = dbAccessDAL.GetDataTable("uspFM_Deduction_DashBoard_Chart", parameters, DataSetparameters);
                if (dt != null && dt.Rows.Count > 0)
                {
                    //KPIDashboardObj.Year = Convert.ToInt32(dt.Rows[0]["Year"]);
                }
                DataSet dt1 = dbAccessDAL.GetDataSet("uspFM_Deduction_DashBoard_Chart", parameters, DataSetparameters);
                if (dt1 != null && dt1.Tables.Count > 0)
                {
                    KPIDashboardObj.KPIDashboardChartListData = (from n in dt1.Tables[0].AsEnumerable()
                                                            select new ItemKPIDashboardChartList
                                                            {
                                                                //Year = Convert.ToInt32(n["Year"]),
                                                                MonthId = Convert.ToInt32(n["MonthId"]),
                                                                MonthName = Convert.ToString(n["MonthName"]),
                                                                MSF = Convert.ToDecimal(n["MSF"]),
                                                                DeductionPercentage = Convert.ToDecimal(n["DeductionPercentage"]),
                                                                DeductionValue = Convert.ToDecimal(n["DeductionValue"]),
                                                                //PenaltyValue = Convert.ToDecimal(n["PenaltyValue"]),
                                                                //PenaltyPercentage = Convert.ToDecimal(n["PenaltyPercentage"]),
                                                            }).ToList();

                }
                Log4NetLogger.LogExit(_FileName, nameof(Get), Level.Info.ToString());
                return KPIDashboardObj;

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

        public KPIDashboardModel GetDate(int Year, int Month)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(GetDate), Level.Info.ToString());
            try
            {
                var dbAccessDAL = new DBAccessDAL();
                var KPIDashboardObj = new KPIDashboardModel();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pFacilityId",Convert.ToString(_UserSession.FacilityId));
                parameters.Add("@pYear", Convert.ToString(Year));
                parameters.Add("@pMonth",Convert.ToString(Month));
                DataTable dt = dbAccessDAL.GetDataTable("uspFM_Deduction_DashBoard", parameters, DataSetparameters);
                if (dt != null && dt.Rows.Count > 0)
                {
                    //KPIDashboardObj.Year = Year;
                    //KPIDashboardObj.Month = Month;
                    //KPIDashboardObj.ServiceId = Convert.ToInt32(dt.Rows[0]["ServiceId"]);
                }
                DataSet dt1 = dbAccessDAL.GetDataSet("uspFM_Deduction_DashBoard", parameters, DataSetparameters);
                if (dt1 != null && dt1.Tables.Count > 0)
                {
                    KPIDashboardObj.KPIDashboardListData = (from n in dt1.Tables[0].AsEnumerable()
                                                            select new ItemKPIDashboardList
                                                            {
                                                                //Year = Year,
                                                                //Month=Month,
                                                                ServiceName = Convert.ToString(n["Service"]),
                                                                MSF = Convert.ToDecimal(n["MSF"]),
                                                                DeductionPercentage = Convert.ToDecimal(n["DeductionPercentage"]),
                                                                DeductionValue = Convert.ToDecimal(n["DeductionValue"]),
                                                                //PenaltyValue = Convert.ToDecimal(n["PenaltyValue"]),
                                                                //PenaltyPercentage = Convert.ToDecimal(n["PenaltyPercentage"]),
                                                            }).ToList();

                }
                Log4NetLogger.LogExit(_FileName, nameof(GetDate), Level.Info.ToString());
                return KPIDashboardObj;

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

        public KPIDashboardTypeDropdown Load()
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
                var KPIDashboardTypeDropdown = new KPIDashboardTypeDropdown();

                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                var currentYear = DateTime.Now.Year;
                var nextYear = currentYear + 1;
                var preYear = currentYear - 1;
                KPIDashboardTypeDropdown.Years = new List<LovValue> { new LovValue { LovId = preYear, FieldValue = preYear.ToString() }, new LovValue { LovId = currentYear, FieldValue = currentYear.ToString() }, new LovValue { LovId = nextYear, FieldValue = nextYear.ToString() } };
                KPIDashboardTypeDropdown.CurrentYear = currentYear;
                KPIDashboardTypeDropdown.PreviousYear = preYear;


                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_Dropdown_Others";
                        cmd.Parameters.AddWithValue("@pTablename", "FinMonthlyFeeTxn");
                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);

                        if (ds.Tables.Count != 0)
                        {
                            KPIDashboardTypeDropdown.MonthListTypedata = dbAccessDAL.GetLovRecords(ds.Tables[0]);
                        }

                    }
                }


                Log4NetLogger.LogExit(_FileName, nameof(Load), Level.Info.ToString());
                return KPIDashboardTypeDropdown;
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
