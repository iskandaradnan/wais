using System;

namespace CP.UETrack.Model
{
    public class AsisDocumentNumber
    {
        public int DocumentNumberId { get; set; }
        public string ScreenName { get; set; }
        public string DocumentNumber { get; set; }
        public long CodeNumber { get; set; }
        public int CreatedBy { get; set; }
        public System.DateTime CreatedDate { get; set; }
        public System.DateTime CreatedDateUTC { get; set; }

        public Nullable<int> ModifiedBy { get; set; }
        public Nullable<System.DateTime> ModifiedDate { get; set; }
        public Nullable<System.DateTime> ModifiedDateUTC { get; set; }

        public byte[] Timestamp { get; set; }
        public bool IsDeleted { get; set; }
        public bool Active { get; set; }
        public bool BuiltIn { get; set; }
    }
}
