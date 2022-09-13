using CP.UETrack.Model;

namespace CP.UETrack.BLL.BusinessAccess.Interface
{
    public interface IEODCategorySystemBAL
    {
        EODCategorySystemViewModel Load();
        EODCategorySystemViewModel Save(EODCategorySystemViewModel userRole, out string ErrorMessage);
        GridFilterResult GetAll(SortPaginateFilter pageFilter);
        EODCategorySystemViewModel Get(int Id);
        void Delete(int Id , out string ErrorMessage);
    }
}
