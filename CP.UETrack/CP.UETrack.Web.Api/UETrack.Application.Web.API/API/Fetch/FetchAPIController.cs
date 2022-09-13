using CP.UETrack.Application.Web.API;
using CP.UETrack.Model;
using CP.Framework.Common.Audit;
using System;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using CP.UETrack.BLL.BusinessAccess.Interface;
using CP.Framework.Common.Logging;
using Newtonsoft.Json;
using CP.UETrack.Model.BEMS;
using CP.UETrack.Model.FetchModels;
using CP.UETrack.Model.VM;
using static CP.UETrack.Model.FetchModels.ModelSearching;
using CP.UETrack.Model.LLS;

namespace UETrack.Application.Web.Controllers
{

    [RoutePrefix("api/Fetch")]
    [WebApiAudit]
    public class FetchAPIController : BaseApiController
    {
        IFetchBAL _FetchBAL;
        private readonly string _FileName = nameof(FetchAPIController);
        public FetchAPIController(IFetchBAL fetchBAL)
        {
            _FetchBAL = fetchBAL;
        }

        [HttpPost]
        [Route(nameof(FetchRecords))]
        public HttpResponseMessage FetchRecords(UMStaffSearch SearchObject)
        {

            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(FetchRecords), Level.Info.ToString());
                var ErrorMessage = string.Empty;
                var result = _FetchBAL.FetchRecords(SearchObject);
                if (result == null)
                {
                    responseObject = BuildResponseObject(HttpStatusCode.NotFound);
                }
                else
                {
                    var serialisedData = JsonConvert.SerializeObject(result);
                    responseObject = BuildResponseObject(HttpStatusCode.OK, serialisedData);
                }

                Log4NetLogger.LogExit(_FileName, nameof(FetchRecords), Level.Info.ToString());
            }
            catch (Exception ex)
            {
                returnMessage = $"{resxFileHelper.GetErrorMessagesFromResource("GeneralException")} : {ex.Message}";
            }

            if (responseObject == null)
                responseObject = BuildResponseObject(false, returnMessage);

            return responseObject;
        }

        [HttpPost]
        [Route(nameof(FetchItemMstdetais))]
        public HttpResponseMessage FetchItemMstdetais(ItemMstFetchEntity SearchObject)
        {

            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(FetchItemMstdetais), Level.Info.ToString());
                var ErrorMessage = string.Empty;
                var result = _FetchBAL.FetchItemMstdetais(SearchObject);
                if (result == null)
                {
                    responseObject = BuildResponseObject(HttpStatusCode.NotFound);
                }
                else
                {
                    var serialisedData = JsonConvert.SerializeObject(result);
                    responseObject = BuildResponseObject(HttpStatusCode.OK, serialisedData);
                }

                Log4NetLogger.LogExit(_FileName, nameof(FetchItemMstdetais), Level.Info.ToString());
            }
            catch (Exception ex)
            {
                returnMessage = $"{resxFileHelper.GetErrorMessagesFromResource("GeneralException")} : {ex.Message}";
            }

            if (responseObject == null)
                responseObject = BuildResponseObject(false, returnMessage);

            return responseObject;
        }

        [HttpPost]
        [Route(nameof(TypeCodeFetch))]
        public HttpResponseMessage TypeCodeFetch(TypeCodeSearch SearchObject)
        {

            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(TypeCodeFetch), Level.Info.ToString());
                var ErrorMessage = string.Empty;
                var result = _FetchBAL.TypeCodeFetch(SearchObject);
                if (result == null)
                {
                    responseObject = BuildResponseObject(HttpStatusCode.NotFound);
                }
                else
                {
                    var serialisedData = JsonConvert.SerializeObject(result);
                    responseObject = BuildResponseObject(HttpStatusCode.OK, serialisedData);
                }

                Log4NetLogger.LogExit(_FileName, nameof(TypeCodeFetch), Level.Info.ToString());
            }
            catch (Exception ex)
            {
                returnMessage = $"{resxFileHelper.GetErrorMessagesFromResource("GeneralException")} : {ex.Message}";
            }

            if (responseObject == null)
                responseObject = BuildResponseObject(false, returnMessage);

            return responseObject;
        }

       
        [HttpPost]
        [Route(nameof(FetchTaskCode))]
        public HttpResponseMessage FetchTaskCode(EngAssetTypeCodeStandardTasksFetch SearchObject)
        {

            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(FetchItemMstdetais), Level.Info.ToString());
                var ErrorMessage = string.Empty;
                var result = _FetchBAL.FetchTaskCode(SearchObject);
                if (result == null)
                {
                    responseObject = BuildResponseObject(HttpStatusCode.NotFound);
                }
                else
                {
                    var serialisedData = JsonConvert.SerializeObject(result);
                    responseObject = BuildResponseObject(HttpStatusCode.OK, serialisedData);
                }

                Log4NetLogger.LogExit(_FileName, nameof(FetchItemMstdetais), Level.Info.ToString());
            }
            catch (Exception ex)
            {
                returnMessage = $"{resxFileHelper.GetErrorMessagesFromResource("GeneralException")} : {ex.Message}";
            }

            if (responseObject == null)
                responseObject = BuildResponseObject(false, returnMessage);

            return responseObject;
        }

        [HttpPost]
        [Route(nameof(LocationCodeFetch))]
        public HttpResponseMessage LocationCodeFetch(UserLocationCodeSearch SearchObject)
        {

            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(LocationCodeFetch), Level.Info.ToString());
                var ErrorMessage = string.Empty;
                var result = _FetchBAL.LocationCodeFetch(SearchObject);
                if (result == null)
                {
                    responseObject = BuildResponseObject(HttpStatusCode.NotFound);
                }
                else
                {
                    var serialisedData = JsonConvert.SerializeObject(result);
                    responseObject = BuildResponseObject(HttpStatusCode.OK, serialisedData);
                }

                Log4NetLogger.LogExit(_FileName, nameof(LocationCodeFetch), Level.Info.ToString());
            }
            catch (Exception ex)
            {
                returnMessage = $"{resxFileHelper.GetErrorMessagesFromResource("GeneralException")} : {ex.Message}";
            }

            if (responseObject == null)
                responseObject = BuildResponseObject(false, returnMessage);

            return responseObject;
        }

        [HttpPost]
        [Route(nameof(ManufacturerFetch))]
        public HttpResponseMessage ManufacturerFetch(ManufacturerSearch SearchObject)
        {

            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(ManufacturerFetch), Level.Info.ToString());
                var ErrorMessage = string.Empty;
                var result = _FetchBAL.ManufacturerFetch(SearchObject);
                if (result == null)
                {
                    responseObject = BuildResponseObject(HttpStatusCode.NotFound);
                }
                else
                {
                    var serialisedData = JsonConvert.SerializeObject(result);
                    responseObject = BuildResponseObject(HttpStatusCode.OK, serialisedData);
                }

                Log4NetLogger.LogExit(_FileName, nameof(ManufacturerFetch), Level.Info.ToString());
            }
            catch (Exception ex)
            {
                returnMessage = $"{resxFileHelper.GetErrorMessagesFromResource("GeneralException")} : {ex.Message}";
            }

            if (responseObject == null)
                responseObject = BuildResponseObject(false, returnMessage);

            return responseObject;
        }

        [HttpPost]
        [Route(nameof(ModelFetch))]
        public HttpResponseMessage ModelFetch(ModelSearch SearchObject)
        {

            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(ModelFetch), Level.Info.ToString());
                var ErrorMessage = string.Empty;
                var result = _FetchBAL.ModelFetch(SearchObject);
                if (result == null)
                {
                    responseObject = BuildResponseObject(HttpStatusCode.NotFound);
                }
                else
                {
                    var serialisedData = JsonConvert.SerializeObject(result);
                    responseObject = BuildResponseObject(HttpStatusCode.OK, serialisedData);
                }

                Log4NetLogger.LogExit(_FileName, nameof(ModelFetch), Level.Info.ToString());
            }
            catch (Exception ex)
            {
                returnMessage = $"{resxFileHelper.GetErrorMessagesFromResource("GeneralException")} : {ex.Message}";
            }

            if (responseObject == null)
                responseObject = BuildResponseObject(false, returnMessage);

            return responseObject;
        }
        [HttpPost]
        [Route(nameof(FetchRescheduleWOdetails))]
        public HttpResponseMessage FetchRescheduleWOdetails(RescheduleWOFetchModel SearchObject)
        {

            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(FetchRescheduleWOdetails), Level.Info.ToString());
                var ErrorMessage = string.Empty;
                var result = _FetchBAL.FetchRescheduleWOdetails(SearchObject);
                if (result == null)
                {
                    responseObject = BuildResponseObject(HttpStatusCode.NotFound);
                }
                else
                {
                    var serialisedData = JsonConvert.SerializeObject(result);
                    responseObject = BuildResponseObject(HttpStatusCode.OK, serialisedData);
                }

                Log4NetLogger.LogExit(_FileName, nameof(FetchRescheduleWOdetails), Level.Info.ToString());
            }
            catch (Exception ex)
            {
                returnMessage = $"{resxFileHelper.GetErrorMessagesFromResource("GeneralException")} : {ex.Message}";
            }

            if (responseObject == null)
                responseObject = BuildResponseObject(false, returnMessage);

            return responseObject;
        }
        [HttpPost]
        [Route(nameof(AssetPreRegistrationNoFetch))]
        public HttpResponseMessage AssetPreRegistrationNoFetch(AssetPreRegistrationNoSearch SearchObject)
        {

            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(AssetPreRegistrationNoFetch), Level.Info.ToString());
                var ErrorMessage = string.Empty;
                var result = _FetchBAL.AssetPreRegistrationNoFetch(SearchObject);
                if (result == null)
                {
                    responseObject = BuildResponseObject(HttpStatusCode.NotFound);
                }
                else
                {
                    var serialisedData = JsonConvert.SerializeObject(result);
                    responseObject = BuildResponseObject(HttpStatusCode.OK, serialisedData);
                }

                Log4NetLogger.LogExit(_FileName, nameof(AssetPreRegistrationNoFetch), Level.Info.ToString());
            }
            catch (Exception ex)
            {
                returnMessage = $"{resxFileHelper.GetErrorMessagesFromResource("GeneralException")} : {ex.Message}";
            }

            if (responseObject == null)
                responseObject = BuildResponseObject(false, returnMessage);

            return responseObject;
        }
        [Route(nameof(FetchWarrantyProvider))]
        public HttpResponseMessage FetchWarrantyProvider(AssetRegisterWarrantyProviderGrid SearchObject)
        {

            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(FetchWarrantyProvider), Level.Info.ToString());
                var ErrorMessage = string.Empty;
                var result = _FetchBAL.FetchWarrantyProvider(SearchObject);
                if (result == null)
                {
                    responseObject = BuildResponseObject(HttpStatusCode.NotFound);
                }
                else
                {
                    var serialisedData = JsonConvert.SerializeObject(result);
                    responseObject = BuildResponseObject(HttpStatusCode.OK, serialisedData);
                }

                Log4NetLogger.LogExit(_FileName, nameof(FetchWarrantyProvider), Level.Info.ToString());
            }
            catch (Exception ex)
            {
                returnMessage = $"{resxFileHelper.GetErrorMessagesFromResource("GeneralException")} : {ex.Message}";
            }

            if (responseObject == null)
                responseObject = BuildResponseObject(false, returnMessage);

            return responseObject;
        }



        [HttpPost]
        [Route(nameof(LevelCodeFetch))]
        public HttpResponseMessage LevelCodeFetch(LevelFetchModel SearchObject)
        {

            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(TypeCodeFetch), Level.Info.ToString());
                var ErrorMessage = string.Empty;
                var result = _FetchBAL.LevelCodeFetch(SearchObject);
                if (result == null)
                {
                    responseObject = BuildResponseObject(HttpStatusCode.NotFound);
                }
                else
                {
                    var serialisedData = JsonConvert.SerializeObject(result);
                    responseObject = BuildResponseObject(HttpStatusCode.OK, serialisedData);
                }

                Log4NetLogger.LogExit(_FileName, nameof(TypeCodeFetch), Level.Info.ToString());
            }
            catch (Exception ex)
            {
                returnMessage = $"{resxFileHelper.GetErrorMessagesFromResource("GeneralException")} : {ex.Message}";
            }

            if (responseObject == null)
                responseObject = BuildResponseObject(false, returnMessage);

            return responseObject;
        }

        [HttpPost]
        [Route(nameof(CompanyStaffFetch))]
        public HttpResponseMessage CompanyStaffFetch(CompanyStaffFetchModel SearchObject)
        {

            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(TypeCodeFetch), Level.Info.ToString());
                var ErrorMessage = string.Empty;
                var result = _FetchBAL.CompanyStaffFetch(SearchObject);
                if (result == null)
                {
                    responseObject = BuildResponseObject(HttpStatusCode.NotFound);
                }
                else
                {
                    var serialisedData = JsonConvert.SerializeObject(result);
                    responseObject = BuildResponseObject(HttpStatusCode.OK, serialisedData);
                }

                Log4NetLogger.LogExit(_FileName, nameof(TypeCodeFetch), Level.Info.ToString());
            }
            catch (Exception ex)

            {
                returnMessage = $"{resxFileHelper.GetErrorMessagesFromResource("GeneralException")} : {ex.Message}";
            }

            if (responseObject == null)
                responseObject = BuildResponseObject(false, returnMessage);

            return responseObject;
        }

        [HttpPost]
        [Route(nameof(FacilityStaffFetch))]
        public HttpResponseMessage FacilityStaffFetch(FacilityStaffFetchModel SearchObject)
        {

            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(TypeCodeFetch), Level.Info.ToString());
                var ErrorMessage = string.Empty;
                var result = _FetchBAL.FacilityStaffFetch(SearchObject);
                if (result == null)
                {
                    responseObject = BuildResponseObject(HttpStatusCode.NotFound);
                }
                else
                {
                    var serialisedData = JsonConvert.SerializeObject(result);
                    responseObject = BuildResponseObject(HttpStatusCode.OK, serialisedData);
                }

                Log4NetLogger.LogExit(_FileName, nameof(TypeCodeFetch), Level.Info.ToString());
            }
            catch (Exception ex)
            {
                returnMessage = $"{resxFileHelper.GetErrorMessagesFromResource("GeneralException")} : {ex.Message}";
            }

            if (responseObject == null)
                responseObject = BuildResponseObject(false, returnMessage);

            return responseObject;
        }
        [HttpPost]
        [Route(nameof(UserAreaFetch))]
        public HttpResponseMessage UserAreaFetch(UserAreaFetch SearchObject)
        {

            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(UserAreaFetch), Level.Info.ToString());
                var ErrorMessage = string.Empty;
                var result = _FetchBAL.UserAreaFetch(SearchObject);
                if (result == null)
                {
                    responseObject = BuildResponseObject(HttpStatusCode.NotFound);
                }
                else
                {
                    var serialisedData = JsonConvert.SerializeObject(result);
                    responseObject = BuildResponseObject(HttpStatusCode.OK, serialisedData);
                }

                Log4NetLogger.LogExit(_FileName, nameof(TypeCodeFetch), Level.Info.ToString());
            }
            catch (Exception ex)
            {
                returnMessage = $"{resxFileHelper.GetErrorMessagesFromResource("GeneralException")} : {ex.Message}";
            }

            if (responseObject == null)
                responseObject = BuildResponseObject(false, returnMessage);

            return responseObject;
        }
        [Route(nameof(AssetNoFetch))]
        public HttpResponseMessage AssetNoFetch(WarrantyManagementSearch SearchObject)
        {

            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(AssetNoFetch), Level.Info.ToString());
                var ErrorMessage = string.Empty;
                var result = _FetchBAL.AssetNoFetch(SearchObject);
                if (result == null)
                {
                    responseObject = BuildResponseObject(HttpStatusCode.NotFound);
                }
                else
                {
                    var serialisedData = JsonConvert.SerializeObject(result);
                    responseObject = BuildResponseObject(HttpStatusCode.OK, serialisedData);
                }

                Log4NetLogger.LogExit(_FileName, nameof(AssetNoFetch), Level.Info.ToString());
            }
            catch (Exception ex)
            {
                returnMessage = $"{ resxFileHelper.GetErrorMessagesFromResource("GeneralException")} : { ex.Message}";
            }

            if (responseObject == null)
                responseObject = BuildResponseObject(false, returnMessage);

            return responseObject;
        }
        [Route(nameof(StockAdjustmentFetchModel))]
        public HttpResponseMessage StockAdjustmentFetchModel(StockAdjustmentFetchModel SearchObject)
        {

            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(StockAdjustmentFetchModel), Level.Info.ToString());
                var ErrorMessage = string.Empty;
                var result = _FetchBAL.StockAdjustmentFetchModel(SearchObject);
                if (result == null)
                {
                    responseObject = BuildResponseObject(HttpStatusCode.NotFound);
                }
                else
                {
                    var serialisedData = JsonConvert.SerializeObject(result);
                    responseObject = BuildResponseObject(HttpStatusCode.OK, serialisedData);
                }

                Log4NetLogger.LogExit(_FileName, nameof(StockAdjustmentFetchModel), Level.Info.ToString());
            }
            catch (Exception ex)
            {
                returnMessage = $"{ resxFileHelper.GetErrorMessagesFromResource("GeneralException")} : { ex.Message}";
            }

            if (responseObject == null)
                responseObject = BuildResponseObject(false, returnMessage);

            return responseObject;
        }
        [Route(nameof(ParentAssetNoFetch))]
        public HttpResponseMessage ParentAssetNoFetch(ParentAssetNoSearch SearchObject)
        {

            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(ParentAssetNoFetch), Level.Info.ToString());
                var ErrorMessage = string.Empty;
                var result = _FetchBAL.ParentAssetNoFetch(SearchObject);
                if (result == null)
                {
                    responseObject = BuildResponseObject(HttpStatusCode.NotFound);
                }
                else
                {
                    var serialisedData = JsonConvert.SerializeObject(result);
                    responseObject = BuildResponseObject(HttpStatusCode.OK, serialisedData);
                }

                Log4NetLogger.LogExit(_FileName, nameof(ParentAssetNoFetch), Level.Info.ToString());
            }
            catch (Exception ex)
            {
                returnMessage = $"{ resxFileHelper.GetErrorMessagesFromResource("GeneralException")} : { ex.Message}";
            }

            if (responseObject == null)
                responseObject = BuildResponseObject(false, returnMessage);

            return responseObject;
        }
        [Route(nameof(FacilityWorkAssetNoFetch))]
        public HttpResponseMessage FacilityWorkAssetNoFetch(ParentAssetNoSearch SearchObject)
        {

            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(FacilityWorkAssetNoFetch), Level.Info.ToString());
                var ErrorMessage = string.Empty;
                var result = _FetchBAL.FacilityWorkAssetNoFetch(SearchObject);
                if (result == null)
                {
                    responseObject = BuildResponseObject(HttpStatusCode.NotFound);
                }
                else
                {
                    var serialisedData = JsonConvert.SerializeObject(result);
                    responseObject = BuildResponseObject(HttpStatusCode.OK, serialisedData);
                }

                Log4NetLogger.LogExit(_FileName, nameof(FacilityWorkAssetNoFetch), Level.Info.ToString());
            }
            catch (Exception ex)
            {
                returnMessage = $"{ resxFileHelper.GetErrorMessagesFromResource("GeneralException")} : { ex.Message}";
            }

            if (responseObject == null)
                responseObject = BuildResponseObject(false, returnMessage);

            return responseObject;
        }
        [Route(nameof(AssetClassificationCodeFetch))]
        public HttpResponseMessage AssetClassificationCodeFetch(AssetClassificationFetch SearchObject)
        {

            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(AssetClassificationCodeFetch), Level.Info.ToString());
                var ErrorMessage = string.Empty;
                var result = _FetchBAL.AssetClassificationCodeFetch(SearchObject);
                if (result == null)
                {
                    responseObject = BuildResponseObject(HttpStatusCode.NotFound);
                }
                else
                {
                    var serialisedData = JsonConvert.SerializeObject(result);
                    responseObject = BuildResponseObject(HttpStatusCode.OK, serialisedData);
                }

                Log4NetLogger.LogExit(_FileName, nameof(AssetClassificationCodeFetch), Level.Info.ToString());
            }
            catch (Exception ex)
            {
                returnMessage = $"{ resxFileHelper.GetErrorMessagesFromResource("GeneralException")} : { ex.Message}";
            }
            if (responseObject == null)
                responseObject = BuildResponseObject(false, returnMessage);

            return responseObject;
        }

        [Route(nameof(ItemCodeFetch))]
        public HttpResponseMessage ItemCodeFetch(ItemCodeFetch SearchObject)
        {

            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(AssetClassificationCodeFetch), Level.Info.ToString());
                var ErrorMessage = string.Empty;
                var result = _FetchBAL.ItemCodeFetch(SearchObject);
                if (result == null)
                {
                    responseObject = BuildResponseObject(HttpStatusCode.NotFound);
                }
                else
                {
                    var serialisedData = JsonConvert.SerializeObject(result);
                    responseObject = BuildResponseObject(HttpStatusCode.OK, serialisedData);
                }

                Log4NetLogger.LogExit(_FileName, nameof(AssetClassificationCodeFetch), Level.Info.ToString());
            }
            catch (Exception ex)
            {
                returnMessage = $"{ resxFileHelper.GetErrorMessagesFromResource("GeneralException")} : { ex.Message}";
            }
            if (responseObject == null)
                responseObject = BuildResponseObject(false, returnMessage);

            return responseObject;
        }
        [Route(nameof(SNFAssetFetch))]
        public HttpResponseMessage SNFAssetFetch(SNFAssetFetchEntity SearchObject)
        {

            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(SNFAssetFetch), Level.Info.ToString());
                var ErrorMessage = string.Empty;
                var result = _FetchBAL.SNFAssetFetch(SearchObject);
                if (result == null)
                {
                    responseObject = BuildResponseObject(HttpStatusCode.NotFound);
                }
                else
                {
                    var serialisedData = JsonConvert.SerializeObject(result);
                    responseObject = BuildResponseObject(HttpStatusCode.OK, serialisedData);
                }

                Log4NetLogger.LogExit(_FileName, nameof(SNFAssetFetch), Level.Info.ToString());
            }
            catch (Exception ex)
            {
                returnMessage = $"{ resxFileHelper.GetErrorMessagesFromResource("GeneralException")} : { ex.Message}";
            }
            if (responseObject == null)
                responseObject = BuildResponseObject(false, returnMessage);

            return responseObject;
        }

        [HttpPost]
        [Route(nameof(FetchCheckListItemDetails))]
        public HttpResponseMessage FetchCheckListItemDetails(PPMCheckListFetchItem SearchObject)
        {

            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(FetchCheckListItemDetails), Level.Info.ToString());
                var ErrorMessage = string.Empty;
                var result = _FetchBAL.FetchCheckListItemDetails(SearchObject);
                if (result == null)
                {
                    responseObject = BuildResponseObject(HttpStatusCode.NotFound);
                }
                else
                {
                    var serialisedData = JsonConvert.SerializeObject(result);
                    responseObject = BuildResponseObject(HttpStatusCode.OK, serialisedData);
                }

                Log4NetLogger.LogExit(_FileName, nameof(FetchCheckListItemDetails), Level.Info.ToString());
            }
            catch (Exception ex)
            {
                returnMessage = $"{resxFileHelper.GetErrorMessagesFromResource("GeneralException")} : {ex.Message}";
            }

            if (responseObject == null)
                responseObject = BuildResponseObject(false, returnMessage);

            return responseObject;
        }
        [HttpPost]
        [Route(nameof(FetchSNFDetails))]
        public HttpResponseMessage FetchSNFDetails(SNFfetchEntity SearchObject)
        {

            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(FetchSNFDetails), Level.Info.ToString());
                var ErrorMessage = string.Empty;
                var result = _FetchBAL.FetchSNFDetails(SearchObject);
                if (result == null)
                {
                    responseObject = BuildResponseObject(HttpStatusCode.NotFound);
                }
                else
                {
                    var serialisedData = JsonConvert.SerializeObject(result);
                    responseObject = BuildResponseObject(HttpStatusCode.OK, serialisedData);
                }

                Log4NetLogger.LogExit(_FileName, nameof(FetchSNFDetails), Level.Info.ToString());
            }
            catch (Exception ex)
            {
                returnMessage = $"{resxFileHelper.GetErrorMessagesFromResource("GeneralException")} : {ex.Message}";
            }

            if (responseObject == null)
                responseObject = BuildResponseObject(false, returnMessage);

            return responseObject;
        }
        [HttpPost]
        [Route(nameof(BERAssetNoFetch))]
        public HttpResponseMessage BERAssetNoFetch(BERAssetNoFetch SearchObject)
        {

            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(BERAssetNoFetch), Level.Info.ToString());
                var ErrorMessage = string.Empty;
                var result = _FetchBAL.BERAssetNoFetch(SearchObject);
                if (result == null)
                {
                    responseObject = BuildResponseObject(HttpStatusCode.NotFound);
                }
                else
                {
                    var serialisedData = JsonConvert.SerializeObject(result);
                    responseObject = BuildResponseObject(HttpStatusCode.OK, serialisedData);
                }

                Log4NetLogger.LogExit(_FileName, nameof(BERAssetNoFetch), Level.Info.ToString());
            }
            catch (Exception ex)
            {
                returnMessage = $"{resxFileHelper.GetErrorMessagesFromResource("GeneralException")} : {ex.Message}";
            }

            if (responseObject == null)
                responseObject = BuildResponseObject(false, returnMessage);

            return responseObject;
        }
        [HttpPost]
        [Route(nameof(BERRejectedNoFetch))]
        public HttpResponseMessage BERRejectedNoFetch(BERRejectedNoFetch SearchObject)
        {

            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(BERRejectedNoFetch), Level.Info.ToString());
                var ErrorMessage = string.Empty;
                var result = _FetchBAL.BERRejectedNoFetch(SearchObject);
                if (result == null)
                {
                    responseObject = BuildResponseObject(HttpStatusCode.NotFound);
                }
                else
                {
                    var serialisedData = JsonConvert.SerializeObject(result);
                    responseObject = BuildResponseObject(HttpStatusCode.OK, serialisedData);
                }

                Log4NetLogger.LogExit(_FileName, nameof(BERRejectedNoFetch), Level.Info.ToString());
            }
            catch (Exception ex)
            {
                returnMessage = $"{resxFileHelper.GetErrorMessagesFromResource("GeneralException")} : {ex.Message}";
            }

            if (responseObject == null)
                responseObject = BuildResponseObject(false, returnMessage);

            return responseObject;
        }

        [HttpPost]
        [Route(nameof(CRMWorkorderRequestFetch))]
        public HttpResponseMessage CRMWorkorderRequestFetch(CRMWorkorderRequestFetch SearchObject)
        {

            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(CRMWorkorderRequestFetch), Level.Info.ToString());
                var ErrorMessage = string.Empty;
                var result = _FetchBAL.CRMWorkorderRequestFetch(SearchObject);
                if (result == null)
                {
                    responseObject = BuildResponseObject(HttpStatusCode.NotFound);
                }
                else
                {
                    var serialisedData = JsonConvert.SerializeObject(result);
                    responseObject = BuildResponseObject(HttpStatusCode.OK, serialisedData);
                }

                Log4NetLogger.LogExit(_FileName, nameof(CRMWorkorderRequestFetch), Level.Info.ToString());
            }
            catch (Exception ex)
            {
                returnMessage = $"{resxFileHelper.GetErrorMessagesFromResource("GeneralException")} : {ex.Message}";
            }

            if (responseObject == null)
                responseObject = BuildResponseObject(false, returnMessage);

            return responseObject;
        }
        [HttpPost]
        [Route(nameof(TAndCCRMRequestNoFetch))]
        public HttpResponseMessage TAndCCRMRequestNoFetch(TAndCCRMRequestNoFetchSearch SearchObject)
        {

            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(TAndCCRMRequestNoFetch), Level.Info.ToString());
                var ErrorMessage = string.Empty;
                var result = _FetchBAL.TAndCCRMRequestNoFetch(SearchObject);
                if (result == null)
                {
                    responseObject = BuildResponseObject(HttpStatusCode.NotFound);
                }
                else
                {
                    var serialisedData = JsonConvert.SerializeObject(result);
                    responseObject = BuildResponseObject(HttpStatusCode.OK, serialisedData);
                }

                Log4NetLogger.LogExit(_FileName, nameof(TAndCCRMRequestNoFetch), Level.Info.ToString());
            }
            catch (Exception ex)
            {
                returnMessage = $"{resxFileHelper.GetErrorMessagesFromResource("GeneralException")} : {ex.Message}";
            }

            if (responseObject == null)
                responseObject = BuildResponseObject(false, returnMessage);

            return responseObject;
        }
        [HttpPost]
        [Route(nameof(AssetQRCodePrintFetchModel))]
        public HttpResponseMessage AssetQRCodePrintFetchModel(AssetQRCodePrintFetchModel SearchObject)
        {

            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(AssetQRCodePrintFetchModel), Level.Info.ToString());
                var ErrorMessage = string.Empty;
                var result = _FetchBAL.AssetQRCodePrintFetchModel(SearchObject);
                if (result == null)
                {
                    responseObject = BuildResponseObject(HttpStatusCode.NotFound);
                }
                else
                {
                    var serialisedData = JsonConvert.SerializeObject(result);
                    responseObject = BuildResponseObject(HttpStatusCode.OK, serialisedData);
                }

                Log4NetLogger.LogExit(_FileName, nameof(AssetQRCodePrintFetchModel), Level.Info.ToString());
            }
            catch (Exception ex)
            {
                returnMessage = $"{ resxFileHelper.GetErrorMessagesFromResource("GeneralException")} : { ex.Message}";
            }

            if (responseObject == null)
                responseObject = BuildResponseObject(false, returnMessage);

            return responseObject;
        }

        [HttpPost]
        [Route(nameof(UserLocationQRCodePrintingFetchModel))]
        public HttpResponseMessage UserLocationQRCodePrintingFetchModel(UserLocationQRCodePrintingFetchModel SearchObject)
        {

            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(UserLocationQRCodePrintingFetchModel), Level.Info.ToString());
                var ErrorMessage = string.Empty;
                var result = _FetchBAL.UserLocationQRCodePrintingFetchModel(SearchObject);
                if (result == null)
                {
                    responseObject = BuildResponseObject(HttpStatusCode.NotFound);
                }
                else
                {
                    var serialisedData = JsonConvert.SerializeObject(result);
                    responseObject = BuildResponseObject(HttpStatusCode.OK, serialisedData);
                }

                Log4NetLogger.LogExit(_FileName, nameof(UserLocationQRCodePrintingFetchModel), Level.Info.ToString());
            }
            catch (Exception ex)
            {
                returnMessage = $"{ resxFileHelper.GetErrorMessagesFromResource("GeneralException")} : { ex.Message}";
            }

            if (responseObject == null)
                responseObject = BuildResponseObject(false, returnMessage);

            return responseObject;
        }

        [HttpPost]
        [Route(nameof(UserAreaQRCodePrintingFetchModel))]
        public HttpResponseMessage UserAreaQRCodePrintingFetchModel(UserAreaQRCodePrintingFetchModel SearchObject)
        {

            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(UserAreaQRCodePrintingFetchModel), Level.Info.ToString());
                var ErrorMessage = string.Empty;
                var result = _FetchBAL.UserAreaQRCodePrintingFetchModel(SearchObject);
                if (result == null)
                {
                    responseObject = BuildResponseObject(HttpStatusCode.NotFound);
                }
                else
                {
                    var serialisedData = JsonConvert.SerializeObject(result);
                    responseObject = BuildResponseObject(HttpStatusCode.OK, serialisedData);
                }

                Log4NetLogger.LogExit(_FileName, nameof(UserAreaQRCodePrintingFetchModel), Level.Info.ToString());
            }
            catch (Exception ex)
            {
                returnMessage = $"{ resxFileHelper.GetErrorMessagesFromResource("GeneralException")} : { ex.Message}";
            }

            if (responseObject == null)
                responseObject = BuildResponseObject(false, returnMessage);

            return responseObject;
        }

        [HttpPost]
        [Route(nameof(PorteringAssetNoFetch))]
        public HttpResponseMessage PorteringAssetNoFetch(PortAssetFetchModel SearchObject)
        {

            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(PorteringAssetNoFetch), Level.Info.ToString());
                var ErrorMessage = string.Empty;
                var result = _FetchBAL.PorteringAssetNoFetch(SearchObject);
                if (result == null)
                {
                    responseObject = BuildResponseObject(HttpStatusCode.NotFound);
                }
                else
                {
                    var serialisedData = JsonConvert.SerializeObject(result);
                    responseObject = BuildResponseObject(HttpStatusCode.OK, serialisedData);
                }

                Log4NetLogger.LogExit(_FileName, nameof(PorteringAssetNoFetch), Level.Info.ToString());
            }
            catch (Exception ex)
            {
                returnMessage = $"{resxFileHelper.GetErrorMessagesFromResource("GeneralException")} : {ex.Message}";
            }
            if (responseObject == null)
                responseObject = BuildResponseObject(false, returnMessage);

            return responseObject;
        }

        [HttpPost]
        [Route(nameof(PorteringWorkOrderNoFetch))]
        public HttpResponseMessage PorteringWorkOrderNoFetch(PortAssetFetchModel SearchObject)
        {

            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(PorteringWorkOrderNoFetch), Level.Info.ToString());
                var ErrorMessage = string.Empty;
                var result = _FetchBAL.PorteringWorkOrderNoFetch(SearchObject);
                if (result == null)
                {
                    responseObject = BuildResponseObject(HttpStatusCode.NotFound);
                }
                else
                {
                    var serialisedData = JsonConvert.SerializeObject(result);
                    responseObject = BuildResponseObject(HttpStatusCode.OK, serialisedData);
                }

                Log4NetLogger.LogExit(_FileName, nameof(PorteringWorkOrderNoFetch), Level.Info.ToString());
            }
            catch (Exception ex)
            {
                returnMessage = $"{resxFileHelper.GetErrorMessagesFromResource("GeneralException")} : {ex.Message}";
            }

            if (responseObject == null)
                responseObject = BuildResponseObject(false, returnMessage);

            return responseObject;
        }

        [HttpPost]
        [Route(nameof(EODCaptureAssetFetch))]
        public HttpResponseMessage EODCaptureAssetFetch(EODCaptureAssetFetch SearchObject)
        {

            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(EODCaptureAssetFetch), Level.Info.ToString());
                var ErrorMessage = string.Empty;
                var result = _FetchBAL.EODCaptureAssetFetch(SearchObject);
                if (result == null)
                {
                    responseObject = BuildResponseObject(HttpStatusCode.NotFound);
                }
                else
                {
                    var serialisedData = JsonConvert.SerializeObject(result);
                    responseObject = BuildResponseObject(HttpStatusCode.OK, serialisedData);
                }

                Log4NetLogger.LogExit(_FileName, nameof(EODCaptureAssetFetch), Level.Info.ToString());
            }
            catch (Exception ex)
            {
                returnMessage = $"{resxFileHelper.GetErrorMessagesFromResource("GeneralException")} : {ex.Message}";
            }

            if (responseObject == null)
                responseObject = BuildResponseObject(false, returnMessage);

            return responseObject;
        }

        [Route(nameof(EODCaptureManufacturer))]
        public HttpResponseMessage EODCaptureManufacturer(EODCaptureManufacturer SearchObject)
        {

            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(EODCaptureManufacturer), Level.Info.ToString());
                var ErrorMessage = string.Empty;
                var result = _FetchBAL.EODCaptureManufacturer(SearchObject);
                if (result == null)
                {
                    responseObject = BuildResponseObject(HttpStatusCode.NotFound);
                }
                else
                {
                    var serialisedData = JsonConvert.SerializeObject(result);
                    responseObject = BuildResponseObject(HttpStatusCode.OK, serialisedData);
                }

                Log4NetLogger.LogExit(_FileName, nameof(EODCaptureManufacturer), Level.Info.ToString());
            }
            catch (Exception ex)
            {
                returnMessage = $"{ resxFileHelper.GetErrorMessagesFromResource("GeneralException")} : { ex.Message}";
            }

            if (responseObject == null)
                responseObject = BuildResponseObject(false, returnMessage);

            return responseObject;
        }
        [Route(nameof(EODCaptureModel))]
        public HttpResponseMessage EODCaptureModel(EODCaptureModel SearchObject)
        {

            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(EODCaptureModel), Level.Info.ToString());
                var ErrorMessage = string.Empty;
                var result = _FetchBAL.EODCaptureModel(SearchObject);
                if (result == null)
                {
                    responseObject = BuildResponseObject(HttpStatusCode.NotFound);
                }
                else
                {
                    var serialisedData = JsonConvert.SerializeObject(result);
                    responseObject = BuildResponseObject(HttpStatusCode.OK, serialisedData);
                }

                Log4NetLogger.LogExit(_FileName, nameof(EODCaptureModel), Level.Info.ToString());
            }
            catch (Exception ex)
            {
                returnMessage = $"{ resxFileHelper.GetErrorMessagesFromResource("GeneralException")} : { ex.Message}";
            }

            if (responseObject == null)
                responseObject = BuildResponseObject(false, returnMessage);

            return responseObject;
        }

        [Route(nameof(CustomerCodeFetch))]
        public HttpResponseMessage CustomerCodeFetch(CustomerFetch SearchObject)
        {

            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(CustomerCodeFetch), Level.Info.ToString());
                var ErrorMessage = string.Empty;
                var result = _FetchBAL.CustomerCodeFetch(SearchObject);
                if (result == null)
                {
                    responseObject = BuildResponseObject(HttpStatusCode.NotFound);
                }
                else
                {
                    var serialisedData = JsonConvert.SerializeObject(result);
                    responseObject = BuildResponseObject(HttpStatusCode.OK, serialisedData);
                }

                Log4NetLogger.LogExit(_FileName, nameof(EODCaptureModel), Level.Info.ToString());
            }
            catch (Exception ex)
            {
                returnMessage = $"{ resxFileHelper.GetErrorMessagesFromResource("GeneralException")} : { ex.Message}";
            }

            if (responseObject == null)
                responseObject = BuildResponseObject(false, returnMessage);

            return responseObject;
        }

        [Route(nameof(CRMRequestAssetFetch))]
        public HttpResponseMessage CRMRequestAssetFetch(CRMRequestAssetFetch SearchObject)
        {

            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(CRMRequestAssetFetch), Level.Info.ToString());
                var ErrorMessage = string.Empty;
                var result = _FetchBAL.CRMRequestAssetFetch(SearchObject);
                if (result == null)
                {
                    responseObject = BuildResponseObject(HttpStatusCode.NotFound);
                }
                else
                {
                    var serialisedData = JsonConvert.SerializeObject(result);
                    responseObject = BuildResponseObject(HttpStatusCode.OK, serialisedData);
                }

                Log4NetLogger.LogExit(_FileName, nameof(CRMRequestAssetFetch), Level.Info.ToString());
            }
            catch (Exception ex)
            {
                returnMessage = $"{ resxFileHelper.GetErrorMessagesFromResource("GeneralException")} : { ex.Message}";
            }

            if (responseObject == null)
                responseObject = BuildResponseObject(false, returnMessage);

            return responseObject;
        }
        [Route(nameof(CRMWorkorderStaffFetch))]
        public HttpResponseMessage CRMWorkorderStaffFetch(CRMWorkorderStaffFetch SearchObject)
        {

            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(CRMWorkorderStaffFetch), Level.Info.ToString());
                var ErrorMessage = string.Empty;
                var result = _FetchBAL.CRMWorkorderStaffFetch(SearchObject);
                if (result == null)
                {
                    responseObject = BuildResponseObject(HttpStatusCode.NotFound);
                }
                else
                {
                    var serialisedData = JsonConvert.SerializeObject(result);
                    responseObject = BuildResponseObject(HttpStatusCode.OK, serialisedData);
                }

                Log4NetLogger.LogExit(_FileName, nameof(CRMWorkorderStaffFetch), Level.Info.ToString());
            }
            catch (Exception ex)
            {
                returnMessage = $"{ resxFileHelper.GetErrorMessagesFromResource("GeneralException")} : { ex.Message}";
            }

            if (responseObject == null)
                responseObject = BuildResponseObject(false, returnMessage);

            return responseObject;
        }

        [Route(nameof(ContractorNameFetch))]
        public HttpResponseMessage ContractorNameFetch(ContractorNameSearch SearchObject)
        {

            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(ContractorNameFetch), Level.Info.ToString());
                var ErrorMessage = string.Empty;
                var result = _FetchBAL.ContractorNameFetch(SearchObject);
                if (result == null)
                {
                    responseObject = BuildResponseObject(HttpStatusCode.NotFound);
                }
                else
                {
                    var serialisedData = JsonConvert.SerializeObject(result);
                    responseObject = BuildResponseObject(HttpStatusCode.OK, serialisedData);
                }

                Log4NetLogger.LogExit(_FileName, nameof(ContractorNameFetch), Level.Info.ToString());
            }
            catch (Exception ex)
            {
                returnMessage = $"{ resxFileHelper.GetErrorMessagesFromResource("GeneralException")} : { ex.Message}";
            }

            if (responseObject == null)
                responseObject = BuildResponseObject(false, returnMessage);

            return responseObject;
        }


        [Route(nameof(BookingWorkOrderNoFetch))]
        public HttpResponseMessage BookingWorkOrderNoFetch(BookingFetch SearchObject)
        {

            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(BookingWorkOrderNoFetch), Level.Info.ToString());
                var ErrorMessage = string.Empty;
                var result = _FetchBAL.BookingWorkOrderNoFetch(SearchObject);
                if (result == null)
                {
                    responseObject = BuildResponseObject(HttpStatusCode.NotFound);
                }
                else
                {
                    var serialisedData = JsonConvert.SerializeObject(result);
                    responseObject = BuildResponseObject(HttpStatusCode.OK, serialisedData);
                }

                Log4NetLogger.LogExit(_FileName, nameof(BookingWorkOrderNoFetch), Level.Info.ToString());
            }
            catch (Exception ex)
            {
                returnMessage = $"{ resxFileHelper.GetErrorMessagesFromResource("GeneralException")} : { ex.Message}";
            }

            if (responseObject == null)
                responseObject = BuildResponseObject(false, returnMessage);

            return responseObject;
        }

        [Route(nameof(BookingAssetNoFetch))]
        public HttpResponseMessage BookingAssetNoFetch(BookingFetch SearchObject)
        {

            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(BookingAssetNoFetch), Level.Info.ToString());
                var ErrorMessage = string.Empty;
                var result = _FetchBAL.BookingAssetNoFetch(SearchObject);
                if (result == null)
                {
                    responseObject = BuildResponseObject(HttpStatusCode.NotFound);
                }
                else
                {
                    var serialisedData = JsonConvert.SerializeObject(result);
                    responseObject = BuildResponseObject(HttpStatusCode.OK, serialisedData);
                }

                Log4NetLogger.LogExit(_FileName, nameof(BookingAssetNoFetch), Level.Info.ToString());
            }
            catch (Exception ex)
            {
                returnMessage = $"{ resxFileHelper.GetErrorMessagesFromResource("GeneralException")} : { ex.Message}";
            }

            if (responseObject == null)
                responseObject = BuildResponseObject(false, returnMessage);

            return responseObject;
        }

        [Route(nameof(UserShiftLeaveDetailsFetch))]
        public HttpResponseMessage UserShiftLeaveDetailsFetch(UserShiftLeaveDetailsFetch SearchObject)
        {

            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(UserShiftLeaveDetailsFetch), Level.Info.ToString());
                var ErrorMessage = string.Empty;
                var result = _FetchBAL.UserShiftLeaveDetailsFetch(SearchObject);
                if (result == null)
                {
                    responseObject = BuildResponseObject(HttpStatusCode.NotFound);
                }
                else
                {
                    var serialisedData = JsonConvert.SerializeObject(result);
                    responseObject = BuildResponseObject(HttpStatusCode.OK, serialisedData);
                }

                Log4NetLogger.LogExit(_FileName, nameof(UserShiftLeaveDetailsFetch), Level.Info.ToString());
            }
            catch (Exception ex)
            {
                returnMessage = $"{ resxFileHelper.GetErrorMessagesFromResource("GeneralException")} : { ex.Message}";
            }

            if (responseObject == null)
                responseObject = BuildResponseObject(false, returnMessage);

            return responseObject;
        }

        [Route(nameof(UserTainingParticipantFetch))]
        public HttpResponseMessage UserTainingParticipantFetch(UserTainingParticipantFetch SearchObject)
        {

            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(UserTainingParticipantFetch), Level.Info.ToString());
                var ErrorMessage = string.Empty;
                var result = _FetchBAL.UserTainingParticipantFetch(SearchObject);
                if (result == null)
                {
                    responseObject = BuildResponseObject(HttpStatusCode.NotFound);
                }
                else
                {
                    var serialisedData = JsonConvert.SerializeObject(result);
                    responseObject = BuildResponseObject(HttpStatusCode.OK, serialisedData);
                }

                Log4NetLogger.LogExit(_FileName, nameof(UserTainingParticipantFetch), Level.Info.ToString());
            }
            catch (Exception ex)
            {
                returnMessage = $"{ resxFileHelper.GetErrorMessagesFromResource("GeneralException")} : { ex.Message}";
            }

            if (responseObject == null)
                responseObject = BuildResponseObject(false, returnMessage);

            return responseObject;
        }
        [Route(nameof(FilureSymptomCodeFetch))]
        public HttpResponseMessage FilureSymptomCodeFetch(FilureSymptomCodeFetch SearchObject)
        {

            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(FilureSymptomCodeFetch), Level.Info.ToString());
                var ErrorMessage = string.Empty;
                var result = _FetchBAL.FilureSymptomCodeFetch(SearchObject);
                if (result == null)
                {
                    responseObject = BuildResponseObject(HttpStatusCode.NotFound);
                }
                else
                {
                    var serialisedData = JsonConvert.SerializeObject(result);
                    responseObject = BuildResponseObject(HttpStatusCode.OK, serialisedData);
                }

                Log4NetLogger.LogExit(_FileName, nameof(FilureSymptomCodeFetch), Level.Info.ToString());
            }
            catch (Exception ex)
            {
                returnMessage = $"{ resxFileHelper.GetErrorMessagesFromResource("GeneralException")} : { ex.Message}";
            }

            if (responseObject == null)
                responseObject = BuildResponseObject(false, returnMessage);

            return responseObject;
        }
        [Route(nameof(FollowupCarFetch))]
        public HttpResponseMessage FollowupCarFetch(FollowupCarFetch SearchObject)
        {

            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(FollowupCarFetch), Level.Info.ToString());
                var ErrorMessage = string.Empty;
                var result = _FetchBAL.FollowupCarFetch(SearchObject);
                if (result == null)
                {
                    responseObject = BuildResponseObject(HttpStatusCode.NotFound);
                }
                else
                {
                    var serialisedData = JsonConvert.SerializeObject(result);
                    responseObject = BuildResponseObject(HttpStatusCode.OK, serialisedData);
                }

                Log4NetLogger.LogExit(_FileName, nameof(FollowupCarFetch), Level.Info.ToString());
            }
            catch (Exception ex)
            {
                returnMessage = $"{ resxFileHelper.GetErrorMessagesFromResource("GeneralException")} : { ex.Message}";
            }

            if (responseObject == null)
                responseObject = BuildResponseObject(false, returnMessage);

            return responseObject;
        }


        [Route(nameof(BlockCascCodeFetch))]
        public HttpResponseMessage BlockCascCodeFetch(AreaFetch SearchObject)
        {

            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(FollowupCarFetch), Level.Info.ToString());
                var ErrorMessage = string.Empty;
                var result = _FetchBAL.BlockCascCodeFetch(SearchObject);
                if (result == null)
                {
                    responseObject = BuildResponseObject(HttpStatusCode.NotFound);
                }
                else
                {
                    var serialisedData = JsonConvert.SerializeObject(result);
                    responseObject = BuildResponseObject(HttpStatusCode.OK, serialisedData);
                }

                Log4NetLogger.LogExit(_FileName, nameof(FollowupCarFetch), Level.Info.ToString());
            }
            catch (Exception ex)
            {
                returnMessage = $"{ resxFileHelper.GetErrorMessagesFromResource("GeneralException")} : { ex.Message}";
            }

            if (responseObject == null)
                responseObject = BuildResponseObject(false, returnMessage);

            return responseObject;
        }

        //[Route(nameof(UserAreaCascCodeFetch))]
        //public HttpResponseMessage UserAreaCascCodeFetch(AreaFetch SearchObject)
        //{

        //    try
        //    {
        //        Log4NetLogger.LogEntry(_FileName, nameof(FollowupCarFetch), Level.Info.ToString());
        //        var ErrorMessage = string.Empty;
        //        var result = _FetchBAL.UserAreaCascCodeFetch(SearchObject);
        //        if (result == null)
        //        {
        //            responseObject = BuildResponseObject(HttpStatusCode.NotFound);
        //        }
        //        else
        //        {
        //            var serialisedData = JsonConvert.SerializeObject(result);
        //            responseObject = BuildResponseObject(HttpStatusCode.OK, serialisedData);
        //        }

        //        Log4NetLogger.LogExit(_FileName, nameof(FollowupCarFetch), Level.Info.ToString());
        //    }
        //    catch (Exception ex)
        //    {
        //        returnMessage = $"{ resxFileHelper.GetErrorMessagesFromResource("GeneralException")} : { ex.Message}";
        //    }

        //    if (responseObject == null)
        //        responseObject = BuildResponseObject(false, returnMessage);

        //    return responseObject;
        //}

        [Route(nameof(LevelCascCodeFetch))]
        public HttpResponseMessage LevelCascCodeFetch(AreaFetch SearchObject)
        {

            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(FollowupCarFetch), Level.Info.ToString());
                var ErrorMessage = string.Empty;
                var result = _FetchBAL.LevelCascCodeFetch(SearchObject);
                if (result == null)
                {
                    responseObject = BuildResponseObject(HttpStatusCode.NotFound);
                }
                else
                {
                    var serialisedData = JsonConvert.SerializeObject(result);
                    responseObject = BuildResponseObject(HttpStatusCode.OK, serialisedData);
                }
                Log4NetLogger.LogExit(_FileName, nameof(FollowupCarFetch), Level.Info.ToString());
            }
            catch (Exception ex)
            {
                returnMessage = $"{ resxFileHelper.GetErrorMessagesFromResource("GeneralException")} : { ex.Message}";
            }

            if (responseObject == null)
                responseObject = BuildResponseObject(false, returnMessage);

            return responseObject;
        }

        [Route(nameof(AreaCascCodeFetch))]
        public HttpResponseMessage AreaCascCodeFetch(AreaFetch SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(FollowupCarFetch), Level.Info.ToString());
                var ErrorMessage = string.Empty;
                var result = _FetchBAL.AreaCascCodeFetch(SearchObject);
                if (result == null)
                {
                    responseObject = BuildResponseObject(HttpStatusCode.NotFound);
                }
                else
                {
                    var serialisedData = JsonConvert.SerializeObject(result);
                    responseObject = BuildResponseObject(HttpStatusCode.OK, serialisedData);
                }
                Log4NetLogger.LogExit(_FileName, nameof(FollowupCarFetch), Level.Info.ToString());
            }
            catch (Exception ex)
            {
                returnMessage = $"{ resxFileHelper.GetErrorMessagesFromResource("GeneralException")} : { ex.Message}";
            }
            if (responseObject == null)
                responseObject = BuildResponseObject(false, returnMessage);
            return responseObject;
        }


        [Route(nameof(BookingLocationFetch))]
        public HttpResponseMessage BookingLocationFetch(UserLocationCodeSearch SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(FollowupCarFetch), Level.Info.ToString());
                var ErrorMessage = string.Empty;
                var result = _FetchBAL.BookingLocationFetch(SearchObject);
                if (result == null)
                {
                    responseObject = BuildResponseObject(HttpStatusCode.NotFound);
                }
                else
                {
                    var serialisedData = JsonConvert.SerializeObject(result);
                    responseObject = BuildResponseObject(HttpStatusCode.OK, serialisedData);
                }
                Log4NetLogger.LogExit(_FileName, nameof(FollowupCarFetch), Level.Info.ToString());
            }
            catch (Exception ex)
            {
                returnMessage = $"{ resxFileHelper.GetErrorMessagesFromResource("GeneralException")} : { ex.Message}";
            }
            if (responseObject == null)
                responseObject = BuildResponseObject(false, returnMessage);
            return responseObject;
        }



        [HttpPost]
        [Route(nameof(CRMFetchRequestTypedetais))]
        public HttpResponseMessage CRMFetchRequestTypedetais(CRMRequestType SearchObject)
        {

            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(CRMFetchRequestTypedetais), Level.Info.ToString());
                var ErrorMessage = string.Empty;
                var result = _FetchBAL.CRMFetchRequestTypedetais(SearchObject);
                if (result == null)
                {
                    responseObject = BuildResponseObject(HttpStatusCode.NotFound);
                }
                else
                {
                    var serialisedData = JsonConvert.SerializeObject(result);
                    responseObject = BuildResponseObject(HttpStatusCode.OK, serialisedData);
                }

                Log4NetLogger.LogExit(_FileName, nameof(CRMWorkorderRequestFetch), Level.Info.ToString());
            }
            catch (Exception ex)
            {
                returnMessage = $"{resxFileHelper.GetErrorMessagesFromResource("GeneralException")} : {ex.Message}";
            }

            if (responseObject == null)
                responseObject = BuildResponseObject(false, returnMessage);

            return responseObject;
        }


        [HttpPost]
        [Route(nameof(FetchItemNo))]
        public HttpResponseMessage FetchItemNo(ItemMstFetchEntity SearchObject)
        {

            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(FetchItemNo), Level.Info.ToString());
                var ErrorMessage = string.Empty;
                var result = _FetchBAL.FetchItemNo(SearchObject);
                if (result == null)
                {
                    responseObject = BuildResponseObject(HttpStatusCode.NotFound);
                }
                else
                {
                    var serialisedData = JsonConvert.SerializeObject(result);
                    responseObject = BuildResponseObject(HttpStatusCode.OK, serialisedData);
                }

                Log4NetLogger.LogExit(_FileName, nameof(FetchItemNo), Level.Info.ToString());
            }
            catch (Exception ex)
            {
                returnMessage = $"{resxFileHelper.GetErrorMessagesFromResource("GeneralException")} : {ex.Message}";
            }

            if (responseObject == null)
                responseObject = BuildResponseObject(false, returnMessage);

            return responseObject;
        }

        [HttpPost]
        [Route(nameof(FetchPartNo))]
        public HttpResponseMessage FetchPartNo(ItemMstFetchEntity SearchObject)
        {

            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(FetchPartNo), Level.Info.ToString());
                var ErrorMessage = string.Empty;
                var result = _FetchBAL.FetchPartNo(SearchObject);
                if (result == null)
                {
                    responseObject = BuildResponseObject(HttpStatusCode.NotFound);
                }
                else
                {
                    var serialisedData = JsonConvert.SerializeObject(result);
                    responseObject = BuildResponseObject(HttpStatusCode.OK, serialisedData);
                }

                Log4NetLogger.LogExit(_FileName, nameof(FetchPartNo), Level.Info.ToString());
            }
            catch (Exception ex)
            {
                returnMessage = $"{resxFileHelper.GetErrorMessagesFromResource("GeneralException")} : {ex.Message}";
            }

            if (responseObject == null)
                responseObject = BuildResponseObject(false, returnMessage);

            return responseObject;
        }


        #region LLS Fetch and Search


        [HttpPost]
        [Route(nameof(DepartmentCascCodeFetch))]
        public HttpResponseMessage DepartmentCascCodeFetch(UserAreaFetch SearchObject)
        {

            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(DepartmentCascCodeFetch), Level.Info.ToString());
                var ErrorMessage = string.Empty;
                var result = _FetchBAL.DepartmentCascCodeFetch(SearchObject);
                if (result == null)
                {
                    responseObject = BuildResponseObject(HttpStatusCode.NotFound);
                }
                else
                {
                    var serialisedData = JsonConvert.SerializeObject(result);
                    responseObject = BuildResponseObject(HttpStatusCode.OK, serialisedData);
                }

                Log4NetLogger.LogExit(_FileName, nameof(TypeCodeFetch), Level.Info.ToString());
            }
            catch (Exception ex)
            {
                returnMessage = $"{resxFileHelper.GetErrorMessagesFromResource("GeneralException")} : {ex.Message}";
            }

            if (responseObject == null)
                responseObject = BuildResponseObject(false, returnMessage);

            return responseObject;
        }

        [HttpPost]
        [Route(nameof(LLSUserAreaDetailsLocationMstDet_FetchLocCode))]
        public HttpResponseMessage LLSUserAreaDetailsLocationMstDet_FetchLocCode(UserAreaFetchs SearchObject)
        {

            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(LLSUserAreaDetailsLocationMstDet_FetchLocCode), Level.Info.ToString());
                var ErrorMessage = string.Empty;
                var result = _FetchBAL.LLSUserAreaDetailsLocationMstDet_FetchLocCode(SearchObject);
                if (result == null)
                {
                    responseObject = BuildResponseObject(HttpStatusCode.NotFound);
                }
                else
                {
                    var serialisedData = JsonConvert.SerializeObject(result);
                    responseObject = BuildResponseObject(HttpStatusCode.OK, serialisedData);
                }

                Log4NetLogger.LogExit(_FileName, nameof(TypeCodeFetch), Level.Info.ToString());
            }
            catch (Exception ex)
            {
                returnMessage = $"{resxFileHelper.GetErrorMessagesFromResource("GeneralException")} : {ex.Message}";
            }

            if (responseObject == null)
                responseObject = BuildResponseObject(false, returnMessage);

            return responseObject;
        }



        [Route(nameof(LinenItemCascCodeFetch))]
        public HttpResponseMessage LinenItemCascCodeFetch(LinenItemCodeFetch SearchObject)
        {

            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(FollowupCarFetch), Level.Info.ToString());
                var ErrorMessage = string.Empty;
                var result = _FetchBAL.LinenItemCascCodeFetch(SearchObject);
                if (result == null)
                {
                    responseObject = BuildResponseObject(HttpStatusCode.NotFound);
                }
                else
                {
                    var serialisedData = JsonConvert.SerializeObject(result);
                    responseObject = BuildResponseObject(HttpStatusCode.OK, serialisedData);
                }

                Log4NetLogger.LogExit(_FileName, nameof(FollowupCarFetch), Level.Info.ToString());
            }
            catch (Exception ex)
            {
                returnMessage = $"{ resxFileHelper.GetErrorMessagesFromResource("GeneralException")} : { ex.Message}";
            }

            if (responseObject == null)
                responseObject = BuildResponseObject(false, returnMessage);

            return responseObject;
        }

        [Route(nameof(LocationCascCodeFetch))]
        public HttpResponseMessage LocationCascCodeFetch(LocationCodeFetch SearchObject)
        {

            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(FollowupCarFetch), Level.Info.ToString());
                var ErrorMessage = string.Empty;
                var result = _FetchBAL.LocationCascCodeFetch(SearchObject);
                if (result == null)
                {
                    responseObject = BuildResponseObject(HttpStatusCode.NotFound);
                }
                else
                {
                    var serialisedData = JsonConvert.SerializeObject(result);
                    responseObject = BuildResponseObject(HttpStatusCode.OK, serialisedData);
                }

                Log4NetLogger.LogExit(_FileName, nameof(FollowupCarFetch), Level.Info.ToString());
            }
            catch (Exception ex)
            {
                returnMessage = $"{ resxFileHelper.GetErrorMessagesFromResource("GeneralException")} : { ex.Message}";
            }

            if (responseObject == null)
                responseObject = BuildResponseObject(false, returnMessage);

            return responseObject;
        }

        [HttpPost]
        [Route(nameof(Cleanlinenrequest_UserareaCodeFetch))]
        public HttpResponseMessage Cleanlinenrequest_UserareaCodeFetch(CleanLinenRequestModel SearchObject)
        {

            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Cleanlinenrequest_UserareaCodeFetch), Level.Info.ToString());
                var ErrorMessage = string.Empty;
                var result = _FetchBAL.Cleanlinenrequest_UserareaCodeFetch(SearchObject);
                if (result == null)
                {
                    responseObject = BuildResponseObject(HttpStatusCode.NotFound);
                }
                else
                {
                    var serialisedData = JsonConvert.SerializeObject(result);
                    responseObject = BuildResponseObject(HttpStatusCode.OK, serialisedData);
                }

                Log4NetLogger.LogExit(_FileName, nameof(TypeCodeFetch), Level.Info.ToString());
            }
            catch (Exception ex)
            {
                returnMessage = $"{resxFileHelper.GetErrorMessagesFromResource("GeneralException")} : {ex.Message}";
            }

            if (responseObject == null)
                responseObject = BuildResponseObject(false, returnMessage);

            return responseObject;
        }

        [HttpPost]
        [Route(nameof(CleanLinenRequestTxn_FetchLocCode))]
        public HttpResponseMessage CleanLinenRequestTxn_FetchLocCode(CleanLinenRequestModel SearchObject)
        {

            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(CleanLinenRequestTxn_FetchLocCode), Level.Info.ToString());
                var ErrorMessage = string.Empty;
                var result = _FetchBAL.CleanLinenRequestTxn_FetchLocCode(SearchObject);
                if (result == null)
                {
                    responseObject = BuildResponseObject(HttpStatusCode.NotFound);
                }
                else
                {
                    var serialisedData = JsonConvert.SerializeObject(result);
                    responseObject = BuildResponseObject(HttpStatusCode.OK, serialisedData);
                }

                Log4NetLogger.LogExit(_FileName, nameof(TypeCodeFetch), Level.Info.ToString());
            }
            catch (Exception ex)
            {
                returnMessage = $"{resxFileHelper.GetErrorMessagesFromResource("GeneralException")} : {ex.Message}";
            }

            if (responseObject == null)
                responseObject = BuildResponseObject(false, returnMessage);

            return responseObject;
        }

        [HttpPost]
        [Route(nameof(Cleanlinenrequest_FetchrequestBy))]
        public HttpResponseMessage Cleanlinenrequest_FetchrequestBy(CleanLinenRequestModel SearchObject)
        {

            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(FollowupCarFetch), Level.Info.ToString());
                var ErrorMessage = string.Empty;
                var result = _FetchBAL.Cleanlinenrequest_FetchrequestBy(SearchObject);
                if (result == null)
                {
                    responseObject = BuildResponseObject(HttpStatusCode.NotFound);
                }
                else
                {
                    var serialisedData = JsonConvert.SerializeObject(result);
                    responseObject = BuildResponseObject(HttpStatusCode.OK, serialisedData);
                }

                Log4NetLogger.LogExit(_FileName, nameof(FollowupCarFetch), Level.Info.ToString());
            }
            catch (Exception ex)
            {
                returnMessage = $"{ resxFileHelper.GetErrorMessagesFromResource("GeneralException")} : { ex.Message}";
            }

            if (responseObject == null)
                responseObject = BuildResponseObject(false, returnMessage);

            return responseObject;
        }

        [HttpPost]
        [Route(nameof(Cleanlinenrequestlinenitem_LinenCodeFetch))]
        public HttpResponseMessage Cleanlinenrequestlinenitem_LinenCodeFetch(LocationCodeFetch SearchObject)
        {

            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(FollowupCarFetch), Level.Info.ToString());
                var ErrorMessage = string.Empty;
                var result = _FetchBAL.Cleanlinenrequestlinenitem_LinenCodeFetch(SearchObject);
                if (result == null)
                {
                    responseObject = BuildResponseObject(HttpStatusCode.NotFound);
                }
                else
                {
                    var serialisedData = JsonConvert.SerializeObject(result);
                    responseObject = BuildResponseObject(HttpStatusCode.OK, serialisedData);
                }

                Log4NetLogger.LogExit(_FileName, nameof(FollowupCarFetch), Level.Info.ToString());
            }
            catch (Exception ex)
            {
                returnMessage = $"{ resxFileHelper.GetErrorMessagesFromResource("GeneralException")} : { ex.Message}";
            }

            if (responseObject == null)
                responseObject = BuildResponseObject(false, returnMessage);

            return responseObject;
        }

        [HttpPost]
        [Route(nameof(CleanLinenRequestLinenBag_FetchLaundryBag))]
        public HttpResponseMessage CleanLinenRequestLinenBag_FetchLaundryBag(LocationCodeFetch SearchObject)
        {

            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(FollowupCarFetch), Level.Info.ToString());
                var ErrorMessage = string.Empty;
                var result = _FetchBAL.CleanLinenRequestLinenBag_FetchLaundryBag(SearchObject);
                if (result == null)
                {
                    responseObject = BuildResponseObject(HttpStatusCode.NotFound);
                }
                else
                {
                    var serialisedData = JsonConvert.SerializeObject(result);
                    responseObject = BuildResponseObject(HttpStatusCode.OK, serialisedData);
                }

                Log4NetLogger.LogExit(_FileName, nameof(FollowupCarFetch), Level.Info.ToString());
            }
            catch (Exception ex)
            {
                returnMessage = $"{ resxFileHelper.GetErrorMessagesFromResource("GeneralException")} : { ex.Message}";
            }

            if (responseObject == null)
                responseObject = BuildResponseObject(false, returnMessage);

            return responseObject;
        }

        [HttpPost]
        [Route(nameof(LinenInjectionTxnDet_FetchLinenCode))]
        public HttpResponseMessage LinenInjectionTxnDet_FetchLinenCode(LinenConemnationModel SearchObject)
        {

            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(FollowupCarFetch), Level.Info.ToString());
                var ErrorMessage = string.Empty;
                var result = _FetchBAL.LinenInjectionTxnDet_FetchLinenCode(SearchObject);
                if (result == null)
                {
                    responseObject = BuildResponseObject(HttpStatusCode.NotFound);
                }
                else
                {
                    var serialisedData = JsonConvert.SerializeObject(result);
                    responseObject = BuildResponseObject(HttpStatusCode.OK, serialisedData);
                }

                Log4NetLogger.LogExit(_FileName, nameof(FollowupCarFetch), Level.Info.ToString());
            }
            catch (Exception ex)
            {
                returnMessage = $"{ resxFileHelper.GetErrorMessagesFromResource("GeneralException")} : { ex.Message}";
            }

            if (responseObject == null)
                responseObject = BuildResponseObject(false, returnMessage);

            return responseObject;
        }

        [HttpPost]
        [Route(nameof(CleanLinenDespatchTxn_FetchReceivedBy))]
        public HttpResponseMessage CleanLinenDespatchTxn_FetchReceivedBy(CleanLinenDespatchModel SearchObject)
        {

            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(FollowupCarFetch), Level.Info.ToString());
                var ErrorMessage = string.Empty;
                var result = _FetchBAL.CleanLinenDespatchTxn_FetchReceivedBy(SearchObject);
                if (result == null)
                {
                    responseObject = BuildResponseObject(HttpStatusCode.NotFound);
                }
                else
                {
                    var serialisedData = JsonConvert.SerializeObject(result);
                    responseObject = BuildResponseObject(HttpStatusCode.OK, serialisedData);
                }

                Log4NetLogger.LogExit(_FileName, nameof(FollowupCarFetch), Level.Info.ToString());
            }
            catch (Exception ex)
            {
                returnMessage = $"{ resxFileHelper.GetErrorMessagesFromResource("GeneralException")} : { ex.Message}";
            }

            if (responseObject == null)
                responseObject = BuildResponseObject(false, returnMessage);

            return responseObject;
        }

        [HttpPost]
        [Route(nameof(CleanLinenDespatchTxnDet_FetchLinenCode))]
        public HttpResponseMessage CleanLinenDespatchTxnDet_FetchLinenCode(CleanLinenDespatchModel SearchObject)
        {

            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(FollowupCarFetch), Level.Info.ToString());
                var ErrorMessage = string.Empty;
                var result = _FetchBAL.CleanLinenDespatchTxnDet_FetchLinenCode(SearchObject);
                if (result == null)
                {
                    responseObject = BuildResponseObject(HttpStatusCode.NotFound);
                }
                else
                {
                    var serialisedData = JsonConvert.SerializeObject(result);
                    responseObject = BuildResponseObject(HttpStatusCode.OK, serialisedData);
                }

                Log4NetLogger.LogExit(_FileName, nameof(FollowupCarFetch), Level.Info.ToString());
            }
            catch (Exception ex)
            {
                returnMessage = $"{ resxFileHelper.GetErrorMessagesFromResource("GeneralException")} : { ex.Message}";
            }

            if (responseObject == null)
                responseObject = BuildResponseObject(false, returnMessage);

            return responseObject;
        }
        #region CleanLinenIssue
        [HttpPost]
        [Route(nameof(CleanLinenIssueTxn_FetchCLRDocNo))]
        public HttpResponseMessage CleanLinenIssueTxn_FetchCLRDocNo(CleanLinenIssueModel SearchObject)
        {

            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(FollowupCarFetch), Level.Info.ToString());
                var ErrorMessage = string.Empty;
                var result = _FetchBAL.CleanLinenIssueTxn_FetchCLRDocNo(SearchObject);
                if (result == null)
                {
                    responseObject = BuildResponseObject(HttpStatusCode.NotFound);
                }
                else
                {
                    var serialisedData = JsonConvert.SerializeObject(result);
                    responseObject = BuildResponseObject(HttpStatusCode.OK, serialisedData);
                }

                Log4NetLogger.LogExit(_FileName, nameof(FollowupCarFetch), Level.Info.ToString());
            }
            catch (Exception ex)
            {
                returnMessage = $"{ resxFileHelper.GetErrorMessagesFromResource("GeneralException")} : { ex.Message}";
            }

            if (responseObject == null)
                responseObject = BuildResponseObject(false, returnMessage);

            return responseObject;
        }


        [HttpPost]
        [Route(nameof(CleanLinenIssueTxn_Fetch1stReceivedBy))]
        public HttpResponseMessage CleanLinenIssueTxn_Fetch1stReceivedBy(CleanLinenIssueModel SearchObject)
        {

            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(FollowupCarFetch), Level.Info.ToString());
                var ErrorMessage = string.Empty;
                var result = _FetchBAL.CleanLinenIssueTxn_Fetch1stReceivedBy(SearchObject);
                if (result == null)
                {
                    responseObject = BuildResponseObject(HttpStatusCode.NotFound);
                }
                else
                {
                    var serialisedData = JsonConvert.SerializeObject(result);
                    responseObject = BuildResponseObject(HttpStatusCode.OK, serialisedData);
                }

                Log4NetLogger.LogExit(_FileName, nameof(FollowupCarFetch), Level.Info.ToString());
            }
            catch (Exception ex)
            {
                returnMessage = $"{ resxFileHelper.GetErrorMessagesFromResource("GeneralException")} : { ex.Message}";
            }

            if (responseObject == null)
                responseObject = BuildResponseObject(false, returnMessage);

            return responseObject;
        }

        [HttpPost]
        [Route(nameof(CleanLinenIssueTxn_Fetch2ndReceivedBy))]
        public HttpResponseMessage CleanLinenIssueTxn_Fetch2ndReceivedBy(CleanLinenIssueModel SearchObject)
        {

            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(FollowupCarFetch), Level.Info.ToString());
                var ErrorMessage = string.Empty;
                var result = _FetchBAL.CleanLinenIssueTxn_Fetch2ndReceivedBy(SearchObject);
                if (result == null)
                {
                    responseObject = BuildResponseObject(HttpStatusCode.NotFound);
                }
                else
                {
                    var serialisedData = JsonConvert.SerializeObject(result);
                    responseObject = BuildResponseObject(HttpStatusCode.OK, serialisedData);
                }

                Log4NetLogger.LogExit(_FileName, nameof(FollowupCarFetch), Level.Info.ToString());
            }
            catch (Exception ex)
            {
                returnMessage = $"{ resxFileHelper.GetErrorMessagesFromResource("GeneralException")} : { ex.Message}";
            }

            if (responseObject == null)
                responseObject = BuildResponseObject(false, returnMessage);

            return responseObject;
        }

        [HttpPost]
        [Route(nameof(CleanLinenIssueTxn_FetchVerifier))]
        public HttpResponseMessage CleanLinenIssueTxn_FetchVerifier(CleanLinenIssueModel SearchObject)
        {

            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(FollowupCarFetch), Level.Info.ToString());
                var ErrorMessage = string.Empty;
                var result = _FetchBAL.CleanLinenIssueTxn_FetchVerifier(SearchObject);
                if (result == null)
                {
                    responseObject = BuildResponseObject(HttpStatusCode.NotFound);
                }
                else
                {
                    var serialisedData = JsonConvert.SerializeObject(result);
                    responseObject = BuildResponseObject(HttpStatusCode.OK, serialisedData);
                }

                Log4NetLogger.LogExit(_FileName, nameof(FollowupCarFetch), Level.Info.ToString());
            }
            catch (Exception ex)
            {
                returnMessage = $"{ resxFileHelper.GetErrorMessagesFromResource("GeneralException")} : { ex.Message}";
            }

            if (responseObject == null)
                responseObject = BuildResponseObject(false, returnMessage);

            return responseObject;
        }

        [HttpPost]
        [Route(nameof(CleanLinenIssueTxn_FetchDeliveredBy))]
        public HttpResponseMessage CleanLinenIssueTxn_FetchDeliveredBy(CleanLinenIssueModel SearchObject)
        {

            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(FollowupCarFetch), Level.Info.ToString());
                var ErrorMessage = string.Empty;
                var result = _FetchBAL.CleanLinenIssueTxn_FetchDeliveredBy(SearchObject);
                if (result == null)
                {
                    responseObject = BuildResponseObject(HttpStatusCode.NotFound);
                }
                else
                {
                    var serialisedData = JsonConvert.SerializeObject(result);
                    responseObject = BuildResponseObject(HttpStatusCode.OK, serialisedData);
                }

                Log4NetLogger.LogExit(_FileName, nameof(FollowupCarFetch), Level.Info.ToString());
            }
            catch (Exception ex)
            {
                returnMessage = $"{ resxFileHelper.GetErrorMessagesFromResource("GeneralException")} : { ex.Message}";
            }

            if (responseObject == null)
                responseObject = BuildResponseObject(false, returnMessage);

            return responseObject;
        }

        [HttpPost]
        [Route(nameof(CleanLinenIssueLinenBagTxnDet_FetchLaundryBag))]
        public HttpResponseMessage CleanLinenIssueLinenBagTxnDet_FetchLaundryBag(CleanLinenIssueModel SearchObject)
        {

            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(FollowupCarFetch), Level.Info.ToString());
                var ErrorMessage = string.Empty;
                var result = _FetchBAL.CleanLinenIssueLinenBagTxnDet_FetchLaundryBag(SearchObject);
                if (result == null)
                {
                    responseObject = BuildResponseObject(HttpStatusCode.NotFound);
                }
                else
                {
                    var serialisedData = JsonConvert.SerializeObject(result);
                    responseObject = BuildResponseObject(HttpStatusCode.OK, serialisedData);
                }

                Log4NetLogger.LogExit(_FileName, nameof(FollowupCarFetch), Level.Info.ToString());
            }
            catch (Exception ex)
            {
                returnMessage = $"{ resxFileHelper.GetErrorMessagesFromResource("GeneralException")} : { ex.Message}";
            }

            if (responseObject == null)
                responseObject = BuildResponseObject(false, returnMessage);

            return responseObject;
        }
        #endregion
        [HttpPost]
        [Route(nameof(DriverDetailsMstDet_FetchLicenseCode))]
        public HttpResponseMessage DriverDetailsMstDet_FetchLicenseCode(DriverDetailsModel SearchObject)
        {

            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(FollowupCarFetch), Level.Info.ToString());
                var ErrorMessage = string.Empty;
                var result = _FetchBAL.DriverDetailsMstDet_FetchLicenseCode(SearchObject);
                if (result == null)
                {
                    responseObject = BuildResponseObject(HttpStatusCode.NotFound);
                }
                else
                {
                    var serialisedData = JsonConvert.SerializeObject(result);
                    responseObject = BuildResponseObject(HttpStatusCode.OK, serialisedData);
                }

                Log4NetLogger.LogExit(_FileName, nameof(FollowupCarFetch), Level.Info.ToString());
            }
            catch (Exception ex)
            {
                returnMessage = $"{ resxFileHelper.GetErrorMessagesFromResource("GeneralException")} : { ex.Message}";
            }

            if (responseObject == null)
                responseObject = BuildResponseObject(false, returnMessage);

            return responseObject;
        }

        [HttpPost]
        [Route(nameof(LinenAdjustmentTxn_FetchAuthorisedBy))]
        public HttpResponseMessage LinenAdjustmentTxn_FetchAuthorisedBy(LinenAdjustmentsModel SearchObject)
        {

            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(FollowupCarFetch), Level.Info.ToString());
                var ErrorMessage = string.Empty;
                var result = _FetchBAL.LinenAdjustmentTxn_FetchAuthorisedBy(SearchObject);
                if (result == null)
                {
                    responseObject = BuildResponseObject(HttpStatusCode.NotFound);
                }
                else
                {
                    var serialisedData = JsonConvert.SerializeObject(result);
                    responseObject = BuildResponseObject(HttpStatusCode.OK, serialisedData);
                }

                Log4NetLogger.LogExit(_FileName, nameof(FollowupCarFetch), Level.Info.ToString());
            }
            catch (Exception ex)
            {
                returnMessage = $"{ resxFileHelper.GetErrorMessagesFromResource("GeneralException")} : { ex.Message}";
            }

            if (responseObject == null)
                responseObject = BuildResponseObject(false, returnMessage);

            return responseObject;
        }

        [HttpPost]
        [Route(nameof(LinenAdjustmentTxn_FetchInventoryDocNo))]
        public HttpResponseMessage LinenAdjustmentTxn_FetchInventoryDocNo(LinenAdjustmentsModel SearchObject)
        {

            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(FollowupCarFetch), Level.Info.ToString());
                var ErrorMessage = string.Empty;
                var result = _FetchBAL.LinenAdjustmentTxn_FetchInventoryDocNo(SearchObject);
                if (result == null)
                {
                    responseObject = BuildResponseObject(HttpStatusCode.NotFound);
                }
                else
                {
                    var serialisedData = JsonConvert.SerializeObject(result);
                    responseObject = BuildResponseObject(HttpStatusCode.OK, serialisedData);
                }

                Log4NetLogger.LogExit(_FileName, nameof(FollowupCarFetch), Level.Info.ToString());
            }
            catch (Exception ex)
            {
                returnMessage = $"{ resxFileHelper.GetErrorMessagesFromResource("GeneralException")} : { ex.Message}";
            }

            if (responseObject == null)
                responseObject = BuildResponseObject(false, returnMessage);

            return responseObject;
        }

        [HttpPost]
        [Route(nameof(LinenAdjustmentTxnDet_FetchLinenCode))]
        public HttpResponseMessage LinenAdjustmentTxnDet_FetchLinenCode(LinenAdjustmentsModel SearchObject)
        {

            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(FollowupCarFetch), Level.Info.ToString());
                var ErrorMessage = string.Empty;
                var result = _FetchBAL.LinenAdjustmentTxnDet_FetchLinenCode(SearchObject);
                if (result == null)
                {
                    responseObject = BuildResponseObject(HttpStatusCode.NotFound);
                }
                else
                {
                    var serialisedData = JsonConvert.SerializeObject(result);
                    responseObject = BuildResponseObject(HttpStatusCode.OK, serialisedData);
                }

                Log4NetLogger.LogExit(_FileName, nameof(FollowupCarFetch), Level.Info.ToString());
            }
            catch (Exception ex)
            {
                returnMessage = $"{ resxFileHelper.GetErrorMessagesFromResource("GeneralException")} : { ex.Message}";
            }

            if (responseObject == null)
                responseObject = BuildResponseObject(false, returnMessage);

            return responseObject;
        }

        [HttpPost]
        [Route(nameof(VehicleDetailsMstDet_FetchLicenseCode))]
        public HttpResponseMessage VehicleDetailsMstDet_FetchLicenseCode(VehicleDetailsModel SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(FollowupCarFetch), Level.Info.ToString());
                var ErrorMessage = string.Empty;
                var result = _FetchBAL.VehicleDetailsMstDet_FetchLicenseCode(SearchObject);
                if (result == null)
                {
                    responseObject = BuildResponseObject(HttpStatusCode.NotFound);
                }
                else
                {
                    var serialisedData = JsonConvert.SerializeObject(result);
                    responseObject = BuildResponseObject(HttpStatusCode.OK, serialisedData);
                }

                Log4NetLogger.LogExit(_FileName, nameof(FollowupCarFetch), Level.Info.ToString());
            }
            catch (Exception ex)
            {
                returnMessage = $"{ resxFileHelper.GetErrorMessagesFromResource("GeneralException")} : { ex.Message}";
            }

            if (responseObject == null)
                responseObject = BuildResponseObject(false, returnMessage);

            return responseObject;
        }

        [HttpPost]
        [Route(nameof(LinenRepairTxn_FetchRepairedBy))]
        public HttpResponseMessage LinenRepairTxn_FetchRepairedBy(LinenRepairModel SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(FollowupCarFetch), Level.Info.ToString());
                var ErrorMessage = string.Empty;
                var result = _FetchBAL.LinenRepairTxn_FetchRepairedBy(SearchObject);
                if (result == null)
                {
                    responseObject = BuildResponseObject(HttpStatusCode.NotFound);
                }
                else
                {
                    var serialisedData = JsonConvert.SerializeObject(result);
                    responseObject = BuildResponseObject(HttpStatusCode.OK, serialisedData);
                }

                Log4NetLogger.LogExit(_FileName, nameof(FollowupCarFetch), Level.Info.ToString());
            }
            catch (Exception ex)
            {
                returnMessage = $"{ resxFileHelper.GetErrorMessagesFromResource("GeneralException")} : { ex.Message}";
            }

            if (responseObject == null)
                responseObject = BuildResponseObject(false, returnMessage);

            return responseObject;
        }

        [HttpPost]
        [Route(nameof(LinenRepairTxn_FetchCheckedBy))]
        public HttpResponseMessage LinenRepairTxn_FetchCheckedBy(LinenRepairModel SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(FollowupCarFetch), Level.Info.ToString());
                var ErrorMessage = string.Empty;
                var result = _FetchBAL.LinenRepairTxn_FetchCheckedBy(SearchObject);
                if (result == null)
                {
                    responseObject = BuildResponseObject(HttpStatusCode.NotFound);
                }
                else
                {
                    var serialisedData = JsonConvert.SerializeObject(result);
                    responseObject = BuildResponseObject(HttpStatusCode.OK, serialisedData);
                }

                Log4NetLogger.LogExit(_FileName, nameof(FollowupCarFetch), Level.Info.ToString());
            }
            catch (Exception ex)
            {
                returnMessage = $"{ resxFileHelper.GetErrorMessagesFromResource("GeneralException")} : { ex.Message}";
            }

            if (responseObject == null)
                responseObject = BuildResponseObject(false, returnMessage);

            return responseObject;
        }

        [HttpPost]
        [Route(nameof(LinenRepairTxnDet_FetchLinenCode))]
        public HttpResponseMessage LinenRepairTxnDet_FetchLinenCode(LinenRepairModel SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(FollowupCarFetch), Level.Info.ToString());
                var ErrorMessage = string.Empty;
                var result = _FetchBAL.LinenRepairTxnDet_FetchLinenCode(SearchObject);
                if (result == null)
                {
                    responseObject = BuildResponseObject(HttpStatusCode.NotFound);
                }
                else
                {
                    var serialisedData = JsonConvert.SerializeObject(result);
                    responseObject = BuildResponseObject(HttpStatusCode.OK, serialisedData);
                }

                Log4NetLogger.LogExit(_FileName, nameof(FollowupCarFetch), Level.Info.ToString());
            }
            catch (Exception ex)
            {
                returnMessage = $"{ resxFileHelper.GetErrorMessagesFromResource("GeneralException")} : { ex.Message}";
            }

            if (responseObject == null)
                responseObject = BuildResponseObject(false, returnMessage);

            return responseObject;
        }

        [HttpPost]
        [Route(nameof(CentralLinenStoreHKeepingTxn_FetchYear))]
        public HttpResponseMessage CentralLinenStoreHKeepingTxn_FetchYear(CentralLinenStoreHousekeepingModel SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(FollowupCarFetch), Level.Info.ToString());
                var ErrorMessage = string.Empty;
                var result = _FetchBAL.CentralLinenStoreHKeepingTxn_FetchYear(SearchObject);
                if (result == null)
                {
                    responseObject = BuildResponseObject(HttpStatusCode.NotFound);
                }
                else
                {
                    var serialisedData = JsonConvert.SerializeObject(result);
                    responseObject = BuildResponseObject(HttpStatusCode.OK, serialisedData);
                }

                Log4NetLogger.LogExit(_FileName, nameof(FollowupCarFetch), Level.Info.ToString());
            }
            catch (Exception ex)
            {
                returnMessage = $"{ resxFileHelper.GetErrorMessagesFromResource("GeneralException")} : { ex.Message}";
            }

            if (responseObject == null)
                responseObject = BuildResponseObject(false, returnMessage);

            return responseObject;
        }

        [HttpPost]
        [Route(nameof(CentralLinenStoreHKeepingTxn_FetchMonth))]
        public HttpResponseMessage CentralLinenStoreHKeepingTxn_FetchMonth(CentralLinenStoreHousekeepingModel SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(FollowupCarFetch), Level.Info.ToString());
                var ErrorMessage = string.Empty;
                var result = _FetchBAL.CentralLinenStoreHKeepingTxn_FetchMonth(SearchObject);
                if (result == null)
                {
                    responseObject = BuildResponseObject(HttpStatusCode.NotFound);
                }
                else
                {
                    var serialisedData = JsonConvert.SerializeObject(result);
                    responseObject = BuildResponseObject(HttpStatusCode.OK, serialisedData);
                }

                Log4NetLogger.LogExit(_FileName, nameof(FollowupCarFetch), Level.Info.ToString());
            }
            catch (Exception ex)
            {
                returnMessage = $"{ resxFileHelper.GetErrorMessagesFromResource("GeneralException")} : { ex.Message}";
            }

            if (responseObject == null)
                responseObject = BuildResponseObject(false, returnMessage);

            return responseObject;
        }

        [HttpPost]
        [Route(nameof(CentralLinenStoreHKeepingTxnDet_FetchDate))]
        public HttpResponseMessage CentralLinenStoreHKeepingTxnDet_FetchDate(CentralLinenStoreHousekeepingModel SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(FollowupCarFetch), Level.Info.ToString());
                var ErrorMessage = string.Empty;
                var result = _FetchBAL.CentralLinenStoreHKeepingTxnDet_FetchDate(SearchObject);
                if (result == null)
                {
                    responseObject = BuildResponseObject(HttpStatusCode.NotFound);
                }
                else
                {
                    var serialisedData = JsonConvert.SerializeObject(result);
                    responseObject = BuildResponseObject(HttpStatusCode.OK, serialisedData);
                }

                Log4NetLogger.LogExit(_FileName, nameof(FollowupCarFetch), Level.Info.ToString());
            }
            catch (Exception ex)
            {
                returnMessage = $"{ resxFileHelper.GetErrorMessagesFromResource("GeneralException")} : { ex.Message}";
            }

            if (responseObject == null)
                responseObject = BuildResponseObject(false, returnMessage);

            return responseObject;
        }

        [HttpPost]
        [Route(nameof(SoiledLinenCollectionTxn_FetchLaundryPlant))]
        public HttpResponseMessage SoiledLinenCollectionTxn_FetchLaundryPlant(soildLinencollectionsModel SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(FollowupCarFetch), Level.Info.ToString());
                var ErrorMessage = string.Empty;
                var result = _FetchBAL.SoiledLinenCollectionTxn_FetchLaundryPlant(SearchObject);
                if (result == null)
                {
                    responseObject = BuildResponseObject(HttpStatusCode.NotFound);
                }
                else
                {
                    var serialisedData = JsonConvert.SerializeObject(result);
                    responseObject = BuildResponseObject(HttpStatusCode.OK, serialisedData);
                }

                Log4NetLogger.LogExit(_FileName, nameof(FollowupCarFetch), Level.Info.ToString());
            }
            catch (Exception ex)
            {
                returnMessage = $"{ resxFileHelper.GetErrorMessagesFromResource("GeneralException")} : { ex.Message}";
            }

            if (responseObject == null)
                responseObject = BuildResponseObject(false, returnMessage);

            return responseObject;
        }

        [HttpPost]
        [Route(nameof(SoiledLinenCollectionTxnDet_FetchUserAreaCode))]
        public HttpResponseMessage SoiledLinenCollectionTxnDet_FetchUserAreaCode(CentralLinenStoreHousekeepingModel SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(FollowupCarFetch), Level.Info.ToString());
                var ErrorMessage = string.Empty;
                var result = _FetchBAL.SoiledLinenCollectionTxnDet_FetchUserAreaCode(SearchObject);
                if (result == null)
                {
                    responseObject = BuildResponseObject(HttpStatusCode.NotFound);
                }
                else
                {
                    var serialisedData = JsonConvert.SerializeObject(result);
                    responseObject = BuildResponseObject(HttpStatusCode.OK, serialisedData);
                }

                Log4NetLogger.LogExit(_FileName, nameof(FollowupCarFetch), Level.Info.ToString());
            }
            catch (Exception ex)
            {
                returnMessage = $"{ resxFileHelper.GetErrorMessagesFromResource("GeneralException")} : { ex.Message}";
            }

            if (responseObject == null)
                responseObject = BuildResponseObject(false, returnMessage);

            return responseObject;
        }

        [HttpPost]
        [Route(nameof(SoiledLinenCollectionTxnDet_FetchLocCode))]
        public HttpResponseMessage SoiledLinenCollectionTxnDet_FetchLocCode(CentralLinenStoreHousekeepingModel SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(FollowupCarFetch), Level.Info.ToString());
                var ErrorMessage = string.Empty;
                var result = _FetchBAL.SoiledLinenCollectionTxnDet_FetchLocCode(SearchObject);
                if (result == null)
                {
                    responseObject = BuildResponseObject(HttpStatusCode.NotFound);
                }
                else
                {
                    var serialisedData = JsonConvert.SerializeObject(result);
                    responseObject = BuildResponseObject(HttpStatusCode.OK, serialisedData);
                }

                Log4NetLogger.LogExit(_FileName, nameof(FollowupCarFetch), Level.Info.ToString());
            }
            catch (Exception ex)
            {
                returnMessage = $"{ resxFileHelper.GetErrorMessagesFromResource("GeneralException")} : { ex.Message}";
            }

            if (responseObject == null)
                responseObject = BuildResponseObject(false, returnMessage);

            return responseObject;
        }

        [HttpPost]
        [Route(nameof(SoiledLinenCollectionTxnDet_FetchCollectionSchedule))]
        public HttpResponseMessage SoiledLinenCollectionTxnDet_FetchCollectionSchedule(soildLinencollectionsModel SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(FollowupCarFetch), Level.Info.ToString());
                var ErrorMessage = string.Empty;
                var result = _FetchBAL.SoiledLinenCollectionTxnDet_FetchCollectionSchedule(SearchObject);
                if (result == null)
                {
                    responseObject = BuildResponseObject(HttpStatusCode.NotFound);
                }
                else
                {
                    var serialisedData = JsonConvert.SerializeObject(result);
                    responseObject = BuildResponseObject(HttpStatusCode.OK, serialisedData);
                }

                Log4NetLogger.LogExit(_FileName, nameof(FollowupCarFetch), Level.Info.ToString());
            }
            catch (Exception ex)
            {
                returnMessage = $"{ resxFileHelper.GetErrorMessagesFromResource("GeneralException")} : { ex.Message}";
            }

            if (responseObject == null)
                responseObject = BuildResponseObject(false, returnMessage);

            return responseObject;
        }

        [HttpPost]
        [Route(nameof(SoiledLinenCollectionTxnDet_FetchVerifiedBy))]
        public HttpResponseMessage SoiledLinenCollectionTxnDet_FetchVerifiedBy(soildLinencollectionsModel SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(FollowupCarFetch), Level.Info.ToString());
                var ErrorMessage = string.Empty;
                var result = _FetchBAL.SoiledLinenCollectionTxnDet_FetchVerifiedBy(SearchObject);
                if (result == null)
                {
                    responseObject = BuildResponseObject(HttpStatusCode.NotFound);
                }
                else
                {
                    var serialisedData = JsonConvert.SerializeObject(result);
                    responseObject = BuildResponseObject(HttpStatusCode.OK, serialisedData);
                }

                Log4NetLogger.LogExit(_FileName, nameof(FollowupCarFetch), Level.Info.ToString());
            }
            catch (Exception ex)
            {
                returnMessage = $"{ resxFileHelper.GetErrorMessagesFromResource("GeneralException")} : { ex.Message}";
            }

            if (responseObject == null)
                responseObject = BuildResponseObject(false, returnMessage);

            return responseObject;
        }

        [HttpPost]
        [Route(nameof(LinenCondemnationTxn_FetchVerifiedBy))]
        public HttpResponseMessage LinenCondemnationTxn_FetchVerifiedBy(LinenConemnationModel SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(FollowupCarFetch), Level.Info.ToString());
                var ErrorMessage = string.Empty;
                var result = _FetchBAL.LinenCondemnationTxn_FetchVerifiedBy(SearchObject);
                if (result == null)
                {
                    responseObject = BuildResponseObject(HttpStatusCode.NotFound);
                }
                else
                {
                    var serialisedData = JsonConvert.SerializeObject(result);
                    responseObject = BuildResponseObject(HttpStatusCode.OK, serialisedData);
                }

                Log4NetLogger.LogExit(_FileName, nameof(FollowupCarFetch), Level.Info.ToString());
            }
            catch (Exception ex)
            {
                returnMessage = $"{ resxFileHelper.GetErrorMessagesFromResource("GeneralException")} : { ex.Message}";
            }

            if (responseObject == null)
                responseObject = BuildResponseObject(false, returnMessage);

            return responseObject;
        }

        [HttpPost]
        [Route(nameof(LinenCondemnationTxn_FetchInspectedBy))]
        public HttpResponseMessage LinenCondemnationTxn_FetchInspectedBy(LinenConemnationModel SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(FollowupCarFetch), Level.Info.ToString());
                var ErrorMessage = string.Empty;
                var result = _FetchBAL.LinenCondemnationTxn_FetchInspectedBy(SearchObject);
                if (result == null)
                {
                    responseObject = BuildResponseObject(HttpStatusCode.NotFound);
                }
                else
                {
                    var serialisedData = JsonConvert.SerializeObject(result);
                    responseObject = BuildResponseObject(HttpStatusCode.OK, serialisedData);
                }

                Log4NetLogger.LogExit(_FileName, nameof(FollowupCarFetch), Level.Info.ToString());
            }
            catch (Exception ex)
            {
                returnMessage = $"{ resxFileHelper.GetErrorMessagesFromResource("GeneralException")} : { ex.Message}";
            }

            if (responseObject == null)
                responseObject = BuildResponseObject(false, returnMessage);

            return responseObject;
        }

        [HttpPost]
        [Route(nameof(LinenCondemnationTxnDet_FetchLinenCode))]
        public HttpResponseMessage LinenCondemnationTxnDet_FetchLinenCode(LinenConemnationModel SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(FollowupCarFetch), Level.Info.ToString());
                var ErrorMessage = string.Empty;
                var result = _FetchBAL.LinenCondemnationTxnDet_FetchLinenCode(SearchObject);
                if (result == null)
                {
                    responseObject = BuildResponseObject(HttpStatusCode.NotFound);
                }
                else
                {
                    var serialisedData = JsonConvert.SerializeObject(result);
                    responseObject = BuildResponseObject(HttpStatusCode.OK, serialisedData);
                }

                Log4NetLogger.LogExit(_FileName, nameof(FollowupCarFetch), Level.Info.ToString());
            }
            catch (Exception ex)
            {
                returnMessage = $"{ resxFileHelper.GetErrorMessagesFromResource("GeneralException")} : { ex.Message}";
            }

            if (responseObject == null)
                responseObject = BuildResponseObject(false, returnMessage);

            return responseObject;
        }

        [HttpPost]
        [Route(nameof(LinenRejectReplacementTxnDet_FetchLinenCode))]
        public HttpResponseMessage LinenRejectReplacementTxnDet_FetchLinenCode(LinenRejectReplacementModel SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(FollowupCarFetch), Level.Info.ToString());
                var ErrorMessage = string.Empty;
                var result = _FetchBAL.LinenRejectReplacementTxnDet_FetchLinenCode(SearchObject);
                if (result == null)
                {
                    responseObject = BuildResponseObject(HttpStatusCode.NotFound);
                }
                else
                {
                    var serialisedData = JsonConvert.SerializeObject(result);
                    responseObject = BuildResponseObject(HttpStatusCode.OK, serialisedData);
                }

                Log4NetLogger.LogExit(_FileName, nameof(FollowupCarFetch), Level.Info.ToString());
            }
            catch (Exception ex)
            {
                returnMessage = $"{ resxFileHelper.GetErrorMessagesFromResource("GeneralException")} : { ex.Message}";
            }

            if (responseObject == null)
                responseObject = BuildResponseObject(false, returnMessage);

            return responseObject;
        }

        [HttpPost]
        [Route(nameof(LinenRejectReplacementTxn_FetchLocCode))]
        public HttpResponseMessage LinenRejectReplacementTxn_FetchLocCode(LinenRejectReplacementModel SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(FollowupCarFetch), Level.Info.ToString());
                var ErrorMessage = string.Empty;
                var result = _FetchBAL.LinenRejectReplacementTxn_FetchLocCode(SearchObject);
                if (result == null)
                {
                    responseObject = BuildResponseObject(HttpStatusCode.NotFound);
                }
                else
                {
                    var serialisedData = JsonConvert.SerializeObject(result);
                    responseObject = BuildResponseObject(HttpStatusCode.OK, serialisedData);
                }

                Log4NetLogger.LogExit(_FileName, nameof(FollowupCarFetch), Level.Info.ToString());
            }
            catch (Exception ex)
            {
                returnMessage = $"{ resxFileHelper.GetErrorMessagesFromResource("GeneralException")} : { ex.Message}";
            }

            if (responseObject == null)
                responseObject = BuildResponseObject(false, returnMessage);

            return responseObject;
        }

        [HttpPost]
        [Route(nameof(LinenRejectReplacementTxn_FetchUserAreaCode))]
        public HttpResponseMessage LinenRejectReplacementTxn_FetchUserAreaCode(LinenRejectReplacementModel SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(FollowupCarFetch), Level.Info.ToString());
                var ErrorMessage = string.Empty;
                var result = _FetchBAL.LinenRejectReplacementTxn_FetchUserAreaCode(SearchObject);
                if (result == null)
                {
                    responseObject = BuildResponseObject(HttpStatusCode.NotFound);
                }
                else
                {
                    var serialisedData = JsonConvert.SerializeObject(result);
                    responseObject = BuildResponseObject(HttpStatusCode.OK, serialisedData);
                }

                Log4NetLogger.LogExit(_FileName, nameof(FollowupCarFetch), Level.Info.ToString());
            }
            catch (Exception ex)
            {
                returnMessage = $"{ resxFileHelper.GetErrorMessagesFromResource("GeneralException")} : { ex.Message}";
            }

            if (responseObject == null)
                responseObject = BuildResponseObject(false, returnMessage);

            return responseObject;
        }

        [HttpPost]
        [Route(nameof(LinenRejectReplacementTxn_FetchCLINo))]
        public HttpResponseMessage LinenRejectReplacementTxn_FetchCLINo(LinenRejectReplacementModel SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(FollowupCarFetch), Level.Info.ToString());
                var ErrorMessage = string.Empty;
                var result = _FetchBAL.LinenRejectReplacementTxn_FetchCLINo(SearchObject);
                if (result == null)
                {
                    responseObject = BuildResponseObject(HttpStatusCode.NotFound);
                }
                else
                {
                    var serialisedData = JsonConvert.SerializeObject(result);
                    responseObject = BuildResponseObject(HttpStatusCode.OK, serialisedData);
                }

                Log4NetLogger.LogExit(_FileName, nameof(FollowupCarFetch), Level.Info.ToString());
            }
            catch (Exception ex)
            {
                returnMessage = $"{ resxFileHelper.GetErrorMessagesFromResource("GeneralException")} : { ex.Message}";
            }

            if (responseObject == null)
                responseObject = BuildResponseObject(false, returnMessage);

            return responseObject;
        }

        [HttpPost]
        [Route(nameof(LinenRejectReplacementTxn_FetchRejectedBy))]
        public HttpResponseMessage LinenRejectReplacementTxn_FetchRejectedBy(LinenRejectReplacementModel SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(FollowupCarFetch), Level.Info.ToString());
                var ErrorMessage = string.Empty;
                var result = _FetchBAL.LinenRejectReplacementTxn_FetchRejectedBy(SearchObject);
                if (result == null)
                {
                    responseObject = BuildResponseObject(HttpStatusCode.NotFound);
                }
                else
                {
                    var serialisedData = JsonConvert.SerializeObject(result);
                    responseObject = BuildResponseObject(HttpStatusCode.OK, serialisedData);
                }

                Log4NetLogger.LogExit(_FileName, nameof(FollowupCarFetch), Level.Info.ToString());
            }
            catch (Exception ex)
            {
                returnMessage = $"{ resxFileHelper.GetErrorMessagesFromResource("GeneralException")} : { ex.Message}";
            }

            if (responseObject == null)
                responseObject = BuildResponseObject(false, returnMessage);

            return responseObject;
        }

        [HttpPost]
        [Route(nameof(LinenRejectReplacementTxn_FetchReceivedBy))]
        public HttpResponseMessage LinenRejectReplacementTxn_FetchReceivedBy(LinenRejectReplacementModel SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(FollowupCarFetch), Level.Info.ToString());
                var ErrorMessage = string.Empty;
                var result = _FetchBAL.LinenRejectReplacementTxn_FetchReceivedBy(SearchObject);
                if (result == null)
                {
                    responseObject = BuildResponseObject(HttpStatusCode.NotFound);
                }
                else
                {
                    var serialisedData = JsonConvert.SerializeObject(result);
                    responseObject = BuildResponseObject(HttpStatusCode.OK, serialisedData);
                }

                Log4NetLogger.LogExit(_FileName, nameof(FollowupCarFetch), Level.Info.ToString());
            }
            catch (Exception ex)
            {
                returnMessage = $"{ resxFileHelper.GetErrorMessagesFromResource("GeneralException")} : { ex.Message}";
            }

            if (responseObject == null)
                responseObject = BuildResponseObject(false, returnMessage);

            return responseObject;
        }

        [HttpPost]
        [Route(nameof(LLSLinenInjectionTxn_FetchDONo))]
        public HttpResponseMessage LLSLinenInjectionTxn_FetchDONo(LinenConemnationModel SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(FollowupCarFetch), Level.Info.ToString());
                var ErrorMessage = string.Empty;
                var result = _FetchBAL.LLSLinenInjectionTxn_FetchDONo(SearchObject);
                if (result == null)
                {
                    responseObject = BuildResponseObject(HttpStatusCode.NotFound);
                }
                else
                {
                    var serialisedData = JsonConvert.SerializeObject(result);
                    responseObject = BuildResponseObject(HttpStatusCode.OK, serialisedData);
                }

                Log4NetLogger.LogExit(_FileName, nameof(FollowupCarFetch), Level.Info.ToString());
            }
            catch (Exception ex)
            {
                returnMessage = $"{ resxFileHelper.GetErrorMessagesFromResource("GeneralException")} : { ex.Message}";
            }

            if (responseObject == null)
                responseObject = BuildResponseObject(false, returnMessage);

            return responseObject;
        }


        [HttpPost]
        [Route(nameof(LLSLinenInventoryTxn_FetchUserAreaCode))]
        public HttpResponseMessage LLSLinenInventoryTxn_FetchUserAreaCode(UserAreaFetch SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(FollowupCarFetch), Level.Info.ToString());
                var ErrorMessage = string.Empty;
                var result = _FetchBAL.LLSLinenInventoryTxn_FetchUserAreaCode(SearchObject);
                if (result == null)
                {
                    responseObject = BuildResponseObject(HttpStatusCode.NotFound);
                }
                else
                {
                    var serialisedData = JsonConvert.SerializeObject(result);
                    responseObject = BuildResponseObject(HttpStatusCode.OK, serialisedData);
                }

                Log4NetLogger.LogExit(_FileName, nameof(FollowupCarFetch), Level.Info.ToString());
            }
            catch (Exception ex)
            {
                returnMessage = $"{ resxFileHelper.GetErrorMessagesFromResource("GeneralException")} : { ex.Message}";
            }

            if (responseObject == null)
                responseObject = BuildResponseObject(false, returnMessage);

            return responseObject;
        }

        [HttpPost]
        [Route(nameof(LLSLinenInventoryTxn_FetchVerifiedBy))]
        public HttpResponseMessage LLSLinenInventoryTxn_FetchVerifiedBy(UserAreaFetch SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(FollowupCarFetch), Level.Info.ToString());
                var ErrorMessage = string.Empty;
                var result = _FetchBAL.LLSLinenInventoryTxn_FetchVerifiedBy(SearchObject);
                if (result == null)
                {
                    responseObject = BuildResponseObject(HttpStatusCode.NotFound);
                }
                else
                {
                    var serialisedData = JsonConvert.SerializeObject(result);
                    responseObject = BuildResponseObject(HttpStatusCode.OK, serialisedData);
                }

                Log4NetLogger.LogExit(_FileName, nameof(FollowupCarFetch), Level.Info.ToString());
            }
            catch (Exception ex)
            {
                returnMessage = $"{ resxFileHelper.GetErrorMessagesFromResource("GeneralException")} : { ex.Message}";
            }

            if (responseObject == null)
                responseObject = BuildResponseObject(false, returnMessage);

            return responseObject;
        }

        [HttpPost]
        [Route(nameof(LLSLinenInventoryTxnDet_FetchLinenCode))]
        public HttpResponseMessage LLSLinenInventoryTxnDet_FetchLinenCode(UserAreaFetch SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(FollowupCarFetch), Level.Info.ToString());
                var ErrorMessage = string.Empty;
                var result = _FetchBAL.LLSLinenInventoryTxnDet_FetchLinenCode(SearchObject);
                if (result == null)
                {
                    responseObject = BuildResponseObject(HttpStatusCode.NotFound);
                }
                else
                {
                    var serialisedData = JsonConvert.SerializeObject(result);
                    responseObject = BuildResponseObject(HttpStatusCode.OK, serialisedData);
                }

                Log4NetLogger.LogExit(_FileName, nameof(FollowupCarFetch), Level.Info.ToString());
            }
            catch (Exception ex)
            {
                returnMessage = $"{ resxFileHelper.GetErrorMessagesFromResource("GeneralException")} : { ex.Message}";
            }

            if (responseObject == null)
                responseObject = BuildResponseObject(false, returnMessage);

            return responseObject;
        }

        [HttpPost]
        [Route(nameof(LLSLinenInventoryTxnDet_FetchLinenCodeUserArea))]
        public HttpResponseMessage LLSLinenInventoryTxnDet_FetchLinenCodeUserArea(UserAreaFetch SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(FollowupCarFetch), Level.Info.ToString());
                var ErrorMessage = string.Empty;
                var result = _FetchBAL.LLSLinenInventoryTxnDet_FetchLinenCodeUserArea(SearchObject);
                if (result == null)
                {
                    responseObject = BuildResponseObject(HttpStatusCode.NotFound);
                }
                else
                {
                    var serialisedData = JsonConvert.SerializeObject(result);
                    responseObject = BuildResponseObject(HttpStatusCode.OK, serialisedData);
                }

                Log4NetLogger.LogExit(_FileName, nameof(FollowupCarFetch), Level.Info.ToString());
            }
            catch (Exception ex)
            {
                returnMessage = $"{ resxFileHelper.GetErrorMessagesFromResource("GeneralException")} : { ex.Message}";
            }

            if (responseObject == null)
                responseObject = BuildResponseObject(false, returnMessage);

            return responseObject;
        }

        #endregion


        #region CRMRequest Asset

        [Route(nameof(CrmAssetNoFetch))]
        public HttpResponseMessage CrmAssetNoFetch(CRMWorkorderStaffFetch SearchObject)
        {

            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(CrmAssetNoFetch), Level.Info.ToString());
                var ErrorMessage = string.Empty;
                var result = _FetchBAL.CrmAssetNoFetch(SearchObject);
                if (result == null)
                {
                    responseObject = BuildResponseObject(HttpStatusCode.NotFound);
                }
                else
                {
                    var serialisedData = JsonConvert.SerializeObject(result);
                    responseObject = BuildResponseObject(HttpStatusCode.OK, serialisedData);
                }

                Log4NetLogger.LogExit(_FileName, nameof(CrmAssetNoFetch), Level.Info.ToString());
            }
            catch (Exception ex)
            {
                returnMessage = $"{ resxFileHelper.GetErrorMessagesFromResource("GeneralException")} : { ex.Message}";
            }

            if (responseObject == null)
                responseObject = BuildResponseObject(false, returnMessage);

            return responseObject;
        }
        #endregion

        [HttpPost]
        [Route(nameof(ArpBerNo))]
        public HttpResponseMessage ArpBerNo(Arp SearchObject)
        {

            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(ArpBerNo), Level.Info.ToString());
                var ErrorMessage = string.Empty;
                var result = _FetchBAL.ArpBerNo(SearchObject);
                if (result == null)
                {
                    responseObject = BuildResponseObject(HttpStatusCode.NotFound);
                }
                else
                {
                    var serialisedData = JsonConvert.SerializeObject(result);
                    responseObject = BuildResponseObject(HttpStatusCode.OK, serialisedData);
                }

                Log4NetLogger.LogExit(_FileName, nameof(ArpBerNo), Level.Info.ToString());
            }
            catch (Exception ex)
            {
                returnMessage = $"{resxFileHelper.GetErrorMessagesFromResource("GeneralException")} : {ex.Message}";
            }

            if (responseObject == null)
                responseObject = BuildResponseObject(false, returnMessage);

            return responseObject;
        }

        [HttpPost]
        [Route(nameof(ArpAssetNo))]
        public HttpResponseMessage ArpAssetNo(Arp SearchObject)
        {

            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(ArpAssetNo), Level.Info.ToString());
                var ErrorMessage = string.Empty;
                var result = _FetchBAL.ArpAssetNo(SearchObject);
                if (result == null)
                {
                    responseObject = BuildResponseObject(HttpStatusCode.NotFound);
                }
                else
                {
                    var serialisedData = JsonConvert.SerializeObject(result);
                    responseObject = BuildResponseObject(HttpStatusCode.OK, serialisedData);
                }

                Log4NetLogger.LogExit(_FileName, nameof(ArpAssetNo), Level.Info.ToString());
            }
            catch (Exception ex)
            {
                returnMessage = $"{resxFileHelper.GetErrorMessagesFromResource("GeneralException")} : {ex.Message}";
            }

            if (responseObject == null)
                responseObject = BuildResponseObject(false, returnMessage);

            return responseObject;
        }

    }
}