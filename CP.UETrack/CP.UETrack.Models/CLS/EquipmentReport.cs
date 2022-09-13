using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace CP.UETrack.Model.CLS
{
    public class EquipmentReport
    {
        public int Month { get; set; }
        public int Year { get; set; }
        public string EquipmentCode { get; set; }
        public string EquipmentDescription { get; set; }
        public string Quantity { get; set; }
        public List<EquipmentReport> EquipmentReportList { get; set; }

    }
}