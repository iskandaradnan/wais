using System;

namespace CP.UETrack.Model
{
    public class ModelSearch
    {
        public int ModelId { get; set; }
        public string Model { get; set; }
        public int TypeCodeId { get; set; }
        public int? ManufacturerId { get; set; }
        public string Manufacturer { get; set; }
        public string ScreenName { get; set; }
        public int PageIndex { get; set; }
        public int TotalRecords { get; set; }
        public int FirstRecord { get; set; }
        public int LastRecord { get; set; }
        public int LastPageIndex { get; set; }

        public int TypeOfServices { get; set; }

    }
}
