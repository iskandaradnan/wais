using CP.UETrack.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CP.UETrack.Model.QAP
{
    public class QualityCauseMasterModel
    {
        public int QualityCauseId { get; set; }
        public int ServiceId { get; set; }
        public string Service { get; set; }
        public string CauseCode { get; set; }
        public string Description { get; set; }
        public string QcCode { get; set; }
        public int ProblemCode { get; set; }
        public string ProblemValue { get; set; }
        public string StatusValue { get; set; }
        public int Status { get; set; }
        public int CreatedBy { get; set; }
        public DateTime CreatedDate { get; set; }
        public DateTime CreatedDateUTC { get; set; }
        public int ModifiedBy { get; set; }
        public DateTime? ModifiedDate { get; set; }
        public DateTime? ModifiedDateUTC { get; set; }
        public string Timestamp { get; set; }
        public bool Active { get; set; }
        public bool BuiltIn { get; set; }
        public List<ItemQualityCauseMasterList> QualityCauseListData { get; set; }
    }
    public class QualityCauseTypeDropdown
    {
        public List<LovValue> QualityServiceTypeData { get; set; }
        public List<LovValue> QualityStatusTypeData { get; set; }
        public List<LovValue> QualityProblemTypeData { get; set; }
    }
    public class ItemQualityCauseMasterList
    {
        public int QualityCauseDetId { get; set; }
        public int QualityCauseId { get; set; }
        public int ProblemCode { get; set; }
        public string QcCode { get; set; }
        public string Details { get; set; }
        public int Status { get; set; }
        public string Description { get; set; }
        public int CreatedBy { get; set; }
        public DateTime CreatedDate { get; set; }
        public DateTime CreatedDateUTC { get; set; }
        public int ModifiedBy { get; set; }
        public DateTime? ModifiedDate { get; set; }
        public DateTime? ModifiedDateUTC { get; set; }
        public string Timestamp { get; set; }
        public bool Active { get; set; }
        public bool BuiltIn { get; set; }
        public int PageIndex { get; set; }
        public int TotalRecords { get; set; }
        public int FirstRecord { get; set; }
        public int LastRecord { get; set; }
        public int LastPageIndex { get; set; }
        public int PageSize { get; set; }
        public int TotalPages { get; set; }
        public bool IsDeleted { get; set; }
    }
}
