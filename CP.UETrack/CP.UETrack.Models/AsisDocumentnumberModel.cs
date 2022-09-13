using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CP.UETrack.Model
{
   public class AsisDocumentnumberModel
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
