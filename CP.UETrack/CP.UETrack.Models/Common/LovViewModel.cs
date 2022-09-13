namespace CP.UETrack.Model
{
    public class LovViewModel
    {
        public string TableName { get; set; }
        public string FieldsList { get; set; }
        public string Condition { get; set; }
        public string KeyName { get; set; }
        public bool Select { get; set; } = true;
        public bool IsService { get; set; }

    }
    public class FetchViewModel
    {
        public string KeyName { get; set; }
        public string TableName { get; set; }
        public string FetchColumns { get; set; }
        public string Condition { get; set; }
    }
}
