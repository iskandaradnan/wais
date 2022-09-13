using CP.Framework.Common.ExceptionHandler.ExceptionWrappers;
using CP.Framework.Common.Logging;
using CP.UETrack.BLL.BusinessAccess.Contracts.BEMS;
using CP.UETrack.DAL.DataAccess.Contracts.BEMS;
using CP.UETrack.Model;
using CP.UETrack.Model.BEMS;
using System;

namespace CP.UETrack.BLL.BusinessAccess.Implementations.BEMS
{
    public  class ContractorandVendorBAL : IContractorandVendorBAL
    {
        #region Ctor/init
        private readonly IContractorandVendorDAL _contractorandVendorDAL;
        private readonly static string fileName = nameof(ContractorandVendorBAL);
        public ContractorandVendorBAL(IContractorandVendorDAL ContractorandVendorDAL)
        {
            _contractorandVendorDAL = ContractorandVendorDAL;

        }
        #endregion
        public GridFilterResult GetAll(SortPaginateFilter pageFilter)
        {
            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(GetAll), Level.Info.ToString());
                var result = _contractorandVendorDAL.GetAll(pageFilter);
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
        public ContractorandVendorLovs Load()
        {
            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(Load), Level.Info.ToString());
                var result = _contractorandVendorDAL.Load();
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
        //public ContractorandVendorLovs LoadCountry()
        //{
        //    try
        //    {
        //        Log4NetLogger.LogEntry(fileName, nameof(LoadCountry), Level.Info.ToString());
        //        var result = _contractorandVendorDAL.LoadCountry();
        //        Log4NetLogger.LogExit(fileName, nameof(LoadCountry), Level.Info.ToString());
        //        return result;

        //    }
        //    catch (BALException bx)
        //    {
        //        throw new BALException(bx);
        //    }
        //    catch (Exception ex)
        //    {
        //        throw new BALException(ex);
        //    }
        //}
        
        public MstContractorandVendorViewModel Get(int ContractorId)
        {
            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(Get), Level.Info.ToString());
                var result = _contractorandVendorDAL.Get(ContractorId);
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

        public MstContractorandVendorViewModel SaveUpdate(MstContractorandVendorViewModel obj, out string ErrorMessage)
        {
            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(SaveUpdate), Level.Info.ToString());
                ErrorMessage = string.Empty;
                MstContractorandVendorViewModel result = null;

                if (IsValid(obj, out ErrorMessage))
                {
                    result = _contractorandVendorDAL.SaveUpdate(obj);
                }               
                Log4NetLogger.LogExit(fileName, nameof(SaveUpdate), Level.Info.ToString());
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

        public void Delete(int ContractorId, out string ErrorMessage)
        {
            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(Get), Level.Info.ToString());
                _contractorandVendorDAL.Delete(ContractorId, out  ErrorMessage);
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
        private bool IsValid(MstContractorandVendorViewModel model, out string ErrorMessage)
        {
            ErrorMessage = string.Empty;
            var isValid = false;
            if (string.IsNullOrEmpty(model.SSMRegistrationCode) || string.IsNullOrEmpty(model.ContractorName) || string.IsNullOrEmpty(model.Address)
               )
            {
                ErrorMessage = "Some fields are incorrect or have not been filled in. Please correct this to proceed.";
            }
            else if (_contractorandVendorDAL.IsContractorRegCodeDuplicate(model))
            {
                ErrorMessage = "Contractor / Vendor Registration Number should be unique";
            }
            else if (_contractorandVendorDAL.IsRecordModified(model))
            {
                ErrorMessage = "Record Modified. Please Re-Select";
            }
            else
            {
                isValid = true;
            }
            return isValid;
        }
    }

}
