using CP.UETrack.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using CP.UETrack.Model.FetchModels;


namespace CP.UETrack.Model.HWMS
{
    public class WasteType : FetchPagination
    {
        public int WasteTypeId { get; set; }
        public int CustomerId { get; set; }
        public int FacilityId { get; set; }
        public string WasteCategory { get; set; }
        public string WasteOfType { get; set; }
        public List<WasteTypeTable> WasteTypeDetailsList { get; set; }
    }
    public class WasteTypeTable {       
        public int WasteId { get; set; }            
        public string WasteCode { get; set; }
        public string WasteDescription { get; set; }
        public bool isDeleted { get; set; }
    }
    public class WasteTypeLoad
    {
        public List<LovValue> WasteCategoryLovs { get; set; }
        public List<LovValue> WasteTypeLovs { get; set; }
    }
}
