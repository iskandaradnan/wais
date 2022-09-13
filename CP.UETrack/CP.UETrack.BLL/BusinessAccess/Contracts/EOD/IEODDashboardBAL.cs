using CP.UETrack.Model;

namespace CP.UETrack.BLL.BusinessAccess.Interface
{
    public interface IEODDashboardBAL
    {
        EODDashboardViewModel Load(int Year, int Month);
        EODDashboardViewModel getChartData(int NoofMonths, int FacilityId);

    }
}
