namespace CP.UETrack.Model
{
    public class SysLovMstModel
    {
        public int LovId { get; set; }
        public string LovKey { get; set; }
        public int FieldCode { get; set; }
        public string FieldName { get; set; }
        public string FieldValue { get; set; }
        public string Remarks { get; set; }
        public bool IsDeleted { get; set; }
        public int SortNo { get; set; }
        public bool IsDefault { get; set; }
    }
}
