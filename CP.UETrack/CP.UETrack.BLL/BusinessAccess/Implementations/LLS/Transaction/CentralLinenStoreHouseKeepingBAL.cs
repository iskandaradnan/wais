using CP.Framework.Common.ExceptionHandler.ExceptionWrappers;
using CP.Framework.Common.Logging;
using CP.UETrack.BLL.BusinessAccess.Contracts.LLS.Transaction;
using CP.UETrack.DAL.DataAccess.Contracts.LLS;
using CP.UETrack.Model;
using CP.UETrack.Model.LLS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CP.UETrack.BLL.BusinessAccess.Implementations.LLS.Transaction
{
    public class CentralLinenStoreHouseKeepingBAL : ICentralLinenStoreHouseKeepingBAL
    {
        private string _FileName = nameof(CentralLinenStoreHouseKeepingBAL);
        ICentralLinenStoreHKeepingDAL _CentralLinenStoreHKeepingDAL;
        public CentralLinenStoreHouseKeepingBAL(ICentralLinenStoreHKeepingDAL CentralLinenStoreHKeepingDAL)
        {
            _CentralLinenStoreHKeepingDAL = CentralLinenStoreHKeepingDAL;
        }
        public CentralLinenStoreHousekeepingModelLovs Load()
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
                var result = _CentralLinenStoreHKeepingDAL.Load();
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
        public CentralLinenStoreHousekeepingModel Save(CentralLinenStoreHousekeepingModel model, out string ErrorMessage)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());

                ErrorMessage = string.Empty;
                CentralLinenStoreHousekeepingModel result = null;

                if (IsValid(model, out ErrorMessage))
                {
                    result = _CentralLinenStoreHKeepingDAL.Save(model, out ErrorMessage);
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
        public CentralLinenStoreHousekeepingModel HKeeping(int StoreType, int Year, int Month,  int pagesize, int pageindex)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
                var result = _CentralLinenStoreHKeepingDAL.HKeeping(StoreType, Year, Month,  pagesize, pageindex);
                Log4NetLogger.LogExit(_FileName, nameof(Get), Level.Info.ToString());
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
        private bool IsValid(CentralLinenStoreHousekeepingModel model, out string ErrorMessage)
        {
            ErrorMessage = string.Empty;
            var isValid = false;

            if (string.IsNullOrEmpty(model.StoreType) || string.IsNullOrEmpty(model.Year) || string.IsNullOrEmpty(model.Month) )
            {
                ErrorMessage = "Some fields are incorrect or have not been filled in. Please correct this to proceed.";
            }
            else if (model.HouseKeepingDetId == 0)
            {
                if (_CentralLinenStoreHKeepingDAL.IsCentralLinenStoreHKeepingDuplicate(model))
                    ErrorMessage = "This Record is Already Existed";
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
        public CentralLinenStoreHousekeepingModel Get(int Id)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
                var result = _CentralLinenStoreHKeepingDAL.Get(Id);
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
                var result = _CentralLinenStoreHKeepingDAL.GetAll(pageFilter);
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
                _CentralLinenStoreHKeepingDAL.Delete(Id, out ErrorMessage);
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


