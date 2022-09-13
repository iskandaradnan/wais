using CP.UETrack.Model.EMail;
using System;
using System.Collections.Generic;

namespace CP.UETrack.Models.EMail
{
    public class EmailQueue
    {
        public int EmailQueueId { get; set; }
        public string ToIds { get; set; }
        public string CcIds { get; set; }
        public string BccIds { get; set; }
        public string ReplyIds { get; set; }
        public string Subject { get; set; }
        public short EmailTemplateId { get; set; }
        public string TemplateVars { get; set; }
        public string ContentBody { get; set; }
        public bool SendAsHtml { get; set; }
        public byte Priority { get; set; }
        public byte Status { get; set; }
        public Nullable<byte> TypeId { get; set; }
        public Nullable<byte> GroupId { get; set; }
        public System.DateTime QueuedOn { get; set; }
        public string QueuedBy { get; set; }
        public Nullable<System.DateTime> SentOn { get; set; }
        public Nullable<System.DateTime> FailedOn { get; set; }
        public Nullable<byte> FailCount { get; set; }
        public int CreatedBy { get; set; }
        public System.DateTime CreatedDate { get; set; }
        public Nullable<int> ModifiedBy { get; set; }
        public Nullable<System.DateTime> ModifiedDate { get; set; }
        public byte[] TimeStamp { get; set; }
        public bool IsDeleted { get; set; }
        public string SubjectVars { get; set; }
        public Nullable<int> CompanyId { get; set; }
        public Nullable<int> HospitalId { get; set; }
        public List<EmailAttachment> EmailAttachments { get; set; }
    }
}
