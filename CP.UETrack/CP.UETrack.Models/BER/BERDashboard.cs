using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CP.UETrack.Model.BER
{
    public class BERDashboard
    {
        public int CustomerId { get; set; }
        public int FacilityId { get; set; }
        public int ServiceId { get; set; }
        public int BerStatusId { get; set; }
        public string BerStatus { get; set; }
        public string FacilityManager { get; set; }
        public string HospDir { get; set; }
        public string LiasonOff { get; set; }
        public string FacilityManagerSts { get; set; }
        public string HospDirSts { get; set; }
        public string LiasonOffSts { get; set; }
        public int FacMAnCount { get; set; }
        public int HosDirCount { get; set; }
        public int LiaOffCount { get; set; }
        public List<BERDashboardGrid> BERDashboardGridData { get; set; }
        public List<BERDAshboardPending> BERDAshboardPendingData { get; set; }
    }

    public class BERDashboardGrid
    {
        public int CustomerId { get; set; }
        public int FacilityId { get; set; }
        public int ServiceId { get; set; }
        public int BerId { get; set; }
        public string BerNo { get; set; }
        public int BerStatusId { get; set; }
        public string BerStatus { get; set; }
        public DateTime RenewalDate { get; set; }
        public int Count { get; set; }
        public int PageIndex { get; set; }
        public int PageSize { get; set; }
        public int TotalRecords { get; set; }
        public int TotalPages { get; set; }
        public int FirstRecord { get; set; }
        public int LastRecord { get; set; }
        public int LastPageIndex { get; set; }

    }

    public class BERDAshboardPending
    {
        public int FacilityId { get; set; }
        public int BerStatusId { get; set; }
        public string BerStatus { get; set; }
        public int Count { get; set; }
    }
}
