using System;

namespace CP.Framework.Common.Email
{
    public partial class EmailQueue
    {
        public int EmailQueueId { get; set; }
        public string ToIds { get; set; }
        public string CcIds { get; set; }
        public string BccIds { get; set; }
        public string ReplyIds { get; set; }
        public string Subject { get; set; }
        public int EmailTemplateId { get; set; }
        public string TemplateVars { get; set; }
        public string ContentBody { get; set; }
        public bool SendAsHtml { get; set; }
        public int Priority { get; set; }
        public int Status { get; set; }
        public byte? TypeId { get; set; }
        public byte? GroupId { get; set; }
        public DateTime QueuedOn { get; set; }
        public string QueuedBy { get; set; }
        public DateTime? SentOn { get; set; }
        public DateTime? FailedOn { get; set; }
        public int FailCount { get; set; }
        public int CreatedBy { get; set; }
        public DateTime CreatedDate { get; set; }
        public int? ModifiedBy { get; set; }
        public DateTime? ModifiedDate { get; set; }
        public byte[] Timestamp { get; set; }
        public bool IsDeleted { get; set; }
        public string SubjectVars { get; set; }
        public int? CustomerId { get; set; }
        public int? FacilityId { get; set; }
        public int DataSource { get; set; }
        public string SourceIp { get; set; }

    }
}
