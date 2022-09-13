using System;

namespace CP.Framework.Common.Email
{
    class EmailExclusionList
    {
        public int EmailExclusionId { get; set; }
        public int? FacilityId { get; set; }
        public int CustomerId { get; set; }
        public int EmailTemplateId { get; set; }
        public string EmailAddress { get; set; }
        public int Type { get; set; }
        public int? Status { get; set; }
        public string Remarks { get; set; }
        public int CreatedBy { get; set; }
        public DateTime CreatedDate { get; set; }
        public int? ModifiedBy { get; set; }
        public DateTime? ModifiedDate { get; set; }
        public byte[] Timestamp { get; set; }
        public bool IsDeleted { get; set; }
    }
}
