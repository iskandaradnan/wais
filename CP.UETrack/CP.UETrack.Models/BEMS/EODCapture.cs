using CP.UETrack.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CP.UETrack.Model.BEMS
{
    public class EODCapture
    {
        public string HiddenId { get; set; }
        public int CaptureId { get; set; }
        public int CustomerId { get; set; }
        public int FacilityId { get; set; }
        public int ServiceId { get; set; }
        public string ServiceName { get; set; }
        public string CaptureDocumentNo { get; set; }
        public DateTime RecordDate { get; set; }
        public DateTime RecordDateUTC { get; set; }
        public int CategorySystemId { get; set; }
        public string CategorySystemName { get; set; }
        public int CategorySystemDetId { get; set; }
        public int CaptureStatusId { get; set; }
        public string CaptureStatus { get; set; }
        public int AssetId { get; set; }
        public string AssetNo { get; set; }
        public string AssetDesc { get; set; }
        public int UserAreaId { get; set; }
        public string UserAreaCode { get; set; }
        public string UserAreaName { get; set; }
        public int UserLocationId { get; set; }
        public string UserLocationCode { get; set; }
        public string UserLocationName { get; set; }
        public int TypeCodeID { get; set; }
        public string TypeCode { get; set; }
        public int AssetClassificationId { get; set; }
        public string AssetClassification { get; set; }
        public string Timestamp { get; set; }
        public DateTime? NextCapdate { get; set; }
        public int NotificationId { get; set; }
        public int? TemplateId { get; set; }
        public List<EODCaptureGrid> EODCaptureGridData { get; set; }

        public int? NextCapdateExpiry { get; set; }
        public string Email { get; set; }
        public string FrequencyVal { get; set; }
    }

    public class EODCaptureGrid
    {
        public int CaptureDetId { get; set; }
        public int CaptureId { get; set; }
        public int ServiceId { get; set; }
        public string ServiceName { get; set; }
        public int AssetTypeCodeId { get; set; }
        public string AssetTypeCode { get; set; }
        public int ParameterMappingDetId { get; set; }
        public string ParamterValue { get; set; }
        public string Standard { get; set; }
        public int DataTypeId { get; set; }
        public string DataTypeValue { get; set; }
        public string AlphaNumDataval { get; set; }
        public string dataValueDropdown { get; set; }
        public decimal? Minimum { get; set; }
        public decimal? Maximum { get; set; }
        public string ActualValue { get; set; }
        public int Status { get; set; }
        public string Timestamp { get; set; }
        public bool IsDeleted { get; set; }
        public int? UOMId { get; set; }
        public string UOM { get; set; }
        public string Email { get; set; }
        public string Frequency { get; set; }
    }
    public class EODCaptureDropdownValues
    {
        public List<LovValue> ServiceLovs { get; set; }
        public List<LovValue> CategorySystem { get; set; }       
    }
}
