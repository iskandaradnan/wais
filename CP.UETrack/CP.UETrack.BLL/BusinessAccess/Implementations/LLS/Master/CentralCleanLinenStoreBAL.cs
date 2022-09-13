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
    public class CentralCleanLinenStoreBAL :ICentralCleanLinenStoreBAL
    {
        private string _FileName = nameof(CentralCleanLinenStoreBAL);
        ICentralCleanLinenStoreDAL _CentralCleanLinenStoreDAL;
        public CentralCleanLinenStoreBAL(ICentralCleanLinenStoreDAL CentralCleanLinenStoreDAL)
        {
            _CentralCleanLinenStoreDAL = CentralCleanLinenStoreDAL;
        }
        public CentralCleanLinenStoreModelLovs Load()
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
                var result = _CentralCleanLinenStoreDAL.Load();
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
        public CentralCleanLinenStoreModel Save(CentralCleanLinenStoreModel model, out string ErrorMessage)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());

                ErrorMessage = string.Empty;
                CentralCleanLinenStoreModel result = null;
                if (IsValid(model, out ErrorMessage))
                {
                    result = _CentralCleanLinenStoreDAL.Save(model, out ErrorMessage);
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
        private bool IsValid(CentralCleanLinenStoreModel model, out string ErrorMessage)
        {
            ErrorMessage = string.Empty;
            var isValid = false;

            if (string.IsNullOrEmpty(model.StoreType))
            {
                ErrorMessage = "Some fields are incorrect or have not been filled in. Please correct this to proceed.";
            }
            else if (model.CCLSId == 0)
            {
                if (_CentralCleanLinenStoreDAL.IsCentralCleanLinenStoreDuplicate(model))
                    ErrorMessage = "Block Code should be unique";
                else
                    isValid = true;
            }
            //else if (_BlockDAL.IsRecordModified(block))
            //{
            //    ErrorMessage = "Record Modified. Please Re-Select";
            //}
            else
            {
                isValid = true;
            }
            return isValid;
        }
        public CentralCleanLinenStoreModel Get(int Id)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
                var result = _CentralCleanLinenStoreDAL.Get(Id);
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
                var result = _CentralCleanLinenStoreDAL.GetAll(pageFilter);
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
                _CentralCleanLinenStoreDAL.Delete(Id, out ErrorMessage);
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


