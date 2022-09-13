using CP.UETrack.BLL.BusinessAccess.Interface;
using CP.UETrack.DAL.DataAccess;
using CP.UETrack.Model;
using System;
using CP.Framework.Common.Logging;
using CP.Framework.Common.ExceptionHandler.ExceptionWrappers;
using System.Collections.Generic;
using CP.UETrack.Model.BEMS;
using CP.UETrack.Model.FetchModels;
using CP.UETrack.Model.VM;
using static CP.UETrack.Model.FetchModels.ModelSearching;
using CP.UETrack.Model.LLS;

namespace CP.UETrack.BLL.BusinessAccess
{
    public class FetchBAL : IFetchBAL

    {
        private string _FileName = nameof(FetchBAL);
        IFetchDAL _FetchDAL;
        public FetchBAL(IFetchDAL fetchDAL)
        {
            _FetchDAL = fetchDAL;
        }
        public List<UMStaffSearch> FetchRecords(UMStaffSearch SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(FetchRecords), Level.Info.ToString());
                var result = _FetchDAL.FetchStaffMaster(SearchObject);
                Log4NetLogger.LogExit(_FileName, nameof(FetchRecords), Level.Info.ToString());
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
        public List<ItemMstFetchEntity> FetchItemMstdetais(ItemMstFetchEntity SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(FetchRecords), Level.Info.ToString());
                var result = _FetchDAL.FetchItemMstdetais(SearchObject);
                Log4NetLogger.LogExit(_FileName, nameof(FetchRecords), Level.Info.ToString());
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
        public List<TypeCodeSearch> TypeCodeFetch(TypeCodeSearch SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(TypeCodeFetch), Level.Info.ToString());
                var result = _FetchDAL.TypeCodeFetch(SearchObject);
                Log4NetLogger.LogExit(_FileName, nameof(TypeCodeFetch), Level.Info.ToString());
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


        public List<EngAssetTypeCodeStandardTasksFetch> FetchTaskCode(EngAssetTypeCodeStandardTasksFetch SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(FetchRecords), Level.Info.ToString());
                var result = _FetchDAL.FetchTaskCode(SearchObject);
                Log4NetLogger.LogExit(_FileName, nameof(FetchRecords), Level.Info.ToString());
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
        public List<UserLocationCodeSearch> LocationCodeFetch(UserLocationCodeSearch SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(LocationCodeFetch), Level.Info.ToString());
                var result = _FetchDAL.LocationCodeFetch(SearchObject);
                Log4NetLogger.LogExit(_FileName, nameof(LocationCodeFetch), Level.Info.ToString());
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
        public List<ManufacturerSearch> ManufacturerFetch(ManufacturerSearch SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(ManufacturerFetch), Level.Info.ToString());
                var result = _FetchDAL.ManufacturerFetch(SearchObject);
                Log4NetLogger.LogExit(_FileName, nameof(ManufacturerFetch), Level.Info.ToString());
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
        public List<ModelSearch> ModelFetch(ModelSearch SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(ModelFetch), Level.Info.ToString());
                var result = _FetchDAL.ModelFetch(SearchObject);
                Log4NetLogger.LogExit(_FileName, nameof(ModelFetch), Level.Info.ToString());
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
        public List<RescheduleWOFetchModel> FetchRescheduleWOdetails(RescheduleWOFetchModel SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(FetchRescheduleWOdetails), Level.Info.ToString());
                var result = _FetchDAL.FetchRescheduleWOdetails(SearchObject);
                Log4NetLogger.LogExit(_FileName, nameof(FetchRescheduleWOdetails), Level.Info.ToString());
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
        public List<AssetPreRegistrationNoSearch> AssetPreRegistrationNoFetch(AssetPreRegistrationNoSearch SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(AssetPreRegistrationNoFetch), Level.Info.ToString());
                var result = _FetchDAL.AssetPreRegistrationNoFetch(SearchObject);
                Log4NetLogger.LogExit(_FileName, nameof(AssetPreRegistrationNoFetch), Level.Info.ToString());
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
        public List<AssetRegisterWarrantyProviderGrid> FetchWarrantyProvider(AssetRegisterWarrantyProviderGrid SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(FetchWarrantyProvider), Level.Info.ToString());
                var result = _FetchDAL.FetchWarrantyProvider(SearchObject);
                Log4NetLogger.LogExit(_FileName, nameof(FetchWarrantyProvider), Level.Info.ToString());
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

        public List<CompanyStaffFetchModel> CompanyStaffFetch(CompanyStaffFetchModel searchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(FetchWarrantyProvider), Level.Info.ToString());
                var result = _FetchDAL.CompanyStaffFetch(searchObject);
                Log4NetLogger.LogExit(_FileName, nameof(FetchWarrantyProvider), Level.Info.ToString());
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
        public List<FacilityStaffFetchModel> FacilityStaffFetch(FacilityStaffFetchModel searchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(FetchWarrantyProvider), Level.Info.ToString());
                var result = _FetchDAL.FacilityStaffFetch(searchObject);
                Log4NetLogger.LogExit(_FileName, nameof(FetchWarrantyProvider), Level.Info.ToString());
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
        public List<LevelFetchModel> LevelCodeFetch(LevelFetchModel searchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(FetchWarrantyProvider), Level.Info.ToString());
                var result = _FetchDAL.LevelCodeFetch(searchObject);
                Log4NetLogger.LogExit(_FileName, nameof(FetchWarrantyProvider), Level.Info.ToString());
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
        public List<WarrantyManagementSearch> AssetNoFetch(WarrantyManagementSearch SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(AssetNoFetch), Level.Info.ToString());
                var result = _FetchDAL.AssetNoFetch(SearchObject);
                Log4NetLogger.LogExit(_FileName, nameof(AssetNoFetch), Level.Info.ToString());
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

        public List<UserAreaFetch> UserAreaFetch(UserAreaFetch searchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(FetchWarrantyProvider), Level.Info.ToString());
                var result = _FetchDAL.UserAreaFetch(searchObject);
                Log4NetLogger.LogExit(_FileName, nameof(FetchWarrantyProvider), Level.Info.ToString());
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
                var result = _FetchDAL.StockAdjustmentFetchModel(SearchObject);
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
        public List<ParentAssetNoSearch> FacilityWorkAssetNoFetch(ParentAssetNoSearch SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(FacilityWorkAssetNoFetch), Level.Info.ToString());
                var result = _FetchDAL.FacilityWorkAssetNoFetch(SearchObject);
                Log4NetLogger.LogExit(_FileName, nameof(FacilityWorkAssetNoFetch), Level.Info.ToString());
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
        public List<ParentAssetNoSearch> ParentAssetNoFetch(ParentAssetNoSearch SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(ParentAssetNoFetch), Level.Info.ToString());
                var result = _FetchDAL.AssetNoFetch(SearchObject);
                Log4NetLogger.LogExit(_FileName, nameof(ParentAssetNoFetch), Level.Info.ToString());
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
        public List<AssetClassificationFetch> AssetClassificationCodeFetch(AssetClassificationFetch searchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(ParentAssetNoFetch), Level.Info.ToString());
                var result = _FetchDAL.AssetClassificationCodeFetch(searchObject);
                Log4NetLogger.LogExit(_FileName, nameof(ParentAssetNoFetch), Level.Info.ToString());
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

        public List<ItemCodeFetch> ItemCodeFetch(ItemCodeFetch searchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(ParentAssetNoFetch), Level.Info.ToString());
                var result = _FetchDAL.ItemCodeFetch(searchObject);
                Log4NetLogger.LogExit(_FileName, nameof(ParentAssetNoFetch), Level.Info.ToString());
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
        public List<SNFAssetFetchEntity> SNFAssetFetch(SNFAssetFetchEntity searchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(SNFAssetFetch), Level.Info.ToString());
                var result = _FetchDAL.SNFAssetFetch(searchObject);
                Log4NetLogger.LogExit(_FileName, nameof(SNFAssetFetch), Level.Info.ToString());
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
        public List<PPMCheckListFetchItem> FetchCheckListItemDetails(PPMCheckListFetchItem searchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(FetchCheckListItemDetails), Level.Info.ToString());
                var result = _FetchDAL.FetchCheckListItemDetails(searchObject);
                Log4NetLogger.LogExit(_FileName, nameof(SNFAssetFetch), Level.Info.ToString());
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
        public List<BERAssetNoFetch> BERAssetNoFetch(BERAssetNoFetch searchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(BERAssetNoFetch), Level.Info.ToString());
                var result = _FetchDAL.BERAssetNoFetch(searchObject);
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

        public List<BERRejectedNoFetch> BERRejectedNoFetch(BERRejectedNoFetch searchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(BERAssetNoFetch), Level.Info.ToString());
                var result = _FetchDAL.BERRejectedNoFetch(searchObject);
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

        public List<SNFfetchEntity> FetchSNFDetails(SNFfetchEntity searchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(FetchSNFDetails), Level.Info.ToString());
                var result = _FetchDAL.FetchSNFDetails(searchObject);
                Log4NetLogger.LogExit(_FileName, nameof(FetchSNFDetails), Level.Info.ToString());
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
                var result = _FetchDAL.AssetQRCodePrintFetchModel(SearchObject);
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
                var result = _FetchDAL.UserLocationQRCodePrintingFetchModel(SearchObject);
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

        public List<UserAreaQRCodePrintingFetchModel> UserAreaQRCodePrintingFetchModel(UserAreaQRCodePrintingFetchModel SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(UserAreaQRCodePrintingFetchModel), Level.Info.ToString());
                var result = _FetchDAL.UserAreaQRCodePrintingFetchModel(SearchObject);
                Log4NetLogger.LogExit(_FileName, nameof(UserAreaQRCodePrintingFetchModel), Level.Info.ToString());
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
                var result = _FetchDAL.CRMWorkorderRequestFetch(SearchObject);
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
        public List<TAndCCRMRequestNoFetchSearch> TAndCCRMRequestNoFetch(TAndCCRMRequestNoFetchSearch SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(TAndCCRMRequestNoFetch), Level.Info.ToString());
                var result = _FetchDAL.TAndCCRMRequestNoFetch(SearchObject);
                Log4NetLogger.LogExit(_FileName, nameof(TAndCCRMRequestNoFetch), Level.Info.ToString());
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
        public List<PortAssetFetchModel> PorteringWorkOrderNoFetch(PortAssetFetchModel SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(PorteringWorkOrderNoFetch), Level.Info.ToString());
                var result = _FetchDAL.PorteringWorkOrderNoFetch(SearchObject);
                Log4NetLogger.LogExit(_FileName, nameof(PorteringWorkOrderNoFetch), Level.Info.ToString());
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

        public List<PortAssetFetchModel> PorteringAssetNoFetch(PortAssetFetchModel SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(PorteringAssetNoFetch), Level.Info.ToString());
                var result = _FetchDAL.PorteringAssetNoFetch(SearchObject);
                Log4NetLogger.LogExit(_FileName, nameof(PorteringAssetNoFetch), Level.Info.ToString());
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
                var result = _FetchDAL.EODCaptureAssetFetch(SearchObject);
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
                var result = _FetchDAL.EODCaptureManufacturer(SearchObject);
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
                var result = _FetchDAL.EODCaptureModel(SearchObject);
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

        public List<CustomerFetch> CustomerCodeFetch(CustomerFetch SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(CustomerCodeFetch), Level.Info.ToString());
                var result = _FetchDAL.CustomerCodeFetch(SearchObject);
                Log4NetLogger.LogExit(_FileName, nameof(CustomerCodeFetch), Level.Info.ToString());
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
                var result = _FetchDAL.CRMRequestAssetFetch(SearchObject);
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
                var result = _FetchDAL.CRMWorkorderStaffFetch(SearchObject);
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
        public List<ContractorNameSearch> ContractorNameFetch(ContractorNameSearch SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(ContractorNameFetch), Level.Info.ToString());
                var result = _FetchDAL.ContractorNameFetch(SearchObject);
                Log4NetLogger.LogExit(_FileName, nameof(ContractorNameFetch), Level.Info.ToString());
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


        public List<BookingFetch> BookingWorkOrderNoFetch(BookingFetch fetchObj)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(BookingWorkOrderNoFetch), Level.Info.ToString());
                var result = _FetchDAL.BookingWorkOrderNoFetch(fetchObj);
                Log4NetLogger.LogExit(_FileName, nameof(BookingWorkOrderNoFetch), Level.Info.ToString());
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
        public List<BookingFetch> BookingAssetNoFetch(BookingFetch fetchObj)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(BookingAssetNoFetch), Level.Info.ToString());
                var result = _FetchDAL.BookingAssetNoFetch(fetchObj);
                Log4NetLogger.LogExit(_FileName, nameof(BookingAssetNoFetch), Level.Info.ToString());
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
        public List<UserShiftLeaveDetailsFetch> UserShiftLeaveDetailsFetch(UserShiftLeaveDetailsFetch SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(UserShiftLeaveDetailsFetch), Level.Info.ToString());
                var result = _FetchDAL.UserShiftLeaveDetailsFetch(SearchObject);
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

        public List<UserTainingParticipantFetch> UserTainingParticipantFetch(UserTainingParticipantFetch SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(UserTainingParticipantFetch), Level.Info.ToString());
                var result = _FetchDAL.UserTainingParticipantFetch(SearchObject);
                Log4NetLogger.LogExit(_FileName, nameof(UserTainingParticipantFetch), Level.Info.ToString());
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
                Log4NetLogger.LogEntry(_FileName, nameof(FilureSymptomCodeFetch), Level.Info.ToString());
                var result = _FetchDAL.FilureSymptomCodeFetch(SearchObject);
                Log4NetLogger.LogExit(_FileName, nameof(FilureSymptomCodeFetch), Level.Info.ToString());
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
                var result = _FetchDAL.FollowupCarFetch(SearchObject);
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

        public List<AreaFetch> BlockCascCodeFetch(AreaFetch SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(FollowupCarFetch), Level.Info.ToString());
                var result = _FetchDAL.BlockCascCodeFetch(SearchObject);
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

        public List<AreaFetch> LevelCascCodeFetch(AreaFetch SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(FollowupCarFetch), Level.Info.ToString());
                var result = _FetchDAL.LevelCascCodeFetch(SearchObject);
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

        public List<AreaFetch> AreaCascCodeFetch(AreaFetch SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(FollowupCarFetch), Level.Info.ToString());
                var result = _FetchDAL.AreaCascCodeFetch(SearchObject);
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


        public List<UserLocationCodeSearch> BookingLocationFetch(UserLocationCodeSearch SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(BookingLocationFetch), Level.Info.ToString());
                var result = _FetchDAL.BookingLocationFetch(SearchObject);
                Log4NetLogger.LogExit(_FileName, nameof(BookingLocationFetch), Level.Info.ToString());
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
        public List<CRMRequestType> CRMFetchRequestTypedetais(CRMRequestType SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(CRMFetchRequestTypedetais), Level.Info.ToString());
                var result = _FetchDAL.CRMFetchRequestTypedetais(SearchObject);
                Log4NetLogger.LogExit(_FileName, nameof(CRMFetchRequestTypedetais), Level.Info.ToString());
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

        public List<ItemMstFetchEntity> FetchItemNo(ItemMstFetchEntity SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(FetchItemNo), Level.Info.ToString());
                var result = _FetchDAL.FetchItemNo(SearchObject);
                Log4NetLogger.LogExit(_FileName, nameof(FetchItemNo), Level.Info.ToString());
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

        public List<ItemMstFetchEntity> FetchPartNo(ItemMstFetchEntity SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(FetchPartNo), Level.Info.ToString());
                var result = _FetchDAL.FetchPartNo(SearchObject);
                Log4NetLogger.LogExit(_FileName, nameof(FetchPartNo), Level.Info.ToString());
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

        #region LLS Fetch and Search

        public List<UserAreaFetch> DepartmentCascCodeFetch(UserAreaFetch searchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(FetchWarrantyProvider), Level.Info.ToString());
                var result = _FetchDAL.DepartmentCascCodeFetch(searchObject);
                Log4NetLogger.LogExit(_FileName, nameof(FetchWarrantyProvider), Level.Info.ToString());
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

        public List<UserAreaFetchs> LLSUserAreaDetailsLocationMstDet_FetchLocCode(UserAreaFetchs searchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(FetchWarrantyProvider), Level.Info.ToString());
                var result = _FetchDAL.LLSUserAreaDetailsLocationMstDet_FetchLocCode(searchObject);
                Log4NetLogger.LogExit(_FileName, nameof(FetchWarrantyProvider), Level.Info.ToString());
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
        public List<LinenItemCodeFetch> LinenItemCascCodeFetch(LinenItemCodeFetch SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(FollowupCarFetch), Level.Info.ToString());
                var result = _FetchDAL.LinenItemCascCodeFetch(SearchObject);
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
        public List<LocationCodeFetch> LocationCascCodeFetch(LocationCodeFetch SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(FollowupCarFetch), Level.Info.ToString());
                var result = _FetchDAL.LocationCascCodeFetch(SearchObject);
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
        public List<CleanLinenRequestModel> Cleanlinenrequest_UserareaCodeFetch(CleanLinenRequestModel searchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(FetchWarrantyProvider), Level.Info.ToString());
                var result = _FetchDAL.Cleanlinenrequest_UserareaCodeFetch(searchObject);
                Log4NetLogger.LogExit(_FileName, nameof(FetchWarrantyProvider), Level.Info.ToString());
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

        public List<CleanLinenRequestModel> CleanLinenRequestTxn_FetchLocCode(CleanLinenRequestModel searchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(FetchWarrantyProvider), Level.Info.ToString());
                var result = _FetchDAL.CleanLinenRequestTxn_FetchLocCode(searchObject);
                Log4NetLogger.LogExit(_FileName, nameof(FetchWarrantyProvider), Level.Info.ToString());
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
        public List<CleanLinenRequestModel> Cleanlinenrequest_FetchrequestBy(CleanLinenRequestModel SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(FollowupCarFetch), Level.Info.ToString());
                var result = _FetchDAL.Cleanlinenrequest_FetchrequestBy(SearchObject);
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
        public List<LocationCodeFetch> Cleanlinenrequestlinenitem_LinenCodeFetch(LocationCodeFetch SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(FollowupCarFetch), Level.Info.ToString());
                var result = _FetchDAL.Cleanlinenrequestlinenitem_LinenCodeFetch(SearchObject);
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
        public List<LocationCodeFetch> CleanLinenRequestLinenBag_FetchLaundryBag(LocationCodeFetch SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(FollowupCarFetch), Level.Info.ToString());
                var result = _FetchDAL.CleanLinenRequestLinenBag_FetchLaundryBag(SearchObject);
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
        public List<LinenConemnationModel> LinenInjectionTxnDet_FetchLinenCode(LinenConemnationModel SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(FollowupCarFetch), Level.Info.ToString());
                var result = _FetchDAL.LinenInjectionTxnDet_FetchLinenCode(SearchObject);
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

        public List<CleanLinenDespatchModel> CleanLinenDespatchTxn_FetchReceivedBy(CleanLinenDespatchModel SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(FollowupCarFetch), Level.Info.ToString());
                var result = _FetchDAL.CleanLinenDespatchTxn_FetchReceivedBy(SearchObject);
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

        public List<CleanLinenDespatchModel> CleanLinenDespatchTxnDet_FetchLinenCode(CleanLinenDespatchModel SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(FollowupCarFetch), Level.Info.ToString());
                var result = _FetchDAL.CleanLinenDespatchTxnDet_FetchLinenCode(SearchObject);
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


        #region CleanLinenIssue
        public List<CleanLinenIssueModel> CleanLinenIssueTxn_FetchCLRDocNo(CleanLinenIssueModel SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(FollowupCarFetch), Level.Info.ToString());
                var result = _FetchDAL.CleanLinenIssueTxn_FetchCLRDocNo(SearchObject);
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
        public List<CleanLinenIssueModel> CleanLinenIssueTxn_Fetch1stReceivedBy(CleanLinenIssueModel SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(FollowupCarFetch), Level.Info.ToString());
                var result = _FetchDAL.CleanLinenIssueTxn_Fetch1stReceivedBy(SearchObject);
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

        public List<CleanLinenIssueModel> CleanLinenIssueTxn_Fetch2ndReceivedBy(CleanLinenIssueModel SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(FollowupCarFetch), Level.Info.ToString());
                var result = _FetchDAL.CleanLinenIssueTxn_Fetch2ndReceivedBy(SearchObject);
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
        public List<CleanLinenIssueModel> CleanLinenIssueTxn_FetchVerifier(CleanLinenIssueModel SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(FollowupCarFetch), Level.Info.ToString());
                var result = _FetchDAL.CleanLinenIssueTxn_FetchVerifier(SearchObject);
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
        public List<CleanLinenIssueModel> CleanLinenIssueTxn_FetchDeliveredBy(CleanLinenIssueModel SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(FollowupCarFetch), Level.Info.ToString());
                var result = _FetchDAL.CleanLinenIssueTxn_FetchDeliveredBy(SearchObject);
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
        public List<CleanLinenIssueModel> CleanLinenIssueLinenBagTxnDet_FetchLaundryBag(CleanLinenIssueModel SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(FollowupCarFetch), Level.Info.ToString());
                var result = _FetchDAL.CleanLinenIssueLinenBagTxnDet_FetchLaundryBag(SearchObject);
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
        #endregion
        public List<DriverDetailsModel> DriverDetailsMstDet_FetchLicenseCode(DriverDetailsModel SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(FollowupCarFetch), Level.Info.ToString());
                var result = _FetchDAL.DriverDetailsMstDet_FetchLicenseCode(SearchObject);
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

        public List<LinenAdjustmentsModel> LinenAdjustmentTxn_FetchAuthorisedBy(LinenAdjustmentsModel SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(FollowupCarFetch), Level.Info.ToString());
                var result = _FetchDAL.LinenAdjustmentTxn_FetchAuthorisedBy(SearchObject);
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

        public List<LinenAdjustmentsModel> LinenAdjustmentTxn_FetchInventoryDocNo(LinenAdjustmentsModel SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(FollowupCarFetch), Level.Info.ToString());
                var result = _FetchDAL.LinenAdjustmentTxn_FetchInventoryDocNo(SearchObject);
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

        public List<LinenAdjustmentsModel> LinenAdjustmentTxnDet_FetchLinenCode(LinenAdjustmentsModel SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(FollowupCarFetch), Level.Info.ToString());
                var result = _FetchDAL.LinenAdjustmentTxnDet_FetchLinenCode(SearchObject);
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

        public List<VehicleDetailsModel> VehicleDetailsMstDet_FetchLicenseCode(VehicleDetailsModel SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(FollowupCarFetch), Level.Info.ToString());
                var result = _FetchDAL.VehicleDetailsMstDet_FetchLicenseCode(SearchObject);
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

        public List<LinenRepairModel> LinenRepairTxn_FetchRepairedBy(LinenRepairModel SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(FollowupCarFetch), Level.Info.ToString());
                var result = _FetchDAL.LinenRepairTxn_FetchRepairedBy(SearchObject);
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

        public List<LinenRepairModel> LinenRepairTxn_FetchCheckedBy(LinenRepairModel SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(FollowupCarFetch), Level.Info.ToString());
                var result = _FetchDAL.LinenRepairTxn_FetchCheckedBy(SearchObject);
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

        public List<LinenRepairModel> LinenRepairTxnDet_FetchLinenCode(LinenRepairModel SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(FollowupCarFetch), Level.Info.ToString());
                var result = _FetchDAL.LinenRepairTxnDet_FetchLinenCode(SearchObject);
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

        public List<CentralLinenStoreHousekeepingModel> CentralLinenStoreHKeepingTxn_FetchYear(CentralLinenStoreHousekeepingModel SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(FollowupCarFetch), Level.Info.ToString());
                var result = _FetchDAL.CentralLinenStoreHKeepingTxn_FetchYear(SearchObject);
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

        public List<CentralLinenStoreHousekeepingModel> CentralLinenStoreHKeepingTxn_FetchMonth(CentralLinenStoreHousekeepingModel SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(FollowupCarFetch), Level.Info.ToString());
                var result = _FetchDAL.CentralLinenStoreHKeepingTxn_FetchMonth(SearchObject);
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

        public List<CentralLinenStoreHousekeepingModel> CentralLinenStoreHKeepingTxnDet_FetchDate(CentralLinenStoreHousekeepingModel SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(FollowupCarFetch), Level.Info.ToString());
                var result = _FetchDAL.CentralLinenStoreHKeepingTxnDet_FetchDate(SearchObject);
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

        public List<soildLinencollectionsModel> SoiledLinenCollectionTxn_FetchLaundryPlant(soildLinencollectionsModel SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(FollowupCarFetch), Level.Info.ToString());
                var result = _FetchDAL.SoiledLinenCollectionTxn_FetchLaundryPlant(SearchObject);
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
        public List<CentralLinenStoreHousekeepingModel> SoiledLinenCollectionTxnDet_FetchUserAreaCode(CentralLinenStoreHousekeepingModel SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(FollowupCarFetch), Level.Info.ToString());
                var result = _FetchDAL.SoiledLinenCollectionTxnDet_FetchUserAreaCode(SearchObject);
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

        public List<CentralLinenStoreHousekeepingModel> SoiledLinenCollectionTxnDet_FetchLocCode(CentralLinenStoreHousekeepingModel SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(FollowupCarFetch), Level.Info.ToString());
                var result = _FetchDAL.SoiledLinenCollectionTxnDet_FetchLocCode(SearchObject);
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
        public List<soildLinencollectionsModel> SoiledLinenCollectionTxnDet_FetchCollectionSchedule(soildLinencollectionsModel SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(FollowupCarFetch), Level.Info.ToString());
                var result = _FetchDAL.SoiledLinenCollectionTxnDet_FetchCollectionSchedule(SearchObject);
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

        public List<soildLinencollectionsModel> SoiledLinenCollectionTxnDet_FetchVerifiedBy(soildLinencollectionsModel SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(FollowupCarFetch), Level.Info.ToString());
                var result = _FetchDAL.SoiledLinenCollectionTxnDet_FetchVerifiedBy(SearchObject);
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
        public List<LinenConemnationModel> LinenCondemnationTxn_FetchVerifiedBy(LinenConemnationModel SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(FollowupCarFetch), Level.Info.ToString());
                var result = _FetchDAL.LinenCondemnationTxn_FetchVerifiedBy(SearchObject);
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

        public List<LinenConemnationModel> LinenCondemnationTxn_FetchInspectedBy(LinenConemnationModel SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(FollowupCarFetch), Level.Info.ToString());
                var result = _FetchDAL.LinenCondemnationTxn_FetchInspectedBy(SearchObject);
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

        public List<LinenConemnationModel> LinenCondemnationTxnDet_FetchLinenCode(LinenConemnationModel SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(FollowupCarFetch), Level.Info.ToString());
                var result = _FetchDAL.LinenCondemnationTxnDet_FetchLinenCode(SearchObject);
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

        public List<LinenRejectReplacementModel> LinenRejectReplacementTxnDet_FetchLinenCode(LinenRejectReplacementModel SearchObject)
         {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(FollowupCarFetch), Level.Info.ToString());
                var result = _FetchDAL.LinenRejectReplacementTxnDet_FetchLinenCode(SearchObject);
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
        public List<LinenRejectReplacementModel> LinenRejectReplacementTxn_FetchLocCode(LinenRejectReplacementModel SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(FollowupCarFetch), Level.Info.ToString());
                var result = _FetchDAL.LinenRejectReplacementTxn_FetchLocCode(SearchObject);
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
        public List<LinenRejectReplacementModel> LinenRejectReplacementTxn_FetchUserAreaCode(LinenRejectReplacementModel SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(FollowupCarFetch), Level.Info.ToString());
                var result = _FetchDAL.LinenRejectReplacementTxn_FetchUserAreaCode(SearchObject);
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
        public List<LinenRejectReplacementModel> LinenRejectReplacementTxn_FetchCLINo(LinenRejectReplacementModel SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(FollowupCarFetch), Level.Info.ToString());
                var result = _FetchDAL.LinenRejectReplacementTxn_FetchCLINo(SearchObject);
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

        public List<LinenRejectReplacementModel> LinenRejectReplacementTxn_FetchRejectedBy(LinenRejectReplacementModel SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(FollowupCarFetch), Level.Info.ToString());
                var result = _FetchDAL.LinenRejectReplacementTxn_FetchRejectedBy(SearchObject);
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

        public List<LinenRejectReplacementModel> LinenRejectReplacementTxn_FetchReceivedBy(LinenRejectReplacementModel SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(FollowupCarFetch), Level.Info.ToString());
                var result = _FetchDAL.LinenRejectReplacementTxn_FetchReceivedBy(SearchObject);
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

        public List<LinenConemnationModel> LLSLinenInjectionTxn_FetchDONo(LinenConemnationModel SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(FollowupCarFetch), Level.Info.ToString());
                var result = _FetchDAL.LLSLinenInjectionTxn_FetchDONo(SearchObject);
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

        public List<UserAreaFetch> LLSLinenInventoryTxn_FetchUserAreaCode(UserAreaFetch SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(FollowupCarFetch), Level.Info.ToString());
                var result = _FetchDAL.LLSLinenInventoryTxn_FetchUserAreaCode(SearchObject);
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

        public List<UserAreaFetch> LLSLinenInventoryTxn_FetchVerifiedBy(UserAreaFetch SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(FollowupCarFetch), Level.Info.ToString());
                var result = _FetchDAL.LLSLinenInventoryTxn_FetchVerifiedBy(SearchObject);
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

        public List<UserAreaFetch> LLSLinenInventoryTxnDet_FetchLinenCode(UserAreaFetch SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(FollowupCarFetch), Level.Info.ToString());
                var result = _FetchDAL.LLSLinenInventoryTxnDet_FetchLinenCode(SearchObject);
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

        public List<UserAreaFetch> LLSLinenInventoryTxnDet_FetchLinenCodeUserArea(UserAreaFetch SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(FollowupCarFetch), Level.Info.ToString());
                var result = _FetchDAL.LLSLinenInventoryTxnDet_FetchLinenCodeUserArea(SearchObject);
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
        #endregion

        #region CRMRequest Asset

        public List<CRMWorkorderStaffFetch> CrmAssetNoFetch(CRMWorkorderStaffFetch SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(CrmAssetNoFetch), Level.Info.ToString());
                var result = _FetchDAL.CrmAssetNoFetch(SearchObject);
                //var result = _FetchDAL.AssetNoFetch(SearchObject);
                Log4NetLogger.LogExit(_FileName, nameof(CrmAssetNoFetch), Level.Info.ToString());
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

        #endregion
        public List<Arp> ArpBerNo(Arp SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(ArpBerNo), Level.Info.ToString());
                var result = _FetchDAL.ArpBerNo(SearchObject);
                Log4NetLogger.LogExit(_FileName, nameof(ArpBerNo), Level.Info.ToString());
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
        public List<Arp> ArpAssetNo(Arp SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(ArpAssetNo), Level.Info.ToString());
                var result = _FetchDAL.ArpAssetNo(SearchObject);
                Log4NetLogger.LogExit(_FileName, nameof(ArpAssetNo), Level.Info.ToString());
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