using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.ComponentModel.DataAnnotations;

namespace CP.UETrack.Model.CLS
{
   public class ChemicalUsedReport
   {
        public int Month { get; set; }
        public int Year { get; set; }
        public string ChemicalName { get; set; }
        public string KMMNO { get; set; }
        public string Category { get; set; }
        public string AreaofApplication { get; set; }                
        public string Properties { get; set; }
        public string Status { get; set; }        
        public string EffectiveDate { get; set; }
        public List<ChemicalUsedReport> ChemicalReportList { get; set; }
    }
}
