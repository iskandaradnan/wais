using CP.UETrack.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using CP.UETrack.Model.FetchModels;


namespace CP.UETrack.Model.HWMS
{
    public class RecordsofRecyclableWaste : FetchPagination
    {
        public int RecyclableId { get; set; }
        public int CustomerId { get; set; }
        public int FacilityId { get; set; }
        public string RRWNo { get; set; }
        public DateTime DateTime { get; set; }
        public float TotalWeight { get; set; }
        public string MethodofDisposal { get; set; }
        public string CSWRepresentative { get; set; }
        public string CSWRepresentativeDesignation { get; set; }
        public string HospitalRepresentative { get; set; }
        public string HospitalRepresentativeDesignation { get; set; }
        public string VendorCode { get; set; }
        public string VendorName { get; set; }
        public float UnitRate { get; set; }
        public float ReturnValue { get; set; }
        public float TotalAmount { get; set; }
        public string InvoiceNoReceiptNo { get; set; }
        public string WasteType { get; set; }
        public string WasteCode { get; set; }
        public string TransportationCategory { get; set; }
        public string Remarks { get; set; }       
        public DateTime StartDate { get; set; }
        public DateTime EndDate { get; set; }    
        
        public List<RecyclableRecords> RecordsofRecyclableWasteList { get; set; }
        public List<RecyclableRecords> CSWRSDetailsFetchList { get; set; }
        public List<RecordsofRecyclableWaste> RecyclableWaste { get; set; }

    }
    public class RecyclableRecords
    {        
        public int CSWRSId { get; set; }
        public string UserAreaCode { get; set; }
        public string UserAreaName { get; set; }
        public string CSWRSNo { get; set; }
        public bool isDeleted { get; set; }
        
    }

    public class RecordsDropdowns
    {
        public List<LovValue> MethodofDisposalValue { get; set; }
        public List<LovValue> RecyclableWasteTypeValue { get; set; }
        public List<LovValue> TransportationCategoryValue { get; set; }
    }
}
