using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CP.UETrack.Model.Common
{
    public class Attachment
    {
        public string ScreenName { get; set; }
        public int PrimaryId { get; set; }
        public int AttachmentId { get; set; }
        public string FileType { get; set; }
        public string FileName { get; set; }        
        public string AttachmentName { get; set; }
        public string FilePath { get; set; }
        public bool isDeleted { get; set; }

    }
}
