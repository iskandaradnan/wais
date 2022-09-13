using CP.UETrack.Model;

namespace CP.UETrack.BLL.BusinessAccess.Interface
{
    public interface ICustomerConfigBAL
    {
        CustomerConfigLovs Load();
        CustomerConfig Save(CustomerConfig customerConfig, out string ErrorMessage);
        CustomerConfig Get(int Id);
    }
}
