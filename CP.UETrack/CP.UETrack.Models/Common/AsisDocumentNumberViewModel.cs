using System;

namespace CP.UETrack.Model
{
    public class AsisDocumentNumberViewModel
    {
        public int DocumentNumberId { get; set; }
        public string ScreenName { get; set; }
        public string DocumentNumber { get; set; }
        public int CodeNumber { get; set; }
        public int CreatedBy { get; set; }
        public System.DateTime CreatedDate { get; set; }
        public Nullable<int> ModifiedBy { get; set; }
        public Nullable<System.DateTime> ModifiedDate { get; set; }
        public byte[] TimeStamp { get; set; }
        public bool IsDeleted { get; set; }
    }
}
