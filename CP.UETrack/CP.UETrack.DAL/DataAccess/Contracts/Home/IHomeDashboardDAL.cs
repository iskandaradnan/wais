using CP.UETrack.Model.Home;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CP.UETrack.DAL.DataAccess.Contracts.Home
{
    public interface IHomeDashboardDAL
    {
        HomeDashboard LoadWorkorderChart(int StartYear, int StartMonth, int EndYear, int EndMonth, int FacilityId);
        HomeDashboard LoadMaintCostChart(int StartYear, int StartMonth, int EndYear, int EndMonth, int FacilityId);
        HomeDashboard LoadEquipUptimeChart(int StartYear, int StartMonth, int EndYear, int EndMonth, int FacilityId);
        HomeDashboard LoadAssetChart(int StartYear, int StartMonth, int EndYear, int EndMonth, int FacilityId);
        HomeDashboard LoadAssetAgeChart(int StartYear, int StartMonth, int EndYear, int EndMonth, int FacilityId);
        HomeDashboard LoadContChart(int StartYear, int StartMonth, int EndYear, int EndMonth, int FacilityId);
    }
}
