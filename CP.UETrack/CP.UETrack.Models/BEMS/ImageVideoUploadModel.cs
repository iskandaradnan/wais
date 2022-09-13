using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CP.UETrack.Model.BEMS
{
    public class ImageVideoUploadModel
    {
        public string DocumentGuId { get; set; }
        public int AssetId { get; set; }
        public int SparePartsId { get; set; }
        public int DocumentId { get; set; }
        public string GuId { get; set; }
        public int CustomerId { get; set; }
        public int FacilityId { get; set; }
        public string DocumentNo { get; set; }
        public string DocumentTitle { get; set; }
        public string DocumentDescription { get; set; }
        public int DocumentCategory { get; set; }
        public string DocumentCategoryOthers { get; set; }
        public string DocumentExtension { get; set; }        
        public string FileName { get; set; }
        public int FileType { get; set; }
        public string FilePath { get; set; }
        public DateTime? UploadedDateUTC { get; set; }
        public int ScreenId { get; set; }
        public string Remarks { get; set; }
        public int UploadedBy { get; set; }
        public DateTime? UploadedDate { get; set; }
        public int ModifiedBy { get; set; }
        public DateTime? ModifiedDate { get; set; }
        public DateTime? ModifiedDateUTC { get; set; }
        public string Timestamp { get; set; }
        public string contentAsBase64String { get; set; }
        public bool Active { get; set; }
        public List<FileUploadDetModel> ImageVideoUploadListData { get; set; }
    }
    
}
