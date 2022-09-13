using CP.UETrack.Model.FetchModels;
using CP.UETrack.Models;
using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CP.UETrack.Model.HWMS
{
    public class BinMaster : FetchPagination
    {
        public int BinMasterId { get; set; }
        public int CustomerId { get; set; }
        public int FacilityId { get; set; }
        public string CapacityCode { get; set; }
        public string Description { get; set; }
        public string WasteType { get; set; }
        public int NoofBins { get; set; }  
        public List<BinMasterTable> binDetailslist { get; set; }
        public List<BinMaster> AutoDisplay { get; set; }       

    }
    public class BinMasterTable : FetchPagination
    {
        public int BinNoId { get; set; }
        public string BinNo { get; set; }
        public string Manufacturer { get; set; }
        public string Weight { get; set; }
        public DateTime OperationDate { get; set; }
        public string Status { get; set; }
        [DataType(DataType.Date)] 
        public DateTime? DisposedDate { get; set; }
        public bool isDeleted { get; set; }
    }
    public class BinMasterDropDown
    {
        public List<LovValue> StatusLovs { get; set; }
        public List<LovValue> CapacityCodeLovs { get; set; }
        public List<LovValue> WasteTypeLovs { get; set; }
    }

}
