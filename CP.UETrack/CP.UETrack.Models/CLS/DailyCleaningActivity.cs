using CP.UETrack.Model.Common;
using CP.UETrack.Models;
using System;
using System.Collections.Generic;

namespace CP.UETrack.Model.CLS
{
    public class DailyCleaningActivity
    {
        public int DailyActivityId { get; set; }
        public int CustomerId { get; set; }
        public int FacilityId { get; set; }
        public string DocumentNo { get; set; }
        public DateTime Date { get; set; }
        public String strDate { get; set; }
        public int TotalDone { get; set; }
        public int TotalNotDone { get; set; }       
        public List<DailyCleaningActivityTable> fetchList { get; set; }
        public List<Attachment> AttachmentList { get; set; }
    }
    public class DailyCleaningActivityTable
    {
        public string UserAreaCode { get; set; }
        public int Status { get; set; }
        public int A1 { get; set; }
        public int A2 { get; set; }
        public int A3 { get; set; }
        public int A4 { get; set; }
        public int A5 { get; set; }
        public int B1 { get; set; }
        public int C1 { get; set; }
        public int D1 { get; set; }
        public int D2 { get; set; }
        public int D3 { get; set; }
        public int D4 { get; set; }
        public int E1 { get; set; }
    }
    //public class DailyCleaningActivityAttachment
    //{
    //    public int JiFetchId { get; set; }
    //    public int DetailsId { get; set; }
    //    public string FileType { get; set; }
    //    public string FileName { get; set; }
    //    [Required(ErrorMessage = "Please choose file to upload.")]
    //    public string Attachment { get; set; }
    //    public HttpPostedFileBase File { get; set; }
    //}
    public class DailyCleaningActivityDropDown
    {
        public List<LovValue> StatusLov { get; set; }
    }

}
