using CP.UETrack.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CP.UETrack.Model.BEMS
{   
    public class EODParameterMapping
    {
        public int ParameterMappingId { get; set; }
        public int CustomerId { get; set; }
        public int FacilityId { get; set; }
        public int ServiceId { get; set; }
        public string ServiceName { get; set; }
        public int CategorySystemId { get; set; }
        public string CategorySystemName { get; set; }
        public int ManufacturerId { get; set; }
        public int BrandId { get; set; }
        public int MakeId { get; set; }
        public int ModelId { get; set; }
        public string Manufacturer { get; set; }
        public string Brand { get; set; }
        public string Make { get; set; }
        public string Model { get; set; }
        public string Timestamp { get; set; }
        public int AssetTypeCodeId { get; set; }
        public string AssetTypeCode { get; set; }
        public string AssetTypeDescription { get; set; }
        public string AssetTypeCodeDesc { get; set; }
        public int AssetClassificationId { get; set; }
        public string AssetClassification { get; set; }
        public int? Frequency { get; set; }
        public List<EODParameterMappingGrid> EODParameterMappingGridData { get; set; }
    }
    public class EODParameterMappingGrid
    {
        public int ParameterMappingDetId { get; set; }
        public int ParameterMappingId { get; set; }
        public string parameter { get; set; }
        public string Standard { get; set; }
        public int? UomId { get; set; }
        public string UOM { get; set; }
        public int DatatypeId { get; set; }
        public string DataType { get; set; }
        public string AlphanumDropdown { get; set; }
        public decimal? Min { get; set; }
        public decimal? max { get; set; }
        public int? FrequencyId { get; set; }
        public string Frequency { get; set; }
        public DateTime EffectiveFrom { get; set; }
        public DateTime EffectiveFromUtc { get; set; }
        public DateTime? EffectiveTo { get; set; }
        public DateTime? EffectiveToUtc { get; set; }
        public string Remarks { get; set; }
        public int ParameterMappingMetaDetId { get; set; }
        public int PageIndex { get; set; }
        public int PageSize { get; set; }
        public int TotalRecords { get; set; }
        public int TotalPages { get; set; }
        public int FirstRecord { get; set; }
        public int LastRecord { get; set; }
        public int LastPageIndex { get; set; }
        public string Timestamp { get; set; }
        public bool IsDeleted { get; set; }
        public bool IsEffectiveDateNull { get; set; }
        public bool Isreferenced { get; set; }
        public bool IsEffectiveDateFilled { get; set; }
        public int? StatusId { get; set; }
        public string Status { get; set; }

    }
    public class EODTpeCodeMapDropdownValues
    {
        public List<LovValue> ServiceLovs { get; set; }
        public List<LovValue> CategorySystem { get; set; }
        public List<LovValue> DataType { get; set; }
        public List<LovValue> UOM { get; set; }
        public List<LovValue> Frequency { get; set; }
        public List<LovValue> Status { get; set; }
    }

}
