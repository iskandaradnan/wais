using CP.UETrack.Model.HWMS;
using CP.UETrack.Model;

namespace CP.UETrack.BLL.BusinessAccess.Contracts.HWMS
{
   public interface ICWRecordSheetBAL
    {
        CWRecordSheetCollectionDetailsDropdown Load();
        CWRecordSheet Save(CWRecordSheet userRole, out string ErrorMessage);
        CWRecordSheet CollectionDetailsFetch(int Id);
        GridFilterResult GetAll(SortPaginateFilter pageFilter);
        CWRecordSheet Get(int Id);
        CWRecordSheetCollectionDetails CollectionTimeDetails(CWRecordSheetCollectionDetails userRole, out string ErrorMessage);
    }
}
