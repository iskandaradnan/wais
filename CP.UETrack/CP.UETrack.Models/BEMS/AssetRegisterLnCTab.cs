using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CP.UETrack.Model.BEMS
{
   public class AssetRegisterLnCTab
    {
       
        public int AssetRegId { get; set; }
        public string AssetNo { get; set; }
        public string AssetDescription { get; set; }
        public string TypeCode { get; set; }
        public int ServiceId { get; set; }
        public string Service { get; set; }
        public int LicenseId { get; set; }
        public int FacilityId { get; set; }
        public string FacilityName { get; set; }
        public string LicenseNo { get; set; }
        public DateTime? NotificationForInspection { get; set; }
        public DateTime? InspectionConductedOn { get; set; }
        public DateTime? NextInspectionDate { get; set; }
        public DateTime? ExpireDate { get; set; }
        public int IssuingBody { get; set; }
        public string IssuingBodyName { get; set; }
        public DateTime IssuingDate { get; set; }
        public string Remarks { get; set; }
       
        public int CreatedBy { get; set; }
        public DateTime CreatedDate { get; set; }
        public DateTime CreatedDateUTC { get; set; }
        public int ModifiedBy { get; set; }
        public DateTime? ModifiedDate { get; set; }
        public DateTime? ModifiedDateUTC { get; set; }
        public string Timestamp { get; set; }
       

    }


    //public class AssetRegisterLnCTabDetails
    //{
        
    //}
}
