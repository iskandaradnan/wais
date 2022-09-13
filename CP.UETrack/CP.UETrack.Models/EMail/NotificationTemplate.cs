using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CP.UETrack.Model.EMail
{
    public partial class NotificationTemplate
    {
       public int NotificationTemplateId { get; set; }
        public string Name { get; set; }
        public string Definition { get; set; }
        public byte TypeId { get; set; }
        public bool IsActive { get; set; }
        public int CreatedBy { get; set; }
        public System.DateTime CreatedDate { get; set; }
        public Nullable<int> ModifiedBy { get; set; }
        public Nullable<System.DateTime> ModifiedDate { get; set; }
        public byte[] Timestamp { get; set; }
        public bool IsDeleted { get; set; }
        public string Subject { get; set; }
        public Nullable<int> ServiceId { get; set; }
        public bool AllowCustomToIds { get; set; }
        public bool AllowCustomCcIds { get; set; }
        public Nullable<int> LeastEntityLevel { get; set; }
        public bool IsConfigurable { get; set; }
    }
}
