using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CP.UETrack.Model.ICT
{
 public  class EngPpmScheduleGenTxnViewModel
    {

        public int WeekLogId { get; set; }
        public Nullable<int> PpmScheduleId { get; set; }
        public int HospitalId { get; set; }
        public Nullable<int> WorkGroupId { get; set; }
        public Nullable<int> EngUserAreaId { get; set; }
        public int CompanyId { get; set; }
        public int ServiceId { get; set; }
        public Nullable<int> WarrantyAsset { get; set; }
        public Nullable<int> WorkGroup { get; set; }
        public Nullable<int> Year { get; set; }
        public Nullable<int> Month { get; set; }
        public Nullable<int> TypeOfPlanner { get; set; }
        public Nullable<int> WeekNoGenerated { get; set; }

        public Nullable<DateTime> StartDate { get; set; }
        public Nullable<DateTime> EndDate { get; set; }
        public Nullable<int> CreatedBy { get; set; }
        //public Nullable<DateTime> CreatedDate { get; set; }
        //public Nullable<int> ModifiedBy { get; set; }
        //public Nullable<DateTime> ModifiedDate { get; set; }
        public byte[] Timestamp { get; set; }
        public bool IsDeleted { get; set; }
        public bool isExport { get; set; }
        public int Tab { get; set; }
        public string Guid { get; set; }
        public Nullable<bool> IsMailSent { get; set; }

        public bool IsGenerateSuccess { get; set; }
        public string FetchType { get; set; }
        public string FmsUserAreaCode { get; set; }
        public string FmsUserAreaName { get; set; }
        public Nullable<int> IntervalInWeeks { get; set; }

        public string JobDescription { get; set; }
        public string PrintActionType { get; set; }
        public string contentType { get; set; }
        public string contentAsBase64String { get; set; }
        public string FileName { get; set; }
        public string FilePath { get; set; }
        public string AgreedDateActionType { get; set; }
        public string WebRootPath { get; set; }

        // public List<EngPpmScheduleGenTxnDetViewModel> EngPpmScheduleGenTxnDets { get; set; }

    }




    public class EngScheduleGenerationFileJobViewModel
    {
        public int WeekLogId { get; set; }
        public int Jobid { get; set; }
        public Nullable<int> Hospitalid { get; set; }
        public Nullable<int> Companyid { get; set; }
        public int Service { get; set; }
        public string JobName { get; set; }
        public string JobDescription { get; set; }
        public string Gid { get; set; }
        public string Status { get; set; }
        public Nullable<int> CreatedBy { get; set; }
        public Nullable<System.DateTime> CreateDate { get; set; }
        public Nullable<bool> IsDeleted { get; set; }
        public int TypeOfPlanner { get; set; }
        public int Year { get; set; }
        public int WeekNo { get; set; }
        public int WorkGroupId { get; set; }
        public int EngUserAreaId { get; set; }
        public string HospitalNmae { get; set; }
        public string CompanyName { get; set; }
        public string YearPath { get; set; }
        public string MonthPath { get; set; }
        public string FileName { get; set; }

        public bool RePrintStatus { get; set; }
        public string file_name { get; set; }
    }

    public class EngPpmPrintlist
    {
        public int WeekLogId { get; set; }
        public int WorkOrderId { get; set; }
        public string WorkOrderNo { get; set; }
        public int AssetTypecodeId { get; set; }
        public string checklistpath { get; set; }
        public string WebRootPath { get; set; }
        public int ModuleId { get; set; }
        
        public Nullable<int> DocumentId { get; set; }
    }

    public class EngPpmScheduleGenPrint
    {
        public int WeekLogId { get; set; }
        public string WorkOrderNo { get; set; }
        public string WebRootPath { get; set; }
        public int ModuleId { get; set; }



        public int FacilityId { get; set; }
        public int CustomerId { get; set; }
        public int Service { get; set; }
        public int CreatedBy { get; set; }
        public string Description { get; set; }
        public string guid { get; set; }
        public string mappedPath { get; set; }
        public int TypeOfPlanner { get; set; }
        public int Year { get; set; }
        public int WeekNo { get; set; }
        public int WorkGroupId { get; set; }
        public int EngUserAreaId { get; set; }

        public List<EngPpmPrintlist> Englist { get; set; }

    }

}
