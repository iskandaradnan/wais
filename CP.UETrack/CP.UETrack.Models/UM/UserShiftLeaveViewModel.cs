using CP.UETrack.Models;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CP.UETrack.Model.UM
{
 public class UserShiftLeaveViewModel
    {
        public int CustomerId { get; set; }
        public int FacilityId { get; set; }
        public int UserShiftsId { get; set; }
        public int UserRegistrationId { get; set; }
        public string StaffName { get; set; }
        public string MobileNumber { get; set; }
        public string AccessLevel { get; set; }
        public string Designation { get; set; }
        public string UserType { get; set; }
        public int LunchTimeLovId { get; set; }
        public int? ShiftTime { get; set; }
        public DateTime LeaveFrom { get; set; }
        public DateTime LeaveTo { get; set; }
        public string Role { get; set; }
        public string Remarks { get; set; }
        public string Timestamp { get; set; }
        public string UserName { get; set; }
       public string ShiftStartTime { get; set; }
        public string ShiftStartTimeMin { get; set; }
        public string ShiftEndTime { get; set; }
        public string ShiftEndTimeMin { get; set; }
        public string ShiftBreakStartTime { get; set; }
        public string ShiftBreakStartTimeMin { get; set; }
        public string ShiftBreakEndTime { get; set; }
        public string ShiftBreakEndTimeMin { get; set; }
        public List<UserShiftLeaveGrid> UserShiftLeaveGridData { get; set; }
    }
    public class UserShiftLeaveGrid
    {
        public int UserShiftDetId { get; set; }
        public DateTime LeaveFromGrid { get; set; }
        public DateTime LeaveToGrid { get; set; }
        public Decimal NoOfDays { get; set; }
        public string Remarks { get; set; }

        public bool IsDeleted { get; set; }
    }

    public class UserShiftLeaveDropdownValues
    {
        public List<LovValue> ShiftLunchTime { get; set; }
        public List<LovValue> ShiftTime { get; set; }
        public int UserworkShiftTime { get; set; }

    }
}
