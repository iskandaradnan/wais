using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CP.UETrack.Model
{
    public class UserAreaQRCodePrintingFetchModel
    {
        public int BlockId { get; set; }
        public string BlockCode { get; set; }
        public string BlockName { get; set; }
        public int LevelId { get; set; }
        public string LevelName { get; set; }
        public int UserAreaId { get; set; }
        public string UserAreaCode { get; set; }
        public string UserAreaName { get; set; }
        public int UserLocationId { get; set; }
        public string UserLocationCode { get; set; }
        public string UserLocationName { get; set; }
        public string DeptQRCode { get; set; }
        public string UserLocQRCode { get; set; }
        public int PageIndex { get; set; }
        public int TotalRecords { get; set; }
        public int FirstRecord { get; set; }
        public int LastRecord { get; set; }
        public int LastPageIndex { get; set; }
    }
}
