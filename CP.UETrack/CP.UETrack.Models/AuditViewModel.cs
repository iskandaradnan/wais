
using System;
using CP.Framework.Common.Audit;
namespace CP.UETrack.Model
{
    [Serializable]
    public class AuditViewModel : IAuditViewModel
    {
        public string VisitedArea
        {
            get;set;
        }

        public string VisitedDateTime
        {
            get; set;
        }

        public string VisitorIP
        {
            get; set;
        }

        public string VisitorName
        {
            get; set;
        }

        public string VisitorSession
        {
            get;


            set;
           
        }
    }
}