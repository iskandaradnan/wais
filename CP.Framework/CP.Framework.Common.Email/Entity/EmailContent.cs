namespace CP.Framework.Common.Email
{
    using System.Collections.Generic;
    using System.ComponentModel.DataAnnotations;

    public class EmailContent
    {
        [Required]
        [MinLength(4)]
        public List<string> ToEmailIds { get; set; }

        public List<string> CcEmailIds { get; set; }
        public List<string> BccEmailIds { get; set; }
        public List<string> ReplyEmailIds { get; set; }

        public EmailPriority MailPriority { get; set; }
        public bool sendAsHtml { get; set; }

        [Required]
        [MinLength(4)]
        public string Subject { get; set; }
        public short EmailTemplateId { get; set; }
        public List<string> TemplateVars { get; set; }
        public List<string> SubjectVars { get; set; }

        public List<Attachment> Attachments { get; set; }


    }
}
