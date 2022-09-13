using CP.UETrack.Models;
using System;
using System.Collections.Generic;

namespace CP.UETrack.Model.BEMS
{
    public class EngAssetTypeCode
    {
        public int AssetTypeCodeId { get; set; }
        public int? ServiceId { get; set; }
        public int AssetClassificationId { get; set; }
        public string AssetClassificationCode { get; set; }
        public string AssetClassificationDescription { get; set; }
        public string AssetTypeCode { get; set; }
        public string AssetTypeDescription { get; set; }
        public int TypeofContractLovId { get; set; }
        public int EquipmentFunctionCatagoryLovId { get; set; }
        public int? LifeExpectancyId { get; set; }
        public int Criticality { get; set; }
        public int ExpectedLifeSpan { get; set; }
        public bool QAPAssetTypeB1 { get; set; }
        public bool QAPServiceAvailabilityB2 { get; set; }
        public decimal? QAPUptimeTargetPerc { get; set; }
        public DateTime? EffectiveFrom { get; set; }
        public DateTime? EffectiveFromUTC { get; set; }
        public DateTime? EffectiveTo { get; set; }
        public DateTime? EffectiveToUTC { get; set; }
        public decimal TRPILessThan5YrsPerc { get; set; }
        public decimal TRPI5to10YrsPerc { get; set; }
        public decimal TRPIGreaterThan10YrsPerc { get; set; }
        public string Timestamp { get; set; }
        public bool Active { get; set; }
       // public List<EngAssetTypeCodeAddSpecification> EngAssetTypeCodeAddSpecifications { get; set; }
        public List<EngAssetTypeCodeVariationRate> EngAssetTypeCodeVariationRates { get; set; }
        public string MaintenanceFlag { get; set; }
        public List<int> MaintainanceFlagList { get; set; }

        public int AssetTypeCodeId_mappingTo_SeviceDB { get; set; }

    }

    public class EngAssetTypeCodeLovs
    {
        public List<LovValue> ServiceList { get; set; }
        public List<LovValue> TypeOfContractValueLovs { get; set; }
        public List<LovValue> EquipmentFunctionCatagoryLovs { get; set; }
        public List<LovValue> StatusLovs { get; set; }
        public List<LovValue> LifeExpectancyValueLovs { get; set; }
        public List<LovValue> EngAssetTypeCodeFlagLovs { get; set; }
        public List<EngAssetTypeCodeVariationRate> EngAssetTypeCodeVariationRates { get; set; }
        public List<LovValue> CriticalityList { get; set; }
        public List<LovValue> Services { get; set; }
    }

    public class EngAssetTypeCodeFlag
    {
        public int AssetTypeCodeFlagId { get; set; }
        public int AssetTypeCodeId { get; set; }
        public int MaintenanceFlag { get; set; }
        public bool Active { get; set; }
    }
    public class EngAssetTypeCodeAddSpecification
    {
        public int AssetTypeCodeAddSpecId { get; set; }
        public int AssetTypeCodeId { get; set; }
        public int SpecificationType { get; set; }
        public int SpecificationUnit { get; set; }
        public bool Active { get; set; }
        public int TypeCodeParameterId { get; set; }
        public int AssetTypeCodeId_mappingTo_SeviceDB { get; set; }
    }
    public class EngAssetTypeCodeVariationRate
    {
        public int AssetTypeCodeVariationId { get; set; }
        public int AssetTypeCodeId { get; set; }
        public int TypeCodeParameterId { get; set; }
        public string SpecificationType { get; set; }
        public decimal VariationRate { get; set; }
        public DateTime? EffectiveFromDate { get; set; }
        public DateTime? EffectiveFromDateUTC { get; set; }
        public bool Active { get; set; }
        public string TypeCodeParameter { get; set; }
        public EngAssetTypeCodeVariationRate()
        {
            EffectiveFromDate = null;
            EffectiveFromDateUTC = null;
        }
    }
    public class EngAssetTypeCodeParameter
    {
        public int TypeCodeParameterId { get; set; }
        public string TypeCodeParameter { get; set; }
        public string Remarks { get; set; }
        public bool Active { get; set; }
    }
}
