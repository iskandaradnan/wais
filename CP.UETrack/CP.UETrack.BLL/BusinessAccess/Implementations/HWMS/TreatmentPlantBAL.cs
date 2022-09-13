using FluentValidation;
using FluentValidation.Internal;
using CP.UETrack.CLS.BusinessAccess.Interface;
using CP.UETrack.DAL.DataAccess.Contracts.HWMS;
using CP.UETrack.Model.HWMS;
using CP.UETrack.Model;
using System;
using CP.Framework.Common.Logging;
using CP.Framework.Common.ExceptionHandler.ExceptionWrappers;
using CP.UETrack.Models;
using System.Collections.Generic;
using CP.UETrack.BLL.BusinessAccess.Contracts.HWMS;

namespace CP.UETrack.BLL.BusinessAccess.Implementations.HWMS
{
    public class TreatmentPlantBAL:ITreatmentPlantBAL
    {
        private string _FileName = nameof(BlockBAL);
        ITreatmentPlantDAL _treatmentPlantDAL;
        public TreatmentPlantBAL(ITreatmentPlantDAL treatmentPlantDAL)
        {
            _treatmentPlantDAL = treatmentPlantDAL;
        }
        public TreatmetPlantDropdown Load()
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
                var result = _treatmentPlantDAL.Load();
                Log4NetLogger.LogExit(_FileName, nameof(Load), Level.Info.ToString());
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

        public TreatmetPlant Save(TreatmetPlant Plant, out string ErrorMessage)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());

                ErrorMessage = string.Empty;
                TreatmetPlant result = null;


                result = _treatmentPlantDAL.Save(Plant, out ErrorMessage);


                Log4NetLogger.LogExit(_FileName, nameof(Save), Level.Info.ToString());
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


        public GridFilterResult GetAll(SortPaginateFilter pageFilter)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(GetAll), Level.Info.ToString());
                var result = _treatmentPlantDAL.GetAll(pageFilter);
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
        public List<VehicleDetail> VehicleDetailsFetch(int TreatmentPlantId)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(VehicleDetailsFetch), Level.Info.ToString());
                var result = _treatmentPlantDAL.VehicleDetailsFetch(TreatmentPlantId);
                Log4NetLogger.LogExit(_FileName, nameof(VehicleDetailsFetch), Level.Info.ToString());
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
        public List<DriverDetail> DriverDetailsFetch(int TreatmentPlantId)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(DriverDetailsFetch), Level.Info.ToString());
                var result = _treatmentPlantDAL.DriverDetailsFetch(TreatmentPlantId);
                Log4NetLogger.LogExit(_FileName, nameof(DriverDetailsFetch), Level.Info.ToString());
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
        public TreatmetPlant Get(int Id)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
                var result = _treatmentPlantDAL.Get(Id);
                Log4NetLogger.LogExit(_FileName, nameof(Get), Level.Info.ToString());
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
        public List<TreatmetPlantLicenseDetails> LicenseCodeFetch(TreatmetPlantLicenseDetails SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(LicenseCodeFetch), Level.Info.ToString());
                var result = _treatmentPlantDAL.LicenseCodeFetch(SearchObject);
                Log4NetLogger.LogExit(_FileName, nameof(LicenseCodeFetch), Level.Info.ToString());
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
