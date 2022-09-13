using System;
namespace CP.UETrack.Model

{
    public class MultiSelectModel
    {
        public string TableName { get; set; }
        public string Condition { get; set; }
        public string Screen { get; set; }
        public string Mode { get; set; }
        public int Id { get; set; }        
        public Nullable<System.DateTime> ReceivedDate { get; set; }
        public string SelectedColumn { get; set; }
        public int SelectedColumnCount { get; set; }

    }
 
}