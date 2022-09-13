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
    public class KPITransactionMappingDAL : IKPITransactionMappingDAL
    {
        private readonly string _FileName = nameof(KPITransactionMappingDAL);
        readonly UserDetailsModel _UserSession = new SessionHelper().UserSession();
        public KPITransactionMappingLovs Load()
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
                var kPITransactionMappingLovs = new KPITransactionMappingLovs();

                var currentYear = DateTime.Now.Year;
                var previousYear = currentYear - 1;
                kPITransactionMappingLovs.Years = new List<LovValue> { new LovValue { LovId = previousYear, FieldValue = previousYear.ToString() }, new LovValue { LovId = currentYear, FieldValue = currentYear.ToString() } };
                kPITransactionMappingLovs.CurrentYear = currentYear;
                var currentMonth = DateTime.Now.Month;
                kPITransactionMappingLovs.CurrentMonth = currentMonth;

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
                    kPITransactionMappingLovs.Months = dbAccessDAL.GetLovRecords(ds.Tables[0]);
                    kPITransactionMappingLovs.Services = dbAccessDAL.GetLovRecords(ds.Tables[1]);
                    kPITransactionMappingLovs.CurrentYearMonths = (from n in kPITransactionMappingLovs.Months
                                                           where n.LovId <= currentMonth
                                                           select new LovValue
                                                           {
                                                               LovId = n.LovId,
                                                               FieldValue = n.FieldValue
                                                           }).ToList();
                    kPITransactionMappingLovs.Indicators = dbAccessDAL.GetLovRecords(ds.Tables[2]);
                }
                
                Log4NetLogger.LogExit(_FileName, nameof(Load), Level.Info.ToString());
                return kPITransactionMappingLovs;
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
        public List<KPITransactionFetchResult> FetchRecords(KPITransactionMapping kPITransactionMapping, out string ErrorMessage)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(FetchRecords), Level.Info.ToString());
                List<KPITransactionFetchResult> result = null;

                ErrorMessage = string.Empty;

                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "UspFM_DeductionTransactionMappingMst_Fetch";

                        cmd.Parameters.AddWithValue("@pYear", kPITransactionMapping.Year);
                        cmd.Parameters.AddWithValue("@pMonth", kPITransactionMapping.Month);
                        cmd.Parameters.AddWithValue("@pServiceId", kPITransactionMapping.ServiceId);
                        cmd.Parameters.AddWithValue("@pFacilityId", _UserSession.FacilityId);
                        cmd.Parameters.AddWithValue("@pIndicatorNo", kPITransactionMapping.IndicatorNo);
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
                              select new KPITransactionFetchResult
                              {
                                  SerialNo = n.Field<int>("SerialNo"),
                                  ServiceWorkDate = n.Field<DateTime?>("ServiceWorkDateTime"),
                                  ServiceWorkNo = n.Field<string>("ServiceWorkNo"),
                                  AssetNo = n.Field<string>("AssetNo"),
                                  AssetDescription = n.Field<string>("AssetDescription"),
                                  ScreenName = n.Field<string>("ScreenName"),
                                  GeneratedDemertiPoints = n.Field<int>("DemeritPoint"),
                                  FinalDemeritPoints = n.Field<int>("FinalDemerit"),
                                  IsValid = n.Field<int>("IsValid"),
                                  DisputedPendingResolution = n.Field<int>("DisputedPendingResolution"),
                                  Remarks = n.Field<string>("Remarks"),
                                  DeductionValue = n.Field<int>("DeductionValue"),
                                  DedGenerationId = n.Field<int>("DedGenerationId"),
                                  DedTxnMappingDetId = n.Field<int>("DedTxnMappingDetId"),
                                  DedTxnMappingId = n.Field<int>("DedTxnMappingId"),
                                  IsAdjustmentSaved = n.Field<bool>("IsAdjustmentSaved")
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
        public KPITransactions Save(KPITransactions kpiTransactions, out string ErrorMessage)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());

                bool isSave = false;
                var dedTxnMappingDetId = kpiTransactions.Transactions[0].DedTxnMappingDetId;

                isSave = dedTxnMappingDetId == 0;

                ErrorMessage = string.Empty;
                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_DeductionTransactionMappingMst_Save";

                        SqlParameter parameter = new SqlParameter();
                        cmd.Parameters.AddWithValue("@pDedGenerationId", kpiTransactions.TranscationMapping.DedGenerationId);
                        cmd.Parameters.AddWithValue("@pDedTxnMappingId", kpiTransactions.TranscationMapping.DedTxnMappingId);
                        cmd.Parameters.AddWithValue("@pYear", kpiTransactions.TranscationMapping.Year);
                        cmd.Parameters.AddWithValue("@pMonth", kpiTransactions.TranscationMapping.Month);
                        cmd.Parameters.AddWithValue("@pCustomerId", _UserSession.CustomerId);
                        cmd.Parameters.AddWithValue("@pFacilityId", _UserSession.FacilityId);
                        cmd.Parameters.AddWithValue("@pServiceId", kpiTransactions.TranscationMapping.ServiceId);
                        cmd.Parameters.AddWithValue("@pIndicatorDetId", kpiTransactions.TranscationMapping.IndicatorDetId);
                        cmd.Parameters.AddWithValue("@pUserId", _UserSession.UserId);

                        if (kpiTransactions.Transactions != null)
                        {

                            DataTable dataTable = new DataTable("udt_DeductionTransactionMappingMstDet");//DedTxnMappingDetId
                            dataTable.Columns.Add("DedTxnMappingDetId", typeof(int));
                            dataTable.Columns.Add("ServiceWorkDateTime", typeof(DateTime));
                            dataTable.Columns.Add("ServiceWorkNo", typeof(string));
                            dataTable.Columns.Add("AssetNo", typeof(string));
                            dataTable.Columns.Add("AssetDescription", typeof(string));
                            dataTable.Columns.Add("ScreenName", typeof(string));

                            dataTable.Columns.Add("DemeritPoint", typeof(int));
                            dataTable.Columns.Add("IsValid", typeof(int));
                            dataTable.Columns.Add("DisputedPendingResolution", typeof(int));
                            dataTable.Columns.Add("Remarks", typeof(string));
                            dataTable.Columns.Add("DeductionValue", typeof(int));
                            dataTable.Columns.Add("FinalDemerit", typeof(int));
                            //dataTable.Columns.Add("DedGenerationId", typeof(int));

                            foreach (var item in kpiTransactions.Transactions)
                            {
                                dataTable.Rows.Add(item.DedTxnMappingDetId, item.ServiceWorkDate, item.ServiceWorkNo, 
                                    item.AssetNo, item.AssetDescription, item.ScreenName, 
                                    item.GeneratedDemertiPoints, item.IsValid, item.DisputedPendingResolution, item.Remarks, 
                                    item.DeductionValue, item.FinalDemeritPoints);
                            }

                            parameter.ParameterName = "@DeductionTransactionMappingMstDet";
                            parameter.SqlDbType = SqlDbType.Structured;
                            parameter.Value = dataTable;
                            cmd.Parameters.Add(parameter);
                        }

                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }
                int dedTxnMappingId = 0;
                if (ds.Tables.Count != 0 && ds.Tables[0].Rows.Count > 0)
                {
                    dedTxnMappingId = Convert.ToInt32(ds.Tables[0].Rows[0]["DedTxnMappingId"]);
                }

                KPITransactions returnValue = null;
                if (isSave)
                {
                    returnValue = Get(dedTxnMappingId, 1, 5);
                }
                else
                {
                    returnValue = new KPITransactions();
                    returnValue.DedTxnMappingId = dedTxnMappingId;
                }

                Log4NetLogger.LogExit(_FileName, nameof(Save), Level.Info.ToString());
                return returnValue;
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
        public GridFilterResult GetAll(SortPaginateFilter pageFilter)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(GetAll), Level.Info.ToString());
                GridFilterResult filterResult = null;

                var multipleOrderBy = pageFilter.SortColumn.Split(',');
                var strOrderBy = string.Empty;
                foreach (var order in multipleOrderBy)
                {
                    strOrderBy += order + " " + pageFilter.SortOrder + ",";
                }
                if (!string.IsNullOrEmpty(strOrderBy))
                {
                    strOrderBy = strOrderBy.TrimEnd(',');
                }

                strOrderBy = string.IsNullOrEmpty(strOrderBy) ? pageFilter.SortColumn + " " + pageFilter.SortOrder : strOrderBy;

                var QueryCondition = pageFilter.QueryWhereCondition;
                var strCondition = string.Empty;
                if (string.IsNullOrEmpty(QueryCondition))
                {
                    strCondition = "FacilityId = " + _UserSession.FacilityId.ToString();
                }
                else
                {
                    strCondition = QueryCondition + " AND FacilityId = " + _UserSession.FacilityId.ToString();
                }

                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_DeductionTransactionMappingMst_GetAll";

                        cmd.Parameters.AddWithValue("@PageIndex", pageFilter.PageIndex);
                        cmd.Parameters.AddWithValue("@PageSize", pageFilter.PageSize);
                        cmd.Parameters.AddWithValue("@strCondition", strCondition);
                        cmd.Parameters.AddWithValue("@strSorting", strOrderBy);

                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }
                if (ds.Tables.Count != 0 && ds.Tables[0].Rows.Count > 0)
                {
                    var totalRecords = Convert.ToInt32(ds.Tables[0].Rows[0]["TotalRecords"]);
                    var totalPages = (int)Math.Ceiling((float)totalRecords / (float)pageFilter.Rows);

                    var commonDAL = new CommonDAL();
                    var currentPageList = commonDAL.ToDynamicList(ds.Tables[0]);
                    filterResult = new GridFilterResult
                    {
                        TotalRecords = totalRecords,
                        TotalPages = totalPages,
                        RecordsList = currentPageList,
                        CurrentPage = pageFilter.Page
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
        public KPITransactions Get(int Id, int PageIndex, int PageSize)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
                var kPITransactions = new KPITransactions();
                List<KPITransactionFetchResult> result = null;

                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "UspFM_DeductionTransactionMappingMst_GetbyId";
                        cmd.Parameters.AddWithValue("@pDedTxnMappingId", Id);
                        cmd.Parameters.AddWithValue("@pPageIndex", PageIndex);
                        cmd.Parameters.AddWithValue("@pPageSize", PageSize);
                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }

                if (ds.Tables.Count != 0 && ds.Tables[0].Rows.Count > 0)
                {
                    var totalRecords = Convert.ToInt32(ds.Tables[0].Rows[0]["TotalRecords"]);
                    var firstRecord = (PageIndex - 1) * PageSize + 1;
                    var lastRecord = (PageIndex - 1) * PageSize + ds.Tables[0].Rows.Count;
                    var lastPageIndex = totalRecords % PageSize == 0 ? totalRecords / PageSize : (totalRecords / PageSize) + 1;

                    result = (from n in ds.Tables[0].AsEnumerable()
                              select new KPITransactionFetchResult
                              {
                                  Year = n.Field<int>("Year"),
                                  Month =n.Field<int>("Month"),
                                  ServiceId = n.Field<int>("ServiceId"),
                                  IndicatorDetId = n.Field<int>("IndicatorDetId"),
                                  SerialNo = n.Field<int>("SerialNo"),
                                  ServiceWorkDate = n.Field<DateTime?>("ServiceWorkDateTime"),
                                  ServiceWorkNo = n.Field<string>("ServiceWorkNo"),
                                  AssetNo = n.Field<string>("AssetNo"),
                                  AssetDescription = n.Field<string>("AssetDescription"),
                                  ScreenName = n.Field<string>("ScreenName"),
                                  GeneratedDemertiPoints = n.Field<int>("DemeritPoint"),
                                  FinalDemeritPoints = n.Field<int>("FinalDemerit"),
                                  IsValid = n.Field<int>("IsValid"),
                                  DisputedPendingResolution = n.Field<int>("DisputedPendingResolution"),
                                  Remarks = n.Field<string>("Remarks"),
                                  DeductionValue = n.Field<int>("DeductionValue"),
                                  DedGenerationId = n.Field<int>("DedGenerationId"),
                                  DedTxnMappingDetId = n.Field<int>("DedTxnMappingDetId"),
                                  DedTxnMappingId = n.Field<int>("DedTxnMappingId"),
                                  IsAdjustmentSaved = n.Field<bool>("IsAdjustmentSaved"),

                                  PageIndex = PageIndex,
                                  PageSize = PageSize,
                                  TotalRecords = totalRecords,
                                  FirstRecord = firstRecord,
                                  LastRecord = lastRecord,
                                  LastPageIndex = lastPageIndex
                              }).ToList();

                    kPITransactions.Transactions = result;
                }
                Log4NetLogger.LogExit(_FileName, nameof(Get), Level.Info.ToString());
                return kPITransactions;
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