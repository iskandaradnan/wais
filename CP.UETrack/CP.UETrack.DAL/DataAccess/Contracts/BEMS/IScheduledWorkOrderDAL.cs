using CP.UETrack.Model;
using CP.UETrack.Model.BEMS;

namespace CP.UETrack.DAL.DataAccess.Contracts.BEMS
{
    public interface IScheduledWorkOrderDAL
    {
        ScheduledWorkOrderLovs Load();
        bool Delete(int Id);

        bool ApproveReject(int Id,string Remarks, string Type);
        ScheduledWorkOrderModel Get(int Id);
        ScheduledWorkOrderModel GetQC(int Id);
        ScheduledWorkOrderModel GetCC(int Id);
        ScheduledWorkOrderLovs GetCheckListDD(int Id);
        ScheduledWorkOrderModel GetAssessment(int Id);
        ScheduledWorkOrderModel GetCompletionInfo(int Id, int pagesize, int pageindex);
        ScheduledWorkOrderModel SaveCompletionInfo(ScheduledWorkOrderModel model);
        ScheduledWorkOrderModel SavePartReplacement(ScheduledWorkOrderModel model);
        ScheduledWorkOrderModel SavePurchaseRequest(ScheduledWorkOrderModel model);
        ScheduledWorkOrderModel SavePPMCheckList(ScheduledWorkOrderModel model);
        ScheduledWorkOrderModel GetPartReplacement(int Id, int pagesize, int pageindex);
        ScheduledWorkOrderModel GetPurchaseRequest(int Id);
        ScheduledWorkOrderModel GetPPMCheckList(int Id , int CheckListId);
        ScheduledWorkOrderModel GetTransfer(int Id, int pagesize, int pageindex);
        ScheduledWorkOrderModel GetReschedule(int Id, int pagesize, int pageindex);
        RescheduleWOViewModel GetTempReschedule(int RescheduleId);
        ScheduledWorkOrderModel GetHistory(int Id, int pagesize, int pageindex);
        ScheduledWorkOrderModel PartReplacementPopUp(int Id);
        ScheduledWorkOrderModel FeedbackPopUp(int Id);
        ScheduledWorkOrderModel Popup(int Id, int pagesize, int pageindex);
        ScheduledWorkOrderModel Summary(int Service, int WorkGroup, int Year, int TOP, int pagesize, int pageindex);
        ScheduledWorkOrderModel Save(ScheduledWorkOrderModel model);
        ScheduledWorkOrderModel CalculateResponse(ScheduledWorkOrderModel model);
        ScheduledWorkOrderModel SaveReschedule(ScheduledWorkOrderModel model);
        ScheduledWorkOrderModel SaveAssessment(ScheduledWorkOrderModel model);
        ScheduledWorkOrderModel SaveTransfer(ScheduledWorkOrderModel model);
        //bool IsAssetTypeCodeDuplicate(PPMCheckListModel model);
        bool IsRecordModified(ScheduledWorkOrderModel model);

        ScheduledWorkOrderModel VendorAssessProcess(ScheduledWorkOrderModel model);
        //  GridFilterResult GetAll(SortPaginateFilter pageFilter);
    }
}
