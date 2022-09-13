using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using CP.UETrack.Model.Common;
using CP.UETrack.Models;

namespace CP.UETrack.Model.CLS
{
    public class ApprovedChemicalList
    {
        public int ApprovedChemicalId { get; set; }
        public int CustomerId { get; set; }
        public int FacilityId { get; set; }
        public string Category { get; set; }
        public string AreaofApplication { get; set; }
        public string ChemicalName { get; set; }
        public string KKMNumber { get; set; }
        public string Properties { get; set; }
        public int Status { get; set; }
        public DateTime EffectiveFromDate { get; set; }
        public DateTime? EffectiveToDate { get; set; }
        public List<Attachment> AttachmentList { get; set; }

    }

 

    public class ApprovedChemicalListDropdown
    {
        public List<LovValue> StatusLovs { get; set; }
        public List<LovValue> CategoryLovs { get; set; }
        public List<LovValue> CategoryLovs1 { get; set; }
        public List<LovValue> AreaOfApplicationLovs { get; set; }
        public List<LovValue> ChemicalNames { get; set; }
        public List<LovValue> FileTypeLovs { get; set; }

    }
}
