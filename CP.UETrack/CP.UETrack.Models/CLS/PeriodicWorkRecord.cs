using CP.UETrack.Model.Common;
using CP.UETrack.Models;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Web;

namespace CP.UETrack.Model.CLS
{
    public class PeriodicWorkRecord
    {
        public int PeriodicId { get; set; }
        public int CustomerId { get; set; }
        public int FacilityId { get; set; }
        public string DocumentNo { get; set; }
        public int Year { get; set; }
        public string Month { get; set; }
        public List<UserAreaDetails> UserAreaDetailsList { get; set; }
        public List<Attachment> AttachmentList { get; set; }
    }

    //Periodic Work Record Table Content 
    public class UserAreaDetails
    {
        public int PeriodicId { get; set; }
        public string UserAreaCode { get; set; }
        public int Status { get; set; }
        public string ScopeofWorkA1 { get; set; }
        public string ScopeofWorkA2 { get; set; }
        public string ScopeofWorkA3 { get; set; }
        public string ScopeofWorkA4 { get; set; }
        public string ScopeofWorkA5 { get; set; }
        public string ScopeofWorkA6 { get; set; }
        public string ScopeofWorkA7 { get; set; }
        public string ScopeofWorkA8 { get; set; }
        public string ScopeofWorkA9 { get; set; }
        public string ScopeofWorkA10 { get; set; }
        public string ScopeofWorkA11 { get; set; }
        public string ScopeofWorkA12 { get; set; }
        public string ScopeofWorkA13 { get; set; }
        public string ScopeofWorkA14 { get; set; }
        public string ScopeofWorkA15 { get; set; }
        public string ScopeofWorkA16 { get; set; }
        public string ScopeofWorkA17 { get; set; }
        public string ScopeofWorkA18 { get; set; }
        public string ScopeofWorkA19 { get; set; }
        public string ScopeofWorkA20 { get; set; }
        public string ScopeofWorkA21 { get; set; }
        public string ScopeofWorkA22 { get; set; }
        public string ScopeofWorkA23 { get; set; }
        public string ScopeofWorkA24 { get; set; }
    }
    public class PeriodidcWorkRecordAttachment
    {
        public int JiFetchId { get; set; }
        public int DetailsId { get; set; }
        public string FileType { get; set; }
        public string FileName { get; set; }
        [Required(ErrorMessage = "Please choose file to upload.")]
        public string Attachment { get; set; }
        public HttpPostedFileBase File { get; set; }
    }
    public class PeriodidcWorkRecordDropdown
    {
        public List<LovValue> YearLov { get; set; }
        public List<LovValue> MonthLov { get; set; }
        public List<LovValue> StatusLov { get; set; }
    }
}
