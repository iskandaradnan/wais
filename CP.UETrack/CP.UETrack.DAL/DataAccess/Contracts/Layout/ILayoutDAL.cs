using CP.UETrack.Model.BEMS.CRMWorkOrder;
using CP.UETrack.Model.Layout;
namespace CP.UETrack.DAL.DataAccess
{
    public interface ILayoutDAL
    {
        CustomerFacilityLovs GetCustomerAndFacilities();
        CustomerFacilityLovs GetFacilities(int CustomerId);

        NotificationCount GetNotificationCount(int FacilityId, int UserId);
        Notification GetNotification(int pagesize, int pageindex);
        Notification ReseteNotificationCount(Notification notify);
        Notification ClearNavigatedRec(Notification notifi);

        CustomerFacilityLovs LoadCustomer();
        CustomerFacilityLovs LoadFacility(int CusId);
        CustomerFacilityLovs GetCustomerFacilityDet(int CusId, int FacId);

    }
}


