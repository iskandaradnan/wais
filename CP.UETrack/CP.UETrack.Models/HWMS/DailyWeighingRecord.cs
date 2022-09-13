using CP.UETrack.Model.FetchModels;
using CP.UETrack.Models;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;
using CP.UETrack.Model.Common;

namespace CP.UETrack.Model.HWMS
{
    public class DailyWeighingRecord : FetchPagination
    {
        public int DWRId { get; set; }
        public int CustomerId { get; set; }
        public int FacilityId { get; set; }
        public string DWRNo { get; set; }
        public float TotalWeight { get; set; }
        public DateTime Date { get; set; }
        public int TotalBags { get; set; }
        public int TotalNoofBins { get; set; }
        public string HospitalRepresentative { get; set; }
        public string ConsignmentNo { get; set; }
        public string Status { get; set; }
        public List<DailyWeighingRecordTable> dailyWeighingRecordsList { get; set; }
        public List<Attachment> AttachmentList { get; set; }
    }
    public class DailyWeighingRecordTable
    {
        public int BinDetailsId { get; set; }
        public string BinNo { get; set; }
        public float Weight { get; set; }
        public bool isDeleted { get; set; }
    }
    public class DailyWeighingRecordDropDown
    {
        public List<LovValue> StatusLovs { get; set; }      
    }

}
