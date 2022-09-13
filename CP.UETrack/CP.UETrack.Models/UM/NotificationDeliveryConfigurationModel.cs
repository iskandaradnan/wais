using CP.UETrack.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CP.UETrack.Model.UM
{
    public class NotificationDeliveryConfigurationModel
    {        
        public int NotificationDeliveryId { get; set; }
        public int NotificationTemplateId { get; set; }        
        public string NotificationType { get; set; }
        public string NotificationName { get; set; }
        public string Subject { get; set; }
        public bool DisableNotification { get; set; }
        public string UserType { get; set; }
        public int UserTypeId { get; set; }
        public string UserRole { get; set; }        
        public int RecepientType { get; set; }
        public int UserRoleId { get; set; }
        public int UserRegistrationId { get; set; }
        public int CompanyId { get; set; }
        public int LocationId { get; set; }
        public int ServiceId { get; set; }
        public string Service { get; set; }
        public int ModuleId { get; set; }
        public string ModuleName { get; set; }
        public int FacilityId { get; set; }
        public int CreatedBy { get; set; }
        public DateTime CreatedDate { get; set; }
        public DateTime CreatedDateUTC { get; set; }
        public int ModifiedBy { get; set; }
        public DateTime? ModifiedDate { get; set; }
        public DateTime? ModifiedDateUTC { get; set; }
        public string Timestamp { get; set; }        
        public List<NotificationToCcList> NotificationToCcListData { get; set; }
        public List<NotificationDeleteList> NotificationDeleteListData { get; set; }

    }
    public class NotificationTypedropdown
    {
        public List<LovValue> NotificationServiceTypeData { get; set; }
        public List<LovValue> NotificationUserTypeData { get; set; }
        public List<LovValue> NotificationRoleTypeData { get; set; }
        public List<LovValue> NotificationCompanyTypeData { get; set; }
        public List<LovValue> NotificationLocationTypeData { get; set; }
        public List<LovValue> NotificationRoleLovs { get; set; }
    }

    public class NotificationToCcList
    {
        public int NotificationDeliveryId { get; set; }
        public int NotificationTemplateId { get; set; }
        public int RecepientType { get; set; }
        public int UserRoleId { get; set; }
        public int UserRegistrationId { get; set; }     
        public int CompanyId { get; set; }  
        public int LocationId { get; set; }
        public string ToRole { get; set; }
        public string ToUser { get; set; }
        public string ToCompany { get; set; }
        public string ToLocation { get; set; }
        public string CcRole { get; set; }
        public string CcUser { get; set; }
        public string CcCompany { get; set; }
        public string CcLocation { get; set; }
        public string CcEmailId { get; set; }
        public bool IsDeleted { get; set; }
        
    }
    
    public class NotificationDeleteList
    {
        public int NotificationTemplateId { get; set; }
        public int NotificationDeliveryId { get; set; }
        public bool IsDeleted { get; set; }
    }
}
