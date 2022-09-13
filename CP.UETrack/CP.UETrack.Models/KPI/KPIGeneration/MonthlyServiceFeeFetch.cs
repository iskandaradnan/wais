namespace CP.UETrack.Model
{
    public class MonthlyServiceFeeFetch
    {
        public int Year { get; set; }
        public int Month { get; set; }
        public decimal MonthlyServiceFee { get; set; }
        public int IsDeductionGenerated { get; set; }
    }
}
