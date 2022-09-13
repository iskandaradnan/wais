using CP.Framework.Common.Logging;
using CP.UETrack.BLL.BusinessAccess.Contracts.Common;
using CP.UETrack.DAL.DataAccess.Contracts;
using CP.UETrack.Model;
using System;
using CP.Framework.Common.ExceptionHandler.ExceptionWrappers;
using System.Data;
using CP.UETrack.Model.BEMS;
using CP.UETrack.Model.GM;
using System.Collections.Generic;
using CP.UETrack.Model.VM;
using CP.UETrack.Model.BEMS.AssetRegister;

namespace CP.UETrack.BLL.BusinessAccess.Implementations.Common
{
    public class CommonBAL : ICommonBAL
    {
        private readonly ICommonDAL _commonDal;
        private readonly static string _FileName = nameof(CommonBAL);
        public CommonBAL(ICommonDAL dal)
        {
            _commonDal = dal;

        }
        public GridFilterResult GetAll(SortPaginateFilter pageFilter, string modelName)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(GetAll), Level.Info.ToString());
                var result = _commonDal.GetAll(pageFilter, modelName);
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

        public GridFilterResult MasterGetAll(SortPaginateFilter pageFilter, string modelName)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(GetAll), Level.Info.ToString());
                var result = _commonDal.MasterGetAll(pageFilter, modelName);
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
        public GridFilterResult BEMSGetAll(SortPaginateFilter pageFilter, string modelName)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(GetAll), Level.Info.ToString());
                var result = _commonDal.BEMSGetAll(pageFilter, modelName);
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
        public GridFilterResult FEMSGetAll(SortPaginateFilter pageFilter, string modelName)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(GetAll), Level.Info.ToString());
                var result = _commonDal.FEMSGetAll(pageFilter, modelName);
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
        public DataTable Export(SortPaginateFilter pageFilter, string SPName)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Export), Level.Info.ToString());
                var result = _commonDal.Export(pageFilter, SPName);
                Log4NetLogger.LogExit(_FileName, nameof(Export), Level.Info.ToString());
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
        public DataTable KPIExport(string SPName, KPIGenerationFetch KpiGenerationFetch)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Export), Level.Info.ToString());
                var result = _commonDal.KPIExport(SPName, KpiGenerationFetch);
                Log4NetLogger.LogExit(_FileName, nameof(Export), Level.Info.ToString());
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
        public DataTable WarrantyHistory(string SPName, string AssetId)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Export), Level.Info.ToString());
                var result = _commonDal.WarrantyHistory(SPName, AssetId);
                Log4NetLogger.LogExit(_FileName, nameof(Export), Level.Info.ToString());
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
        public FileUploadDetModel DownloadAttachments(int DcoumentId)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(DownloadAttachments), Level.Info.ToString());
                var result = _commonDal.DownloadAttachments(DcoumentId);
                Log4NetLogger.LogExit(_FileName, nameof(DownloadAttachments), Level.Info.ToString());
                return result;
            }
            catch (BALException balex)
            {
                throw new BALException(balex);
            }
            catch (Exception ex)
            {
                throw new BALException(ex);
            }
        }
        public DataTable MonthlyStockRegisterExport(string SPName, ItemMonthlyStockRegisterList monthlystkRegmodel)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(MonthlyStockRegisterExport), Level.Info.ToString());
                var result = _commonDal.MonthlyStockRegisterExport(SPName, monthlystkRegmodel);
                Log4NetLogger.LogExit(_FileName, nameof(MonthlyStockRegisterExport), Level.Info.ToString());
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

        public DataTable VerificationOfVariationExport(string SPName, VVFEntity vvfExport)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(MonthlyStockRegisterExport), Level.Info.ToString());
                var result = _commonDal.VerificationOfVariationExport(SPName, vvfExport);
                Log4NetLogger.LogExit(_FileName, nameof(MonthlyStockRegisterExport), Level.Info.ToString());
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
        public LovMasterViewModel GetHelpDescription(string ScreenUrl)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(GetHelpDescription), Level.Info.ToString());
                var result = _commonDal.GetHelpDescription(ScreenUrl);
                Log4NetLogger.LogExit(_FileName, nameof(GetHelpDescription), Level.Info.ToString());
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

        public List<HistoryViewModel> History(string GuId, int PageIndex, int PageSize)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(History), Level.Info.ToString());
                var result = _commonDal.History(GuId, PageSize, PageIndex);
                Log4NetLogger.LogExit(_FileName, nameof(History), Level.Info.ToString());
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

        public AssetRegisterImport GetAssetData(string AssetId)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(History), Level.Info.ToString());
                var result = _commonDal.GetAssetData(AssetId);
                Log4NetLogger.LogExit(_FileName, nameof(History), Level.Info.ToString());
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
