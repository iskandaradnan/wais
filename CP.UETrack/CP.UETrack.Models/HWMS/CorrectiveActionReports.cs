using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Web;
using CP.UETrack.Model.FetchModels;
using CP.UETrack.Models;

namespace CP.UETrack.Model.HWMS
{
    public class CorrectiveActionReports: FetchPagination
    {
        public int CustomerId { get; set; }
        public int FacilityId { get; set; }
        public int CARId { get; set; }
        public string CARGeneration { get; set; }
        public string CARNo { get; set; }
        public string Indicator { get; set; }
        public DateTime CARDate { get; set; }
        public DateTime? CARPeriodFrom { get; set; }
        public DateTime? CARPeriodTo { get; set; }
        public string FollowUpCAR { get; set; }
        public string Assignee { get; set; }
        public string ProblemStatement { get; set; }
        public string RootCause { get; set; }
        public string Solution { get; set; }
        public string Priority { get; set; }
        public string Status { get; set; }
        public string Issuer { get; set; }
        public DateTime? CARTargetDate { get; set; }
        public DateTime? VerifiedDate { get; set; }
        public string VerifiedBy { get; set; }
        public string Remarks { get; set; }
        public List<CARActivity> CARActivityList { get; set; }
        public List<CARHistoryDetail> CARHistoryDetailsList { get; set; }
        public List<CARAttachment> CARAttachmentList { get; set; }
        public List<CorrectiveActionReports> AutoDisplay { get; set; }
        public List<CorrectiveActionReports> AutoIdentityCarModelList { get; set; }
        public List<CorrectiveActionReports> CARNoFetch { get; set; }
    }
    public class CARActivity
    {
        public int CARActivityId { get; set; }
        public string Activity { get; set; }
        public DateTime StartDate { get; set; }
        public DateTime TargetDate { get; set; }
        public DateTime? ActualCompletionDate { get; set; }
        public string Responsibility { get; set; }
        public string ResponsiblePerson { get; set; }
        public bool isDeleted { get; set; }
    }   
    public class CARHistoryDetail
    {
        public string RootCause { get; set; }
        public string Solution { get; set; }
        public string StatusValue { get; set; }
        public string Remarks { get; set; }
    }
    public class CARAttachment
    {
        public int AttachmentId { get; set; }
        public int CARId { get; set; }
        public string FileType { get; set; }
        public string FileName { get; set; }
        [Required(ErrorMessage = "Please choose file to upload.")]
        public string AttachmentName { get; set; }
        public string FilePath { get; set; }
        public bool isDeleted { get; set; }

    }
}
