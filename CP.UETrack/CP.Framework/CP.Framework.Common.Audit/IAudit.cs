namespace CP.Framework.Common.Audit
{
    public interface IAudit
    {
        bool Save(IAuditViewModel model);
    }
}
