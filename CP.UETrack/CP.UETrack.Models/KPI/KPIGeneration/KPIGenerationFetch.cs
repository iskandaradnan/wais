namespace CP.UETrack.Model
{
    public class KPIGenerationFetch
    {
        public int Year { get; set; }
        public int Month { get; set; }
        public int ServiceId { get; set; }
        public int FacilityId { get; set; }
        public string IndicatorNo { get; set; }
        public int PageIndex { get; set; }
        public int PageSize { get; set; }
    }
}
