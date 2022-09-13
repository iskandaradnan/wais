using CP.UETrack.Model;
using System;
using System.Linq;
using CP.Framework.Common.Logging;
using CP.Framework.Common.ExceptionHandler.ExceptionWrappers;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using UETrack.DAL;
using CP.UETrack.DAL.DataAccess.Implementation;
using CP.UETrack.Model.BEMS.AssetRegister;
using System.Collections.Generic;
using CP.UETrack.Models;
using CP.UETrack.DAL.Helper;
using CP.Framework.Common.StateManagement;


namespace CP.UETrack.DAL.DataAccess
{

    public class AssetRegisterDAL : IAssetRegisterDAL
    {
        private readonly string _FileName = nameof(UserRoleDAL);
        readonly UserDetailsModel _UserSession = new SessionHelper().UserSession();
        int mastercrmID;
        int migout;
        public AssetRegisterLovs Load()
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
                AssetRegisterLovs assetRegisterLovs = null;

                var ds = new DataSet();
                var ds1 = new DataSet();
                var ds2 = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_Dropdown_group";                     
                        var da2 = new SqlDataAdapter();
                        da2.SelectCommand = cmd;
                        da2.Fill(ds2);

                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_Dropdown_Others";
                        cmd.Parameters.AddWithValue("@pLovKey", _UserSession.CustomerId);
                        cmd.Parameters.AddWithValue("@pTableName", "EngAsset");

                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);

                        var da1 = new SqlDataAdapter();
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_Dropdown";
                        cmd.Parameters.Clear();
                        cmd.Parameters.AddWithValue("@pLovKey", "RealTimeStatusValue,AppliedPartTypeValue,EquipmentClassValue,PowerSpecificationValue,PurchaseCategoryValue,StatusValue,AssetTransferModeValue,AssetTransferTypeValue,YesNoValue,TypeOfAssetValue,RiskRatingValue,TypeOfContractValue,AssetCategory,WorkGroup,BatchNo");
                        da1.SelectCommand = cmd;
                        da1.Fill(ds1);
                    }
                }
                assetRegisterLovs = new AssetRegisterLovs();
                if (ds.Tables.Count != 0)
                {
                    assetRegisterLovs.AssetWorkGroups = dbAccessDAL.GetLovRecords(ds.Tables[0]);
                    assetRegisterLovs.AssetClassifications = dbAccessDAL.GetLovRecords(ds.Tables[1]);
                    assetRegisterLovs.Services = dbAccessDAL.GetLovRecords(ds.Tables[2]);
                    assetRegisterLovs.Facilities = dbAccessDAL.GetLovRecords(ds.Tables[3]);
                }
                if (ds1.Tables.Count != 0)
                {
                    assetRegisterLovs.RealTimeStatusValues = dbAccessDAL.GetLovRecords(ds1.Tables[0], "RealTimeStatusValue");
                    assetRegisterLovs.AppliedPartTypeValues = dbAccessDAL.GetLovRecords(ds1.Tables[0], "AppliedPartTypeValue");
                    assetRegisterLovs.EquipmentClassValues = dbAccessDAL.GetLovRecords(ds1.Tables[0], "EquipmentClassValue");
                    assetRegisterLovs.PowerSpecificationValues = dbAccessDAL.GetLovRecords(ds1.Tables[0], "PowerSpecificationValue");
                    assetRegisterLovs.PurchaseCategoryValues = dbAccessDAL.GetLovRecords(ds1.Tables[0], "PurchaseCategoryValue");
                    assetRegisterLovs.StatusValues = dbAccessDAL.GetLovRecords(ds1.Tables[0], "StatusValue");
                    assetRegisterLovs.AssetTransferModeValues = dbAccessDAL.GetLovRecords(ds1.Tables[0], "AssetTransferModeValue");
                    assetRegisterLovs.AssetTransferTypeValues = dbAccessDAL.GetLovRecords(ds1.Tables[0], "AssetTransferTypeValue");
                    assetRegisterLovs.YesNoValues = dbAccessDAL.GetLovRecords(ds1.Tables[0], "YesNoValue");
                    assetRegisterLovs.TypeOfAssetValue = dbAccessDAL.GetLovRecords(ds1.Tables[0], "TypeOfAssetValue");
                    assetRegisterLovs.RiskRatings = dbAccessDAL.GetLovRecords(ds1.Tables[0], "RiskRatingValue");
                    assetRegisterLovs.ContractTypes = dbAccessDAL.GetLovRecords(ds1.Tables[0], "TypeOfContractValue");
                    //assetRegisterLovs.TypeOfService = dbAccessDAL.GetLovRecords(ds1.Tables[0], "TypeOfService");
                    //assetRegisterLovs.Work_Group = dbAccessDAL.GetLovRecords(ds1.Tables[0], "Work_Group");
                    assetRegisterLovs.Asset_Category = dbAccessDAL.GetLovRecords(ds1.Tables[0], "AssetCategory");
                    assetRegisterLovs.WorkGroup = dbAccessDAL.GetLovRecords(ds2.Tables[0]);
                    assetRegisterLovs.BatchNo = dbAccessDAL.GetLovRecords(ds1.Tables[0], "BatchNo");
                }
                assetRegisterLovs.IsAdditionalFieldsExist = IsAdditionalFieldsExist();
                Log4NetLogger.LogExit(_FileName, nameof(Load), Level.Info.ToString());
                return assetRegisterLovs;
            }
            catch (DALException dalex)
            {
                throw new DALException(dalex);
            }
            catch (Exception)
            {
                throw;
            }
        }
        public bool IsAdditionalFieldsExist()
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(IsAdditionalFieldsExist), Level.Info.ToString());
                var isExists = false;

                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_FMAddFieldConfig_Check";
                        cmd.Parameters.AddWithValue("@pCustomerId", _UserSession.CustomerId);
                        cmd.Parameters.AddWithValue("@pScreenNameLovId", (int)ConfigScreenNameValue.AssetRegister);
                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }
                if (ds.Tables.Count != 0 && ds.Tables[0].Rows.Count > 0)
                {
                    isExists = Convert.ToInt32(ds.Tables[0].Rows[0][0]) > 0;
                }
                Log4NetLogger.LogExit(_FileName, nameof(IsAdditionalFieldsExist), Level.Info.ToString());
                return isExists;
            }
            catch (DALException dalex)
            {
                throw new DALException(dalex);
            }
            catch (Exception)
            {
                throw;
            }
        }
        public AssetRegisterModel Save(AssetRegisterModel assetRegister, out string ErrorMessage)
        {
            AssetRegisterModel MassetRegister = new AssetRegisterModel();
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());
                var tempvar = assetRegister.Authorization;
                ErrorMessage = string.Empty;
                var commonDAL = new CommonDAL();
                //byte[] image = commonDAL.GenerateQRCode(assetRegister.AssetNo);
                var isAddMode = assetRegister.AssetId == 0;

                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                var MdbAccessDAL = new MASTERDBAccessDAL();

                ISessionProvider _sessionProvider = SessionProviderFactory.GetSessionProvider();
                // var Testsession = ((UserDetailsModel)_sessionProvider.Get(nameof(UserDetailsModel)));
                var Testsession = _UserSession.UserDB;

                if (Testsession == 1)
                {
                    assetRegister.ServiceId = 2;
                }
                else
                {
                    if (Testsession == 2)
                    {
                        assetRegister.ServiceId = 1;
                    }
                    else
                    {
                    }
                }

                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_EngAsset_Save";

                        SqlParameter parameter = new SqlParameter();
                        //  @pWorkGroupId = '1'

                        cmd.Parameters.AddWithValue("@pAssetId", assetRegister.AssetId);
                        cmd.Parameters.AddWithValue("@pUserId", _UserSession.UserId);
                        cmd.Parameters.AddWithValue("@pCustomerId", _UserSession.CustomerId);
                        cmd.Parameters.AddWithValue("@pFacilityId", _UserSession.FacilityId);
                        cmd.Parameters.AddWithValue("@pServiceId", assetRegister.ServiceId);
                        cmd.Parameters.AddWithValue("@pAssetNo", assetRegister.AssetNo);
                        cmd.Parameters.AddWithValue("@pTestingandCommissioningDetId", assetRegister.TestingandCommissioningDetId);
                        cmd.Parameters.AddWithValue("@pAssetPreRegistrationNo", assetRegister.AssetPreRegistrationNo);
                        cmd.Parameters.AddWithValue("@pAssetTypeCodeId", assetRegister.AssetTypeCodeId);
                        cmd.Parameters.AddWithValue("@pAssetClassification", assetRegister.AssetClassification);
                        cmd.Parameters.AddWithValue("@pAssetDescription", assetRegister.AssetDescription);
                        cmd.Parameters.AddWithValue("@pCommissioningDate", assetRegister.CommissioningDate);
                        cmd.Parameters.AddWithValue("@pAssetParentId", assetRegister.AssetParentId);
                        cmd.Parameters.AddWithValue("@pServiceStartDate", assetRegister.ServiceStartDate);//
                        cmd.Parameters.AddWithValue("@pEffectiveDate", assetRegister.EffectiveDate);
                        cmd.Parameters.AddWithValue("@pExpectedLifespan", assetRegister.ExpectedLifespan);
                        cmd.Parameters.AddWithValue("@pRealTimeStatusLovId", assetRegister.RealTimeStatusLovId);
                        cmd.Parameters.AddWithValue("@pAssetStatusLovId", assetRegister.AssetStatusLovId);
                        cmd.Parameters.AddWithValue("@pOperatingHours", assetRegister.OperatingHours);
                        cmd.Parameters.AddWithValue("@pUserLocationId", assetRegister.UserLocationId);
                        cmd.Parameters.AddWithValue("@pUserAreaId", assetRegister.UserAreaId);
                        cmd.Parameters.AddWithValue("@pManufacturer", assetRegister.Manufacturer);
                        cmd.Parameters.AddWithValue("@pNamePlateManufacturer ", assetRegister.NamePlateManufacturer);
                        cmd.Parameters.AddWithValue("@pModel", assetRegister.Model);
                        cmd.Parameters.AddWithValue("@pAppliedPartTypeLovId", assetRegister.AppliedPartTypeLovId);
                        cmd.Parameters.AddWithValue("@pEquipmentClassLovId", assetRegister.EquipmentClassLovId);
                        cmd.Parameters.AddWithValue("@pSpecification", assetRegister.Specification);
                        cmd.Parameters.AddWithValue("@pSerialNo", assetRegister.SerialNo);
                        cmd.Parameters.AddWithValue("@pRiskRating", assetRegister.RiskRating);
                        cmd.Parameters.AddWithValue("@pTransferFacilityName", assetRegister.TransferFacilityName);
                        cmd.Parameters.AddWithValue("@pTransferRemarks", assetRegister.TransferRemarks);
                        cmd.Parameters.AddWithValue("@pPreviousAssetNo", assetRegister.PreviousAssetNo);
                        cmd.Parameters.AddWithValue("@pPurchaseOrderNo", assetRegister.PurchaseOrderNo);
                        cmd.Parameters.AddWithValue("@pInstalledLocationId", assetRegister.InstalledLocationId);
                        cmd.Parameters.AddWithValue("@pSoftwareVersion", assetRegister.SoftwareVersion);
                        cmd.Parameters.AddWithValue("@pSoftwareKey", assetRegister.SoftwareKey);
                        cmd.Parameters.AddWithValue("@pOtherTransferDate", assetRegister.OtherTransferDate);
                        cmd.Parameters.AddWithValue("@pMainsFuseRating", assetRegister.MainsFuseRating);
                        cmd.Parameters.AddWithValue("@pTransferMode", assetRegister.TransferMode);
                        cmd.Parameters.AddWithValue("@pMainSupplier", assetRegister.MainSupplier);
                        cmd.Parameters.AddWithValue("@pManufacturingDate", assetRegister.ManufacturingDate);
                        cmd.Parameters.AddWithValue("@pPowerSpecification", assetRegister.PowerSpecification);
                        cmd.Parameters.AddWithValue("@pPowerSpecificationWatt", assetRegister.PowerSpecificationWatt);
                        cmd.Parameters.AddWithValue("@pPowerSpecificationAmpere", assetRegister.PowerSpecificationAmpere);
                        cmd.Parameters.AddWithValue("@pVolt", assetRegister.Volt);
                        cmd.Parameters.AddWithValue("@pPpmPlannerId", assetRegister.PpmPlannerId);
                        cmd.Parameters.AddWithValue("@pRiPlannerId", assetRegister.RiPlannerId);
                        cmd.Parameters.AddWithValue("@pOtherPlannerId", assetRegister.OtherPlannerId);
                        cmd.Parameters.AddWithValue("@pPurchaseCostRM", assetRegister.PurchaseCostRM);
                        cmd.Parameters.AddWithValue("@pPurchaseDate", assetRegister.PurchaseDate);
                        cmd.Parameters.AddWithValue("@pPurchaseCategory", assetRegister.PurchaseCategory);
                        cmd.Parameters.AddWithValue("@pWarrantyDuration", assetRegister.WarrantyDuration);
                        cmd.Parameters.AddWithValue("@pWarrantyStartDate", assetRegister.WarrantyStartDate);
                        cmd.Parameters.AddWithValue("@pWarrantyEndDate", assetRegister.WarrantyEndDate);
                        cmd.Parameters.AddWithValue("@pCumulativePartCost", assetRegister.CumulativePartCost);
                        cmd.Parameters.AddWithValue("@pCumulativeLabourCost", assetRegister.CumulativeLabourCost);
                        cmd.Parameters.AddWithValue("@pCumulativeContractCost", assetRegister.CumulativeContractCost);
                        cmd.Parameters.AddWithValue("@pTimestamp", Convert.FromBase64String(assetRegister.Timestamp));
                        cmd.Parameters.AddWithValue("@pIsLoaner", assetRegister.IsLoaner);
                        cmd.Parameters.AddWithValue("@pTypeOfAsset", assetRegister.TypeOfAsset);
                        cmd.Parameters.AddWithValue("@pRunningHoursCapture", assetRegister.RunningHoursCapture);
                        cmd.Parameters.AddWithValue("@pContractType", assetRegister.ContractType);
                        cmd.Parameters.AddWithValue("@pCompanyStaffId", assetRegister.CompanyStaffId);
                        cmd.Parameters.AddWithValue("@pAsset_Name", assetRegister.Asset_Name);
                        
                        if (Testsession == 2)
                        {
                           
                            cmd.Parameters.AddWithValue("@pChassisNo", assetRegister.ChassisNo);
                            cmd.Parameters.AddWithValue("@pEngineNo", assetRegister.EngineNo);
                            cmd.Parameters.AddWithValue("@pAssetCategory", assetRegister.Asset_Category);
                            //    cmd.Parameters.AddWithValue("@pWorkGroupId", assetRegister.WorkGroup);
                        }
                        else
                        {
                           
                        }
                        //cmd.Parameters.AddWithValue("@pWorkGroup", assetRegister.Work_Group);
                        //cmd.Parameters.AddWithValue("@pWorkGroup", assetRegister.WorkGroup);
                        cmd.Parameters.AddWithValue("@pBatchNo", assetRegister.BatchNo);


                        if (assetRegister.Authorization == 199 || assetRegister.Authorization == 200)
                        {
                            cmd.Parameters.AddWithValue("@pAuthorization", assetRegister.Authorization);
                        }

                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                        //if (ds.Tables.Count != 0 && ds.Tables[0].Rows.Count > 0)
                        //{

                        //    migout = Convert.ToInt32(ds.Tables[0].Rows[0]["MigrationStatus"]);


                        //}
                        //if (migout > 0)
                        //{
                        //}
                        //else
                        //{

                        if (assetRegister.TestingandCommissioningDetId!=null)
                        {


                            DataSet dssub = new DataSet();
                            var da1 = new SqlDataAdapter();
                            cmd.CommandText = "uspFM_Get_Master_CRMID_BY_TestingandCommissioningId";
                            SqlParameter parameters = new SqlParameter();
                            cmd.Parameters.Clear();
                            cmd.Parameters.AddWithValue("@pTestingandCommissioningDetId", assetRegister.TestingandCommissioningDetId);
                            var das = new SqlDataAdapter();
                            das.SelectCommand = cmd;
                            das.Fill(dssub);
                            if (dssub.Tables.Count != 0 && dssub.Tables[0].Rows.Count > 0)
                            {
                                mastercrmID = Convert.ToInt32(dssub.Tables[0].Rows[0]["Master_CRMRequestId"]);
                            }
                        }
                        else
                        {
                        }


                      //  }
                    }
                }
                using (SqlConnection con = new SqlConnection(MdbAccessDAL.ConnectionString))
                {
                    if (migout > 0)
                    {
                    }
                    else
                    {

                        DataSet dsm = new DataSet();
                        using (SqlCommand cmd = new SqlCommand())
                        {
                            cmd.Connection = con;
                            cmd.CommandType = CommandType.StoredProcedure;
                            cmd.CommandText = "uspFM_CRMRequest_to_Close";
                            SqlParameter parameter = new SqlParameter();
                            cmd.Parameters.AddWithValue("@pCRMRequestId", mastercrmID);
                            var da = new SqlDataAdapter();
                            da.SelectCommand = cmd;
                            da.Fill(dsm);
                        }
                        MassetRegister = assetRegister;

                    }


                    if (ds.Tables.Count != 0 && ds.Tables[0].Rows.Count > 0)
                    {
                        assetRegister.AssetId = Convert.ToInt32(ds.Tables[0].Rows[0]["AssetId"]);
                        ErrorMessage = Convert.ToString(ds.Tables[0].Rows[0]["ErrorMessage"]);
                        if (ErrorMessage == string.Empty)
                        {
                            //assetRegister.QRCode = Convert.ToBase64String((byte[])(ds.Tables[0].Rows[0]["QRCode"]));
                            assetRegister.AssetNo = Convert.ToString(ds.Tables[0].Rows[0]["AssetNo"]);
                            assetRegister.Timestamp = Convert.ToBase64String((byte[])(ds.Tables[0].Rows[0]["Timestamp"]));
                            assetRegister.HiddenId = Convert.ToString(ds.Tables[0].Rows[0]["GuId"]);
                        }
                        //if (isAddMode)
                        //{
                        //    byte[] image = commonDAL.GenerateQRCode(assetRegister.AssetNo + " + " + assetRegister.HiddenId.ToUpper());
                        //    UpdateQRCode(assetRegister, image);
                        //}
                    }
                    if (tempvar == 199)
                    {
                        updateNotificationSingle(assetRegister);
                    }
                    else if (tempvar == 200)
                    {
                        updateNotificationSingle(assetRegister);
                        SendMailUnauthorized(assetRegister);
                    }
                    //using (SqlConnection con = new SqlConnection(MdbAccessDAL.ConnectionString))
                    //{
                    //    using (SqlCommand cmd = new SqlCommand())
                    //    {
                    //        cmd.Connection = con;
                    //        cmd.CommandType = CommandType.StoredProcedure;
                    //        cmd.CommandText = "uspFM_EngAsset_Save";
                    //        SqlParameter parameter = new SqlParameter();
                    //        cmd.Parameters.AddWithValue("@pAssetId", MassetRegister.AssetId);
                    //        cmd.Parameters.AddWithValue("@pUserId", _UserSession.UserId);
                    //        cmd.Parameters.AddWithValue("@pCustomerId", _UserSession.CustomerId);
                    //        cmd.Parameters.AddWithValue("@pFacilityId", _UserSession.FacilityId);
                    //        cmd.Parameters.AddWithValue("@pServiceId", MassetRegister.ServiceId);
                    //        cmd.Parameters.AddWithValue("@pTestingandCommissioningDetId", MassetRegister.TestingandCommissioningDetId);
                    //        cmd.Parameters.AddWithValue("@pAssetPreRegistrationNo", MassetRegister.AssetPreRegistrationNo);
                    //        cmd.Parameters.AddWithValue("@pAssetTypeCodeId", MassetRegister.AssetTypeCodeId);
                    //        cmd.Parameters.AddWithValue("@pAssetClassification", MassetRegister.AssetClassification);
                    //        cmd.Parameters.AddWithValue("@pAssetDescription", MassetRegister.AssetDescription);
                    //        cmd.Parameters.AddWithValue("@pCommissioningDate", MassetRegister.CommissioningDate);
                    //        cmd.Parameters.AddWithValue("@pAssetParentId", MassetRegister.AssetParentId);
                    //        cmd.Parameters.AddWithValue("@pServiceStartDate", MassetRegister.ServiceStartDate);//
                    //        cmd.Parameters.AddWithValue("@pEffectiveDate", MassetRegister.EffectiveDate);
                    //        cmd.Parameters.AddWithValue("@pExpectedLifespan", MassetRegister.ExpectedLifespan);
                    //        cmd.Parameters.AddWithValue("@pRealTimeStatusLovId", MassetRegister.RealTimeStatusLovId);
                    //        cmd.Parameters.AddWithValue("@pAssetStatusLovId", MassetRegister.AssetStatusLovId);
                    //        cmd.Parameters.AddWithValue("@pOperatingHours", MassetRegister.OperatingHours);
                    //        cmd.Parameters.AddWithValue("@pUserLocationId", MassetRegister.UserLocationId);
                    //        cmd.Parameters.AddWithValue("@pUserAreaId", MassetRegister.UserAreaId);
                    //        cmd.Parameters.AddWithValue("@pManufacturer", MassetRegister.Manufacturer);
                    //        cmd.Parameters.AddWithValue("@pNamePlateManufacturer ", MassetRegister.NamePlateManufacturer);
                    //        cmd.Parameters.AddWithValue("@pModel", MassetRegister.Model);
                    //        cmd.Parameters.AddWithValue("@pAppliedPartTypeLovId", MassetRegister.AppliedPartTypeLovId);
                    //        cmd.Parameters.AddWithValue("@pEquipmentClassLovId", MassetRegister.EquipmentClassLovId);
                    //        cmd.Parameters.AddWithValue("@pSpecification", MassetRegister.Specification);
                    //        cmd.Parameters.AddWithValue("@pSerialNo", MassetRegister.SerialNo);
                    //        cmd.Parameters.AddWithValue("@pRiskRating", MassetRegister.RiskRating);
                    //        cmd.Parameters.AddWithValue("@pTransferFacilityName", MassetRegister.TransferFacilityName);
                    //        cmd.Parameters.AddWithValue("@pTransferRemarks", MassetRegister.TransferRemarks);
                    //        cmd.Parameters.AddWithValue("@pPreviousAssetNo", MassetRegister.PreviousAssetNo);
                    //        cmd.Parameters.AddWithValue("@pPurchaseOrderNo", MassetRegister.PurchaseOrderNo);
                    //        cmd.Parameters.AddWithValue("@pInstalledLocationId", MassetRegister.InstalledLocationId);
                    //        cmd.Parameters.AddWithValue("@pSoftwareVersion", MassetRegister.SoftwareVersion);
                    //        cmd.Parameters.AddWithValue("@pSoftwareKey", MassetRegister.SoftwareKey);
                    //        cmd.Parameters.AddWithValue("@pOtherTransferDate", MassetRegister.OtherTransferDate);
                    //        cmd.Parameters.AddWithValue("@pMainsFuseRating", MassetRegister.MainsFuseRating);
                    //        cmd.Parameters.AddWithValue("@pTransferMode", MassetRegister.TransferMode);
                    //        cmd.Parameters.AddWithValue("@pMainSupplier", MassetRegister.MainSupplier);
                    //        cmd.Parameters.AddWithValue("@pManufacturingDate", MassetRegister.ManufacturingDate);
                    //        cmd.Parameters.AddWithValue("@pPowerSpecification", MassetRegister.PowerSpecification);
                    //        cmd.Parameters.AddWithValue("@pPowerSpecificationWatt", MassetRegister.PowerSpecificationWatt);
                    //        cmd.Parameters.AddWithValue("@pPowerSpecificationAmpere", MassetRegister.PowerSpecificationAmpere);
                    //        cmd.Parameters.AddWithValue("@pVolt", MassetRegister.Volt);
                    //        cmd.Parameters.AddWithValue("@pPpmPlannerId", MassetRegister.PpmPlannerId);
                    //        cmd.Parameters.AddWithValue("@pRiPlannerId", MassetRegister.RiPlannerId);
                    //        cmd.Parameters.AddWithValue("@pOtherPlannerId", MassetRegister.OtherPlannerId);
                    //        cmd.Parameters.AddWithValue("@pPurchaseCostRM", MassetRegister.PurchaseCostRM);
                    //        cmd.Parameters.AddWithValue("@pPurchaseDate", MassetRegister.PurchaseDate);
                    //        cmd.Parameters.AddWithValue("@pPurchaseCategory", MassetRegister.PurchaseCategory);
                    //        cmd.Parameters.AddWithValue("@pWarrantyDuration", MassetRegister.WarrantyDuration);
                    //        cmd.Parameters.AddWithValue("@pWarrantyStartDate", MassetRegister.WarrantyStartDate);
                    //        cmd.Parameters.AddWithValue("@pWarrantyEndDate", MassetRegister.WarrantyEndDate);
                    //        cmd.Parameters.AddWithValue("@pCumulativePartCost", MassetRegister.CumulativePartCost);
                    //        cmd.Parameters.AddWithValue("@pCumulativeLabourCost", MassetRegister.CumulativeLabourCost);
                    //        cmd.Parameters.AddWithValue("@pCumulativeContractCost", MassetRegister.CumulativeContractCost);
                    //        cmd.Parameters.AddWithValue("@pTimestamp", Convert.FromBase64String(MassetRegister.Timestamp));
                    //        cmd.Parameters.AddWithValue("@pIsLoaner", MassetRegister.IsLoaner);
                    //        cmd.Parameters.AddWithValue("@pTypeOfAsset", MassetRegister.TypeOfAsset);
                    //        cmd.Parameters.AddWithValue("@pRunningHoursCapture", MassetRegister.RunningHoursCapture);
                    //        cmd.Parameters.AddWithValue("@pContractType", MassetRegister.ContractType);
                    //        cmd.Parameters.AddWithValue("@pCompanyStaffId", MassetRegister.CompanyStaffId);
                    //        if (Testsession == 2)
                    //        {
                    //            //cmd.Parameters.AddWithValue("@pAssetCategory", MassetRegister.Asset_Category);
                    //            //cmd.Parameters.AddWithValue("@pChassisNo", MassetRegister.ChassisNo);
                    //            //cmd.Parameters.AddWithValue("@pEngineNo", MassetRegister.EngineNo);
                    //        }
                    //        else
                    //        {

                    //        }
                    //        //cmd.Parameters.AddWithValue("@pWorkGroup", MassetRegister.Work_Group);
                    //        cmd.Parameters.AddWithValue("@pWorkGroup", MassetRegister.WorkGroup);
                    //        cmd.Parameters.AddWithValue("@pBatchNo", MassetRegister.BatchNo);


                    //        if (MassetRegister.Authorization == 199 || MassetRegister.Authorization == 200)
                    //        {
                    //            cmd.Parameters.AddWithValue("@pAuthorization", MassetRegister.Authorization);
                    //        }

                    //        var da = new SqlDataAdapter();
                    //        da.SelectCommand = cmd;
                    //        da.Fill(ds);
                    //    }
                    //}
                    Log4NetLogger.LogExit(_FileName, nameof(Save), Level.Info.ToString());
                    return assetRegister;
                }
            }
            catch (DALException dalex)
            {
                throw new DALException(dalex);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        public AssetRegisterUploadModel SaveUpload(AssetRegisterUploadModel assetRegister, out string ErrorMessage)
        {

            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(SaveUpload), Level.Info.ToString());
                ErrorMessage = string.Empty;
                var RequestStatus = 140;
                var TypeOfRequest = 375;  
                var dbAccessDAL = new DBAccessDAL();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pCRMRequestId", Convert.ToString(assetRegister.CRMRequestId));
                parameters.Add("@pUserId", Convert.ToString(_UserSession.UserId));
                parameters.Add("@CustomerId", Convert.ToString(_UserSession.CustomerId));
                parameters.Add("@FacilityId", Convert.ToString(_UserSession.FacilityId));
                parameters.Add("@ServiceId", Convert.ToString(2));
                parameters.Add("@RequestNo", Convert.ToString(assetRegister.RequestNo));
                parameters.Add("@RequestDescription", Convert.ToString(assetRegister.RequestDescription));
                parameters.Add("@RequestStatus", Convert.ToString(RequestStatus));
                parameters.Add("@TypeOfRequest", Convert.ToString(TypeOfRequest));
                parameters.Add("@Remarks", Convert.ToString(assetRegister.Remarks));
                parameters.Add("@pModelId", Convert.ToString(assetRegister.Model));
                parameters.Add("@pManufacturerid", Convert.ToString(assetRegister.Manufacturer));
                parameters.Add("@pUserAreaId", Convert.ToString(assetRegister.UserAreaId));
                parameters.Add("@pUserLocationId", Convert.ToString(assetRegister.UserLocationId));
                parameters.Add("@pTargetDate", Convert.ToString(assetRegister.TargetDate == null || assetRegister.TargetDate == DateTime.MinValue ? null : assetRegister.TargetDate.Value.ToString("MM-dd-yyy")));
                parameters.Add("@pRequestedPerson", Convert.ToString(assetRegister.RequestorId));
                parameters.Add("@pFlag", Convert.ToString(assetRegister.AccessFlag));
                parameters.Add("@pRequester", Convert.ToString(assetRegister.RequestorId));
                parameters.Add("@pAssigneeId", Convert.ToString(assetRegister.AssigneeId));

                // T and C 
                parameters.Add("@pTestingandCommissioningId", Convert.ToString(assetRegister.TestingandCommissioningId));                
                parameters.Add("@pTandCDate", Convert.ToString(assetRegister.TandCDate == null || assetRegister.TandCDate == DateTime.MinValue ? null : assetRegister.TandCDate.Value.ToString("MM-dd-yyy")));
                parameters.Add("@pAssetTypeCodeId", Convert.ToString(assetRegister.AssetTypeCodeId));
                parameters.Add("@pTandCCompletedDate", Convert.ToString(assetRegister.TandCCompletedDate == null || assetRegister.TandCCompletedDate == DateTime.MinValue ? null : assetRegister.TandCCompletedDate.Value.ToString("MM-dd-yyy")));
                parameters.Add("@pHandoverDate", Convert.ToString(assetRegister.HandOverDate == null || assetRegister.HandOverDate == DateTime.MinValue ? null : assetRegister.HandOverDate.Value.ToString("MM-dd-yyy")));
                parameters.Add("@pVariationStatus", Convert.ToString(assetRegister.VariationStatusId));
                parameters.Add("@pTandCContractorRepresentative", Convert.ToString(""));
                parameters.Add("@pFmsCustomerRepresentativeId", Convert.ToString(assetRegister.CompanyRepresentativeId));
                parameters.Add("@pFmsFacilityRepresentativeId", Convert.ToString(assetRegister.FacilityRepresentativeId));
                parameters.Add("@pTandCStatus", Convert.ToString(71));  // passed 
                parameters.Add("@pAssetNoOld", Convert.ToString(""));
                parameters.Add("@pAssetCategoryLovId", Convert.ToString(73)); // Asset
                parameters.Add("@pSerialNo", Convert.ToString(assetRegister.SerialNo));
                parameters.Add("@pPurchaseCost", Convert.ToString(assetRegister.PurchaseCostRM));
                parameters.Add("@pPurchaseOrderNo", Convert.ToString(assetRegister.PurchaseOrderNo));
                parameters.Add("@pPurchaseDate", Convert.ToString(assetRegister.PurchaseDate == null || assetRegister.PurchaseDate == DateTime.MinValue ? null : assetRegister.PurchaseDate.Value.ToString("MM-dd-yyy")));
                parameters.Add("@pServiceStartDate", Convert.ToString(assetRegister.ServiceStartDate == null || assetRegister.ServiceStartDate == DateTime.MinValue ? null : assetRegister.ServiceStartDate.Value.ToString("MM-dd-yyy")));              
                parameters.Add("@pApprovalRemarks", Convert.ToString(assetRegister.WarrantyRemarks));
                parameters.Add("@pWarrantyStartDate", Convert.ToString(assetRegister.WarrantyStartDate == null || assetRegister.WarrantyStartDate == DateTime.MinValue ? null : assetRegister.WarrantyStartDate.Value.ToString("MM-dd-yyy")));
                parameters.Add("@pWarrantyEndDate", Convert.ToString(assetRegister.WarrantyEndDate == null || assetRegister.WarrantyEndDate == DateTime.MinValue ? null : assetRegister.WarrantyEndDate.Value.ToString("MM-dd-yyy")));
                parameters.Add("@pWarrantyDuration", Convert.ToString(assetRegister.WarrantyDuration));
                parameters.Add("@pContractorId", Convert.ToString(assetRegister.ContractorId));
                parameters.Add("@pTandCRemarks", Convert.ToString(assetRegister.TandCRemarks));             

                // Asset register 
                parameters.Add("@pAssetId", Convert.ToString(assetRegister.AssetId));
                parameters.Add("@pAssetNo", Convert.ToString(assetRegister.AssetNo));
                parameters.Add("@pAssetClassification", Convert.ToString(assetRegister.AssetClassification));
                parameters.Add("@pAssetDescription", Convert.ToString(assetRegister.AssetDescription));
                parameters.Add("@pCommissioningDate", Convert.ToString(assetRegister.WarrantyEndDate == null || assetRegister.WarrantyEndDate == DateTime.MinValue ? null : assetRegister.WarrantyEndDate.Value.ToString("MM-dd-yyy")));
                parameters.Add("@pEffectiveDate", Convert.ToString(assetRegister.EffectiveDate == null || assetRegister.EffectiveDate == DateTime.MinValue ? null : assetRegister.EffectiveDate.Value.ToString("MM-dd-yyy")));
                parameters.Add("@pExpectedLifespan", Convert.ToString(assetRegister.ExpectedLifespan));
                parameters.Add("@pRealTimeStatusLovId", Convert.ToString(assetRegister.RealTimeStatusLovId));
                parameters.Add("@pAssetStatusLovId", Convert.ToString(assetRegister.AssetStatusLovId));
                parameters.Add("@pMainSupplier",Convert.ToString( assetRegister.VendorName));             
                parameters.Add("@pPurchaseCategory", Convert.ToString(assetRegister.PurchaseCategory));              
                parameters.Add("@pCumulativePartCost", Convert.ToString(assetRegister.CumulativePartCost));              
                parameters.Add("@pContractType",Convert.ToString( assetRegister.ContractType));
                parameters.Add("@pCompanyStaffId", Convert.ToString(assetRegister.CompanyStaffId));

                var dec = new Dictionary<string, DataTable>();

                DataTable ds = dbAccessDAL.GetDataTable("uspFM_AssetRegisterUpload_Save", parameters, dec);
                if (ds != null)
                {
                    foreach (DataRow row in ds.Rows)
                    {
                        var CRMRequestId = Convert.ToInt32(row["CRMRequestId"]);
                        var TestingandCommissioningDetId = Convert.ToInt32(row["TestingandCommissioningDetId"]);                     
                    }
                }
                
                Log4NetLogger.LogEntry(_FileName, nameof(SaveUpload), Level.Info.ToString());
                return assetRegister;
            }
            catch (DALException dalex)
            {
                throw new DALException(dalex);
            }
            catch (Exception e)
            {
                throw;
            }
        }
        public void UpdateQRCode(AssetRegisterModel AssetRegister, byte[] QRCodeImage)
        {
            var ds = new DataSet();
            var dbAccessDAL = new DBAccessDAL();
            using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = con;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "uspFM_EngAssetQR_Update";
                    cmd.Parameters.AddWithValue("@pAssetId", AssetRegister.AssetId);
                    cmd.Parameters.AddWithValue("@pQRCode", QRCodeImage);

                    var da = new SqlDataAdapter();
                    da.SelectCommand = cmd;
                    da.Fill(ds);

                    if (ds.Tables.Count != 0 && ds.Tables[0].Rows.Count > 0)
                    {
                        AssetRegister.Timestamp = Convert.ToBase64String((byte[])(ds.Tables[0].Rows[0]["Timestamp"]));
                    }
                }
            }
        }

        public AssetRegisterModel updateNotificationSingle(AssetRegisterModel ent)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());
            AssetRegisterModel griddata = new AssetRegisterModel();
            var notalert = string.Empty;
            var dbAccessDAL = new DBAccessDAL();
            var parameters = new Dictionary<string, string>();
            var DataSetparameters = new Dictionary<string, DataTable>();
            if (ent.Authorization == 199)
            {
                notalert = ent.AssetNo + " " + "Asset has been authorized";
            }
            else
            {
                notalert = ent.AssetNo + " " + "Asset has been Unauthorized";
            }
            var hyplink = "/bems/assetregister/get/" + ent.AssetId;

            parameters.Add("@pNotificationId", Convert.ToString(ent.NotificationId));
            parameters.Add("@pCustomerId", Convert.ToString(_UserSession.CustomerId));
            parameters.Add("@pFacilityId", Convert.ToString(_UserSession.FacilityId));
            parameters.Add("@pUserId", Convert.ToString(_UserSession.UserId));
            parameters.Add("@pNotificationAlerts", Convert.ToString(notalert));
            parameters.Add("@pRemarks", Convert.ToString(""));
            parameters.Add("@pHyperLink", Convert.ToString(hyplink));
            parameters.Add("@pIsNew", Convert.ToString(1));
            parameters.Add("@pNotificationDateTime", Convert.ToString(null));
            if (ent.Authorization == 199)
            {
                parameters.Add("@pEmailTempId", Convert.ToString(79));
            }
            else
            {
                parameters.Add("@pEmailTempId", Convert.ToString(56));
            }
            //parameters.Add("@pmScreenName", Convert.ToString("CRMRequestStatus"));
            //parameters.Add("@pMGuid", Convert.ToString(ent.HiddenId));


            DataTable ds = dbAccessDAL.GetDataTable("uspFM_WebNotificationSingle_Save", parameters, DataSetparameters);
            if (ds != null)
            {
                foreach (DataRow row in ds.Rows)
                {
                    //model.CRMRequestId = Convert.ToInt32(row["CRMRequestId"]);
                    //model.Timestamp = Convert.ToBase64String((byte[])(row["Timestamp"]));
                    //// model.err = Convert.ToBase64String((byte[])(row["Timestamp"]));
                    //model.HiddenId = Convert.ToString(row["GuId"]);
                }
            }

            return ent;
        }
        public GridFilterResult GetAll(SortPaginateFilter pageFilter)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(GetAll), Level.Info.ToString());
                GridFilterResult filterResult = null;

                var multipleOrderBy = pageFilter.SortColumn.Split(',');
                var strOrderBy = string.Empty;
                foreach (var order in multipleOrderBy)
                {
                    strOrderBy += order + " " + pageFilter.SortOrder + ",";
                }
                if (!string.IsNullOrEmpty(strOrderBy))
                {
                    strOrderBy = strOrderBy.TrimEnd(',');
                }

                strOrderBy = string.IsNullOrEmpty(strOrderBy) ? pageFilter.SortColumn + " " + pageFilter.SortOrder : strOrderBy;

                var QueryCondition = pageFilter.QueryWhereCondition;
                var strCondition = string.Empty;
                if (string.IsNullOrEmpty(QueryCondition))
                {
                    strCondition = "FacilityId = " + _UserSession.FacilityId.ToString();
                }
                else
                {
                    strCondition = QueryCondition + "AND FacilityId = " + _UserSession.FacilityId.ToString();
                }

                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_EngAsset_GetAll";

                        cmd.Parameters.AddWithValue("@PageIndex", pageFilter.PageIndex);
                        cmd.Parameters.AddWithValue("@PageSize", pageFilter.PageSize);
                        cmd.Parameters.AddWithValue("@strCondition", strCondition);
                        cmd.Parameters.AddWithValue("@strSorting", strOrderBy);
                        cmd.Parameters.AddWithValue("@pUserId", _UserSession.UserId);
                        cmd.Parameters.AddWithValue("@pAccessLevel", _UserSession.AccessLevel);
                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }
                if (ds.Tables.Count != 0 && ds.Tables[0].Rows.Count > 0)
                {
                    var totalRecords = Convert.ToInt32(ds.Tables[0].Rows[0]["TotalRecords"]);
                    var totalPages = (int)Math.Ceiling((float)totalRecords / (float)pageFilter.Rows);

                    var commonDAL = new CommonDAL();
                    var currentPageList = commonDAL.ToDynamicList(ds.Tables[0]);
                    filterResult = new GridFilterResult
                    {
                        TotalRecords = totalRecords,
                        TotalPages = totalPages,
                        RecordsList = currentPageList,
                        CurrentPage = pageFilter.Page
                    };
                }
                Log4NetLogger.LogExit(_FileName, nameof(GetAll), Level.Info.ToString());
                return filterResult;
            }
            catch (DALException dalex)
            {
                throw new DALException(dalex);
            }
            catch (Exception)
            {
                throw;
            }
        }
        public AssetRegisterModel Get(int Id)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
                AssetRegisterModel assetRegister = null;

                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "UspFM_EngAsset_GetById";
                        cmd.Parameters.AddWithValue("@pAssetId", Id);
                        //cmd.Parameters.AddWithValue("@pWorkGroup", Work_Group);
                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }
                var Testsession = _UserSession.UserDB;

                if (ds.Tables.Count != 0 && ds.Tables[0].Rows.Count > 0)
                {
                    assetRegister = (from n in ds.Tables[0].AsEnumerable()
                                     select new AssetRegisterModel
                                     {
                                      //   ServiceId= Convert.ToInt32((n["ServiceId"])),
                                         AssetId = Id,
                                         CustomerId = Convert.ToInt32((n["CustomerId"])),
                                         FacilityId = Convert.ToInt32((n["FacilityId"])),
                                         AssetNo = Convert.ToString((n["AssetNo"])),
                                         TestingandCommissioningDetId = n.Field<int?>("TestingandCommissioningDetId"),
                                         TypeOfAsset = n.Field<int?>("TypeOfAsset"),
                                         AssetPreRegistrationNo = Convert.ToString((n["AssetPreRegistrationNo"])),
                                         AssetTypeCodeId = Convert.ToInt32((n["AssetTypeCodeId"])),
                                         AssetTypeCode = Convert.ToString((n["AssetTypeCode"])),
                                         AssetTypeDescription = n.Field<string>("AssetTypeDescription"),
                                         AssetClassification = n.Field<int?>("AssetClassification"),
                                         AssetDescription = Convert.ToString((n["AssetDescription"])),

                                         CommissioningDate = Convert.ToDateTime((n["CommissioningDate"])),
                                         AssetParentId = n.Field<int?>("AssetParentId"),
                                         ParentAssetNo = n.Field<string>("ParentAssetNo"),
                                         ServiceStartDate = Convert.ToDateTime((n["ServiceStartDate"])),
                                         EffectiveDate = n["EffectiveDate"] == DBNull.Value ? DateTime.MinValue : Convert.ToDateTime((n["EffectiveDate"])),
                                         ExpectedLifespan = n.Field<int?>("ExpectedLifespan"),
                                         RealTimeStatusLovId = n.Field<int?>("RealTimeStatusLovId"),
                                         AssetStatusLovId = n.Field<int?>("AssetStatusLovId"),
                                         AssetAge = n.Field<decimal?>("AssetAge"),
                                         YearsInService = n.Field<decimal?>("YearsInService"),
                                         OperatingHours = n.Field<decimal?>("OperatingHours"),

                                         TransferUserLocation = n.Field<string>("TransferUserLocation"),
                                         TransferDate = n.Field<DateTime?>("TransferDate"),
                                         OtherTransferDate = n.Field<DateTime?>("OtherTransferDate"),
                                         OtherFacilityId = n.Field<int?>("OtherFacilityId"),
                                         OtherSpecify = n.Field<string>("OtherSpecify"),
                                         OtherPreviousAssetNo = n.Field<string>("OtherPreviousAssetNo"),

                                         UserLocationId = Convert.ToInt32((n["UserLocationId"])),
                                         UserLocationCode = Convert.ToString(n["UserLocationCode"]),
                                         UserLocationName = n.Field<string>("UserLocationName"),
                                         CurrentAreaCode = n.Field<string>("CurrentAreaCode"),
                                         CurrentAreaName = n.Field<string>("CurrentAreaName"),
                                         UserAreaCode = n.Field<string>("UserAreaCode"),
                                         UserAreaName = n.Field<string>("UserAreaName"),
                                         UserAreaId = n.Field<int>("UserAreaId"),

                                         Manufacturer = Convert.ToInt32((n["Manufacturer"])),
                                         ManufacturerName = Convert.ToString(n["ManufacturerName"]),
                                         NamePlateManufacturer = Convert.ToString(n["NamePlateManufacturer"]),
                                         Model = Convert.ToInt32((n["Model"])),
                                         ModelName = Convert.ToString(n["ModelName"]),
                                         AppliedPartTypeLovId = Convert.ToInt32((n["AppliedPartTypeLovId"])),
                                         EquipmentClassLovId = n.Field<int?>("EquipmentClassLovId"),
                                         Specification = n.Field<int?>("Specification"),
                                         SerialNo = Convert.ToString((n["SerialNo"])),
                                         MainSupplier = Convert.ToString((n["MainSupplier"])),
                                         ManufacturingDate = n["ManufacturingDate"] == DBNull.Value ? DateTime.MinValue : Convert.ToDateTime((n["ManufacturingDate"])),
                                         PowerSpecification = n.Field<int?>("PowerSpecification"),
                                         PowerSpecificationWatt = n.Field<decimal?>("PowerSpecificationWatt"),
                                         PowerSpecificationAmpere = n.Field<decimal?>("PowerSpecificationAmpere"),
                                         Volt = n.Field<decimal?>("Volt"),

                                         PpmPlannerId = Convert.ToInt32((n["PpmPlannerId"])),
                                         RiPlannerId = Convert.ToInt32((n["RiPlannerId"])),
                                         OtherPlannerId = Convert.ToInt32((n["OtherPlannerId"])),
                                         LastSchduledWorkOrderNo = n.Field<string>("LastSchduledWorkOrderNo"),
                                         LastSchduledWorkOrderDateTime = n.Field<DateTime?>("LastSchduledWorkOrderDateTime"),

                                         //SchduledTotDowntimeHoursMinYTD = n.Field<decimal?>("SchduledTotDowntimeHoursMinYTD"),
                                         SchduledTotDowntimeHoursMinYTD = n.Field<decimal?>("UnSchduledTotDowntimeHoursMinYTD"),
                                         LastUnSchduledWorkOrderNo = n.Field<string>("LastUnSchduledWorkOrderNo"),
                                         LastUnSchduledWorkOrderDateTime = n.Field<DateTime?>("LastUnSchduledWorkOrderDateTime"),
                                         DefectList = n.Field<int?>("DefectList"),

                                         PurchaseCostRM = n.Field<decimal?>("PurchaseCostRM"),
                                         PurchaseDate = n["PurchaseDate"] == DBNull.Value ? DateTime.MinValue : Convert.ToDateTime((n["PurchaseDate"])),
                                         PurchaseCategory = n.Field<int?>("PurchaseCategory"),
                                         WarrantyDuration = n.Field<decimal?>("WarrantyDuration"),
                                         WarrantyStartDate = n["WarrantyStartDate"] == DBNull.Value ? DateTime.MinValue : Convert.ToDateTime((n["WarrantyStartDate"])),
                                         WarrantyEndDate = n["WarrantyEndDate"] == DBNull.Value ? DateTime.MinValue : Convert.ToDateTime((n["WarrantyEndDate"])),
                                         CumulativePartCost = n.Field<decimal?>("CumulativePartCost"),
                                         CumulativeLabourCost = n.Field<decimal?>("CumulativeLabourCost"),
                                         CumulativeContractCost = n.Field<decimal?>("CumulativeContractCost"),

                                         RiskRating = n.Field<int?>("RiskRating"),
                                         TransferFacilityName = n.Field<string>("TransferFacilityName"),
                                         TransferRemarks = n.Field<string>("TransferRemarks"),
                                         PreviousAssetNo = n.Field<string>("PreviousAssetNo"),
                                         PurchaseOrderNo = n.Field<string>("PurchaseOrderNo"),
                                         InstalledLocationName = n.Field<string>("InstalledLocationName"),
                                         InstalledLocationCode = n.Field<string>("InstalledLocationCode"),
                                         SoftwareVersion = n.Field<string>("SoftwareVersion"),
                                         SoftwareKey = n.Field<string>("SoftwareKey"),
                                         LevelName = n.Field<string>("LevelName"),
                                         LevelCode = n.Field<string>("LevelCode"),
                                         BlockName = n.Field<string>("BlockName"),
                                         BlockCode = n.Field<string>("BlockCode"),
                                         TransferMode = n.Field<int?>("TransferMode"),
                                         MainsFuseRating = n.Field<decimal?>("MainsFuseRating"),
                                         CalculatedFeeDW = n.Field<decimal?>("CalculatedFeeDW"),
                                         CalculatedFeePW = n.Field<decimal?>("CalculatedFeePW"),
                                         TotalWarrantyDownTime = n.Field<decimal?>("TotalWarrantyDownTime"),
                                         AuthorizationName = n.Field<string>("AuthorizationName"),
                                         AssetWorkingStatusValue = n.Field<string>("AssetWorkingStatusValue"),
                                         QRCode = n["QRCode"] == DBNull.Value ? "" : Convert.ToBase64String((byte[])n["QRCode"]),
                                         Timestamp = Convert.ToBase64String((byte[])(n["Timestamp"])),
                                         HiddenId = Convert.ToString((n["GuId"])),
                                         RunningHoursCapture = n.Field<int?>("RunningHoursCapture"),
                                         ContractType = n.Field<int?>("ContractType"),
                                         CompanyStaffId = n.Field<int?>("CompanyStaffId"),
                                         CompanyStaffName = n.Field<string>("StaffName"),
                                         Asset_Name = n.Field<string>("Asset_Name"),
                                         Item_Code = n.Field<string>("Item_Code"),
                                         Item_Description = n.Field<string>("Item_Description"),
                                         Package_Code = n.Field<string>("Package_Code"),
                                         Package_Description = n.Field<string>("Package_Description"),
                                         Asset_Category = Convert.ToInt32((n["Asset_Category"]) != DBNull.Value ? (Convert.ToInt32(n["Asset_Category"])) : (int?)null),
                                         InstalledLocationId = Convert.ToInt32(n["InstallUserLocationId"]),
                                         //  Work_Group = n.Field<string>("Work_Group"),
                                         //   WorkGroup = n.Field<string>("WorkGroup"),
                                         BatchNo = Convert.ToInt32((n["BatchNo"]))
                                     }).FirstOrDefault();

                    if (Testsession == 1)
                    {
                        assetRegister.ServiceId = 2;
                    }
                    else
                    {
                        if (Testsession == 2)
                        {
                            assetRegister.ServiceId = 1;
                        }
                        else
                        {
                        }
                    }

                    if (assetRegister.ServiceId==1)
                    {
                        assetRegister.ChassisNo = Convert.ToString(ds.Tables[0].Rows[0]["ChassisNo"]);
                        assetRegister.EngineNo = Convert.ToString(ds.Tables[0].Rows[0]["EngineNo"]);
                    }
                    else
                    {
                    }
                    assetRegister.RunningHoursCapture = assetRegister.RunningHoursCapture == null || assetRegister.RunningHoursCapture == 0 ?
                        (int)YesNo.No : assetRegister.RunningHoursCapture;

                    if (assetRegister.EffectiveDate == DateTime.MinValue) assetRegister.EffectiveDate = null;
                    if (assetRegister.ManufacturingDate == DateTime.MinValue) assetRegister.ManufacturingDate = null;
                    if (assetRegister.PurchaseDate == DateTime.MinValue) assetRegister.PurchaseDate = null;
                    if (assetRegister.WarrantyStartDate == DateTime.MinValue) assetRegister.WarrantyStartDate = null;
                    if (assetRegister.WarrantyEndDate == DateTime.MinValue) assetRegister.WarrantyEndDate = null;

                    if (ds.Tables[1].Rows.Count > 0)
                    {
                        assetRegister.AssetSpecifications = (from n in ds.Tables[1].AsEnumerable()
                                                             select new LovValue
                                                             {
                                                                 LovId = n.Field<int>("AssetTypeCodeAddSpecId"),
                                                                 FieldValue = n.Field<string>("SpecificationTypeName")
                                                             }).ToList();
                    }
                }
                    Log4NetLogger.LogExit(_FileName, nameof(Get), Level.Info.ToString());
                return assetRegister;
            }
            catch (DALException dalex)
            {
                throw new DALException(dalex);
            }
            catch (Exception e)
            {
                throw;
            }
        }
        public AssetPreRegistrationNoSearch GetTestingAndCommissioningDetails(int Id, out string ErrorMessage)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(GetTestingAndCommissioningDetails), Level.Info.ToString());
                AssetPreRegistrationNoSearch result = null;

                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_TandCConvertToAsset_GetById";
                        cmd.Parameters.AddWithValue("@pTestingandCommissioningId", Id);
                        cmd.Parameters.Add("@pErrorMessage", SqlDbType.NVarChar);
                        cmd.Parameters["@pErrorMessage"].Size = 1000;
                        cmd.Parameters["@pErrorMessage"].Direction = ParameterDirection.Output;
                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);

                        ErrorMessage = cmd.Parameters["@pErrorMessage"].Value.ToString();
                    }
                }
                if (ds.Tables.Count != 0 && ds.Tables[0].Rows.Count > 0)
                {
                    result = (from n in ds.Tables[0].AsEnumerable()
                              select new AssetPreRegistrationNoSearch
                              {
                                  TestingandCommissioningDetId = Convert.ToInt32(n["TestingandCommissioningDetId"]),
                                  AssetPreRegistrationNo = Convert.ToString(n["AssetPreRegistrationNo"]),
                                  TandCDate = Convert.ToDateTime(n["TandCDate"]),
                                  ServiceStartDate = n.Field<DateTime?>("ServiceStartDate"),
                                  PurchaseDate = n.Field<DateTime?>("PurchaseDate"),
                                  PurchaseCost = n.Field<decimal?>("PurchaseCost"),
                                  WarrantyStartDate = n.Field<DateTime?>("WarrantyStartDate"),
                                  WarrantyEndDate = n.Field<DateTime?>("WarrantyEndDate"),
                                  WarrantyDuration = n.Field<int?>("WarrantyDuration"),
                                  AssetClassificationId = n.Field<int>("AssetClassificationId"),
                                  AssetAge = n.Field<decimal?>("AssetAge"),
                                  YearsInService = n.Field<decimal?>("YearsInService"),
                                  PurchaseOrderNo = n.Field<string>("PurchaseOrderNo"),
                                  AssetTypeCodeId = n.Field<int>("AssetTypeCodeId"),
                                  AssetTypeCode = n.Field<string>("AssetTypeCode"),
                                  AssetTypeDescription = n.Field<string>("AssetTypeDescription"),
                                 // AssetNo = n.Field<string>("AssetNo"),
                                  Model = n.Field<int>("Model"),
                                  ModelName = n.Field<string>("ModelName"),
                                  Manufacturer = n.Field<int>("Manufacturer"),
                                  ManufacturerName = n.Field<string>("ManufacturerName"),

                                  AssetCategoryLovId = n.Field<int?>("AssetCategoryLovId"),
                                  SerialNo = n.Field<string>("SerialNo"),
                                  InstalledLocationCodeId = n.Field<int?>("InstalledLocationCodeId"),
                                  InstalledLocationName = n.Field<string>("InstalledLocationName"),
                                  InstalledLocationCode = n.Field<string>("InstalledLocationCode"),
                                  BlockName = n.Field<string>("BlockName"),
                                  BlockCode = n.Field<string>("BlockCode"),
                                  LevelName = n.Field<string>("LevelName"),
                                  LevelCode = n.Field<string>("LevelCode"),
                                  UserAreaId = n.Field<int?>("UserAreaId"),
                                  UserAreaName = n.Field<string>("UserAreaName"),
                                  UserAreaCode = n.Field<string>("UserAreaCode"),
                                  UserLocationId = n.Field<int?>("UserLocationId"),
                                  UserLocationName = n.Field<string>("UserLocationName"),
                                  UserLocationCode = n.Field<string>("UserLocationCode"),
                                  CurrentAreaCode = n.Field<string>("CurrentAreaCode"),
                                  CurrentAreaName = n.Field<string>("CurrentAreaName"),

                                  PpmPlannerId = n.Field<int?>("PPM"),
                                  RiPlannerId = n.Field<int?>("RI"),
                                  OtherPlannerId = n.Field<int?>("Other"),
                                  ExpectedLifeSpan = n.Field<int?>("ExpectedLifeSpan")

                              }).FirstOrDefault();

                    if (result.AssetCategoryLovId == 284)
                    {
                        result.AssetCategoryLovId = 191;
                    }
                    else if (result.AssetCategoryLovId == 283)
                    {
                        result.AssetCategoryLovId = 190;
                    }
                }

                Log4NetLogger.LogExit(_FileName, nameof(GetTestingAndCommissioningDetails), Level.Info.ToString());
                return result;
            }
            catch (DALException dalex)
            {
                throw new DALException(dalex);
            }
            catch (Exception e)
            {
                throw;
            }
        }
        public bool IsAssetNoDuplicate(AssetRegisterModel assetRegister)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(IsAssetNoDuplicate), Level.Info.ToString());

                var isDuplicate = true;
                string constring = ConfigurationManager.ConnectionStrings["UETrackConnectionString"].ConnectionString;
                using (SqlConnection con = new SqlConnection(constring))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_EngAsset_DuplicateCheck";
                        cmd.Parameters.AddWithValue("@pAssetId", assetRegister.AssetId);
                        cmd.Parameters.AddWithValue("@pAssetNo", assetRegister.AssetNo);
                        cmd.Parameters.Add("@IsDuplicate", SqlDbType.Bit);
                        cmd.Parameters["@IsDuplicate"].Direction = ParameterDirection.Output;

                        con.Open();
                        cmd.ExecuteNonQuery();
                        con.Close();
                        bool.TryParse(cmd.Parameters["@IsDuplicate"].Value.ToString(), out isDuplicate);
                    }
                }

                Log4NetLogger.LogExit(_FileName, nameof(IsAssetNoDuplicate), Level.Info.ToString());
                return isDuplicate;
            }
            catch (DALException dalex)
            {
                throw new DALException(dalex);
            }
            catch (Exception)
            {
                throw;
            }
        }
        public bool IsSerialNoDuplicate(AssetRegisterModel assetRegister)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(IsSerialNoDuplicate), Level.Info.ToString());

                var isDuplicate = true;
                string constring = ConfigurationManager.ConnectionStrings["UETrackConnectionString"].ConnectionString;
                using (SqlConnection con = new SqlConnection(constring))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_EngAssetSerialNo_DuplicateCheck";
                        cmd.Parameters.AddWithValue("@pAssetId", assetRegister.AssetId);
                        cmd.Parameters.AddWithValue("@pSerialNo", assetRegister.SerialNo);
                        cmd.Parameters.Add("@IsDuplicate", SqlDbType.Bit);
                        cmd.Parameters["@IsDuplicate"].Direction = ParameterDirection.Output;

                        con.Open();
                        cmd.ExecuteNonQuery();
                        con.Close();
                        bool.TryParse(cmd.Parameters["@IsDuplicate"].Value.ToString(), out isDuplicate);
                    }
                }

                Log4NetLogger.LogExit(_FileName, nameof(IsSerialNoDuplicate), Level.Info.ToString());
                return isDuplicate;
            }
            catch (DALException dalex)
            {
                throw new DALException(dalex);
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
                ErrorMessage = string.Empty;

                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "UspFM_EngAsset_Delete";
                        cmd.Parameters.AddWithValue("@pAssetId", Id);

                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }
                if (ds.Tables.Count != 0 && ds.Tables[0].Rows.Count > 0)
                {
                    ErrorMessage = Convert.ToString(ds.Tables[0].Rows[0]["ErrorMessage"]);
                }
                Log4NetLogger.LogExit(_FileName, nameof(Delete), Level.Info.ToString());
            }
            catch (DALException dalex)
            {
                throw new DALException(dalex);
            }
            catch (Exception)
            {
                throw;
            }
        }
        public GridFilterResult GetChildAsset(int Id, SortPaginateFilter pageFilter)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
                GridFilterResult filterResult = null;

                //var multipleOrderBy = pageFilter.SortColumn.Split(',');
                //var strOrderBy = string.Empty;
                //foreach (var order in multipleOrderBy)
                //{
                //    strOrderBy += order + " " + pageFilter.SortOrder + ",";
                //}
                //if (!string.IsNullOrEmpty(strOrderBy))
                //{
                //    strOrderBy = strOrderBy.TrimEnd(',');
                //}

                //strOrderBy = string.IsNullOrEmpty(strOrderBy) ? pageFilter.SortColumn + " " + pageFilter.SortOrder : strOrderBy;

                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_EngChildAsset_GetByAssetId";
                        cmd.Parameters.AddWithValue("@pAssetId", Id);

                        cmd.Parameters.AddWithValue("@pPageIndex", pageFilter.PageIndex);
                        cmd.Parameters.AddWithValue("@pPageSize", pageFilter.PageSize);
                        //cmd.Parameters.AddWithValue("@strCondition", pageFilter.QueryWhereCondition);
                        //cmd.Parameters.AddWithValue("@strSorting", strOrderBy);

                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }
                if (ds.Tables.Count != 0 && ds.Tables[0].Rows.Count > 0)
                {
                    var totalRecords = Convert.ToInt32(ds.Tables[0].Rows[0]["TotalRecords"]);
                    var totalPages = (int)Math.Ceiling((float)totalRecords / (float)pageFilter.Rows);

                    var commonDAL = new CommonDAL();
                    var currentPageList = commonDAL.ToDynamicList(ds.Tables[0]);
                    filterResult = new GridFilterResult
                    {
                        TotalRecords = totalRecords,
                        TotalPages = totalPages,
                        RecordsList = currentPageList,
                        CurrentPage = pageFilter.Page
                    };
                }
                Log4NetLogger.LogExit(_FileName, nameof(Get), Level.Info.ToString());
                return filterResult;
            }
            catch (DALException dalex)
            {
                throw new DALException(dalex);
            }
            catch (Exception)
            {
                throw;
            }
        }
        public List<AssetStatusDetails> GetAssetStatusDetails(int AssetId)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
                List<AssetStatusDetails> assetStatusDetails = null;

                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_EngAssetStatus_GetByAssetId";
                        cmd.Parameters.AddWithValue("@pAssetId", AssetId);
                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }
                if (ds.Tables.Count != 0 && ds.Tables[0].Rows.Count > 0)
                {
                    assetStatusDetails = (from n in ds.Tables[0].AsEnumerable()
                                          select new AssetStatusDetails
                                          {
                                              AssetStatus = Convert.ToString((n["Status"])),
                                              SNFNumber = Convert.ToString((n["SNFDocumentNo"])),
                                              VariationStatus = Convert.ToString((n["VariationStatus"])),
                                              SNFRaisedDate = n["SNFRaisedDate"] == DBNull.Value ? DateTime.MinValue : Convert.ToDateTime((n["SNFRaisedDate"])),
                                              ServiceStartDate = n["StartServiceDate"] == DBNull.Value ? DateTime.MinValue : Convert.ToDateTime((n["StartServiceDate"])),
                                              ServiceEndDate = n["ServiceStopDate"] == DBNull.Value ? DateTime.MinValue : Convert.ToDateTime((n["ServiceStopDate"])),
                                          }).ToList();
                }
                foreach (var item in assetStatusDetails)
                {
                    if (item.SNFRaisedDate == DateTime.MinValue) item.SNFRaisedDate = null;
                    if (item.ServiceStartDate == DateTime.MinValue) item.ServiceStartDate = null;
                    if (item.ServiceEndDate == DateTime.MinValue) item.ServiceEndDate = null;
                }

                Log4NetLogger.LogExit(_FileName, nameof(Get), Level.Info.ToString());
                return assetStatusDetails;
            }
            catch (DALException dalex)
            {
                throw new DALException(dalex);
            }
            catch (Exception)
            {
                throw;
            }
        }
        public List<AssetRealTimeStatusDetails> GetAssetRealTimeStatusDetails(int AssetId)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
                List<AssetRealTimeStatusDetails> assetRealTimeStatusDetails = null;

                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_EngAssetRealTimeStatus_GetByAssetId";
                        cmd.Parameters.AddWithValue("@pAssetId", AssetId);
                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }
                if (ds.Tables.Count != 0 && ds.Tables[0].Rows.Count > 0)
                {
                    assetRealTimeStatusDetails = (from n in ds.Tables[0].AsEnumerable()
                                                  select new AssetRealTimeStatusDetails
                                                  {
                                                      ServiceWorkNo = Convert.ToString((n["ServiceWorkNo"])),
                                                      ServiceWorkDate = n["ServiceWorkDateTime"] == DBNull.Value ? DateTime.MinValue : Convert.ToDateTime((n["ServiceWorkDateTime"])),
                                                      RealTimeStatus = Convert.ToString((n["RealTimeStatus"])),
                                                  }).ToList();
                }
                foreach (var item in assetRealTimeStatusDetails)
                {
                    if (item.ServiceWorkDate == DateTime.MinValue) item.ServiceWorkDate = null;
                }

                Log4NetLogger.LogExit(_FileName, nameof(Get), Level.Info.ToString());
                return assetRealTimeStatusDetails;
            }
            catch (DALException dalex)
            {
                throw new DALException(dalex);
            }
            catch (Exception)
            {
                throw;
            }
        }
        public List<SoftwareDetails> GetSoftwareDetails(int AssetId)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
                List<SoftwareDetails> softwareDetails = null;

                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_EngAssetSoftware_GetByAssetId";
                        cmd.Parameters.AddWithValue("@pAssetId", AssetId);
                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }
                if (ds.Tables.Count != 0 && ds.Tables[0].Rows.Count > 0)
                {
                    softwareDetails = (from n in ds.Tables[0].AsEnumerable()
                                       select new SoftwareDetails
                                       {
                                           AssetSoftwareId = n.Field<int>("AssetSoftwareId"),
                                           SoftwareKey = Convert.ToString((n["SoftwareKey"])),
                                           SoftwareVersion = Convert.ToString((n["SoftwareVersion"]))
                                       }).ToList();
                }
                Log4NetLogger.LogExit(_FileName, nameof(Get), Level.Info.ToString());
                return softwareDetails;
            }
            catch (DALException dalex)
            {
                throw new DALException(dalex);
            }
            catch (Exception)
            {
                throw;
            }
        }
        public List<DefectDetails> GetDefectDetails(int AssetId)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
                List<DefectDetails> softwareDetails = null;

                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_EngAssetDefectDetails_GetByAssetId";
                        cmd.Parameters.AddWithValue("@pAssetId", AssetId);
                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }
                if (ds.Tables.Count != 0 && ds.Tables[0].Rows.Count > 0)
                {
                    softwareDetails = (from n in ds.Tables[0].AsEnumerable()
                                       select new DefectDetails
                                       {
                                           DefectNo = Convert.ToString((n["DefectNo"])),
                                           DefectDate = n["DefectDate"] == DBNull.Value ? DateTime.MinValue : Convert.ToDateTime((n["DefectDate"])),
                                           StartDate = n["StartDate"] == DBNull.Value ? DateTime.MinValue : Convert.ToDateTime((n["StartDate"])),
                                           CompletionDate = n["CompletionDate"] == DBNull.Value ? DateTime.MinValue : Convert.ToDateTime((n["CompletionDate"])),
                                           ActionTaken = Convert.ToString((n["ActionTaken"])),
                                       }).ToList();
                }
                foreach (var item in softwareDetails)
                {
                    if (item.DefectDate == DateTime.MinValue) item.DefectDate = null;
                    if (item.StartDate == DateTime.MinValue) item.StartDate = null;
                    if (item.CompletionDate == DateTime.MinValue) item.CompletionDate = null;
                }
                Log4NetLogger.LogExit(_FileName, nameof(Get), Level.Info.ToString());
                return softwareDetails;
            }
            catch (DALException dalex)
            {
                throw new DALException(dalex);
            }
            catch (Exception)
            {
                throw;
            }
        }
        public AssetRegisterAccessoriesMstModel GetAccessoriesGridData(int Id, int PageSize, int PageIndex)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(GetAccessoriesGridData), Level.Info.ToString());
                AssetRegisterAccessoriesMstModel entity = new AssetRegisterAccessoriesMstModel();

                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "UspFM_EngAssetAccessories_GetById";
                        //cmd.Parameters.AddWithValue("@pUserId", _UserSession.UserId);
                        cmd.Parameters.AddWithValue("@pAssetId", Id);
                        //cmd.Parameters.AddWithValue("@pPageIndex", 1);
                        //cmd.Parameters.AddWithValue("@pPageSize", 50);

                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }
                if (ds.Tables.Count != 0 && ds.Tables[0].Rows.Count > 0)
                {
                    entity.AssetRegisterAccessoriesDetModel = (from n in ds.Tables[0].AsEnumerable()
                                                               select new AssetRegisterAccessoriesDetModel
                                                               {
                                                                   AccessoriesId = Convert.ToInt32(n["AccessoriesId"]),
                                                                   AssetId = Convert.ToInt32(n["AssetId"]),
                                                                   AccessoriesDescription = Convert.ToString(n["AccessoriesDescription"]),
                                                                   SerialNo = Convert.ToString(n["SerialNo"]),
                                                                   //ManufacturerId = Convert.ToInt32(n["ManufacturerId"]),
                                                                   // ManufacturerId = (n["ManufacturerId"] == DBNull.Value ? 0 : Convert.ToInt32(n["ManufacturerId"])),
                                                                   //   ModelId = (n["ModelId"] == DBNull.Value ? 0 : Convert.ToInt32(n["ModelId"])),
                                                                   ManufacturerName = Convert.ToString(n["ManufacturerName"]),
                                                                   // ModelId = Convert.ToInt32(n["ModelId"]),
                                                                   ModelName = Convert.ToString(n["ModelName"]),
                                                                   //TotalRecords = Convert.ToInt32(n["TotalRecords"]),
                                                                   //TotalPages = Convert.ToInt32(n["TotalPageCalc"])
                                                                   FileName = Convert.ToString(n["FileName"]),
                                                                   FilePath = Convert.ToString(n["FilePath"]),
                                                                   DocumentTitle = Convert.ToString(n["DocumentTitle"]),
                                                                   DocumentExtension = Convert.ToString(n["DocumentExtension"]),
                                                                   //GuId = Convert.ToString(n["GuId"]),

                                                               }).ToList();

                    //entity.AssetRegisterAccessoriesDetModel.ForEach((x) => {
                    //    x.PageIndex = PageIndex;
                    //    x.FirstRecord = ((PageIndex - 1) * PageSize) + 1;
                    //    x.LastRecord = ((PageIndex - 1) * PageSize) + PageSize;
                    //});

                    entity.AssetId = Id;
                }
                Log4NetLogger.LogExit(_FileName, nameof(GetAccessoriesGridData), Level.Info.ToString());
                return entity;
            }
            catch (DALException dalex)
            {
                throw new DALException(dalex);
            }
            catch (Exception)
            {
                throw;
            }
        }
        public AssetRegisterAccessoriesMstModel SaveAccessoriesGridData(AssetRegisterAccessoriesMstModel Accessories, out string ErrorMessage)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(SaveAccessoriesGridData), Level.Info.ToString());
                ErrorMessage = string.Empty;
                var AssetId = 0;
                if (Accessories != null && Accessories.AssetRegisterAccessoriesDetModel != null && Accessories.AssetRegisterAccessoriesDetModel.Count > 0)
                {
                    AssetId = Accessories.AssetRegisterAccessoriesDetModel[0].AssetId;
                }
                DataTable dataTable = new DataTable("EngAssetAccessories");
                dataTable.Columns.Add("AccessoriesId", typeof(int));
                dataTable.Columns.Add("AssetId", typeof(int));
                dataTable.Columns.Add("AccessoriesDescription", typeof(string));
                dataTable.Columns.Add("SerialNo", typeof(string));
                dataTable.Columns.Add("Manufacturer", typeof(string));
                dataTable.Columns.Add("Model", typeof(string));
                dataTable.Columns.Add("CreatedBy", typeof(int));
                dataTable.Columns.Add("DocumentTitle", typeof(string));
                dataTable.Columns.Add("DocumentExtension", typeof(string));
                dataTable.Columns.Add("FileName", typeof(string));
                dataTable.Columns.Add("DocumentRemarks", typeof(string));
                dataTable.Columns.Add("FilePath", typeof(string));
                dataTable.Columns.Add("DocumentGuid", typeof(string));
                var deletedId = Accessories.AssetRegisterAccessoriesDetModel.Where(y => y.IsDeleted).Select(x => x.AccessoriesId).ToList();
                var idstring = string.Empty;
                if (deletedId.Count() > 0)
                {
                    foreach (var item in deletedId.Select((value, i) => new { i, value }))
                    {
                        idstring += item.value;
                        if (item.i != deletedId.Count() - 1)
                        { idstring += ","; }
                    }
                    deleteChildrecords(idstring);
                }
                foreach (var item in Accessories.AssetRegisterAccessoriesDetModel.Where(x => !x.IsDeleted))
                {
                    dataTable.Rows.Add(item.AccessoriesId, item.AssetId, item.AccessoriesDescription, item.SerialNo, item.ManufacturerName, item.ModelName,
                    _UserSession.UserId, item.DocumentTitle, item.DocumentExtension, item.FileName, item.DocumentRemarks, item.FilePath,
                    item.DocumentGuId);

                }

                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_EngAssetAccessories_Save";

                        SqlParameter parameter = new SqlParameter();
                        parameter.ParameterName = "@EngAssetAccessories";
                        parameter.SqlDbType = System.Data.SqlDbType.Structured;
                        parameter.Value = dataTable;
                        cmd.Parameters.Add(parameter);

                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }

                if (ds.Tables.Count != 0)
                {
                    foreach (DataRow row in ds.Tables[0].Rows)
                    {
                        Accessories.AssetId = AssetId;
                        //Accessories.Timestamp = Convert.ToBase64String((byte[])(ds.Tables[0].Rows[0]["Timestamp"]));
                        ErrorMessage = Convert.ToString(row["ErrorMessage"]);
                    }
                }

                Log4NetLogger.LogExit(_FileName, nameof(SaveAccessoriesGridData), Level.Info.ToString());
                return Accessories;
            }
            catch (DALException dalex)
            {
                throw new DALException(dalex);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
        public void deleteChildrecords(string id)
        {
            try
            {
                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_EngAssetAccessories_Delete";
                        cmd.Parameters.AddWithValue("@pAccessoriesId", id);

                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }
            }
            catch (DALException dalex)
            {
                throw new DALException(dalex);
            }
            catch (Exception)
            {
                throw;
            }
        }
        public GridFilterResult GetContractorVendor(int Id, SortPaginateFilter pageFilter)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
                GridFilterResult filterResult = null;

                //var multipleOrderBy = pageFilter.SortColumn.Split(',');
                //var strOrderBy = string.Empty;
                //foreach (var order in multipleOrderBy)
                //{
                //    strOrderBy += order + " " + pageFilter.SortOrder + ",";
                //}
                //if (!string.IsNullOrEmpty(strOrderBy))
                //{
                //    strOrderBy = strOrderBy.TrimEnd(',');
                //}

                //strOrderBy = string.IsNullOrEmpty(strOrderBy) ? pageFilter.SortColumn + " " + pageFilter.SortOrder : strOrderBy;

                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "UspFM_EngAssetContractorandVendor_GetByAssetId";
                        cmd.Parameters.AddWithValue("@pAssetId", Id);
                        cmd.Parameters.AddWithValue("@pPageIndex", pageFilter.PageIndex);
                        cmd.Parameters.AddWithValue("@pPageSize", pageFilter.PageSize);
                        //cmd.Parameters.AddWithValue("@strCondition", pageFilter.QueryWhereCondition);
                        //cmd.Parameters.AddWithValue("@strSorting", strOrderBy);

                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }
                if (ds.Tables.Count != 0 && ds.Tables[0].Rows.Count > 0)
                {
                    var totalRecords = Convert.ToInt32(ds.Tables[0].Rows[0]["TotalRecords"]);
                    var totalPages = (int)Math.Ceiling((float)totalRecords / (float)pageFilter.Rows);

                    var commonDAL = new CommonDAL();
                    var currentPageList = commonDAL.ToDynamicList(ds.Tables[0]);
                    filterResult = new GridFilterResult
                    {
                        TotalRecords = totalRecords,
                        TotalPages = totalPages,
                        RecordsList = currentPageList,
                        CurrentPage = pageFilter.Page
                    };
                }
                Log4NetLogger.LogExit(_FileName, nameof(Get), Level.Info.ToString());
                return filterResult;
            }
            catch (DALException dalex)
            {
                throw new DALException(dalex);
            }
            catch (Exception)
            {
                throw;
            }
        }
        public AssetRegisterLovs GetAssetSpecification(int Id)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(GetAssetSpecification), Level.Info.ToString());
                var assetRegisterLovs = new AssetRegisterLovs();

                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_EngAssetTypeCodeAddSpecification_GetByAssetTypeCodeId";
                        cmd.Parameters.AddWithValue("@pAssetTypeCodeId", Id);

                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }

                if (ds.Tables.Count != 0)
                {
                    if (ds.Tables[0].Rows.Count > 0)
                    {
                        assetRegisterLovs.AssetSpecifications = (from n in ds.Tables[0].AsEnumerable()
                                                                 select new LovValue
                                                                 {
                                                                     LovId = n.Field<int>("AssetTypeCodeAddSpecId"),
                                                                     FieldValue = n.Field<string>("SpecificationTypeName")
                                                                 }).ToList();
                    }
                }
                Log4NetLogger.LogExit(_FileName, nameof(GetAssetSpecification), Level.Info.ToString());
                return assetRegisterLovs;
            }
            catch (DALException dalex)
            {
                throw new DALException(dalex);
            }
            catch (Exception)
            {
                throw;
            }
        }
        public AssetRegisterUploadModel ImportValidation(ref AssetRegisterUploadModel model)
        {
            try
            {
                var result = new AssetRegisterUploadModel();
                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_EngAsset_Import";

                        cmd.Parameters.AddWithValue("@pAssetClassification", model.AssetClassificationName);
                        cmd.Parameters.AddWithValue("@pContractType", model.ContractTypeName);
                        cmd.Parameters.AddWithValue("@pTypeCode", model.AssetTypeCode);
                        cmd.Parameters.AddWithValue("@pModel", model.ModelName);
                        cmd.Parameters.AddWithValue("@pManufacturer", model.ManufacturerName);
                        cmd.Parameters.AddWithValue("@pCurrentLocationName", model.CurrentLocationName);
                        cmd.Parameters.AddWithValue("@pFacilityId", _UserSession.FacilityId);
                        cmd.Parameters.AddWithValue("@pRequestorName", model.RequestorName);
                        cmd.Parameters.AddWithValue("@pAssignee", model.Assignee);
                        cmd.Parameters.AddWithValue("@pVariationStatus", model.VariationStatus);
                        cmd.Parameters.AddWithValue("@pCompanyRepresentative", model.CompanyRepresentative);
                        cmd.Parameters.AddWithValue("@pFacilityRepresentative", model.FacilityRepresentative);
                        cmd.Parameters.AddWithValue("@pVendorName", model.VendorName);
                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }

                if (ds.Tables.Count != 0 && ds.Tables[0].Rows.Count > 0)
                {
                    result.ErrorMessage = ds.Tables[0].Rows[0]["ErrorMessage"] == DBNull.Value ? null : Convert.ToString(ds.Tables[0].Rows[0]["ErrorMessage"]);
                    if (result.ErrorMessage == null || result.ErrorMessage == "")
                    {
                        result.AssetClassification = Convert.ToInt32(ds.Tables[0].Rows[0]["AssetClassificationId"]);
                       //result.TestingandCommissioningDetId = Convert.ToInt32(ds.Tables[0].Rows[0]["AssetPreRegistrationNoId"]);
                        result.AssetTypeCodeId = Convert.ToInt32(ds.Tables[0].Rows[0]["TypeCodeId"]);
                        result.Model = Convert.ToInt32(ds.Tables[0].Rows[0]["ModelId"]);
                        result.Manufacturer = Convert.ToInt32(ds.Tables[0].Rows[0]["ManufacturerId"]);
                        result.UserLocationId = Convert.ToInt32(ds.Tables[0].Rows[0]["CurrentLocationNameId"]);
                        result.UserAreaId = Convert.ToInt32(ds.Tables[0].Rows[0]["UserAreaId"]);                       
                        result.ContractType = Convert.ToInt32(ds.Tables[0].Rows[0]["ContractTypeId"]);
                        result.RequestorId = Convert.ToInt32(ds.Tables[0].Rows[0]["RequestorId"]);
                        result.AssigneeId = Convert.ToInt32(ds.Tables[0].Rows[0]["AssigneeId"]);
                        result.VariationStatusId = Convert.ToInt32(ds.Tables[0].Rows[0]["VariationStatus"]);
                        result.CompanyRepresentativeId = Convert.ToInt32(ds.Tables[0].Rows[0]["CompanyRepresentative"]);
                        result.FacilityRepresentativeId = Convert.ToInt32(ds.Tables[0].Rows[0]["FacilityRepresentative"]);
                        result.ContractorId = Convert.ToInt32(ds.Tables[0].Rows[0]["ContractorId"]);
                    }
                }
                return result;

            }
            catch (DALException dalex)
            {
                throw new DALException(dalex);
            }
            catch (Exception ex)
            {
                throw;
            }
        }
        private void SendMailUnauthorized(AssetRegisterModel model)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(SendMailUnauthorized), Level.Info.ToString());
            try
            {
                string emailTemplateId = string.Empty;
                string subject = string.Empty;
                string subjectVars = string.Empty;
                string templateVars = string.Empty;
                string email = string.Empty;
                if (model.Authorization == 199)
                {
                    emailTemplateId = "79";
                }
                else
                {
                    emailTemplateId = "56";
                }
                //email = model.StaffEmail;

                //var tempid = Convert.ToInt32(emailTemplateId);
                //model.TemplateId = tempid;
                // email = model.StaffEmail;

                templateVars = string.Join(",", model.AssetNo);

                var DataSetparameters = new Dictionary<string, DataTable>();
                DataTable TypecodeDt = new DataTable();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pEmailTemplateId", Convert.ToString(emailTemplateId));
                parameters.Add("@pToEmailIds", email);
                parameters.Add("@pSubject", Convert.ToString(subject));
                parameters.Add("@pPriority", Convert.ToString(1));
                parameters.Add("@pSendAsHtml", Convert.ToString(1));
                parameters.Add("@pSubjectVars", Convert.ToString(subjectVars));
                parameters.Add("@pTemplateVars", Convert.ToString(templateVars));
                parameters.Add("@pFacilityId", Convert.ToString(_UserSession.FacilityId));
                //parameters.Add("@pEmailTempId", Convert.ToString(ent.TemplateId));

                var dbAccessDAL = new DBAccessDAL();
                DataTable dt = dbAccessDAL.GetDataTable("uspFM_EmailNotify_Save", parameters, DataSetparameters);
                if (dt != null)
                {
                    foreach (DataRow rows in dt.Rows)
                    {


                    }
                }
                //  AssigneeNotification(model);
            }


            catch (DALException dalex)
            {
                throw new DALException(dalex);
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
    }
}
