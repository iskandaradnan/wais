using CP.UETrack.DAL.DataAccess.Contracts.BEMS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using CP.UETrack.Model.BEMS;
using CP.UETrack.Model;
using CP.Framework.Common.Logging;
using UETrack.DAL;
using System.Data;
using CP.Framework.Common.ExceptionHandler.ExceptionWrappers;
using System.Data.SqlClient;
using CP.UETrack.DAL.DataAccess.Implementation;
using CP.UETrack.DAL.DataAccess.Implementations.Common;

namespace CP.UETrack.DAL.DataAccess.Implementations.BEMS
{
    public class StockAdjustmentDAL : IStockAdjustmentDAL
    {
        private readonly string _FileName = nameof(StockAdjustmentDAL);
        readonly UserDetailsModel _UserSession = new SessionHelper().UserSession();

        public bool Delete(int Id)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Delete), Level.Info.ToString());
            try
            {
                var dbAccessDAL = new DBAccessDAL();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pStockAdjustmentId", Id.ToString());
                DataTable dt = dbAccessDAL.GetDataTable("UspFM_EngStockAdjustmentTxn_Delete", parameters, DataSetparameters);
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

        public StockAdjustmentModel Get(int Id, int pagesize , int pageindex)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
            try
            {
                StockAdjustmentModel entity = new StockAdjustmentModel();                
                var dbAccessDAL = new DBAccessDAL();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
               
                parameters.Add("@pUserId", Convert.ToString(_UserSession.UserId));
                parameters.Add("@pStockAdjustmentId", Convert.ToString(Id));
                parameters.Add("@pPageIndex", Convert.ToString(pageindex));
                parameters.Add("@pPageSize", Convert.ToString(pagesize));

                DataTable dt = dbAccessDAL.GetDataTable("UspFM_EngStockAdjustmentTxn_GetById", parameters, DataSetparameters);
                if (dt != null && dt.Rows.Count > 0)
                {
                    entity.StockAdjustmentId = Convert.ToInt32(dt.Rows[0]["StockAdjustmentId"]);
                    entity.ApprovalStatus = Convert.ToInt32(dt.Rows[0]["ApprovalStatus"]);
                    entity.StockAdjustmentNo = Convert.ToString(dt.Rows[0]["StockAdjustmentNo"]);
                    entity.AdjustmentDate = Convert.ToDateTime(dt.Rows[0]["AdjustmentDate"] != DBNull.Value ? (Convert.ToDateTime(dt.Rows[0]["AdjustmentDate"])) : (DateTime?)null);
                    entity.ApprovedBy = Convert.ToString(dt.Rows[0]["ApprovedBy"]);
                    entity.ApprovedDate = Convert.ToDateTime(dt.Rows[0]["ApprovedDate"] != DBNull.Value ? (Convert.ToDateTime(dt.Rows[0]["ApprovedDate"])) : (DateTime?)null);
                    entity.FacilityId = Convert.ToInt32(dt.Rows[0]["FacilityId"]);
                    entity.FacilityCode = Convert.ToString(dt.Rows[0]["FacilityCode"]);
                    entity.FacilityName = Convert.ToString(dt.Rows[0]["FacilityName"]);                                       
                    //entity.Timestamp = Convert.ToBase64String((byte[])(dt.Rows[0]["Timestamp"]));
                }
                DataSet dt1 = dbAccessDAL.GetDataSet("UspFM_EngStockAdjustmentTxn_GetById", parameters, DataSetparameters);
                if (dt != null && dt1.Tables.Count > 0)
                {
                    entity.StockAdjustmentGridList = (from n in dt1.Tables[0].AsEnumerable()
                                                   select new ItemStockAdjustmentList
                                                   {
                                                       StockAdjustmentId = Convert.ToInt32(n["StockAdjustmentId"]),
                                                       StockAdjustmentNo = Convert.ToString(n["StockAdjustmentNo"]),                                                       
                                                       AdjustmentDate = Convert.ToDateTime(n["AdjustmentDate"] != DBNull.Value ? (Convert.ToDateTime(n["AdjustmentDate"])) : (DateTime?)null),
                                                       ApprovedBy = Convert.ToString(n["ApprovedBy"]),                                                       
                                                       ApprovedDate = Convert.ToDateTime(n["ApprovedDate"] != DBNull.Value ? (Convert.ToDateTime(n["ApprovedDate"])) : (DateTime?)null),
                                                       FacilityCode = Convert.ToString(n["FacilityCode"]),
                                                       FacilityName = Convert.ToString(n["FacilityName"]),
                                                       PartNo = Convert.ToString(n["PartNo"]),
                                                       PartDescription = Convert.ToString(n["PartDescription"]),
                                                       ItemCode = Convert.ToString(n["ItemNo"]),
                                                       ItemDescription = Convert.ToString(n["ItemDescription"]),
                                                       BinNo = Convert.ToString(n["BinNo"]),
                                                       QuantityFacility = Convert.ToDecimal(n["QuantityInFacility"]),
                                                       PhysicalQuantity = Convert.ToInt32(n["PhysicalQuantity"]),
                                                       Variance = Convert.ToDecimal(n["Variance"]),
                                                       AdjustedQuantity = Convert.ToDecimal(n["AdjustedQuantity"]),
                                                       Cost = Convert.ToDecimal(n["Cost"]),
                                                       PurchaseCost = Convert.ToDecimal(n["PurchaseCost"]),
                                                       InvoiceNo = Convert.ToString(n["InvoiceNo"]),
                                                       VendorName = Convert.ToString(n["VendorName"]),
                                                       Remarks = Convert.ToString(n["Remarks"]),
                                                       StockAdjustmentDetId= Convert.ToInt32(n["StockAdjustmentDetId"]),
                                                       StockUpdateDetId = Convert.ToInt32(n["StockUpdateDetId"]),
                                                       SparePartsId = Convert.ToInt32(n["SparePartsId"]),
                                                       ApprovalStatus= Convert.ToInt32(n["ApprovalStatus"]),

                                                       TotalRecords = Convert.ToInt32(n["TotalRecords"]),
                                                       TotalPages = Convert.ToInt32(n["TotalPageCalc"]),
                                                       //Timestamp = Convert.ToBase64String((byte[])(n["Timestamp"]))
                                                   }).ToList();

                    entity.StockAdjustmentGridList.ForEach((x) => {
                       // entity.TotalCost = x.TotalCost;
                        x.PageIndex = pageindex;
                        x.FirstRecord = ((pageindex - 1) * pagesize) + 1;
                        x.LastRecord = ((pageindex - 1) * pagesize) + pagesize;
                        x.Remarks = x.Remarks == null ? string.Empty : x.Remarks;
                    });

                }
                entity.isAdjustmentDateNull = (entity.AdjustmentDate == default(DateTime));
                entity.isApprovedDateNull = (entity.ApprovedDate == default(DateTime));
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

        public StockAdjustmentModel Save(StockAdjustmentModel Adjustment, out string ErrorMessage)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());
                var ServiceId = 2;
                ErrorMessage = string.Empty;

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
                //    AutoGenarateProp = "StockAdjustmentNo"
                //};
                //var docnumber = AutoGenerateNumberDAL.AutoGenerate(Adjustment, documentIdKeyFormat);

                var dbAccessDAL = new DBAccessDAL();                
                var parameters = new Dictionary<string, string>();              
                parameters.Add("@pStockAdjustmentId", Convert.ToString(Adjustment.StockAdjustmentId));
                parameters.Add("@pUserId", Convert.ToString(_UserSession.UserId));
                parameters.Add("@CustomerId", Convert.ToString(_UserSession.CustomerId));
                parameters.Add("@FacilityId", Convert.ToString(_UserSession.FacilityId));
                parameters.Add("@ServiceId", Convert.ToString(ServiceId));
                parameters.Add("@StockAdjustmentNo", Convert.ToString(Adjustment.StockAdjustmentNo));
                parameters.Add("@AdjustmentDate", Adjustment.AdjustmentDate != null ? Adjustment.AdjustmentDate.ToString("yyyy-MM-dd") : null);
                parameters.Add("@AdjustmentDateUTC", Adjustment.AdjustmentDate != null ? Adjustment.AdjustmentDate.ToString("yyyy-MM-dd") : null);
                parameters.Add("@ApprovalStatus", Convert.ToString(Adjustment.ApprovalStatus));
                if (Adjustment.Approved == true)
                {
                    parameters.Add("@ApprovedBy", Convert.ToString(_UserSession.UserName));
                }
                else
                {
                    parameters.Add("@ApprovedBy", Convert.ToString(null));
                }
                parameters.Add("@ApprovedDate", Adjustment.ApprovedDate != null ? Adjustment.ApprovedDate?.ToString("yyyy-MM-dd") : null);
                parameters.Add("@ApprovedDateUTC", Adjustment.ApprovedDate != null ? Adjustment.ApprovedDate?.ToString("yyyy-MM-dd") : null);
                parameters.Add("@Submitted", Convert.ToString(Adjustment.Submitted));
                parameters.Add("@Approved", Convert.ToString(Adjustment.Approved));
                parameters.Add("@Rejected", Convert.ToString(Adjustment.Rejected));

                var DataSetparameters = new Dictionary<string, DataTable>();
                DataTable dt = new DataTable();
                dt.Columns.Add("StockAdjustmentDetId", typeof(int));
                dt.Columns.Add("CustomerId", typeof(int));
                dt.Columns.Add("FacilityId", typeof(int));
                dt.Columns.Add("ServiceId", typeof(int));
                dt.Columns.Add("StockAdjustmentId", typeof(int));
                //dt.Columns.Add("StockUpdateId", typeof(int));
                dt.Columns.Add("StockUpdateDetId", typeof(int));
                dt.Columns.Add("SparePartsId", typeof(int));
                dt.Columns.Add("PhysicalQuantity", typeof(decimal));
                dt.Columns.Add("Variance", typeof(decimal));
                dt.Columns.Add("AdjustedQuantity", typeof(decimal));
                dt.Columns.Add("Cost", typeof(decimal));
                dt.Columns.Add("PurchaseCost", typeof(decimal));
                dt.Columns.Add("InvoiceNo", typeof(string));
                dt.Columns.Add("Remarks", typeof(string));
                dt.Columns.Add("VendorName", typeof(string));                
                dt.Columns.Add("UserId", typeof(int));

                var deletedId = Adjustment.StockAdjustmentGridList.Where(y => y.IsDeleted).Select(x => x.StockAdjustmentDetId).ToList();
                var idstring = string.Empty;
                if (deletedId.Count() > 0)
                {
                    foreach (var item in deletedId.Select((value, i) => new { i, value }))
                    {
                        idstring += item.value;
                        if (item.i != deletedId.Count() - 1)
                        { idstring += ","; }
                    }
                    deleteChildRecords(idstring);
                }


                foreach (var i in Adjustment.StockAdjustmentGridList.Where(y => !y.IsDeleted))
                {
                    dt.Rows.Add(i.StockAdjustmentDetId, _UserSession.CustomerId, _UserSession.FacilityId, ServiceId, i.StockAdjustmentId, i.StockUpdateDetId, i.SparePartsId, i.PhysicalQuantity,
                        i.Variance, i.AdjustedQuantity, i.Cost, i.PurchaseCost, i.InvoiceNo, i.Remarks, i.VendorName, _UserSession.UserId);

                    //dt.Rows.Add(i.StockAdjustmentDetId, 1, 1, 2, i.StockAdjustmentId, 18, 32, 7, 10, 25, 25, 5, 5, "tts", "tst", "tst");
                }

                DataSetparameters.Add("@EngStockAdjustmentTxnDet", dt);
                DataTable dt1 = dbAccessDAL.GetDataTable("uspFM_EngStockAdjustmentTxn_Save", parameters, DataSetparameters);
                if (dt1 != null)
                {
                    foreach (DataRow row in dt1.Rows)
                    {
                        foreach (var val in Adjustment.StockAdjustmentGridList)

                        {
                            Adjustment.StockAdjustmentId = Convert.ToInt32(row["StockAdjustmentId"]);                            
                            Adjustment.Timestamp = Convert.ToBase64String((byte[])(row["Timestamp"]));
                            val.StockAdjustmentId = Convert.ToInt32(row["StockAdjustmentId"]);                            
                            ErrorMessage = Convert.ToString(row["ErrorMessage"]);                            
                        }
                    }
                }

                if (Adjustment.Submitted == true)
                {
                    SendMailRequestSubmit(Adjustment);
                }
                if (Adjustment.Approved == true)
                {
                    SendMailRequestApprove(Adjustment);
                }
                if (Adjustment.Rejected == true)
                {
                    SendMailRequestReject(Adjustment);
                }
                Log4NetLogger.LogExit(_FileName, nameof(Save), Level.Info.ToString());
                return Adjustment;
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

        public void deleteChildRecords(string id)
        {
            try
            {
                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "UspFM_EngStockAdjustmentTxnDet_Delete";
                        cmd.Parameters.AddWithValue("@pStockAdjustmentDetId", id);

                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }
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

        public bool IsRecordModified(StockAdjustmentModel Adjustment)
        {
            try
            {

                Log4NetLogger.LogEntry(_FileName, nameof(IsRecordModified), Level.Info.ToString());
                var dbAccessDAL = new DBAccessDAL();
                var recordModifed = false;

                if (Adjustment.StockAdjustmentId != 0)
                {

                    var DataSetparameters = new Dictionary<string, DataTable>();
                    var parameters = new Dictionary<string, string>();
                    parameters.Add("@RescheduleWOId", Adjustment.StockAdjustmentId.ToString());
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

        public bool IsStockAdjustmentCodeDuplicate(StockAdjustmentModel Adjustment)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(IsStockAdjustmentCodeDuplicate), Level.Info.ToString());

                var IsDuplicate = true;
                var dbAccessDAL = new DBAccessDAL();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@RescheduleWOId", Adjustment.StockAdjustmentId.ToString());
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
                        cmd.CommandText = "uspFM_EngStockAdjustmentTxn_GetAll";

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

        private void SendMailRequestSubmit(StockAdjustmentModel Adjustment)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(SendMailRequestSubmit), Level.Info.ToString());
            try
            {
                string emailTemplateId = string.Empty;
                string subject = string.Empty;
                string subjectVars = string.Empty;
                string templateVars = string.Empty;
                string email = string.Empty;
                                
                emailTemplateId = "33";
                var tempid = Convert.ToInt32(emailTemplateId);
                Adjustment.TemplateId = tempid;

                templateVars = string.Join(",", Adjustment.StockAdjustmentNo);   

                var DataSetparameters = new Dictionary<string, DataTable>();
                DataTable TypecodeDt = new DataTable();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pEmailTemplateId", Convert.ToString(emailTemplateId));
                parameters.Add("@pToEmailIds", Convert.ToString(email));
                parameters.Add("@pSubject", Convert.ToString(subject));
                parameters.Add("@pPriority", Convert.ToString(1));
                parameters.Add("@pSendAsHtml", Convert.ToString(1));
                parameters.Add("@pSubjectVars", Convert.ToString(subjectVars));
                parameters.Add("@pTemplateVars", Convert.ToString(templateVars));
                parameters.Add("@pFacilityId", Convert.ToString(_UserSession.FacilityId));
                var dbAccessDAL = new DBAccessDAL();
                DataTable dt = dbAccessDAL.GetDataTable("uspFM_EmailNotify_Save", parameters, DataSetparameters);
                if (dt != null)
                {
                    foreach (DataRow rows in dt.Rows)
                    {
                    }
                }
                SendMailRequestSubmitNotify(Adjustment);
            }
            catch (DALException dalex)
            {
                throw new DALException(dalex);
            }
            catch (Exception ex)
            {
                throw;
            }
        }

        public StockAdjustmentModel SendMailRequestSubmitNotify(StockAdjustmentModel Adjustment)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(SendMailRequestSubmitNotify), Level.Info.ToString());
            ScheduledWorkOrderModel griddata = new ScheduledWorkOrderModel();
            var dbAccessDAL = new DBAccessDAL();
            var parameters = new Dictionary<string, string>();
            var DataSetparameters = new Dictionary<string, DataTable>();            
                       
            var notalert = Adjustment.StockAdjustmentNo + " " + "Stock Adjustment has been Submitted";
            var hyplink = "/bems/stockadjustment?id=" + Adjustment.StockAdjustmentId;            

            parameters.Add("@pNotificationId", Convert.ToString(Adjustment.NotificationId));
            parameters.Add("@pCustomerId", Convert.ToString(_UserSession.CustomerId));
            parameters.Add("@pFacilityId", Convert.ToString(_UserSession.FacilityId));
            parameters.Add("@pUserId", Convert.ToString(_UserSession.UserId));
            parameters.Add("@pNotificationAlerts", Convert.ToString(notalert));
            parameters.Add("@pRemarks", Convert.ToString(""));
            parameters.Add("@pHyperLink", Convert.ToString(hyplink));
            parameters.Add("@pIsNew", Convert.ToString(1));
            parameters.Add("@pNotificationDateTime", Convert.ToString(null));
            parameters.Add("@pEmailTempId", Convert.ToString(Adjustment.TemplateId));

            DataTable ds = dbAccessDAL.GetDataTable("uspFM_WebNotificationSingle_Save", parameters, DataSetparameters);
            if (ds != null)
            {
                foreach (DataRow row in ds.Rows)
                {

                }
            }
            return Adjustment;
        }

        private void SendMailRequestApprove(StockAdjustmentModel Adjustment)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(SendMailRequestApprove), Level.Info.ToString());
            try
            {
                string emailTemplateId = string.Empty;
                string subject = string.Empty;
                string subjectVars = string.Empty;
                string templateVars = string.Empty;
                string email = string.Empty;

                emailTemplateId = "70";
                var tempid = Convert.ToInt32(emailTemplateId);
                Adjustment.TemplateId = tempid;

                templateVars = string.Join(",", Adjustment.StockAdjustmentNo);

                var DataSetparameters = new Dictionary<string, DataTable>();
                DataTable TypecodeDt = new DataTable();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pEmailTemplateId", Convert.ToString(emailTemplateId));
                parameters.Add("@pToEmailIds", Convert.ToString(email));
                parameters.Add("@pSubject", Convert.ToString(subject));
                parameters.Add("@pPriority", Convert.ToString(1));
                parameters.Add("@pSendAsHtml", Convert.ToString(1));
                parameters.Add("@pSubjectVars", Convert.ToString(subjectVars));
                parameters.Add("@pTemplateVars", Convert.ToString(templateVars));
                parameters.Add("@pFacilityId", Convert.ToString(_UserSession.FacilityId));
                var dbAccessDAL = new DBAccessDAL();
                DataTable dt = dbAccessDAL.GetDataTable("uspFM_EmailNotify_Save", parameters, DataSetparameters);
                if (dt != null)
                {
                    foreach (DataRow rows in dt.Rows)
                    {
                    }
                }
                SendMailRequestApproveNotify(Adjustment);
            }
            catch (DALException dalex)
            {
                throw new DALException(dalex);
            }
            catch (Exception ex)
            {
                throw;
            }
        }

        public StockAdjustmentModel SendMailRequestApproveNotify(StockAdjustmentModel Adjustment)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(SendMailRequestApproveNotify), Level.Info.ToString());
            ScheduledWorkOrderModel griddata = new ScheduledWorkOrderModel();
            var dbAccessDAL = new DBAccessDAL();
            var parameters = new Dictionary<string, string>();
            var DataSetparameters = new Dictionary<string, DataTable>();

            var notalert = Adjustment.StockAdjustmentNo + " " + "Stock Adjustment has been Approved";
            var hyplink = "/bems/stockadjustment?id=" + Adjustment.StockAdjustmentId;

            parameters.Add("@pNotificationId", Convert.ToString(Adjustment.NotificationId));
            parameters.Add("@pCustomerId", Convert.ToString(_UserSession.CustomerId));
            parameters.Add("@pFacilityId", Convert.ToString(_UserSession.FacilityId));
            parameters.Add("@pUserId", Convert.ToString(_UserSession.UserId));
            parameters.Add("@pNotificationAlerts", Convert.ToString(notalert));
            parameters.Add("@pRemarks", Convert.ToString(""));
            parameters.Add("@pHyperLink", Convert.ToString(hyplink));
            parameters.Add("@pIsNew", Convert.ToString(1));
            parameters.Add("@pNotificationDateTime", Convert.ToString(null));
            parameters.Add("@pEmailTempId", Convert.ToString(Adjustment.TemplateId));

            DataTable ds = dbAccessDAL.GetDataTable("uspFM_WebNotificationSingle_Save", parameters, DataSetparameters);
            if (ds != null)
            {
                foreach (DataRow row in ds.Rows)
                {

                }
            }
            return Adjustment;
        }

        private void SendMailRequestReject(StockAdjustmentModel Adjustment)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(SendMailRequestReject), Level.Info.ToString());
            try
            {
                string emailTemplateId = string.Empty;
                string subject = string.Empty;
                string subjectVars = string.Empty;
                string templateVars = string.Empty;
                string email = string.Empty;

                emailTemplateId = "71";
                var tempid = Convert.ToInt32(emailTemplateId);
                Adjustment.TemplateId = tempid;

                templateVars = string.Join(",", Adjustment.StockAdjustmentNo);

                var DataSetparameters = new Dictionary<string, DataTable>();
                DataTable TypecodeDt = new DataTable();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pEmailTemplateId", Convert.ToString(emailTemplateId));
                parameters.Add("@pToEmailIds", Convert.ToString(email));
                parameters.Add("@pSubject", Convert.ToString(subject));
                parameters.Add("@pPriority", Convert.ToString(1));
                parameters.Add("@pSendAsHtml", Convert.ToString(1));
                parameters.Add("@pSubjectVars", Convert.ToString(subjectVars));
                parameters.Add("@pTemplateVars", Convert.ToString(templateVars));
                parameters.Add("@pFacilityId", Convert.ToString(_UserSession.FacilityId));
                var dbAccessDAL = new DBAccessDAL();
                DataTable dt = dbAccessDAL.GetDataTable("uspFM_EmailNotify_Save", parameters, DataSetparameters);
                if (dt != null)
                {
                    foreach (DataRow rows in dt.Rows)
                    {
                    }
                }
                SendMailRequestRejectNotify(Adjustment);
            }
            catch (DALException dalex)
            {
                throw new DALException(dalex);
            }
            catch (Exception ex)
            {
                throw;
            }
        }

        public StockAdjustmentModel SendMailRequestRejectNotify(StockAdjustmentModel Adjustment)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(SendMailRequestRejectNotify), Level.Info.ToString());
            ScheduledWorkOrderModel griddata = new ScheduledWorkOrderModel();
            var dbAccessDAL = new DBAccessDAL();
            var parameters = new Dictionary<string, string>();
            var DataSetparameters = new Dictionary<string, DataTable>();

            var notalert = Adjustment.StockAdjustmentNo + " " + "Stock Adjustment has been Rejected";
            var hyplink = "/bems/stockadjustment?id=" + Adjustment.StockAdjustmentId;

            parameters.Add("@pNotificationId", Convert.ToString(Adjustment.NotificationId));
            parameters.Add("@pCustomerId", Convert.ToString(_UserSession.CustomerId));
            parameters.Add("@pFacilityId", Convert.ToString(_UserSession.FacilityId));
            parameters.Add("@pUserId", Convert.ToString(_UserSession.UserId));
            parameters.Add("@pNotificationAlerts", Convert.ToString(notalert));
            parameters.Add("@pRemarks", Convert.ToString(""));
            parameters.Add("@pHyperLink", Convert.ToString(hyplink));
            parameters.Add("@pIsNew", Convert.ToString(1));
            parameters.Add("@pNotificationDateTime", Convert.ToString(null));
            parameters.Add("@pEmailTempId", Convert.ToString(Adjustment.TemplateId));

            DataTable ds = dbAccessDAL.GetDataTable("uspFM_WebNotificationSingle_Save", parameters, DataSetparameters);
            if (ds != null)
            {
                foreach (DataRow row in ds.Rows)
                {

                }
            }
            return Adjustment;
        }
    }
}
