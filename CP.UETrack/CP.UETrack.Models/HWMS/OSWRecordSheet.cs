using System;
using System.Collections.Generic;
using CP.UETrack.Model.FetchModels;
using CP.UETrack.Models;
using CP.UETrack.Model.Common;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;


namespace CP.UETrack.Model.HWMS
{
    public class OSWRecordSheet : FetchPagination
    {
    
        public int OSWRId { get; set; }
        public int DeptAreaId { get; set; }
        public int CustomerId { get; set; }
        public int FacilityId { get; set; }
        public string OSWRSNo { get; set; }
        public int TotalPackage { get; set; }
        public string WasteType { get; set; }
        public string ConsignmentNo { get; set; }
        public string UserAreaCode { get; set; }
        public string UserAreaName { get; set; }
        public string Month { get; set; }
        public int Year { get; set; }
        public string CollectionFrequency { get; set; }
        public string CollectionType { get; set; }
        public int Status { get; set; }
        public List<OSWRecordSheetSave> OSWRecordSheetList { get; set; }

        public List<Attachment> AttachmentList { get; set; }
    }
    public class OSWRecordSheetSave
    {
        public int OSWRecordId { get; set; }
        public int OSWRId { get; set; }      
        public DateTime Date { get; set; }
        public string CollectionTime { get; set; }
        public string CollectionStatus { get; set; }
        public string QC { get; set; }
        public bool isDeleted { get; set; }
    }
    public class OSWRecordSheetDropDown
    {
        public List<LovValue> WasteTypeLovs { get; set; }
        public List<LovValue> OSWRMonthLovs { get; set; }
        public List<LovValue> OSWRYearLovs { get; set; }
        public List<LovValue> OSWRCollectionTypeLovs { get; set; }
        public List<LovValue> OSWRStatusLovs { get; set; }
        public List<LovValue> OSWRCollectionStatusLovs { get; set; }
        public List<LovValue> QcLovs { get; set; }
    }
}
