using CP.UETrack.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CP.UETrack.Model.LLS
{
   public class LinenConemnationModel
    {
        public Decimal LinenPrice { get; set; }
        public int PageIndex { get; set; }
        public int TotalRecords { get; set; }
        public int FirstRecord { get; set; }
        public int LastRecord { get; set; }
        public int LastPageIndex { get; set; }
        public int LinenCondemnationId { get; set; }
        public int CustomerID { get; set; }
        public int FacilityID { get; set; }
        public string DocumentNo { get; set; }
        public DateTime DocumentDate { get; set; }
        public string InspectedBy { get; set; }
        public string VerifiedBy { get; set; }
        public int TotalCondemns { get; set; }
        public string Timestamp { get; set; }
        public decimal Value { get; set; }
        public string LocationOfCondemnation { get; set; }
        public string Remarks { get; set; }


        public int LinenCondemnationDetId { get; set; }
        public int LinenItemId { get; set; }
        public string BatchNo { get; set; }
        public int Total { get; set; }
        public int Torn { get; set; }
        public int Stained { get; set; }
        public int Faded { get; set; }
        public int Vandalism { get; set; }
        public int WearTear { get; set; }
        public int StainedByChemical { get; set; }
        public int LinenInjectionId { get; set; }


        public int CreatedBy { get; set; }
        public DateTime CreatedDate { get; set; }
        public DateTime CreatedDateUTC { get; set; }
        public int ModifiedBy { get; set; }
        public DateTime ModifiedDate { get; set; }
        public DateTime ModifiedDateUTC { get; set; }
       
        public bool IsDeleted { get; set; }
        public DateTime InjectionDate { get; set; }
        public int LinenInjectionDetId { get; set; }

        //==Child2 Table=======
        public List<LLinenCondemnationList> LLinenCondemnationGridList { get; set; }


        //=====================

        public string LinenCode { get; set; }
        public string LinenDescription { get; set; }

        public string StaffName { get; set; }
        

        public int UserRegistrationId { get; set; }

        public string PONo { get; set; }
        public int DOId { get; set; }
        public string DONo { get; set; }
        public DateTime DODate { get; set; }
        public List<LLinenInjectionLinenItem> LLinenInjectionLinenItemListGrid { get; set; }
       


    }


    public class LLinenCondemnationList
    {
        public int LinenCondemnationDetId { get; set; }
        public int LinenItemId { get; set; }
        public string LinenCode { get; set; }
        public string LinenDescription { get; set; }
        public string BatchNo { get; set; }
        public int Total { get; set; }
        public int Torn { get; set; }
        public int Stained { get; set; }
        public int Faded { get; set; }
        public int Vandalism { get; set; }
        public int WearTear { get; set; }
        public int StainedByChemical { get; set; }
        public int PageIndex { get; set; }
        public int TotalRecords { get; set; }
        public int FirstRecord { get; set; }
        public int LastRecord { get; set; }
        public int LastPageIndex { get; set; }
        public int PageSize { get; set; }
        public int TotalPages { get; set; }
        public bool IsDeleted { get; set; }
    }
    public class LinenConemnationModelLovs
    {
        public List<LovValue> LocationofCondemnation { get; set; }

    }

    public class LLinenInjectionLinenItem
    {
        public Decimal LinenPrice { get; set; }
        public int LinenCondemnationDetId { get; set; }
        public int LinenInjectionDetId { get; set; }
        public int LinenInjectionId { get; set; }
        public string LinenCode { get; set; }
        public string LinenDescription { get; set; }
        public int QuantityInjected { get; set; }
        public int LinenItemId { get; set; }
        public string DONo { get; set; }
        public string Guid { get; set; }
        public DateTime DODate { get; set; }
        public string TestReport { get; set; }
        public DateTime? LifeSpanValidity { get; set; }

        public int PageIndex { get; set; }
        public int TotalRecords { get; set; }
        public int FirstRecord { get; set; }
        public int LastRecord { get; set; }
        public int LastPageIndex { get; set; }
        public int PageSize { get; set; }
        public int TotalPages { get; set; }
        public bool IsDeleted { get; set; }
    }
}
