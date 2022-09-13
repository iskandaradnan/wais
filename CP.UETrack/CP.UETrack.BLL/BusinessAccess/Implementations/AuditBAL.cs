using CP.UETrack.BAL.BusinessAccess;
using CP.UETrack.DAL.DataAccess;
namespace CP.UETrack.BLL.BusinessAccess.Implementations
{
    public class AuditBAL : IAuditBAL
    {
        public IAuditDAL _auditDAL;
        public AuditBAL(IAuditDAL auditDAL)
        {
            _auditDAL = auditDAL;
        }
        public bool Save<T>(T viewModel)
        {
            return _auditDAL.Save(viewModel);
        }
    }
}
