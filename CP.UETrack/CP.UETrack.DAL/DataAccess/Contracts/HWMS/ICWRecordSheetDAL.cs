using CP.UETrack.Model;
using CP.UETrack.Model.HWMS;

namespace CP.UETrack.DAL.DataAccess.Contracts.HWMS
{
    public interface ICWRecordSheetDAL
    {
        CWRecordSheetCollectionDetailsDropdown Load();
        CWRecordSheet Save(CWRecordSheet CWRecordSheet, out string ErrorMessage);
        CWRecordSheet CollectionDetailsFetch(int Id);
        GridFilterResult GetAll(SortPaginateFilter pageFilter);
        CWRecordSheet Get(int Id);
        CWRecordSheetCollectionDetails CollectionTimeDetails(CWRecordSheetCollectionDetails CWRecordSheet, out string ErrorMessage);
    }
}
