using CP.UETrack.Model.Home;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CP.UETrack.DAL.DataAccess.Contracts.Home
{
    public interface IDashboardDAL
    {
        permission DashboardPermission(int UserId, int FacilityId);
        BMWorkorder LoadWorkorderChart(int StartYear, int StartMonth, int EndYear, int EndMonth, int FacilityId, int UserId);
        PPMWorkorder LoadPPMWorkOrderChart(int StartYear, int StartMonth, int EndYear, int EndMonth, int FacilityId, int UserId);
        HomeDashboard LoadMaintCostChart(int StartYear, int StartMonth, int EndYear, int EndMonth, int FacilityId);
        KPIChart LoadKPIChart(int StartYear, int StartMonth, int EndYear, int EndMonth, int FacilityId, int UserId);
        HomeDashboard LoadEquipUptimeChart(int StartYear, int StartMonth, int EndYear, int EndMonth, int FacilityId);
        Deduction LoadDeductionChart(int StartYear, int StartMonth, int EndYear, int EndMonth, int FacilityId, int UserId);
        AssetCategory LoadAssetCategoryChart(int StartYear, int StartMonth, int EndYear, int EndMonth, int FacilityId, int UserId);
        AssetWarranty LoadAssetWarrantyChart(int StartYear, int StartMonth, int EndYear, int EndMonth, int FacilityId, int UserId);
        KPITarget LoadKPITargetChart(int StartYear, int StartMonth, int EndYear, int EndMonth, int FacilityId, int UserId);
        ExpiryAlert LoadExpiryAlertChart(int StartYear, int StartMonth, int EndYear, int EndMonth, int FacilityId, int UserId);
        BERAsset LoadBERAssetChart(int StartYear, int StartMonth, int EndYear, int EndMonth, int FacilityId, int UserId);
        HomeDashboard LoadContChart(int StartYear, int StartMonth, int EndYear, int EndMonth, int FacilityId);
    }
}
