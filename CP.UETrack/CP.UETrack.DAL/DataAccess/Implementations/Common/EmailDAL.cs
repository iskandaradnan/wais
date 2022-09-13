using CP.ASIS.DAL.Helper;
using CP.Framework.Common.ExceptionHandler.ExceptionWrappers;
using CP.Framework.Common.Logging;
using CP.UETrack.DAL.DataAccess.Contracts;
using CP.UETrack.DAL.Helper;
using CP.UETrack.Model;
using CP.UETrack.Model.BEMS;
using CP.UETrack.Model.EMail;
using CP.UETrack.Model.GM;
using CP.UETrack.Model.VM;
using QRCoder;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Drawing;
using System.Drawing.Imaging;
using System.Dynamic;
using System.IO;
using System.Linq;
using UETrack.DAL;

namespace CP.UETrack.DAL.DataAccess.Implementation
{
    public class EmailDAL : IEmailDAL
    {
        private readonly string _FileName = nameof(CommonDAL);

        readonly UserDetailsModel _UserSession = new SessionHelper().UserSession();
        public EmailDAL()
        {

        }
        public void SendUserRegistrationEMail(UMUserRegistration userRegistration)
        {
            var loginName = string.Empty;
            var staffName = string.Empty;
            var password = string.Empty;
            var emailId = string.Empty;
            var createdBy = 0;
            try
            {
                loginName = userRegistration.UserName;
                staffName = userRegistration.StaffName;
                password = userRegistration.Password;
                emailId = userRegistration.Email;
                createdBy = _UserSession.UserId;
                var queueingUserName = _UserSession.UserName;

                if (!string.IsNullOrWhiteSpace(emailId))
                {
                    var hostName = ConfigurationManager.AppSettings["EmailIUrl"].ToString();
                    var emailContent = new EmailContent
                    {
                        ToEmailIds = new List<string> { emailId },
                        Subject = "User Registration",
                        EmailTemplateId = 1,
                        TemplateVars = new List<string> { staffName, loginName, hostName, loginName, password },
                        MailPriority = EmailPriority.High,
                        sendAsHtml = true,
                        SubjectVars = new List<string> { "UETrack - User Registration" }
                    };

                    var queueId = EMailHelper.QueueEmail(emailContent, createdBy, 0, 0);
                }
            }
            catch (Exception ex)
            {
                throw;
            }
        }
        public void SendUnblockUserEMail(string UserRegistrationIds)
        {
            try
            {
                var userRegistrationIds = UserRegistrationIds.Split(',').ToList();
                foreach (var userId in userRegistrationIds)
                {
                    var userIdInt = 0;
                    if (!int.TryParse(userId, out userIdInt))
                    {
                        continue;
                    }
                    string emailTemplateId = string.Empty;
                    string subject = string.Empty;
                    string subjectVars = string.Empty;
                    string templateVars = string.Empty;

                    var userRegistration = new UMUserRegistration();

                    var ds = new DataSet();
                    var dbAccessDAL1 = new DBAccessDAL();
                    using (SqlConnection con = new SqlConnection(dbAccessDAL1.ConnectionString))
                    {
                        using (SqlCommand cmd = new SqlCommand())
                        {
                            cmd.Connection = con;
                            cmd.CommandType = CommandType.StoredProcedure;
                            cmd.CommandText = "GetUserRegistration";
                            cmd.Parameters.AddWithValue("@Id", userId);
                            var da = new SqlDataAdapter();
                            da.SelectCommand = cmd;
                            da.Fill(ds);
                        }
                    }
                    if (ds.Tables.Count != 0 && ds.Tables[0].Rows.Count > 0)
                    {
                        userRegistration = (from n in ds.Tables[0].AsEnumerable()
                                            select new UMUserRegistration
                                            {
                                                StaffName = Convert.ToString(n["StaffName"]),
                                                Email = Convert.ToString(n["Email"]),
                                            }).FirstOrDefault();

                    }

                    templateVars = string.Join(",", userRegistration.StaffName);

                    var DataSetparameters = new Dictionary<string, DataTable>();
                    DataTable TypecodeDt = new DataTable();
                    var parameters = new Dictionary<string, string>();
                    parameters.Add("@pEmailTemplateId", "51");
                    parameters.Add("@pToEmailIds", userRegistration.Email);
                    parameters.Add("@pSubject", Convert.ToString(subject));
                    parameters.Add("@pPriority", Convert.ToString(1));
                    parameters.Add("@pSendAsHtml", Convert.ToString(1));
                    parameters.Add("@pSubjectVars", Convert.ToString(subjectVars));
                    parameters.Add("@pTemplateVars", Convert.ToString(templateVars));
                    parameters.Add("@pFacilityId", Convert.ToString(_UserSession.FacilityId));

                    var dbAccessDAL = new DBAccessDAL();
                    DataTable dt = dbAccessDAL.GetDataTable("uspFM_EmailNotify_Save", parameters, DataSetparameters);
                }
            }
            catch (Exception ex)
            {
                throw;
            }
        }
        public void SendTandCSubmittedEMail(string TandCDocumentNo, string RequesterEmailId)
        {
            try
            {
                string emailTemplateId = string.Empty;
                string subject = string.Empty;
                string subjectVars = string.Empty;
                string templateVars = string.Empty;
                
                templateVars = string.Join(",", TandCDocumentNo);

                var DataSetparameters = new Dictionary<string, DataTable>();
                DataTable TypecodeDt = new DataTable();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pEmailTemplateId", "52");
                parameters.Add("@pToEmailIds", RequesterEmailId);
                parameters.Add("@pSubject", Convert.ToString(subject));
                parameters.Add("@pPriority", Convert.ToString(1));
                parameters.Add("@pSendAsHtml", Convert.ToString(1));
                parameters.Add("@pSubjectVars", Convert.ToString(subjectVars));
                parameters.Add("@pTemplateVars", Convert.ToString(templateVars));
                parameters.Add("@pFacilityId", Convert.ToString(_UserSession.FacilityId));

                var dbAccessDAL = new DBAccessDAL();
                DataTable dt = dbAccessDAL.GetDataTable("uspFM_EmailNotify_Save", parameters, DataSetparameters);
            }
            catch (Exception ex)
            {
                throw;
            }
        }
        public void SendTandCApprovedEMail(string TandCDocumentNo, string RequesterEmailId)
        {
            try
            {
                string emailTemplateId = string.Empty;
                string subject = string.Empty;
                string subjectVars = string.Empty;
                string templateVars = string.Empty;

                templateVars = string.Join(",", TandCDocumentNo);

                var DataSetparameters = new Dictionary<string, DataTable>();
                DataTable TypecodeDt = new DataTable();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pEmailTemplateId", "53");
                parameters.Add("@pToEmailIds", RequesterEmailId);
                parameters.Add("@pSubject", Convert.ToString(subject));
                parameters.Add("@pPriority", Convert.ToString(1));
                parameters.Add("@pSendAsHtml", Convert.ToString(1));
                parameters.Add("@pSubjectVars", Convert.ToString(subjectVars));
                parameters.Add("@pTemplateVars", Convert.ToString(templateVars));
                parameters.Add("@pFacilityId", Convert.ToString(_UserSession.FacilityId));

                var dbAccessDAL = new DBAccessDAL();
                DataTable dt = dbAccessDAL.GetDataTable("uspFM_EmailNotify_Save", parameters, DataSetparameters);
            }
            catch (Exception ex)
            {
                throw;
            }
        }
        public void SendStopNotificationEMail(string Assetno, bool IsLoaner)
        {
            try
            {
                string emailTemplateId = string.Empty;
                string subject = string.Empty;
                string subjectVars = string.Empty;
                string templateVars = string.Empty;

                templateVars = string.Join(",", Assetno);
                emailTemplateId = IsLoaner ? "59" : "65";


                var DataSetparameters = new Dictionary<string, DataTable>();
                DataTable TypecodeDt = new DataTable();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pEmailTemplateId", emailTemplateId);
                parameters.Add("@pToEmailIds", "");
                parameters.Add("@pSubject", Convert.ToString(subject));
                parameters.Add("@pPriority", Convert.ToString(1));
                parameters.Add("@pSendAsHtml", Convert.ToString(1));
                parameters.Add("@pSubjectVars", Convert.ToString(subjectVars));
                parameters.Add("@pTemplateVars", Convert.ToString(templateVars));
                parameters.Add("@pFacilityId", Convert.ToString(_UserSession.FacilityId));

                var dbAccessDAL = new DBAccessDAL();
                DataTable dt = dbAccessDAL.GetDataTable("uspFM_EmailNotify_Save", parameters, DataSetparameters);
            }
            catch (Exception ex)
            {
                throw;
            }
        }
        public void SendCAREmail(CorrectiveActionReport correctiveActionReport)
        {
            try
            {
                string subject = string.Empty;
                string subjectVars = string.Empty;
                string templateVars = string.Empty;

                templateVars = string.Join(",", correctiveActionReport.CARNumber);

                var emailTemplateId = 0;
                switch (correctiveActionReport.CARStatus)
                {
                    case (int)CARStatus.Submitted:
                        emailTemplateId = (int)NotificationTemplateIds.QAPCARSubmission;
                        break;
                    case (int)CARStatus.Approved:
                        emailTemplateId = (int)NotificationTemplateIds.QAPCARApproved;
                        break;
                    case (int)CARStatus.Rejected:
                        emailTemplateId = (int)NotificationTemplateIds.QAPCARRejected;
                        break;
                }

                var userId = correctiveActionReport.AssignedUserId == null ? 0 : (int)correctiveActionReport.AssignedUserId;
                var ToEmailId = GetUserRegistrationInfo(userId).Email;

                var DataSetparameters = new Dictionary<string, DataTable>();
                DataTable TypecodeDt = new DataTable();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pEmailTemplateId", emailTemplateId.ToString());
                parameters.Add("@pToEmailIds", ToEmailId);
                parameters.Add("@pSubject", Convert.ToString(subject));
                parameters.Add("@pPriority", Convert.ToString(1));
                parameters.Add("@pSendAsHtml", Convert.ToString(1));
                parameters.Add("@pSubjectVars", Convert.ToString(subjectVars));
                parameters.Add("@pTemplateVars", Convert.ToString(templateVars));
                parameters.Add("@pFacilityId", Convert.ToString(_UserSession.FacilityId));

                var dbAccessDAL = new DBAccessDAL();
                DataTable dt = dbAccessDAL.GetDataTable("uspFM_EmailNotify_Save", parameters, DataSetparameters);
            }
            catch (Exception ex)
            {
                throw;
            }
        }
        public void SendWorkOrderReassignEmail(ScheduledWorkOrderModel workOrder)
        {
            try
            {
                string subject = string.Empty;
                string subjectVars = string.Empty;
                string templateVars = string.Empty;

                var emailTemplateId = (int)NotificationTemplateIds.WorkOrderReassigned;
                switch (workOrder.WorkOrderCategory)
                {
                    case (int)WorkOrderCategory.Scheduled:
                        subjectVars = "Scheduled";
                        break;
                    case (int)WorkOrderCategory.Unscheduled:
                        subjectVars = "Unscheduled";
                        break;
                }

                var userId = workOrder.TransferAssignedPersonId;
                var userDetails = GetUserRegistrationInfo(userId);
                templateVars = string.Join(",", subjectVars, workOrder.WorkOrderNo, userDetails.StaffName);

                
                var ToEmailId = userDetails.Email;

                var DataSetparameters = new Dictionary<string, DataTable>();
                DataTable TypecodeDt = new DataTable();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pEmailTemplateId", emailTemplateId.ToString());
                parameters.Add("@pToEmailIds", ToEmailId);
                parameters.Add("@pSubject", Convert.ToString(subject));
                parameters.Add("@pPriority", Convert.ToString(1));
                parameters.Add("@pSendAsHtml", Convert.ToString(1));
                parameters.Add("@pSubjectVars", Convert.ToString(subjectVars));
                parameters.Add("@pTemplateVars", Convert.ToString(templateVars));
                parameters.Add("@pFacilityId", Convert.ToString(_UserSession.FacilityId));

                var dbAccessDAL = new DBAccessDAL();
                DataTable dt = dbAccessDAL.GetDataTable("uspFM_EmailNotify_Save", parameters, DataSetparameters);
            }
            catch (Exception ex)
            {
                throw;
            }
        }
        public void SendWorkOrderVendorAssignEmail(ScheduledWorkOrderModel workOrder)
        {
            try
            {
                string subject = string.Empty;
                string subjectVars = string.Empty;
                string templateVars = string.Empty;

                var emailTemplateId = (int)NotificationTemplateIds.WorkOrderReassignedToVendor;
               
                var userId = workOrder.AssignedVendor == null ? 0 : (int)workOrder.AssignedVendor;
                var userDetails = GetContractorInfo(userId);
                templateVars = string.Join(",", workOrder.WorkOrderNo, userDetails.StaffName);


                var ToEmailId = userDetails.Email;

                var DataSetparameters = new Dictionary<string, DataTable>();
                DataTable TypecodeDt = new DataTable();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pEmailTemplateId", emailTemplateId.ToString());
                parameters.Add("@pToEmailIds", ToEmailId);
                parameters.Add("@pSubject", Convert.ToString(subject));
                parameters.Add("@pPriority", Convert.ToString(1));
                parameters.Add("@pSendAsHtml", Convert.ToString(1));
                parameters.Add("@pSubjectVars", Convert.ToString(subjectVars));
                parameters.Add("@pTemplateVars", Convert.ToString(templateVars));
                parameters.Add("@pFacilityId", Convert.ToString(_UserSession.FacilityId));

                var dbAccessDAL = new DBAccessDAL();
                DataTable dt = dbAccessDAL.GetDataTable("uspFM_EmailNotify_Save", parameters, DataSetparameters);
            }
            catch (Exception ex)
            {
                throw;
            }
        }
        private UMUserRegistration GetUserRegistrationInfo(int UserId)
        {
            var userDetails = new UMUserRegistration();

            var ds = new DataSet();
            var dbAccessDAL1 = new DBAccessDAL();
            using (SqlConnection con = new SqlConnection(dbAccessDAL1.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = con;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "GetUserRegistration";
                    cmd.Parameters.AddWithValue("@Id", UserId);
                    var da = new SqlDataAdapter();
                    da.SelectCommand = cmd;
                    da.Fill(ds);
                }
            }
            if (ds.Tables.Count != 0 && ds.Tables[0].Rows.Count > 0)
            {
                userDetails = (from n in ds.Tables[0].AsEnumerable()
                               select new UMUserRegistration
                               {
                                   StaffName = n.Field<string>("StaffName"),
                                   Email = n.Field<string>("Email")
                               }).FirstOrDefault();


            }
            return userDetails;
        }
        public UMUserRegistration GetContractorInfo(int UserId)
        {
            var userDetails = new UMUserRegistration();

            var ds = new DataSet();
            var dbAccessDAL1 = new DBAccessDAL();
            using (SqlConnection con = new SqlConnection(dbAccessDAL1.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = con;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "UspFM_EngAssetContractorandVendor_GetByContractorId";
                    cmd.Parameters.AddWithValue("@pContractorId", UserId);
                    var da = new SqlDataAdapter();
                    da.SelectCommand = cmd;
                    da.Fill(ds);
                }
            }
            if (ds.Tables.Count != 0 && ds.Tables[0].Rows.Count > 0)
            {
                userDetails = (from n in ds.Tables[0].AsEnumerable()
                               select new UMUserRegistration
                               {
                                   StaffName = n.Field<string>("StaffName"),
                                   Email = n.Field<string>("Email"),
                                   UserId = n.Field<int?>("UserRegistrationId")
                               }).FirstOrDefault();


            }
            return userDetails;
        }
    }
}