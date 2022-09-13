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
  public  class TransportationCategory : FetchPagination
    {
        public int RouteTransportationId { get; set; }
        public int CustomerId { get; set; }
        public int FacilityId { get; set; }
        public string RouteCode { get; set; }
        public string RouteDescription { get; set; }
        public string RouteCategory { get; set; }
        public string Status { get; set; }
        public List<TransportationCategoryTable> TransportationCategoryList { get; set; }        

  }
    public class TransportationCategoryTable : FetchPagination
    {
        public int RouteHospitalId { get; set; }  
        public string HospitalCode { get; set; }
        public string HospitalName { get; set; }
        public string Remarks { get; set; }
        public bool isDeleted { get; set; }
    }
    public class TransportationCategoryDropDown
    {
        public List<LovValue> StatusLovs { get; set; }
        
    }
}
