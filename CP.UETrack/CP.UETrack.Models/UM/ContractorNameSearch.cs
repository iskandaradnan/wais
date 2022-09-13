
namespace CP.UETrack.Model
{
    public class ContractorNameSearch
    {
        public int ContractorId { get; set; }
        public string ContractorName { get; set; }
        public string SSMRegistrationCode { get; set; }
        public int PageIndex { get; set; }
        public int TotalRecords { get; set; }
        public int FirstRecord { get; set; }
        public int LastRecord { get; set; }
        public int LastPageIndex { get; set; }
    }
}