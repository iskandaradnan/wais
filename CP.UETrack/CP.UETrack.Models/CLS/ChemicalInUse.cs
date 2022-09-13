using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.ComponentModel;
using System.ComponentModel.DataAnnotations;
using System.Web;

namespace CP.UETrack.Model.CLS
{
    public class ChemicalInUse
    {
        public int CustomerId { get; set; }
        public int FacilityId { get; set; }
        public int ChemicalId { get; set; }
        public string DocumentNo { get; set; }
        public DateTime Date { get; set; }
        public string Remarks { get; set; }
        public List<Chemicals> ChemicalsList { get; set; }
        public List<ChemicalInUseAttachments> AttachmentList { get; set; }
        public List<ChemicalInUseAttachments> lstChemicalInUseAttachments { get; set; }
    }

    public class Chemicals
    {
        public int CategoryId { get; set; }
        public int ChemicalInUseId { get; set; }        
        public int Category { get; set; }
        public int AreaofApplication { get; set; }
        public int ChemicalId { get; set; }
        public string KMMNO { get; set; }
        public string Properties { get; set; }
        public int Status { get; set; }
        [DataType(DataType.Date)]
        public DateTime? EffectiveDate { get; set; }
        public bool isDeleted { get; set; }
    }

    public class ChemicalInUseAttachments
    {   
        public int AttachmentId { get; set; }
        public string FileType { get; set; }
        public string FileName { get; set; }
        [Required(ErrorMessage = "Please choose file to upload.")]
        public string AttachmentName { get; set; }
        public string FilePath { get; set; }
        public bool isDeleted { get; set; }

    }
   
}
