using CP.UETrack.Model.Common;
using CP.UETrack.Models;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Web;

namespace CP.UETrack.Model.CLS
{

    public class ToiletInspection
    {
        public int ToiletInspectionId { get; set; }
        public int CustomerId { get; set; }
        public int FacilityId { get; set; }
        public string DocumentNo { get; set; }
        public DateTime Date { get; set; }
        public string strDate { get; set; }
        public int TotalDone { get; set; }
        public int TotalNotDone { get; set; }
        public List<LocationCodeDetails> locationCodeDetailsList { get; set; }
        public List<Attachment> AttachmentList { get; set; }
    }

    public class LocationCodeDetails
    {
        public int ToiletInspectionId { get; set; }
        public string LocationCode { get; set; }
        public int Status { get; set; }       
        public int Mirror { get; set; }
        public int Floor { get; set; }
        public int Wall { get; set; }
        public int Urinal { get; set; }
        public int Bowl { get; set; }
        public int Basin { get; set; }
        public int ToiletRoll { get; set; }
        public int SoapDispenser { get; set; }
        public int AutoAirFreshner { get; set; }
        public int Waste { get; set; }
    }
    public class ToiletInspectionAttachment
    {
        public int JiFetchId { get; set; }
        public int DetailsId { get; set; }
        public string FileType { get; set; }
        public string FileName { get; set; }
        [Required(ErrorMessage = "Please choose file to upload.")]
        public string Attachment { get; set; }
        public HttpPostedFileBase File { get; set; }
    }
    public class ToiletInspectionDropDown
    {
        public List<LovValue> StatusLov { get; set; }
    }

}
