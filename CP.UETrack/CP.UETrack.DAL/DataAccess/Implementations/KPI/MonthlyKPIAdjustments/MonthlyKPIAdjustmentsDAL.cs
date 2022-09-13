using CP.UETrack.Model;
using System;
using System.Linq;
using CP.Framework.Common.Logging;
using CP.Framework.Common.ExceptionHandler.ExceptionWrappers;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using UETrack.DAL;
using CP.UETrack.DAL.DataAccess.Implementation;
using System.Collections.Generic;
using CP.UETrack.Models;

namespace CP.UETrack.DAL.DataAccess
{
    public class MonthlyKPIAdjustmentsDAL : IMonthlyKPIAdjustmentsDAL
    {
        private readonly string _FileName = nameof(MonthlyKPIAdjustmentsDAL);
        readonly UserDetailsModel _UserSession = new SessionHelper().UserSession();
        public MonthlyKPIAdjustmentsLovs Load()
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
                var monthlyKPIAdjustmentsLovs = new MonthlyKPIAdjustmentsLovs();

                var currentYear = DateTime.Now.Year;
                var previousYear = currentYear - 1;
                monthlyKPIAdjustmentsLovs.Years = new List<LovValue> { new LovValue { LovId = previousYear, FieldValue = previousYear.ToString() }, new LovValue { LovId = currentYear, FieldValue = currentYear.ToString() } };
                monthlyKPIAdjustmentsLovs.CurrentYear = currentYear;
                var currentMonth = DateTime.Now.Month;
                monthlyKPIAdjustmentsLovs.CurrentMonth = currentMonth;

                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_Dropdown_Others";
                        cmd.Parameters.AddWithValue("@pLovKey", "");
                        cmd.Parameters.AddWithValue("@pTableName", "KPIGeneration");

                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }

                if (ds.Tables.Count != 0)
                {
                    monthlyKPIAdjustmentsLovs.Months = dbAccessDAL.GetLovRecords(ds.Tables[0]);
                    monthlyKPIAdjustmentsLovs.Services = dbAccessDAL.GetLovRecords(ds.Tables[1]);
                    monthlyKPIAdjustmentsLovs.CurrentYearMonths = (from n in monthlyKPIAdjustmentsLovs.Months
                                                                   where n.LovId <= currentMonth
                                                                   select new LovValue
                                                                   {
                                                                       LovId = n.LovId,
                                                                       FieldValue = n.FieldValue
                                                                   }).ToList();
                }

                Log4NetLogger.LogExit(_FileName, nameof(Load), Level.Info.ToString());
                return monthlyKPIAdjustmentsLovs;
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
        public MonthlyKPIAdjustments Save(MonthlyKPIAdjustments monthlyKPIAdjustments, out string ErrorMessage)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());

                ErrorMessage = string.Empty;
                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_DedGenerationTxn_AdjustmentSave";

                        SqlParameter parameter = new SqlParameter();
                        cmd.Parameters.AddWithValue("@pYear", monthlyKPIAdjustments.Year);
                        cmd.Parameters.AddWithValue("@pMonth", monthlyKPIAdjustments.Month);
                        cmd.Parameters.AddWithValue("@pServiceId", monthlyKPIAdjustments.ServiceId);
                        cmd.Parameters.AddWithValue("@pFacilityId", _UserSession.FacilityId);
                        cmd.Parameters.AddWithValue("@pRemarks", monthlyKPIAdjustments.Remarks);
                        cmd.Parameters.AddWithValue("@pUserId", monthlyKPIAdjustments.UserId);
                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }
                if (ds.Tables.Count != 0 && ds.Tables[0].Rows.Count > 0)
                {
                    ErrorMessage = Convert.ToString(ds.Tables[0].Rows[0]["ErrorMessage"]);
                    monthlyKPIAdjustments.DocumentNo = Convert.ToString(ds.Tables[0].Rows[0]["DocumentNo"]);
                }

                Log4NetLogger.LogExit(_FileName, nameof(Save), Level.Info.ToString());
                return monthlyKPIAdjustments;
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
        public List<MonthlyKPIAdjustmentFetchResult> FetchRecords(MonthlyKPIAdjustments monthlyKPIAdjustments, out string ErrorMessage)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(FetchRecords), Level.Info.ToString());
                List<MonthlyKPIAdjustmentFetchResult> result = null;

                ErrorMessage = string.Empty;

                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_DedGenerationTxn_AdjustmentFetch";

                        cmd.Parameters.AddWithValue("@pYear", monthlyKPIAdjustments.Year);
                        cmd.Parameters.AddWithValue("@pMonth", monthlyKPIAdjustments.Month);
                        cmd.Parameters.AddWithValue("@pServiceId", monthlyKPIAdjustments.ServiceId);
                        cmd.Parameters.AddWithValue("@pFacilityId", _UserSession.FacilityId);
                        cmd.Parameters.Add("@pErrorMessage", SqlDbType.NVarChar);
                        cmd.Parameters["@pErrorMessage"].Size = 1000;
                        cmd.Parameters["@pErrorMessage"].Direction = ParameterDirection.Output;

                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                        ErrorMessage = cmd.Parameters["@pErrorMessage"].Value.ToString();
                    }
                }
                if (ds.Tables.Count != 0 && ds.Tables[0].Rows.Count > 0)
                {
                    result = (from n in ds.Tables[0].AsEnumerable()
                              select new MonthlyKPIAdjustmentFetchResult
                              {
                                  IsAdjustmentSaved = n.Field<int>("IsAdjustmentSaved"),
                                  IndicatorNo = n.Field<string>("IndicatorNo"),
                                  IndicatorName = n.Field<string>("IndicatorName"),
                                  TotalDemeritPoints = n.Field<int>("TotalDemeritPoints"),
                                  DeductionValue = n.Field<decimal>("DeductionValue"),
                                  DeductionPer = n.Field<decimal>("DeductionPer"),
                                  PostDemeritPoints = n.Field<int>("PostDemeritPoints"),
                                  PostDeductionValue = n.Field<decimal>("PostDeductionValue"),
                                  PostDeductionPer = n.Field<decimal>("PostDeductionPer"),
                                  DocumentNo = n.Field<string>("DocumentNo"),
                                  Remarks = n.Field<string>("Remarks")
                              }).ToList();
                }

                Log4NetLogger.LogExit(_FileName, nameof(FetchRecords), Level.Info.ToString());
                return result;
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
        public List<KPIGenerationDemertis> GetPostDemeritPoints(KPIGenerationFetch KpiGenerationFetch)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(GetPostDemeritPoints), Level.Info.ToString());
                List<KPIGenerationDemertis> result = null;
                var pageIndex = KpiGenerationFetch.PageIndex;
                var pageSize = Convert.ToInt32(ConfigurationManager.AppSettings["FetchPopupPageSize"]);

                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_DeductionAdjustment_DemeritpointFetch";

                        cmd.Parameters.AddWithValue("@pYear", KpiGenerationFetch.Year);
                        cmd.Parameters.AddWithValue("@pMonth", KpiGenerationFetch.Month);
                        cmd.Parameters.AddWithValue("@pServiceId", KpiGenerationFetch.ServiceId);
                        cmd.Parameters.AddWithValue("@pFacilityId", _UserSession.FacilityId);
                        cmd.Parameters.AddWithValue("@pIndicatorNo", KpiGenerationFetch.IndicatorNo);
                        cmd.Parameters.AddWithValue("@pPageIndex", pageIndex);
                        cmd.Parameters.AddWithValue("@pPageSize", pageSize);

                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }
                if (ds.Tables.Count != 0 && ds.Tables[0].Rows.Count > 0)
                {
                    var totalRecords = Convert.ToInt32(ds.Tables[0].Rows[0]["TotalRecords"]);
                    var firstRecord = (pageIndex - 1) * pageSize + 1;
                    var lastRecord = (pageIndex - 1) * pageSize + ds.Tables[0].Rows.Count;
                    var lastPageIndex = totalRecords % pageSize == 0 ? totalRecords / pageSize : (totalRecords / pageSize) + 1;

                    result = (from n in ds.Tables[0].AsEnumerable()
                              select new KPIGenerationDemertis
                              {
                                  DocumentNo = n.Field<string>("DocumentNo"),
                                  FinalDemeritPoint = n.Field<int>("FinalDemeritPoint"),

                                  TotalRecords = totalRecords,
                                  FirstRecord = firstRecord,
                                  LastRecord = lastRecord,
                                  LastPageIndex = lastPageIndex
                              }).ToList();
                }

                Log4NetLogger.LogExit(_FileName, nameof(GetPostDemeritPoints), Level.Info.ToString());
                return result;
            }
            catch (DALException dalex)
            {
                throw new DALException(dalex);
            }
            catch (Exception ex)
            {
                Log4NetLogger.LogEntry("ERROR", ex.Message + ex.InnerException, Level.Error.ToString());
                throw;
            }
        }
    }
}