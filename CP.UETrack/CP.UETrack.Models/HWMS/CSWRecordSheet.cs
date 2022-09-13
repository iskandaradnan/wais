using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using CP.UETrack.Model.FetchModels;
using CP.UETrack.Models;
using CP.UETrack.Model.Common;

namespace CP.UETrack.Model.HWMS
{
    public class CSWRecordSheet: FetchPagination
    {

        public int CSWRecordSheetId { get; set; }
        public int CustomerId { get; set; }
        public int FacilityId { get; set; }
        public string DocumentNo { get; set; }
        public string RRWNo { get; set; }
        public string WasteType { get; set; }
        public string WasteCode { get; set; }
        public string UserAreaCode { get; set; }
        public string UserAreaName { get; set; }
        public string Month { get; set; }
        public int Year { get; set; }
        public string CollectionType { get; set; }
        public int Status { get; set; }
        public float TotalWeight { get; set; }
        public List<CSWRecordSheet> WasteTypeList { get; set; }
        public List<CollectionDetails> CollectionDetailsList { get; set; }

        public List<Attachment> AttachmentList { get; set; }

    }

    public class CollectionDetails
    {
        public int CSWRecordSheetId { get; set; }
        public int CSWId { get; set; }
        public DateTime Date { get; set; }
        public int NoofBin { get; set; }
        public float Weight { get; set; }
        public string CollectionFrequency { get; set; }
        public string CollectionTime { get; set; }
        public string CollectionStatus { get; set; }
        public string QC { get; set; }
        public bool isDeleted { get; set; }

    }
    public class CSWRecordSheetDropdown
    {
        public List<LovValue> WasteTypeLovs { get; set; }
        public List<LovValue> CSWRMonthLovs { get; set; }
        public List<LovValue> CSWRYearLovs { get; set; }
        public List<LovValue> CSWRCollectionTypeLovs { get; set; }
        public List<LovValue> CSWRStatusLovs { get; set; }
        public List<LovValue> CSWRCollectionStatusLovs { get; set; }
        public List<LovValue> CSWRCollectionFrequencyLovs { get; set; }
        public List<LovValue> QcLovs { get; set; }

     

    }
}
