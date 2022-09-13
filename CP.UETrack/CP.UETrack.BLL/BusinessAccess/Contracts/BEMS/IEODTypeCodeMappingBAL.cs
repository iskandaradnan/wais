using CP.UETrack.Model;
using CP.UETrack.Model.BEMS;

namespace CP.UETrack.BLL.BusinessAccess.Interface
{
    public interface IEODTypeCodeMappingBAL
    {
        EODDropdownValues Load();
        EODTypeCodeMappingViewModel Save(EODTypeCodeMappingViewModel userRole, out string ErrorMessage);
        GridFilterResult GetAll(SortPaginateFilter pageFilter);
        EODTypeCodeMappingViewModel Get(int Id, int pagesize, int pageindex);
        void Delete(int Id , out string ErrorMessage);
    }
}
