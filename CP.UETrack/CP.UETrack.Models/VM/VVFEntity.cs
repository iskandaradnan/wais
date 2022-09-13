using CP.UETrack.Model.BEMS;
using CP.UETrack.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CP.UETrack.Model.VM
{
   public class VVFEntity
    {
        public string ErrorMsg { get; set; }
        public int? Month { get; set; }
        public int? Year { get; set; }
        public int? FacilityId { get; set; }
        public int? ServiceId { get; set; }
        public int? WorkFlowStatusId { get; set; }
        public int? VariationStatusId { get; set; }
        public string VariationStatusValue { get; set; }

        public int DocumentId { get; set; }
        public string GuId { get; set; }
        public List<FileUploadDetModel> FileUploadList { get; set; }
        public List<VatiationDetailList> VatiationDetailList { get; set; }
    }
    public class LoadEntity
    {
        public List<LovValue> FMTimeMonth { get; set; }
        public List<LovValue> Yearlist { get; set; }
        public List<LovValue> VariationStatusValue { get; set; }
        public List<LovValue> WorkFlowStatusList { get; set; }
        public List<LovValue> ActionList { get; set; }
        public List<LovValue> ServiceData { get; set; }
        public int CurrentYear { get; set; }
        public int PreviousMonth { get; set; }
        public int VariationStatuslist { get; set; }
        public int WorkFlowStatus { get; set; }
    }
    public class VVFDetails
    {
        public List<VatiationDetailList> VatiationDetailList { get; set; }

        public int? PageSize { get; set; }
        public string Flag { get; set; }
        public int? Pageindex { get; set; }
        public int? ServiceId { get; set; }
        public int? Month { get; set; }
        public int? Year { get; set; }
        public int? FacilityId { get; set; }
        public int? WorkFlowStatusId { get; set; }
        public int? VariationStatusId { get; set; }
        public string ErrorMsg { get; set; }
    }
    public class VatiationDetailList : BaseViewModel
    {
        public int? VariationId { get; set; }
        public string UserAreaName { get; set; }
        public int? WorkFlowStatus { get; set; }
        public string EquipmentDescription { get; set; }
        public string EquipmentCode { get; set; }
        public string AssetNo { get; set; }
        public string Manufacturer { get; set; }
        public string Model { get; set; }
        public decimal? PurchaseCost { get; set; }
        public string VariationStatus { get; set; }
        public DateTime? StartServiceDate { get; set; }
        public DateTime? WarrantyExpiryDate { get; set; }
        public DateTime? StopServiceDate { get; set; }
        public decimal? MaintenanceRateDW { get; set; }
        public decimal? MaintenanceRatePW { get; set; }
        public decimal? MonthlyProposedFeeDW { get; set; }
        public decimal? MonthlyProposedFeePW { get; set; }
        public decimal? CountingDays { get; set; }
        public int? Action { get; set; }
        public string Remarks { get; set; }
        public int FirstRecord { get; set; }
        public int LastRecord { get; set; }
        public int TotalPages { get; set; }
       
    }

   

    public class VVFExportEntity
    {
        public int? Month { get; set; }
        public int? Year { get; set; }
       
        public int? WorkFlowStatusId { get; set; }
        public int? VariationStatusId { get; set; }
        public int AssetId { get; set; }
        public string AssetNo { get; set; }
        public string UserAreaName { get; set; }
        public string Manufacturer { get; set; }
        public string Model { get; set; }
        public decimal PurchaseCost { get; set; }
        public string VariationStatus { get; set; }
        public DateTime CommissioningDate { get; set; }
        public DateTime StartServiceDate { get; set; }
        public DateTime WarrantyExpiryDate { get; set; }
        public DateTime StopServiceDate { get; set; }
        public decimal MaintenanceRateDW { get; set; }
        public decimal MaintenanceRatePW { get; set; }
        public decimal MonthlyProposedFeeDW { get; set; }
        public decimal MonthlyProposedFeePW { get; set; }
        public decimal CountingDays { get; set; }
        public int Action { get; set; }
        public string Remarks { get; set; }
        public string WorkFlowStatus { get; set; }
        public int VariationWFStatus { get; set; }       
        public int VariationWFStatusId { get; set; }

      

    }

   
}
