
using System;
using System.Collections.Generic;

namespace CP.UETrack.Model
{
    public class ParentAssetNoSearch
    {
        public int  AssetId { get; set; }
        public int CurrentAssetId { get; set; }
        public int AssetClarification { get; set; }
        public string AssetClarificationCode { get; set; }
        public string AssetNo { get; set; }
        public string Asset_Name { get; set; }
        public string Flag { get; set; }
        public string TypeCode { get; set; }
        public string ContractTypeValue { get; set; }
        public string TypeCodeDescription { get; set; }
        public string AssetDescription { get; set; }
        public string PartDescription { get; set; }
        public int PageIndex { get; set; }
        public int TotalRecords { get; set; }
        public int FirstRecord { get; set; }
        public int LastRecord { get; set; }
        public int LastPageIndex { get; set; }
        public int TypeOfPlanner { get; set; }
        public string Model { get; set; }
        public string Level { get; set; }
        public string Block { get; set; }
        public string Manufacturer { get; set; }
        public string SerialNumber { get; set; }
        public int ManufacturerId { get; set; }
        public int ModelId { get; set; }
        public int UserAreaId { get; set; }
        public string UserAreaCode { get; set; }
        public string UserAreaName { get; set; }
        public int UserLocationId { get; set; }
        public string UserLocationCode { get; set; }
        public string UserLocationName { get; set; }
        public int TypeCodeID { get; set; }
        public DateTime? WarrentyEndDate { get; set; }
        public string SupplierName { get; set; }
        public DateTime? ContractEndDate { get; set; }
        public string ContractorName { get; set; }
        public String ContactNumber { get; set; }
        public int WorkOrderType { get; set; }
        public string PPMFrequencyValue { get; set; }
        public int? PPMFrequency { get; set; }
        public int CategoryId { get; set; }
        public int WarrentyType { get; set; }
        public int IsFromAssetRegister { get; set; }
        public string TaskCode { get; set; }
        public int? TaskCodeId { get; set; }
        public int Year { get; set; }

       
        public List<PPPMFrequency> PPFrequency { get; set; }
        public List<FrequencyPPM> FrequencyPPM { get; set; }

        
    }

    public class PPPMFrequency
    {
        public int AQuantityText { get; set; }

        public int Frequency { get; set; }

        public string FieldValue { get; set; }
        public string TTaskCode { get; set; }
    }

    public class FrequencyPPM
    {
        public int AQuantityText { get; set; }

        public int Frequency { get; set; }

        public string FieldValue { get; set; }
        public string TTaskCode { get; set; }
    }


}