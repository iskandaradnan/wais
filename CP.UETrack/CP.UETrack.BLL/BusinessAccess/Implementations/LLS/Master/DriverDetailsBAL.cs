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
using CP.UETrack.BLL.BusinessAccess.Interface.LLS;
using CP.UETrack.BLL.BusinessAccess.Interface.LLS.Master;
using CP.UETrack.BLL.BusinessAccess.Contracts.LLS.Master;

namespace CP.UETrack.BLL.BusinessAccess.Implementations.LLS.Master
{
    public  class DriverDetailsBAL:IDriverDetailsBAL
    {
        private string _FileName = nameof(DriverDetailsBAL);
        IDriverDetailsDAL _DriverDetailsDAL;
        //private object fileName;

        public DriverDetailsBAL(IDriverDetailsDAL DriverDetailsDAL)
        {
            _DriverDetailsDAL = DriverDetailsDAL;
        }
        public DriverDetailsModelLovs Load()
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
                var result = _DriverDetailsDAL.Load();
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
        public DriverDetailsModel Save(DriverDetailsModel model, out string ErrorMessage)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());


                ErrorMessage = string.Empty;
                DriverDetailsModel result = null;

                if (IsValid(model, out ErrorMessage))
                {
                    result = _DriverDetailsDAL.Save(model, out ErrorMessage);
                }

                Log4NetLogger.LogExit(_FileName, nameof(Save), Level.Info.ToString());
                return result;
            }
            catch (BALException balException)
            {
                throw new BALException(balException);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        private bool IsValid(DriverDetailsModel model, out string ErrorMessage)
        {
            ErrorMessage = string.Empty;
            var isValid = false;
            if (model.DriverCode == " " || model.DriverCode == null)
            {
                var guid = Guid.NewGuid().ToString();
                model.DriverCode = guid;
            }
            if (string.IsNullOrEmpty(model.DriverCode))
            {
                ErrorMessage = "Some fields are incorrect or have not been filled in. Please correct this to proceed.";
            }
            else if (model.DriverId == 0)
            {
                if (_DriverDetailsDAL.IsDriverCodeDuplicate(model))
                    ErrorMessage = "Driver Code should be unique";
                else
                    isValid = true;
            }
            else
            {
                isValid = true;
            }
            return isValid;
        }

        public DriverDetailsModel Get(int Id)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
                var result = _DriverDetailsDAL.Get(Id);
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
                var result = _DriverDetailsDAL.GetAll(pageFilter);
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
                _DriverDetailsDAL.Delete(Id, out ErrorMessage);
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
