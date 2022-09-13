namespace CP.UETrack.Models
{
    public class LovValue
    {
        public int LovId { get; set; }
        public string FieldValue { get; set; }
        public bool DefaultValue { get; set; }
    }
    public class LovValueServices
    {
        public int LovId { get; set; }
        public string FieldValue { get; set; }
        public bool DefaultValue { get; set; }
    }
    public class LovValueDesc
    {
        public int LovId { get; set; }
        public string FieldValue { get; set; }
        public bool DefaultValue { get; set; }
        public string Description { get; set; }
    }
    public class LovSelectedVisible
    {
        public int LovId { get; set; }
        public string FieldValue { get; set; }
        public bool IsSelected { get; set; }
        public bool IsVisible { get; set; }
    }
    public class LovSelected
    {
        public int LovId { get; set; }
        public string FieldValue { get; set; }
        public bool IsSelected { get; set; }
        public int UserRoleId { get; set; }
    }
  
    
}
