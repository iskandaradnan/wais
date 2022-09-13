namespace UETrack.Application.Web
{
    using CP.Framework.Common.Logging;
    using CP.UETrack.Application.Web.API;
    using CP.UETrack.Application.Web.Filter;
    using CP.UETrack.Model;
    using CP.UETrack.Model.BEMS;
    using CP.UETrack.Model.FetchModels;
    using CP.UETrack.Model.LLS;
    using CP.UETrack.Model.VM;
    using Helpers;
    using System.Net.Http;
    using System.Threading.Tasks;
    using System.Web.Http;
    using static CP.UETrack.Model.FetchModels.ModelSearching;

    [RoutePrefix("api/Fetch")]
    [WebApiAuthentication]
    public class FetchAPIController : BaseApiController
    {
        private readonly string _FileName = nameof(SearchAPIController);
        [HttpPost(nameof(FetchRecords))]
        public async Task<HttpResponseMessage> FetchRecords(HttpRequestMessage request, [FromBody] UMStaffSearch SearchObject)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(FetchRecords), Level.Info.ToString());
            var result = await RestHelper.ApiPost("Fetch/FetchRecords", SearchObject);
            Log4NetLogger.LogEntry(_FileName, nameof(FetchRecords), Level.Info.ToString());
            return result;
        }
        [HttpPost(nameof(FetchItemMstdetais))]
        public async Task<HttpResponseMessage> FetchItemMstdetais(HttpRequestMessage request, [FromBody] ItemMstFetchEntity SearchObject)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(FetchItemMstdetais), Level.Info.ToString());
            var result = await RestHelper.ApiPost("Fetch/FetchItemMstdetais", SearchObject);
            Log4NetLogger.LogEntry(_FileName, nameof(FetchItemMstdetais), Level.Info.ToString());
            return result;
        }
        [HttpPost(nameof(TypeCodeFetch))]
        public async Task<HttpResponseMessage> TypeCodeFetch(HttpRequestMessage request, [FromBody] TypeCodeSearch SearchObject)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(TypeCodeFetch), Level.Info.ToString());
            var result = await RestHelper.ApiPost("Fetch/TypeCodeFetch", SearchObject);
            Log4NetLogger.LogEntry(_FileName, nameof(TypeCodeFetch), Level.Info.ToString());
            return result;
        }

        

        [HttpPost(nameof(FetchTaskCode))]
        public async Task<HttpResponseMessage> FetchTaskCode(HttpRequestMessage request, [FromBody] EngAssetTypeCodeStandardTasksFetch SearchObject)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(FetchItemMstdetais), Level.Info.ToString());
            var result = await RestHelper.ApiPost("Fetch/FetchTaskCode", SearchObject);
            Log4NetLogger.LogEntry(_FileName, nameof(FetchItemMstdetais), Level.Info.ToString());
            return result;
        }

        [HttpPost(nameof(LocationCodeFetch))]
        public async Task<HttpResponseMessage> LocationCodeFetch(HttpRequestMessage request, [FromBody] UserLocationCodeSearch SearchObject)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(LocationCodeFetch), Level.Info.ToString());
            var result = await RestHelper.ApiPost("Fetch/LocationCodeFetch", SearchObject);
            Log4NetLogger.LogEntry(_FileName, nameof(LocationCodeFetch), Level.Info.ToString());
            return result;
        }
        [HttpPost(nameof(ManufacturerFetch))]
        public async Task<HttpResponseMessage> ManufacturerFetch(HttpRequestMessage request, [FromBody] ManufacturerSearch SearchObject)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(ManufacturerFetch), Level.Info.ToString());
            var result = await RestHelper.ApiPost("Fetch/ManufacturerFetch", SearchObject);
            Log4NetLogger.LogEntry(_FileName, nameof(ManufacturerFetch), Level.Info.ToString());
            return result;
        }
        [HttpPost(nameof(ModelFetch))]
        public async Task<HttpResponseMessage> ModelFetch(HttpRequestMessage request, [FromBody] ModelSearch SearchObject)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(ModelFetch), Level.Info.ToString());
            var result = await RestHelper.ApiPost("Fetch/ModelFetch", SearchObject);
            Log4NetLogger.LogEntry(_FileName, nameof(ModelFetch), Level.Info.ToString());
            return result;
        }
        [HttpPost(nameof(FetchRescheduleWOdetails))]
        public async Task<HttpResponseMessage> FetchRescheduleWOdetails(HttpRequestMessage request, [FromBody] RescheduleWOFetchModel SearchObject)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(FetchItemMstdetais), Level.Info.ToString());
            var result = await RestHelper.ApiPost("Fetch/FetchRescheduleWOdetails", SearchObject);
            Log4NetLogger.LogEntry(_FileName, nameof(FetchItemMstdetais), Level.Info.ToString());
            return result;
        }
        [HttpPost(nameof(AssetPreRegistrationNoFetch))]
        public async Task<HttpResponseMessage> AssetPreRegistrationNoFetch(HttpRequestMessage request, [FromBody] AssetPreRegistrationNoSearch SearchObject)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(AssetPreRegistrationNoFetch), Level.Info.ToString());
            var result = await RestHelper.ApiPost("Fetch/AssetPreRegistrationNoFetch", SearchObject);
            Log4NetLogger.LogEntry(_FileName, nameof(AssetPreRegistrationNoFetch), Level.Info.ToString());
            return result;
        }
        [HttpPost(nameof(FetchWarrantyProvider))]
        public async Task<HttpResponseMessage> FetchWarrantyProvider(HttpRequestMessage request, [FromBody] AssetRegisterWarrantyProviderGrid SearchObject)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(FetchWarrantyProvider), Level.Info.ToString());
            var result = await RestHelper.ApiPost("Fetch/FetchWarrantyProvider", SearchObject);
            Log4NetLogger.LogEntry(_FileName, nameof(FetchWarrantyProvider), Level.Info.ToString());
            return result;
        }

        [HttpPost(nameof(LevelCodeFetch))]
        public async Task<HttpResponseMessage> LevelCodeFetch(HttpRequestMessage request, [FromBody] LevelFetchModel SearchObject)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(FetchWarrantyProvider), Level.Info.ToString());
            var result = await RestHelper.ApiPost("Fetch/LevelCodeFetch", SearchObject);
            Log4NetLogger.LogEntry(_FileName, nameof(FetchWarrantyProvider), Level.Info.ToString());
            return result;
        }
        [HttpPost(nameof(CompanyStaffFetch))]
        public async Task<HttpResponseMessage> CompanyStaffFetch(HttpRequestMessage request, [FromBody] CompanyStaffFetchModel SearchObject)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(FetchWarrantyProvider), Level.Info.ToString());
            var result = await RestHelper.ApiPost("Fetch/CompanyStaffFetch", SearchObject);
            Log4NetLogger.LogEntry(_FileName, nameof(FetchWarrantyProvider), Level.Info.ToString());
            return result;
        }
        [HttpPost(nameof(FacilityStaffFetch))]
        public async Task<HttpResponseMessage> FacilityStaffFetch(HttpRequestMessage request, [FromBody] FacilityStaffFetchModel SearchObject)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(FetchWarrantyProvider), Level.Info.ToString());
            var result = await RestHelper.ApiPost("Fetch/FacilityStaffFetch", SearchObject);
            Log4NetLogger.LogEntry(_FileName, nameof(FetchWarrantyProvider), Level.Info.ToString());
            return result;
        }
        [HttpPost(nameof(AssetNoFetch))]
        public async Task<HttpResponseMessage> AssetNoFetch(HttpRequestMessage request, [FromBody] WarrantyManagementSearch SearchObject)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(AssetNoFetch), Level.Info.ToString());
            var result = await RestHelper.ApiPost("Fetch/AssetNoFetch", SearchObject);
            Log4NetLogger.LogEntry(_FileName, nameof(AssetNoFetch), Level.Info.ToString());
            return result;
        }
        [HttpPost(nameof(UserAreaFetch))]
        public async Task<HttpResponseMessage> UserAreaFetch(HttpRequestMessage request, [FromBody] UserAreaFetch SearchObject)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(UserAreaFetch), Level.Info.ToString());
            var result = await RestHelper.ApiPost("Fetch/UserAreaFetch", SearchObject);
            Log4NetLogger.LogEntry(_FileName, nameof(UserAreaFetch), Level.Info.ToString());
            return result;
        }
        [HttpPost(nameof(StockAdjustmentFetchModel))]
        public async Task<HttpResponseMessage> StockAdjustmentFetchModel(HttpRequestMessage request, [FromBody] StockAdjustmentFetchModel SearchObject)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(StockAdjustmentFetchModel), Level.Info.ToString());
            var result = await RestHelper.ApiPost("Fetch/StockAdjustmentFetchModel", SearchObject);
            Log4NetLogger.LogEntry(_FileName, nameof(StockAdjustmentFetchModel), Level.Info.ToString());
            return result;
        }
        [HttpPost(nameof(ParentAssetNoFetch))]
        public async Task<HttpResponseMessage> ParentAssetNoFetch(HttpRequestMessage request, [FromBody] ParentAssetNoSearch SearchObject)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(ParentAssetNoFetch), Level.Info.ToString());
            var result = await RestHelper.ApiPost("Fetch/ParentAssetNoFetch", SearchObject);
            Log4NetLogger.LogEntry(_FileName, nameof(ParentAssetNoFetch), Level.Info.ToString());
            return result;
        }
        [HttpPost(nameof(FacilityWorkAssetNoFetch))]
        public async Task<HttpResponseMessage> FacilityWorkAssetNoFetch(HttpRequestMessage request, [FromBody] ParentAssetNoSearch SearchObject)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(FacilityWorkAssetNoFetch), Level.Info.ToString());
            var result = await RestHelper.ApiPost("Fetch/FacilityWorkAssetNoFetch", SearchObject);
            Log4NetLogger.LogEntry(_FileName, nameof(FacilityWorkAssetNoFetch), Level.Info.ToString());
            return result;
        }
        [HttpPost(nameof(AssetClassificationCodeFetch))]
        public async Task<HttpResponseMessage> AssetClassificationCodeFetch(HttpRequestMessage request, [FromBody] AssetClassificationFetch SearchObject)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(AssetClassificationCodeFetch), Level.Info.ToString());
            var result = await RestHelper.ApiPost("Fetch/AssetClassificationCodeFetch", SearchObject);
            Log4NetLogger.LogEntry(_FileName, nameof(AssetClassificationCodeFetch), Level.Info.ToString());
            return result;
        }
        [HttpPost(nameof(ItemCodeFetch))]
        public async Task<HttpResponseMessage> ItemCodeFetch(HttpRequestMessage request, [FromBody] ItemCodeFetch SearchObject)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(ItemCodeFetch), Level.Info.ToString());
            var result = await RestHelper.ApiPost("Fetch/ItemCodeFetch", SearchObject);
            Log4NetLogger.LogEntry(_FileName, nameof(ItemCodeFetch), Level.Info.ToString());
            return result;
        }
        [HttpPost(nameof(SNFAssetFetch))]
        public async Task<HttpResponseMessage> SNFAssetFetch(HttpRequestMessage request, [FromBody] SNFAssetFetchEntity SearchObject)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(SNFAssetFetch), Level.Info.ToString());
            var result = await RestHelper.ApiPost("Fetch/SNFAssetFetch", SearchObject);
            Log4NetLogger.LogEntry(_FileName, nameof(SNFAssetFetch), Level.Info.ToString());
            return result;
        }

        [HttpPost(nameof(FetchCheckListItemDetails))]
        public async Task<HttpResponseMessage> FetchCheckListItemDetails(HttpRequestMessage request, [FromBody] PPMCheckListFetchItem SearchObject)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(FetchCheckListItemDetails), Level.Info.ToString());
            var result = await RestHelper.ApiPost("Fetch/FetchCheckListItemDetails", SearchObject);
            Log4NetLogger.LogEntry(_FileName, nameof(FetchCheckListItemDetails), Level.Info.ToString());
            return result;
        }
        [HttpPost(nameof(FetchSNFDetails))]
        public async Task<HttpResponseMessage> FetchSNFDetails(HttpRequestMessage request, [FromBody] SNFfetchEntity SearchObject)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(FetchSNFDetails), Level.Info.ToString());
            var result = await RestHelper.ApiPost("Fetch/FetchSNFDetails", SearchObject);
            Log4NetLogger.LogEntry(_FileName, nameof(FetchSNFDetails), Level.Info.ToString());
            return result;
        }

        [HttpPost(nameof(BERAssetNoFetch))]
        public async Task<HttpResponseMessage> BERAssetNoFetch(HttpRequestMessage request, [FromBody] BERAssetNoFetch SearchObject)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(BERAssetNoFetch), Level.Info.ToString());
            var result = await RestHelper.ApiPost("Fetch/BERAssetNoFetch", SearchObject);
            Log4NetLogger.LogEntry(_FileName, nameof(BERAssetNoFetch), Level.Info.ToString());
            return result;
        }
        [HttpPost(nameof(BERRejectedNoFetch))]
        public async Task<HttpResponseMessage> BERRejectedNoFetch(HttpRequestMessage request, [FromBody] BERRejectedNoFetch SearchObject)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(BERRejectedNoFetch), Level.Info.ToString());
            var result = await RestHelper.ApiPost("Fetch/BERRejectedNoFetch", SearchObject);
            Log4NetLogger.LogEntry(_FileName, nameof(BERRejectedNoFetch), Level.Info.ToString());
            return result;
        }

        [HttpPost(nameof(AssetQRCodePrintFetchModel))]
        public async Task<HttpResponseMessage> AssetQRCodePrintFetchModel(HttpRequestMessage request, [FromBody] AssetQRCodePrintFetchModel SearchObject)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(AssetQRCodePrintFetchModel), Level.Info.ToString());
            var result = await RestHelper.ApiPost("Fetch/AssetQRCodePrintFetchModel", SearchObject);
            Log4NetLogger.LogEntry(_FileName, nameof(AssetQRCodePrintFetchModel), Level.Info.ToString());
            return result;
        }
        [HttpPost(nameof(UserLocationQRCodePrintingFetchModel))]
        public async Task<HttpResponseMessage> UserLocationQRCodePrintingFetchModel(HttpRequestMessage request, [FromBody] UserLocationQRCodePrintingFetchModel SearchObject)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(UserLocationQRCodePrintingFetchModel), Level.Info.ToString());
            var result = await RestHelper.ApiPost("Fetch/UserLocationQRCodePrintingFetchModel", SearchObject);
            Log4NetLogger.LogEntry(_FileName, nameof(UserLocationQRCodePrintingFetchModel), Level.Info.ToString());
            return result;
        }

        [HttpPost(nameof(UserAreaQRCodePrintingFetchModel))]
        public async Task<HttpResponseMessage> UserAreaQRCodePrintingFetchModel(HttpRequestMessage request, [FromBody] UserAreaQRCodePrintingFetchModel SearchObject)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(UserAreaQRCodePrintingFetchModel), Level.Info.ToString());
            var result = await RestHelper.ApiPost("Fetch/UserAreaQRCodePrintingFetchModel", SearchObject);
            Log4NetLogger.LogEntry(_FileName, nameof(UserAreaQRCodePrintingFetchModel), Level.Info.ToString());
            return result;
        }
        [HttpPost(nameof(CRMWorkorderRequestFetch))]
        public async Task<HttpResponseMessage> CRMWorkorderRequestFetch(HttpRequestMessage request, [FromBody] CRMWorkorderRequestFetch SearchObject)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(CRMWorkorderRequestFetch), Level.Info.ToString());
            var result = await RestHelper.ApiPost("Fetch/CRMWorkorderRequestFetch", SearchObject);
            Log4NetLogger.LogEntry(_FileName, nameof(CRMWorkorderRequestFetch), Level.Info.ToString());
            return result;
        }
        [HttpPost(nameof(TAndCCRMRequestNoFetch))]
        public async Task<HttpResponseMessage> TAndCCRMRequestNoFetch(HttpRequestMessage request, [FromBody] TAndCCRMRequestNoFetchSearch SearchObject)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(TAndCCRMRequestNoFetch), Level.Info.ToString());
            var result = await RestHelper.ApiPost("Fetch/TAndCCRMRequestNoFetch", SearchObject);
            Log4NetLogger.LogEntry(_FileName, nameof(TAndCCRMRequestNoFetch), Level.Info.ToString());
            return result;
        }
        [HttpPost(nameof(PorteringAssetNoFetch))]
        public async Task<HttpResponseMessage> PorteringAssetNoFetch(HttpRequestMessage request, [FromBody] PortAssetFetchModel obj)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(PorteringAssetNoFetch), Level.Info.ToString());
            var result = await RestHelper.ApiPost("Fetch/PorteringAssetNoFetch", obj);
            Log4NetLogger.LogEntry(_FileName, nameof(PorteringAssetNoFetch), Level.Info.ToString());
            return result;
        }

        [HttpPost(nameof(PorteringWorkOrderNoFetch))]
        public async Task<HttpResponseMessage> PorteringWorkOrderNoFetch(HttpRequestMessage request, [FromBody] PortAssetFetchModel obj)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(PorteringWorkOrderNoFetch), Level.Info.ToString());
            var result = await RestHelper.ApiPost("Fetch/PorteringWorkOrderNoFetch", obj);
            Log4NetLogger.LogEntry(_FileName, nameof(PorteringWorkOrderNoFetch), Level.Info.ToString());
            return result;
        }

        [HttpPost(nameof(EODCaptureAssetFetch))]
        public async Task<HttpResponseMessage> EODCaptureAssetFetch(HttpRequestMessage request, [FromBody] EODCaptureAssetFetch SearchObject)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(EODCaptureAssetFetch), Level.Info.ToString());
            var result = await RestHelper.ApiPost("Fetch/EODCaptureAssetFetch", SearchObject);
            Log4NetLogger.LogEntry(_FileName, nameof(EODCaptureAssetFetch), Level.Info.ToString());
            return result;
        }
        [HttpPost(nameof(EODCaptureManufacturer))]
        public async Task<HttpResponseMessage> EODCaptureManufacturer(HttpRequestMessage request, [FromBody] EODCaptureManufacturer SearchObject)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(EODCaptureManufacturer), Level.Info.ToString());
            var result = await RestHelper.ApiPost("Fetch/EODCaptureManufacturer", SearchObject);
            Log4NetLogger.LogEntry(_FileName, nameof(EODCaptureManufacturer), Level.Info.ToString());
            return result;
        }
        [HttpPost(nameof(EODCaptureModel))]
        public async Task<HttpResponseMessage> EODCaptureModel(HttpRequestMessage request, [FromBody] EODCaptureModel SearchObject)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(EODCaptureModel), Level.Info.ToString());
            var result = await RestHelper.ApiPost("Fetch/EODCaptureModel", SearchObject);
            Log4NetLogger.LogEntry(_FileName, nameof(EODCaptureModel), Level.Info.ToString());
            return result;
        }
        [HttpPost(nameof(CustomerCodeFetch))]
        public async Task<HttpResponseMessage> CustomerCodeFetch(HttpRequestMessage request, [FromBody] CustomerFetch SearchObject)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(CustomerCodeFetch), Level.Info.ToString());
            var result = await RestHelper.ApiPost("Fetch/CustomerCodeFetch", SearchObject);
            Log4NetLogger.LogEntry(_FileName, nameof(CustomerCodeFetch), Level.Info.ToString());
            return result;
        }
        [HttpPost(nameof(CRMRequestAssetFetch))]
        public async Task<HttpResponseMessage> CRMRequestAssetFetch(HttpRequestMessage request, [FromBody] CRMRequestAssetFetch SearchObject)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(CRMRequestAssetFetch), Level.Info.ToString());
            var result = await RestHelper.ApiPost("Fetch/CRMRequestAssetFetch", SearchObject);
            Log4NetLogger.LogEntry(_FileName, nameof(CRMRequestAssetFetch), Level.Info.ToString());
            return result;
        }
        [HttpPost(nameof(CRMWorkorderStaffFetch))]
        public async Task<HttpResponseMessage> CRMWorkorderStaffFetch(HttpRequestMessage request, [FromBody] CRMWorkorderStaffFetch SearchObject)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(CRMWorkorderStaffFetch), Level.Info.ToString());
            var result = await RestHelper.ApiPost("Fetch/CRMWorkorderStaffFetch", SearchObject);
            Log4NetLogger.LogEntry(_FileName, nameof(CRMWorkorderStaffFetch), Level.Info.ToString());
            return result;
        }
        [HttpPost(nameof(ContractorNameFetch))]
        public async Task<HttpResponseMessage> ContractorNameFetch(HttpRequestMessage request, [FromBody] ContractorNameSearch SearchObject)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(ContractorNameFetch), Level.Info.ToString());
            var result = await RestHelper.ApiPost("Fetch/ContractorNameFetch", SearchObject);
            Log4NetLogger.LogEntry(_FileName, nameof(ContractorNameFetch), Level.Info.ToString());
            return result;
        }

        [HttpPost(nameof(BookingAssetNoFetch))]
        public async Task<HttpResponseMessage> BookingAssetNoFetch(HttpRequestMessage request, [FromBody] BookingFetch SearchObject)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(BookingAssetNoFetch), Level.Info.ToString());
            var result = await RestHelper.ApiPost("Fetch/BookingAssetNoFetch", SearchObject);
            Log4NetLogger.LogEntry(_FileName, nameof(BookingAssetNoFetch), Level.Info.ToString());
            return result;
        }

        [HttpPost(nameof(BookingWorkOrderNoFetch))]
        public async Task<HttpResponseMessage> BookingWorkOrderNoFetch(HttpRequestMessage request, [FromBody] BookingFetch SearchObject)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(BookingWorkOrderNoFetch), Level.Info.ToString());
            var result = await RestHelper.ApiPost("Fetch/BookingWorkOrderNoFetch", SearchObject);
            Log4NetLogger.LogEntry(_FileName, nameof(BookingWorkOrderNoFetch), Level.Info.ToString());
            return result;
        }
        [HttpPost(nameof(UserShiftLeaveDetailsFetch))]
        public async Task<HttpResponseMessage> UserShiftLeaveDetailsFetch(HttpRequestMessage request, [FromBody] UserShiftLeaveDetailsFetch SearchObject)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(UserShiftLeaveDetailsFetch), Level.Info.ToString());
            var result = await RestHelper.ApiPost("Fetch/UserShiftLeaveDetailsFetch", SearchObject);
            Log4NetLogger.LogEntry(_FileName, nameof(UserShiftLeaveDetailsFetch), Level.Info.ToString());
            return result;
        }
        [HttpPost(nameof(UserTainingParticipantFetch))]
        public async Task<HttpResponseMessage> UserTainingParticipantFetch(HttpRequestMessage request, [FromBody] UserTainingParticipantFetch SearchObject)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(UserTainingParticipantFetch), Level.Info.ToString());
            var result = await RestHelper.ApiPost("Fetch/UserTainingParticipantFetch", SearchObject);
            Log4NetLogger.LogEntry(_FileName, nameof(UserTainingParticipantFetch), Level.Info.ToString());
            return result;
        }
        [HttpPost(nameof(FilureSymptomCodeFetch))]
        public async Task<HttpResponseMessage> FilureSymptomCodeFetch(HttpRequestMessage request, [FromBody] FilureSymptomCodeFetch SearchObject)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(FilureSymptomCodeFetch), Level.Info.ToString());
            var result = await RestHelper.ApiPost("Fetch/FilureSymptomCodeFetch", SearchObject);
            Log4NetLogger.LogEntry(_FileName, nameof(FilureSymptomCodeFetch), Level.Info.ToString());
            return result;
        }
        [HttpPost(nameof(FollowupCarFetch))]
        public async Task<HttpResponseMessage> FollowupCarFetch(HttpRequestMessage request, [FromBody] FollowupCarFetch SearchObject)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(FollowupCarFetch), Level.Info.ToString());
            var result = await RestHelper.ApiPost("Fetch/FollowupCarFetch", SearchObject);
            Log4NetLogger.LogEntry(_FileName, nameof(FollowupCarFetch), Level.Info.ToString());
            return result;
        }


        [HttpPost(nameof(BlockCascCodeFetch))]
        public async Task<HttpResponseMessage> BlockCascCodeFetch(HttpRequestMessage request, [FromBody] AreaFetch SearchObject)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(BlockCascCodeFetch), Level.Info.ToString());
            var result = await RestHelper.ApiPost("Fetch/BlockCascCodeFetch", SearchObject);
            Log4NetLogger.LogEntry(_FileName, nameof(BlockCascCodeFetch), Level.Info.ToString());
            return result;
        }

        [HttpPost(nameof(LevelCascCodeFetch))]
        public async Task<HttpResponseMessage> LevelCascCodeFetch(HttpRequestMessage request, [FromBody] AreaFetch SearchObject)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(LevelCascCodeFetch), Level.Info.ToString());
            var result = await RestHelper.ApiPost("Fetch/LevelCascCodeFetch", SearchObject);
            Log4NetLogger.LogEntry(_FileName, nameof(LevelCascCodeFetch), Level.Info.ToString());
            return result;
        }
        [HttpPost(nameof(AreaCascCodeFetch))]
        public async Task<HttpResponseMessage> AreaCascCodeFetch(HttpRequestMessage request, [FromBody] AreaFetch SearchObject)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(AreaCascCodeFetch), Level.Info.ToString());
            var result = await RestHelper.ApiPost("Fetch/AreaCascCodeFetch", SearchObject);
            Log4NetLogger.LogEntry(_FileName, nameof(AreaCascCodeFetch), Level.Info.ToString());
            return result;
        }

        [HttpPost(nameof(BookingLocationFetch))]
        public async Task<HttpResponseMessage> BookingLocationFetch(HttpRequestMessage request, [FromBody] UserLocationCodeSearch SearchObject)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(BookingLocationFetch), Level.Info.ToString());
            var result = await RestHelper.ApiPost("Fetch/BookingLocationFetch", SearchObject);
            Log4NetLogger.LogEntry(_FileName, nameof(BookingLocationFetch), Level.Info.ToString());
            return result;
        }
        [HttpPost(nameof(CRMFetchRequestTypedetais))]
        public async Task<HttpResponseMessage> CRMFetchRequestTypedetais(HttpRequestMessage request, [FromBody] CRMRequestType SearchObject)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(CRMFetchRequestTypedetais), Level.Info.ToString());
            var result = await RestHelper.ApiPost("Fetch/CRMFetchRequestTypedetais", SearchObject);
            Log4NetLogger.LogEntry(_FileName, nameof(CRMFetchRequestTypedetais), Level.Info.ToString());
            return result;
        }
        [HttpPost(nameof(FetchPartNo))]
        public async Task<HttpResponseMessage> FetchPartNo(HttpRequestMessage request, [FromBody] ItemMstFetchEntity SearchObject)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(FetchPartNo), Level.Info.ToString());
            var result = await RestHelper.ApiPost("Fetch/FetchPartNo", SearchObject);
            Log4NetLogger.LogEntry(_FileName, nameof(FetchPartNo), Level.Info.ToString());
            return result;
        }
        [HttpPost(nameof(FetchItemNo))]
        public async Task<HttpResponseMessage> FetchItemNo(HttpRequestMessage request, [FromBody] ItemMstFetchEntity SearchObject)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(FetchItemNo), Level.Info.ToString());
            var result = await RestHelper.ApiPost("Fetch/FetchItemNo", SearchObject);
            Log4NetLogger.LogEntry(_FileName, nameof(FetchItemNo), Level.Info.ToString());
            return result;
        }

        #region LLS Fetch and Search
        [HttpPost(nameof(DepartmentCascCodeFetch))]
        public async Task<HttpResponseMessage> DepartmentCascCodeFetch(HttpRequestMessage request, [FromBody] DepartmentFetch SearchObject)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(DepartmentCascCodeFetch), Level.Info.ToString());
            var result = await RestHelper.ApiPost("Fetch/DepartmentCascCodeFetch", SearchObject);
            Log4NetLogger.LogEntry(_FileName, nameof(DepartmentCascCodeFetch), Level.Info.ToString());
            return result;
        }

        [HttpPost(nameof(LLSUserAreaDetailsLocationMstDet_FetchLocCode))]
        public async Task<HttpResponseMessage> LLSUserAreaDetailsLocationMstDet_FetchLocCode(HttpRequestMessage request, [FromBody] UserAreaFetchs SearchObject)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(DepartmentCascCodeFetch), Level.Info.ToString());
            var result = await RestHelper.ApiPost("Fetch/LLSUserAreaDetailsLocationMstDet_FetchLocCode", SearchObject);
            Log4NetLogger.LogEntry(_FileName, nameof(LLSUserAreaDetailsLocationMstDet_FetchLocCode), Level.Info.ToString());
            return result;
        }

        [HttpPost(nameof(LinenItemCascCodeFetch))]
        public async Task<HttpResponseMessage> LinenItemCascCodeFetch(HttpRequestMessage request, [FromBody] LinenItemCodeFetch SearchObject)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(LinenItemCascCodeFetch), Level.Info.ToString());
            var result = await RestHelper.ApiPost("Fetch/LinenItemCascCodeFetch", SearchObject);
            Log4NetLogger.LogEntry(_FileName, nameof(LinenItemCascCodeFetch), Level.Info.ToString());
            return result;
        }

        [HttpPost(nameof(LocationCascCodeFetch))]
        public async Task<HttpResponseMessage> LocationCascCodeFetch(HttpRequestMessage request, [FromBody] LocationCodeFetch SearchObject)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(LocationCascCodeFetch), Level.Info.ToString());
            var result = await RestHelper.ApiPost("Fetch/LocationCascCodeFetch", SearchObject);
            Log4NetLogger.LogEntry(_FileName, nameof(LocationCascCodeFetch), Level.Info.ToString());
            return result;
        }

        [HttpPost(nameof(Cleanlinenrequest_UserareaCodeFetch))]
        public async Task<HttpResponseMessage> Cleanlinenrequest_UserareaCodeFetch(HttpRequestMessage request, [FromBody] CleanLinenRequestModel SearchObject)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Cleanlinenrequest_UserareaCodeFetch), Level.Info.ToString());
            var result = await RestHelper.ApiPost("Fetch/Cleanlinenrequest_UserareaCodeFetch", SearchObject);
            Log4NetLogger.LogEntry(_FileName, nameof(Cleanlinenrequest_UserareaCodeFetch), Level.Info.ToString());
            return result;
        }

        [HttpPost(nameof(CleanLinenRequestTxn_FetchLocCode))]
        public async Task<HttpResponseMessage> CleanLinenRequestTxn_FetchLocCode(HttpRequestMessage request, [FromBody] CleanLinenRequestModel SearchObject)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(CleanLinenRequestTxn_FetchLocCode), Level.Info.ToString());
            var result = await RestHelper.ApiPost("Fetch/CleanLinenRequestTxn_FetchLocCode", SearchObject);
            Log4NetLogger.LogEntry(_FileName, nameof(CleanLinenRequestTxn_FetchLocCode), Level.Info.ToString());
            return result;
        }


        [HttpPost(nameof(Cleanlinenrequest_FetchrequestBy))]
        public async Task<HttpResponseMessage> Cleanlinenrequest_FetchrequestBy(HttpRequestMessage request, [FromBody] CleanLinenRequestModel SearchObject)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Cleanlinenrequest_FetchrequestBy), Level.Info.ToString());
            var result = await RestHelper.ApiPost("Fetch/Cleanlinenrequest_FetchrequestBy", SearchObject);
            Log4NetLogger.LogEntry(_FileName, nameof(Cleanlinenrequest_FetchrequestBy), Level.Info.ToString());
            return result;
        }

        [HttpPost(nameof(Cleanlinenrequestlinenitem_LinenCodeFetch))]
        public async Task<HttpResponseMessage> Cleanlinenrequestlinenitem_LinenCodeFetch(HttpRequestMessage request, [FromBody] LocationCodeFetch SearchObject)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Cleanlinenrequestlinenitem_LinenCodeFetch), Level.Info.ToString());
            var result = await RestHelper.ApiPost("Fetch/Cleanlinenrequestlinenitem_LinenCodeFetch", SearchObject);
            Log4NetLogger.LogEntry(_FileName, nameof(Cleanlinenrequestlinenitem_LinenCodeFetch), Level.Info.ToString());
            return result;
        }

        [HttpPost(nameof(CleanLinenRequestLinenBag_FetchLaundryBag))]
        public async Task<HttpResponseMessage> CleanLinenRequestLinenBag_FetchLaundryBag(HttpRequestMessage request, [FromBody] LinenInjectionModel SearchObject)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(CleanLinenRequestLinenBag_FetchLaundryBag), Level.Info.ToString());
            var result = await RestHelper.ApiPost("Fetch/CleanLinenRequestLinenBag_FetchLaundryBag", SearchObject);
            Log4NetLogger.LogEntry(_FileName, nameof(CleanLinenRequestLinenBag_FetchLaundryBag), Level.Info.ToString());
            return result;
        }

        [HttpPost(nameof(CleanLinenDespatchTxn_FetchReceivedBy))]
        public async Task<HttpResponseMessage> CleanLinenDespatchTxn_FetchReceivedBy(HttpRequestMessage request, [FromBody] CleanLinenDespatchModel SearchObject)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(CleanLinenDespatchTxn_FetchReceivedBy), Level.Info.ToString());
            var result = await RestHelper.ApiPost("Fetch/CleanLinenDespatchTxn_FetchReceivedBy", SearchObject);
            Log4NetLogger.LogEntry(_FileName, nameof(CleanLinenDespatchTxn_FetchReceivedBy), Level.Info.ToString());
            return result;
        }

        [HttpPost(nameof(CleanLinenDespatchTxnDet_FetchLinenCode))]
        public async Task<HttpResponseMessage> CleanLinenDespatchTxnDet_FetchLinenCode(HttpRequestMessage request, [FromBody] CleanLinenDespatchModel SearchObject)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(CleanLinenDespatchTxnDet_FetchLinenCode), Level.Info.ToString());
            var result = await RestHelper.ApiPost("Fetch/CleanLinenDespatchTxnDet_FetchLinenCode", SearchObject);
            Log4NetLogger.LogEntry(_FileName, nameof(CleanLinenDespatchTxnDet_FetchLinenCode), Level.Info.ToString());
            return result;
        }

        #region CleanLinenIssue
        [HttpPost(nameof(CleanLinenIssueTxn_FetchCLRDocNo))]
        public async Task<HttpResponseMessage> CleanLinenIssueTxn_FetchCLRDocNo(HttpRequestMessage request, [FromBody] CleanLinenIssueModel SearchObject)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(CleanLinenIssueTxn_FetchCLRDocNo), Level.Info.ToString());
            var result = await RestHelper.ApiPost("Fetch/CleanLinenIssueTxn_FetchCLRDocNo", SearchObject);
            Log4NetLogger.LogEntry(_FileName, nameof(CleanLinenIssueTxn_FetchCLRDocNo), Level.Info.ToString());
            return result;
        }

        [HttpPost(nameof(CleanLinenIssueTxn_Fetch1stReceivedBy))]
        public async Task<HttpResponseMessage> CleanLinenIssueTxn_Fetch1stReceivedBy(HttpRequestMessage request, [FromBody] CleanLinenIssueModel SearchObject)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(CleanLinenIssueTxn_Fetch1stReceivedBy), Level.Info.ToString());
            var result = await RestHelper.ApiPost("Fetch/CleanLinenIssueTxn_Fetch1stReceivedBy", SearchObject);
            Log4NetLogger.LogEntry(_FileName, nameof(CleanLinenIssueTxn_Fetch1stReceivedBy), Level.Info.ToString());
            return result;
        }

        [HttpPost(nameof(CleanLinenIssueTxn_Fetch2ndReceivedBy))]
        public async Task<HttpResponseMessage> CleanLinenIssueTxn_Fetch2ndReceivedBy(HttpRequestMessage request, [FromBody] CleanLinenIssueModel SearchObject)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(CleanLinenIssueTxn_Fetch2ndReceivedBy), Level.Info.ToString());
            var result = await RestHelper.ApiPost("Fetch/CleanLinenIssueTxn_Fetch2ndReceivedBy", SearchObject);
            Log4NetLogger.LogEntry(_FileName, nameof(CleanLinenIssueTxn_Fetch2ndReceivedBy), Level.Info.ToString());
            return result;
        }
        [HttpPost(nameof(CleanLinenIssueTxn_FetchVerifier))]
        public async Task<HttpResponseMessage> CleanLinenIssueTxn_FetchVerifier(HttpRequestMessage request, [FromBody] CleanLinenIssueModel SearchObject)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(CleanLinenIssueTxn_FetchVerifier), Level.Info.ToString());
            var result = await RestHelper.ApiPost("Fetch/CleanLinenIssueTxn_FetchVerifier", SearchObject);
            Log4NetLogger.LogEntry(_FileName, nameof(CleanLinenIssueTxn_FetchVerifier), Level.Info.ToString());
            return result;
        }

        [HttpPost(nameof(CleanLinenIssueTxn_FetchDeliveredBy))]
        public async Task<HttpResponseMessage> CleanLinenIssueTxn_FetchDeliveredBy(HttpRequestMessage request, [FromBody] CleanLinenIssueModel SearchObject)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(CleanLinenIssueTxn_FetchDeliveredBy), Level.Info.ToString());
            var result = await RestHelper.ApiPost("Fetch/CleanLinenIssueTxn_FetchDeliveredBy", SearchObject);
            Log4NetLogger.LogEntry(_FileName, nameof(CleanLinenIssueTxn_FetchDeliveredBy), Level.Info.ToString());
            return result;
        }

        [HttpPost(nameof(CleanLinenIssueLinenBagTxnDet_FetchLaundryBag))]
        public async Task<HttpResponseMessage> CleanLinenIssueLinenBagTxnDet_FetchLaundryBag(HttpRequestMessage request, [FromBody] CleanLinenIssueModel SearchObject)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(CleanLinenIssueLinenBagTxnDet_FetchLaundryBag), Level.Info.ToString());
            var result = await RestHelper.ApiPost("Fetch/CleanLinenIssueLinenBagTxnDet_FetchLaundryBag", SearchObject);
            Log4NetLogger.LogEntry(_FileName, nameof(CleanLinenIssueLinenBagTxnDet_FetchLaundryBag), Level.Info.ToString());
            return result;
        }

        #endregion

        #endregion
        [HttpPost(nameof(DriverDetailsMstDet_FetchLicenseCode))]
        public async Task<HttpResponseMessage> DriverDetailsMstDet_FetchLicenseCode(HttpRequestMessage request, [FromBody] DriverDetailsModel SearchObject)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(FetchItemNo), Level.Info.ToString());
            var result = await RestHelper.ApiPost("Fetch/DriverDetailsMstDet_FetchLicenseCode", SearchObject);
            Log4NetLogger.LogEntry(_FileName, nameof(FetchItemNo), Level.Info.ToString());
            return result;
        }

        [HttpPost(nameof(LinenAdjustmentTxn_FetchAuthorisedBy))]
        public async Task<HttpResponseMessage> LinenAdjustmentTxn_FetchAuthorisedBy(HttpRequestMessage request, [FromBody] LinenAdjustmentsModel SearchObject)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(FetchItemNo), Level.Info.ToString());
            var result = await RestHelper.ApiPost("Fetch/LinenAdjustmentTxn_FetchAuthorisedBy", SearchObject);
            Log4NetLogger.LogEntry(_FileName, nameof(FetchItemNo), Level.Info.ToString());
            return result;
        }


        [HttpPost(nameof(LinenAdjustmentTxn_FetchInventoryDocNo))]
        public async Task<HttpResponseMessage> LinenAdjustmentTxn_FetchInventoryDocNo(HttpRequestMessage request, [FromBody] LinenAdjustmentsModel SearchObject)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(FetchItemNo), Level.Info.ToString());
            var result = await RestHelper.ApiPost("Fetch/LinenAdjustmentTxn_FetchInventoryDocNo", SearchObject);
            Log4NetLogger.LogEntry(_FileName, nameof(FetchItemNo), Level.Info.ToString());
            return result;
        }

        [HttpPost(nameof(LinenAdjustmentTxnDet_FetchLinenCode))]
        public async Task<HttpResponseMessage> LinenAdjustmentTxnDet_FetchLinenCode(HttpRequestMessage request, [FromBody] LinenAdjustmentsModel SearchObject)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(FetchItemNo), Level.Info.ToString());
            var result = await RestHelper.ApiPost("Fetch/LinenAdjustmentTxnDet_FetchLinenCode", SearchObject);
            Log4NetLogger.LogEntry(_FileName, nameof(FetchItemNo), Level.Info.ToString());
            return result;
        }

        [HttpPost(nameof(VehicleDetailsMstDet_FetchLicenseCode))]
        public async Task<HttpResponseMessage> VehicleDetailsMstDet_FetchLicenseCode(HttpRequestMessage request, [FromBody] VehicleDetailsModel SearchObject)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(FetchItemNo), Level.Info.ToString());
            var result = await RestHelper.ApiPost("Fetch/VehicleDetailsMstDet_FetchLicenseCode", SearchObject);
            Log4NetLogger.LogEntry(_FileName, nameof(FetchItemNo), Level.Info.ToString());
            return result;
        }

        [HttpPost(nameof(LinenInjectionTxnDet_FetchLinenCode))]
        public async Task<HttpResponseMessage> LinenInjectionTxnDet_FetchLinenCode(HttpRequestMessage request, [FromBody] LinenConemnationModel SearchObject)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(FetchItemNo), Level.Info.ToString());
            var result = await RestHelper.ApiPost("Fetch/LinenInjectionTxnDet_FetchLinenCode", SearchObject);
            Log4NetLogger.LogEntry(_FileName, nameof(FetchItemNo), Level.Info.ToString());
            return result;
        }

        [HttpPost(nameof(LinenRepairTxn_FetchRepairedBy))]
        public async Task<HttpResponseMessage> LinenRepairTxn_FetchRepairedBy(HttpRequestMessage request, [FromBody] LinenRepairModel SearchObject)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(FetchItemNo), Level.Info.ToString());
            var result = await RestHelper.ApiPost("Fetch/LinenRepairTxn_FetchRepairedBy", SearchObject);
            Log4NetLogger.LogEntry(_FileName, nameof(FetchItemNo), Level.Info.ToString());
            return result;
        }

        [HttpPost(nameof(LinenRepairTxn_FetchCheckedBy))]
        public async Task<HttpResponseMessage> LinenRepairTxn_FetchCheckedBy(HttpRequestMessage request, [FromBody] LinenRepairModel SearchObject)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(FetchItemNo), Level.Info.ToString());
            var result = await RestHelper.ApiPost("Fetch/LinenRepairTxn_FetchCheckedBy", SearchObject);
            Log4NetLogger.LogEntry(_FileName, nameof(FetchItemNo), Level.Info.ToString());
            return result;
        }

        [HttpPost(nameof(LinenRepairTxnDet_FetchLinenCode))]
        public async Task<HttpResponseMessage> LinenRepairTxnDet_FetchLinenCode(HttpRequestMessage request, [FromBody] LinenRepairModel SearchObject)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(FetchItemNo), Level.Info.ToString());
            var result = await RestHelper.ApiPost("Fetch/LinenRepairTxnDet_FetchLinenCode", SearchObject);
            Log4NetLogger.LogEntry(_FileName, nameof(FetchItemNo), Level.Info.ToString());
            return result;
        }

        [HttpPost(nameof(CentralLinenStoreHKeepingTxn_FetchYear))]
        public async Task<HttpResponseMessage> CentralLinenStoreHKeepingTxn_FetchYear(HttpRequestMessage request, [FromBody] CentralLinenStoreHousekeepingModel SearchObject)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(FetchItemNo), Level.Info.ToString());
            var result = await RestHelper.ApiPost("Fetch/CentralLinenStoreHKeepingTxn_FetchYear", SearchObject);
            Log4NetLogger.LogEntry(_FileName, nameof(FetchItemNo), Level.Info.ToString());
            return result;
        }

        [HttpPost(nameof(CentralLinenStoreHKeepingTxn_FetchMonth))]
        public async Task<HttpResponseMessage> CentralLinenStoreHKeepingTxn_FetchMonth(HttpRequestMessage request, [FromBody] CentralLinenStoreHousekeepingModel SearchObject)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(FetchItemNo), Level.Info.ToString());
            var result = await RestHelper.ApiPost("Fetch/CentralLinenStoreHKeepingTxn_FetchMonth", SearchObject);
            Log4NetLogger.LogEntry(_FileName, nameof(FetchItemNo), Level.Info.ToString());
            return result;
        }

        [HttpPost(nameof(CentralLinenStoreHKeepingTxnDet_FetchDate))]
        public async Task<HttpResponseMessage> CentralLinenStoreHKeepingTxnDet_FetchDate(HttpRequestMessage request, [FromBody] CentralLinenStoreHousekeepingModel SearchObject)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(FetchItemNo), Level.Info.ToString());
            var result = await RestHelper.ApiPost("Fetch/CentralLinenStoreHKeepingTxnDet_FetchDate", SearchObject);
            Log4NetLogger.LogEntry(_FileName, nameof(FetchItemNo), Level.Info.ToString());
            return result;
        }

        [HttpPost(nameof(SoiledLinenCollectionTxn_FetchLaundryPlant))]
        public async Task<HttpResponseMessage> SoiledLinenCollectionTxn_FetchLaundryPlant(HttpRequestMessage request, [FromBody] soildLinencollectionsModel SearchObject)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(FetchItemNo), Level.Info.ToString());
            var result = await RestHelper.ApiPost("Fetch/SoiledLinenCollectionTxn_FetchLaundryPlant", SearchObject);
            Log4NetLogger.LogEntry(_FileName, nameof(FetchItemNo), Level.Info.ToString());
            return result;
        }

        [HttpPost(nameof(SoiledLinenCollectionTxnDet_FetchUserAreaCode))]
        public async Task<HttpResponseMessage> SoiledLinenCollectionTxnDet_FetchUserAreaCode(HttpRequestMessage request, [FromBody] CentralLinenStoreHousekeepingModel SearchObject)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(FetchItemNo), Level.Info.ToString());
            var result = await RestHelper.ApiPost("Fetch/SoiledLinenCollectionTxnDet_FetchUserAreaCode", SearchObject);
            Log4NetLogger.LogEntry(_FileName, nameof(FetchItemNo), Level.Info.ToString());
            return result;
        }

        [HttpPost(nameof(SoiledLinenCollectionTxnDet_FetchLocCode))]
        public async Task<HttpResponseMessage> SoiledLinenCollectionTxnDet_FetchLocCode(HttpRequestMessage request, [FromBody] CentralLinenStoreHousekeepingModel SearchObject)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(FetchItemNo), Level.Info.ToString());
            var result = await RestHelper.ApiPost("Fetch/SoiledLinenCollectionTxnDet_FetchLocCode", SearchObject);
            Log4NetLogger.LogEntry(_FileName, nameof(FetchItemNo), Level.Info.ToString());
            return result;
        }

        [HttpPost(nameof(SoiledLinenCollectionTxnDet_FetchCollectionSchedule))]
        public async Task<HttpResponseMessage> SoiledLinenCollectionTxnDet_FetchCollectionSchedule(HttpRequestMessage request, [FromBody] soildLinencollectionsModel SearchObject)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(FetchItemNo), Level.Info.ToString());
            var result = await RestHelper.ApiPost("Fetch/SoiledLinenCollectionTxnDet_FetchCollectionSchedule", SearchObject);
            Log4NetLogger.LogEntry(_FileName, nameof(FetchItemNo), Level.Info.ToString());
            return result;
        }

        [HttpPost(nameof(SoiledLinenCollectionTxnDet_FetchVerifiedBy))]
        public async Task<HttpResponseMessage> SoiledLinenCollectionTxnDet_FetchVerifiedBy(HttpRequestMessage request, [FromBody] soildLinencollectionsModel SearchObject)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(FetchItemNo), Level.Info.ToString());
            var result = await RestHelper.ApiPost("Fetch/SoiledLinenCollectionTxnDet_FetchVerifiedBy", SearchObject);
            Log4NetLogger.LogEntry(_FileName, nameof(FetchItemNo), Level.Info.ToString());
            return result;
        }

        [HttpPost(nameof(LinenCondemnationTxn_FetchVerifiedBy))]
        public async Task<HttpResponseMessage> LinenCondemnationTxn_FetchVerifiedBy(HttpRequestMessage request, [FromBody] LinenConemnationModel SearchObject)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(FetchItemNo), Level.Info.ToString());
            var result = await RestHelper.ApiPost("Fetch/LinenCondemnationTxn_FetchVerifiedBy", SearchObject);
            Log4NetLogger.LogEntry(_FileName, nameof(FetchItemNo), Level.Info.ToString());
            return result;
        }

        [HttpPost(nameof(LinenCondemnationTxn_FetchInspectedBy))]
        public async Task<HttpResponseMessage> LinenCondemnationTxn_FetchInspectedBy(HttpRequestMessage request, [FromBody] LinenConemnationModel SearchObject)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(FetchItemNo), Level.Info.ToString());
            var result = await RestHelper.ApiPost("Fetch/LinenCondemnationTxn_FetchInspectedBy", SearchObject);
            Log4NetLogger.LogEntry(_FileName, nameof(FetchItemNo), Level.Info.ToString());
            return result;
        }

        [HttpPost(nameof(LinenCondemnationTxnDet_FetchLinenCode))]
        public async Task<HttpResponseMessage> LinenCondemnationTxnDet_FetchLinenCode(HttpRequestMessage request, [FromBody] LinenConemnationModel SearchObject)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(FetchItemNo), Level.Info.ToString());
            var result = await RestHelper.ApiPost("Fetch/LinenCondemnationTxnDet_FetchLinenCode", SearchObject);
            Log4NetLogger.LogEntry(_FileName, nameof(FetchItemNo), Level.Info.ToString());
            return result;
        }

        [HttpPost(nameof(LinenRejectReplacementTxnDet_FetchLinenCode))]
        public async Task<HttpResponseMessage> LinenRejectReplacementTxnDet_FetchLinenCode(HttpRequestMessage request, [FromBody] LinenRejectReplacementModel SearchObject)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(FetchItemNo), Level.Info.ToString());
            var result = await RestHelper.ApiPost("Fetch/LinenRejectReplacementTxnDet_FetchLinenCode", SearchObject);
            Log4NetLogger.LogEntry(_FileName, nameof(FetchItemNo), Level.Info.ToString());
            return result;
        }

        [HttpPost(nameof(LinenRejectReplacementTxn_FetchLocCode))]
        public async Task<HttpResponseMessage> LinenRejectReplacementTxn_FetchLocCode(HttpRequestMessage request, [FromBody] LinenRejectReplacementModel SearchObject)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(FetchItemNo), Level.Info.ToString());
            var result = await RestHelper.ApiPost("Fetch/LinenRejectReplacementTxn_FetchLocCode", SearchObject);
            Log4NetLogger.LogEntry(_FileName, nameof(FetchItemNo), Level.Info.ToString());
            return result;
        }

        [HttpPost(nameof(LinenRejectReplacementTxn_FetchUserAreaCode))]
        public async Task<HttpResponseMessage> LinenRejectReplacementTxn_FetchUserAreaCode(HttpRequestMessage request, [FromBody] LinenRejectReplacementModel SearchObject)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(FetchItemNo), Level.Info.ToString());
            var result = await RestHelper.ApiPost("Fetch/LinenRejectReplacementTxn_FetchUserAreaCode", SearchObject);
            Log4NetLogger.LogEntry(_FileName, nameof(FetchItemNo), Level.Info.ToString());
            return result;
        }

        [HttpPost(nameof(LinenRejectReplacementTxn_FetchCLINo))]
        public async Task<HttpResponseMessage> LinenRejectReplacementTxn_FetchCLINo(HttpRequestMessage request, [FromBody] LinenRejectReplacementModel SearchObject)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(FetchItemNo), Level.Info.ToString());
            var result = await RestHelper.ApiPost("Fetch/LinenRejectReplacementTxn_FetchCLINo", SearchObject);
            Log4NetLogger.LogEntry(_FileName, nameof(FetchItemNo), Level.Info.ToString());
            return result;
        }

        [HttpPost(nameof(LinenRejectReplacementTxn_FetchRejectedBy))]
        public async Task<HttpResponseMessage> LinenRejectReplacementTxn_FetchRejectedBy(HttpRequestMessage request, [FromBody] LinenRejectReplacementModel SearchObject)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(FetchItemNo), Level.Info.ToString());
            var result = await RestHelper.ApiPost("Fetch/LinenRejectReplacementTxn_FetchRejectedBy", SearchObject);
            Log4NetLogger.LogEntry(_FileName, nameof(FetchItemNo), Level.Info.ToString());
            return result;
        }

        [HttpPost(nameof(LinenRejectReplacementTxn_FetchReceivedBy))]
        public async Task<HttpResponseMessage> LinenRejectReplacementTxn_FetchReceivedBy(HttpRequestMessage request, [FromBody] LinenRejectReplacementModel SearchObject)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(FetchItemNo), Level.Info.ToString());
            var result = await RestHelper.ApiPost("Fetch/LinenRejectReplacementTxn_FetchReceivedBy", SearchObject);
            Log4NetLogger.LogEntry(_FileName, nameof(FetchItemNo), Level.Info.ToString());
            return result;
        }

        [HttpPost(nameof(LLSLinenInjectionTxn_FetchDONo))]
        public async Task<HttpResponseMessage> LLSLinenInjectionTxn_FetchDONo(HttpRequestMessage request, [FromBody] LinenConemnationModel SearchObject)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(FetchItemNo), Level.Info.ToString());
            var result = await RestHelper.ApiPost("Fetch/LLSLinenInjectionTxn_FetchDONo", SearchObject);
            Log4NetLogger.LogEntry(_FileName, nameof(FetchItemNo), Level.Info.ToString());
            return result;
        }

        [HttpPost(nameof(LLSLinenInventoryTxn_FetchUserAreaCode))]
        public async Task<HttpResponseMessage> LLSLinenInventoryTxn_FetchUserAreaCode(HttpRequestMessage request, [FromBody] UserAreaFetch SearchObject)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(FetchItemNo), Level.Info.ToString());
            var result = await RestHelper.ApiPost("Fetch/LLSLinenInventoryTxn_FetchUserAreaCode", SearchObject);
            Log4NetLogger.LogEntry(_FileName, nameof(FetchItemNo), Level.Info.ToString());
            return result;
        }

        [HttpPost(nameof(LLSLinenInventoryTxn_FetchVerifiedBy))]
        public async Task<HttpResponseMessage> LLSLinenInventoryTxn_FetchVerifiedBy(HttpRequestMessage request, [FromBody] UserAreaFetch SearchObject)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(FetchItemNo), Level.Info.ToString());
            var result = await RestHelper.ApiPost("Fetch/LLSLinenInventoryTxn_FetchVerifiedBy", SearchObject);
            Log4NetLogger.LogEntry(_FileName, nameof(FetchItemNo), Level.Info.ToString());
            return result;
        }

        [HttpPost(nameof(LLSLinenInventoryTxnDet_FetchLinenCode))]
        public async Task<HttpResponseMessage> LLSLinenInventoryTxnDet_FetchLinenCode(HttpRequestMessage request, [FromBody] UserAreaFetch SearchObject)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(FetchItemNo), Level.Info.ToString());
            var result = await RestHelper.ApiPost("Fetch/LLSLinenInventoryTxnDet_FetchLinenCode", SearchObject);
            Log4NetLogger.LogEntry(_FileName, nameof(FetchItemNo), Level.Info.ToString());
            return result;
        }

        [HttpPost(nameof(LLSLinenInventoryTxnDet_FetchLinenCodeUserArea))]
        public async Task<HttpResponseMessage> LLSLinenInventoryTxnDet_FetchLinenCodeUserArea(HttpRequestMessage request, [FromBody] UserAreaFetch SearchObject)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(FetchItemNo), Level.Info.ToString());
            var result = await RestHelper.ApiPost("Fetch/LLSLinenInventoryTxnDet_FetchLinenCodeUserArea", SearchObject);
            Log4NetLogger.LogEntry(_FileName, nameof(FetchItemNo), Level.Info.ToString());
            return result;
        }

        #region CRMRequest Asset
        [HttpPost(nameof(CrmAssetNoFetch))]
        public async Task<HttpResponseMessage> CrmAssetNoFetch(HttpRequestMessage request, [FromBody] CRMWorkorderStaffFetch SearchObject)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(CrmAssetNoFetch), Level.Info.ToString());
            var result = await RestHelper.ApiPost("Fetch/CrmAssetNoFetch", SearchObject);
            Log4NetLogger.LogEntry(_FileName, nameof(CrmAssetNoFetch), Level.Info.ToString());
            return result;
        }

        #endregion


        [HttpPost(nameof(ArpBerNo))]
        public async Task<HttpResponseMessage> ArpBerNo(HttpRequestMessage request, [FromBody] Arp SearchObject)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(ArpBerNo), Level.Info.ToString());
            var result = await RestHelper.ApiPost("Fetch/ArpBerNo", SearchObject);
            Log4NetLogger.LogEntry(_FileName, nameof(ArpBerNo), Level.Info.ToString());
            return result;
        }

        [HttpPost(nameof(ArpAssetNo))]
        public async Task<HttpResponseMessage> ArpAssetNo(HttpRequestMessage request, [FromBody] Arp SearchObject)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(ArpAssetNo), Level.Info.ToString());
            var result = await RestHelper.ApiPost("Fetch/ArpAssetNo", SearchObject);
            Log4NetLogger.LogEntry(_FileName, nameof(ArpAssetNo), Level.Info.ToString());
            return result;
        }

    }
}

