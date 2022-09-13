using CP.UETrack.DAL.DataAccess.Contracts.KPI;
using CP.UETrack.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using CP.UETrack.Model.KPI;
using CP.Framework.Common.Logging;
using System.Data;
using UETrack.DAL;
using System.Data.SqlClient;
using CP.Framework.Common.ExceptionHandler.ExceptionWrappers;
using CP.UETrack.DAL.DataAccess.Implementation;
using CP.UETrack.Models;

namespace CP.UETrack.DAL.DataAccess.Implementations.KPI
{
    public class MonthlyServiceFeeDAL: IMonthlyServiceFeeDAL
    {
        private readonly string _FileName = nameof(MonthlyServiceFeeDAL);
        readonly UserDetailsModel _UserSession = new SessionHelper().UserSession();

        public MonthlyServiceFeeTypeDropdown Load()
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
                var MonthlyServiceFeeTypeDropdown = new MonthlyServiceFeeTypeDropdown();                

                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                var currentYear = DateTime.Now.Year;
                var nextYear = currentYear + 1;
                MonthlyServiceFeeTypeDropdown.Yearss = new List<LovValue> { new LovValue { LovId = currentYear, FieldValue = currentYear.ToString() }, new LovValue { LovId = nextYear, FieldValue = nextYear.ToString() } };                
                MonthlyServiceFeeTypeDropdown.CurrentYear = currentYear;                             

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
                            MonthlyServiceFeeTypeDropdown.MonthListTypedata = dbAccessDAL.GetLovRecords(ds.Tables[0]);
                        }                       

                    }
                }
                

                Log4NetLogger.LogExit(_FileName, nameof(Load), Level.Info.ToString());
                return MonthlyServiceFeeTypeDropdown;
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
                        cmd.CommandText = "uspFM_FinMonthlyFeeTxn_GetAll";  //Change SP Name

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
                //return userRoles;
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

        public MonthlyServiceFeeModel Save(MonthlyServiceFeeModel ServiceFee, out string ErrorMessage)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());
                ErrorMessage = string.Empty;
                var dbAccessDAL = new DBAccessDAL();
                var parameters = new Dictionary<string, string>();
                
                parameters.Add("@pMonthlyFeeId", Convert.ToString(ServiceFee.MonthlyFeeId));
                parameters.Add("@CustomerId", Convert.ToString(_UserSession.CustomerId));
                parameters.Add("@FacilityId", Convert.ToString(_UserSession.FacilityId));
                parameters.Add("@Year", Convert.ToString(ServiceFee.Year));
                parameters.Add("@VersionNo", Convert.ToString(ServiceFee.VersionNo));
                parameters.Add("@pUserId", Convert.ToString(_UserSession.UserId)); 
                parameters.Add("@pTimestamp", Convert.ToString(ServiceFee.Timestamp));

                var DataSetparameters = new Dictionary<string, DataTable>();
                DataTable dt = new DataTable();
                dt.Columns.Add("MonthlyFeeDetId", typeof(int));
                dt.Columns.Add("CustomerId", typeof(int));
                dt.Columns.Add("FacilityId", typeof(int));
                dt.Columns.Add("Month", typeof(int));
                dt.Columns.Add("VersionNo", typeof(int));
                dt.Columns.Add("BemsMSF", typeof(decimal));
                dt.Columns.Add("BemsCF", typeof(decimal));
                dt.Columns.Add("BemsPercent", typeof(decimal));
                dt.Columns.Add("TotalFee", typeof(decimal));
                dt.Columns.Add("FemsMSF", typeof(decimal));
                dt.Columns.Add("FemsCF", typeof(decimal));
                dt.Columns.Add("FemsPercent", typeof(decimal));
                dt.Columns.Add("IsAmdGenerated", typeof(bool));
                dt.Columns.Add("AmdUserId", typeof(int));                
                dt.Columns.Add("AmdDate", typeof(DateTime));
                dt.Columns.Add("AmdDateUTC", typeof(DateTime));

                //dt.Columns.Add("UserId", typeof(int));

                foreach (var i in ServiceFee.MonthlyServiceFeeListData)
                {
                    dt.Rows.Add(i.MonthlyFeeDetId, _UserSession.CustomerId, _UserSession.FacilityId, i.Month, i.VersionNo, i.BemsMSF, i.BemsCF, i.BemsPercent, i.TotalFee,
                        i.FemsMSF, i.FemsCF, i.FemsPercent, i.IsAmdGenerated, i.AmdUserId, /*i.AmdDate, i.AmdDateUTC*/ "10/10/2010", "10/10/2010");

                    //dt.Rows.Add(i.MonthlyFeeDetId, CustomerId, FacilityId, 10, 1, 5.5, 5.6, 5.7, 5.8, 5.9, 4.1, 4.2, 0, 2, "10/10/2010", "10/10/2010");

                }

                DataSetparameters.Add("@FinMonthlyFeeTxnDet", dt);
                DataTable dt1 = dbAccessDAL.GetDataTable("uspFM_FinMonthlyFeeTxn_Save", parameters, DataSetparameters);
                if (dt1 != null)
                {
                    foreach (DataRow row in dt1.Rows)
                    {
                        foreach (var val in ServiceFee.MonthlyServiceFeeListData)

                        {
                            //val.MonthlyFeeId = Convert.ToInt32(row["MonthlyFeeId"]);
                            ServiceFee.MonthlyFeeId = Convert.ToInt32(row["MonthlyFeeId"]);
                            ServiceFee.Timestamp = Convert.ToBase64String((byte[])(row["Timestamp"]));
                            ErrorMessage = Convert.ToString(row["ErrorMessage"]);
                        }
                    }
                }

                Log4NetLogger.LogExit(_FileName, nameof(Save), Level.Info.ToString());
                return ServiceFee;
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

        public MonthlyServiceFeeModel Get(int Id)                           // use one
        {            
            Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
            try
            {
                var dbAccessDAL = new DBAccessDAL();
                var entity = new MonthlyServiceFeeModel();

                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pYear", Convert.ToString(Id));
                parameters.Add("@pFacilityId", Convert.ToString(_UserSession.FacilityId));

                DataTable dt1 = dbAccessDAL.GetDataTable("UspFM_FinMonthlyFeeTxn_GetById", parameters, DataSetparameters);
                if (dt1 != null && dt1.Rows.Count > 0)
                {
                    entity.MonthlyFeeId = Convert.ToInt32(dt1.Rows[0]["MonthlyFeeId"]);
                    entity.FacilityId = Convert.ToInt32(dt1.Rows[0]["FacilityId"]);
                    entity.FacilityName = Convert.ToString(dt1.Rows[0]["FacilityName"]);
                    entity.Year = Convert.ToInt16(dt1.Rows[0]["Year"]);
                    entity.Timestamp = Convert.ToBase64String((byte[])(dt1.Rows[0]["Timestamp"]));
                }
                DataSet dt = dbAccessDAL.GetDataSet("UspFM_FinMonthlyFeeTxn_GetById", parameters, DataSetparameters);
                if (dt != null && dt.Tables.Count > 0)
                {

                    entity.MonthlyServiceFeeListData = (from n in dt.Tables[0].AsEnumerable()
                                                select new ItemMonthlyServiceFeeList
                                                {
                                                    MonthlyFeeMonth= Convert.ToString(n["MonthlyFeeMonth"]),
                                                    MonthlyFeeId = Convert.ToInt32(n["MonthlyFeeId"]),
                                                    Month = Convert.ToInt32(n["Month"]),
                                                    BemsMSF = Convert.ToDecimal(n["BemsMSF"]),
                                                    BemsCF = Convert.ToDecimal(n["BemsCF"]),             //Amendmentfee
                                                    DeductionMSF = Convert.ToDecimal(n["BemsKPIF"]),             //Deductionfee
                                                    TotalFee = Convert.ToDecimal(n["TotalFee"]),
                                                    MonthlyFeeDetId = Convert.ToInt32(n["MonthlyFeeDetId"])
                                                    //Timestamp = Convert.ToBase64String((byte[])(n["Timestamp"]))
                                                }).ToList();

                }
                Log4NetLogger.LogExit(_FileName, nameof(Get), Level.Info.ToString());
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

        public bool Delete(int Id)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Delete), Level.Info.ToString());
            try
            {
                var dbAccessDAL = new DBAccessDAL();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pMonthlyFeeId", Id.ToString());
                DataTable dt = dbAccessDAL.GetDataTable("uspFM_FinMonthlyFeeTxn_Delete", parameters, DataSetparameters);//sp name change
                if (dt != null && dt.Rows.Count > 0)
                {
                    string Message = Convert.ToString(dt.Rows[0]["Message"]);
                }
                Log4NetLogger.LogExit(_FileName, nameof(Delete), Level.Info.ToString());
                return true;
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

        public bool IsMonthlyServiceFeeCodeDuplicate(MonthlyServiceFeeModel ServiceFee)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(IsMonthlyServiceFeeCodeDuplicate), Level.Info.ToString());

                var IsDuplicate = true;
                var dbAccessDAL = new DBAccessDAL();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@RescheduleWOId", ServiceFee.MonthlyFeeId.ToString());
                //parameters.Add("@RescheduleWOCode", RescheduleWO.WorkOrderNo.ToString());
                DataTable dt = dbAccessDAL.GetDataTable("UspFM_RescheduleWO_ValCode", parameters, DataSetparameters); //change sp name
                if (dt != null && dt.Rows.Count > 0)
                {
                    IsDuplicate = Convert.ToBoolean(dt.Rows[0]["IsDuplicate"]);
                }
                return IsDuplicate;
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

        public bool IsRecordModified(MonthlyServiceFeeModel ServiceFee)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(IsRecordModified), Level.Info.ToString());
                var dbAccessDAL = new DBAccessDAL();
                var recordModifed = false;

                if (ServiceFee.MonthlyFeeId != 0)
                {

                    var DataSetparameters = new Dictionary<string, DataTable>();
                    var parameters = new Dictionary<string, string>();
                    parameters.Add("@RescheduleWOId", ServiceFee.MonthlyFeeId.ToString());
                    parameters.Add("@Operation", "GetTimestamp");
                    DataTable dt = dbAccessDAL.GetDataTable("UspFM_RescheduleWO_Get", parameters, DataSetparameters);//change sp name

                    if (dt != null && dt.Rows.Count > 0)
                    {
                        var timestamp = Convert.ToBase64String((byte[])(dt.Rows[0]["Timestamp"]));
                        //if (timestamp != RescheduleWO.Timestamp)
                        //{
                        recordModifed = true;
                        //}
                    }
                }

                Log4NetLogger.LogExit(_FileName, nameof(IsRecordModified), Level.Info.ToString());
                return recordModifed;
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

        public MonthlyServiceFeeModel GetRevision(int Id, int Year)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(GetRevision), Level.Info.ToString());
            try
            {
                var dbAccessDAL = new DBAccessDAL();
                var entity = new MonthlyServiceFeeModel();

                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pFacilityId", Convert.ToString(_UserSession.FacilityId));
                parameters.Add("@pVersionNo", Convert.ToString(Id));
                parameters.Add("@pYear", Convert.ToString(Year));
                

                DataTable dt1 = dbAccessDAL.GetDataTable("UspFM_FinMonthlyFeeTxnRevision_GetById", parameters, DataSetparameters);
                if (dt1 != null && dt1.Rows.Count > 0)
                {
                    entity.MonthlyFeeId = Convert.ToInt16(dt1.Rows[0]["MonthlyFeeId"]);
                    entity.FacilityId = Convert.ToInt16(dt1.Rows[0]["FacilityId"]);
                    entity.Year = Year;
                    entity.VersionNo= Id;
                    entity.Timestamp = Convert.ToBase64String((byte[])(dt1.Rows[0]["Timestamp"]));
                }
                DataSet dt = dbAccessDAL.GetDataSet("UspFM_FinMonthlyFeeTxnRevision_GetById", parameters, DataSetparameters);
                if (dt != null && dt.Tables.Count > 0)
                {

                    entity.MonthlyServiceFeeListData = (from n in dt.Tables[0].AsEnumerable()
                                                        select new ItemMonthlyServiceFeeList
                                                        {
                                                            VersionNo = Id,
                                                            MonthlyFeeMonth = Convert.ToString(n["MonthlyFeeMonth"]),
                                                            Month = Convert.ToInt32(n["Month"]),
                                                            BemsMSF = Convert.ToDecimal(n["BemsMSF"]),
                                                            BemsCF = Convert.ToDecimal(n["BemsCF"]),
                                                            TotalFee = Convert.ToDecimal(n["TotalFee"]),
                                                            MonthlyFeeDetId = Convert.ToInt32(n["MonthlyFeeDetId"])
                                                            //Timestamp = Convert.ToBase64String((byte[])(n["Timestamp"]))
                                                        }).ToList();

                }
                Log4NetLogger.LogExit(_FileName, nameof(GetRevision), Level.Info.ToString());
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

        public MonthlyServiceFeeModel GetVersion(int Year)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(GetVersion), Level.Info.ToString());
            try
            {
                var dbAccessDAL = new DBAccessDAL();
                var entity = new MonthlyServiceFeeModel();
                var MonthlyServiceFeeTypeDropdown = new MonthlyServiceFeeTypeDropdown();                
                var ds = new DataSet();                
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_FinMonthlyFeeTxn_GetByVersionId";
                        cmd.Parameters.AddWithValue("@pFacilityId", _UserSession.FacilityId);
                        cmd.Parameters.AddWithValue("@pYear", Year);
                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);

                        if (ds.Tables.Count != 0)
                        {
                            entity.VersionListData = dbAccessDAL.GetLovRecords(ds.Tables[0]);
                        }

                    }
                }
             
                Log4NetLogger.LogExit(_FileName, nameof(GetVersion), Level.Info.ToString());
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
