using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CP.UETrack.Model.HWMS
{
   public class RecordSheetWithoutCN
    {
        public int Year { get; set; }
        public int Month { get; set; }
        public string DateOfConsignmentNote { get; set; }
        public string ConsignmentNo { get; set; }
        public string TotalWeight { get; set; }
        public string RM { get; set; }

        public List<RecordSheetWithoutCN> RecordSheetWithoutCNList { get; set; }


    }
}
