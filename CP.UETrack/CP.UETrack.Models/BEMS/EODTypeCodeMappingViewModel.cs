using System;
using CP.UETrack.Models;
using System.Collections.Generic;

namespace CP.UETrack.Model
{
    public class EODTypeCodeMappingViewModel
    {
        public int CategorySystemId { get; set; }
        public int ServiceId { get; set; }
        public string ServiceName { get; set; }
        public string CategorySystemName { get; set; }
        public string Remarks { get; set; }
        public int CreatedBy { get; set; }
        public DateTime? CreatedDate { get; set; }
        public DateTime? CreatedDateUTC { get; set; }
        public int ModifiedBy { get; set; }
        public DateTime? ModifiedDate { get; set; }
        public DateTime? ModifiedDateUTC { get; set; }
        public string Timestamp { get; set; }
        public int Active { get; set; }
        public bool BuiltIn { get; set; }
        public int EntryModeChk { get; set; }
        //public List<LovValue> ServiceData { get; set; }

        public List<EODTypeCodeMappingGrid> EODTypeCodeMappingGridData { get; set; }
    }

    public class EODTypeCodeMappingGrid
    {
        public int CategorySystemDetId { get; set; }
        public int CategorySystemId { get; set; }
        public string CategorySystemName { get; set; }
        public int ServiceId { get; set; }
        public string ServiceName { get; set; }
        public int AssetTypeCodeId { get; set; }
        public string AssetTypeCode { get; set; }
        public string AssetTypeDescription { get; set; }
        public int PageIndex { get; set; }
        public int PageSize { get; set; }
        public int TotalRecords { get; set; }
        public int TotalPages { get; set; }
        public int FirstRecord { get; set; }
        public int LastRecord { get; set; }
        public int LastPageIndex { get; set; }
        public string Timestamp { get; set; }
        public bool IsDeleted { get; set; }
        public bool Isreferenced { get; set; }

    }

    public class EODDropdownValues
    {
        public List<LovValue> ServiceLovs { get; set; }
        public List<LovValue> CategorySystem { get; set; }
    }
}
