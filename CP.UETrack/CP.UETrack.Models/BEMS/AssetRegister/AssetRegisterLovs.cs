using CP.UETrack.Models;
using System.Collections.Generic;

namespace CP.UETrack.Model
{
    public class AssetRegisterLovs
    {
        public List<LovValue> AssetClassifications { get; set; }
        public List<LovValue> AssetWorkGroups { get; set; }
        public List<LovValue> Services { get; set; }
        public List<LovValue> Facilities { get; set; }
        public List<LovValue> StatusValues { get; set; }
        public List<LovValue> RealTimeStatusValues { get; set; }
        public List<LovValue> AppliedPartTypeValues { get; set; }
        public List<LovValue> EquipmentClassValues { get; set; }
        public List<LovValue> PowerSpecificationValues { get; set; }
        public List<LovValue> PurchaseCategoryValues { get; set; }
        public List<LovValue> AssetTransferModeValues { get; set; }
        public List<LovValue> AssetTransferTypeValues { get; set; }
        public List<LovValue> YesNoValues { get; set; }
        public List<LovValue> TypeOfAssetValue { get; set; }
        public List<LovValue> AssetSpecifications { get; set; }
        public List<LovValue> RiskRatings { get; set; }
        public List<LovValue> ContractTypes { get; set; }
        public bool IsAdditionalFieldsExist { get; set; }
        public List<LovValue> TypeOfService { get; set; }
        public List<LovValue> BatchNo { get; set; }
        public List<LovValue> Work_Group { get; set; }
        public List<LovValue> WorkGroup { get; set; }
        public List<LovValue> Asset_Category { get; set; }
    }
}
