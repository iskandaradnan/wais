using CP.Framework.Common.ExceptionHandler.ExceptionWrappers;
using CP.Framework.Common.Logging;
using CP.UETrack.DAL.DataAccess.Contracts.BEMS;
using CP.UETrack.Model;
using CP.UETrack.Model.BEMS;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using UETrack.DAL;


namespace CP.UETrack.DAL.DataAccess.Implementations.BEMS
{
    public class SparepartRegisterDAL : ISparepartRegisterDAL
    {
        private readonly string _FileName = nameof(SparepartRegisterDAL);
        readonly UserDetailsModel _UserSession = new SessionHelper().UserSession();

        public SparepartRegisterDAL()
        {

        }
        public void Delete(int Id, out string ErrorMessage)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Delete), Level.Info.ToString());
            try
            {
                ErrorMessage = string.Empty;
                var dbAccessDAL = new DBAccessDAL();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pSparePartsId", Id.ToString());
                DataTable dt = dbAccessDAL.GetDataTable("uspFM_EngSpareParts_Delete", parameters, DataSetparameters);
                if (dt != null && dt.Rows.Count > 0)
                {
                    ErrorMessage = Convert.ToString(dt.Rows[0]["ErrorMessage"]);
                }
                Log4NetLogger.LogEntry(_FileName, nameof(Delete), Level.Info.ToString());
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

        public EngSpareParts Get(int Id)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
            try
            {
                var dbAccessDAL = new DBAccessDAL();
                var obj = new EngSpareParts();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pSparePartsId", Id.ToString());
                DataTable dt = dbAccessDAL.GetDataTable("uspFM_EngSpareParts_GetById ", parameters, DataSetparameters);
                if (dt != null && dt.Rows.Count > 0)
                {

                    obj.SparePartsId = Convert.ToInt16(dt.Rows[0]["SparePartsId"]);
                    obj.ServiceId = Convert.ToInt16(dt.Rows[0]["ServiceId"]);
                    obj.ItemId = Convert.ToInt16(dt.Rows[0]["ItemId"]);
                    obj.ItemCode = Convert.ToString(dt.Rows[0]["ItemNo"]);
                    obj.ItemDescription = Convert.ToString(dt.Rows[0]["ItemDescription"]);
                    obj.PartNo = Convert.ToString(dt.Rows[0]["PartNo"]);
                    obj.PartDescription = Convert.ToString(dt.Rows[0]["PartDescription"]);
                    obj.AssetTypeCodeId = Convert.ToInt16(dt.Rows[0]["AssetTypeCodeId"]);
                    obj.AssetTypeCode = Convert.ToString(dt.Rows[0]["AssetTypeCode"]);
                    obj.ManufacturerId = Convert.ToInt16(dt.Rows[0]["ManufacturerId"]);
                    obj.ManufacturerName = Convert.ToString(dt.Rows[0]["ManufacturerName"]);
                    obj.ModelId = Convert.ToInt16(dt.Rows[0]["ModelId"]);
                    obj.ModelName = Convert.ToString(dt.Rows[0]["ModelName"]);
                    //obj.BrandId = Convert.ToInt16(dt.Rows[0]["BrandId"]);
                    obj.UnitOfMeasurement = Convert.ToInt16(dt.Rows[0]["UnitOfMeasurement"]);
                    obj.SparePartType = Convert.ToInt16(dt.Rows[0]["SparePartType"]);
                    obj.Location = Convert.ToInt16(dt.Rows[0]["Location"]);
                    obj.Specify = Convert.ToString(dt.Rows[0]["Specify"]);
                    obj.PartCategory = Convert.ToInt16(dt.Rows[0]["PartCategory"]);
                    //obj.IsExpirydate = Convert.ToBoolean(dt.Rows[0]["IsExpirydate"]);
                    obj.MinLevel = Convert.ToDecimal(dt.Rows[0]["MinLevel"]);
                    // obj.EstimatedLifeSpan = Convert.ToDecimal(dt.Rows[0]["EstimatedLifeSpanInHours"]);
                    obj.MaxLevel = dt.Rows[0]["MaxLevel"] == DBNull.Value ? 0 : Convert.ToDecimal(dt.Rows[0]["MaxLevel"]);
                    obj.MinPrice = dt.Rows[0]["MinPrice"] == DBNull.Value ? 0 : Convert.ToDecimal(dt.Rows[0]["MinPrice"]);
                    obj.MaxPrice = dt.Rows[0]["MaxPrice"] == DBNull.Value ? 0 : Convert.ToDecimal(dt.Rows[0]["MaxPrice"]);
                    obj.Status = Convert.ToInt16(dt.Rows[0]["Status"]);
                    //obj.ExpiryAgeInMonth = dt.Rows[0]["ExpiryAgeInMonth"] == DBNull.Value ? 0 : Convert.ToInt32(dt.Rows[0]["ExpiryAgeInMonth"]);
                    obj.CurrentStockLevel = Convert.ToString(dt.Rows[0]["CurrentStockLevel"]);
                    obj.Image1DocumentId = dt.Rows[0]["Image1DocumentId"] == DBNull.Value ? 0 : Convert.ToInt32(dt.Rows[0]["Image1DocumentId"]);

                    obj.Image2DocumentId = dt.Rows[0]["Image2DocumentId"] == DBNull.Value ? 0 : Convert.ToInt32(dt.Rows[0]["Image2DocumentId"]);

                    obj.Image3DocumentId = dt.Rows[0]["Image3DocumentId"] == DBNull.Value ? 0 : Convert.ToInt32(dt.Rows[0]["Image3DocumentId"]);
                    obj.Image4DocumentId = dt.Rows[0]["Image4DocumentId"] == DBNull.Value ? 0 : Convert.ToInt32(dt.Rows[0]["Image4DocumentId"]);
                    obj.Image5DocumentId = dt.Rows[0]["Image5DocumentId"] == DBNull.Value ? 0 : Convert.ToInt32(dt.Rows[0]["Image5DocumentId"]);
                    obj.Image6DocumentId = dt.Rows[0]["Image6DocumentId"] == DBNull.Value ? 0 : Convert.ToInt32(dt.Rows[0]["Image6DocumentId"]);
                    obj.VideoDocumentId = dt.Rows[0]["VideoDocumentId"] == DBNull.Value ? 0 : Convert.ToInt32(dt.Rows[0]["VideoDocumentId"]);
                    obj.LifespanOptionsId = Convert.ToInt32(dt.Rows[0]["LifeSpanOptionId"]);
                    //  obj.Active = Convert.ToBoolean(dt.Rows[0]["Active"]); 
                    obj.PartSourceId = dt.Rows[0]["PartSourceId"] == DBNull.Value ? 0 : Convert.ToInt32(dt.Rows[0]["PartSourceId"]);
                    obj.Timestamp = Convert.ToBase64String((byte[])(dt.Rows[0]["Timestamp"]));
                    //obj.ExpiryDate = dt.Rows[0]["ExpiryDate"] != DBNull.Value ? (Convert.ToDateTime(dt.Rows[0]["ExpiryDate"])) : (DateTime?)null;
                    obj.HiddenId = Convert.ToString(dt.Rows[0]["GuId"]);

                }
                Log4NetLogger.LogExit(_FileName, nameof(Get), Level.Info.ToString());
                return obj;

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



        public EngSpareParts Save(EngSpareParts model, out string ErrorMessage)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Delete), Level.Info.ToString());
            try
            {

                ErrorMessage = string.Empty;
                var DataSetparameters = new Dictionary<string, DataTable>();

                var parameters = new Dictionary<string, string>();

                parameters.Add("@pUserId", Convert.ToString(_UserSession.UserId));
                parameters.Add("@pSparePartsId", Convert.ToString(model.SparePartsId));
                parameters.Add("@pServiceId", Convert.ToString(model.ServiceId));
                parameters.Add("@pItemId", Convert.ToString(model.ItemId));
                parameters.Add("@pPartNo", Convert.ToString(model.PartNo));
                parameters.Add("@pPartDescription", Convert.ToString(model.PartDescription));
                parameters.Add("@pAssetTypeCodeId", Convert.ToString(model.AssetTypeCodeId));
                parameters.Add("@pManufacturerId", Convert.ToString(model.ManufacturerId));
                parameters.Add("@pBrandId", Convert.ToString(model.BrandId));
                parameters.Add("@pModelId", Convert.ToString(model.ModelId));
                parameters.Add("@pUnitOfMeasurement", Convert.ToString(model.UnitOfMeasurement));
                parameters.Add("@pSparePartType", Convert.ToString(model.SparePartType));
                parameters.Add("@pLocation", Convert.ToString(model.Location));
                parameters.Add("@pSpecify", Convert.ToString(model.Specify));
                parameters.Add("@pPartCategory", Convert.ToString(model.PartCategory));
                //parameters.Add("@pIsExpirydate", model.IsExpirydate == true ? "true" : "false");
                parameters.Add("@pMinLevel", Convert.ToString(model.MinLevel));
                parameters.Add("@pMaxLevel", Convert.ToString(model.MaxLevel));
                parameters.Add("@pMinPrice", Convert.ToString(model.MinPrice));
                parameters.Add("@pMaxPrice", Convert.ToString(model.MaxPrice));
                parameters.Add("@pStatus", Convert.ToString(model.Status));
                // parameters.Add("@pExpiryAgeInMonth", Convert.ToString(model.ExpiryAgeInMonth));
                parameters.Add("@pCurrentStockLevel", Convert.ToString(model.CurrentStockLevel));
                parameters.Add("@pImage1DocumentId", Convert.ToString(model.Image1DocumentId));
                parameters.Add("@pImage2DocumentId", Convert.ToString(model.Image2DocumentId));
                parameters.Add("@pImage3DocumentId", Convert.ToString(model.Image3DocumentId));
                parameters.Add("@pImage4DocumentId", Convert.ToString(model.Image4DocumentId));
                parameters.Add("@pImage5DocumentId", Convert.ToString(model.Image5DocumentId));
                parameters.Add("@pImage6DocumentId", Convert.ToString(model.Image6DocumentId));
                parameters.Add("@pVideoDocumentId", Convert.ToString(model.VideoDocumentId));
                parameters.Add("@pTimestamp", Convert.ToString(model.Timestamp));
                parameters.Add("@pPartSourceId", Convert.ToString(model.PartSourceId));
                parameters.Add("@pItemCode", Convert.ToString(model.ItemCode));
                parameters.Add("@pItemDescription", Convert.ToString(model.ItemDescription));
                // parameters.Add("@ExpiryDate", Convert.ToString(model.ExpiryDate != null ? model.ExpiryDate.Value.ToString("yyyy-MM-dd") : null));
                parameters.Add("@LifeSpanOptionId", Convert.ToString(model.LifespanOptionsId));

                var dbAccessDAL = new DBAccessDAL();
                //var dbAccessDAL = new MASTERDBAccessDAL();
                DataTable dt = dbAccessDAL.GetDataTable("uspFM_EngSpareParts_Save", parameters, DataSetparameters);
                if (dt != null)
                {
                    foreach (DataRow rows in dt.Rows)
                    {
                        model.SparePartsId = Convert.ToInt32(rows["SparePartsId"]);
                        if (rows["Timestamp"] == DBNull.Value)
                        {
                            model.Timestamp = "";
                        }
                        else
                        {
                            model.Timestamp = Convert.ToBase64String((byte[])(rows["Timestamp"]));
                        }


                        ErrorMessage = Convert.ToString(rows["ErrorMessage"]);
                        model.HiddenId = Convert.ToString(rows["GuId"]);
                    }
                }
                return model;
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

        public EngSparePartsLovs Load()
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
                EngSparePartsLovs lovs = new EngSparePartsLovs();
                string lov = "StockTypeValue,SparePartStockLocationValue,SparePartSourceValue,YesNoValue,StatusValue,SparePartLifespanValues";
                var dbAccessDAL = new DBAccessDAL();
                var obj = new EngAssetClassification();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pLovKey", lov);
                DataSet ds = dbAccessDAL.GetDataSet("uspFM_Dropdown", parameters, DataSetparameters);
                if (ds.Tables.Count != 0 && ds.Tables[0].Rows.Count > 0)
                {
                    lovs.StockTypeLovs = dbAccessDAL.GetLovRecords(ds.Tables[0], "StockTypeValue");
                    lovs.SparePartStockLocationLovs = dbAccessDAL.GetLovRecords(ds.Tables[0], "SparePartStockLocationValue");
                    lovs.SparePartSourceLovs = dbAccessDAL.GetLovRecords(ds.Tables[0], "SparePartSourceValue");
                    lovs.YesNoLovs = dbAccessDAL.GetLovRecords(ds.Tables[0], "YesNoValue");
                    lovs.StatusLovs = dbAccessDAL.GetLovRecords(ds.Tables[0], "StatusValue");
                    lovs.LifespanOptionsList = dbAccessDAL.GetLovRecords(ds.Tables[0], "SparePartLifespanValues");
                }
                var DataSetparameters1 = new Dictionary<string, DataTable>();
                var parameters1 = new Dictionary<string, string>();
                parameters1.Add("@pLovKey", null);
                parameters1.Add("@pTableName", "EngSpareParts");
                DataSet ds1 = dbAccessDAL.GetDataSet("uspFM_Dropdown_Others", parameters1, DataSetparameters1);
                if (ds1.Tables.Count != 0 && ds1.Tables[0].Rows.Count > 0)
                {
                    lovs.ServiceList = dbAccessDAL.GetLovRecords(ds.Tables[0]);
                }


                if (ds1.Tables[1] != null && ds1.Tables[1].Rows.Count > 0)
                {
                    lovs.UnitofMeasurementLovs = dbAccessDAL.GetLovRecords(ds1.Tables[1]);
                }
                //if (ds1.Tables[2] != null && ds1.Tables[2].Rows.Count > 0)
                //{
                //    lovs.PartCategoryList = dbAccessDAL.GetLovRecords(ds1.Tables[2]);
                //}
                Log4NetLogger.LogExit(_FileName, nameof(Load), Level.Info.ToString());
                return lovs;
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


        public ImageVideoUploadModel SPImageVideoSave(ImageVideoUploadModel ImageVideo)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(SPImageVideoSave), Level.Info.ToString());

                var dbAccessDAL = new DBAccessDAL();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pGuId", Convert.ToString(ImageVideo.DocumentGuId));
                parameters.Add("@pUserId", Convert.ToString(_UserSession.UserId));

                var DataSetparameters = new Dictionary<string, DataTable>();
                DataTable dt = new DataTable();
                dt.Columns.Add("DocumentId", typeof(int));
                dt.Columns.Add("GuId", typeof(string));
                dt.Columns.Add("CustomerId", typeof(int));
                dt.Columns.Add("FacilityId", typeof(int));
                dt.Columns.Add("DocumentNo", typeof(string));
                dt.Columns.Add("DocumentTitle", typeof(string));
                dt.Columns.Add("DocumentDescription", typeof(string));
                dt.Columns.Add("DocumentCategory", typeof(int));
                dt.Columns.Add("DocumentCategoryOthers", typeof(string));
                dt.Columns.Add("DocumentExtension", typeof(string));
                dt.Columns.Add("MajorVersion", typeof(int));
                dt.Columns.Add("MinorVersion", typeof(int));
                dt.Columns.Add("FileType", typeof(int));
                dt.Columns.Add("FilePath", typeof(string));
                dt.Columns.Add("FileName", typeof(string));
                dt.Columns.Add("UploadedDateUTC", typeof(DateTime));
                dt.Columns.Add("ScreenId", typeof(int));
                dt.Columns.Add("Remarks", typeof(string));
                dt.Columns.Add("UserId", typeof(int));
                dt.Columns.Add("Active", typeof(bool));
                dt.Columns.Add("DocumentGuId", typeof(string));

                foreach (var i in ImageVideo.ImageVideoUploadListData.Where(x => !((string.IsNullOrEmpty(x.Remarks)) && (string.IsNullOrEmpty(x.contentAsBase64String)) && x.DocumentId == 0)))
                {
                    dt.Rows.Add(i.DocumentId, i.GuId, _UserSession.CustomerId, _UserSession.FacilityId, i.DocumentNo, i.DocumentTitle, i.DocumentDescription,
                        i.DocumentCategory, i.DocumentCategoryOthers, i.DocumentExtension, i.MajorVersion, i.MinorVersion, i.FileType, i.FilePath, i.FileName,
                        i.UploadedDateUTC, i.ScreenId, i.Remarks, _UserSession.UserId, i.Active, i.DocumentGuId);
                }
                DataSetparameters.Add("@pFMDocument", dt);
                DataTable dt1 = dbAccessDAL.GetDataTable("uspFM_SparePartsAttachment_Save", parameters, DataSetparameters);
                if (dt1 != null)
                {
                    foreach (DataRow row in dt1.Rows)
                    {
                        foreach (var val in ImageVideo.ImageVideoUploadListData)

                        {
                            val.DocumentId = Convert.ToInt32(row["DocumentId"]);
                            val.Timestamp = Convert.ToBase64String((byte[])(row["Timestamp"]));
                        }
                    }
                }
                Log4NetLogger.LogExit(_FileName, nameof(SPImageVideoSave), Level.Info.ToString());
                return ImageVideo;
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

        public ImageVideoUploadModel SPGetUploadDetails(string Id)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(SPGetUploadDetails), Level.Info.ToString());
            try
            {
                var dbAccessDAL = new DBAccessDAL();
                var obj = new ImageVideoUploadModel();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pDocumentGuId", Id.ToString());

                DataTable dt = dbAccessDAL.GetDataTable("uspFM_SparePartsAttachment_GetById", parameters, DataSetparameters);
                if (dt != null && dt.Rows.Count > 0)
                {

                    var historyList = (from n in dt.AsEnumerable()
                                       select new FileUploadDetModel
                                       {
                                           FileName = Convert.ToString(n["FileName"]),
                                           FilePath = Convert.ToString(n["FilePath"]),
                                           DocumentId = Convert.ToInt32(n["DocumentId"]),
                                           DocumentTitle = Convert.ToString(n["DocumentTitle"]),
                                           DocumentExtension = Convert.ToString(n["DocumentExtension"]),
                                           GuId = Convert.ToString(n["GuId"]),
                                           Remarks = Convert.ToString(n["Remarks"]),
                                           DocumentGuId = Id

                                       }).ToList();


                    if (historyList != null && historyList.Count > 0)
                    {
                        obj.ImageVideoUploadListData = historyList;
                    }
                }
                Log4NetLogger.LogExit(_FileName, nameof(SPGetUploadDetails), Level.Info.ToString());
                return obj;
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

        public bool SPFileDelete(int Id)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(SPFileDelete), Level.Info.ToString());
            try
            {
                var dbAccessDAL = new DBAccessDAL();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pDocumentId", Id.ToString());
                DataTable dt = dbAccessDAL.GetDataTable("uspFM_Attachment_Delete", parameters, DataSetparameters);
                if (dt != null && dt.Rows.Count > 0)
                {
                    string Message = Convert.ToString(dt.Rows[0]["Message"]);
                }
                Log4NetLogger.LogExit(_FileName, nameof(SPFileDelete), Level.Info.ToString());
                return true;
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

    }
}
