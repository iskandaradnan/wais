using CP.Framework.Common.ExceptionHandler.ExceptionWrappers;
using CP.Framework.Common.Logging;
using CP.UETrack.DAL.DataAccess.Contracts.BEMS;
using CP.UETrack.DAL.DataAccess.Implementation;
using CP.UETrack.Model;
using CP.UETrack.Model.BEMS;
using CP.UETrack.Model.BEMS.CRMWorkOrder;
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
    public class CRMWorkorderDAL : ICRMWorkorderDAL
    {
        private readonly string _FileName = nameof(CRMWorkorderDAL);
        readonly UserDetailsModel _UserSession = new SessionHelper().UserSession();

        public CRMWorkorderDAL()
        {

        }

        public CRMWorkorderDropdownValues Load()
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
                CRMWorkorderDropdownValues CRMWorkorderdropdown = null;

                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_Dropdown";
                        cmd.Parameters.AddWithValue("@pLovKey", "CRMRequestTypeValue,CRMRequestStatusValue");
                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }

                CRMWorkorderdropdown = new CRMWorkorderDropdownValues();
                if (ds.Tables.Count != 0)
                {
                    CRMWorkorderdropdown.TypeofRequestLov = dbAccessDAL.GetLovRecords(ds.Tables[0], "CRMRequestTypeValue");
                    CRMWorkorderdropdown.WorkOrderStatusLov = dbAccessDAL.GetLovRecords(ds.Tables[0], "CRMRequestStatusValue");
                }


                Log4NetLogger.LogExit(_FileName, nameof(Load), Level.Info.ToString());
                return CRMWorkorderdropdown;
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

        public CRMWorkorder Save(CRMWorkorder workorder, out string ErrorMessage)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());
            try
            {
                var email = workorder.StaffEmail;
                var sendNotification = string.Empty;
                sendNotification = workorder.MailSts;
                ErrorMessage = string.Empty;
                var dbAccessDAL = new DBAccessDAL();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pCRMRequestWOId", Convert.ToString(workorder.CRMRequestWOId));
                parameters.Add("@pUserid", Convert.ToString(_UserSession.UserId));
                parameters.Add("@pCustomerId", Convert.ToString(_UserSession.CustomerId));
                parameters.Add("@pFacilityId", Convert.ToString(_UserSession.FacilityId));
                parameters.Add("@pServiceId", Convert.ToString(2));
                parameters.Add("@pCRMWorkOrderNo", Convert.ToString(workorder.CRMRequestWONo));
                parameters.Add("@pCRMWorkOrderDateTime", Convert.ToString(workorder.CRMWorkOrderDateTime.ToString("MM-dd-yyy HH:mm")));
                parameters.Add("@pStatus", Convert.ToString(workorder.WorkOrderStatusId));
                parameters.Add("@pDescription", Convert.ToString(workorder.WorkorderDetails));
                parameters.Add("@pTypeOfRequest", Convert.ToString(workorder.TypeOfRequestId));
                parameters.Add("@pCRMRequestId", Convert.ToString(workorder.CRMRequestId));
                parameters.Add("@pAssetId", Convert.ToString(workorder.AssetId));
                parameters.Add("@pAssignedUserId", Convert.ToString(workorder.UserId));
                parameters.Add("@pRemarks", Convert.ToString(workorder.Remarks));
                parameters.Add("@pManufacturerId", Convert.ToString(workorder.ManufacturerId));
                parameters.Add("@pModelId", Convert.ToString(workorder.ModelId));
                parameters.Add("@pTimestamp", Convert.ToString(workorder.Timestamp));

                DataTable ds = dbAccessDAL.GetDataTable("uspFM_CRMRequestWorkOrderTxn_Save", parameters, DataSetparameters);
                if (ds != null)
                {
                    foreach (DataRow row in ds.Rows)
                    {
                        workorder.CRMRequestWOId = Convert.ToInt32(row["CRMRequestWOId"]);
                        workorder.Timestamp = Convert.ToBase64String((byte[])(row["Timestamp"]));
                        workorder.HiddenId = Convert.ToString(row["GuId"]);
                    }
                }

                workorder = Get(workorder.CRMRequestWOId);
                workorder.StaffEmail = email;
                //if(sendNotification == "NoMail")
                //{
                //    SendMailAssignee(workorder);                   
                //}
                


                Log4NetLogger.LogExit(_FileName, nameof(Save), Level.Info.ToString());
                return workorder;
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
                        cmd.CommandText = "uspFM_CRMRequestWorkOrderTxn_GetAll";

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
        public CRMWorkorder Get(int Id)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
            try
            {

                var dbAccessDAL = new DBAccessDAL();

                CRMWorkorder entity = new CRMWorkorder();

                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                //parameters.Add("@pUserId", 1.ToString());
                parameters.Add("@pCRMRequestWOId", Id.ToString());
                DataTable dt = dbAccessDAL.GetDataTable("uspFM_CRMRequestWorkOrderTxn_GetById", parameters, DataSetparameters);
                if (dt != null && dt.Rows.Count > 0)
                {

                    entity.CRMRequestWOId = Convert.ToInt16(dt.Rows[0]["CRMRequestWOId"]);
                    entity.CRMRequestWONo = Convert.ToString(dt.Rows[0]["CRMWorkOrderNo"]);
                    entity.CRMWorkOrderDateTime = Convert.ToDateTime(dt.Rows[0]["CRMWorkOrderDateTime"]);
                    entity.CRMRequestId = Convert.ToInt32(dt.Rows[0]["CRMRequestId"]);
                    entity.RequestNo = Convert.ToString(dt.Rows[0]["RequestNo"]);
                    entity.TypeOfRequestId = Convert.ToInt32(dt.Rows[0]["TypeOfRequestId"]);
                    entity.TypeOfRequest = Convert.ToString(dt.Rows[0]["TypeOfRequest"]);

                    //entity.AssetId = Convert.ToInt32(dt.Rows[0]["AssetId"]);
                    entity.AssetId = dt.Rows[0].Field<int?>("AssetId");
                    entity.AssetNo = Convert.ToString(dt.Rows[0]["AssetNo"]);
                    //entity.UserId = Convert.ToInt32(dt.Rows[0]["AssignedStaffId"]);
                    entity.UserId = dt.Rows[0].Field<int?>("AssignedStaffId");
                    entity.StaffName = Convert.ToString(dt.Rows[0]["AssignedStaffName"] == DBNull.Value ? "" : (Convert.ToString(dt.Rows[0]["AssignedStaffName"])));
                    entity.StaffEmail = Convert.ToString(dt.Rows[0]["AssigneEmail"] == DBNull.Value ? "" : (Convert.ToString(dt.Rows[0]["AssigneEmail"])));
                    entity.MailSts = Convert.ToString(dt.Rows[0]["MailStatus"] == DBNull.Value ? "" : (Convert.ToString(dt.Rows[0]["MailStatus"])));
                    entity.WorkOrderStatusId = Convert.ToInt32(dt.Rows[0]["StatusId"]);
                    entity.WorkOrderStatus = Convert.ToString(dt.Rows[0]["Status"]);
                    //entity.ManufacturerId = Convert.ToInt32(dt.Rows[0]["ManufacturerId"]);
                    entity.ManufacturerId = dt.Rows[0].Field<int?>("ManufacturerId");
                    entity.Manufacturer = Convert.ToString(dt.Rows[0]["Manufacturer"]);
                    //entity.ModelId = Convert.ToInt32(dt.Rows[0]["ModelId"]);
                    entity.ModelId = dt.Rows[0].Field<int?>("ModelId");
                    entity.Model = Convert.ToString(dt.Rows[0]["Model"]);
                    entity.WorkorderDetails = Convert.ToString(dt.Rows[0]["Description"]);
                    entity.IsReqTypeReferenced = dt.Rows[0].Field<int?>("IsReqTypeReferenced");
                    entity.Timestamp = Convert.ToBase64String((byte[])(dt.Rows[0]["Timestamp"]));
                    entity.IsAssessFinished = dt.Rows[0].Field<int?>("CRMAssesmentId");
                    entity.IsCompletionInfoFinished = dt.Rows[0].Field<int?>("CRMCompletionInfoId");
                    //n.Field<decimal?>("Maximum")
                    entity.UserAreaId = dt.Rows[0].Field<int?>("UserAreaId");
                    entity.UserAreaName = Convert.ToString(dt.Rows[0]["UserAreaName"]);
                    entity.UserAreaCode = Convert.ToString(dt.Rows[0]["UserAreaCode"]);
                    entity.UserLocationId = dt.Rows[0].Field<int?>("UserLocationId");
                    entity.UserLocationCode = Convert.ToString(dt.Rows[0]["UserLocationCode"]);
                    entity.UserLocationName = Convert.ToString(dt.Rows[0]["UserLocationName"]);

                    entity.RequesterId = dt.Rows[0].Field<int>("RequesterId");
                    entity.RequesterEmail = Convert.ToString(dt.Rows[0]["RequesterEmail"]);
                    entity.HiddenId = Convert.ToString((dt.Rows[0]["GuId"]));
                    entity.Service = Convert.ToString((dt.Rows[0]["ServiceName"]));

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
                parameters.Add("@pCRMRequestWOId", Id.ToString());
                parameters.Add("@pUserId", Convert.ToString(_UserSession.UserId));
                DataTable dt = dbAccessDAL.GetDataTable("uspFM_CRMRequestWorkOrderTxn_Delete", parameters, DataSetparameters);
                if (dt != null && dt.Rows.Count > 0)
                {
                    //string Message = Convert.ToString(dt.Rows[0]["Message"]);
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

        /******************* CRM Workorder Assessment Tab Save *********************/
        public CRMWorkorderAssessment SaveAssessment(CRMWorkorderAssessment crmworkAss, out string ErrorMessage)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());
            try
            {
                var compId = crmworkAss.CRMAssesmentId;
                var reqId = crmworkAss.RequesterId;
                var reqEmail = crmworkAss.RequesterEmail;
                ErrorMessage = string.Empty;
                var dbAccessDAL = new DBAccessDAL();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pCRMAssesmentId", Convert.ToString(crmworkAss.CRMAssesmentId));
                parameters.Add("@pUserid", Convert.ToString(_UserSession.UserId));
                parameters.Add("@pCustomerId", Convert.ToString(_UserSession.CustomerId));
                parameters.Add("@pFacilityId", Convert.ToString(_UserSession.FacilityId));
                parameters.Add("@pServiceId", Convert.ToString(2));
                parameters.Add("@pCRMRequestWOId", Convert.ToString(crmworkAss.CRMRequestWOId));
                parameters.Add("@pStaffMasterId", Convert.ToString(crmworkAss.StaffMasterId));
                parameters.Add("@pFeedBack", Convert.ToString(crmworkAss.Feedback));
               // parameters.Add("@pAssessmentStartDateTime", Convert.ToString(crmworkAss.AssessmentStartDate));
                parameters.Add("@pAssessmentStartDateTime", Convert.ToString(crmworkAss.AssessmentStartDate.ToString("MM-dd-yyy HH:mm")));
                //parameters.Add("@pAssessmentStartDateTime", Convert.ToString(crmworkAss.AssessmentStartDate == null || crmworkAss.AssessmentStartDate == DateTimeOffset.MinValue ? null : crmworkAss.AssessmentStartDate.ToString("MM-dd-yyy HH:mm")));

                // parameters.Add("@pAssessmentStartDateTimeUTC", Convert.ToString(crmworkAss.AssessmentStartDate));
                parameters.Add("@pAssessmentStartDateTimeUTC", Convert.ToString(crmworkAss.AssessmentStartDate.ToString("MM-dd-yyy HH:mm")));
                //parameters.Add("@pAssessmentEndDateTime", Convert.ToString(crmworkAss.AssessmentEndDate));
                parameters.Add("@pAssessmentEndDateTime", Convert.ToString(crmworkAss.AssessmentEndDate.ToString("MM-dd-yyy HH:mm")));
                //parameters.Add("@pAssessmentStartDateTime", Convert.ToString(crmworkAss.AssessmentEndDate == null || crmworkAss.AssessmentStartDate == DateTimeOffset.MinValue ? null : crmworkAss.AssessmentEndDate.ToString("MM-dd-yyy HH:mm")));
                //parameters.Add("@pAssessmentEndDateTimeUTC", Convert.ToString(crmworkAss.AssessmentEndDate));
                parameters.Add("@pAssessmentEndDateTimeUTC", Convert.ToString(crmworkAss.AssessmentEndDate.ToString("MM-dd-yyy HH:mm")));
                parameters.Add("@pTimestamp", Convert.ToString(crmworkAss.Timestamp));

                DataTable ds = dbAccessDAL.GetDataTable("uspFM_CRMRequestAssessment_Save", parameters, DataSetparameters);
                if (ds != null)
                {
                    foreach (DataRow row in ds.Rows)
                    {
                        crmworkAss.CRMAssesmentId = Convert.ToInt32(row["CRMAssesmentId"]);
                        crmworkAss.Timestamp = Convert.ToBase64String((byte[])(row["Timestamp"]));
                        crmworkAss.HiddenId = Convert.ToString(row["GuId"]);
                        crmworkAss.CRMRequestWONo = Convert.ToString(row["CRMWorkOrderNo"]);
                        
                        
                    }
                }
                crmworkAss.RequesterId = reqId;
                crmworkAss.RequesterEmail = reqEmail;
                if(compId==0)
                {
                    SendMailAssessCDone(crmworkAss);
                }
                
                Log4NetLogger.LogExit(_FileName, nameof(Save), Level.Info.ToString());
                return crmworkAss;
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

        /******************* CRM Workorder Assessment Tab Get *********************/
        public CRMWorkorderAssessment GetAssessment(int Id)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
            try
            {

                var dbAccessDAL = new DBAccessDAL();

                CRMWorkorderAssessment entity = new CRMWorkorderAssessment();

                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pUserId", 1.ToString());
                parameters.Add("@pCRMRequestWOId", Id.ToString());
                DataTable dt = dbAccessDAL.GetDataTable("UspFM_CRMRequestAssessment_GetById", parameters, DataSetparameters);
                if (dt != null && dt.Rows.Count > 0)
                {

                    entity.CRMAssesmentId = Convert.ToInt16(dt.Rows[0]["CRMAssesmentId"]);
                    entity.CRMRequestWOId = Convert.ToInt16(dt.Rows[0]["CRMRequestWOId"]);
                    entity.StaffMasterId = Convert.ToInt16(dt.Rows[0]["StaffMasterId"]);
                    entity.StaffName = Convert.ToString(dt.Rows[0]["StaffName"]);
                    entity.Feedback = Convert.ToString(dt.Rows[0]["FeedBack"]);
                    entity.AssessmentStartDate = Convert.ToDateTime(dt.Rows[0]["AssessmentStartDateTime"]);
                    entity.AssessmentEndDate = Convert.ToDateTime(dt.Rows[0]["AssessmentEndDateTime"]);
                    entity.Timestamp = Convert.ToBase64String((byte[])(dt.Rows[0]["Timestamp"]));
                    entity.WorkOrderStatusId = Convert.ToInt16(dt.Rows[0]["Status"]);
                    entity.WorkOrderStatus = Convert.ToString(dt.Rows[0]["StatusValue"]);
                }
                var model = Get(entity.CRMRequestWOId);
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

        /******************* CRM Workorder Completion Info Tab Save *********************/
        public CRMWorkorderCompInfo SaveCompInfo(CRMWorkorderCompInfo crmworkComp, out string ErrorMessage)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());
            try
            {
                if(crmworkComp.AcceptedById == 0)
                {
                    crmworkComp.AcceptedById = null;
                }

                var assigneeEmail = crmworkComp.AssigneeEmail;
                var ReqEmail = crmworkComp.RequesterEmail;
                var sendacceptedmail ="";
                if (crmworkComp.AcceptedById > 0)
                {
                    sendacceptedmail = "sendmail"; ;
                }

                ErrorMessage = string.Empty;
                var dbAccessDAL = new DBAccessDAL();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pCRMCompletionInfoId", Convert.ToString(crmworkComp.CRMCompletionInfoId));
                parameters.Add("@pUserid", Convert.ToString(_UserSession.UserId));
                parameters.Add("@pCustomerId", Convert.ToString(_UserSession.CustomerId));
                parameters.Add("@pFacilityId", Convert.ToString(_UserSession.FacilityId));
                parameters.Add("@pServiceId", Convert.ToString(2));
                parameters.Add("@pCRMRequestWOId", Convert.ToString(crmworkComp.CRMRequestWOId));
                //parameters.Add("@pStartDateTime", Convert.ToString(crmworkComp.StartDateTime));
                parameters.Add("@pStartDateTime", Convert.ToString(crmworkComp.StartDateTime.ToString("MM-dd-yyy HH:mm")));
                //parameters.Add("@pStartDateTimeUTC", Convert.ToString(crmworkComp.StartDateTime));
                parameters.Add("@pStartDateTimeUTC", Convert.ToString(crmworkComp.StartDateTime.ToString("MM-dd-yyy HH:mm")));
                //parameters.Add("@pEndDateTime", Convert.ToString(crmworkComp.EndDateTime));
                parameters.Add("@pEndDateTime", Convert.ToString(crmworkComp.EndDateTime.ToString("MM-dd-yyy HH:mm")));
                //parameters.Add("@pEndDateTimeUTC", Convert.ToString(crmworkComp.EndDateTime));
                parameters.Add("@pEndDateTimeUTC", Convert.ToString(crmworkComp.EndDateTime.ToString("MM-dd-yyy HH:mm")));
                //parameters.Add("@pHandoverDateTime", Convert.ToString(crmworkComp.HandOverDateTime));
                parameters.Add("@pHandoverDateTime", Convert.ToString(crmworkComp.HandOverDateTime.ToString("MM-dd-yyy HH:mm")));
                //parameters.Add("@pHandoverDateTimeUTC", Convert.ToString(crmworkComp.HandOverDateTime));
                parameters.Add("@pHandoverDateTimeUTC", Convert.ToString(crmworkComp.HandOverDateTime.ToString("MM-dd-yyy HH:mm")));
                parameters.Add("@pHandoverDelay", Convert.ToString(null));
                parameters.Add("@pAcceptedBy", Convert.ToString(crmworkComp.AcceptedById));
                parameters.Add("@pSignature", Convert.ToString(crmworkComp.Signature));
                parameters.Add("@pRemarks", Convert.ToString(crmworkComp.Remarks));
                parameters.Add("@pCompletedBy", Convert.ToString(crmworkComp.CompletedById));
                //parameters.Add("@pCompPositionId", Convert.ToString(crmworkComp.CompbyPositionId));
                parameters.Add("@pCompletedRemarks", Convert.ToString(crmworkComp.CompletedRemarks));
                parameters.Add("@pTimestamp", Convert.ToString(crmworkComp.Timestamp));

                DataTable ds = dbAccessDAL.GetDataTable("uspFM_CRMRequestCompletionInfo_Save", parameters, DataSetparameters);
                if (ds != null)
                {
                    foreach (DataRow row in ds.Rows)
                    {
                        crmworkComp.CRMCompletionInfoId = Convert.ToInt32(row["CRMCompletionInfoId"]);
                        crmworkComp.CRMRequestWOId = Convert.ToInt32(row["CRMRequestWOId"]);
                        crmworkComp.Timestamp = Convert.ToBase64String((byte[])(row["Timestamp"]));
                        crmworkComp.CRMRequestWONo = Convert.ToString(row["CRMWorkOrderNo"]);
                        crmworkComp.HiddenId = Convert.ToString(row["GuId"]);
                    }
                }
                crmworkComp.AssigneeEmail = assigneeEmail;
                crmworkComp.RequesterEmail = ReqEmail;
                if (sendacceptedmail == "sendmail")
                {
                    SendMailWOClosed(crmworkComp);
                }

                Log4NetLogger.LogExit(_FileName, nameof(Save), Level.Info.ToString());
                return crmworkComp;
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

        /******************* CRM Workorder Completion Info Tab Get *********************/
        public CRMWorkorderCompInfo GetCompInfo(int Id)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
            try
            {

                var dbAccessDAL = new DBAccessDAL();

                CRMWorkorderCompInfo entity = new CRMWorkorderCompInfo();

                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pUserId", 1.ToString());
                parameters.Add("@pCRMRequestWOId", Id.ToString());
                DataTable dt = dbAccessDAL.GetDataTable("UspFM_CRMRequestCompletionInfo_GetById", parameters, DataSetparameters);
                if (dt != null && dt.Rows.Count > 0)
                {
                    entity.CRMCompletionInfoId = Convert.ToInt16(dt.Rows[0]["CRMCompletionInfoId"]);
                    entity.CRMRequestWOId = Convert.ToInt16(dt.Rows[0]["CRMRequestWOId"]);
                    entity.StartDateTime = Convert.ToDateTime(dt.Rows[0]["StartDateTime"]);
                    entity.EndDateTime = Convert.ToDateTime(dt.Rows[0]["EndDateTime"]);
                    entity.CompletedById = dt.Rows[0].Field<int?>("CompletedBy");
                    entity.CompletedBy = Convert.ToString(dt.Rows[0]["CompletedByValue"] == System.DBNull.Value ? "" : dt.Rows[0]["CompletedByValue"]);
                    //entity.CompbyPositionId = Convert.ToInt16(dt.Rows[0]["CRMCompletionInfoId"]);
                    entity.CompbyPosition = Convert.ToString(dt.Rows[0]["CompletedbyDesignation"]);
                    entity.CompletedRemarks = Convert.ToString(dt.Rows[0]["CompletedbyRemarks"]);
                    entity.HandOverDateTime = Convert.ToDateTime(dt.Rows[0]["HandoverDateTime"]);
                    entity.AcceptedById = dt.Rows[0].Field<int?>("AcceptedBy");
                    entity.AcceptedBy = Convert.ToString(dt.Rows[0]["StaffName"]);
                    entity.Signature = Convert.ToString(dt.Rows[0]["Signature"]);
                    entity.Remarks = Convert.ToString(dt.Rows[0]["Remarks"]);
                    entity.Timestamp = Convert.ToBase64String((byte[])(dt.Rows[0]["Timestamp"]));
                    entity.WorkOrderStatusId = Convert.ToInt16(dt.Rows[0]["Status"]);
                    entity.WorkOrderStatus = Convert.ToString(dt.Rows[0]["StatusValue"]);
                }
                var model = Get(entity.CRMRequestWOId);
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

        /******************* CRM Workorder Completion Info Tab Get *********************/
        public CRMWorkorderProcessStatus GetProcessStatus(int Id)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(GetProcessStatus), Level.Info.ToString());
            try
            {

                var dbAccessDAL = new DBAccessDAL();

                CRMWorkorderProcessStatus entity = new CRMWorkorderProcessStatus();

                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pCRMRequestWOId", Id.ToString());
                DataSet dt = dbAccessDAL.GetDataSet("uspFM_CRMRequestProcessStatus_GetById", parameters, DataSetparameters);
                if (dt != null && dt.Tables[0].Rows.Count > 0)
                {

                    entity.CRMProcessStatusData = (from n in dt.Tables[0].AsEnumerable()
                                                         select new CRMProcessStatus
                                                         {
                                                             CRMProcessStatusId = Convert.ToInt32(n["CRMProcessStatusId"]),
                                                             WorkOrderStatus = Convert.ToString(n["Status"] == DBNull.Value ? "" : Convert.ToString(n["Status"])),
                                                             DoneBy = Convert.ToString(n["DoneBy"] == DBNull.Value ? "" : Convert.ToString(n["DoneBy"])),
                                                             Designation = Convert.ToString(n["DoneByDesignation"] == DBNull.Value ? "" : Convert.ToString(n["DoneByDesignation"])),
                                                             Date = n.Field <DateTime?>("DoneDate"),
                                                             StaffName = Convert.ToString(n["ReAssignedStaff"] == DBNull.Value ? "" : Convert.ToString(n["ReAssignedStaff"])),
                                                         }).ToList();
                }

                Log4NetLogger.LogExit(_FileName, nameof(GetProcessStatus), Level.Info.ToString());
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

        private void SendMailAssignee(CRMWorkorder model)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(SendMailAssignee), Level.Info.ToString());
            try
            {
                string emailTemplateId = string.Empty;
                string subject = string.Empty;
                string subjectVars = string.Empty;
                string templateVars = string.Empty;
                string email = string.Empty;

                email = model.StaffEmail;
                emailTemplateId = "39";
                //var tempid = Convert.ToInt32(emailTemplateId);
                //model.TemplateId = tempid;
                email = model.StaffEmail;

                templateVars = string.Join(",", model.CRMRequestWONo);

                var DataSetparameters = new Dictionary<string, DataTable>();
                DataTable TypecodeDt = new DataTable();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pEmailTemplateId", Convert.ToString(emailTemplateId));
                parameters.Add("@pToEmailIds", email);
                parameters.Add("@pSubject", Convert.ToString(subject));
                parameters.Add("@pPriority", Convert.ToString(1));
                parameters.Add("@pSendAsHtml", Convert.ToString(1));
                parameters.Add("@pSubjectVars", Convert.ToString(subjectVars));
                parameters.Add("@pTemplateVars", Convert.ToString(templateVars));
                parameters.Add("@pFacilityId", Convert.ToString(_UserSession.FacilityId));
                //parameters.Add("@pEmailTempId", Convert.ToString(ent.TemplateId));

                var dbAccessDAL = new DBAccessDAL();
                DataTable dt = dbAccessDAL.GetDataTable("uspFM_EmailNotify_Save", parameters, DataSetparameters);
                if (dt != null)
                {
                    foreach (DataRow rows in dt.Rows)
                    {


                    }
                }
                AssigneeNotification(model);
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
        public CRMWorkorder AssigneeNotification(CRMWorkorder ent)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(AssigneeNotification), Level.Info.ToString());
            CRMWorkorder griddata = new CRMWorkorder();
            var dbAccessDAL = new DBAccessDAL();
            var parameters = new Dictionary<string, string>();
            var DataSetparameters = new Dictionary<string, DataTable>();

            var notalert = ent.CRMRequestWONo + " " + "CRM Work Order has been Assigned to you";

            var hyplink = "/bems/crmworkorder?id=" + ent.CRMRequestWOId;

            parameters.Add("@pNotificationId", Convert.ToString(ent.NotificationId));
            parameters.Add("@pCustomerId", Convert.ToString(_UserSession.CustomerId));
            parameters.Add("@pFacilityId", Convert.ToString(_UserSession.FacilityId));
            parameters.Add("@pUserId", Convert.ToString(ent.UserId));
            parameters.Add("@pNotificationAlerts", Convert.ToString(notalert));
            parameters.Add("@pRemarks", Convert.ToString(""));
            parameters.Add("@pHyperLink", Convert.ToString(hyplink));
            parameters.Add("@pIsNew", Convert.ToString(1));
            parameters.Add("@pNotificationDateTime", Convert.ToString(null));

           

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

        private void SendMailWOClosed(CRMWorkorderCompInfo model)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(SendMailAssignee), Level.Info.ToString());
            try
            {
                string emailTemplateId = string.Empty;
                string subject = string.Empty;
                string subjectVars = string.Empty;
                string templateVars = string.Empty;
                string email = string.Empty;

                email = model.RequesterEmail;
                emailTemplateId = "66";
                var tempid = Convert.ToInt32(emailTemplateId);
                model.TemplateId = tempid;
                templateVars = string.Join(",", model.CRMRequestWONo);

                var DataSetparameters = new Dictionary<string, DataTable>();
                DataTable TypecodeDt = new DataTable();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pEmailTemplateId", Convert.ToString(emailTemplateId));
                parameters.Add("@pToEmailIds", email);
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
                 WOClosedNotification(model);
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

        public CRMWorkorderCompInfo WOClosedNotification(CRMWorkorderCompInfo ent)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(AssigneeNotification), Level.Info.ToString());
            CRMWorkorder griddata = new CRMWorkorder();
            var dbAccessDAL = new DBAccessDAL();
            var parameters = new Dictionary<string, string>();
            var DataSetparameters = new Dictionary<string, DataTable>();

            var notalert = ent.CRMRequestWONo + " " + "CRM Work Order is closed";

            var hyplink = "/bems/crmworkorder?id=" + ent.CRMRequestWOId;

            parameters.Add("@pNotificationId", Convert.ToString(ent.NotificationId));
            parameters.Add("@pCustomerId", Convert.ToString(_UserSession.CustomerId));
            parameters.Add("@pFacilityId", Convert.ToString(_UserSession.FacilityId));
            parameters.Add("@pUserId", Convert.ToString(ent.RequesterId));
            parameters.Add("@pNotificationAlerts", Convert.ToString(notalert));
            parameters.Add("@pRemarks", Convert.ToString(""));
            parameters.Add("@pHyperLink", Convert.ToString(hyplink));
            parameters.Add("@pIsNew", Convert.ToString(1));
            parameters.Add("@pNotificationDateTime", Convert.ToString(null));
            parameters.Add("@pEmailTempId", Convert.ToString(ent.TemplateId));

            parameters.Add("@pmScreenName", Convert.ToString("CRMRequestStatus"));
            parameters.Add("@pMGuid", Convert.ToString(ent.HiddenId));

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

        private void SendMailAssessCDone(CRMWorkorderAssessment model)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(SendMailAssignee), Level.Info.ToString());
            try
            {
                string emailTemplateId = string.Empty;
                string subject = string.Empty;
                string subjectVars = string.Empty;
                string templateVars = string.Empty;
                string email = string.Empty;

                email = model.RequesterEmail;
                emailTemplateId = "77";
                var tempid = Convert.ToInt32(emailTemplateId);
               // model.TemplateId = tempid;
                templateVars = string.Join(",", model.CRMRequestWONo);

                var DataSetparameters = new Dictionary<string, DataTable>();
                DataTable TypecodeDt = new DataTable();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pEmailTemplateId", Convert.ToString(emailTemplateId));
                parameters.Add("@pToEmailIds", email);
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
                AssessCDoneNotification(model);
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

        public CRMWorkorderAssessment AssessCDoneNotification(CRMWorkorderAssessment ent)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(AssigneeNotification), Level.Info.ToString());
            CRMWorkorderAssessment griddata = new CRMWorkorderAssessment();
            var dbAccessDAL = new DBAccessDAL();
            var parameters = new Dictionary<string, string>();
            var DataSetparameters = new Dictionary<string, DataTable>();

            var notalert = ent.CRMRequestWONo + " " + "Assessment is completed";

            var hyplink = "/bems/crmworkorder?id=" + ent.CRMRequestWOId;

            parameters.Add("@pNotificationId", Convert.ToString(ent.NotificationId));
            parameters.Add("@pCustomerId", Convert.ToString(_UserSession.CustomerId));
            parameters.Add("@pFacilityId", Convert.ToString(_UserSession.FacilityId));
            parameters.Add("@pUserId", Convert.ToString(ent.RequesterId));
            parameters.Add("@pNotificationAlerts", Convert.ToString(notalert));
            parameters.Add("@pRemarks", Convert.ToString(""));
            parameters.Add("@pHyperLink", Convert.ToString(hyplink));
            parameters.Add("@pIsNew", Convert.ToString(1));
            parameters.Add("@pNotificationDateTime", Convert.ToString(null));
            parameters.Add("@pEmailTempId", Convert.ToString(77));

            parameters.Add("@pmScreenName", Convert.ToString("CRMRequestStatus"));
            parameters.Add("@pMGuid", Convert.ToString(ent.HiddenId));

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
    }
}
