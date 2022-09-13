using System;
using System.Collections.Generic;

namespace CP.Framework.Common.EmailTest
{
    class Program
    {
        static void Main(string[] args)
        {
            //Console.WriteLine(string.Format("Sending test email..."));

            //var emailContent = new Email.EmailContent
            //{
            //    ToEmailIds = new List<string> { "test1@asis.com" },
            //    Subject = "Test Email from component",
            //    TemplateId = 2,
            //    TemplateVars = new List<string> { "Mohammed", "Var2", "Var3", "Var4" },
            //    MailPriority = Email.EmailPriority.High,
            //    sendAsHtml = true
            //};

            //var attachment = new Email.Attachment
            //{
            //    AttachmentName = "test.doc",
            //    AttachmentType = "application/ms-doc",
            //    Content = new byte[] { 0x20, 0x10 }
            //};

            //emailContent.Attachments = new List<Email.Attachment> { attachment };

            //var emailSender = new Email.QueueManager();
            //var queueId = emailSender.QueueEmail(emailContent, "shakeel");

            //emailSender = null;

            //Console.WriteLine(string.Format("QueueId: {0}", queueId));

            Console.WriteLine("starting...");

            var emailSender = new Email.QueueManager();
            emailSender.ProcessQueue();
            emailSender = null;

            Console.WriteLine("finished!");
            Console.Read();


        }
    }
}
