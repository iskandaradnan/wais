using CP.UETrack.Model;
using CP.UETrack.Model.BEMS;

namespace CP.UETrack.BLL.BusinessAccess.Contracts.BEMS
{
    public interface IScheduledWorkOrderBAL
    {
        ScheduledWorkOrderLovs Load();
        bool Delete(int Id);

        bool ApproveReject(int Id, string Remarks, string Type);
        ScheduledWorkOrderModel Get(int Id);
        ScheduledWorkOrderModel GetQC(int Id);
        ScheduledWorkOrderModel GetCC(int Id);
        ScheduledWorkOrderLovs GetCheckListDD(int Id);
        ScheduledWorkOrderModel GetAssessment(int Id);
        ScheduledWorkOrderModel GetCompletionInfo(int Id, int pagesize, int pageindex);
        ScheduledWorkOrderModel GetPartReplacement(int Id, int pagesize, int pageindex);
        ScheduledWorkOrderModel GetPurchaseRequest(int Id);
        ScheduledWorkOrderModel GetPPMCheckList(int Id , int CheckListId);
        ScheduledWorkOrderModel GetTransfer(int Id, int pagesize, int pageindex);
        ScheduledWorkOrderModel GetReschedule(int Id, int pagesize, int pageindex);
        ScheduledWorkOrderModel GetHistory(int Id, int pagesize, int pageindex);
        ScheduledWorkOrderModel PartReplacementPopUp(int Id);
        ScheduledWorkOrderModel FeedbackPopUp(int Id);
        ScheduledWorkOrderModel SaveCompletionInfo(ScheduledWorkOrderModel model, out string ErrorMessage);
        ScheduledWorkOrderModel SavePartReplacement(ScheduledWorkOrderModel model, out string ErrorMessage);
        ScheduledWorkOrderModel SavePurchaseRequest(ScheduledWorkOrderModel model, out string ErrorMessage);
        ScheduledWorkOrderModel SavePPMCheckList(ScheduledWorkOrderModel model, out string ErrorMessage);
        ScheduledWorkOrderModel Popup(int Id, int pagesize, int pageindex);
        ScheduledWorkOrderModel Summary(int Service, int WorkGroup, int Year, int TOP, int pagesize, int pageindex);
        ScheduledWorkOrderModel Save(ScheduledWorkOrderModel model, out string ErrorMessage);
        ScheduledWorkOrderModel CalculateResponse(ScheduledWorkOrderModel model, out string ErrorMessage);
        ScheduledWorkOrderModel SaveReschedule(ScheduledWorkOrderModel model, out string ErrorMessage);
        ScheduledWorkOrderModel SaveAssessment(ScheduledWorkOrderModel model, out string ErrorMessage);
        ScheduledWorkOrderModel SaveTransfer(ScheduledWorkOrderModel model, out string ErrorMessage);
        ScheduledWorkOrderModel VendorAssessProcess(ScheduledWorkOrderModel model, out string ErrorMessage);
        // GridFilterResult GetAll(SortPaginateFilter paginationFilter);
    }
}
