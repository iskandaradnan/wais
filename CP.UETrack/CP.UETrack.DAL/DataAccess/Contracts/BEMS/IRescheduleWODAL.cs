using CP.UETrack.Model;
using CP.UETrack.Model.BEMS;

namespace CP.UETrack.DAL.DataAccess.Contracts.BEMS
{
    public interface IRescheduleWODAL
    {
        RescheduleDropdownValues Load();
        GridFilterResult GetAll(SortPaginateFilter pageFilter);
        void Delete(int RescheduleId);
        RescheduleWOViewModel Get(int RescheduleId);
        RescheduleWOViewModel Save(RescheduleWOViewModel Cust);
        bool IsRecordModified(RescheduleWOViewModel Customer);
        bool IsRescheduleWOCodeDuplicate(RescheduleWOViewModel RescheduleWO);
        RescheduleWOViewModel FetchWorkorder(RescheduleWOViewModel work);
    }
}
