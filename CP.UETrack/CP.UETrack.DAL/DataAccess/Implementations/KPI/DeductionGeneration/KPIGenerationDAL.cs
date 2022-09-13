
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
using CP.UETrack.Model.BEMS.AssetRegister;
using System.Collections.Generic;
using CP.UETrack.Models;

namespace CP.UETrack.DAL.DataAccess
{
    public class KPIGenerationDAL : IKPIGenerationDAL
    {
        private readonly string _FileName = nameof(KPIGenerationDAL);
        readonly UserDetailsModel _UserSession = new SessionHelper().UserSession();
        public KPIGenerationLovs Load()
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
                var kpiGenerationLovs = new KPIGenerationLovs();

                var currentYear = DateTime.Now.Year;
                var previousYear = currentYear - 1;
                kpiGenerationLovs.Years = new List<LovValue> { new LovValue { LovId = previousYear, FieldValue = previousYear.ToString() }, new LovValue { LovId = currentYear, FieldValue = currentYear.ToString() } };
                kpiGenerationLovs.CurrentYear = currentYear;
                var currentMonth = DateTime.Now.Month;
                kpiGenerationLovs.CurrentMonth = currentMonth;

                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_Dropdown_Others";
                        cmd.Parameters.AddWithValue("@pTableName", "KPIGeneration");

                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }
                if (ds.Tables.Count != 0 && ds.Tables[0].Rows.Count > 0)
                {
                    kpiGenerationLovs.Months = dbAccessDAL.GetLovRecords(ds.Tables[0]);
                    kpiGenerationLovs.Services = dbAccessDAL.GetLovRecords(ds.Tables[1]);
                    kpiGenerationLovs.CurrentYearMonths = (from n in kpiGenerationLovs.Months
                                                           where n.LovId <= currentMonth
                                                           select new LovValue
                                                           {
                                                               LovId = n.LovId,
                                                               FieldValue = n.FieldValue
                                                           }).ToList();
                }
                Log4NetLogger.LogExit(_FileName, nameof(Load), Level.Info.ToString());
                return kpiGenerationLovs;
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
        public MonthlyServiceFeeFetch GetMonthlyServiceFee(MonthlyServiceFeeFetch serviceFeeFetch)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(GetMonthlyServiceFee), Level.Info.ToString());
                MonthlyServiceFeeFetch monthlyServiceFee = null;

                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_KPIGeneration_GetById";
                        cmd.Parameters.AddWithValue("@pYear", serviceFeeFetch.Year);
                        cmd.Parameters.AddWithValue("@pMonth", serviceFeeFetch.Month);
                        cmd.Parameters.AddWithValue("@pCustomerId", _UserSession.CustomerId);
                        cmd.Parameters.AddWithValue("@pFacilityId", _UserSession.FacilityId);

                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }
                if (ds.Tables.Count != 0 && ds.Tables[0].Rows.Count > 0)
                {
                    monthlyServiceFee = new MonthlyServiceFeeFetch();
                    monthlyServiceFee.MonthlyServiceFee = Convert.ToDecimal(ds.Tables[0].Rows[0]["MonthlyServiceFee"]);
                    monthlyServiceFee.IsDeductionGenerated = Convert.ToInt32(ds.Tables[0].Rows[0]["IsDeductionGenerated"]);
                }
                Log4NetLogger.LogExit(_FileName, nameof(GetMonthlyServiceFee), Level.Info.ToString());
                return monthlyServiceFee;
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
        public KPIGeneration Save(KPIGeneration kpiGeneration, out string ErrorMessage)
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
                        cmd.CommandText = "uspFM_DedGenerationTxn_Save";
                        SqlParameter parameter = new SqlParameter();
                        cmd.Parameters.AddWithValue("@pYear", kpiGeneration.Year);
                        cmd.Parameters.AddWithValue("@pMonth", kpiGeneration.Month);
                        cmd.Parameters.AddWithValue("@pCustomerId", _UserSession.CustomerId);
                        cmd.Parameters.AddWithValue("@pServiceId", kpiGeneration.ServiceId);
                        cmd.Parameters.AddWithValue("@pFacilityId", _UserSession.FacilityId);
                        cmd.Parameters.AddWithValue("@pUserId", _UserSession.UserId);
                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }
               
                Log4NetLogger.LogExit(_FileName, nameof(Save), Level.Info.ToString());
                return kpiGeneration;
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
        public GridFilterResult GetAll(KPIGenerationFetch kpiGenerationFetch)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(GetAll), Level.Info.ToString());
                GridFilterResult filterResult = null;

                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_DedGenerationTxn_A";

                        cmd.Parameters.AddWithValue("@pYear", kpiGenerationFetch.Year);
                        cmd.Parameters.AddWithValue("@pMonth", kpiGenerationFetch.Month);
                        cmd.Parameters.AddWithValue("@pServiceId", kpiGenerationFetch.ServiceId);
                        cmd.Parameters.AddWithValue("@pFacilityId", _UserSession.FacilityId);
                        
                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }
                if (ds.Tables.Count != 0 && ds.Tables[0].Rows.Count > 0)
                {
                    var totalRecords = 7;
                    var totalPages = (int)Math.Ceiling((float)totalRecords / 10f);

                    var commonDAL = new CommonDAL();
                    var currentPageList = commonDAL.ToDynamicList(ds.Tables[0]);
                    filterResult = new GridFilterResult
                    {
                        TotalRecords = totalRecords,
                        TotalPages = totalPages,
                        RecordsList = currentPageList,
                        CurrentPage = "1"
                    };
                }
                Log4NetLogger.LogExit(_FileName, nameof(GetAll), Level.Info.ToString());
                return filterResult;
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
        public List<KPIGenerationRecord> GetAllRecords(KPIGenerationFetch kpiGenerationFetch)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(GetAll), Level.Info.ToString());
                List<KPIGenerationRecord> result = null;

                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_DedGenerationTxn_A";

                        cmd.Parameters.AddWithValue("@pYear", kpiGenerationFetch.Year);
                        cmd.Parameters.AddWithValue("@pMonth", kpiGenerationFetch.Month);
                        cmd.Parameters.AddWithValue("@pServiceId", kpiGenerationFetch.ServiceId);
                        cmd.Parameters.AddWithValue("@pFacilityId", _UserSession.FacilityId);

                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }
                if (ds.Tables.Count != 0 && ds.Tables[0].Rows.Count > 0)
                {
                    result = (from n in ds.Tables[0].AsEnumerable()
                              select new KPIGenerationRecord
                              {
                                IndicatorDetId = n.Field<int>("IndicatorDetId"),
                                IndicatorNo = n.Field<string>("IndicatorNo"),
                                IndicatorName = n.Field<string>("IndicatorName"), 
                                TotalDemeritPoints = n.Field<int>("TotalDemeritPoints"),
                                DeductionValue = n.Field<decimal>("DeductionValue"),
                                DeductionPer = n.Field<decimal>("DeductionPer")
                              }).ToList();
                }
                Log4NetLogger.LogExit(_FileName, nameof(GetAll), Level.Info.ToString());
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
        public List<KPIGenerationDemertis> GetDemeritPoints(KPIGenerationFetch KpiGenerationFetch)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(GetDemeritPoints), Level.Info.ToString());
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
                        cmd.CommandText = "uspFM_KpiGenerationTxn_Popup_DemeritPoints";

                        cmd.Parameters.AddWithValue("@pYear", KpiGenerationFetch.Year);
                        cmd.Parameters.AddWithValue("@pMonth", KpiGenerationFetch.Month);
                        cmd.Parameters.AddWithValue("@pServiceId", 2);
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

                    if (KpiGenerationFetch.IndicatorNo == "B.1" || KpiGenerationFetch.IndicatorNo == "B.2"
                        || KpiGenerationFetch.IndicatorNo == "B.3" || KpiGenerationFetch.IndicatorNo == "B.4")
                    {
                        result = (from n in ds.Tables[0].AsEnumerable()
                                  select new KPIGenerationDemertis
                                  {
                                      SerialNo = n.Field<int>("SerialNo"),
                                      ServiceWorkNo = n.Field<string>("ServiceWorkNo"),
                                      AssetNo = n.Field<string>("AssetNo"),
                                      AssetDescription = n.Field<string>("AssetDescription"),
                                      AssetTypeCode = n.Field<string>("AssetTypeCode"),
                                      UnderWarranty = n.Field<string>("UnderWarranty"),
                                      ServiceWorkDateTime = n.Field<DateTime?>("ServiceWorkDateTime"),
                                      ResponseDateTime = n.Field<DateTime?>("ResponseDateTime"),
                                      RepsonseDurationHrs = n.Field<decimal?>("RepsonseDurationHrs"),
                                      StartDateTime = n.Field<DateTime?>("StartDateTime"),
                                      EndDateTime = n.Field<DateTime?>("EndDateTime"),
                                      WorkOrderStatus = n.Field<string>("WorkOrderStatus"),
                                      DowntimeHrs = n.Field<decimal?>("DowntimeHrs"),
                                      DemeritPoint = n.Field<int>("DemeritPoint"),
                                      TotalRecords = totalRecords,
                                      FirstRecord = firstRecord,
                                      LastRecord = lastRecord,
                                      LastPageIndex = lastPageIndex
                                  }).ToList();
                    }
                    else if (KpiGenerationFetch.IndicatorNo == "B.5")
                    {
                        result = (from n in ds.Tables[0].AsEnumerable()
                                  select new KPIGenerationDemertis
                                  {
                                      SerialNo = n.Field<int>("SerialNo"),
                                      TCDate = n.Field<DateTime?>("TCDate"),
                                      TCDocumentNo = n.Field<string>("TCDocumentNo"),
                                      RequiredDateTime = n.Field<DateTime?>("RequiredDateTime"),
                                      TCCompletedDate = n.Field<DateTime?>("TCCompletedDate"),
                                      TCStatus = n.Field<string>("TCStatus"),

                                      TotalRecords = totalRecords,
                                      FirstRecord = firstRecord,
                                      LastRecord = lastRecord,
                                      LastPageIndex = lastPageIndex
                                  }).ToList();
                    }
                    else if (KpiGenerationFetch.IndicatorNo == "B.6")
                    {
                        result = (from n in ds.Tables[0].AsEnumerable()
                                  select new KPIGenerationDemertis
                                  {
                                      SerialNo = n.Field<int>("SerialNo"),
                                      Report = n.Field<string>("Report"),
                                      Remarks = n.Field<string>("Remarks"),
                                      DemeritPoint = n.Field<int>("DemeritPoint"),

                                      TotalRecords = totalRecords,
                                      FirstRecord = firstRecord,
                                      LastRecord = lastRecord,
                                      LastPageIndex = lastPageIndex
                                  }).ToList();
                    }
                }

                Log4NetLogger.LogExit(_FileName, nameof(GetDemeritPoints), Level.Info.ToString());
                return result;
            }
            catch (DALException dalex)
            {
                throw new DALException(dalex);
            }
            catch (Exception ex)
            {
                Log4NetLogger.LogEntry("ERROR", ex.Message + ex.InnerException, Level.Error.ToString());
                throw ex;
            }
        }
        public List<KPIGenerationDemertis> GetDeductionValues(KPIGenerationFetch KpiGenerationFetch)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(GetDeductionValues), Level.Info.ToString());
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
                        cmd.CommandText = "uspFM_KpiGenerationTxn_Popup_DeductionValue";

                        cmd.Parameters.AddWithValue("@pYear", KpiGenerationFetch.Year);
                        cmd.Parameters.AddWithValue("@pMonth", KpiGenerationFetch.Month);
                        cmd.Parameters.AddWithValue("@pServiceId", 2);
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
                                  //BEMSDedGenerationPopupId = n.Field<int>("BEMSDedGenerationPopupId"),
                                  SerialNo = n.Field<int>("SerialNo"),
                                  AssetNo = n.Field<string>("AssetNo"),
                                  PurchaseCostRM = n.Field<decimal?>("PurchaseCost"),
                                  DemeritValue1 = n.Field<int>("DemeritValue1"),
                                  DemeritPoint = n.Field<int>("DemeritPoint"),
                                  DeductionValue = n.Field<decimal?>("DeductionValue"),

                                  TotalRecords = totalRecords,
                                  FirstRecord = firstRecord,
                                  LastRecord = lastRecord,
                                  LastPageIndex = lastPageIndex
                              }).ToList();
                }

                Log4NetLogger.LogExit(_FileName, nameof(GetDeductionValues), Level.Info.ToString());
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
        public void Delete(int Id)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Delete), Level.Info.ToString());

                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_Test_Delete";
                        cmd.Parameters.AddWithValue("@Id", Id);

                        con.Open();
                        cmd.ExecuteNonQuery();
                        con.Close();
                    }
                }
                Log4NetLogger.LogExit(_FileName, nameof(Delete), Level.Info.ToString());
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
    }
}