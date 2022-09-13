
namespace CP.UETrack.Model
{
    public class EODCaptureManufacturer
    {
        public int ManufacturerId { get; set; }
        public string Manufacturer { get; set; }
        public int ModelId { get; set; }
        public string Model { get; set; }
        public int? CategorySystemId { get; set; }
        public int PageIndex { get; set; }
        public int TotalRecords { get; set; }
        public int FirstRecord { get; set; }
        public int LastRecord { get; set; }
        public int LastPageIndex { get; set; }
    }
}