using CP.UETrack.Model;
using CP.UETrack.Model.CLS;

namespace CP.UETrack.DAL.DataAccess.Contracts.CLS
{
  public  interface IQualityCauseMasterDAL
    {
        QualityCauseMasterDropdown Load();
        QualityCauseMaster Save(QualityCauseMaster block, out string ErrorMessage);
        GridFilterResult GetAll(SortPaginateFilter pageFilter);
        QualityCauseMaster Get(int Id);
    }
}
