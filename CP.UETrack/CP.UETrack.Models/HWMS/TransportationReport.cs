using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CP.UETrack.Model.HWMS
{
   public class TransportationReport
    {
        public int Year { get; set; }
        public int Month { get; set; }
        public string ConsignmentNote { get; set; }
        public string Date { get; set; }
        public string QCValue { get; set; }
        public string VehicleNumber { get; set; }
        public string DriverName { get; set; }
        public string ONSchedule { get; set; }
        public List<TransportationReport> TransportationReportList { get; set; }
    }
}
