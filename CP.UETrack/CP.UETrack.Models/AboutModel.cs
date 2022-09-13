namespace CP.UETrack.Models
{
    using System.Collections.Generic;
    using System;
    public   class AboutModel
    {
        public int LoggedConcurrentCount { get; set; }       
        public List<VistorHistoryCount> VistorHistory  { get; set; }
        public string sessionId { get; set; }
        public int loginType { get; set; }
        public string LoginName { get; set; }
        public int? HistryType { get; set; }
        public string Selecteddate { get; set; }
    }

    public class VistorHistoryCount
    {
        public string Date { get; set; }
        public int DateViceCount { get; set; }
        public int VisitorId { get; set; }
    }

    public class VistorHistoryDetails
    {
        public string UserId { get; set; }
        public string UserName { get; set; }
        public string SessionId { get; set; }
        public string LoginTime { get; set; }
        public string LogoutTime { get; set; }
        
    }
}
