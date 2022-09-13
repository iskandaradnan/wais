using CP.UETrack.Models;
using System;
using System.Collections.Generic;

namespace CP.UETrack.Model.BEMS
{
    public class PPMAssetTypeCodeSearch
    {
        public int AssetTypeCodeId { get; set; }
        public string AssetTypeCode { get; set; }
        public string AssetTypeCodeDesc { get; set; }
        public int PageIndex { get; set; }
        public int TotalRecords { get; set; }
        public int FirstRecord { get; set; }
        public int LastRecord { get; set; }
        public int LastPageIndex { get; set; }
    }

    public class EngAssetTypeCodeStandardTasksFetch
    {
        public int? StandardTaskDetId { get; set; }
        public string TaskCode { get; set; }
        public string TaskDescription { get; set; }
        public string PPMChecklistNo { get; set; }
        public int TypeOfPlanner { get; set; }
        public int hdnAssetTypeCodeId { get; set; }
        public int? ManufacturerId { get; set; }
        public string Manufacturer { get; set; }
        public int? ModelId { get; set; }
        public String PPMFrequencyValue { get; set; }
        public int? PPMFrequency { get; set; }
        public string Model { get; set; }
        public decimal PpmHours { get; set; }
        public int PageIndex { get; set; }
        public int TotalRecords { get; set; }
        public int FirstRecord { get; set; }
        public int LastRecord { get; set; }
        public int LastPageIndex { get; set; }
        public string LovPPMFrequency { get; set; }
        public string ScreenName { get; set; }
    };
    public class PPMCheckListModel
    {
        public int PPMCheckListId { get; set; }
        public int ServiceId { get; set; }
        public int? AssetTypeCodeId { get; set; }
        public string AssetTypeCode { get; set; }
        public string AssetTypeDescription { get; set; }
        public string TaskCode { get; set; }
        public string TaskCodeDesc { get; set; }
        public string PPMChecklistNo { get; set; }
        public int? ManufacturerId { get; set; }
        public string Manufacturer { get; set; }
        public int? ModelId { get; set; }
        public string Model { get; set; }
        public int? PPMFrequency { get; set; }
        public decimal PpmHours { get; set; }
        public string SpecialPrecautions { get; set; }
        public string Remarks { get; set; }
        public string Timestamp { get; set; }
        public bool Active { get; set; }
        public string HiddenId { get; set; }
        public string PPMFrequencyValue { get; set; }
        public List<PPMCheckListQuantasksMstDetModel> PPMCheckListQuantasksMstDets { get; set; }
        public List<PPmChecklistCategoryDet> PPmChecklistCategoryDets { get; set; }
        public List<CategoryHistory> CategoryHistoryList { get; set; }
        public List<QunantityHistory> QunantityHistoryList { get; set; }

        public List<PPMCheckListQuantasksMstDetModel> QunantityPopupHistoryList { get; set; }
        public List<PPmChecklistCategoryDet> CategoryPopupHistoryList { get; set; }
    }


    public class CategoryHistory
    {
        public int categoryHistoryId { get; set; }
        public decimal? Version { get; set; }
        public DateTime EffectiveFromDate { get; set; }
        public string ModifiedBy { get; set; }
    }

    public class QunantityHistory
    {
        public int categoryHistoryId { get; set; }
        public decimal? Version { get; set; }
        public DateTime EffectiveFromDate { get; set; }
        public string ModifiedBy { get; set; }
    }


    public class PPMCheckListLovs
    {
        public List<LovValue> UOMList { get; set; }
        public List<LovValue> PpmCategoryList { get; set; }
        public List<LovValue> FrequencyList { get; set; }
        public List<LovValue> Services { get; set; }
    }

    public class PPmChecklistCategoryDet
    {
        public int PPmCategoryHisrtoryDetId { get; set; }
        public int PPmCategoryDetId { get; set; }
        public int PpmCategoryId { get; set; }
        public int SNo { get; set; }
        public string Description { get; set; }
        public bool Active { get; set; }
        public string PPmCategory { get; set; }
    }
    public class PPMCheckListQuantasksMstDetModel
    {
        public int PPMCheckListHisroryQNId { get; set; }
        public int PPMCheckListQNId { get; set; }
        public int PPMCheckListId { get; set; }
        public string QuantitativeTasks { get; set; }
        public int? UOM { get; set; }
        public string UOMValue { get; set; }
        public string SetValues { get; set; }
        public string LimitTolerance { get; set; }
        public string Timestamp { get; set; }
        public bool Active { get; set; }
    }
}
