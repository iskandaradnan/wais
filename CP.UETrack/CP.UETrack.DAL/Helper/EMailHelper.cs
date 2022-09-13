namespace CP.ASIS.DAL.Helper
{
    using System;
    using System.Linq;
    using System.Collections.Generic;
    using UETrack.CodeLib.Helpers;
    using UETrack.Model.EMail;
    using UETrack.Models.EMail;
    using DataAccess.Implementations;

    public class Constants
    {
        public static string TEMPLATE_VAR_SEPARATOR = "|~$~|";
    }

    public enum NotificationTemplateLevelEnum
    {
        MoHLevel = 1,
        CompanyLevel =2,
        HospitalLevel = 3
    }

    public class EncodedInfo
    {
        public int CompanyId { get; set; }
    }

    public class EMailHelper
    {

        public static int QueueEmail(EmailContent emailContent, int UserId, int? companyId, int? hospitalId)
        {
            //companyId and hospitalId to be made not nullable; for time being to avoid compile errors, this is done; to be changed when all devs finish the implementation.
			//Tesing Purpose
            const int MAX_ATTACHMENT_COUNT = 5; // to be moved to config
            const int MAX_ATTACHMENT_SIZE_BYTES = 102400; // to be moved to config

            var queueId = 0;
            NotificationTemplateDAL notificationTemplateDAL;

            var toList = string.Empty;
            var ccList = string.Empty;

            try
            {
                //validations
                if (emailContent == null)
                {
                    //throw new ArgumentNullException(nameof(emailContent));
                    UETrackLogger.Log("EmailHelper.QueueEmail :: Argument Exception - Email could not be queued! 'emailContent' cannot be null!");
                    return queueId;
                }

                //if (companyId == null || hospitalId == null)
                //{
                //    throw new ArgumentNullException("companyId/hospitalId", "Company Id or Hospital Id cannot be null!");
                //}

                if (emailContent.Attachments != null)
                {
                    if (emailContent.Attachments.Count > MAX_ATTACHMENT_COUNT)
                    {
                        //throw new ArgumentException(string.Format("Maximum attachments cannot exceed {0}!", MAX_ATTACHMENT_COUNT), nameof(emailContent.Attachments));
                        UETrackLogger.Log("EmailHelper.QueueEmail :: Argument Exception - Email could not be queued!", string.Format("Maximum attachments cannot exceed {0}!", MAX_ATTACHMENT_COUNT));
                        return queueId;
                    }

                    var attachmentTotalBytes = 0;
                    emailContent.Attachments.ForEach(x => attachmentTotalBytes += x.Content.Length);
                }

                //to implement
                //if email template level is 3 then hospitalid is required, if level is 2 then companyid is required
                //
                notificationTemplateDAL = new NotificationTemplateDAL();

                var template = notificationTemplateDAL.GetTemplate(emailContent.EmailTemplateId);


                if (template == null)
                {
                    UETrackLogger.Log("EmailHelper.QueueEmail :: Argument Exception - Given Email Template is not valid", string.Format("Template Id: {0};", emailContent.EmailTemplateId));
                    return queueId;
                }
                //var templateLevel = template.LeastEntityLevel;

                //if (templateLevel == 3 && hospitalId == null)
                //{
                //    UETrackLogger.Log("EmailHelper.QueueEmail :: Argument Exception - Hospital Id is required for Level 3 template!", string.Format("Template Id: {0};", emailContent.EmailTemplateId));
                //    return queueId;
                //}
                //if (templateLevel == 2 && companyId == null)
                //{
                //    UETrackLogger.Log("EmailHelper.QueueEmail :: Argument Exception - Company Id is required for Level 2 template!", string.Format("Template Id: {0};", emailContent.EmailTemplateId));
                //    return queueId;
                //}

                var emailQueue = new EmailQueue
                {
                    ToIds = emailContent.ToEmailIds == null ? string.Empty : string.Join(",", emailContent.ToEmailIds),
                    CcIds = emailContent.CcEmailIds == null ? string.Empty : string.Join(",", emailContent.CcEmailIds),
                    ReplyIds = emailContent.ReplyEmailIds == null ? string.Empty : string.Join(",", emailContent.ReplyEmailIds),
                    Subject = emailContent.Subject,
                    EmailTemplateId = emailContent.EmailTemplateId,
                    TemplateVars = string.Join(Constants.TEMPLATE_VAR_SEPARATOR, emailContent.TemplateVars),
                    SubjectVars = emailContent.SubjectVars == null ? string.Empty : string.Join(Constants.TEMPLATE_VAR_SEPARATOR, emailContent.SubjectVars),
                    Priority = (byte)emailContent.MailPriority,
                    Status = (byte)EmailStatus.Queued,
                    SendAsHtml = emailContent.sendAsHtml,
                    QueuedBy = UserId.ToString(),
                    QueuedOn = DateTime.Now,
                    CreatedBy = UserId,
                    ModifiedBy = UserId,
                    IsDeleted = false
                };

                if (emailContent.Attachments != null)
                    emailContent.Attachments
                        .ForEach(x => emailQueue.EmailAttachments
                            .Add(new EmailAttachment
                            {
                                AttachmentName = x.AttachmentName,
                                AttachmentType = x.AttachmentType,
                                Content = x.Content
                            }));

                //replace template vars                    
                var templateDefinition = string.Empty;
                var templateSubject = string.Empty;
                var templateVars = new string[] { };
                var subjectVars = new string[] { };
                var body = string.Empty;

                if (template != null)
                {
                    templateDefinition = template.Definition;
                    templateSubject = template.Subject;

                    if (!string.IsNullOrEmpty(emailQueue.TemplateVars))
                        templateVars = emailQueue.TemplateVars.Split(new string[] { Constants.TEMPLATE_VAR_SEPARATOR }, StringSplitOptions.None);

                    if (!string.IsNullOrEmpty(emailQueue.SubjectVars))
                        subjectVars = emailQueue.SubjectVars.Split(new string[] { Constants.TEMPLATE_VAR_SEPARATOR }, StringSplitOptions.None);

                    emailQueue.ContentBody = templateDefinition;
                    emailQueue.Subject = templateSubject;

                    try // this try block is required to catch Format exceptions, occuring when number of vars in string input and string array dont match.
                    {
                        if (templateVars.Length > 0)
                        {
                            body = string.Format(templateDefinition, templateVars);
                            emailQueue.ContentBody = body;
                        }

                        if (subjectVars.Length > 0)
                            emailQueue.Subject = string.Format(templateSubject, subjectVars);

                    }
                    catch (Exception ex)
                    {
                        UETrackLogger.Log("Exception in QueueEmail during var replacement!", ex.Message);
                    }
                }

                if (!string.IsNullOrEmpty(emailQueue.ToIds))
                {
                    toList = emailQueue.ToIds;
                }

                if (!string.IsNullOrEmpty(emailQueue.CcIds))
                {
                    ccList = emailQueue.CcIds;
                }
                /*Need to implement*/

                //if (!string.IsNullOrEmpty(emailQueue.ToIds))
                //{
                //    toList = emailQueue.ToIds;
                //    if (!notificationTemplateDAL.IsCustomIdsAllowed(emailQueue.EmailTemplateId, "To"))
                //    {                        
                //        UETrackLogger.Log("EmailHelper.QueueEmail :: Custom To Ids not allowed!", string.Format("Template Id: {0};", emailContent.EmailTemplateId));
                //        if (!string.IsNullOrEmpty(toList))
                //            UETrackLogger.Log("EmailHelper.QueueEmail :: Custom To Ids discarded!", string.Format("Template Id: {0};", emailContent.EmailTemplateId));
                //        toList = string.Empty;
                //    }
                //}

                //if (!string.IsNullOrEmpty(emailQueue.CcIds))
                //{
                //    ccList = emailQueue.CcIds;
                //    if (!notificationTemplateDAL.IsCustomIdsAllowed(emailQueue.EmailTemplateId, "Cc"))
                //    {
                //        UETrackLogger.Log("EmailHelper.QueueEmail :: Custom Cc Ids not allowed!", string.Format("Template Id: {0};", emailContent.EmailTemplateId));
                //        if (!string.IsNullOrEmpty(ccList))
                //            UETrackLogger.Log("EmailHelper.QueueEmail :: Custom Cc Ids discarded!", string.Format("Template Id: {0};", emailContent.EmailTemplateId));
                //        ccList = string.Empty;                        
                //    }
                //}

                //if (templateLevel != null)
                //{
                /*Need to implement*/

                //var configuredEmails = notificationTemplateDAL.GetEmailsForTemplate(emailQueue.EmailTemplateId, (NotificationTemplateLevelEnum)templateLevel.Value, companyId.Value, hospitalId.Value);

                //configuredEmails.Where(x=> x.RecepientType.ToUpper() == "TO").ToList().ForEach(x => toList += "," + x.EmailId);

                //while (toList.Contains(",,"))
                //    toList = toList.Replace(",,", ",");

                //if (toList.StartsWith(","))
                //    toList = toList.Substring(1);

                //configuredEmails.Where(x => x.RecepientType.ToUpper() == "CC").ToList().ForEach(x => ccList += "," + x.EmailId);

                //while (ccList.Contains(",,"))
                //    ccList = ccList.Replace(",,", ",");

                //if (ccList.StartsWith(","))
                //    ccList = ccList.Substring(1);

                //UETrackLogger.Log("EmailHelper.QueueEmail :: ", string.Format("id:{0}; tolist:{1}; cclist: {2}", emailContent.EmailTemplateId, toList, ccList));
                //}

                emailQueue.ToIds = toList;
                emailQueue.CcIds = ccList;

                if (string.IsNullOrEmpty(emailQueue.ToIds))
                {
                    UETrackLogger.Log("EmailHelper.QueueEmail :: Email could not be queued! Atleast 1 'To' email id required to queue the email!");
                    return queueId;
                }

                queueId = notificationTemplateDAL.QueueEmail(emailQueue);                
            }
            catch (Exception ex)
            {
                UETrackLogger.Log(string.Format("EmailHelper.QueueEmail - Exception occured :: {0}", ex.Message));
            }
            finally
            {
                notificationTemplateDAL = null;
            }
            return queueId;
        }

        //public static List<int> QueueSMS(SMSContent smsContent, int UserId, int? companyId, int? hospitalId)
        //{
        //    var queueIds = new List<int>();

        //    NotificationTemplateDAL notificationTemplateDAL;

        //    try
        //    {
        //        //validations
        //        if (smsContent == null)
        //        {
        //            //throw new ArgumentNullException(nameof(smsContent));
        //            UETrackLogger.Log("EmailHelper.QueueSMS :: Argument Exception - SMS could not be queued! 'smsContent' cannot be null!");
        //            return queueIds;
        //        }

        //        if (companyId == null || hospitalId == null)
        //        {
        //            throw new ArgumentNullException("companyId/hospitalId", "Company Id or Hospital Id cannot be null!");
        //        }

        //        //to implement
        //        //if email template level is 3 then hospitalid is required, if level is 2 then companyid is required
             
        //        notificationTemplateDAL = new NotificationTemplateDAL();

        //        var template = notificationTemplateDAL.GetTemplate(smsContent.EmailTemplateId);
        //        if (template == null)
        //        {
        //            UETrackLogger.Log("EmailHelper.QueueEmail :: Argument Exception - Given Email Template is not valid", string.Format("Template Id: {0};", smsContent.EmailTemplateId));
        //            return queueIds;
        //        }
        //        var templateLevel = template.LeastEntityLevel;

        //        if (templateLevel == 3 && hospitalId == null)
        //        {
        //            UETrackLogger.Log("EmailHelper.QueueEmail :: Argument Exception - Hospital Id is required for Level 3 template!", string.Format("Template Id: {0};", smsContent.EmailTemplateId));
        //            return queueIds;
        //        }
        //        if (templateLevel == 2 && companyId == null)
        //        {
        //            UETrackLogger.Log("EmailHelper.QueueEmail :: Argument Exception - Company Id is required for Level 2 template!", string.Format("Template Id: {0};", smsContent.EmailTemplateId));
        //            return queueIds;
        //        }

        //        //replace template vars                    
        //        var templateDefinition = string.Empty;
        //        var templateVars = new string[] { };
        //        var body = string.Empty;
                
        //        if (template != null)
        //        {
        //            templateDefinition = template.Definition;
        //            body = templateDefinition;
                
        //            if (smsContent.TemplateVars != null && smsContent.TemplateVars.Count > 0)
        //                templateVars = smsContent.TemplateVars.ToArray();

        //            try // this try block is required to catch Format exceptions, occuring when number of vars in string input and string array dont match.
        //            {
        //                if (templateVars.Length > 0)
        //                {
        //                    body = string.Format(templateDefinition, templateVars);
        //                }
        //            }
        //            catch (Exception ex)
        //            {
        //                UETrackLogger.Log("Exception in QueueEmail during var replacement!", ex.Message);
        //            }
        //        }
              
        //        if (smsContent.DestinationNos != null && smsContent.DestinationNos.Count > 0)
        //        {
        //            if (!notificationTemplateDAL.IsCustomIdsAllowed(smsContent.EmailTemplateId, "To"))
        //            {
        //                UETrackLogger.Log("EmailHelper.QueueEmail :: Custom To Ids not allowed!", string.Format("Template Id: {0};", smsContent.EmailTemplateId));
        //                UETrackLogger.Log("EmailHelper.QueueEmail :: Custom To Ids discarded!", string.Format("Template Id: {0};", smsContent.EmailTemplateId));
        //                smsContent.DestinationNos = null;
        //            }
        //        }

        //        var smsOjs = new List<SMSQueue>();

        //        var currentDateTime = DateTime.Now;

        //        if (templateLevel != null)
        //        {
        //            var configuredSMSs = notificationTemplateDAL.GetSMSForTemplate(smsContent.EmailTemplateId, (NotificationTemplateLevelEnum)templateLevel.Value, companyId.Value, hospitalId.Value);

        //            foreach (var obj in configuredSMSs)
        //            {
        //                smsOjs.Add(new SMSQueue
        //                {
        //                    SourceNo = "123",
        //                    DestinationNo = obj.DestinationNo.Contains('-') ? obj.DestinationNo.Remove(obj.DestinationNo.IndexOf('-'),1): obj.DestinationNo,
        //                    MessageText = body,
        //                    QueuedOn = currentDateTime,
        //                    QueuedBy = UserId.ToString(),
        //                    CreatedBy = UserId,
        //                    CreatedDate = currentDateTime,
        //                    MessageStatus = 0,
        //                    Companyid = companyId
        //                });
        //            }
                  
        //        }

        //        if (smsContent.DestinationNos != null && smsContent.DestinationNos.Count > 0)
        //        {
        //            foreach (var destinationNo in smsContent.DestinationNos)
        //            {
        //                smsOjs.Add(new SMSQueue
        //                {
        //                    SourceNo = "123",
        //                    DestinationNo = destinationNo.Contains('-') ? destinationNo.Remove(destinationNo.IndexOf('-'), 1) : destinationNo,
        //                    MessageText = body,
        //                    QueuedOn = currentDateTime,
        //                    QueuedBy = UserId.ToString(),
        //                    CreatedBy = UserId,
        //                    CreatedDate = currentDateTime,
        //                    MessageStatus = 0,
        //                    Companyid = companyId
        //                });
        //            }
        //        }

        //        if (smsOjs.Count == 0)
        //        {
        //            UETrackLogger.Log("EmailHelper.QueueSMS :: SMS could not be queued! Atleast 1 'To' mobile no is required to queue the SMS!");
        //            return queueIds;
        //        }

        //        queueIds = notificationTemplateDAL.QueueSMS(smsOjs);
        //    }
        //    catch (Exception ex)
        //    {
        //        UETrackLogger.Log(string.Format("EmailHelper.QueueSMS - Exception occured :: {0}", ex.Message));
        //    }
        //    finally
        //    {
        //        notificationTemplateDAL = null;
        //    }
        //    return queueIds;
        //}      

        public static string GetEncodedUrl(EncodedInfo info)
        {
            return string.Empty;

        }

    }

}
