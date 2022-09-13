using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CP.UETrack.Model
{
    public class HistoryViewModel
    {
        public string GuId { get; set; }
        public int PageIndex { get; set; }
        public int PageSize { get; set; }
        public int TotalRecords { get; set; }
        public string TableRowData { get; set; }
        public int LastRecord { get; set; }
        public int FirstRecord { get; set; }
        public int LastPageIndex { get; set; }


    }
}
