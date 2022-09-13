
using System;

namespace CP.UETrack.Model
{
    [Serializable]
    public class BaseViewModel : AuditViewModel
    {
        //public IAuditViewModel _auditViewModel;
        //public IAudit _audit;
        //public BaseViewModel(IAuditViewModel auditModel, IAudit audit)
        //{
        //    _auditViewModel = auditModel;
        //    _audit = audit;
        //}
        public int? ServiceId { get; set; }
        public int? MenuId { get; set; }
        public int CreatedBy { get; set; }
        public System.DateTime CreatedDate { get; set; }
        public int ModifiedBy { get; set; }
        public DateTime ModifiedDate { get; set; }
        public string Timestamp { get; set; }
        public Nullable<int> Islatest { get; set; }
        public int PageIndex { get; set; }
        public int PageSize { get; set; }
        public int TotalRecords { get; set; }
        public int LastPage { get; set; }
        public int startIndex { get; set; }
        public int endIndex { get; set; }
        public string SourceReferenceNo { get; set; }
        public string SourceColValue1 { get; set; }
        public string SourceColValue2 { get; set; }
        public string SourceColValue3 { get; set; }
        public string SourceColValue4 { get; set; }
        public string SourceColValue5 { get; set; }      
        public string SetError { get; set; }
        public bool Active { get; set; }
        public bool BuiltIn { get; set; }
    }
}