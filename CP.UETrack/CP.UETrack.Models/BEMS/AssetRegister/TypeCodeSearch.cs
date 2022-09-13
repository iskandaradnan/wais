namespace CP.UETrack.Model
{
    public class TypeCodeSearch
    {
        public int AssetTypeCodeId { get; set; }
        public string AssetTypeCode { get; set; }
        public string AssetTypeDescription { get; set; }
        public string AssetClassificationCode { get; set; }
        public string AssetClassificationDescription { get; set; }
        public int AssetClassificationId { get; set; }
        public int ExpectedLifeSpan { get; set; }
        public int PPM { get; set; }
        public int RI { get; set; }
        public int TypeOfPlanner { get; set; }
        public int Other { get; set; }
        public string RiskRating { get; set; }
        public string ScreenName { get; set; }
        public int CheckEquipmentFunctionDescription { get; set; }
        public int PageIndex { get; set; }
        public int TotalRecords { get; set; }
        public int FirstRecord { get; set; }
        public int LastRecord { get; set; }
        public int LastPageIndex { get; set; }
        public int TypeOfServices { get; set; }
    }
}
