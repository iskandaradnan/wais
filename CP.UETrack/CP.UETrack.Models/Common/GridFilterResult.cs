namespace CP.UETrack.Model
{
    public class GridFilterResult
    {
        public int TotalPages { get; set; }
        public string CurrentPage { get; set; }
        public int TotalRecords { get; set; }
        public object RecordsList { get; set; }
        public byte[] CompanyLogo { get; set; }
        public byte[] MohLogo { get; set; }
        public string Column_Names { get; set; }
        public string Header_Names { get; set; }
    }
}
