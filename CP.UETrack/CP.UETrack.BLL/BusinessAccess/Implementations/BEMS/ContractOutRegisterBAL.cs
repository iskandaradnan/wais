using CP.Framework.Common.ExceptionHandler.ExceptionWrappers;
using CP.Framework.Common.Logging;
using CP.UETrack.BLL.BusinessAccess.Contracts.BEMS;
using CP.UETrack.DAL.DataAccess;
using CP.UETrack.DAL.DataAccess.Contracts.BEMS;
using CP.UETrack.Model;
using CP.UETrack.Model.BEMS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CP.UETrack.BLL.BusinessAccess.Implementations.BEMS
{
    class ContractOutRegisterBAL : IContractOutRegisterBAL
    {

        private readonly IContractOutRegisterDAL _IContractOutRegisterDAL;
       // private readonly IAssetRegisterDAL _IAssetRegisterDAL;
        private readonly static string fileName = nameof(ContractOutRegisterBAL);
        public ContractOutRegisterBAL(IContractOutRegisterDAL IContractOutRegisterDAL /*, IAssetRegisterDAL IAssetRegisterDAL*/)
        {
            _IContractOutRegisterDAL = IContractOutRegisterDAL;
            //_IAssetRegisterDAL=IAssetRegisterDAL;

        }

        public CORDropdownList Load()

        {
            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(Load), Level.Info.ToString());

                Log4NetLogger.LogExit(fileName, nameof(Load), Level.Info.ToString());
                return _IContractOutRegisterDAL.Load();
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

        public void save(ref ContractOutRegisterEntity entity,out string ErrorMessage)
        {
            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(save), Level.Info.ToString());

                if (IsValid(entity, out ErrorMessage))
                {
                    _IContractOutRegisterDAL.save(ref entity, out ErrorMessage);
                }
                
                Log4NetLogger.LogExit(fileName, nameof(save), Level.Info.ToString());
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
        public void update(ref ContractOutRegisterEntity entity, out string ErrorMessage)
        {
            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(update), Level.Info.ToString());

                if (IsValid(entity, out ErrorMessage))
                {
                    _IContractOutRegisterDAL.update(ref entity, out ErrorMessage);
                }
                Log4NetLogger.LogExit(fileName, nameof(update), Level.Info.ToString());
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
        public ContractOutRegisterEntity Get(int id, int pagesize, int pageindex)
        {
            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(Get), Level.Info.ToString());

                Log4NetLogger.LogExit(fileName, nameof(Get), Level.Info.ToString());
                return _IContractOutRegisterDAL.Get(id, pagesize, pageindex);
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
        public bool Delete(int id)
        {
            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(Delete), Level.Info.ToString());

                Log4NetLogger.LogExit(fileName, nameof(Delete), Level.Info.ToString());
                return _IContractOutRegisterDAL.Delete(id);
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
        public GridFilterResult Getall(SortPaginateFilter pageFilter)
        {
            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(Getall), Level.Info.ToString());

                Log4NetLogger.LogExit(fileName, nameof(Getall), Level.Info.ToString());
                return _IContractOutRegisterDAL.Getall(pageFilter);
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

        private bool IsValid(ContractOutRegisterEntity entity, out string ErrorMessage)
        {
            ErrorMessage = string.Empty;
            var isValid = false;

            if (entity.endDate <= entity.startDate)
            {
                ErrorMessage = "Contract End Date should be greater than Contract Start Date";
            }
            else
            {
                isValid = true;
            }
            return isValid;
        }

        public ContractOutRegisterEntity GetPopupDetails(int primaryId, int ContractHisId)
        {
            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(GetPopupDetails), Level.Info.ToString());
                var result = _IContractOutRegisterDAL.GetPopupDetails(primaryId, ContractHisId);

                Log4NetLogger.LogExit(fileName, nameof(GetPopupDetails), Level.Info.ToString());
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
    }
}
