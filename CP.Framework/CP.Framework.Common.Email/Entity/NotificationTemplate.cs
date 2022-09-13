using System;

namespace CP.Framework.Common.Email
{
    class NotificationTemplate
    {
        public short NotificationTemplateId { get; set; }
        public string Name { get; set; }
        public string Definition { get; set; }
        public byte TypeId { get; set; }
        public bool IsActive { get; set; }
        public int CreatedBy { get; set; }
        public DateTime CreatedDate { get; set; }
        public int? ModifiedBy { get; set; }
        public DateTime? ModifiedDate { get; set; }
        public byte[] Timestamp { get; set; }
        public bool IsDeleted { get; set; }
        public string Subject { get; set; }
        public int? ServiceId { get; set; }
        public bool AllowCustomToIds { get; set; }
        public bool AllowCustomCcIds { get; set; }
        public int? LeastEntityLevel { get; set; }
        public bool IsConfigurable { get; set; }
    }
}
