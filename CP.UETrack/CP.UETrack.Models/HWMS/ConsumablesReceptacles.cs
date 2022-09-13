using CP.UETrack.Model.FetchModels;
using CP.UETrack.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CP.UETrack.Model.HWMS
{
    public class ConsumablesReceptacles : FetchPagination
    {  
        public int ConsumablesId { get; set; }
        public int CustomerId { get; set; }
        public int FacilityId { get; set; }
        public string WasteCategory { get; set; }
        public string WasteType { get; set; }
        public List<ItemTable> ItemList { get; set; }     
        public List<ConsumablesReceptacles> ConsumablesReceptaclesList { get; set; }
    }

    public class ItemTable : FetchPagination
    {     
        public int ItemCodeId { get; set; }
        public string ItemCode { get; set; }
        public string ItemName { get; set; }
        public string ItemType { get; set; }
        public string Size { get; set; }
        public string UOM { get; set; }
        public bool isDeleted { get; set; }
        public int WasteTypeCode { get; set; }
    }
    public class ItemTypeDropdown
    {
        public List<LovValue> WasteCategoryLovs { get; set; }
        public List<LovValue> WasteTypeConsumables { get; set; }
        public List<LovValue> ItemTypeConsumables { get; set; }
        public List<LovValue> UOMLovs { get; set; }
    }
}
