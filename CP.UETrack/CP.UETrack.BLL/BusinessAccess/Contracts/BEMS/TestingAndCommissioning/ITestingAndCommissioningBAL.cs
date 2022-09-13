using CP.UETrack.Model;

namespace CP.UETrack.BLL.BusinessAccess.Interface
{
    public interface ITestingAndCommissioningBAL
    {
        TestingAndCommissioningLovs Load();
        TestingAndCommissioning Save(TestingAndCommissioning testingAndCommissioning, out string ErrorMessage);
        TAndCSNF SaveSNF(TAndCSNF testingAndCommissioning, out string ErrorMessage);
        GridFilterResult GetAll(SortPaginateFilter pageFilter);
        TestingAndCommissioning Get(int Id);
        void Delete(int Id, out string ErrorMessage);
    }
}
