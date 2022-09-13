using CP.UETrack.Model;
using CP.UETrack.Model.VM;

namespace CP.UETrack.DAL.DataAccess.Contracts.VM
{
    public interface IBulkAuthorizationDAL
    {
        BulkAuthorizationViewModel Load();
        BulkAuthorizationViewModel Get(int Year, int Month, int ServiceId, int PageSize, int PageIndex);
        BulkAuthorizationViewModel Save(BulkAuthorizationViewModel Cust);

    }
}
