using CP.UETrack.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CP.UETrack.Model.LLS
{
    public class LaundryPlantModel
    {
        public string HiddenId { get; set; }
        public int UserAreaID { get; set; }
        public string UserAreaCode { get; set; }
        public int LaundryPlantId { get; set; }
        public int CustomerID { get; set; }
        public int FacilityID { get; set; }
        public string LaundryPlantCode { get; set; }
        public string LaundryPlantName { get; set; }
        public int Ownership { get; set; }
        public string Ownerships { get; set; }
        public Decimal Capacity { get; set; }
        public string ContactPerson { get; set; }
        public int Status { get; set; }
        public string Statuss { get; set; }



        public int CreatedBy { get; set; }
        public DateTime CreatedDate { get; set; }
        public DateTime CreatedDateUTC { get; set; }
        public int ModifiedBy { get; set; }
        public DateTime ModifiedDate { get; set; }
        public DateTime ModifiedDateUTC { get; set; }
        public string Timestamp { get; set; }
        public bool IsDeleted { get; set; }

        public List<LaundryPlantModelUpdate> LaundryPlantModelUpdateList{get; set;}

    }
    public class LaundryPlantModelFilter
    {
        public string HiddenId { get; set; }
        public int UserAreaID { get; set; }
        public string UserAreaCode { get; set; }
        public int LaundryPlantId { get; set; }
        public int CustomerID { get; set; }
        public int FacilityID { get; set; }
        public string LaundryPlantCode { get; set; }
        public string LaundryPlantName { get; set; }
        public string Ownership { get; set; }
        public string Ownerships { get; set; }
        public Decimal Capacity { get; set; }
        public string ContactPerson { get; set; }
        public string Status { get; set; }
        public string Statuss { get; set; }



        public int CreatedBy { get; set; }
        public DateTime CreatedDate { get; set; }
        public DateTime CreatedDateUTC { get; set; }
        public int ModifiedBy { get; set; }
        public DateTime ModifiedDate { get; set; }
        public DateTime ModifiedDateUTC { get; set; }
        public string Timestamp { get; set; }
        public bool IsDeleted { get; set; }

        public List<LaundryPlantModelUpdate> LaundryPlantModelUpdateList { get; set; }

    }

    public class LaundryPlantModelUpdate
    {
        public int LaundryPlantId { get; set; }
        public int CustomerID { get; set; }
        public int FacilityID { get; set; }
        public string LaundryPlantCode { get; set; }
        public string LaundryPlantName { get; set; }
        public int Ownership { get; set; }
        public string Ownerships { get; set; }
        public Decimal Capacity { get; set; }
        public string ContactPerson { get; set; }
        public int Status { get; set; }
        public string Statuss { get; set; }

    }


    public class LaundryPlantModelLovs
    {
       public List<LovValue> Ownership { get; set; }
        public List<LovValue> Status { get; set; }

    }

}
