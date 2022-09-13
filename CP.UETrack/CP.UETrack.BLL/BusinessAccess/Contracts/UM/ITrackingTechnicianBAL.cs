using CP.UETrack.Model;
using CP.UETrack.Model.UM;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CP.UETrack.BLL.BusinessAccess.Contracts.UM
{
    public interface ITrackingTechnicianBAL
    {
        List<UMTrackingTechnician> GetAll(string starDate, string endDate, string customerid, string facilityid, int staffid);
        List<UMTrackingFacility> GetFacility();
        List<UMTrackingTechnicianView> GetEngineerByid(int Engineerid, string starDate, string endDate);
    }
}
