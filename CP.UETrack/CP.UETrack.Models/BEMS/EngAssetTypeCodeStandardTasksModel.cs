using CP.UETrack.Models;
using System;
using System.Collections.Generic;

namespace CP.UETrack.Model.BEMS
{
    public class EngAssetTypeCodeStandardTasksModel
    {
        public int StandardTaskId { get; set; }
        public int ServiceId { get; set; }
        public string ServiceName { get; set; }
        public int WorkGroupId { get; set; }
        public string WorkGroupName { get; set; }
        public int AssetTypeCodeId { get; set; }
        public bool Active { get; set; }
        public string Timestamp { get; set; }
        public int CreatedBy { get; set; }
        public DateTime CreatedDate { get; set; }
        public DateTime CreatedDateUTC { get; set; }
        public int ModifiedBy { get; set; }
        public DateTime? ModifiedDate { get; set; }
        public DateTime? ModifiedDateUTC { get; set; }
        public string AssetTypeCode { get; set; }
        public List<EngAssetTypeCodeStandardTasksDetModel> AssetTypeCodeStandardTasksDets { get; set; }
        public string AssetTypeDescription { get; set; }
        public List<EngAssetTypeCodeStandardTasksHistoryDet> EngAssetTypeCodeStandardTasksHistoryDets { get; set; }
    }

    public class EngAssetTypeCodeStandardTasksDetModel
    {
        public int StandardTaskDetId { get; set; }
        public int StandardTaskId { get; set; }
        public string TaskCode { get; set; }
        public string TaskDescription { get; set; }
        public int? PPMId { get; set; }
        public int? ModelId { get; set; }
        public string OGWI { get; set; }
        public DateTime? EffectiveFrom { get; set; }
        public DateTime? EffectiveFromUTC { get; set; }
        public int CreatedBy { get; set; }
        public DateTime CreatedDate { get; set; }
        public DateTime CreatedDateUTC { get; set; }
        public int ModifiedBy { get; set; }
        public DateTime? ModifiedDate { get; set; }
        public DateTime? ModifiedDateUTC { get; set; }
        public bool Active { get; set; }
        public string Timestamp { get; set; }
        public string Model { get; set; }
        public int ServiceId { get; set; }
        public string PPMChecklistNo { get; set; }
        public int Status { get; set; }
        public int DocumentId { get; set; }

    }
    public class EngAssetTypeCodeStandardTaskLovs
    {
        public List<LovValue> ServiceList { get; set; }
        public List<LovValue> StatusList { get; set; }
        public List<EngAssetWorkGroupModel> EngAssetWorkGroupList { get; set; }
        public string ServiceName { get; set; }
        public string WorkGroupName { get; set; }
    }

    public class EngAssetWorkGroupModel
    {
        public int WorkGroupId { get; set; }
        public int ServiceId { get; set; }
        public string WorkGroupDescription { get; set; }
        public string WorkGroupCode { get; set; }
        public string Timestamp { get; set; }

    }
    public class EngAssetTypeCodeStandardTasksHistoryDet
    {
        public int StandardTaskHistoryId { get; set;  }
        public int StandardTaskDetId { get; set; }
        public int StandardTaskId { get; set; }
        public int Status { get; set; }
        public string  StatusName { get; set; }      
        public DateTime? EffectiveFrom { get; set; }
        public DateTime? EffectiveFromUTC { get; set; }
        public string TaskCode { get; set; }
        public string TaskDescription { get; set; }
    }    
}
