using CP.UETrack.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CP.UETrack.Model.BEMS.UserTraining
{
    public class UserTrainingCompletion
    {
        public string Status { get; set; }
        public int TrainingScheduleId { get; set; }
        public string HiddenId { get; set; }
        public int CustomerId { get; set; }
        public int FacilityId { get; set; }
        public string Facility { get; set; }
        public int ServiceId { get; set; }
        public string Service { get; set; }
        public string TrainingScheduleNo { get; set; }
        public int? TrainingTypeId { get; set; }
        public string TrainingType { get; set; }
        public string TrainingDescription { get; set; }
        public DateTime? PlannedDate { get; set; }
        public DateTime? PlannedDateUTC { get; set; }
        public int? Quarter { get; set; }
        public int? Year { get; set; }
        public string Trainingmodule { get; set; }
        public int? MinNoOfParticipants { get; set; }
        public DateTime? ActualDate { get; set; }
        public DateTime? ActualDateUTC { get; set; }
        public int? TrainingStatusId { get; set; }
        public string TrainingStatus { get; set; }

        public int? TrainerSource { get; set; }
        public int? TrainerPresenter { get; set; }
        public string TrainerPresenterName { get; set; }
        public int? Experience { get; set; }
        public string Designation { get; set; }
        public int? TotalParticipants { get; set; }
        public string venue { get; set; }
        public DateTime? TrainingRescheduleDate { get; set; }
        public DateTime? TrainingRescheduleDateUTC { get; set; }
        public decimal? OverallEffectiveness { get; set; }
        public string Remarks { get; set; }
        public string QuarterVal { get; set; }
        public string Timestamp { get; set; }
        public List<UserTrainingGrid> UserTrainingGridData { get; set; }
        public List<UserTrainingAreaGrid> UserTrainingAreaGridData { get; set; }
        public bool IsConfirmed { get; set; }
        public bool IsRescheduled { get; set; }
        public string Email { get; set; }
        public DateTime? NotificationDate { get; set; }
        public bool IsPlanedOver { get; set; }
        public DateTime? CurrentDate { get; set; }

        public string AllEmail { get; set; }
        public int NotificationId { get; set; }
        public int? TemplateId { get; set; }
        public string MultipleNotiIds { get; set; }
        public int TypeOfServiceRequest { get; set; }

    }

    public class UserTrainingGrid
    {
        public int? TrainingScheduleDetId { get; set; }
        public int? TrainingScheduleId { get; set; }
        public int CustomerId { get; set; }
        public int FacilityId { get; set; }
        public int ServiceId { get; set; }
        public int? ParticipantId { get; set; }
        public string ParticipantName { get; set; }
        public string Designation { get; set; }
        public int? UserAreaId { get; set; }
        public string UserAreaCode { get; set; }
        public string UserAreaName { get; set; }
        public int? PageIndex { get; set; }
        public int PageSize { get; set; }
        public int? TotalRecords { get; set; }
        public int? TotalPages { get; set; }
        public int? FirstRecord { get; set; }
        public int? LastRecord { get; set; }
        public int LastPageIndex { get; set; }
        public string Timestamp { get; set; }
        public bool IsDeleted { get; set; }
        public string CompRepEmail { get; set; }
        public string FacRepEmail { get; set; }
        public bool IsConfirmed { get; set; }
    }

    public class UserTrainingAreaGrid
    {
        public int? TrainingScheduleAreaId { get; set; }
        public int? TrainingScheduleId { get; set; }
        public int CustomerId { get; set; }
        public int FacilityId { get; set; }
        public int ServiceId { get; set; }    
        public int? UserAreaId { get; set; }
        public string UserAreaCode { get; set; }
        public string UserAreaName { get; set; }
        public string Timestamp { get; set; }
        public bool IsDeleted { get; set; }
        public int? CompRepId { get; set; }
        public string CompRepName { get; set; }
        public string CompRepEmail { get; set; }
        public int? FacRepId { get; set; }
        public string FacRepName { get; set; }
        public string FacRepEmail { get; set; }
    }
    public class UserTrainingDropdown
    {
        public List<LovValue> ServiceLovs { get; set; }
        public List<LovValue> TrainingTypeLovs { get; set; }
        public List<LovValue> YearLovs { get; set; }
        public List<LovValue> QuarterLovs { get; set; }
        public List<LovValue> TrainingStsLovs { get; set; }
        public List<LovValue> TrainingSourceLovs { get; set; }
        public List<LovValue> FacilityLovs { get; set; }
        public List<LovValue> RequestServiceList { get; set; }
    }
}
