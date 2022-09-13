using CP.UETrack.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.ComponentModel.DataAnnotations;
using System.Web;
using CP.UETrack.Model.FetchModels;
using CP.UETrack.Model.Common;


namespace CP.UETrack.Model.HWMS
{
    public class ConsignmentNoteOSWCN : FetchPagination
    {
       public int  ConsignmentOSWCNId { get; set; }
        public int CustomerId { get; set; }
        public int FacilityId { get; set; }
        public string ConsignmentNoteNo { get; set; }
        public DateTime DateTime { get; set; }
        public int TotalEst { get; set; }
        public int TotalNoofPackaging { get; set; }
        public string OSWRepresentative { get; set; }
        public string OSWRepresentativeDesignation { get; set; }
        public string HospitalRepresentative { get; set; }
        public string HospitalRepresentativeDesignation { get; set; }
        public string TreatmentPlant { get; set; }
        public string Ownership { get; set; }
        public string VehicleNo { get; set; }
        public string DriverName { get; set; }
        public string Wastetype { get; set; }
        public string WasteCode { get; set; }
        public int ChargeRM { get; set; }
        public int ReturnValueRM { get; set; }
        public string TransportationCategory { get; set; }        
        public string TotalWeight { get; set; }
        public string Remarks { get; set; }
        public DateTime StartDate { get; set; }
        public DateTime EndDate { get; set; }
        public int PageIndex { get; set; }
        public List<ConsignmentOSWCN_SWRSNo> ConsignmentSWRSNoDetailsList { get; set; }            
        public List<ConsignmentNoteOSWCN> WasteDropDownList { get; set; }
        public List<Attachment> AttachmentList { get; set; }
    }

    public class ConsignmentOSWCN_SWRSNo
    {
        public int SWRSNoId { get; set; }
        public string UserAreaCode { get; set; }
        public string UserAreaName { get; set; }
        public string OSWRSNo { get; set; }
        public bool isDeleted { get; set; }
    }

    public class ConsignmentNoteOSWCNAttachment
    {
        public int AttachmentId { get; set; }
        public int ConsignmentOSWCNId { get; set; }
        public string FileType { get; set; }
        public string FileName { get; set; }
        [Required(ErrorMessage = "Please choose file to upload.")]
        public string AttachmentName { get; set; }
        public string FilePath { get; set; }
        public bool isDeleted { get; set; }
        public HttpPostedFileBase File { get; set; }
    }

    public class ConsignmentOSWCNDropDown
    {
        public List<LovValue> TransportationLov { get; set; }
        public List<LovValue> WasteTypeLov { get; set; }
        public List<LovValue> FileTypeLovs { get; set; }

    }
}
