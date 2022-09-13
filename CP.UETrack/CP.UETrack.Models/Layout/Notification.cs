using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CP.UETrack.Model.Layout
{
   public class Notification
    {
        //public int CustomerId { get; set; }
        //public int FacilityId { get; set; }
        //public int UserId { get; set; }
        //public DateTime Date { get; set; }
        //public string Remarks { get; set; }
        public int TotalCount { get; set; }
        public List<Notificationgrid> NotificationgridData { get; set; }
    }

    public class Notificationgrid
    {
        public int CustomerId { get; set; }
        public int FacilityId { get; set; }
        public int UserId { get; set; }
        public int NotificationId { get; set; }
        public DateTime NotificationDateTime { get; set; }
        public string Remarks { get; set; }
        public string NotificationAlerts { get; set; }
        public string URL { get; set; }
        public int TotalCount { get; set; }
        public bool IsNew { get; set; }
        public bool Isnavigated { get; set; }
        public string Module { get; set; }
        public int PageIndex { get; set; }
        public int TotalRecords { get; set; }
        public int FirstRecord { get; set; }
        public int LastRecord { get; set; }
        public int TotalPages { get; set; }
        public int LastPageIndex { get; set; }
    }
}
