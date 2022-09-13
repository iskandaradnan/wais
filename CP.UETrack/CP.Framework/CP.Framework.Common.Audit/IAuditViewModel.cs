namespace CP.Framework.Common.Audit
{
    public interface IAuditViewModel
    {
        string VisitorName { get; set; }
        string VisitedArea { get; set; }
        string VisitorIP { set; get; }
        string VisitedDateTime { get; set; }
        string VisitorSession { get; set; }
    }
}
