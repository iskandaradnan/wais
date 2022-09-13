using System;
using System.Collections.Generic;
using System.Linq;
using CP.UETrack.Models;
using System.Text;
using System.Threading.Tasks;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;
using System.Web;
using CP.UETrack.Model.FetchModels;
using CP.UETrack.Model.Common;

namespace CP.UETrack.Model.HWMS
{
    public class ConsignmentNoteCWCN : FetchPagination
    {
        public int ConsignmentId { get; set; }
        public int CustomerId { get; set; }
        public int FacilityId { get; set; }
        public string ConsignmentNoteNo { get; set; }
        public DateTime DateTime { get; set; }
        public string OnSchedule { get; set; }
        public string Qc { get; set; }
        public string CwRepresentative { get; set; }
        public string CwRepresentativeDesignation { get; set; }
        public string HospitalRepresentative { get; set; }
        public string HospitalRepresentativeDesignation { get; set; }
        public string TreatmentPlantName { get; set; }
        public string TreatmentPlantId { get; set; }
        public string Ownership { get; set; }
        public string VehicleNo { get; set; }
        public string DriverCode { get; set; }
        public string DriverName { get; set; }
        public string TotalNoOfBins { get; set; }
        public string TotalEst { get; set; }
        public string Remarks { get; set; }
        public List<ConsignmentNoteCWCN_BinDetails> ConsignmentNoteList { get; set; }        
        public List<Attachment> AttachmentList { get; set; }

    }
    public class ConsignmentNoteCWCN_BinDetails
    {    
        public int DWRNoId { get; set; } 
        public int DWRDocId { get; set; }
        public string BinNo { get; set; }
        public float Weight { get; set; }
        public string Remarks_Bin { get; set; }
        public bool isDeleted { get; set; }
    }

    public class ConsignmentNoteCWCNAttachments
    {
        public int AttachmentId { get; set; }
        public int ConsignmentId { get; set; }
        public string FileType { get; set; }
        public string FileName { get; set; }
        [Required(ErrorMessage = "Please choose file to upload.")]
        public string AttachmentName { get; set; }
        public string FilePath { get; set; }
        public bool isDeleted { get; set; }
        public HttpPostedFileBase File { get; set; }
    }

    public class ConsignmentCWCNDropDown
    {
        public List<LovValue> QcLovs { get; set; }
        public List<LovValue> OnScheduleLovs { get; set; }
        public List<LovValue> DWRSNOLovs { get; set; }
        public List<LovValue> FileTypeLovs { get; set; }

    }
}
