using CP.UETrack.BLL.BusinessAccess.Interface;
using CP.UETrack.DAL.DataAccess;
using CP.UETrack.Model;
using System;
using CP.Framework.Common.Logging;
using CP.Framework.Common.ExceptionHandler.ExceptionWrappers;
using System.Collections.Generic;
using CP.UETrack.Model.BEMS.AssetRegister;
using System.Data;
using System.IO;
using System.Linq;

namespace CP.UETrack.BLL.BusinessAccess
{
    public class AssetRegisterBAL : IAssetRegisterBAL
    {
        private string _FileName = nameof(AssetRegisterBAL);
        IAssetRegisterDAL _AssetRegisterDAL;
        public AssetRegisterBAL(IAssetRegisterDAL assetRegisterDAL)
        {
            _AssetRegisterDAL = assetRegisterDAL;
        }
        public AssetRegisterLovs Load()
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
                var result = _AssetRegisterDAL.Load();
                Log4NetLogger.LogExit(_FileName, nameof(Load), Level.Info.ToString());
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
        public AssetRegisterModel Save(AssetRegisterModel assetRegister, out string ErrorMessage)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());

                ErrorMessage = string.Empty;
                AssetRegisterModel result = null;

                if (IsValid(assetRegister, out ErrorMessage))
                {
                    result = _AssetRegisterDAL.Save(assetRegister, out ErrorMessage);
                }

                Log4NetLogger.LogExit(_FileName, nameof(Save), Level.Info.ToString());
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
        public AssetRegisterUploadModel SaveUpload(AssetRegisterUploadModel assetRegister, out string ErrorMessage)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());

                ErrorMessage = string.Empty;
                AssetRegisterUploadModel result = null;

                if (IsValidUpload(assetRegister, out ErrorMessage))
                {
                    result = _AssetRegisterDAL.SaveUpload(assetRegister, out ErrorMessage);
                }

                Log4NetLogger.LogExit(_FileName, nameof(Save), Level.Info.ToString());
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


        private bool IsValid(AssetRegisterModel assetRegister, out string ErrorMessage)
        {
            ErrorMessage = string.Empty;
            var isValid = false;

            //if (!string.IsNullOrEmpty(assetRegister.SerialNo) && _AssetRegisterDAL.IsSerialNoDuplicate(assetRegister))
            //{
            //    ErrorMessage = "Serial No. should be unique";
            //} else 
            if (assetRegister.OtherTransferDate != null && assetRegister.OtherTransferDate < assetRegister.CommissioningDate)
            {
                ErrorMessage = "Transfer Date should be greater than or equal to Commissioning Date";
            }
            else
            {
                isValid = true;
            }
            return isValid;
        }

        private bool IsValidUpload(AssetRegisterUploadModel assetRegister, out string ErrorMessage)
        {
            ErrorMessage = string.Empty;
            var isValid = false;

            //if (!string.IsNullOrEmpty(assetRegister.SerialNo) && _AssetRegisterDAL.IsSerialNoDuplicate(assetRegister))
            //{
            //    ErrorMessage = "Serial No. should be unique";
            //} else 
            if (assetRegister.OtherTransferDate != null && assetRegister.OtherTransferDate < assetRegister.CommissioningDate)
            {
                ErrorMessage = "Transfer Date should be greater than or equal to Commissioning Date";
            }
            else
            {
                isValid = true;
            }
            return isValid;
        }
        public GridFilterResult GetAll(SortPaginateFilter pageFilter)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(GetAll), Level.Info.ToString());
                var result = _AssetRegisterDAL.GetAll(pageFilter);
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
        public AssetRegisterModel Get(int Id)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
                var result = _AssetRegisterDAL.Get(Id);
                Log4NetLogger.LogExit(_FileName, nameof(Get), Level.Info.ToString());
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
        public AssetPreRegistrationNoSearch GetTestingAndCommissioningDetails(int Id, out string ErrorMessage)
        {
            try
            {
                ErrorMessage = string.Empty;
                Log4NetLogger.LogEntry(_FileName, nameof(GetTestingAndCommissioningDetails), Level.Info.ToString());
                var result = _AssetRegisterDAL.GetTestingAndCommissioningDetails(Id, out ErrorMessage);
                Log4NetLogger.LogExit(_FileName, nameof(GetTestingAndCommissioningDetails), Level.Info.ToString());
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
        public void Delete(int Id, out string ErrorMessage)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Delete), Level.Info.ToString());
                _AssetRegisterDAL.Delete(Id, out ErrorMessage);
                Log4NetLogger.LogExit(_FileName, nameof(Delete), Level.Info.ToString());
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
        public GridFilterResult GetChildAsset(int Id, SortPaginateFilter pageFilter)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
                var result = _AssetRegisterDAL.GetChildAsset(Id, pageFilter);
                Log4NetLogger.LogExit(_FileName, nameof(Get), Level.Info.ToString());
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
        public List<AssetStatusDetails> GetAssetStatusDetails(int AssetId)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(GetSoftwareDetails), Level.Info.ToString());
                var result = _AssetRegisterDAL.GetAssetStatusDetails(AssetId);
                Log4NetLogger.LogExit(_FileName, nameof(GetSoftwareDetails), Level.Info.ToString());
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
        public List<AssetRealTimeStatusDetails> GetAssetRealTimeStatusDetails(int AssetId)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(GetSoftwareDetails), Level.Info.ToString());
                var result = _AssetRegisterDAL.GetAssetRealTimeStatusDetails(AssetId);
                Log4NetLogger.LogExit(_FileName, nameof(GetSoftwareDetails), Level.Info.ToString());
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
        public List<SoftwareDetails> GetSoftwareDetails(int AssetId)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(GetSoftwareDetails), Level.Info.ToString());
                var result = _AssetRegisterDAL.GetSoftwareDetails(AssetId);
                Log4NetLogger.LogExit(_FileName, nameof(GetSoftwareDetails), Level.Info.ToString());
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
        public List<DefectDetails> GetDefectDetails(int AssetId)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(GetSoftwareDetails), Level.Info.ToString());
                var result = _AssetRegisterDAL.GetDefectDetails(AssetId);
                Log4NetLogger.LogExit(_FileName, nameof(GetSoftwareDetails), Level.Info.ToString());
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
        public AssetRegisterAccessoriesMstModel GetAccessoriesGridData(int Id, int PageSize, int PageIndex)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
                var result = _AssetRegisterDAL.GetAccessoriesGridData(Id, PageSize, PageIndex);
                Log4NetLogger.LogExit(_FileName, nameof(Get), Level.Info.ToString());
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
        public AssetRegisterAccessoriesMstModel SaveAccessoriesGridData(AssetRegisterAccessoriesMstModel assetRegister, out string ErrorMessage)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());

                ErrorMessage = string.Empty;
                AssetRegisterAccessoriesMstModel result = null;

                //if (IsValid(assetRegister, out ErrorMessage))
                //{
                result = _AssetRegisterDAL.SaveAccessoriesGridData(assetRegister, out ErrorMessage);
                //}

                Log4NetLogger.LogExit(_FileName, nameof(Save), Level.Info.ToString());
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
        public GridFilterResult GetContractorVendor(int Id, SortPaginateFilter pageFilter)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
                var result = _AssetRegisterDAL.GetContractorVendor(Id, pageFilter);
                Log4NetLogger.LogExit(_FileName, nameof(Get), Level.Info.ToString());
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
        public AssetRegisterLovs GetAssetSpecification(int Id)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(GetAssetSpecification), Level.Info.ToString());
                var result = _AssetRegisterDAL.GetAssetSpecification(Id);
                Log4NetLogger.LogExit(_FileName, nameof(GetAssetSpecification), Level.Info.ToString());
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
        private static bool IsUploadValid(AssetRegisterUploadModel model, out string ErrorMessage)
        {
            ErrorMessage = string.Empty;
            var isValid = false;           
            if (model.AssetClassificationName == null || model.AssetClassificationName == "")
            {
                ErrorMessage = "Asset Classification is required.";
            }           
            else if (string.IsNullOrEmpty(model.AssetTypeCode))
            {
                ErrorMessage = "Type Code is required.";
            }
            else if (string.IsNullOrEmpty(model.ModelName))
            {
                ErrorMessage = "Model is required.";
            }
            else if (string.IsNullOrEmpty(model.ManufacturerName))
            {
                ErrorMessage = "Manufacturer is required.";
            }
            else if (model.CurrentLocationName == null)
            {
                ErrorMessage = "Current Location Name is required.";
            }
            else if (model.ContractTypeName == null)
            {
                ErrorMessage = "Current Contract Type is required.";
            }
            else if (model.RequestorName == null)
            {
                ErrorMessage = "Requestor is required.";
            }
            else if (model.RequestDescription == null)
            {
                ErrorMessage = "Request Description is required.";
            }
            else if (model.Assignee == null)
            {
                ErrorMessage = "Assignee is required.";
            }

            else if (model.SerialNo == null)
            {
                ErrorMessage = "Serial No. is required.";
            }
            else if (model.TandCDate == null)
            {
                ErrorMessage = "T&C Date is required.";
            }
            else if (model.TandCCompletedDate == null)
            {
                ErrorMessage = "T&C Completed Date is required.";
            }
            else if (model.HandOverDate == null)
            {
                ErrorMessage = "Hand Over Date is required.";
            }
            else if (model.VariationStatus == null)
            {
                ErrorMessage = "Variation Status is required.";
            }
            else if (model.CompanyRepresentative == null)
            {
                ErrorMessage = "Company Representative required.";
            }
            else if (model.FacilityRepresentative == null)
            {
                ErrorMessage = " Facility Representative is required.";
            }
            else if (model.PurchaseOrderNo == null)
            {
                ErrorMessage = " Purchase Order No. is required.";
            }
            else if (model.ServiceStartDate == null)
            {
                ErrorMessage = " Start Service Date is required.";
            }
            else if (model.WarrantyRemarks == null)
            {
                ErrorMessage = " Remarks Date is required.";
            }
            else if (model.WarrantyDuration == null)
            {
                ErrorMessage = " Warranty Duration (in Months) is required.";
            }           
            else
            {
                isValid = true;
            }
            return isValid;
        }
        public AssetRegisterUpload Upload(ref AssetRegisterUpload FileModel, out string ErrorMessage)
        {
            try
            {
                ErrorMessage = string.Empty;
                Log4NetLogger.LogEntry(_FileName, nameof(Upload), Level.Info.ToString());
                var filePath = System.IO.Path.Combine(AppDomain.CurrentDomain.BaseDirectory + "App_Data\\Temp\\FileUploads");
                var fullFilePath = System.IO.Path.Combine(filePath, FileModel.fileResponseName);
                if (File.Exists(fullFilePath))
                {
                    File.Delete(fullFilePath);
                }
                var bytes = Convert.FromBase64String(FileModel.contentAsBase64String);
                using (FileStream file = File.Create(fullFilePath))
                {
                    file.Write(bytes, 0, bytes.Length);
                    file.Close();
                }
                var FileData = ConvertCSVtoDataTable(fullFilePath);
                var assetRegisterUploadModel = new AssetRegisterUpload();
                foreach (DataRow row in FileData.Rows)
                {
                    var assetRegister = new AssetRegisterUploadModel
                    {
                        Hosptial = row["Hospital"] == DBNull.Value ? null : Convert.ToString(row["Hospital"].ToString()),
                        AssetNo = row["Asset No."] == DBNull.Value ? null : Convert.ToString(row["Asset No."].ToString()),
                        AssetTypeCode = row["Type Code"] == DBNull.Value ? null : Convert.ToString(row["Type Code"].ToString()),
                        AssetDescription = row["Type Description"] == DBNull.Value ? null : Convert.ToString(row["Type Description"].ToString()),
                        AssetClassificationName = row["Classification Code"] == DBNull.Value ? null : Convert.ToString(row["Classification Code"].ToString()),
                        ContractTypeName = row["Contract Type"] == DBNull.Value ? null : Convert.ToString(row["Contract Type"].ToString()),
                        ModelName = row["Model"] == DBNull.Value ? null : Convert.ToString(row["Model"].ToString()),
                        ManufacturerName = row["Manufacturer"] == DBNull.Value ? null : Convert.ToString(row["Manufacturer"].ToString()),
                        CurrentLocationName = row["Location Name"] == DBNull.Value ? null : Convert.ToString(row["Location Name"].ToString()),                        //CRM 
                        RequestorName = row["Requester"] == DBNull.Value ? null : Convert.ToString(row["Requester"].ToString()),
                        TargetDate = Convert.ToDateTime(row["Target Date"].ToString()),
                        RequestDescription = row["Request Description"] == DBNull.Value ? null : Convert.ToString(row["Request Description"].ToString()),
                        Remarks = row["Remarks"] == DBNull.Value ? null : Convert.ToString(row["Remarks"].ToString()),
                        Assignee = row["Assignee"] == DBNull.Value ? null : Convert.ToString(row["Assignee"].ToString()),
                        SerialNo = row["Serial No."] == DBNull.Value ? null : Convert.ToString(row["Serial No."].ToString()),
                        TandCDate = Convert.ToDateTime(row["TnC Date"]),
                        TandCCompletedDate = Convert.ToDateTime(row["TnC Completed Date"].ToString()),
                        HandOverDate = Convert.ToDateTime(row["Hand Over Date"].ToString()),
                        VariationStatus = Convert.ToString(row["Variation Status"].ToString()),
                        CompanyRepresentative = row["Company Representative"] == DBNull.Value ? null : Convert.ToString(row["Company Representative"].ToString()),
                        FacilityRepresentative = row["Facility Representative"] == DBNull.Value ? null : Convert.ToString(row["Facility Representative"].ToString()),
                        PurchaseOrderNo = row["Purchase Order No."] == DBNull.Value ? null : Convert.ToString(row["Purchase Order No."].ToString()),
                        PurchaseCostRM = row["Purchase Cost (RM)"] != DBNull.Value ? (Convert.ToDecimal(row["Purchase Cost (RM)"])) : (Decimal?)null,
                        WarrantyStartDate = row["Warranty Start Date"] != DBNull.Value ? (Convert.ToDateTime(row["Warranty Start Date"])) : (DateTime?)null,
                        PurchaseDate = Convert.ToDateTime(row["Purchase Date"].ToString()),
                        ServiceStartDate = Convert.ToDateTime(row["Service Start Date"].ToString()),
                        WarrantyRemarks = row["Warranty Remarks"] == DBNull.Value ? null : Convert.ToString(row["Warranty Remarks"].ToString()),
                        WarrantyDuration = row["Warranty Duration(In Months)"] != DBNull.Value ? (Convert.ToDecimal(row["Warranty Duration(In Months)"])) : (Decimal?)null,
                        VendorName = row["Vendor"] == DBNull.Value ? null : Convert.ToString(row["Vendor"].ToString()),
                    };

                    if (IsUploadValid(assetRegister, out ErrorMessage))
                    {
                        var importOut = _AssetRegisterDAL.ImportValidation(ref assetRegister);
                        if (importOut.ErrorMessage != null && importOut.ErrorMessage != "")
                        {
                            ErrorMessage = importOut.ErrorMessage.Split(',')[0];
                        }
                        else
                        {
                            assetRegister.AssetClassification = importOut.AssetClassification;
                            assetRegister.AssetTypeCodeId = importOut.AssetTypeCodeId;
                            assetRegister.Model = importOut.Model;
                            assetRegister.Manufacturer = importOut.Manufacturer;
                            assetRegister.UserLocationId = importOut.UserLocationId;
                            assetRegister.UserAreaId = importOut.UserAreaId;
                            assetRegister.AppliedPartTypeLovId = importOut.AppliedPartTypeLovId;
                            assetRegister.Timestamp = "";
                            assetRegister.ContractorId = importOut.ContractorId;
                            assetRegister.ContractType = importOut.ContractType;
                            assetRegister.RequestorId = importOut.RequestorId;
                            assetRegister.AssigneeId = importOut.AssigneeId;
                            assetRegister.CompanyRepresentativeId = importOut.CompanyRepresentativeId;
                            assetRegister.FacilityRepresentativeId = importOut.FacilityRepresentativeId;
                            assetRegister.VariationStatusId = importOut.VariationStatusId;
                            SaveUpload(assetRegister, out ErrorMessage);
                        }
                    }
                }
                return assetRegisterUploadModel;
            }
            catch (BALException balException)
            {
                throw new BALException(balException);
            }
            catch (Exception ex)
            {
                throw new Exception(ex.Message.Replace(".", "") + " or Invalid CSV File has been uploaded");
            }
        }




        public static DataTable ConvertCSVtoDataTable(string strFilePath)
        {
            using (var sr = new StreamReader(strFilePath))
            {
                var t = "";
                var headers = sr.ReadLine().Split(',');
                var dt = new DataTable();
                foreach (string header in headers)
                {
                    if (header.Contains('"'))
                    {
                        t = header.Substring(1, header.Length - 2);
                    }
                    else
                    {
                        t = header;
                    }
                    dt.Columns.Add(t);
                }
                while (!sr.EndOfStream)
                {
                    var rows = sr.ReadLine().Split(',');
                    var dr = dt.NewRow();
                    try
                    {
                        for (int i = 0; i < headers.Length; i++)
                        {
                            if (rows[i].Contains('"'))
                            {
                                t = rows[i].Substring(1, rows[i].Length - 2);
                            }
                            else
                            {
                                t = rows[i];
                            }
                            if (t.ToString().Trim() != "")
                            {
                                dr[i] = t;
                            }
                        }
                    }
                    catch (IndexOutOfRangeException ex)
                    {
                        throw new BALException(ex);
                    }
                    dt.Rows.Add(dr);
                }
                return dt;
            }
        }
    }
}
