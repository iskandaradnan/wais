using CP.UETrack.Model;
namespace CP.UETrack.DAL.DataAccess
{
    public interface ITestingAndCommissioningDAL
    {
        TestingAndCommissioningLovs Load();
        TestingAndCommissioning Save(TestingAndCommissioning testingAndCommissioning, out string ErrorMessage);
        TAndCSNF SaveSNF(TAndCSNF testingAndCommissioning, out string ErrorMessage);
        GridFilterResult GetAll(SortPaginateFilter pageFilter);
        TestingAndCommissioning Get(int Id);
        void Delete(int Id, out string ErrorMessage);
        bool IsSerialNoDuplicate(TestingAndCommissioning testingAndCommissioning);
    }
}