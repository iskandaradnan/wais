using CP.Framework.Common.ExceptionHandler.ExceptionWrappers;
using CP.Framework.Common.Logging;
using CP.UETrack.BLL.BusinessAccess.Contracts.UM;
using CP.UETrack.DAL.DataAccess.Contracts.UM;
using CP.UETrack.Model;
using CP.UETrack.Model.UM;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CP.UETrack.BLL.BusinessAccess.Implementations.UM
{
    public class TrackingTechnicianBAL: ITrackingTechnicianBAL
    {
        private string _FileName = nameof(TrackingTechnicianBAL);
        ITrackingTechnicianDAL _trackingTechnicianDAL;
        public TrackingTechnicianBAL(ITrackingTechnicianDAL trackingTechnicianDAL)
        {
            _trackingTechnicianDAL = trackingTechnicianDAL;
        }

        public List<UMTrackingTechnician> GetAll(string starDate, string endDate, string customerid, string facilityid, int staffid)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(GetAll), Level.Info.ToString());
                var result = _trackingTechnicianDAL.GetAll(starDate, endDate, customerid, facilityid, staffid);
                Log4NetLogger.LogExit(_FileName, nameof(GetAll), Level.Info.ToString());
                return result;
            }
            catch (BALException balException)
            {
                throw new BALException(balException);
            }
            catch (Exception)
            {
                throw;
            }
        }
        public List<UMTrackingFacility> GetFacility()
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(GetAll), Level.Info.ToString());
                var result = _trackingTechnicianDAL.GetFacility();
                Log4NetLogger.LogExit(_FileName, nameof(GetAll), Level.Info.ToString());
                return result;
            }
            catch (BALException balException)
            {
                throw new BALException(balException);
            }
            catch (Exception)
            {
                throw;
            }
        }

        public List<UMTrackingTechnicianView> GetEngineerByid(int Engineerid, string starDate, string endDate)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(GetAll), Level.Info.ToString());
                var result = _trackingTechnicianDAL.GetEngineerByid(Engineerid, starDate, endDate);
                Log4NetLogger.LogExit(_FileName, nameof(GetAll), Level.Info.ToString());
                return result;
            }
            catch (BALException balException)
            {
                throw new BALException(balException);
            }
            catch (Exception)
            {
                throw;
            }
        }
    }
}
