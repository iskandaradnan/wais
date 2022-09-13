using CP.Framework.Common.ExceptionHandler.ExceptionWrappers;
using CP.Framework.Common.Logging;
using CP.UETrack.DAL.DataAccess.Contracts.BEMS;
using CP.UETrack.DAL.DataAccess.Implementation;
using CP.UETrack.DAL.DataAccess.Implementations.Common;
using CP.UETrack.Model;
using CP.UETrack.Model.BEMS;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using UETrack.DAL;

namespace CP.UETrack.DAL.DataAccess.Implementations.BEMS
{
    public class WarrantyManagementDAL : IWarrantyManagementDAL
    {
        private readonly string _FileName = nameof(WarrantyManagementDAL);
        readonly UserDetailsModel _UserSession = new SessionHelper().UserSession();
        public ServiceLov Load()
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
                ServiceLov warrantyManSerLovs = null;

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
                            warrantyManSerLovs = new ServiceLov();
                            warrantyManSerLovs.ServiceLovs = dbAccessDAL.GetLovRecords(ds.Tables[0]);
                        }
                    }
                }

                Log4NetLogger.LogExit(_FileName, nameof(Load), Level.Info.ToString());
                return warrantyManSerLovs;
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

        public WarrantyManagement Save(WarrantyManagement Warranty)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());
            try
            {
                //var Userid = 2;
                //var CustomerId = 1;
                //var FacilityId = 1;

                //var formatkey = "[ModuleName][ScreenName][YearMonth]";
                //var documentIdKeyFormat = new DocumentIdKeyFormat
                //{
                //    CompanyId = 1,
                //    HospitalId = 2,
                //    Year = DateTime.Now.Year,
                //    Month = DateTime.Now.Month,

                //    Formatkey = formatkey,

                //    ScreenName = "Biomedical Engineering Maintenance Services",
                //    ModuleName = "BEMS",
                //    AutoGenarateProp = "WarrantyNo"
                //};

                //var docnumber = AutoGenerateNumberDAL.AutoGenerate(Warranty, documentIdKeyFormat);

                //var docnum = (docnumber);
                var dbAccessDAL = new DBAccessDAL();
                var model = new WarrantyManagement();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@PWarrantyMgmtId", Convert.ToString(Warranty.WarrantyMgmtId));
                parameters.Add("@pUserid", Convert.ToString(_UserSession.UserId));
                parameters.Add("@CustomerId", Convert.ToString(_UserSession.CustomerId));
                parameters.Add("@FacilityId", Convert.ToString(_UserSession.FacilityId));
                parameters.Add("@ServiceId", Convert.ToString(Warranty.ServiceId));
                parameters.Add("@WarrantyNo", Convert.ToString(Warranty.WarrantyNo));
                //parameters.Add("@WarrantyNo", Convert.ToString(Warranty.WarrantyNo));
                parameters.Add("@WarrantyDate", Convert.ToString(Warranty.WarrantyDate));
                parameters.Add("@WarrantyDateUTC", Convert.ToString(Warranty.WarrantyDateUtc));
                parameters.Add("@AssetId", Convert.ToString(Warranty.AssetId));
                parameters.Add("@Remarks", Convert.ToString(Warranty.Remarks));
                parameters.Add("@pTimestamp", Convert.ToString(Warranty.Timestamp));

                DataTable ds = dbAccessDAL.GetDataTable("uspFM_EngWarrantyManagementTxn_Save", parameters, DataSetparameters);
                if (ds != null)
                {
                    foreach (DataRow row in ds.Rows)
                    {
                        Warranty.WarrantyMgmtId = Convert.ToInt32(row["WarrantyMgmtId"]);
                        Warranty.Timestamp = Convert.ToBase64String((byte[])(row["Timestamp"]));
                    }
                }

                Log4NetLogger.LogExit(_FileName, nameof(Save), Level.Info.ToString());
                return Warranty;
                //}
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
                        cmd.CommandText = "uspFM_EngWarrantyManagementTxn_GetAll";

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
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public WarrantyManagement Get(int Id)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
            try
            {

                var dbAccessDAL = new DBAccessDAL();

                WarrantyManagement entity = new WarrantyManagement();

                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pUserId", 1.ToString());
                parameters.Add("@pWarrantyMgmtId", Id.ToString());
                DataTable dt = dbAccessDAL.GetDataTable("UspFM_EngWarrantyManagementTxn_GetById", parameters, DataSetparameters);
                if (dt != null && dt.Rows.Count > 0)
                {
                    
                    entity.WarrantyMgmtId = Convert.ToInt16(dt.Rows[0]["WarrantyMgmtId"]);
                    entity.WarrantyNo = Convert.ToString(dt.Rows[0]["WarrantyNo"]);
                    entity.WarrantyDate = Convert.ToDateTime(dt.Rows[0]["WarrantyDate"] != DBNull.Value ? (Convert.ToDateTime(dt.Rows[0]["WarrantyDate"])) : (DateTime?)null);
                    entity.TnCRefNo = Convert.ToString(dt.Rows[0]["TandCDocumentNo"]);
                    entity.Service = Convert.ToString(dt.Rows[0]["ServiceKey"]);
                    entity.AssetId = Convert.ToInt32(dt.Rows[0]["AssetId"]);
                    entity.AssetNo = Convert.ToString(dt.Rows[0]["AssetNo"]);
                    entity.AssetClassification = Convert.ToString(dt.Rows[0]["AssetClassificationDescription"]);
                    entity.TypeCode = Convert.ToString(dt.Rows[0]["AssetTypeCode"]);
                    entity.AssetDescription = Convert.ToString(dt.Rows[0]["AssetDescription"]);
                    entity.WarrantyStartDate = Convert.ToDateTime(dt.Rows[0]["WarrantyStartDate"] != DBNull.Value ? (Convert.ToDateTime(dt.Rows[0]["WarrantyStartDate"])) : (DateTime?)null);
                    entity.WarrantyEndDate = Convert.ToDateTime(dt.Rows[0]["WarrantyEndDate"] != DBNull.Value ? (Convert.ToDateTime(dt.Rows[0]["WarrantyEndDate"])) : (DateTime?)null);
                    entity.WarrantyPeriod = Convert.ToInt32(dt.Rows[0]["WarrantyDuration"]);
                    entity.PurchaseCost = Convert.ToDouble(dt.Rows[0]["PurchaseCostRM"]);
                    entity.DWFee = Convert.ToDouble(dt.Rows[0]["MonthlyProposedFeeDW"]);
                    entity.PWFee = Convert.ToDouble(dt.Rows[0]["MonthlyProposedFeePW"]);
                    entity.WarrantyDownTime = Convert.ToDouble(dt.Rows[0]["DowntimeHoursMin"]);
                    entity.Remarks = Convert.ToString(dt.Rows[0]["Remarks"]);
                    entity.Timestamp = Convert.ToBase64String((byte[])(dt.Rows[0]["Timestamp"]));

                    if(entity.WarrantyDate == default(DateTime))
                    {
                        entity.IsWarrantyDateNull = true;
                    }
                    if (entity.WarrantyStartDate == default(DateTime))
                    {
                        entity.IsWarrStartDateNull = true;
                    }
                    if (entity.WarrantyEndDate == default(DateTime))
                    {
                        entity.IsWarrEndDateNull = true;
                    }

                }

                //entity.IsCalibrationDueDateNull((x) =>
                //{
                //    x.IsCalibrationDueDateNull = (x.CalibrationDueDate == default(DateTime));
                //});

                Log4NetLogger.LogExit(_FileName, nameof(Get), Level.Info.ToString());
                return entity;

            }
            catch (DALException dalex)
            {
                throw new DALException(dalex);
            }
            catch (Exception ex )
            {
                throw ex;
            }
        }

        //public bool IsRoleDuplicate(WarrantyManagement WarrantyProvider)
        //{
        //    return true;
        //}

        public bool IsRecordModified(WarrantyManagement WarrantyProvider)
        {
            try
            {

                Log4NetLogger.LogEntry(_FileName, nameof(IsRecordModified), Level.Info.ToString());
                var dbAccessDAL = new DBAccessDAL();
                var recordModifed = false;

                if (WarrantyProvider.WarrantyMgmtId != 0)
                {

                    var DataSetparameters = new Dictionary<string, DataTable>();
                    var parameters = new Dictionary<string, string>();
                    parameters.Add("@RescheduleWOId", WarrantyProvider.WarrantyMgmtId.ToString());
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

        public bool Delete(int Id)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Delete), Level.Info.ToString());
            try
            {
                var dbAccessDAL = new DBAccessDAL();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pWarrantyMgmtId", Id.ToString());
                DataTable dt = dbAccessDAL.GetDataTable("uspFM_EngWarrantyManagementTxn_Delete", parameters, DataSetparameters);
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
            catch (Exception)
            {
                throw;
            }

        }

        public WarrantyManagement GetDD(int Id, int pagesize, int pageindex)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
            try
            {

                var dbAccessDAL = new DBAccessDAL();
                WarrantyManagement entity = new WarrantyManagement();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pUserId", Convert.ToString(_UserSession.UserId));
                parameters.Add("@pWarrantyMgmtId", Id.ToString());
                parameters.Add("@pPageIndex", pageindex.ToString());
                parameters.Add("@pPageSize", pagesize.ToString());
                DataSet dt = dbAccessDAL.GetDataSet("UspFM_EngWarrantyManagementTxnDefect_GetById", parameters, DataSetparameters);
                if (dt != null && dt.Tables[0].Rows.Count > 0)
                {

                    entity.WMDefectDetailsGriddata = (from n in dt.Tables[0].AsEnumerable()
                                         select new WMDefectDetailsGrid
                                         {
                                             WarrantyMgmtetId = Convert.ToInt32(n["WarrantyMgmtId"]),
                                             DefectDate = Convert.ToDateTime(n["DefectDate"] != DBNull.Value ? (Convert.ToDateTime(n["DefectDate"])) : (DateTime?)null),
                                             DefectDetails = Convert.ToString(n["DefectDetails"] == System.DBNull.Value ? "" : n["DefectDetails"]),
                                             StartDate = Convert.ToDateTime(n["StartDate"] != DBNull.Value ? (Convert.ToDateTime(n["StartDate"])) : (DateTime?)null),
                                             IsCompleted = Convert.ToBoolean(n["IsCompleted"] == System.DBNull.Value ? 0 : n["IsCompleted"]),
                                             CompletionDate = Convert.ToDateTime(n["CompletionDate"] != DBNull.Value ? (Convert.ToDateTime(n["CompletionDate"])) : (DateTime?)null),
                                             ActionTaken = Convert.ToString(n["ActionTaken"] == System.DBNull.Value ? "" : n["ActionTaken"]),
                                             TotalRecords = Convert.ToInt32(n["TotalRecords"]),
                                             TotalPages = Convert.ToInt32(n["TotalPageCalc"]),
                                         }).ToList();

                    entity.WMDefectDetailsGriddata.ForEach((x) => {
                        x.IsDefectDateNull = (x.DefectDate == default(DateTime));
                        x.IsStartDateNull = (x.StartDate == default(DateTime));
                        x.IsCompletionDateNull = (x.CompletionDate == default(DateTime));
                        x.PageIndex = pageindex;
                        x.FirstRecord = ((pageindex - 1) * pagesize) + 1;
                        x.LastRecord = ((pageindex - 1) * pagesize) + pagesize;
                    });


                    //if (entity.WMDefectDetailsGriddata != null && entity.WMDefectDetailsGriddata.Count > 0)
                    //{
                    //    entity.WMDefectDetailsGriddata = entity.WMDefectDetailsGriddata;
                    //}
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

        public WarrantyManagement GetWO(int Id, int pagesize, int pageindex)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
            try
            {

                var dbAccessDAL = new DBAccessDAL();
                WarrantyManagement entity = new WarrantyManagement();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pUserId", Convert.ToString(_UserSession.UserId));
                parameters.Add("@pWarrantyMgmtId", Id.ToString());
                parameters.Add("@pPageIndex", 1.ToString());
                parameters.Add("@pPageSize", 10.ToString());
                DataSet dt = dbAccessDAL.GetDataSet("UspFM_EngWarrantyManagementTxnWO_GetById", parameters, DataSetparameters);
                if (dt != null && dt.Tables[0].Rows.Count > 0)
                {

                    entity.WMWorkorderGriddata = (from n in dt.Tables[0].AsEnumerable()
                                          select new WMWOrkOrderGrid
                                          {

                                              WorkorderNo = Convert.ToString(n["MaintenanceWorkNo"] == System.DBNull.Value ? "" : n["MaintenanceWorkNo"]),
                                              WorkorderType = Convert.ToString(n["WorkOrderType"] == System.DBNull.Value ? "" : n["WorkOrderType"]),
                                              ResponseDate = Convert.ToDateTime(n["ResponseDateTime"] != DBNull.Value ? (Convert.ToDateTime(n["ResponseDateTime"])) : (DateTime?)null),
                                              TargetDate = Convert.ToDateTime(n["TargetDateTime"] != DBNull.Value ? (Convert.ToDateTime(n["TargetDateTime"])) : (DateTime?)null),
                                              CompletionDate = Convert.ToDateTime(n["CompletionDatetime"] != DBNull.Value ? (Convert.ToDateTime(n["CompletionDatetime"])) : (DateTime?)null),
                                              WorkorderStatus = Convert.ToString(n["WorkOrderStatus"] == System.DBNull.Value ? "" : n["WorkOrderStatus"]),
                                               TotalRecords = Convert.ToInt32(n["TotalRecords"]),
                                              TotalPages = Convert.ToInt32(n["TotalPageCalc"]),
                                          }).ToList();

                    entity.WMWorkorderGriddata.ForEach((x) => {
                        x.IsResposeDateNull = (x.ResponseDate == default(DateTime));
                        x.IsTargetDateNull = (x.TargetDate == default(DateTime));
                        x.IsCompDateNull = (x.CompletionDate == default(DateTime));
                        x.PageIndex = pageindex;
                        x.FirstRecord = ((pageindex - 1) * pagesize) + 1;
                        x.LastRecord = ((pageindex - 1) * pagesize) + pagesize;
                    });

                    //if (entity.WMWorkorderGriddata != null && entity.WMWorkorderGriddata.Count > 0)
                    //{
                    //    entity.WMWorkorderGriddata = entity.WMWorkorderGriddata;
                    //}
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
