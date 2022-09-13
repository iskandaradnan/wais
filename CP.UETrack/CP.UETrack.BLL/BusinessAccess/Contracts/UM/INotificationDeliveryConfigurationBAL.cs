using CP.UETrack.Model;
using CP.UETrack.Model.UM;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CP.UETrack.BLL.BusinessAccess.Contracts.UM
{
    public interface INotificationDeliveryConfigurationBAL
    {
        NotificationTypedropdown Load();
        NotificationDeliveryConfigurationModel Save(NotificationDeliveryConfigurationModel Notification, out string ErrorMessage);
        NotificationDeliveryConfigurationModel Get(int Id);        
        NotificationTypedropdown GetRole(int Id);
        NotificationTypedropdown GetCompany(int Id);
        NotificationTypedropdown GetLocation(int Id);
        bool Delete(string Id);
        GridFilterResult GetAll(SortPaginateFilter pageFilter);
    }
}
