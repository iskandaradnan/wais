using CP.Framework.Common.ExceptionHandler.ExceptionWrappers;
using CP.Framework.Common.Logging;
using CP.UETrack.DAL.DataAccess.Contracts.BEMS;
using CP.UETrack.DAL.DataAccess.Implementation;
using CP.UETrack.Model;
using CP.UETrack.Model.BEMS;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using UETrack.DAL;

namespace CP.UETrack.DAL.DataAccess.Implementations.BEMS
{
    public class RescheduleWODAL : IRescheduleWODAL
    {
        private readonly string _FileName = nameof(RescheduleWODAL);
        readonly UserDetailsModel _UserSession = new SessionHelper().UserSession();

        public RescheduleDropdownValues Load()
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
                RescheduleDropdownValues RescheduleWOViewModel = null;

                var ds = new DataSet();
                var ds1 = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_Dropdown_Others";
                        cmd.Parameters.AddWithValue("@pTableName", "Rescheduling");
                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);

                        var da1 = new SqlDataAdapter();
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_Dropdown";
                        cmd.Parameters.Clear();
                        cmd.Parameters.AddWithValue("@pLovKey", "ReasonRemarks");
                        da1.SelectCommand = cmd;
                        da1.Fill(ds1);
                    }
                }
                if (ds.Tables.Count != 0)
                {
                    RescheduleWOViewModel = new RescheduleDropdownValues();
                    RescheduleWOViewModel.PlannerLovs = dbAccessDAL.GetLovRecords(ds.Tables[0]);
                }
                if (ds1.Tables.Count != 0)
                {

                    RescheduleWOViewModel.Reason = dbAccessDAL.GetLovRecords(ds1.Tables[0], "ReasonRemarks");
                    //var variationStatus = dbAccessDAL.GetLovRecords(ds1.Tables[0], "VariationStatusValue");
                    //var variationIds = new List<int> { 125, 128, 130, 131 };
                    //RescheduleWOViewModel.VariationStatus = variationStatus.Where(x => variationIds.Contains(x.LovId)).ToList();
                    //RescheduleWOViewModel.YesNoValues = dbAccessDAL.GetLovRecords(ds1.Tables[0], "YesNoValue");
                    //RescheduleWOViewModel.TAndCStatusValues = dbAccessDAL.GetLovRecords(ds1.Tables[0], "TCStatusValue");
                }
                //RescheduleWOViewModel.IsAdditionalFieldsExist = IsAdditionalFieldsExist();

                Log4NetLogger.LogExit(_FileName, nameof(Load), Level.Info.ToString());
                return RescheduleWOViewModel;
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

        #region Data Access Methods
        //public RescheduleWOViewModel Get(int RescheduleWOId)
        //{
        //    Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
        //    try
        //    {
        //        RescheduleWOViewModel entity = new RescheduleWOViewModel();

        //        var ds = new DataSet();
        //        var dbAccessDAL = new DBAccessDAL();
        //        using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
        //        {
        //            using (SqlCommand cmd = new SqlCommand())
        //            {
        //                cmd.Connection = con;
        //                cmd.CommandType = CommandType.StoredProcedure;
        //                cmd.CommandText = "uspFM_Rescheduling_GetById";
        //                //cmd.Parameters.AddWithValue("@pUserId", 1);
        //                cmd.Parameters.AddWithValue("@pWorkOrderId", RescheduleWOId);
        //                var da = new SqlDataAdapter();
        //                da.SelectCommand = cmd;
        //                da.Fill(ds);
        //            }
        //        }
        //        if (ds.Tables.Count != 0)
        //        {
        //            entity.RescheduleWOListData = (from n in ds.Tables[0].AsEnumerable()
        //                                           select new RescheduleWOListData
        //                                           {
        //                                               WorkOrderId = RescheduleWOId,
        //                                               WorkOrderReschedulingId = Convert.ToInt32(n["WorkOrderReschedulingId"]),
        //                                               WorkOrderNo = Convert.ToString(n["MaintenanceWorkNo"]),
        //                                               WorkOrderDate = Convert.ToDateTime(n["MaintenanceWorkDateTime"]),
        //                                               AssetNo = Convert.ToString(n["AssetNo"]),
        //                                               AssetDescription = Convert.ToString(n["AssetDescription"]),
        //                                               TypeOfWorkOrderName = Convert.ToString(n["TypeOfPlanner"]),
        //                                               MaintenanceDetails = Convert.ToString(n["MaintenanceDetails"]),
        //                                               TargetDate = Convert.ToDateTime(n["TargetDateTime"]),
        //                                               NextScheduleDate = Convert.ToDateTime(n["NextScheduleDate"]),
        //                                               RescheduleDate = Convert.ToDateTime(n["RescheduleDate"]),
        //                                               RescheduleApprovedByName = Convert.ToString(n["RescheduleApprovedByValue"]),
        //                                               ReasonForReschedule = Convert.ToInt16(n["ReasonId"]),
        //                                               ReasonForRescheduleName = Convert.ToString(n["ReasonName"])
        //                                               //Timestamp = Convert.ToBase64String((byte[])(n["Timestamp"]))
        //                                           }).ToList();
        //        }
        //        Log4NetLogger.LogExit(_FileName, nameof(Get), Level.Info.ToString());
        //        return entity;

        //    }
        //    catch (DALException dalex)
        //    {
        //        throw new DALException(dalex);
        //    }
        //    catch (Exception)
        //    {
        //        throw;
        //    }
        //}
        //public RescheduleWOViewModel Save(RescheduleWOViewModel RescheduleWO)
        //{
        //    Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());
        //    try
        //    {
        //        Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());

        //        var ds = new DataSet();
        //        var dbAccessDAL = new DBAccessDAL();
        //        using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
        //        {
        //            using (SqlCommand cmd = new SqlCommand())
        //            {
        //                cmd.Connection = con;
        //                cmd.CommandType = CommandType.StoredProcedure;
        //                cmd.CommandText = "uspFM_Rescheduling_Save";
        //                cmd.Parameters.AddWithValue("@pWorkOrderReschedulingId", RescheduleWO.WorkOrderReschedulingId);
        //                cmd.Parameters.AddWithValue("@CustomerId", _UserSession.UserId);
        //                cmd.Parameters.AddWithValue("@FacilityId", _UserSession.FacilityId);
        //                cmd.Parameters.AddWithValue("@ServiceId", 2);
        //                cmd.Parameters.AddWithValue("@RescheduleApprovedBy", RescheduleWO.RescheduleApprovedBy);
        //                cmd.Parameters.AddWithValue("@WorkOrderId", RescheduleWO.WorkOrderId);
        //                cmd.Parameters.AddWithValue("@RescheduleDate", RescheduleWO.RescheduleDate);
        //                cmd.Parameters.AddWithValue("@RescheduleDateUTC", RescheduleWO.RescheduleDate);
        //                cmd.Parameters.AddWithValue("@Reason", RescheduleWO.ReasonForReschedule);
        //                cmd.Parameters.AddWithValue("@ImpactSchedulePlanner", 1);
        //                cmd.Parameters.AddWithValue("@CreatedBy", _UserSession.UserId);
        //                cmd.Parameters.AddWithValue("@ModifiedBy", _UserSession.UserId);
        //                var da = new SqlDataAdapter();
        //                da.SelectCommand = cmd;
        //                da.Fill(ds);
        //            }
        //        }
        //        //if (ds.Tables.Count != 0)
        //        //{
        //        //    RescheduleWO.WorkOrderId = RescheduleWO.WorkOrderId;//Convert.ToInt32(ds.Tables[0].Rows[0]["WorkOrderId"]);
        //        //    //RescheduleWO.Timestamp = Convert.ToBase64String((byte[])(ds.Tables[0].Rows[0]["Timestamp"]));
        //        //}

        //        Log4NetLogger.LogExit(_FileName, nameof(Save), Level.Info.ToString());
        //        return RescheduleWO;
        //    }
        //    catch (DALException dalex)
        //    {
        //        throw new DALException(dalex);
        //    }
        //    catch (Exception ex)
        //    {
        //        throw ex;
        //    }
        //}


        public RescheduleWOViewModel Save(RescheduleWOViewModel resch)
        {
           
            try
            {
              
                Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());
                RescheduleWOViewModel griddata = new RescheduleWOViewModel();
                var dbAccessDAL = new DBAccessDAL();
                var parameters = new Dictionary<string, string>();
                
                //parameters.Add("@pFacilityId", Convert.ToString(_UserSession.FacilityId));

                var DataSetparameters = new Dictionary<string, DataTable>();
                DataTable dt = new DataTable();
                dt.Columns.Add("WorkOrderId", typeof(int));
                dt.Columns.Add("AssetId", typeof(int));
                dt.Columns.Add("AssignedUserId", typeof(int));
                dt.Columns.Add("RescheduleDate", typeof(DateTime));

                dt.Columns.Add("CustomerId", typeof(int));
                dt.Columns.Add("FacilityId", typeof(int));
                dt.Columns.Add("UserId", typeof(int));
                dt.Columns.Add("Remarks", typeof(string));

                //DataSet ds = dbAccessDAL.GetDataSet("uspFM_Rescheduling_GetById", parameters, DataSetparameters);
                //if (ds != null)
                //{
                //    if (ds.Tables[0] != null && ds.Tables[0].Rows.Count > 0)
                //    {

                //        resch.AssetId = Convert.ToInt32(ds.Tables[0].Rows[0]["AssetId"]);

                //    }
                //}

                foreach (var i in resch.RescheduleWOListData.Where(y => y.IsDeleted))
                {
                    //i.AssetId = resch.AssetId;
                    dt.Rows.Add(i.WorkOrderId, i.AssetId,  i.NewStaffMasterId, i.RescheduleDate , _UserSession.CustomerId, _UserSession.FacilityId, _UserSession.UserId, i.Reason);
                }

                DataSetparameters.Add("@pRescheduling", dt);
                
                DataTable dt1 = dbAccessDAL.GetDataTable("uspFM_Rescheduling_Save", parameters, DataSetparameters);
                if (dt1 != null)
                {
                    foreach (DataRow row in dt1.Rows)
                    {
                        //EODCaptur.CaptureId = Convert.ToInt32(row["CaptureId"]);
                        //EODCaptur.Timestamp = Convert.ToBase64String((byte[])(row["Timestamp"]));
                        //ErrorMessage = Convert.ToString(row["ErrorMessage"]);
                    }
                    SendMailAboutReschedule(resch);
                    SendMailAboutReassignee(resch);
                    updateNotificationSingle(resch);
                }

                Log4NetLogger.LogExit(_FileName, nameof(Save), Level.Info.ToString());
                return resch;
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

        private void SendMailAboutReschedule(RescheduleWOViewModel model)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());
            try
            {
                string emailTemplateId = string.Empty;
                string subject = string.Empty;
                string subjectVars = string.Empty;
                string templateVars = string.Empty;
                var WOID = model.RescheduleWOListData[0].WorkOrderId;
                var WOIDInt = Convert.ToInt32(WOID);
                emailTemplateId = "34";
                var obj = Get(WOIDInt);

                
                if (obj != null)
                {
                    var WO = obj.RescheduleWOListData[0].WorkOrderNo;  //string.Empty;
                    var WODate = obj.RescheduleWOListData[0].RescheduleDate;
                    var WODat = WODate.Value.ToString("dd-MMM-yyyy");
                    templateVars = string.Join(",", WO, WODat);
                }

                // var GetObj = GetMail(obj);
                string email = string.Empty; //GetObj.Email;
                var DataSetparameters = new Dictionary<string, DataTable>();
                DataTable TypecodeDt = new DataTable();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pEmailTemplateId", Convert.ToString(emailTemplateId));
                parameters.Add("@pToEmailIds", email);
                parameters.Add("@pSubject", Convert.ToString(subject));
                parameters.Add("@pPriority", Convert.ToString(1));
                parameters.Add("@pSendAsHtml", Convert.ToString(1));
                parameters.Add("@pFacilityId", Convert.ToString(_UserSession.FacilityId));


                parameters.Add("@pSubjectVars", Convert.ToString(subjectVars));
                parameters.Add("@pTemplateVars", Convert.ToString(templateVars));


                var dbAccessDAL = new DBAccessDAL();
                DataTable dt = dbAccessDAL.GetDataTable("uspFM_EmailNotify_Save", parameters, DataSetparameters);
                if (dt != null)
                {
                    foreach (DataRow rows in dt.Rows)
                    {


                    }
                }
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

        private void SendMailAboutReassignee(RescheduleWOViewModel model)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());
            try
            {
                string emailTemplateId = string.Empty;
                string subject = string.Empty;
                string subjectVars = string.Empty;
                string templateVars = string.Empty;

                var WOID = model.RescheduleWOListData[0].WorkOrderId;
                var WOIDInt = Convert.ToInt32(WOID);
                emailTemplateId = "35";
                var obj = Get(WOIDInt);
                //var WOAssigneeId
                if (obj != null)
                {
                    var WO = obj.RescheduleWOListData[0].WorkOrderNo;  //string.Empty;
                    var WOAssigneeId = obj.StaffMasterId;
                    var WOAssignee = obj.StaffName;
                    templateVars = string.Join(",", WO, WOAssignee);
                }

                var GetObj = GetMail(obj);
                string email = GetObj.Email;

                var DataSetparameters = new Dictionary<string, DataTable>();
                DataTable TypecodeDt = new DataTable();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pEmailTemplateId", Convert.ToString(emailTemplateId));
                parameters.Add("@pToEmailIds", email);
                parameters.Add("@pSubject", Convert.ToString(subject));
                parameters.Add("@pPriority", Convert.ToString(1));
                parameters.Add("@pSendAsHtml", Convert.ToString(1));
                parameters.Add("@pFacilityId", Convert.ToString(_UserSession.FacilityId));

                parameters.Add("@pSubjectVars", Convert.ToString(subjectVars));
                parameters.Add("@pTemplateVars", Convert.ToString(templateVars));


                var dbAccessDAL = new DBAccessDAL();
                DataTable dt = dbAccessDAL.GetDataTable("uspFM_EmailNotify_Save", parameters, DataSetparameters);
                if (dt != null)
                {
                    foreach (DataRow rows in dt.Rows)
                    {


                    }
                }
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

        public RescheduleWOViewModel GetMail(RescheduleWOViewModel model)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());
            try
            {
                var dbAccessDAL = new DBAccessDAL();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();

                parameters.Add("@pUserRegistrationId", Convert.ToString(model.StaffMasterId));

                DataTable dt = dbAccessDAL.GetDataTable("uspFM_UMUserRegistration_GetEmailId", parameters, DataSetparameters);
                if (dt != null)
                {
                    foreach (DataRow row in dt.Rows)
                    {
                        model.Email = Convert.ToString(row["Email"]);
                    }

                }
                Log4NetLogger.LogExit(_FileName, nameof(Save), Level.Info.ToString());
                return model;
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

        //public RescheduleWOViewModel updateNotificationSingleReassignee(RescheduleWOViewModel ent)
        //{
        //    Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());
        //    RescheduleWOViewModel griddata = new RescheduleWOViewModel();
        //    var dbAccessDAL = new DBAccessDAL();
        //    var parameters = new Dictionary<string, string>();
        //    var DataSetparameters = new Dictionary<string, DataTable>();
        //    //var TempWorkOrderType = ent.WorkOrderType;
        //    var notalert = string.Empty;
        //    var hyplink = string.Empty;
        //    var WO = ent.RescheduleWOListData[0].WorkOrderNo;  //string.Empty;
        //    var WOId = ent.RescheduleWOListData[0].WorkOrderId;
        //    notalert = WO + " " + "Work Order has been rescheduled";
        //    hyplink = "/bems/reschedulewo?id=" + WOId;


        //    parameters.Add("@pNotificationId", Convert.ToString(ent.NotificationId));
        //    parameters.Add("@pCustomerId", Convert.ToString(_UserSession.CustomerId));
        //    parameters.Add("@pFacilityId", Convert.ToString(_UserSession.FacilityId));
        //    parameters.Add("@pUserId", Convert.ToString(_UserSession.UserId));
        //    parameters.Add("@pNotificationAlerts", Convert.ToString(notalert));
        //    parameters.Add("@pRemarks", Convert.ToString(""));
        //    parameters.Add("@pHyperLink", Convert.ToString(hyplink));
        //    parameters.Add("@pIsNew", Convert.ToString(1));
        //    parameters.Add("@pNotificationDateTime", Convert.ToString(null));

        //    DataTable ds = dbAccessDAL.GetDataTable("uspFM_WebNotificationSingle_Save", parameters, DataSetparameters);
        //    if (ds != null)
        //    {
        //        foreach (DataRow row in ds.Rows)
        //        {
        //            //model.CRMRequestId = Convert.ToInt32(row["CRMRequestId"]);
        //            //model.Timestamp = Convert.ToBase64String((byte[])(row["Timestamp"]));
        //            //// model.err = Convert.ToBase64String((byte[])(row["Timestamp"]));
        //            //model.HiddenId = Convert.ToString(row["GuId"]);
        //        }
        //    }

        //    return ent;
        //}

        public RescheduleWOViewModel updateNotificationSingle(RescheduleWOViewModel ent)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());
            RescheduleWOViewModel griddata = new RescheduleWOViewModel();
            var dbAccessDAL = new DBAccessDAL();
            var parameters = new Dictionary<string, string>();
            var DataSetparameters = new Dictionary<string, DataTable>();
            //var TempWorkOrderType = ent.WorkOrderType;
            var notalert = string.Empty;
            var hyplink = string.Empty;
            var WO = ent.RescheduleWOListData[0].WorkOrderNo;  //string.Empty;
            var WOId = ent.RescheduleWOListData[0].WorkOrderId;
            notalert = WO + " " + "Work Order has been rescheduled";
            hyplink = "/bems/reschedulewo?id=" + WOId;
     

            parameters.Add("@pNotificationId", Convert.ToString(ent.NotificationId));
            parameters.Add("@pCustomerId", Convert.ToString(_UserSession.CustomerId));
            parameters.Add("@pFacilityId", Convert.ToString(_UserSession.FacilityId));
            parameters.Add("@pUserId", Convert.ToString(_UserSession.UserId));
            parameters.Add("@pNotificationAlerts", Convert.ToString(notalert));
            parameters.Add("@pRemarks", Convert.ToString(""));
            parameters.Add("@pHyperLink", Convert.ToString(hyplink));
            parameters.Add("@pIsNew", Convert.ToString(1));
            parameters.Add("@pNotificationDateTime", Convert.ToString(null));
           // parameters.Add("@pEmailTempId", Convert.ToString(ent.TemplateId));

            DataTable ds = dbAccessDAL.GetDataTable("uspFM_WebNotificationSingle_Save", parameters, DataSetparameters);
            if (ds != null)
            {
                foreach (DataRow row in ds.Rows)
                {
                    //model.CRMRequestId = Convert.ToInt32(row["CRMRequestId"]);
                    //model.Timestamp = Convert.ToBase64String((byte[])(row["Timestamp"]));
                    //// model.err = Convert.ToBase64String((byte[])(row["Timestamp"]));
                    //model.HiddenId = Convert.ToString(row["GuId"]);
                }
            }

            return ent;
        }

        public RescheduleWOViewModel Get(int RescheduleWOId)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
            try
            {
                var dbAccessDAL = new DBAccessDAL();
                RescheduleWOViewModel entity = new RescheduleWOViewModel();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pWorkOrderId", RescheduleWOId.ToString());
                DataSet ds = dbAccessDAL.GetDataSet("uspFM_Rescheduling_GetById", parameters, DataSetparameters);
                if (ds != null)
                {
                    if (ds.Tables[0] != null && ds.Tables[0].Rows.Count > 0)
                    {
                        entity.WorkOrderId = Convert.ToInt32(ds.Tables[0].Rows[0]["WorkOrderId"]);
                        entity.UserAreaName = Convert.ToString(ds.Tables[0].Rows[0]["UserAreaName"]);
                        entity.UserLocationName = Convert.ToString(ds.Tables[0].Rows[0]["UserLocationName"]);
                        //entity.PlannerId = Convert.ToInt32(ds.Tables[0].Rows[0]["TypeOfPlanner"]);
                        entity.PlannerId = ds.Tables[0].Rows[0].Field<int?>("TypeOfPlanner");
                        entity.StaffMasterId = Convert.ToInt32(ds.Tables[0].Rows[0]["AssignedUserId"]);
                        entity.StaffName = Convert.ToString(ds.Tables[0].Rows[0]["Assignee"]);
                        entity.Reason = Convert.ToString(ds.Tables[0].Rows[0]["Reason"]);
                    }

                    var griddata = (from n in ds.Tables[1].AsEnumerable()
                                    select new RescheduleWOListData
                                    {
                                        WorkOrderId = Convert.ToInt32(n["WorkOrderId"]),
                                        AssetId = Convert.ToInt32(n["AssetId"]),                                        
                                        AssetNo = Convert.ToString(n["AssetNo"]),
                                        WorkOrderNo = Convert.ToString(n["MaintenanceWorkNo"]),
                                        scheduleDate = n.Field<DateTime?>("ScheduledDate"),
                                        RescheduleDate = n.Field<DateTime?>("ReScheduledDate"),                                       
                                    }).ToList();

                    if (griddata != null && griddata.Count > 0)
                    {
                        entity.RescheduleWOListData = griddata;
                    }
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
        public void Delete(int RescheduleWOId)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Delete), Level.Info.ToString());
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
                        cmd.CommandText = "UspFM_EngMwoReschedulingTxn_Delete";
                        cmd.Parameters.AddWithValue("@pWorkOrderId", RescheduleWOId);

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

        public bool IsRecordModified(RescheduleWOViewModel RescheduleWO)
        {
            try
            {
               
                Log4NetLogger.LogEntry(_FileName, nameof(IsRecordModified), Level.Info.ToString());
                var dbAccessDAL = new DBAccessDAL();
                var recordModifed = false;

                if (RescheduleWO.WorkOrderId != 0)
                {

                    var DataSetparameters = new Dictionary<string, DataTable>();
                    var parameters = new Dictionary<string, string>();
                    parameters.Add("@RescheduleWOId", RescheduleWO.WorkOrderId.ToString());
                    parameters.Add("@Operation", "GetTimestamp");
                    DataTable dt = dbAccessDAL.GetDataTable("UspFM_RescheduleWO_Get", parameters, DataSetparameters);

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
                        cmd.CommandText = "uspFM_EngMwoReschedulingTxn_GetAll";

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
        public bool IsRescheduleWOCodeDuplicate(RescheduleWOViewModel RescheduleWO)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(IsRescheduleWOCodeDuplicate), Level.Info.ToString());

                var IsDuplicate = true;
                var dbAccessDAL = new DBAccessDAL();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@RescheduleWOId", RescheduleWO.WorkOrderId.ToString());
                //parameters.Add("@RescheduleWOCode", RescheduleWO.WorkOrderNo.ToString());
                DataTable dt = dbAccessDAL.GetDataTable("UspFM_RescheduleWO_ValCode", parameters, DataSetparameters);
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

        public RescheduleWOViewModel FetchWorkorder(RescheduleWOViewModel EODCaptur)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(FetchWorkorder), Level.Info.ToString());
            try
            {
                var dbAccessDAL = new DBAccessDAL();
                RescheduleWOViewModel entity = new RescheduleWOViewModel();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pUserAreaId", Convert.ToString(EODCaptur.UserAreaId));
                parameters.Add("@pUserLocationId", Convert.ToString(EODCaptur.UserLocationId));
                parameters.Add("@pAssigneeId", Convert.ToString(EODCaptur.StaffMasterId));
                parameters.Add("@pTypeOfPlanner", Convert.ToString(EODCaptur.PlannerId));
                parameters.Add("@pFacilityId", Convert.ToString(_UserSession.FacilityId));
                parameters.Add("@pPageIndex", Convert.ToString(EODCaptur.PageIndex));
                parameters.Add("@pPageSize", Convert.ToString(EODCaptur.PageSize));
                parameters.Add("@pAssetId", Convert.ToString(EODCaptur.AssetId));
                DataSet dt = dbAccessDAL.GetDataSet("uspFM_WorkOrderReschedule_Fetch", parameters, DataSetparameters);
                if (dt != null && dt.Tables.Count > 0)
                {

                    entity.RescheduleWOListData = (from n in dt.Tables[0].AsEnumerable()
                                                 select new RescheduleWOListData
                                                 {
                                                     AssetId = n.Field<int?>("AssetId"),
                                                     AssetNo = Convert.ToString(n["AssetNo"] == DBNull.Value ?"" : (Convert.ToString(n["AssetNo"]))),
                                                     WorkOrderId = n.Field<int?>("WorkOrderId"),
                                                     WorkOrderNo = Convert.ToString(n["MaintenanceWorkNo"] == DBNull.Value ? "" : (Convert.ToString(n["MaintenanceWorkNo"]))),
                                                     scheduleDate = n.Field<DateTime?>("TargetDateTime"),
                                                     
                                                     TotalRecords = Convert.ToInt32(n["TotalRecords"]),
                                                     TotalPages = Convert.ToInt32(n["TotalPageCalc"]),

                                                 }).ToList();

                    entity.RescheduleWOListData.ForEach((x) =>
                    {
                        x.PageSize = EODCaptur.PageSize;
                        x.PageIndex = EODCaptur.PageIndex;
                        x.FirstRecord = ((EODCaptur.PageIndex - 1) * EODCaptur.PageSize) + 1;
                        x.LastRecord = ((EODCaptur.PageIndex - 1) * EODCaptur.PageSize) + EODCaptur.PageSize;
                        x.LastPageIndex = x.TotalRecords % EODCaptur.PageSize == 0 ? x.TotalRecords / EODCaptur.PageSize : (x.TotalRecords / EODCaptur.PageSize) + 1;
                       
                    });


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
        #endregion
    }
}
