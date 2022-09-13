using System.Collections.Generic;
using System.Data;
using CP.UETrack.Model;
using CP.UETrack.Model.BEMS;
using CP.UETrack.Model.GM;
using CP.UETrack.Model.VM;

namespace CP.UETrack.DAL.DataAccess.Contracts
{
    public interface IEmailDAL
    {
        void SendUserRegistrationEMail(UMUserRegistration userRegistration);
        void SendUnblockUserEMail(string UserRegistrationIds);
        void SendTandCSubmittedEMail(string TandCDocumentNo, string RequesterEmailId);
        void SendTandCApprovedEMail(string TandCDocumentNo, string RequesterEmailId);
        void SendStopNotificationEMail(string Assetno, bool IsLoaner);
        void SendCAREmail(CorrectiveActionReport correctiveActionReport);
        void SendWorkOrderReassignEmail(ScheduledWorkOrderModel workOrder);
        void SendWorkOrderVendorAssignEmail(ScheduledWorkOrderModel workOrder);
        UMUserRegistration GetContractorInfo(int UserId);
    }
}
