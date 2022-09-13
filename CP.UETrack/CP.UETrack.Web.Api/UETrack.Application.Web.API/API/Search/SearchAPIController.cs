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

namespace UETrack.Application.Web.Controllers
{

    [RoutePrefix("api/Search")]
    [WebApiAudit]
    public class SearchAPIController : BaseApiController
    {
        ISearchBAL _SearchBAL;
        private readonly string _FileName = nameof(SearchAPIController);
        public SearchAPIController(ISearchBAL searchBAL)
        {
            _SearchBAL = searchBAL;
        }

        [HttpPost]
        [Route(nameof(PopupSearch))]
        public HttpResponseMessage PopupSearch(UMStaffSearch SearchObject)
        {

            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(PopupSearch), Level.Info.ToString());
                var ErrorMessage = string.Empty;
                var result = _SearchBAL.PopupSearch(SearchObject);
                if (result == null)
                {
                    responseObject = BuildResponseObject(HttpStatusCode.NotFound);
                }
                else
                {
                    var serialisedData = JsonConvert.SerializeObject(result);
                    responseObject = BuildResponseObject(HttpStatusCode.OK, serialisedData);
                }

                Log4NetLogger.LogExit(_FileName, nameof(PopupSearch), Level.Info.ToString());
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
        [Route(nameof(TypeCodeSearch))]
        public HttpResponseMessage TypeCodeSearch(TypeCodeSearch SearchObject)
        {

            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(TypeCodeSearch), Level.Info.ToString());
                var ErrorMessage = string.Empty;
                var result = _SearchBAL.TypeCodeSearch(SearchObject);
                if (result == null)
                {
                    responseObject = BuildResponseObject(HttpStatusCode.NotFound);
                }
                else
                {
                    var serialisedData = JsonConvert.SerializeObject(result);
                    responseObject = BuildResponseObject(HttpStatusCode.OK, serialisedData);
                }

                Log4NetLogger.LogExit(_FileName, nameof(TypeCodeSearch), Level.Info.ToString());
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
        [Route(nameof(LocationCodeSearch))]
        public HttpResponseMessage LocationCodeSearch(UserLocationCodeSearch SearchObject)
        {

            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(LocationCodeSearch), Level.Info.ToString());
                var ErrorMessage = string.Empty;
                var result = _SearchBAL.LocationCodeSearch(SearchObject);
                if (result == null)
                {
                    responseObject = BuildResponseObject(HttpStatusCode.NotFound);
                }
                else
                {
                    var serialisedData = JsonConvert.SerializeObject(result);
                    responseObject = BuildResponseObject(HttpStatusCode.OK, serialisedData);
                }

                Log4NetLogger.LogExit(_FileName, nameof(LocationCodeSearch), Level.Info.ToString());
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
        [Route(nameof(ManufacturerSearch))]
        public HttpResponseMessage ManufacturerSearch(ManufacturerSearch SearchObject)
        {

            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(ManufacturerSearch), Level.Info.ToString());
                var ErrorMessage = string.Empty;
                var result = _SearchBAL.ManufacturerSearch(SearchObject);
                if (result == null)
                {
                    responseObject = BuildResponseObject(HttpStatusCode.NotFound);
                }
                else
                {
                    var serialisedData = JsonConvert.SerializeObject(result);
                    responseObject = BuildResponseObject(HttpStatusCode.OK, serialisedData);
                }

                Log4NetLogger.LogExit(_FileName, nameof(ManufacturerSearch), Level.Info.ToString());
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
        [Route(nameof(ModelSearch))]
        public HttpResponseMessage ModelSearch(ModelSearch SearchObject)
        {

            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(ModelSearch), Level.Info.ToString());
                var ErrorMessage = string.Empty;
                var result = _SearchBAL.ModelSearch(SearchObject);
                if (result == null)
                {
                    responseObject = BuildResponseObject(HttpStatusCode.NotFound);
                }
                else
                {
                    var serialisedData = JsonConvert.SerializeObject(result);
                    responseObject = BuildResponseObject(HttpStatusCode.OK, serialisedData);
                }

                Log4NetLogger.LogExit(_FileName, nameof(ModelSearch), Level.Info.ToString());
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
        [Route(nameof(TaskCodeSearch))]
        public HttpResponseMessage TaskCodeSearch(EngAssetTypeCodeStandardTasksFetch SearchObject)
        {

            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(ModelSearch), Level.Info.ToString());
                var ErrorMessage = string.Empty;
                var result = _SearchBAL.TaskCodeSearch(SearchObject);
                if (result == null)
                {
                    responseObject = BuildResponseObject(HttpStatusCode.NotFound);
                }
                else
                {
                    var serialisedData = JsonConvert.SerializeObject(result);
                    responseObject = BuildResponseObject(HttpStatusCode.OK, serialisedData);
                }

                Log4NetLogger.LogExit(_FileName, nameof(ModelSearch), Level.Info.ToString());
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
        [Route(nameof(AssetPreRegistrationNoSearch))]
        public HttpResponseMessage AssetPreRegistrationNoSearch(AssetPreRegistrationNoSearch SearchObject)
        {

            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(AssetPreRegistrationNoSearch), Level.Info.ToString());
                var ErrorMessage = string.Empty;
                var result = _SearchBAL.AssetPreRegistrationNoSearch(SearchObject);
                if (result == null)
                {
                    responseObject = BuildResponseObject(HttpStatusCode.NotFound);
                }
                else
                {
                    var serialisedData = JsonConvert.SerializeObject(result);
                    responseObject = BuildResponseObject(HttpStatusCode.OK, serialisedData);
                }

                Log4NetLogger.LogExit(_FileName, nameof(AssetPreRegistrationNoSearch), Level.Info.ToString());
            }
            catch (Exception ex)
            {
                returnMessage = $"{resxFileHelper.GetErrorMessagesFromResource("GeneralException")} : {ex.Message}";
            }

            if (responseObject == null)
                responseObject = BuildResponseObject(false, returnMessage);

            return responseObject;
        }
        [Route(nameof(WarrantyManagementSearch))]
        public HttpResponseMessage WarrantyManagementSearch(WarrantyManagementSearch SearchObject)
        {

            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(WarrantyManagementSearch), Level.Info.ToString());
                var ErrorMessage = string.Empty;
                var result = _SearchBAL.WarrantyManagementSearch(SearchObject);
                if (result == null)
                {
                    responseObject = BuildResponseObject(HttpStatusCode.NotFound);
                }
                else
                {
                    var serialisedData = JsonConvert.SerializeObject(result);
                    responseObject = BuildResponseObject(HttpStatusCode.OK, serialisedData);
                }

                Log4NetLogger.LogExit(_FileName, nameof(WarrantyManagementSearch), Level.Info.ToString());
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
        [Route(nameof(UserAreaSearch))]
        public HttpResponseMessage UserAreaSearch(UserAreaFetch SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(UserAreaSearch), Level.Info.ToString());
                var ErrorMessage = string.Empty;
                var result = _SearchBAL.UserAreaSearch(SearchObject);
                if (result == null)
                    responseObject = BuildResponseObject(HttpStatusCode.NotFound);
                else
                {
                    var serialisedData = JsonConvert.SerializeObject(result);
                    responseObject = BuildResponseObject(HttpStatusCode.OK, serialisedData);
                }
                Log4NetLogger.LogExit(_FileName, nameof(UserAreaSearch), Level.Info.ToString());
            }
            catch (Exception ex)
            {
                returnMessage = $"{resxFileHelper.GetErrorMessagesFromResource("GeneralException")} : {ex.Message}";
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
                var result = _SearchBAL.StockAdjustmentFetchModel(SearchObject);
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
        [Route(nameof(ParentAssetNoSearch))]
        public HttpResponseMessage ParentAssetNoSearch(ParentAssetNoSearch SearchObject)
        {

            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(ParentAssetNoSearch), Level.Info.ToString());
                var ErrorMessage = string.Empty;
                var result = _SearchBAL.ParentAssetNoSearch(SearchObject);
                if (result == null)
                {
                    responseObject = BuildResponseObject(HttpStatusCode.NotFound);
                }
                else
                {
                    var serialisedData = JsonConvert.SerializeObject(result);
                    responseObject = BuildResponseObject(HttpStatusCode.OK, serialisedData);
                }

                Log4NetLogger.LogExit(_FileName, nameof(ParentAssetNoSearch), Level.Info.ToString());
            }
            catch (Exception ex)
            {
                returnMessage = $"{ resxFileHelper.GetErrorMessagesFromResource("GeneralException")} : { ex.Message}";
            }

            if (responseObject == null)
                responseObject = BuildResponseObject(false, returnMessage);

            return responseObject;
        }


        [Route(nameof(SearchforContractorcode))]
        public HttpResponseMessage SearchforContractorcode(AssetRegisterWarrantyProviderGrid SearchObject)
        {

            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(ParentAssetNoSearch), Level.Info.ToString());
                var ErrorMessage = string.Empty;
                var result = _SearchBAL.SearchforContractorcode(SearchObject);
                if (result == null)
                {
                    responseObject = BuildResponseObject(HttpStatusCode.NotFound);
                }
                else
                {
                    var serialisedData = JsonConvert.SerializeObject(result);
                    responseObject = BuildResponseObject(HttpStatusCode.OK, serialisedData);
                }

                Log4NetLogger.LogExit(_FileName, nameof(ParentAssetNoSearch), Level.Info.ToString());
            }
            catch (Exception ex)
            {
                returnMessage = $"{ resxFileHelper.GetErrorMessagesFromResource("GeneralException")} : { ex.Message}";
            }

            if (responseObject == null)
                responseObject = BuildResponseObject(false, returnMessage);

            return responseObject;
        }
        [Route(nameof(AssetClassificationCodeSearch))]
        public HttpResponseMessage AssetClassificationCodeSearch(AssetClassificationFetch SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(AssetClassificationCodeSearch), Level.Info.ToString());
                var ErrorMessage = string.Empty;
                var result = _SearchBAL.AssetClassificationCodeSearch(SearchObject);
                if (result == null)
                {
                    responseObject = BuildResponseObject(HttpStatusCode.NotFound);
                }
                else
                {
                    var serialisedData = JsonConvert.SerializeObject(result);
                    responseObject = BuildResponseObject(HttpStatusCode.OK, serialisedData);
                }
                Log4NetLogger.LogExit(_FileName, nameof(AssetClassificationCodeSearch), Level.Info.ToString());
            }
            catch (Exception ex)
            {
                returnMessage = $"{ resxFileHelper.GetErrorMessagesFromResource("GeneralException")} : { ex.Message}";
            }
            if (responseObject == null)
                responseObject = BuildResponseObject(false, returnMessage);

            return responseObject;
        }

        [Route(nameof(CompanyStaffSearch))]
        public HttpResponseMessage CompanyStaffSearch(CompanyStaffFetchModel SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(CompanyStaffSearch), Level.Info.ToString());
                var ErrorMessage = string.Empty;
                var result = _SearchBAL.CompanyStaffSearch(SearchObject);
                if (result == null)
                {
                    responseObject = BuildResponseObject(HttpStatusCode.NotFound);
                }
                else
                {
                    var serialisedData = JsonConvert.SerializeObject(result);
                    responseObject = BuildResponseObject(HttpStatusCode.OK, serialisedData);
                }
                Log4NetLogger.LogExit(_FileName, nameof(CompanyStaffSearch), Level.Info.ToString());
            }
            catch (Exception ex)
            {
                returnMessage = $"{ resxFileHelper.GetErrorMessagesFromResource("GeneralException")} : { ex.Message}";
            }
            if (responseObject == null)
                responseObject = BuildResponseObject(false, returnMessage);

            return responseObject;
        }
        [Route(nameof(FacilityStaffSearch))]
        public HttpResponseMessage FacilityStaffSearch(FacilityStaffFetchModel SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(FacilityStaffSearch), Level.Info.ToString());
                var ErrorMessage = string.Empty;
                var result = _SearchBAL.FacilityStaffSearch(SearchObject);
                if (result == null)
                {
                    responseObject = BuildResponseObject(HttpStatusCode.NotFound);
                }
                else
                {
                    var serialisedData = JsonConvert.SerializeObject(result);
                    responseObject = BuildResponseObject(HttpStatusCode.OK, serialisedData);
                }
                Log4NetLogger.LogExit(_FileName, nameof(FacilityStaffSearch), Level.Info.ToString());
            }
            catch (Exception ex)
            {
                returnMessage = $"{ resxFileHelper.GetErrorMessagesFromResource("GeneralException")} : { ex.Message}";
            }
            if (responseObject == null)
                responseObject = BuildResponseObject(false, returnMessage);

            return responseObject;
        }
        [Route(nameof(ItemCodeSearch))]
        public HttpResponseMessage ItemCodeSearch(ItemCodeFetch SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(FacilityStaffSearch), Level.Info.ToString());
                var ErrorMessage = string.Empty;
                var result = _SearchBAL.ItemCodeSearch(SearchObject);
                if (result == null)
                {
                    responseObject = BuildResponseObject(HttpStatusCode.NotFound);
                }
                else
                {
                    var serialisedData = JsonConvert.SerializeObject(result);
                    responseObject = BuildResponseObject(HttpStatusCode.OK, serialisedData);
                }
                Log4NetLogger.LogExit(_FileName, nameof(FacilityStaffSearch), Level.Info.ToString());
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
        [Route(nameof(LevelCodeSearch))]
        public HttpResponseMessage LevelCodeSearch(LevelFetchModel SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(LevelCodeSearch), Level.Info.ToString());
                var ErrorMessage = string.Empty;
                var result = _SearchBAL.LevelCodeSearch(SearchObject);
                if (result == null)
                {
                    responseObject = BuildResponseObject(HttpStatusCode.NotFound);
                }
                else
                {
                    var serialisedData = JsonConvert.SerializeObject(result);
                    responseObject = BuildResponseObject(HttpStatusCode.OK, serialisedData);
                }
                Log4NetLogger.LogExit(_FileName, nameof(FacilityStaffSearch), Level.Info.ToString());
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
        [Route(nameof(BERAssetSearch))]
        public HttpResponseMessage BERAssetSearch(BERAssetNoFetch SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(BERAssetSearch), Level.Info.ToString());
                var ErrorMessage = string.Empty;
                var result = _SearchBAL.BERAssetSearch(SearchObject);
                if (result == null)
                {
                    responseObject = BuildResponseObject(HttpStatusCode.NotFound);
                }
                else
                {
                    var serialisedData = JsonConvert.SerializeObject(result);
                    responseObject = BuildResponseObject(HttpStatusCode.OK, serialisedData);
                }
                Log4NetLogger.LogExit(_FileName, nameof(BERAssetSearch), Level.Info.ToString());
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
        [Route(nameof(BERRejectedNoSearch))]
        public HttpResponseMessage BERRejectedNoSearch(BERRejectedNoFetch SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(BERRejectedNoSearch), Level.Info.ToString());
                var ErrorMessage = string.Empty;
                var result = _SearchBAL.BERRejectedNoSearch(SearchObject);
                if (result == null)
                {
                    responseObject = BuildResponseObject(HttpStatusCode.NotFound);
                }
                else
                {
                    var serialisedData = JsonConvert.SerializeObject(result);
                    responseObject = BuildResponseObject(HttpStatusCode.OK, serialisedData);
                }
                Log4NetLogger.LogExit(_FileName, nameof(BERRejectedNoSearch), Level.Info.ToString());
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
        [Route(nameof(PorteringAssetNoSearch))]
        public HttpResponseMessage PorteringAssetNoSearch(PortAssetFetchModel SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(PorteringAssetNoSearch), Level.Info.ToString());
                var ErrorMessage = string.Empty;
                var result = _SearchBAL.PorteringAssetNoSearch(SearchObject);
                if (result == null)
                {
                    responseObject = BuildResponseObject(HttpStatusCode.NotFound);
                }
                else
                {
                    var serialisedData = JsonConvert.SerializeObject(result);
                    responseObject = BuildResponseObject(HttpStatusCode.OK, serialisedData);
                }
                Log4NetLogger.LogExit(_FileName, nameof(PorteringAssetNoSearch), Level.Info.ToString());
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
        [Route(nameof(PorteringWorkOrderNoSearch))]
        public HttpResponseMessage PorteringWorkOrderNoSearch(PortAssetFetchModel SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(PorteringWorkOrderNoSearch), Level.Info.ToString());
                var ErrorMessage = string.Empty;
                var result = _SearchBAL.PorteringWorkOrderNoSearch(SearchObject);
                if (result == null)
                {
                    responseObject = BuildResponseObject(HttpStatusCode.NotFound);
                }
                else
                {
                    var serialisedData = JsonConvert.SerializeObject(result);
                    responseObject = BuildResponseObject(HttpStatusCode.OK, serialisedData);
                }
                Log4NetLogger.LogExit(_FileName, nameof(PorteringWorkOrderNoSearch), Level.Info.ToString());
            }
            catch (Exception ex)
            {
                returnMessage = $"{ resxFileHelper.GetErrorMessagesFromResource("GeneralException")} : { ex.Message}";
            }
            if (responseObject == null)
                responseObject = BuildResponseObject(false, returnMessage);

            return responseObject;
        }

        [Route(nameof(EODCaptureAssetFetch))]
        public HttpResponseMessage EODCaptureAssetFetch(EODCaptureAssetFetch SearchObject)
        {

            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(EODCaptureAssetFetch), Level.Info.ToString());
                var ErrorMessage = string.Empty;
                var result = _SearchBAL.EODCaptureAssetFetch(SearchObject);
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
                returnMessage = $"{ resxFileHelper.GetErrorMessagesFromResource("GeneralException")} : { ex.Message}";
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
                var result = _SearchBAL.EODCaptureManufacturer(SearchObject);
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
                var result = _SearchBAL.EODCaptureModel(SearchObject);
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

        [Route(nameof(CustomerCodeSearch))]
        public HttpResponseMessage CustomerCodeSearch(CustomerFetch SearchObject)
        {

            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(CustomerCodeSearch), Level.Info.ToString());
                var ErrorMessage = string.Empty;
                var result = _SearchBAL.CustomerCodeSearch(SearchObject);
                if (result == null)
                {
                    responseObject = BuildResponseObject(HttpStatusCode.NotFound);
                }
                else
                {
                    var serialisedData = JsonConvert.SerializeObject(result);
                    responseObject = BuildResponseObject(HttpStatusCode.OK, serialisedData);
                }

                Log4NetLogger.LogExit(_FileName, nameof(CustomerCodeSearch), Level.Info.ToString());
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
                var result = _SearchBAL.CRMRequestAssetFetch(SearchObject);
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
                var result = _SearchBAL.CRMWorkorderStaffFetch(SearchObject);
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

        [Route(nameof(TAndCCRMRequestNoSearch))]
        public HttpResponseMessage TAndCCRMRequestNoSearch(TAndCCRMRequestNoFetchSearch SearchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(TAndCCRMRequestNoSearch), Level.Info.ToString());
                var ErrorMessage = string.Empty;
                var result = _SearchBAL.TAndCCRMRequestNoSearch(SearchObject);
                if (result == null)
                {
                    responseObject = BuildResponseObject(HttpStatusCode.NotFound);
                }
                else
                {
                    var serialisedData = JsonConvert.SerializeObject(result);
                    responseObject = BuildResponseObject(HttpStatusCode.OK, serialisedData);
                }

                Log4NetLogger.LogExit(_FileName, nameof(TAndCCRMRequestNoSearch), Level.Info.ToString());
            }
            catch (Exception ex)
            {
                returnMessage = $"{ resxFileHelper.GetErrorMessagesFromResource("GeneralException")} : { ex.Message}";
            }

            if (responseObject == null)
                responseObject = BuildResponseObject(false, returnMessage);

            return responseObject;
        }

        [Route(nameof(ContractorNameSearch))]
        public HttpResponseMessage ContractorNameSearch(ContractorNameSearch SearchObject)
        {

            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(ContractorNameSearch), Level.Info.ToString());
                var ErrorMessage = string.Empty;
                var result = _SearchBAL.ContractorNameSearch(SearchObject);
                if (result == null)
                {
                    responseObject = BuildResponseObject(HttpStatusCode.NotFound);
                }
                else
                {
                    var serialisedData = JsonConvert.SerializeObject(result);
                    responseObject = BuildResponseObject(HttpStatusCode.OK, serialisedData);
                }

                Log4NetLogger.LogExit(_FileName, nameof(ContractorNameSearch), Level.Info.ToString());
            }
            catch (Exception ex)
            {
                returnMessage = $"{ resxFileHelper.GetErrorMessagesFromResource("GeneralException")} : { ex.Message}";
            }

            if (responseObject == null)
                responseObject = BuildResponseObject(false, returnMessage);

            return responseObject;
        }

        [Route(nameof(BookingAssetNoSearch))]
        public HttpResponseMessage BookingAssetNoSearch(BookingFetch SearchObject)
        {

            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(BookingAssetNoSearch), Level.Info.ToString());
                var ErrorMessage = string.Empty;
                var result = _SearchBAL.BookingAssetNoSearch(SearchObject);
                if (result == null)
                {
                    responseObject = BuildResponseObject(HttpStatusCode.NotFound);
                }
                else
                {
                    var serialisedData = JsonConvert.SerializeObject(result);
                    responseObject = BuildResponseObject(HttpStatusCode.OK, serialisedData);
                }

                Log4NetLogger.LogExit(_FileName, nameof(BookingAssetNoSearch), Level.Info.ToString());
            }
            catch (Exception ex)
            {
                returnMessage = $"{ resxFileHelper.GetErrorMessagesFromResource("GeneralException")} : { ex.Message}";
            }

            if (responseObject == null)
                responseObject = BuildResponseObject(false, returnMessage);

            return responseObject;
        }

        [Route(nameof(BookingWorkOrderNoSearch))]
        public HttpResponseMessage BookingWorkOrderNoSearch(BookingFetch SearchObject)
        {

            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(BookingWorkOrderNoSearch), Level.Info.ToString());
                var ErrorMessage = string.Empty;
                var result = _SearchBAL.BookingWorkOrderNoSearch(SearchObject);
                if (result == null)
                {
                    responseObject = BuildResponseObject(HttpStatusCode.NotFound);
                }
                else
                {
                    var serialisedData = JsonConvert.SerializeObject(result);
                    responseObject = BuildResponseObject(HttpStatusCode.OK, serialisedData);
                }

                Log4NetLogger.LogExit(_FileName, nameof(BookingWorkOrderNoSearch), Level.Info.ToString());
            }
            catch (Exception ex)
            {
                returnMessage = $"{ resxFileHelper.GetErrorMessagesFromResource("GeneralException")} : { ex.Message}";
            }

            if (responseObject == null)
                responseObject = BuildResponseObject(false, returnMessage);

            return responseObject;
        }

        [Route(nameof(UserShiftLeaveDetailsSearch))]
        public HttpResponseMessage UserShiftLeaveDetailsSearch(UserShiftLeaveDetailsFetch SearchObject)
        {

            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(UserShiftLeaveDetailsSearch), Level.Info.ToString());
                var ErrorMessage = string.Empty;
                var result = _SearchBAL.UserShiftLeaveDetailsSearch(SearchObject);
                if (result == null)
                {
                    responseObject = BuildResponseObject(HttpStatusCode.NotFound);
                }
                else
                {
                    var serialisedData = JsonConvert.SerializeObject(result);
                    responseObject = BuildResponseObject(HttpStatusCode.OK, serialisedData);
                }

                Log4NetLogger.LogExit(_FileName, nameof(UserShiftLeaveDetailsSearch), Level.Info.ToString());
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
                var result = _SearchBAL.UserTainingParticipantFetch(SearchObject);
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
                var result = _SearchBAL.FilureSymptomCodeFetch(SearchObject);
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
                var result = _SearchBAL.FollowupCarFetch(SearchObject);
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

        [Route("blockSearch")]
        public HttpResponseMessage BlockCascCodeSearch(AreaFetch SearchObject)
        {

            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(BlockCascCodeSearch), Level.Info.ToString());
                var ErrorMessage = string.Empty;
                var result = _SearchBAL.BlockCascCodeSearch(SearchObject);
                if (result == null)
                {
                    responseObject = BuildResponseObject(HttpStatusCode.NotFound);
                }
                else
                {
                    var serialisedData = JsonConvert.SerializeObject(result);
                    responseObject = BuildResponseObject(HttpStatusCode.OK, serialisedData);
                }

                Log4NetLogger.LogExit(_FileName, nameof(BlockCascCodeSearch), Level.Info.ToString());
            }
            catch (Exception ex)
            {
                returnMessage = $"{ resxFileHelper.GetErrorMessagesFromResource("GeneralException")} : { ex.Message}";
            }

            if (responseObject == null)
                responseObject = BuildResponseObject(false, returnMessage);

            return responseObject;
        }

        [Route("QCPPMSearch")]
        public HttpResponseMessage QCPPMCodeSearch(AreaFetch SearchObject)
        {

            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(QCPPMCodeSearch), Level.Info.ToString());
                var ErrorMessage = string.Empty;
                var result = _SearchBAL.QCPPMCodeSearch(SearchObject);
                if (result == null)
                {
                    responseObject = BuildResponseObject(HttpStatusCode.NotFound);
                }
                else
                {
                    var serialisedData = JsonConvert.SerializeObject(result);
                    responseObject = BuildResponseObject(HttpStatusCode.OK, serialisedData);
                }

                Log4NetLogger.LogExit(_FileName, nameof(BlockCascCodeSearch), Level.Info.ToString());
            }
            catch (Exception ex)
            {
                returnMessage = $"{ resxFileHelper.GetErrorMessagesFromResource("GeneralException")} : { ex.Message}";
            }

            if (responseObject == null)
                responseObject = BuildResponseObject(false, returnMessage);

            return responseObject;
        }

        [Route("LevelCscSearch")]
        public HttpResponseMessage LevelCascCodeSearch(AreaFetch SearchObject)
        {

            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(BlockCascCodeSearch), Level.Info.ToString());
                var ErrorMessage = string.Empty;
                var result = _SearchBAL.LevelCascCodeSearch(SearchObject);
                if (result == null)
                {
                    responseObject = BuildResponseObject(HttpStatusCode.NotFound);
                }
                else
                {
                    var serialisedData = JsonConvert.SerializeObject(result);
                    responseObject = BuildResponseObject(HttpStatusCode.OK, serialisedData);
                }

                Log4NetLogger.LogExit(_FileName, nameof(BlockCascCodeSearch), Level.Info.ToString());
            }
            catch (Exception ex)
            {
                returnMessage = $"{ resxFileHelper.GetErrorMessagesFromResource("GeneralException")} : { ex.Message}";
            }

            if (responseObject == null)
                responseObject = BuildResponseObject(false, returnMessage);

            return responseObject;
        }

        [Route("AreaCascCodeSearch")]
        public HttpResponseMessage AreaCascCodeSearch(AreaFetch SearchObject)
        {

            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(BlockCascCodeSearch), Level.Info.ToString());
                var ErrorMessage = string.Empty;
                var result = _SearchBAL.AreaCascCodeSearch(SearchObject);
                if (result == null)
                {
                    responseObject = BuildResponseObject(HttpStatusCode.NotFound);
                }
                else
                {
                    var serialisedData = JsonConvert.SerializeObject(result);
                    responseObject = BuildResponseObject(HttpStatusCode.OK, serialisedData);
                }

                Log4NetLogger.LogExit(_FileName, nameof(BlockCascCodeSearch), Level.Info.ToString());
            }
            catch (Exception ex)
            {
                returnMessage = $"{ resxFileHelper.GetErrorMessagesFromResource("GeneralException")} : { ex.Message}";
            }

            if (responseObject == null)
                responseObject = BuildResponseObject(false, returnMessage);

            return responseObject;
        }


        [Route("BookingLocationSearch")]
        public HttpResponseMessage BookingLocationSearch(UserLocationCodeSearch SearchObject)
        {

            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(BookingLocationSearch), Level.Info.ToString());
                var ErrorMessage = string.Empty;
                var result = _SearchBAL.BookingLocationSearch(SearchObject);
                if (result == null)
                {
                    responseObject = BuildResponseObject(HttpStatusCode.NotFound);
                }
                else
                {
                    var serialisedData = JsonConvert.SerializeObject(result);
                    responseObject = BuildResponseObject(HttpStatusCode.OK, serialisedData);
                }

                Log4NetLogger.LogExit(_FileName, nameof(BookingLocationSearch), Level.Info.ToString());
            }
            catch (Exception ex)
            {
                returnMessage = $"{ resxFileHelper.GetErrorMessagesFromResource("GeneralException")} : { ex.Message}";
            }

            if (responseObject == null)
                responseObject = BuildResponseObject(false, returnMessage);

            return responseObject;
        }


        //[HttpPost]
        //[Route(nameof(BERNoList))]
        //public HttpResponseMessage BERNoList(BERNoList SearchObject)
        //{

        //    try
        //    {
        //        Log4NetLogger.LogEntry(_FileName, nameof(BERNoList), Level.Info.ToString());
        //        var ErrorMessage = string.Empty;
        //        var result = _SearchBAL.BERNoList(SearchObject);
        //        if (result == null)
        //        {
        //            responseObject = BuildResponseObject(HttpStatusCode.NotFound);
        //        }
        //        else
        //        {
        //            var serialisedData = JsonConvert.SerializeObject(result);
        //            responseObject = BuildResponseObject(HttpStatusCode.OK, serialisedData);
        //        }

        //        Log4NetLogger.LogExit(_FileName, nameof(TypeCodeSearch), Level.Info.ToString());
        //    }
        //    catch (Exception ex)
        //    {
        //        returnMessage = $"{resxFileHelper.GetErrorMessagesFromResource("GeneralException")} : {ex.Message}";
        //    }

        //    if (responseObject == null)
        //        responseObject = BuildResponseObject(false, returnMessage);

        //    return responseObject;
        //}




    }//

}
