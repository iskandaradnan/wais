using System;
using CP.Framework.Common.Audit;
using CP.ASIS.Service.Interface;
using CP.ASIS.Service;
using CP.ASIS.BLL.BusinessAccess.Implementations;
using CP.ASIS.DAL.DataAccess.Implementation;

namespace ASIS.Application.Web
{
    public class AuditDB : IAudit
    {
        //IAuditService _auditService;
        //public AuditDB(IAuditService auditService)
        //{
        //    _auditService = auditService;
        //}
        public bool Save(IAuditViewModel model)
        {
            IAuditService _auditService = new AuditService(new AuditBAL(new AuditDAL()));
            return _auditService.Save(model);
        }
    }
}