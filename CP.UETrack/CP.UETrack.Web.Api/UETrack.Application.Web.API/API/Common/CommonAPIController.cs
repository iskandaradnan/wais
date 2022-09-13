using CP.Framework.Common.Audit;
using CP.Framework.Common.Logging;
using CP.UETrack.Application.Web.API;
using CP.UETrack.Application.Web.API.Helpers;
using CP.UETrack.BLL.BusinessAccess.Contracts.Common;
using CP.UETrack.DAL.DataAccess;
using CP.UETrack.Model;
using CP.UETrack.Model.BEMS;
using CP.UETrack.Model.BEMS.AssetRegister;
using CP.UETrack.Model.BEMS.CRMWorkOrder;
using CP.UETrack.Model.BEMS.UserTraining;
using CP.UETrack.Model.BER;
using CP.UETrack.Model.Common;
using CP.UETrack.Model.GM;
using CP.UETrack.Model.KPI;
using CP.UETrack.Model.LLS;
using CP.UETrack.Model.Portering;
using CP.UETrack.Model.QAP;
using CP.UETrack.Model.UM;
using CP.UETrack.Model.VM;
using CP.UETrack.Models.BEMS;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.ComponentModel;
using System.Data;
using System.Globalization;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Net.Http.Formatting;
using System.Text;
using System.Text.RegularExpressions;
using System.Web.Http;
using UETrack.Application.Web.API.Models;
using UETrack.DAL;

namespace UETrack.Application.Web.API.API.Common
{
    [RoutePrefix("api/Common1")]
    [WebApiAudit]
    public class CommonAPIController : BaseApiController
    {
        private readonly ICommonBAL _ICommonBAL;
        private readonly string _FileName = nameof(CommonAPIController);
        readonly UserDetailsModel _UserSession = new SessionHelper().UserSession();
        public CommonAPIController(ICommonBAL commonBAL)
        {
            _ICommonBAL = commonBAL;
        }

        [HttpGet]
        [Route("Download/{Id}")]
        public HttpResponseMessage Download(string Id)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Download), Level.Info.ToString());
                var document = _ICommonBAL.DownloadAttachments(int.Parse(Id));
                if (document == null || string.IsNullOrEmpty(document.FilePath))
                {
                    responseObject = BuildResponseObject(HttpStatusCode.NotFound, false, String.Format(resxFileHelper.GetErrorMessagesFromResource("AAFileNotFound"), "Download - "));
                }
                else
                {
                    var serialisedData = JsonConvert.SerializeObject(document);
                    responseObject = BuildResponseObject(HttpStatusCode.OK, serialisedData);
                    //Filename changed to documentTitle
                    // responseObject = ExportHelper.Download(document.FilePath, document.DocumentTitle);

                }
                Log4NetLogger.LogExit(_FileName, nameof(Download), Level.Info.ToString());
                return responseObject;
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
        [Route("GetHelpDescription")]
        public HttpResponseMessage GetHelpDescription(Helpdescription form)
        {

            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(GetHelpDescription), Level.Info.ToString());

                var result = _ICommonBAL.GetHelpDescription(form.ScreenUrl);
                var serialisedData = JsonConvert.SerializeObject(result);
                responseObject = serialisedData == null ? BuildResponseObject(HttpStatusCode.NotFound) : BuildResponseObject(HttpStatusCode.OK, serialisedData);
                Log4NetLogger.LogExit(_FileName, nameof(GetHelpDescription), Level.Info.ToString());
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
        [Route(nameof(ExportCSVTemplate))]
        public HttpResponseMessage ExportCSVTemplate(FormDataCollection form, string spName)
        {
            try
            {
                var columnNames = form.GetValues("columnNames")[0];
                var headerNames = form.GetValues("headerColumnNames");
                var filters = form.GetValues("filters")[0];
                var sortColumn = form.GetValues("sortColumnName")[0];
                var sortType = form.GetValues("sortOrder")[0];
                var screenTitle = form.GetValues("screenName") == null ? string.Empty : form.GetValues("screenName")[0];
                DataTable dt = new DataTable();
                switch (spName)
                {
                    case "uspFM_EngStockUpdateRegisterTxn_Export_Template":
                        var stockUpdateMOdel = new ExportModel
                        {
                            //StockUpdateNo = "BEMS/PAN101/201808/000025",
                          //  Date = DateTime.Now.ToString("dd-MMM-yyyy").Replace("-", "/"),
                            //Year = DateTime.Now.Year.ToString(),
                          //  TotalSparePartCost = "10",
                         //   FacilityCode = "SAMP001",
                          //  FacilityName = "Sample Facility Name",
                            PartNo = "SAMP001",
                            PartDescription = "Sample Description",
                            SparePartType = "Inventory",
                            Location="Centralized",
                            ItemCode = "SAMCode001",
                            ItemDescription = "Sample Description",
                            PartSource = "OEM",
                            LifeSpanOptions = "Year",
                            EstimatedLifeSpan = "10",
                            ExpiryDate = DateTime.Now.ToString("dd-MMM-yyyy").Replace("-", "/"),
                            Quantity = "10",                            
                            PurchaseCost = "10",
                            Cost = "20",
                            InvoiceNo = "SAMINV001",
                            VendorName = "JHON",
                            BinNo="SampleBinNo12",
                            Remarks = "Sample Remarks"
                        };
                        dt = ConvertToTable(stockUpdateMOdel);
                        break;
                    case "uspFM_EngPlannerTxn_Export":
                        var plannerModel = new PlannerExport
                        {
                            WorkOrderType = "PPM",
                            Year = "2018",
                            Assignee = "Super Admin",
                            AssetClassification = "Sample",
                            PPMType = "Warranty",
                            TypeCode = "ATC-General/01",
                            TypeCodeDescription = "SAMP99",
                            AssetNo = "Dia1010-0001",
                            PPMTaskCode = "PTC0001",
                            Schedule = "Monthly-Day",
                            Status = "Active",
                            Month = "Jan,Feb,Mar",
                            Date = "1|2|3|4",
                            Week = "1|2|3|4",
                            Day = "1|2|3|4"
                        };
                        dt = ConvertToTable(plannerModel);
                        break;
                    case "uspFM_AssetRegisterTxn_Export":

                        var assetId = form.GetValues("AssetId") == null ? string.Empty : form.GetValues("AssetId")[0];

                        var model = _ICommonBAL.GetAssetData(assetId);

                        var assetModel = model; 



                        // var assetModel = new AssetRegisterImport
                        //{
                        //    AssetNo = "SAM0001",
                        //    AssetDescription = "Sample Description",
                        //    AssetClassification = "General",
                        //    AssetPreRegistrationNo = "SAM0077",
                        //    TypeCode = "ATC-General/01",
                        //    //TypeDescription = "SAMP99",
                        //    Model = "SAMmodel",
                        //    Manufacturer = "SamManuf",
                        //    CurrentLocationName = "JHON",
                        //    ManufacturingDate = DateTime.Now.ToString("dd-MMM-yyyy").Replace("-", "/"),
                        //    AppliedPartType = "B"
                        //};
                        dt = ConvertToTable(assetModel);
                        break;

                }

                var gridColumnNames = new List<string>();
                responseObject = ExportHelper.Export<DataTable>(dt, "CSV", gridColumnNames, headerNames.ToList(), screenTitle);

            }
            catch (Exception ex)
            {
                returnMessage = string.Format("{0} : {1}", resxFileHelper.GetErrorMessagesFromResource("GeneralException"), ex.Message);
            }

            if (responseObject == null)
                responseObject = BuildResponseObject(false, returnMessage);

            return responseObject;
        }
        public static DataTable ConvertToTable<T>(T data)
        {
            var properties = TypeDescriptor.GetProperties(typeof(T));
            var table = new DataTable();
            foreach (PropertyDescriptor prop in properties)
            {
                table.Columns.Add(prop.Name, Nullable.GetUnderlyingType(prop.PropertyType) ?? prop.PropertyType);
            }
            var row = table.NewRow();
            foreach (PropertyDescriptor prop in properties)
            {
                row[prop.Name] = prop.GetValue(data) ?? DBNull.Value;
            }
            table.Rows.Add(row);

            return table;

        }

        [HttpPost]
        [Route(nameof(Export))]
        public HttpResponseMessage Export(FormDataCollection form)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Export), Level.Info.ToString());
                var exportType = form.GetValues("exportType")[0];
                //var headerNames = form.GetValues("headerColumnNames")[0];
                var sortColumn = form.GetValues("sortColumnName")[0];
                var filters = form.GetValues("filters")[0];
                var sortType = form.GetValues("sortOrder")[0];
                var spName = form.GetValues("spName")[0];
                var screenTitle = form.GetValues("screenName") == null ? string.Empty : form.GetValues("screenName")[0];
                var defaultFilters = form.GetValues("defaultFilters") == null ? string.Empty : form.GetValues("defaultFilters")[0];
                var KPIExportType = form.GetValues("KPIExportType") == null ? string.Empty : form.GetValues("KPIExportType")[0];
                var assetId = form.GetValues("AssetId") == null ? string.Empty : form.GetValues("AssetId")[0];
                var MonthlyStkExport = form.GetValues("Year") == null ? string.Empty : form.GetValues("Year")[0];

                KPIGenerationFetch kpiGenerationFetch = null;
                ItemMonthlyStockRegisterList monthlystkRegmodel = null;
                VVFEntity vvfExport = null;
                if (KPIExportType != string.Empty)
                {
                    if (KPIExportType == "Demerit")
                    {
                        spName = "uspFM_KpiGenerationTxn_Popup_DemeritPoints_Export";
                    }
                    else if (KPIExportType == "KPIValue")
                    {
                        spName = "uspFM_KpiGenerationTxn_Popup_DeductionValue_Export";
                    }
                    else if (KPIExportType == "KPIGeneration")
                    {
                        spName = "uspFM_DedGenerationTxn_A";
                    }
                    var Year = Convert.ToInt32(form.GetValues("Year")[0]);
                    var Month = Convert.ToInt32(form.GetValues("Month")[0]);
                    var ServiceId = 2; // Convert.ToInt32(form.GetValues("ServiceId")[0]);
                    var IndicatorNo = form.GetValues("IndicatorNo")[0];
                    kpiGenerationFetch = new KPIGenerationFetch { Year = Year, Month = Month, ServiceId = ServiceId, IndicatorNo = IndicatorNo };
                }

                if (MonthlyStkExport != string.Empty && screenTitle == "Monthly_Stock_Register")
                {
                    spName = "uspFM_EngStockMonthlyRegisterTxn_Export";
                    var MonthlyStkYear = Convert.ToInt32(form.GetValues("Year")[0]);
                    var MonthlyStkMonth = Convert.ToInt32(form.GetValues("Month")[0]);
                    var PartNo = Convert.ToString(form.GetValues("PartNo")[0]);
                    var PartDescription = Convert.ToString(form.GetValues("PartDescription")[0]);
                    var ItemCode = Convert.ToString(form.GetValues("ItemCode")[0]);
                    var ItemDescription = Convert.ToString(form.GetValues("ItemDescription")[0]);
                    var SparePartTypeName = Convert.ToString(form.GetValues("SparePartType")[0]);
                    monthlystkRegmodel = new ItemMonthlyStockRegisterList { Year = MonthlyStkYear, Month = MonthlyStkMonth, PartNo = PartNo, PartDescription = PartDescription, ItemCode = ItemCode, ItemDescription = ItemDescription, SparePartTypeName = SparePartTypeName };

                }
                if ( screenTitle == "Verification_Of_Variations")
                {
                    spName = "uspFM_VmVariationTxnVVF_Export";
                    var MonthlyStkYear = Convert.ToInt32(form.GetValues("Year")[0]);
                    var MonthlyStkMonth = Convert.ToInt32(form.GetValues("Month")[0]);
                    var VariationStatusValue = Convert.ToString(form.GetValues("VariationStatusValue") == null ? string.Empty : form.GetValues("VariationStatusValue")[0]);                  
                    var facilityid = _UserSession.FacilityId;
                    vvfExport = new VVFEntity { Year = MonthlyStkYear, Month = MonthlyStkMonth, VariationStatusValue = VariationStatusValue,FacilityId=facilityid };

                }

                var paginationFilter = new SortPaginateFilter();
                var filterCondtions = new List<KeyValuePair<string, string>>();
                if (filters != string.Empty)
                {
                    var keyValue = new KeyValuePair<string, string>(nameof(filters), filters);
                    filterCondtions.Add(keyValue);
                }
                if (defaultFilters != string.Empty)
                {
                    var keyValue = new KeyValuePair<string, string>(nameof(defaultFilters), defaultFilters);
                    filterCondtions.Add(keyValue);
                }
                if (filterCondtions.Count > 0)
                {
                    switch (spName)
                    {
                        case "uspFM_DeductionTransactionMappingMst_Export":
                            paginationFilter = GridHelper.GetAllFormatSearchConditionForExport<KPITransactionMapping>(filterCondtions);
                            break;
                        case "uspFM_QAPCarTxn_Export":
                            paginationFilter = GridHelper.GetAllFormatSearchConditionForExport<CorrectiveActionReport>(filterCondtions);
                            break;
                        case "uspFM_UMUserRole_Export":
                            paginationFilter = GridHelper.GetAllFormatSearchConditionForExport<UMUserRole>(filterCondtions);
                            break;
                        case "uspFM_EngTestingandCommissioningTxn_Export":
                            paginationFilter = GridHelper.GetAllFormatSearchConditionForExport<TestingAndCommissioning>(filterCondtions);
                            break;
                        case "uspFM_EngAsset_Export":
                            paginationFilter = GridHelper.GetAllFormatSearchConditionForExport<AssetRegister>(filterCondtions);
                            break;
                        case "uspFM_UMBlockedUsers_Export":
                            paginationFilter = GridHelper.GetAllFormatSearchConditionForExport<UMUserRegistration>(filterCondtions);
                            break;
                        case "uspFM_UMUserRegistration_Export":
                            paginationFilter = GridHelper.GetAllFormatSearchConditionForExport<UMUserRegistration>(filterCondtions);
                            break;
                        case "uspFM_CRMRequest_Export":
                            paginationFilter = GridHelper.GetAllFormatSearchConditionForExport<CRMRequestEntity>(filterCondtions);
                            break;
                        case "uspFM_EngStockUpdateRegisterTxn_Export":
                            paginationFilter = GridHelper.GetAllFormatSearchConditionForExport<StockUpdateRegisterGetallEntity>(filterCondtions);
                            break;
                        case "uspFM_EngStockUpdateRegisterTxn_Export_Template":
                            return ExportCSVTemplate(form, spName);
                        //paginationFilter = GridHelper.GetAllFormatSearchConditionForExport<StockUpdateRegister>(filterCondtions);
                        //break;
                        case "uspFM_EngPlannerTxn_Export":
                            return ExportCSVTemplate(form, spName);
                        //paginationFilter = GridHelper.GetAllFormatSearchConditionForExport<StockUpdateRegister>(filterCondtions);
                        //break;
                        case "uspFM_AssetRegisterTxn_Export":
                            return ExportCSVTemplate(form, spName);
                        //paginationFilter = GridHelper.GetAllFormatSearchConditionForExport<StockUpdateRegister>(filterCondtions);
                        //break;
                        case "uspFM_EngContractOutRegister_Export":
                            paginationFilter = GridHelper.GetAllFormatSearchConditionForExport<CORGetallEntity>(filterCondtions);
                            break;
                        case "uspFM_MstLocationBlock_Export":
                            paginationFilter = GridHelper.GetAllFormatSearchConditionForExport<BlockMstViewModel>(filterCondtions);
                            break;
                        case "uspFM_MstLocationLevel_Export":
                            paginationFilter = GridHelper.GetAllFormatSearchConditionForExport<LevelMstViewModel>(filterCondtions);
                            break;
                        case "uspFM_MstStaff_Company_Export":
                        case "uspFM_MstStaff_Facility_Export":
                            paginationFilter = GridHelper.GetAllFormatSearchConditionForExport<StaffMstViewModel>(filterCondtions);
                            break;
                        case "uspFM_EngStockAdjustmentTxn_Export":
                            paginationFilter = GridHelper.GetAllFormatSearchConditionForExport<StockAdjustmentModel>(filterCondtions);
                            break;
                        case "uspFM_EngAssetStandardizationInformation_Export":
                            paginationFilter = GridHelper.GetAllFormatSearchConditionForExport<AssetInformationViewModel>(filterCondtions);
                            break;
                        case "uspFM_EngEODCategorySystem_Export":
                            paginationFilter = GridHelper.GetAllFormatSearchConditionForExport<EODCategorySystemViewModel>(filterCondtions);
                            break;
                        case "uspFM_MstQAPIndicator_Export":
                            paginationFilter = GridHelper.GetAllFormatSearchConditionForExport<QAPIndicatorMasterModel>(filterCondtions);
                            break;
                        case "uspFM_MstQAPQualityCause_Export":
                            paginationFilter = GridHelper.GetAllFormatSearchConditionForExport<QualityCauseMasterModel>(filterCondtions);
                            break;
                        case "uspFM_MstLocationFacility_Export":
                            paginationFilter = GridHelper.GetAllFormatSearchConditionForExport<MstLocationFacilityViewModel>(filterCondtions);
                            break;
                        case "uspFM_MstCustomer_Export":
                            paginationFilter = GridHelper.GetAllFormatSearchConditionForExport<CustomerMstViewModel>(filterCondtions);
                            break;
                        case "uspFM_EngAssetClassification_Export":
                            paginationFilter = GridHelper.GetAllFormatSearchConditionForExport<EngAssetClassification>(filterCondtions);
                            break;
                        case "uspFM_MstLocationUserArea_Export":
                            paginationFilter = GridHelper.GetAllFormatSearchConditionForExport<MstLocationUserAreaViewModel>(filterCondtions);
                            break;
                        case "uspFM_MstLocationUserLocation_Export":
                            paginationFilter = GridHelper.GetAllFormatSearchConditionForExport<MstLocationUserLocation>(filterCondtions);
                            break;
                        case "uspFM_MstContractorandVendor_Export":
                            paginationFilter = GridHelper.GetAllFormatSearchConditionForExport<MstContractorandVendorViewModel>(filterCondtions);
                            break;
                        case "uspFM_EngSpareParts_Export":
                            paginationFilter = GridHelper.GetAllFormatSearchConditionForExport<EngSpareParts>(filterCondtions);
                            break;
                        case "uspFM_EngEODCaptureTxn_Export":
                            paginationFilter = GridHelper.GetAllFormatSearchConditionForExport<EODCapture>(filterCondtions);
                            break;
                        case "uspFM_FinMonthlyFeeTxn_Export":
                            paginationFilter = GridHelper.GetAllFormatSearchConditionForExport<MonthlyServiceFeeModel>(filterCondtions);
                            break;
                        case "uspFM_EngStockMonthlyRegisterTxn_Fetch":
                            paginationFilter = GridHelper.GetAllFormatSearchConditionForExport<MonthlyStockRegisterModel>(filterCondtions);
                            break;
                        case "uspFM_EngAssetTypeCode_Export":
                            paginationFilter = GridHelper.GetAllFormatSearchConditionForExport<EngAssetTypeCode>(filterCondtions);
                            break;
                        case "uspFM_EngAssetStandardization_Export":
                            paginationFilter = GridHelper.GetAllFormatSearchConditionForExport<AssetStandardization>(filterCondtions);
                            break;
                        case "uspFM_BERApplicationTxn_Export":
                            paginationFilter = GridHelper.GetAllFormatSearchConditionForExport<BERApplicationTxn>(filterCondtions);
                            break;
                        case "uspFM_EngEODCategorySystemDet_Export":
                            paginationFilter = GridHelper.GetAllFormatSearchConditionForExport<EODTypeCodeMappingViewModel>(filterCondtions);
                            break;
                        case "uspFM_PorteringTransaction_Export":
                            paginationFilter = GridHelper.GetAllFormatSearchConditionForExport<PorteringModel>(filterCondtions);
                            break;
                        case "uspFM_VmVariationTxnVVF_Export":
                            paginationFilter = GridHelper.GetAllFormatSearchConditionForExport<VVFExportEntity>(filterCondtions);
                            break;
                        case "uspFM_EngEODParameterMapping_Export":
                            paginationFilter = GridHelper.GetAllFormatSearchConditionForExport<EODParameterMapping>(filterCondtions);
                            break;
                        case "uspFM_EngWarrantyManagementTxn_Export":
                            paginationFilter = GridHelper.GetAllFormatSearchConditionForExport<WarrantyManagement>(filterCondtions);
                            break;
                        case "uspFM_BERApplicationTxnBER2_Export":
                            paginationFilter = GridHelper.GetAllFormatSearchConditionForExport<BERApplicationTxn>(filterCondtions);
                            break;
                        case "uspFM_EngPlannerTxn_PPM_Export":
                            paginationFilter = GridHelper.GetAllFormatSearchConditionForExport<EngPlannerTxn>(filterCondtions);
                            break;
                        case "uspFM_EngPlannerTxn_RI_Export":
                            paginationFilter = GridHelper.GetAllFormatSearchConditionForExport<EngPlannerTxn>(filterCondtions);
                            break;
                        case "uspFM_EngPlannerTxn_Others_Export":
                            paginationFilter = GridHelper.GetAllFormatSearchConditionForExport<EngPlannerTxn>(filterCondtions);
                            break;
                            //case "uspFM_EngStockMonthlyRegisterTxn_Export":
                            //    paginationFilter = GridHelper.GetAllFormatSearchConditionForExport<ItemMonthlyStockRegisterList>(filterCondtions);
                            //    break;
                            
                        case "uspFM_EngMaintenanceWorkOrderTxn_Scheduled_Export":
                            paginationFilter = GridHelper.GetAllFormatSearchConditionForExport<ScheduledWorkOrderModel>(filterCondtions);
                            break;
                        case "uspFM_EngMaintenanceWorkOrderTxn_UnSchedule_Export":
                            paginationFilter = GridHelper.GetAllFormatSearchConditionForExport<ScheduledWorkOrderModel>(filterCondtions);
                            break;

                        case "uspFM_FMLovMst_Export":
                            paginationFilter = GridHelper.GetAllFormatSearchConditionForExport<LovMasterGrid>(filterCondtions);
                            break;
                        case "uspFM_EngTestingandCommissioningTxnSNF_Export":
                            paginationFilter = GridHelper.GetAllFormatSearchConditionForExport<SNFGetallEntity>(filterCondtions);
                            break;
                        case "uspFM_EngLoanerTestEquipmentBookingTxn_Export ":
                            paginationFilter = GridHelper.GetAllFormatSearchConditionForExport<LoanerBooking>(filterCondtions);
                            break;
                        case "uspFM_CRMRequestWorkOrderTxn_Export":
                            paginationFilter = GridHelper.GetAllFormatSearchConditionForExport<CRMWorkorder>(filterCondtions);
                            break;
                        case "uspFM_EngMwoReschedulingTxn_Export":
                            paginationFilter = GridHelper.GetAllFormatSearchConditionForExport<RescheduleWOViewModel>(filterCondtions);
                            break;
                        case "uspFM_UMUserShifts_Export":
                            paginationFilter = GridHelper.GetAllFormatSearchConditionForExport<UserShiftLeaveViewModel>(filterCondtions);
                            break;
                        case "uspFM_EngAssetPPMCheckList_Export":
                            paginationFilter = GridHelper.GetAllFormatSearchConditionForExport<PPMCheckListModel>(filterCondtions);
                            break;

                        case "uspFM_WorkOrder_Manual_Export":
                            paginationFilter = GridHelper.GetAllFormatSearchConditionForExport<ManualassignViewModel>(filterCondtions);
                            break;
                        case "uspFM_NotificationTemplate_Export":
                            paginationFilter = GridHelper.GetAllFormatSearchConditionForExport<NotificationDeliveryConfigurationModel>(filterCondtions);
                            break;
                        case "uspFM_EngFacilitiesWorkshopTxn_Export":
                            paginationFilter = GridHelper.GetAllFormatSearchConditionForExport<FacilityWorkshop>(filterCondtions);
                            break;
                        case "uspFM_GetAssignedWorkOrder_GetAll_Export":
                            paginationFilter = GridHelper.GetAllFormatSearchConditionForExport<SmartAssign>(filterCondtions);
                            break;
                        case "uspFM_EngLicenseandCertificateTxn_Export":
                            paginationFilter = GridHelper.GetAllFormatSearchConditionForExport<LicenseAndCertificateEntity>(filterCondtions);
                            break;
                        case "uspFM_KPIReportsandRecordTxn_Export":
                            paginationFilter = GridHelper.GetAllFormatSearchConditionForExport<ReportsAndRecordsLst>(filterCondtions);
                            break;
                        case "uspFM_EngTrainingScheduleTxn_Export":
                            paginationFilter = GridHelper.GetAllFormatSearchConditionForExport<UserTrainingCompletion>(filterCondtions);
                            break;
                        case "uspFM_CRMWorkOrderAssign_Export":
                            paginationFilter = GridHelper.GetAllFormatSearchConditionForExport<CRMWorkorderAssign>(filterCondtions);
                            break;
                        case "uspFM_EngMaintenanceWorkOrderTxn_Export":
                            paginationFilter = GridHelper.GetAllFormatSearchConditionForExport<ScheduledWorkOrderModel>(filterCondtions);
                            break;
                        case "uspFM_VMRollOverFeeReport_Export":
                            paginationFilter = GridHelper.GetAllFormatSearchConditionForExport<SFRGetallEntity>(filterCondtions);
                            break;
                        case "LLSCleanLinenIssueTxn_Export":
                            paginationFilter = GridHelper.GetAllFormatSearchConditionForExport<CleanLinenIssueModel_Filter>(filterCondtions);
                            break;
                        case "LLSCleanLinenRequestTxn_Export":
                            paginationFilter = GridHelper.GetAllFormatSearchConditionForExport<CleanLinenRequestModel>(filterCondtions);
                            break;
                    }
                }

                paginationFilter.WhereCondition = paginationFilter.QueryWhereCondition;
                paginationFilter.SortColumn = sortColumn;
                paginationFilter.SortOrder = sortType;

                DataTable result = null;
                if (KPIExportType == string.Empty)
                {
                    if (spName == "uspFM_EngAssetMaintenanceHistory_Export")
                    {
                        result = _ICommonBAL.WarrantyHistory(spName, assetId);
                    }
                    else if (spName == "uspFM_EngStockMonthlyRegisterTxn_Export")
                    {
                        result = _ICommonBAL.MonthlyStockRegisterExport(spName, monthlystkRegmodel);
                    }
                    else if (spName == "uspFM_VmVariationTxnVVF_Export")
                    {
                        result = _ICommonBAL.VerificationOfVariationExport(spName, vvfExport);
                    }
                    else
                    {
                        result = _ICommonBAL.Export(paginationFilter, spName);
                    }
                }
                else
                {
                    result = _ICommonBAL.KPIExport(spName, kpiGenerationFetch);
                }

                if (result == null)
                {
                    responseObject = BuildResponseObject(HttpStatusCode.NotFound);
                }
                else
                {
                    var gridColumnNames = new List<string>();
                    var headerColumnNames = getHeaderColumnNames(result, spName);
                    responseObject = ExportHelper.Export<DataTable>(result, exportType.ToString().ToUpper(), gridColumnNames, headerColumnNames, screenTitle);
                }
            }
            catch (Exception ex)
            {
                returnMessage = string.Format("{0} : {1}", resxFileHelper.GetErrorMessagesFromResource("GeneralException"), ex.Message);
            }

            if (responseObject == null)
                responseObject = BuildResponseObject(false, returnMessage);

            return responseObject;
        }
        public List<string> getHeaderColumnNames(DataTable Table, string SPName)
        {

            var builder = new StringBuilder();

            for (int i = 0; i < Table.Columns.Count; i++) //(DataColumn column in Table.Columns)
            {
                var ColumnName = Table.Columns[i].ColumnName;
                builder.Append(ColumnName);
                if (i != Table.Columns.Count - 1)
                    builder.Append(",");
            }
            var headerString = builder.ToString();

            var currency = _UserSession.Currency;
            switch (SPName)
            {
                case "uspFM_UMUserRole_Export":
                    headerString = headerString.Replace("RoleName", "Role Name");
                    headerString = headerString.Replace("UserType", "User Type");
                    headerString = headerString.Replace("StatusValue", "Status");
                    break;

                case "uspFM_UMUserShifts_Export":
                    headerString = headerString.Replace("StaffName", "Staff Name");
                    headerString = headerString.Replace("UserName", "User Name");
                    headerString = headerString.Replace("MobileNo", "Mobile No");
                    headerString = headerString.Replace("UserType", "User Type");
                    headerString = headerString.Replace("ShiftStarttime", "Shift Start time");
                    headerString = headerString.Replace("ShiftEndtime", "Shift End time");
                    headerString = headerString.Replace("ShiftBreakStartTime", "Shift Break Start Time");
                    headerString = headerString.Replace("ShiftBreakEndTime", "Shift Break End Time");
                    headerString = headerString.Replace("LeaveFrom", "Leave From");
                    headerString = headerString.Replace("LeaveTo", "Leave To");
                    headerString = headerString.Replace("NoOfDays", "No Of Days");
                    break;
                    

                case "uspFM_UMBlockedUsers_Export":
                    headerString = headerString.Replace("CustomerName", "Customer Name");
                    headerString = headerString.Replace("StaffName", "Staff Name");
                    headerString = headerString.Replace("UserName", "Username");
                    headerString = headerString.Replace("UserTypeValue", "User Type");
                    headerString = headerString.Replace("StatusValue", "Status");
                    break;
                case "uspFM_EngAssetStandardizationInformation_Export":
                    headerString = headerString.Replace("AssetInfoTypeName", "Type");
                    headerString = headerString.Replace("AssetInfoValue", "Name");
                    break;

                default:
                    headerString = Regex.Replace(headerString, @"(?<!^)(?=[A-Z])", " $0");
                    break;
            }
            switch (SPName)//exceptional cases
            {
                case "uspFM_EngTestingandCommissioningTxn_Export":
                    headerString = headerString.Replace("Contract L P O No", "Contract LPO No.");
                    headerString = headerString.Replace("Tand C Document No", "T&C Document No.");
                    headerString = headerString.Replace(" Request No", "Request No.");
                    headerString = headerString.Replace("Asset Pre Registration No", "Asset Pre Registration No.");
                    headerString = headerString.Replace("Tand C Type", "T&C Type");
                    headerString = headerString.Replace("Tand C Date", "T&C Date");
                    headerString = headerString.Replace("Tand C Status", "T&C Status");
                    headerString = headerString.Replace("Tand C Completed Date", "T&C Completed Date");
                    headerString = headerString.Replace("Tand C Contractor Representative", "T&C Contractor Representative");
                    headerString = headerString.Replace("Status Name", "Status");
                    break;
                case "uspFM_QAPCarTxn_Export":
                    headerString = headerString.Replace("C A R", "CAR");
                    break;

                case "uspFM_EngEODCaptureTxn_Export":
                    headerString = headerString.Replace("U O M", "UOM");
                    headerString = headerString.Replace("AssetDesc", "AssetDescription");
                    break;
                case "uspFM_EngAssetTypeCode_Export":
                    headerString = headerString.Replace("Q A P Asset Service", "QAP Asset Service");
                    headerString = headerString.Replace("Q A P Asset Type( B1)", "QAP Asset Type(B1)");
                    headerString = headerString.Replace("Q A P Service Availability( B2)", "QAP Service Availability(B2)");
                    headerString = headerString.Replace("Q A P Uptime Target(%)", "QAP Uptime Target(%)");
                    break;
                case "uspFM_EngEODParameterMapping_Export":
                    headerString = headerString.Replace("U O M", "UOM");
                    break;
                case "uspFM_EngWarrantyManagementTxn_Export":
                    headerString = headerString.Replace("T& C Reference No.", "T&C Reference No.");
                    headerString = headerString.Replace("Purchase Cost ( R M)", "Purchase Cost (RM)");
                    headerString = headerString.Replace("Monthly D W Fee ( R M)", "Monthly DW Fee (RM)");
                    headerString = headerString.Replace("Monthly P W Fee ( R M)", "Monthly PW Fee (RM)");
                    break;
                case "uspFM_DedGenerationTxn_A":
                    headerString = headerString.Replace(" K P I Value( R M)", "KPI Value (RM)");
                    headerString = headerString.Replace(" K P I %", "KPI %");
                    break;
                case "uspFM_EngAssetPPMCheckList_Export":
                    headerString = headerString.Replace("P P M Checklist No", "PPM Checklist No");
                    headerString = headerString.Replace("No", "No.");
                    headerString = headerString.Replace("Units/ U O M", "Units / UOM");
                    headerString = headerString.Replace("P P M Hours", "PPM Hours");
                    headerString = headerString.Replace("Limit/ Tolerance", "Limit / Tolerance");
                    headerString = headerString.Replace("P P M Frequency Value", "PPM Frequency Value");
                    break;
                case "uspFM_EngPlannerTxn_PPM_Export":
                    headerString = headerString.Replace("P P M Type", "PPM Type");
                    headerString = headerString.Replace("P P M Task Code", "PPM Task Code");
                    headerString = headerString.Replace("Asset No", "Asset No.");
                    break;
                case "uspFM_EngSpareParts_Export": 
                    headerString= headerString.Replace("Type Code ( Device Code)", "Type Code (Device Code)");
                    headerString = headerString.Replace(" Asset Type Description ( Device Code)", "Asset Type Description (Device Code)");
                    headerString = headerString.Replace("Min Price Per Unit ( R M)", "Min Price Per Unit (RM)");
                    headerString = headerString.Replace("Max Price Per Unit ( R M)", "Max Price Per Unit (RM)");
                    break;

                case "uspFM_CRMRequestWorkOrderTxn_Export":               
                    headerString = headerString.Replace("C R M Work Order No", " CRM Work Order No");
                    headerString = headerString.Replace("C R M Work Order Date Time", " CRM Work Order Date Time");
                    break;
               
                case "uspFM_EngAsset_Export":
                    headerString = headerString.Replace("S N F No", "SNF No.");
                    headerString = headerString.Replace("P P M", "PPM");
                    headerString = headerString.Replace("Asset Pre Registration No", "Asset Pre Registration No.");
                    headerString = headerString.Replace("Parent Asset No", "Parent Asset No.");
                    headerString = headerString.Replace("Warranty Duration( Month)", "Warranty Duration (Month)"); 
                    headerString = headerString.Replace("Last Brakdown/ Emergency Work Order No", "Last Brakdown / Emergency Work Order No.");
                    headerString = headerString.Replace("Routine Inspection( R I) Flag", "Routine Inspection (RI) Flag");
                    headerString = headerString.Replace("Scheduled Downtime( Y T D)", "Scheduled Downtime (YTD)");
                    headerString = headerString.Replace("Unscheduled Downtime( Y T D)", "Unscheduled Downtime (YTD)");
                    headerString = headerString.Replace("Total Downtime( Y T D)", "Total Downtime (YTD)");
                    headerString = headerString.Replace("Purchase Cost R M", "Purchase Cost (RM)");
                    headerString = headerString.Replace("Cumulative Part Cost", "Cumulative Part Cost (RM)");
                    headerString = headerString.Replace("Cumulative Labour Cost", "Cumulative Labour Cost (RM)");
                    headerString = headerString.Replace("Cumulative Contract Cost", "Cumulative Contract Cost (RM)");
                    break;
                case "uspFM_BERApplicationTxn_Export":
                case "uspFM_BERApplicationTxnBER2_Export":
                    headerString = headerString.Replace("Asset No", "Asset No.");
                    headerString = headerString.Replace("B E R No.", "BER No.");
                    headerString = headerString.Replace("Purchase Cost ( R M)", string.Format("Purchase Cost ({0})", currency));
                    headerString = headerString.Replace("After Repair Value( R M)", string.Format("After Repair Value ({0})", currency));
                    headerString = headerString.Replace("Current Value( R M)", string.Format("Current Value (({0}))", currency));
                    headerString = headerString.Replace("Total Cost on Improvement( R M)", string.Format("Total Cost on Improvement ({0})", currency));

                    headerString = headerString.Replace("Estimated Repair Cost(R M)", string.Format("Estimated Repair Cost ({0})", currency));
                    headerString = headerString.Replace("Estimated Repair Cost( R M)", string.Format("Estimated Repair Cost  ({0})", currency));
                    headerString = headerString.Replace("Estimated Duration Of Usage After Repair( Months)", "Estimated Duration Of Usage After Repair (Months)");

                    break;
                case "uspFM_EngStockMonthlyRegisterTxn_Export":
                    headerString = headerString.Replace("U O M", "UOM");
                    break;
                case "uspFM_EngStockUpdateRegisterTxn_Export":
                    headerString = headerString.Replace(" Total Spare Part Cost( R M)", "Total Spare Part Cost (RM)");
                    headerString = headerString.Replace(" Cost/ Pcs( R M)", "Cost / Pcs (RM)");
                    headerString = headerString.Replace(" E R P PurchaseCost / Pcs( R M)", "ERP Purchase Cost / Pcs (RM)");
                    break;
                case "uspFM_EngStockAdjustmentTxn_Export":                  
                    headerString = headerString.Replace("Cost/ Pcs( R M)", "Cost / Pcs (RM)");
                    headerString = headerString.Replace(" E R P Purchase Cost/ Pcs( R M)", "ERP Purchase Cost / Pcs (RM)");
                    break;
                case "uspFM_VmVariationTxnVVF_Export":
                    headerString = headerString.Replace("Maintenance Rate D W", "Maintenance Rate DW");
                    headerString = headerString.Replace("Maintenance Rate P W", "Maintenance Rate PW");
                    headerString = headerString.Replace("Monthly Proposed Fee D W", "Monthly Proposed Fee DW");
                    headerString = headerString.Replace("Monthly Proposed Fee P W", "Monthly Proposed Fee PW");
                    headerString = headerString.Replace("User Area Name", "Area Name");
                    break;
                case "uspFM_MstLocationFacility_Export":
                    headerString = headerString.Replace("Initial Project Cost( R M)", "Initial Project Cost (RM)");
                    headerString = headerString.Replace("Current Monthly Service Fee( R M)", "Current Monthly Service Fee (RM)");
                    
                    break;
                case "uspFM_EngContractOutRegister_Export":
                    headerString = headerString.Replace(" Contract Value ( R M)", "Contract Value (RM)");                    
                    break;

            }
            headerString = headerString.Replace("(RM)","("+currency+")");
            var headerColumn = headerString.Split(',').ToList();
            return headerColumn;
        }
        public StringBuilder FormWhereClause(List<GridRuleModel> filterByWithDelete, string groupOp)
        {

            var WhereOperation =
           new Dictionary<string, string>
           {
                    { "eq", "{0} = '{1}'" },
                    { "bw", "{0} like '{1}%'" },
                    { "ew", "{0} like '%{1}'" },
                    { "cn", "{0} like '%{1}%'" },
                    { "nc", "not {0} like '%{1}%'" },
                    {"nn","not {0} = '{1}(null)'" },
                    {"nu","{0} is null" },
                    { "ne", "not {0} = '{1}'" },
                    { "gt", "{0} > {1}" },//Numeric
                    { "lt", "{0} < {1}" },
                    {"bn", "not {0} like '{1}%'" },
                    {"en", "not {0} like '%{1}'" },
                    { "ge", "{0} >= {1}" },
                    { "le", "{0} <= {1}" }
                    //{ "From Date", "{0} >= {1}" },//date time
                    //{ "To Date", "{0} <= {1}" },

           };
            var filterBy = new List<GridRuleModel>();

            filterBy = filterByWithDelete.OrderBy(x => x.op).ToList();
            var queryConditions = new StringBuilder();
            string filterValue = "";

            for (int index = 0; index < filterBy.Count; index++)
            {
                if (index != 0)
                {
                    queryConditions.Append(groupOp);
                }

                if (string.Equals(filterBy[index].data.ToString().Trim(), "", StringComparison.InvariantCultureIgnoreCase))
                {
                    filterValue = filterBy[index].data;
                }
                else
                { filterValue = filterBy[index].data; }

                if (filterBy[index].field.ToString().ToLower().Contains("date"))
                {
                    try
                    {
                        var filterValue1 = DateTime.ParseExact(filterValue, "dd/MMM/yyyy", CultureInfo.InvariantCulture);
                    }
                    catch (Exception)
                    { }
                    queryConditions.Append(string.Format(WhereOperation[filterBy[index].op], " replace(convert(nvarchar(20),[" + filterBy[index].field.ToString() + "],106),' ','-') ", "convert(datetime, '" + filterValue + "',103)", filterBy[index].data));
                }
                else
                {

                    queryConditions.Append(string.Format(WhereOperation[filterBy[index].op], " [" + filterBy[index].field + "]", filterValue, filterBy[index].data));
                }

            }
            return queryConditions;
        }

        [HttpGet]
        [Route("History/{GuId}/{PageIndex}/{PageSize}")]
        public HttpResponseMessage History(string GuId, int PageIndex, int PageSize)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Download), Level.Info.ToString());
                var document = _ICommonBAL.History(GuId, PageSize, PageIndex);
                if (document == null)
                {
                    responseObject = BuildResponseObject(HttpStatusCode.NotFound, false);
                }
                else
                {
                    // var serialisedData = JsonConvert.SerializeObject(document);
                    responseObject = BuildResponseObject(HttpStatusCode.OK, document);
                }
                Log4NetLogger.LogExit(_FileName, nameof(Download), Level.Info.ToString());
                return responseObject;
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