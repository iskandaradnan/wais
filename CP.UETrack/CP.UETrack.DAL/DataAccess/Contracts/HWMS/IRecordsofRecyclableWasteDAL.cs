using CP.UETrack.Model.HWMS;
using CP.UETrack.Model;


namespace CP.UETrack.DAL.DataAccess.Contracts.HWMS
{
    public interface IRecordsofRecyclableWasteDAL
    {
        RecordsDropdowns Load();
        RecordsofRecyclableWaste WasteCodeGet(string WasteType);      
        RecordsofRecyclableWaste CSWRSFetch(RecordsofRecyclableWaste RecordsofRecyclable, out string ErrorMessage);
        RecordsofRecyclableWaste Save(RecordsofRecyclableWaste RecordsofRecyclable, out string ErrorMessage);
        GridFilterResult GetAll(SortPaginateFilter pageFilter);
        RecordsofRecyclableWaste Get(int Id);
    }
}
