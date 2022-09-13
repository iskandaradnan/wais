namespace CP.UETrack.Model
{
    public class KPIGeneration
    {
        public int DedGenerationId { get; set; }
        public int CustomerId { get; set; }
        public int FacilityId { get; set; }
        public int ServiceId { get; set; }
        public int Month { get; set; }
        public int Year { get; set; }
        public int Group { get; set; }
        public decimal MonthlyServiceFee { get; set; }
        public string DeductionStatus { get; set; }
        public string DocumentNo { get; set; }
        public string Remarks { get; set; }
        public int UserId { get; set; }
        public string Timestamp { get; set; }
    }
}