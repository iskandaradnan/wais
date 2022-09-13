using CP.Framework.Common.ExceptionHandler.ExceptionWrappers;
using CP.Framework.Common.Logging;
using CP.UETrack.BLL.BusinessAccess.Contracts.BEMS;
using CP.UETrack.DAL.DataAccess.Contracts.BEMS;
using CP.UETrack.Model;
using CP.UETrack.Model.BEMS;
using System;

namespace CP.UETrack.BLL.BusinessAccess.Implementations.BEMS
{
    public class FacilityBAL : IFacilityBAL
    {
        private readonly IFacilityDAL _facilityDAL;

        private readonly static string fileName = nameof(CustomerBAL);

        #region Ctor/init
        public FacilityBAL(IFacilityDAL facilityDAL)
        {
            _facilityDAL = facilityDAL;

        }
        #endregion

        #region Business Access Methods
        public GridFilterResult GetAll(SortPaginateFilter pageFilter)
        {
            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(GetAll), Level.Info.ToString());
                var result = _facilityDAL.GetAll(pageFilter);
                Log4NetLogger.LogExit(fileName, nameof(GetAll), Level.Info.ToString());
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

        public FacilityLovs Load()
        {
            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(Load), Level.Info.ToString());
                var result = _facilityDAL.Load();
                Log4NetLogger.LogExit(fileName, nameof(Load), Level.Info.ToString());
                return result;

            }
            catch (BALException bx)
            {
                throw new BALException(bx);
            }
            catch (Exception ex)
            {
                throw new BALException(ex);
            }
        }
        public MstLocationFacilityViewModel Get(int facilityId)
        {
            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(Get), Level.Info.ToString());
                var result = _facilityDAL.Get(facilityId);
                Log4NetLogger.LogExit(fileName, nameof(Get), Level.Info.ToString());
                return result;

            }
            catch (BALException bx)
            {
                throw new BALException(bx);
            }
            catch (Exception ex)
            {
                throw new BALException(ex);
            }
        }
        public void Delete(int facilityId, out string ErrorMessage)
        {
            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(Get), Level.Info.ToString());
                _facilityDAL.Delete(facilityId, out ErrorMessage);
                Log4NetLogger.LogExit(fileName, nameof(Get), Level.Info.ToString());

            }
            catch (BALException bx)
            {
                throw new BALException(bx);
            }
            catch (Exception ex)
            {
                throw new BALException(ex);
            }
        }
        public MstLocationFacilityViewModel Save(MstLocationFacilityViewModel facility, out string ErrorMessage)
        {
            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(Save), Level.Info.ToString());
                ErrorMessage = string.Empty;
                MstLocationFacilityViewModel result = null;

                if (IsValid(facility, out ErrorMessage))
                {
                    result = _facilityDAL.Save(facility);
                }

                Log4NetLogger.LogExit(fileName, nameof(Save), Level.Info.ToString());
                return result;
            }
            catch (BALException balException)
            {
                throw new BALException(balException);
            }

            catch (Exception ex)
            {
                throw new BALException(ex);
            }
        }

        private bool IsValid(MstLocationFacilityViewModel facility, out string ErrorMessage)
        {
            ErrorMessage = string.Empty;
            var isValid = false;
            if (string.IsNullOrEmpty(facility.FacilityName) || string.IsNullOrEmpty(facility.Address)
                || facility.Latitude == 0 || facility.Longitude == 0 || facility.ActiveFrom == null)
            {
                ErrorMessage = "Some fields are incorrect or have not been filled in. Please correct this to proceed.";
            }
            else if (_facilityDAL.IsFacilityCodeDuplicate(facility))
            {
                ErrorMessage = "Facility Code should be unique"; // active date cannot be future date 
            }
            else if (!validateActiveToDate(facility))
            {
                ErrorMessage = "1"; // active date cannot be future date 
            }
            else if (_facilityDAL.IsRecordModified(facility))
            {
                ErrorMessage = "Record Modified. Please Re-Select";
            }
            else
            {
                isValid = true;
            }
            return isValid;
        }
        public static bool validateActiveToDate(MstLocationFacilityViewModel model)
        {
            var CurrentDate = DateTime.Now;
            var date = CurrentDate.Date;
            return (model.ActiveFrom > date) ? false : true;
        }

        public FacilityVariation AddVariation(FacilityVariation obj)
        {
            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(Save), Level.Info.ToString());
                var result = _facilityDAL.AddVariation(obj);
                Log4NetLogger.LogExit(fileName, nameof(Save), Level.Info.ToString());
                return result;
            }
            catch (BALException balException)
            {
                throw new BALException(balException);
            }

            catch (Exception ex)
            {
                throw new BALException(ex);
            }
        }
        #endregion
    }
}
