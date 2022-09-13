using CP.UETrack.Model;

namespace CP.UETrack.DAL.DataAccess
{
    public interface ICustomerConfigDAL
    {
        CustomerConfigLovs Load();
        CustomerConfig Save(CustomerConfig customerConfig, out string ErrorMessage);
        //GridFilterResult GetAll(SortPaginateFilter pageFilter);
        CustomerConfig Get(int Id);
        //void Delete(int Id);
    }
}