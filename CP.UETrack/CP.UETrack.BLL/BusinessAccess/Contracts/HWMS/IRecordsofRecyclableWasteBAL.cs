using CP.UETrack.Model.HWMS;
using CP.UETrack.Model;

namespace CP.UETrack.BLL.BusinessAccess.Contracts.HWMS
{
    public interface IRecordsofRecyclableWasteBAL
    {
        RecordsDropdowns Load();
        RecordsofRecyclableWaste WasteCodeGet(string WasteType);
        RecordsofRecyclableWaste CSWRSFetch(RecordsofRecyclableWaste userRole, out string ErrorMessage);
        RecordsofRecyclableWaste Save(RecordsofRecyclableWaste userRole, out string ErrorMessage);
        GridFilterResult GetAll(SortPaginateFilter pageFilter);
        RecordsofRecyclableWaste Get(int Id);

    }
}
