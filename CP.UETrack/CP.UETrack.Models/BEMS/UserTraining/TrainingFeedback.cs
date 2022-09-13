using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CP.UETrack.Model.BEMS.UserTraining
{
    public class TrainingFeedback
    {
        public int TrainingFeedbackId { get; set; }
        public int TrainingScheduleId { get; set; } 
        public int CustomerId { get; set; }
        public int FacilityId { get; set; }
        public int Facility { get; set; }
        public int ServiceId { get; set; }
        
        public int Curriculum1 { get; set; }
        public int Curriculum2 { get; set; }
        public int Curriculum3 { get; set; }
        public int Curriculum4 { get; set; }
        public int Curriculum5 { get; set; }
        public int CourseIntructors1 { get; set; }
        public int CourseIntructors2 { get; set; }
        public int CourseIntructors3 { get; set; }
        public int TrainingDelivery1 { get; set; }
        public int TrainingDelivery2 { get; set; }
        public int TrainingDelivery3 { get; set; }
        public string Recommendation { get; set; }
        public string Timestamp { get; set; }
    }
}
