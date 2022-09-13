using CP.UETrack.Model.FetchModels;
using CP.UETrack.Models;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Web;

namespace CP.UETrack.Model.CLS
{
    public class JIDetails : FetchPagination
    {
        public int DetailsId { get; set; }
        public int ScheduleId { get; set; }
        public int CustomerId { get; set; }
        public int FacilityId { get; set; }
        public string DocumentNo { get; set; }
        public DateTime DateandTime { get; set; }
        public string UserAreaCode { get; set; }
        public string UserAreaName { get; set; }
        public string HospitalRepresentative { get; set; }
        public string HospitalRepresentativeDesignation { get; set; }
        public string CompanyRepresentative { get; set; }
        public string CompanyRepresentativeDesignation { get; set; }
        public string Remarks { get; set; }
        public string ReferenceNo { get; set; }
        public int Satisfactory { get; set; }
        public int NoofUserLocation { get; set; }
        public int UnSatisfactory { get; set; }
        public int GrandTotalElementsInspected { get; set; }
        public int NotApplicable { get; set; }
        public int IsSubmitted { get; set; }
        public List<JIFetch> LocationDetailsList { get; set; }
        public List<JIDetailsAttachment> lstJIDetailsAttachments { get; set; }
       
    }
   
    public class JIFetch
    {
       
        public string LocationCode { get; set; }
        public string LocationName { get; set; }
        public string Floor { get; set; }
        public string Walls { get; set; }
        public string Ceiling { get; set; }
        public string WindowsandDoors { get; set; }
        public string ReceptaclesandContainers { get; set; }
        public string FurnitureFixtureandEquipment { get; set; }
        public string Remark { get; set; }
    }
    public class JIDetailsAttachment
    {
        public int JIAttachmentId { get; set; }        
        public string FileType { get; set; }
        public string FileName { get; set; }
        [Required(ErrorMessage = "Please choose file to upload.")]
        public string AttachmentName { get; set; }
        public string FilePath { get; set; }
        public bool isDeleted { get; set; }
       
    }
    public class JIDetailsListDropdown
    {
        public List<LovValue> DropDownLovs { get; set; }
        public List<LovValue> FileTypeValues { get; set; }
    }
}
