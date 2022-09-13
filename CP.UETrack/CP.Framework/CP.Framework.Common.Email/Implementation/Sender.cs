namespace CP.Framework.Common.Email
{
    using Logging;
    using System;
    using System.Collections.Generic;
    using System.Configuration;
    using System.IO;
    using System.Net.Mail;
    using System.Net.Mime;

    public static class SmtpHelper
    {
        static bool enableSsl;
        static string smtpHost;
        static string smtpPort;
        static string fromMailId;
        static string smtpUserId;
        static string smtpPassword;
        static SmtpClient smtpClient;
        private static Log4NetLogger _logger;
        static SmtpHelper()
        {
            _logger = new Log4NetLogger();
            enableSsl = false;
            bool.TryParse(ConfigurationManager.AppSettings["SmtpEnableSsl"], out enableSsl);

            smtpHost = ConfigurationManager.AppSettings["SmtpHost"];
            smtpPort = ConfigurationManager.AppSettings["SmtpPort"];

            fromMailId = ConfigurationManager.AppSettings["FromMailId"];
            smtpUserId = ConfigurationManager.AppSettings["SmtpUserId"];
            smtpPassword = ConfigurationManager.AppSettings["SmtpPassword"];

            smtpClient = new SmtpClient();
            smtpClient.EnableSsl = enableSsl;
            smtpClient.Host = smtpHost;
            if (!string.IsNullOrEmpty(smtpPort))
                smtpClient.Port = int.Parse(smtpPort);

            if (!string.IsNullOrEmpty(smtpUserId))
                smtpClient.Credentials = new System.Net.NetworkCredential(smtpUserId, smtpPassword);

        }

        public static bool SendEmail(string toAddrCsv, string ccAddrCsv, string bccAddrCsv, string replyAddrCsv, string subject, string body, List<Attachment> files = null, bool isBodyHtml = true)
        {
            var result = false;
            MailMessage mailMessage = null;

            try
            {
                string mediaType = isBodyHtml ? MediaTypeNames.Text.Html : MediaTypeNames.Text.Plain;

                var alterView = AlternateView.CreateAlternateViewFromString(body, System.Text.Encoding.Default, mediaType);

                mailMessage = new MailMessage();
                mailMessage.Subject = subject;
                mailMessage.Body = body;
                mailMessage.AlternateViews.Add(alterView);
                mailMessage.IsBodyHtml = isBodyHtml;

                string FromEmailDisplayName = Convert.ToString(System.Configuration.ConfigurationManager.AppSettings["FromEmailDisplayName"]);
                mailMessage.From = new MailAddress(fromMailId, FromEmailDisplayName);

                if (toAddrCsv != null)
                {
                    foreach (var item in toAddrCsv.Split(','))
                        if (!string.IsNullOrEmpty(item))
                            mailMessage.To.Add(item);
                }

                if (ccAddrCsv != null)
                {
                    foreach (var item in ccAddrCsv.Split(','))
                        if (!string.IsNullOrEmpty(item))
                            mailMessage.CC.Add(item);

                }

                if (bccAddrCsv != null)
                {
                    foreach (var item in bccAddrCsv.Split(','))
                        if (!string.IsNullOrEmpty(item))
                            mailMessage.Bcc.Add(item);
                }

                if (replyAddrCsv != null)
                {
                    foreach (var item in replyAddrCsv.Split(','))
                        if (!string.IsNullOrEmpty(item))
                            mailMessage.ReplyToList.Add(item);
                }
                if (files != null)
                {
                    foreach (var file in files)
                    {
                        if (file.Content.Length > 0)
                        {
                            var fileDetails = GetFileContentType(file.AttachmentType);
                            var fileBinary = new MemoryStream(file.Content);
                            fileBinary.Seek(0, SeekOrigin.Begin);
                            var mailAttachment = new System.Net.Mail.Attachment(fileBinary, file.AttachmentName+"." + Convert.ToString(fileDetails[0]).ToLower(), Convert.ToString(fileDetails[1]));
                            mailAttachment.ContentDisposition.DispositionType = DispositionTypeNames.Attachment;
                            mailMessage.Attachments.Add(mailAttachment);
                        }
                    }
                }

                smtpClient.Send(mailMessage);
                result = true;

            }
            catch (SmtpException sx)
            {
                _logger.LogException(sx, Level.Error);
            }
            catch (Exception ex)
            {
                _logger.LogException(ex, Level.Error);
            }
            finally
            {
                if (mailMessage != null) mailMessage.Dispose();
            }

            return result;

        }


        static string[] GetFileContentType(string fileRelativePath)
        {
            try
            {
                string[] fileDetails = new string[2];

                fileDetails[0] = fileRelativePath.Substring(fileRelativePath.LastIndexOf('.') + 1, (fileRelativePath.Length - (fileRelativePath.LastIndexOf('.') + 1)));
                switch (fileDetails[0].ToLower())
                {
                    case "pdf":
                        fileDetails[1] = "application/pdf";
                        break;
                    case "avi":
                        fileDetails[1] = "video/avi";
                        break;
                    case "flv":
                        fileDetails[1] = "video/flv";
                        break;
                    case "mkv":
                        fileDetails[1] = "video/mkv";
                        break;
                    case "mp4":
                        fileDetails[1] = "video/mp4";
                        break;
                    case "jpeg":
                        fileDetails[1] = "image/jpeg";
                        break;
                    case "jpg":
                        fileDetails[1] = "image/jpg";
                        break;
                    case "png":
                        fileDetails[1] = "image/png";
                        break;
                    case "gif":
                        fileDetails[1] = "image/gif";
                        break;
                    case "doc":
                        fileDetails[1] = "application/msword";
                        break;
                    case "docx":
                        fileDetails[1] = "application/vnd.openxmlformats-officedocument.wordprocessingml.document";
                        break;
                    case "xls":
                        fileDetails[1] = "application/vnd.ms-excel";
                        break;
                    case "xlsx":
                        fileDetails[1] = "application/vnd.openxmlformats-officedocument.spreadsheetml.sheet";
                        break;
                }
                return fileDetails;
            }
            catch (Exception)
            {
                throw;
            }
        }

    }
}
