using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace CP.UETrack.Model.CLS
{
    public class WeekCalendar
    {           
        public int CustomerId { get; set; }
        public int FacilityId { get; set; }
        public string Year { get; set; }
        public string Month { get; set; }
        public int WeekNo { get; set; }
        public DateTime StartDate { get; set; }
        public DateTime EndDate { get; set; }
        
    }
   
}
