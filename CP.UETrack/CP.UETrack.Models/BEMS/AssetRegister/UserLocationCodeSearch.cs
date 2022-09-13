namespace CP.UETrack.Model
{
    public class UserLocationCodeSearch
    {
        public int UserLocationId { get; set; }
        public int UserAreaId { get; set; }
        public int LevelId { get; set; }
        public int BlockId { get; set; }
        public int FacilityId { get; set; }
        public string UserLocationCode { get; set; }
        public string UserLocationName { get; set; }       
        public string UserAreaCode { get; set; }
        public string UserAreaName { get; set; }
        public string LevelName { get; set; }
        public string LevelCode { get; set; }
        public string BlockName { get; set; }
        public string BlockCode { get; set; }
        public string FacilityName { get; set; }
        public string FacilityCode { get; set; }
        public int PageIndex { get; set; }
        public int TotalRecords { get; set; }
        public int FirstRecord { get; set; }
        public int LastRecord { get; set; }
        public int LastPageIndex { get; set; }

    }
}
