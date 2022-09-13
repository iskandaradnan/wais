using CP.Framework.Common.ExceptionHandler.ExceptionWrappers;
using CP.Framework.Common.Logging;
using CP.UETrack.BLL.BusinessAccess.Interface;
using CP.UETrack.DAL.DataAccess.Contracts.LLS;
using CP.UETrack.Model.LLS;
using CP.UETrack.DAL.DataAccess;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using CP.UETrack.Model;
using CP.UETrack.BLL.BusinessAccess.Contracts.LLS.Master;

namespace CP.UETrack.BLL.BusinessAccess.Implementations.LLS.Master
{
   public class LicenseTypeBAL: ILicenseTypeBAL
    {
        private string _FileName = nameof(LicenseTypeBAL);
        ILicenseTypeDAL _LicenseTypeDAL;
        public LicenseTypeBAL(ILicenseTypeDAL LicenseTypeDAL)
        {
            _LicenseTypeDAL = LicenseTypeDAL;
        }
        public LicenseTypeModelLovs Load()
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
                var result = _LicenseTypeDAL.Load();
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
        public LicenseTypeModel Save(LicenseTypeModel model, out string ErrorMessage)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());

                ErrorMessage = string.Empty;
                LicenseTypeModel result = null;

                if (IsValid(model, out ErrorMessage))
                {
                    result = _LicenseTypeDAL.Save(model, out ErrorMessage);
                }

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
        private bool IsValid(LicenseTypeModel model, out string ErrorMessage)
        {
            ErrorMessage = string.Empty;
            var isValid = false;
            List<LicenseTypeModelList> LicenseTypeModelListData = new List<LicenseTypeModelList>();
                LicenseTypeModelListData.AddRange(model.LicenseTypeModelListData);
            foreach (var jjj in LicenseTypeModelListData)
            {
                if (string.IsNullOrEmpty(jjj.LicenseCode))
                {
                    ErrorMessage = "Some fields are incorrect or have not been filled in. Please correct this to proceed.";
                }
                else if (model.LicenseTypeId == 0)
                {
                    if (_LicenseTypeDAL.IsLicenseTypeDuplicate(model))
                        ErrorMessage = "License Code should be unique";
                    else
                        isValid = true;
                }

                //else if (_modelDAL.IsRecordModified(model))
                //{
                //    ErrorMessage = "Record Modified. Please Re-Select";
                //}
                else
                {
                    isValid = true;
                }
            }
            return isValid;
        }
        public LicenseTypeModel Get(int Id)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
                var result = _LicenseTypeDAL.Get(Id);
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
        public GridFilterResult GetAll(SortPaginateFilter pageFilter)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(GetAll), Level.Info.ToString());
                var result = _LicenseTypeDAL.GetAll(pageFilter);
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
        public void Delete(int Id, out string ErrorMessage)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Delete), Level.Info.ToString());
                _LicenseTypeDAL.Delete(Id, out ErrorMessage);
                Log4NetLogger.LogExit(_FileName, nameof(Delete), Level.Info.ToString());
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
