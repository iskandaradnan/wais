using CP.UETrack.BLL.BusinessAccess.Interface;
using CP.UETrack.DAL.DataAccess;
using CP.UETrack.Model;
using System;
using CP.Framework.Common.Logging;
using CP.Framework.Common.ExceptionHandler.ExceptionWrappers;
using System.Collections.Generic;
using CP.UETrack.Model.BEMS;
using CP.UETrack.Model.FetchModels;

namespace CP.UETrack.BLL.BusinessAccess
{
    public class SearchBAL : ISearchBAL
    {
        private string _FileName = nameof(SearchBAL);
        ISearchDAL _SearchDAL;
        public SearchBAL(ISearchDAL searchDAL)
        {
            _SearchDAL = searchDAL;
        }
        public List<UMStaffSearch> PopupSearch(UMStaffSearch SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(PopupSearch), Level.Info.ToString());
                var result = _SearchDAL.StaffMasterSearch(SearchObject);
                Log4NetLogger.LogExit(_FileName, nameof(PopupSearch), Level.Info.ToString());
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
        public List<TypeCodeSearch> TypeCodeSearch(TypeCodeSearch SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(TypeCodeSearch), Level.Info.ToString());
                var result = _SearchDAL.TypeCodeSearch(SearchObject);
                Log4NetLogger.LogExit(_FileName, nameof(TypeCodeSearch), Level.Info.ToString());
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
        public List<UserLocationCodeSearch> LocationCodeSearch(UserLocationCodeSearch SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(LocationCodeSearch), Level.Info.ToString());
                var result = _SearchDAL.LocationCodeSearch(SearchObject);
                Log4NetLogger.LogExit(_FileName, nameof(LocationCodeSearch), Level.Info.ToString());
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
        public List<ManufacturerSearch> ManufacturerSearch(ManufacturerSearch SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(ManufacturerSearch), Level.Info.ToString());
                var result = _SearchDAL.ManufacturerSearch(SearchObject);
                Log4NetLogger.LogExit(_FileName, nameof(ManufacturerSearch), Level.Info.ToString());
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
        public List<ModelSearch> ModelSearch(ModelSearch SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(ModelSearch), Level.Info.ToString());
                var result = _SearchDAL.ModelSearch(SearchObject);
                Log4NetLogger.LogExit(_FileName, nameof(ModelSearch), Level.Info.ToString());
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
        public List<EngAssetTypeCodeStandardTasksFetch> TaskCodeSearch(EngAssetTypeCodeStandardTasksFetch SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(ModelSearch), Level.Info.ToString());
                var result = _SearchDAL.TaskCodeSearch(SearchObject);
                Log4NetLogger.LogExit(_FileName, nameof(ModelSearch), Level.Info.ToString());
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
        public List<AssetPreRegistrationNoSearch> AssetPreRegistrationNoSearch(AssetPreRegistrationNoSearch SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(AssetPreRegistrationNoSearch), Level.Info.ToString());
                var result = _SearchDAL.AssetPreRegistrationNoSearch(SearchObject);
                Log4NetLogger.LogExit(_FileName, nameof(AssetPreRegistrationNoSearch), Level.Info.ToString());
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
        public List<LevelFetchModel> LevelCodeSearch(LevelFetchModel searchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(AssetPreRegistrationNoSearch), Level.Info.ToString());
                var result = _SearchDAL.LevelCodeSearch(searchObject);
                Log4NetLogger.LogExit(_FileName, nameof(AssetPreRegistrationNoSearch), Level.Info.ToString());
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
        public List<CompanyStaffFetchModel> CompanyStaffSearch(CompanyStaffFetchModel searchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(AssetPreRegistrationNoSearch), Level.Info.ToString());
                var result = _SearchDAL.CompanyStaffSearch(searchObject);
                Log4NetLogger.LogExit(_FileName, nameof(AssetPreRegistrationNoSearch), Level.Info.ToString());
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
        public List<FacilityStaffFetchModel> FacilityStaffSearch(FacilityStaffFetchModel searchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(AssetPreRegistrationNoSearch), Level.Info.ToString());
                var result = _SearchDAL.FacilityStaffSearch(searchObject);
                Log4NetLogger.LogExit(_FileName, nameof(AssetPreRegistrationNoSearch), Level.Info.ToString());
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
        public List<WarrantyManagementSearch> WarrantyManagementSearch(WarrantyManagementSearch SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(WarrantyManagementSearch), Level.Info.ToString());
                var result = _SearchDAL.WarrantyManagementSearch(SearchObject);
                Log4NetLogger.LogExit(_FileName, nameof(WarrantyManagementSearch), Level.Info.ToString());
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
        public List<UserAreaFetch> UserAreaSearch(UserAreaFetch searchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(AssetPreRegistrationNoSearch), Level.Info.ToString());
                var result = _SearchDAL.UserAreaSearch(searchObject);
                Log4NetLogger.LogExit(_FileName, nameof(AssetPreRegistrationNoSearch), Level.Info.ToString());
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
        public List<StockAdjustmentFetchModel> StockAdjustmentFetchModel(StockAdjustmentFetchModel SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(StockAdjustmentFetchModel), Level.Info.ToString());
                var result = _SearchDAL.StockAdjustmentFetchModel(SearchObject);
                Log4NetLogger.LogExit(_FileName, nameof(StockAdjustmentFetchModel), Level.Info.ToString());
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
        public List<ParentAssetNoSearch> ParentAssetNoSearch(ParentAssetNoSearch SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(ParentAssetNoSearch), Level.Info.ToString());
                var result = _SearchDAL.AssetNoSearch(SearchObject);
                Log4NetLogger.LogExit(_FileName, nameof(ParentAssetNoSearch), Level.Info.ToString());
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
        public List<AssetRegisterWarrantyProviderGrid> SearchforContractorcode(AssetRegisterWarrantyProviderGrid SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(SearchforContractorcode), Level.Info.ToString());
                var result = _SearchDAL.SearchforContractorcode(SearchObject);
                Log4NetLogger.LogExit(_FileName, nameof(SearchforContractorcode), Level.Info.ToString());
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
        public List<AssetClassificationFetch> AssetClassificationCodeSearch(AssetClassificationFetch searchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(AssetClassificationCodeSearch), Level.Info.ToString());
                var result = _SearchDAL.AssetClassificationCodeSearch(searchObject);
                Log4NetLogger.LogExit(_FileName, nameof(AssetClassificationCodeSearch), Level.Info.ToString());
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
        public List<ItemCodeFetch> ItemCodeSearch(ItemCodeFetch searchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(AssetClassificationCodeSearch), Level.Info.ToString());
                var result = _SearchDAL.ItemCodeSearch(searchObject);
                Log4NetLogger.LogExit(_FileName, nameof(AssetClassificationCodeSearch), Level.Info.ToString());
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
        public List<BERAssetNoFetch> BERAssetSearch(BERAssetNoFetch searchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(BERAssetNoFetch), Level.Info.ToString());
                var result = _SearchDAL.BERAssetSearch(searchObject);
                Log4NetLogger.LogExit(_FileName, nameof(BERAssetNoFetch), Level.Info.ToString());
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

        public List<BERRejectedNoFetch> BERRejectedNoSearch(BERRejectedNoFetch searchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(BERRejectedNoSearch), Level.Info.ToString());
                var result = _SearchDAL.BERRejectedNoSearch(searchObject);
                Log4NetLogger.LogExit(_FileName, nameof(BERRejectedNoSearch), Level.Info.ToString());
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
        public List<AssetQRCodePrintFetchModel> AssetQRCodePrintFetchModel(AssetQRCodePrintFetchModel SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(AssetQRCodePrintFetchModel), Level.Info.ToString());
                var result = _SearchDAL.AssetQRCodePrintFetchModel(SearchObject);
                Log4NetLogger.LogExit(_FileName, nameof(AssetQRCodePrintFetchModel), Level.Info.ToString());
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
        public List<UserLocationQRCodePrintingFetchModel> UserLocationQRCodePrintingFetchModel(UserLocationQRCodePrintingFetchModel SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(UserLocationQRCodePrintingFetchModel), Level.Info.ToString());
                var result = _SearchDAL.UserLocationQRCodePrintingFetchModel(SearchObject);
                Log4NetLogger.LogExit(_FileName, nameof(UserLocationQRCodePrintingFetchModel), Level.Info.ToString());
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
        public List<CRMWorkorderRequestFetch> CRMWorkorderRequestFetch(CRMWorkorderRequestFetch SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(CRMWorkorderRequestFetch), Level.Info.ToString());
                var result = _SearchDAL.CRMWorkorderRequestFetch(SearchObject);
                Log4NetLogger.LogExit(_FileName, nameof(CRMWorkorderRequestFetch), Level.Info.ToString());
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
        public List<TAndCCRMRequestNoFetchSearch> TAndCCRMRequestNoSearch(TAndCCRMRequestNoFetchSearch SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(TAndCCRMRequestNoSearch), Level.Info.ToString());
                var result = _SearchDAL.TAndCCRMRequestNoSearch(SearchObject);
                Log4NetLogger.LogExit(_FileName, nameof(TAndCCRMRequestNoSearch), Level.Info.ToString());
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
        public List<PortAssetFetchModel> PorteringWorkOrderNoSearch(PortAssetFetchModel SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(PorteringWorkOrderNoSearch), Level.Info.ToString());
                var result = _SearchDAL.PorteringWorkOrderNoSearch(SearchObject);
                Log4NetLogger.LogExit(_FileName, nameof(PorteringWorkOrderNoSearch), Level.Info.ToString());
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
        public List<PortAssetFetchModel> PorteringAssetNoSearch(PortAssetFetchModel SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(PorteringAssetNoSearch), Level.Info.ToString());
                var result = _SearchDAL.PorteringAssetNoSearch(SearchObject);
                Log4NetLogger.LogExit(_FileName, nameof(PorteringAssetNoSearch), Level.Info.ToString());
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
        public List<EODCaptureAssetFetch> EODCaptureAssetFetch(EODCaptureAssetFetch SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(EODCaptureAssetFetch), Level.Info.ToString());
                var result = _SearchDAL.EODCaptureAssetFetch(SearchObject);
                Log4NetLogger.LogExit(_FileName, nameof(EODCaptureAssetFetch), Level.Info.ToString());
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
        public List<EODCaptureManufacturer> EODCaptureManufacturer(EODCaptureManufacturer SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(EODCaptureManufacturer), Level.Info.ToString());
                var result = _SearchDAL.EODCaptureManufacturer(SearchObject);
                Log4NetLogger.LogExit(_FileName, nameof(EODCaptureManufacturer), Level.Info.ToString());
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
        public List<EODCaptureModel> EODCaptureModel(EODCaptureModel SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(EODCaptureModel), Level.Info.ToString());
                var result = _SearchDAL.EODCaptureModel(SearchObject);
                Log4NetLogger.LogExit(_FileName, nameof(EODCaptureModel), Level.Info.ToString());
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
        public List<CustomerFetch> CustomerCodeSearch(CustomerFetch SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(CustomerCodeSearch), Level.Info.ToString());
                var result = _SearchDAL.CustomerCodeSearch(SearchObject);
                Log4NetLogger.LogExit(_FileName, nameof(CustomerCodeSearch), Level.Info.ToString());
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
        public List<CRMRequestAssetFetch> CRMRequestAssetFetch(CRMRequestAssetFetch SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(CRMRequestAssetFetch), Level.Info.ToString());
                var result = _SearchDAL.CRMRequestAssetFetch(SearchObject);
                Log4NetLogger.LogExit(_FileName, nameof(CRMRequestAssetFetch), Level.Info.ToString());
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
        public List<CRMWorkorderStaffFetch> CRMWorkorderStaffFetch(CRMWorkorderStaffFetch SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(CRMWorkorderStaffFetch), Level.Info.ToString());
                var result = _SearchDAL.CRMWorkorderStaffFetch(SearchObject);
                Log4NetLogger.LogExit(_FileName, nameof(CRMWorkorderStaffFetch), Level.Info.ToString());
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
        public List<ContractorNameSearch> ContractorNameSearch(ContractorNameSearch SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(ContractorNameSearch), Level.Info.ToString());
                var result = _SearchDAL.ContractorNameSearch(SearchObject);
                Log4NetLogger.LogExit(_FileName, nameof(ContractorNameSearch), Level.Info.ToString());
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

        public List<BookingFetch> BookingAssetNoSearch(BookingFetch searchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(ContractorNameSearch), Level.Info.ToString());
                var result = _SearchDAL.BookingAssetNoSearch(searchObject);
                Log4NetLogger.LogExit(_FileName, nameof(ContractorNameSearch), Level.Info.ToString());
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
        public List<BookingFetch> BookingWorkOrderNoSearch(BookingFetch searchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(ContractorNameSearch), Level.Info.ToString());
                var result = _SearchDAL.BookingWorkOrderNoSearch(searchObject);
                Log4NetLogger.LogExit(_FileName, nameof(ContractorNameSearch), Level.Info.ToString());
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

        
        public List<UserShiftLeaveDetailsFetch> UserShiftLeaveDetailsSearch(UserShiftLeaveDetailsFetch searchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(UserShiftLeaveDetailsSearch), Level.Info.ToString());
                var result = _SearchDAL.UserShiftLeaveDetailsSearch(searchObject);
                Log4NetLogger.LogExit(_FileName, nameof(UserShiftLeaveDetailsSearch), Level.Info.ToString());
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

        public List<UserTainingParticipantFetch> UserTainingParticipantFetch(UserTainingParticipantFetch searchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(UserShiftLeaveDetailsFetch), Level.Info.ToString());
                var result = _SearchDAL.UserTainingParticipantFetch(searchObject);
                Log4NetLogger.LogExit(_FileName, nameof(UserShiftLeaveDetailsFetch), Level.Info.ToString());
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
        public List<FilureSymptomCodeFetch> FilureSymptomCodeFetch(FilureSymptomCodeFetch SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(UserShiftLeaveDetailsFetch), Level.Info.ToString());
                var result = _SearchDAL.FilureSymptomCodeFetch(SearchObject);
                Log4NetLogger.LogExit(_FileName, nameof(UserShiftLeaveDetailsFetch), Level.Info.ToString());
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
        public List<FollowupCarFetch> FollowupCarFetch(FollowupCarFetch SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(FollowupCarFetch), Level.Info.ToString());
                var result = _SearchDAL.FollowupCarFetch(SearchObject);
                Log4NetLogger.LogExit(_FileName, nameof(FollowupCarFetch), Level.Info.ToString());
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

        public List<AreaFetch> BlockCascCodeSearch(AreaFetch SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(BlockCascCodeSearch), Level.Info.ToString());
                var result = _SearchDAL.BlockCascCodeSearch(SearchObject);
                Log4NetLogger.LogExit(_FileName, nameof(BlockCascCodeSearch), Level.Info.ToString());
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

        public List<AreaFetch> QCPPMCodeSearch(AreaFetch SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(QCPPMCodeSearch), Level.Info.ToString());
                var result = _SearchDAL.QCPPMCodeSearch(SearchObject);
                Log4NetLogger.LogExit(_FileName, nameof(QCPPMCodeSearch), Level.Info.ToString());
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

        public List<AreaFetch> LevelCascCodeSearch(AreaFetch SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(LevelCascCodeSearch), Level.Info.ToString());
                var result = _SearchDAL.LevelCascCodeSearch(SearchObject);
                Log4NetLogger.LogExit(_FileName, nameof(LevelCascCodeSearch), Level.Info.ToString());
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

        public List<AreaFetch> AreaCascCodeSearch(AreaFetch SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(AreaCascCodeSearch), Level.Info.ToString());
                var result = _SearchDAL.AreaCascCodeSearch(SearchObject);
                Log4NetLogger.LogExit(_FileName, nameof(AreaCascCodeSearch), Level.Info.ToString());
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

        public List<UserLocationCodeSearch> BookingLocationSearch(UserLocationCodeSearch SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(AreaCascCodeSearch), Level.Info.ToString());
                var result = _SearchDAL.BookingLocationSearch(SearchObject);
                Log4NetLogger.LogExit(_FileName, nameof(AreaCascCodeSearch), Level.Info.ToString());
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



        //public List<BERNoList> BERNoList(BERNoList SearchObject)
        //{
        //    try
        //    {
        //        Log4NetLogger.LogEntry(_FileName, nameof(BERNoList), Level.Info.ToString());
        //        var result = _SearchDAL.BERNoList(SearchObject);
        //        Log4NetLogger.LogExit(_FileName, nameof(BERNoList), Level.Info.ToString());
        //        return result;
        //    }
        //    catch (BALException balException)
        //    {
        //        throw new BALException(balException);
        //    }
        //    catch (Exception)
        //    {
        //        throw;
        //    }
        //}
    }//
}
