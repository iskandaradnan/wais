using CP.UETrack.Models;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using CP.UETrack.Model.FetchModels;
using CP.UETrack.Model.Common;

namespace CP.UETrack.Model.HWMS
{
   public class CWRecordSheet : FetchPagination
    {
        public int CWRecordSheetId { get; set; }
        public int CustomerId { get; set; }
        public int FacilityId { get; set; }
        public DateTime Date { get; set; }
        public int TotalUserArea { get; set; }
        public int TotalBagCollected { get; set; }
        public int TotalSanitized { get; set; }
        public List<CWRecordSheetCollectionDetails> CWRecordSheetCollectionDetailsList { get; set; }

        public List<Attachment> AttachmentList { get; set; }

    }
    public class CWRecordSheetCollectionDetails
    {
       
        public int CollectionDetailsId { get; set; }
        public string UserAreaCode { get; set; }
        public string FrequencyType { get; set; }
        public string CollectionFrequency { get; set; }
        public string CollectionTime { get; set; }
        public string CollectionStatus { get; set; }
        public string QC { get; set; }
        public int NoofBags { get; set; }
        public int NoofReceptaclesOnsite { get; set; }
        public int NoofReceptacleSanitize { get; set; }
        public string Sanitize { get; set; }
        public bool isDeleted { get; set; }
        
    }
    public class CWRecordSheetCollectionDetailsDropdown
    {
        public List<LovValue> CollectionStatusLovs { get; set; }
        public List<LovValue> qualitycausecodeLovs { get; set; }
        public List<LovValue> SanitizeLovs { get; set; }

    }
}
