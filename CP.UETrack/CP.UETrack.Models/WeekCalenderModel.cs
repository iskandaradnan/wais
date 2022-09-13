using CP.UETrack.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CP.UETrack.Model
{
    public class WeekCalenderModel
    {
        public int YearId { get; set; }
        public string Year { get; set; }
        //==Child Table 1=======
        public List<WeekCalenderList> WeekCalenderList { get; set; }
        //=========//
    }
    public class WeekCalenderList
    {
        public string Month { get; set; }
        public string WeekNo { get; set; }
        public DateTime StartDate { get; set; }
        public DateTime EndDate { get; set; }
    }
    public class WeekCalenderModelLovs
    {
        public List<LovValue> Month { get; set; }
        public List<LovValue> Year { get; set; }
    }
}
