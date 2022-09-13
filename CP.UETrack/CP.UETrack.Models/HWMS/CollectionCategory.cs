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
   public class CollectionCategory : FetchPagination
   {
        public int RouteCollectionId { get; set; }
        public int CustomerId { get; set; }
        public int FacilityId { get; set; }
        public string RouteCode { get; set; }
        public string RouteDescription { get; set; }
        public string RouteCategory { get; set; }
        public string Status { get; set; }
        public List<CollectionCategoryTable> CollectionCategoryList { get; set; }       
    }
    public class CollectionCategoryTable
    {
        public int RouteCollectionUserAreaId { get; set; }       
        public string UserAreaCode { get; set; }
        public string UserAreaName { get; set; }
        public string Remarks { get; set; }
        public bool isDeleted { get; set; }
    }
    public class CollectionCategoryDropDown
    {
        public List<LovValue> StatusLovs { get; set; }
        public List<LovValue> RouteCategoryLovs { get; set; }

    }
}
