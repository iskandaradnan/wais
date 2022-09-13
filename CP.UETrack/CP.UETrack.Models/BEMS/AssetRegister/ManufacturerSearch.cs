using System;

namespace CP.UETrack.Model
{
    public class ManufacturerSearch
    {
        public int ServiceId { get; set; }
        public int ManufacturerId { get; set; }
        public string Manufacturer { get; set; }
        public int TypeCodeId { get; set; }
        public int ModelId { get; set; }
        public string ScreenName { get; set; }
        public int PageIndex { get; set; }
        public int TotalRecords { get; set; }
        public int FirstRecord { get; set; }
        public int LastRecord { get; set; }
        public int LastPageIndex { get; set; }
        public int UserAreaId { get; set; }

        public string UserAreaCode { get; set; }

    }
}
