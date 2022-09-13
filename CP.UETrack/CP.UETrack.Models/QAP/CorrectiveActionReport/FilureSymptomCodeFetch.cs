
namespace CP.UETrack.Model
{
    public class FilureSymptomCodeFetch
    {
        public int QualityCauseId { get; set; }
        public string FailureSymptomCode { get; set; }
        public string Description { get; set; }
        public int PageIndex { get; set; }
        public int TotalRecords { get; set; }
        public int FirstRecord { get; set; }
        public int LastRecord { get; set; }
        public int LastPageIndex { get; set; }
    }
}