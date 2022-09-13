using CP.UETrack.Model;
using CP.UETrack.Models;
using System;
using System.Collections.Generic;
namespace CP.UETrack.DAL.DataAccess
{
    public interface IEODDashboardDAL
    {
        EODDashboardViewModel Load(int Year, int Month);
        EODDashboardViewModel getChartData(int NoofMonths, int FacilityId);
    }
}


