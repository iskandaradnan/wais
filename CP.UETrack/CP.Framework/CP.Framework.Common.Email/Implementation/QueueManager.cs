namespace CP.Framework.Common.Email
{
    using Logging;
    using System;
    using System.Data;
    using System.Linq;
    using System.Collections.Generic;
    using System.Configuration;
    using System.Data.Entity;
    using System.Data.Entity.SqlServer;
    using System.Net;
    using System.Data.SqlClient;

    public class QueueManager
    {
        private Log4NetLogger _logger;
        private DbContext _emailDbContext;

        public QueueManager()
        {
            _logger = new Log4NetLogger();
        }
        public QueueManager(Log4NetLogger logger)
        {
            _logger = logger;
        }
        public QueueManager(Log4NetLogger logger, DbContext dbContext)
        {
            _logger = logger;
            _emailDbContext = dbContext;

        }
        public int QueueEmail(EmailContent emailContent, string QueuingUserName, int UserId)
        {
            const int MAX_ATTACHMENT_COUNT = 5; // to be moved to config
            const int MAX_ATTACHMENT_SIZE_BYTES = 1024; // to be moved to config

            //validations
            if (emailContent == null)
                throw new ArgumentNullException(nameof(emailContent));

            if (string.IsNullOrEmpty(QueuingUserName))
                throw new ArgumentNullException(nameof(QueuingUserName));

            if (emailContent.ToEmailIds == null || emailContent.ToEmailIds.Count == 0)
                throw new ArgumentNullException(nameof(emailContent.ToEmailIds));

            if (emailContent.Attachments != null)
            {
                if (emailContent.Attachments.Count > MAX_ATTACHMENT_COUNT)
                    throw new ArgumentException(string.Format("Maximum attachments cannot exceed {0}!", MAX_ATTACHMENT_COUNT), nameof(emailContent.Attachments));

                var attachmentTotalBytes = 0;
                emailContent.Attachments.ForEach(x => attachmentTotalBytes += x.Content.Length);
                if (attachmentTotalBytes > MAX_ATTACHMENT_SIZE_BYTES)
                    throw new ArgumentException(string.Format("Total attachment size cannot exceed {0} bytes!", MAX_ATTACHMENT_SIZE_BYTES), nameof(emailContent.Attachments));

            }


            //
            var queueId = 0;

            var emailQueue = new EmailQueue()
            {
                ToIds = string.Join(",", emailContent.ToEmailIds),
                CcIds = emailContent.CcEmailIds == null ? string.Empty : string.Join(",", emailContent.CcEmailIds),
                BccIds = emailContent.BccEmailIds == null ? string.Empty : string.Join(",", emailContent.BccEmailIds),
                ReplyIds = emailContent.ReplyEmailIds == null ? string.Empty : string.Join(",", emailContent.ReplyEmailIds),

                Subject = emailContent.Subject,
                EmailTemplateId = emailContent.EmailTemplateId,
                TemplateVars = string.Join(Constants.TEMPLATE_VAR_SEPARATOR, emailContent.TemplateVars),
                SubjectVars = emailContent.SubjectVars == null ? string.Empty : string.Join(Constants.TEMPLATE_VAR_SEPARATOR, emailContent.SubjectVars),

                Priority = (byte)emailContent.MailPriority,
                Status = (byte)EmailStatus.Queued,
                SendAsHtml = emailContent.sendAsHtml,

                QueuedBy = QueuingUserName,
                QueuedOn = DateTime.Now,
                CreatedDate = DateTime.Now,
                ModifiedDate = DateTime.Now,
                CreatedBy = UserId,
                ModifiedBy = UserId,
                IsDeleted = false
            };

            //if (emailContent.Attachments != null)
            //    emailContent.Attachments
            //        .ForEach(x => emailQueue.EmailAttachment
            //            .Add(new EmailAttachment() { AttachmentName = x.AttachmentName, AttachmentType = x.AttachmentType, Content = x.Content }));

            //using (var context = new EmailEntities())
            //{
            //    try
            //    {
            //        var newEntity = context.EmailQueue.Add(emailQueue);
            //        context.SaveChanges();
            //        queueId = newEntity.EmailQueueId;
            //    }
            //    catch (Exception ex)
            //    {
            //        if (_logger != null)
            //            _logger.LogException(ex, Level.Error);

            //        throw ex;
            //    }

            //}

            return queueId;

        }
        public int ProcessQueue()
        {
            var processedCount = 0;

            var processStatus = new int[] { (int)EmailStatus.Queued/*, (int)EmailStatus.Failed*/ };
            var processPriority = new int[] { (int)EmailPriority.High, (int)EmailPriority.Normal, (int)EmailPriority.Low };
            var imagePath = ConfigurationManager.AppSettings["webrootpath"];
            int RetrieveEmail = Convert.ToInt32(System.Configuration.ConfigurationManager.AppSettings["RetrieveEmail"]);
            RetrieveEmail = RetrieveEmail == 0 ? 10 : RetrieveEmail;
            int CommandTimeout = Convert.ToInt32(System.Configuration.ConfigurationManager.AppSettings["EmailEntitiesCommandTimeout"]);
            CommandTimeout = CommandTimeout == 0 ? 120 : CommandTimeout;
            int UpdateStatus = UpdateFailEmail(CommandTimeout);
            _logger.LogMessage(string.Format("{0} emails are realigned for processing due to unexpected circumstances!", UpdateStatus), Level.Info);

            string hostName = Dns.GetHostName(); // Retrive the Name of HOST           
            string myIP = Convert.ToString(Dns.GetHostByName(hostName).AddressList[0]);
            try
            {
                foreach (var priority in processPriority)
                {
                    foreach (var status in processStatus)
                    {
                        var emails = new List<EmailQueue>();
                        var emailAttachments = new List<EmailAttachment>();
                        var exclusionList = new List<EmailExclusionList>();

                        var ds = new DataSet();
                        var dbAccessDAL = new DBAccess();
                        using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                        {
                            using (SqlCommand cmd = new SqlCommand())
                            {
                                cmd.Connection = con;
                                cmd.CommandType = CommandType.StoredProcedure;
                                cmd.CommandText = "uspFM_EmailQueue_GetByStatus";
                                cmd.Parameters.AddWithValue("@pStatus", status);
                                cmd.Parameters.AddWithValue("@pPriority", priority);
                                cmd.Parameters.AddWithValue("@pRetrieveEmail", RetrieveEmail);
                                cmd.Parameters.AddWithValue("@pMyIp", myIP);
                                cmd.CommandTimeout = CommandTimeout;

                                var da = new SqlDataAdapter();
                                da.SelectCommand = cmd;
                                da.Fill(ds);
                            }
                        }
                        if (ds.Tables.Count != 0)
                        {
                            if (ds.Tables[0] != null && ds.Tables[0].Rows.Count > 0)
                            {
                                emails = (from n in ds.Tables[0].AsEnumerable()
                                          select new EmailQueue
                                          {
                                              EmailQueueId = n.Field<int>("EmailQueueId"),
                                              ToIds = n.Field<string>("ToIds"),
                                              CcIds = n.Field<string>("CcIds"),
                                              BccIds = n.Field<string>("BccIds"),
                                              ReplyIds = n.Field<string>("ReplyIds"),
                                              Subject = n.Field<string>("Subject"),
                                              EmailTemplateId = n.Field<int>("EmailTemplateId"),
                                              ContentBody = n.Field<string>("ContentBody"),
                                              SendAsHtml = n.Field<bool>("SendAsHtml"),
                                              Priority = n.Field<int>("Priority"),
                                              Status = n.Field<int>("Status"),
                                              FailCount = n.Field<int>("FailCount")
                                          }).ToList();
                            }
                            if (ds.Tables[2] != null && ds.Tables[2].Rows.Count > 0)
                            {
                                emailAttachments = (from n in ds.Tables[2].AsEnumerable()
                                                    select new EmailAttachment
                                                    {
                                                        EmailQueueId = n.Field<int>("EmailQueueId"),
                                                        AttachmentName = n.Field<string>("AttachmentName"),
                                                        AttachmentType = n.Field<string>("AttachmentType"),
                                                        Content = n.Field<byte[]>("Content")
                                                    }).ToList();
                            }
                            if (ds.Tables[1] != null && ds.Tables[1].Rows.Count > 0)
                            {
                                exclusionList = (from n in ds.Tables[1].AsEnumerable()
                                                 select new EmailExclusionList
                                                 {
                                                     EmailTemplateId = n.Field<int>("EmailTemplateId"),
                                                     EmailAddress = n.Field<string>("EmailAddress"),
                                                     Type = n.Field<int>("Type")
                                                 }).ToList();
                            }
                        }
                        //using (var context = new EmailEntities())
                        //{
                        //context.Database.CommandTimeout = CommandTimeout;
                        //    var emails = context.EmailQueue.Where(x => x.Status == status && x.Priority == priority).OrderBy(x => x.EmailQueueId).Take(RetrieveEmail).ToList();
                        //    emails.ForEach(x => { x.Status = 4; x.ModifiedDate = DateTime.Now; x.SourceIp = myIP; });
                        //    context.SaveChanges();

                            foreach (var email in emails)
                            {
                                try
                                {
                                    var result = false;

                                    //var template = context.NotificationTemplate.Where(x => x.NotificationTemplateId == email.EmailTemplateId);
                                    //var templateDefinition = string.Empty;
                                    //var templateSubject = string.Empty;
                                    //var body = string.Empty;
                                    string ToIds = string.Empty;
                                    string CcIds = string.Empty;
                                    string BccIds = string.Empty;
                                    string ReplyIds = string.Empty;

                                    //if (template != null && !string.IsNullOrEmpty(email.TemplateVars))
                                    //{
                                        //var EmailExclusion = context.EmailExclusionList.Where(x => !x.IsDeleted
                                        //&& x.EmailTemplateId == email.EmailTemplateId && x.Type == 2).Select(x => x.EmailAddress).ToList();

                                        //var EmailInclusion = context.EmailExclusionList.
                                        //    Where(x => !x.IsDeleted && x.EmailTemplateId == email.EmailTemplateId && x.Type == 1
                                        //    && x.CompanyId == email.CompanyId && email.CompanyId.HasValue
                                        //    && x.HospitalId == email.HospitalId && email.HospitalId.HasValue
                                        //    ).Select(x => x.EmailAddress).ToList();

                                var EmailExclusion = exclusionList.Where(x=>x.EmailTemplateId == email.EmailTemplateId && x.Type == 2).Select(x=>x.EmailAddress).ToList();
                                var EmailInclusion = exclusionList.Where(x=>x.EmailTemplateId == email.EmailTemplateId && x.Type == 1).Select(x => x.EmailAddress).ToList();

                                ToIds = GetEmailList(email.ToIds, EmailExclusion, EmailInclusion);
                                        CcIds = GetEmailList(email.CcIds, EmailExclusion, EmailInclusion);
                                        BccIds = GetEmailList(email.BccIds, EmailExclusion, EmailInclusion);
                                        ReplyIds = GetEmailList(email.ReplyIds, EmailExclusion, EmailInclusion);

                                //templateDefinition = template.FirstOrDefault().Definition;
                                //templateSubject = template.FirstOrDefault().Subject;
                                //var vars = email.TemplateVars.Split(new string[] { Constants.TEMPLATE_VAR_SEPARATOR }, StringSplitOptions.None);
                                //try
                                //{
                                //    body = string.Format(templateDefinition, vars);
                                //    templateDefinition = templateDefinition.Replace(Constants.TEMPLATE_VAR_SEPARATOR, imagePath);

                                //    if (email.Subject == null && string.IsNullOrEmpty(email.Subject))
                                //    {
                                //        var subjectVars = email.SubjectVars.Split(new string[] { Constants.TEMPLATE_VAR_SEPARATOR }, StringSplitOptions.None);
                                //        email.Subject = string.Format(templateSubject, subjectVars);
                                //    }
                                //}
                                //catch (Exception)
                                //{
                                //    //log ex
                                //}

                                //if (!string.IsNullOrEmpty(body))
                                //        {
                                    List<Attachment> files = null;
                                    //var attachments = context.EmailAttachment.Where(x => x.EmailQueueId == email.EmailQueueId).ToList();
                                var attachments = emailAttachments.Where(x => x.EmailQueueId == email.EmailQueueId).ToList();
                                if (attachments.Any())
                                    {
                                        files = new List<Attachment>();
                                        attachments.ForEach(x => files.Add(new Attachment { AttachmentName = x.AttachmentName, AttachmentType = x.AttachmentType, Content = x.Content }));
                                    }

                                    result = SmtpHelper.SendEmail(ToIds, CcIds, BccIds, ReplyIds, email.Subject, email.ContentBody, files, email.SendAsHtml);

                                        //}
                                    //}

                                    //if (template != null && string.IsNullOrEmpty(email.TemplateVars))
                                    //{
                                    //    templateDefinition = template.FirstOrDefault().Definition;
                                    //    body = templateDefinition;
                                    //    if (!string.IsNullOrEmpty(body))
                                    //    {
                                    //        List<Attachment> files = null;
                                    //        var attachments = context.EmailAttachment.Where(x => x.EmailQueueId == email.EmailQueueId).ToList();
                                    //        if (attachments.Any())
                                    //        {
                                    //            files = new List<Attachment>();
                                    //            attachments.ForEach(x => files.Add(new Attachment { AttachmentName = x.AttachmentName, AttachmentType = x.AttachmentType, Content = x.Content }));
                                    //        }

                                    //        result = SmtpHelper.SendEmail(ToIds, CcIds, BccIds, ReplyIds, email.Subject, body, files, email.SendAsHtml);

                                    //    }
                                    //}
                                    processedCount++;

                                    if (result)
                                    {
                                        email.Status = (int)EmailStatus.Sent;
                                        email.SentOn = DateTime.Now;
                                    }
                                    else
                                    {
                                        email.Status = (int)EmailStatus.Failed;
                                        email.FailedOn = DateTime.Now;
                                        email.FailCount = (email.FailCount + 1);
                                    }

                                }
                                catch (Exception ex)
                                {
                                    email.FailedOn = DateTime.Now;
                                    email.Status = (int)EmailStatus.Failed;
                                    email.FailCount = (email.FailCount + 1);
                                    _logger.LogException(ex, Level.Error);
                                }
                                finally
                                {
                                //context.Entry(email).State = EntityState.Modified;
                                //context.SaveChanges();
                               
                                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                                {
                                    using (SqlCommand cmd = new SqlCommand())
                                    {
                                        cmd.Connection = con;
                                        cmd.CommandType = CommandType.StoredProcedure;
                                        cmd.CommandText = "uspFM_EmailQueue_EmailQueueId";
                                        cmd.Parameters.AddWithValue("@pStatus", email.Status);
                                        cmd.Parameters.AddWithValue("@pSentOn", email.SentOn);
                                        cmd.Parameters.AddWithValue("@pFailedOn", email.FailedOn);
                                        cmd.Parameters.AddWithValue("@pFailCount", email.FailCount);
                                        cmd.Parameters.AddWithValue("@pFlag", email.Status);
                                        cmd.Parameters.AddWithValue("@pEmailQueueId", email.EmailQueueId);

                                        con.Open();
                                        cmd.ExecuteNonQuery();
                                        con.Close();
                                    }
                                }
                            }
                            }
                        //}
                    }
                }

            }
            catch (Exception ex)
            {
                if (_logger != null)
                    _logger.LogException(ex, Level.Error);

                throw ex;
            }

            //}

            return processedCount;

        }
        public int UpdateFailEmail(int CommandTimeout)
        {

            int EmailFailTimeout = Convert.ToInt32(System.Configuration.ConfigurationManager.AppSettings["EmailFailTimeout"]);
            EmailFailTimeout = EmailFailTimeout == 0 ? 5 : EmailFailTimeout;
            int count = 0;
            var CurrentDate = DateTime.Now;
            //using (var context = new EmailEntities())
            //{
            //    context.Database.CommandTimeout = CommandTimeout;
            //    var FailEmail = context.EmailQueue.Where(x => x.Status == 4 && CurrentDate >= SqlFunctions.DateAdd("minute", EmailFailTimeout, x.ModifiedDate));
            //    count = FailEmail.Count();
            //    if (count > 0)
            //    {
            //        FailEmail.ToList().ForEach(x => { x.Status = 1; x.ModifiedDate = DateTime.Now; });
            //        context.SaveChanges();
            //    }
            //}
            var ds = new DataSet();
            var dbAccessDAL = new DBAccess();
            using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = con;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "uspFM_UpdateFailEmail_Save";
                    cmd.Parameters.AddWithValue("@pEmailFailTimeout", EmailFailTimeout);
                    cmd.CommandTimeout = CommandTimeout;

                    var da = new SqlDataAdapter();
                    da.SelectCommand = cmd;
                    da.Fill(ds);
                }
            }
            if (ds.Tables.Count != 0 && ds.Tables[0].Rows.Count > 0)
            {
                int.TryParse(ds.Tables[0].Rows[0][0].ToString(), out count);
            }

            return count;
        }
        private static string GetEmailList(string Eailid,List<string> EmailExclusion, List<string> EmailInclusion)
        {
            string Email = string.Empty;
            var Eamillist = new List<string>();
           
            if(Eailid!=null)
               Eamillist = Eailid.Split(',').ToList();

            if(EmailExclusion!=null && EmailExclusion.Count>0)            
                Eamillist = Eamillist.Where(x => !EmailExclusion.Contains(x)).ToList();
            
            if(EmailInclusion!=null && EmailInclusion.Count>0)            
                Eamillist = Eamillist.Concat(EmailInclusion.ToList()).ToList();
            
            Email = Eamillist!=null && Eamillist.Count>0 ? string.Join(",", Eamillist):"";
            //return string.Join(",", Eailid.Split(',').ToList().Where(x => !EmailExclusion.Contains(x)).ToList());
            return Email;
        }
        public void ProcessScheduledEmail()
        {
            try
            {
                _logger.LogMessage("QueueEmail Entry", Level.Info);

                int CommandTimeout = Convert.ToInt32(System.Configuration.ConfigurationManager.AppSettings["EmailEntitiesCommandTimeout"]);
                var dbAccessDAL = new DBAccess();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_TandCCompletionDate_EmailJob"; // senthil
                        cmd.CommandTimeout = CommandTimeout;

                        con.Open();
                        cmd.ExecuteNonQuery();

                        cmd.Parameters.Clear();
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_AssetWarrantyEndDate_EmailJob"; // senthil
                        cmd.CommandTimeout = CommandTimeout;
                        cmd.ExecuteNonQuery();

                        cmd.Parameters.Clear();
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_QapCarTxn_Auto_Save"; // senthil
                        cmd.CommandTimeout = CommandTimeout;
                        cmd.ExecuteNonQuery();

                        cmd.Parameters.Clear();
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_QapCarTxnB2_Auto_Save"; // senthil
                        cmd.CommandTimeout = CommandTimeout;
                        cmd.ExecuteNonQuery();

                        cmd.Parameters.Clear();
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_PorteringTransactionEmailNotify_Save";
                        cmd.CommandTimeout = CommandTimeout;
                        cmd.ExecuteNonQuery();


                        cmd.Parameters.Clear();
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_EngTrainingScheduleTxn_Job";
                        cmd.CommandTimeout = CommandTimeout;
                        cmd.ExecuteNonQuery();

                        cmd.Parameters.Clear();
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_QAPCarTxnTargetDate_Job";
                        cmd.CommandTimeout = CommandTimeout;
                        cmd.ExecuteNonQuery();

                        cmd.Parameters.Clear();
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_QAPCarNotApproved_Job";
                        cmd.CommandTimeout = CommandTimeout;
                        cmd.ExecuteNonQuery();

                        cmd.Parameters.Clear();
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_MonthlyServiceFee_Save";
                        cmd.CommandTimeout = CommandTimeout;
                        cmd.ExecuteNonQuery();

                        con.Close();
                    }
                }
                _logger.LogMessage("QueueEmail Exit", Level.Info);
            }
            catch (Exception ex)
            {
                if (_logger != null)
                    _logger.LogException(ex, Level.Error);

                throw ex;
            }

        }
    }
}
