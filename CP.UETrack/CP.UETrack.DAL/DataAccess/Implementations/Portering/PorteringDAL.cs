using CP.UETrack.DAL.DataAccess.Contracts.Portering;
using System;
using System.Collections.Generic;
using CP.UETrack.Model.Portering;
using CP.Framework.Common.Logging;
using CP.UETrack.Model;
using UETrack.DAL;
using System.Data;
using CP.Framework.Common.ExceptionHandler.ExceptionWrappers;
using System.Linq;
using CP.UETrack.DAL.DataAccess.Implementations.BEMS;
using CP.UETrack.Model.BEMS;
using System.Data.SqlClient;
using CP.UETrack.Models;

namespace CP.UETrack.DAL.DataAccess.Implementations.Portering
{
    public class PorteringDAL : IPorteringDAL
    {
        private readonly string _FileName = nameof(PorteringDAL);
        readonly UserDetailsModel _UserSession = new SessionHelper().UserSession();

        public PorteringLovs Load()
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
                var Lovs = new PorteringLovs();
                string lovs = "PorterMovementCategoryValue,PorterRequestTypeValue,PorterWFStatusValue,PorteringStatusValue,PorterTrasportModeValue,WarrantyCategoryValue";
                var dbAccessDAL = new DBAccessDAL();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pLovKey", lovs);
                DataSet ds = dbAccessDAL.GetDataSet("uspFM_Dropdown", parameters, DataSetparameters);
                if (ds.Tables.Count != 0 && ds.Tables[0].Rows.Count > 0)
                {
                    Lovs.MovementCategoryLovs = dbAccessDAL.GetLovRecords(ds.Tables[0], "PorterMovementCategoryValue");
                    Lovs.RequestTypeLovs = dbAccessDAL.GetLovRecords(ds.Tables[0], "PorterRequestTypeValue");
                    Lovs.WorkFlowStatusLovs = dbAccessDAL.GetLovRecords(ds.Tables[0], "PorterWFStatusValue");
                    Lovs.PorteringStatusLovs = dbAccessDAL.GetLovRecords(ds.Tables[0], "PorteringStatusValue");
                    Lovs.WarrantyCategoryLovs = dbAccessDAL.GetLovRecords(ds.Tables[0], "WarrantyCategoryValue");
                    Lovs.ModeOfTransportLovs = dbAccessDAL.GetLovRecords(ds.Tables[0], "PorterTrasportModeValue");
                }
                var DataSetparameters1 = new Dictionary<string, DataTable>();
                var parameters1 = new Dictionary<string, string>();

                var customerid = _UserSession.CustomerId;

                parameters1.Add("@pLovKey", Convert.ToString(customerid));
                parameters1.Add("@pTableName", "PorteringTransaction");
                DataSet ds1 = dbAccessDAL.GetDataSet("uspFM_Dropdown_Others", parameters1, DataSetparameters1);

                if (ds1 != null && ds1.Tables[0] != null && ds1.Tables[0].Rows.Count > 0)
                {
                    Lovs.FromFacilityLovs = dbAccessDAL.GetLovRecords(ds1.Tables[0]);
                }
                var currentDate = DateTime.Now;
                Lovs.FacilityId = _UserSession.FacilityId;
                Lovs.PorteringDate = currentDate.Date;
                Log4NetLogger.LogExit(_FileName, nameof(Load), Level.Info.ToString());
                return Lovs;
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

        public PorteringLovs GetLocationList(PorteringLovs obj)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
                var Lovs = new PorteringLovs();
                var dbAccessDAL = new DBAccessDAL();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pFacilityId", Convert.ToString(obj.ToFacilityId));
                parameters.Add("@pBlockId", Convert.ToString(obj.ToBlockId));
                parameters.Add("@pLevelId", Convert.ToString(obj.ToLevelId));
                parameters.Add("@pUserAreaId", Convert.ToString(obj.ToUserAreaId));
                parameters.Add("@pLocationNo", Convert.ToString(obj.LocationNo));
                DataTable dt = dbAccessDAL.GetDataTable("uspFM_MstLocation_Fetch", parameters, DataSetparameters);
                if (dt != null && dt.Rows.Count > 0)
                {
                    Lovs.CascadeLocationLovs = dbAccessDAL.GetLovRecords(dt);

                }
                Log4NetLogger.LogExit(_FileName, nameof(Load), Level.Info.ToString());
                return Lovs;
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

        public void Delete(int Id, out string ErrorMessage)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Delete), Level.Info.ToString());
            try
            {
                ErrorMessage = string.Empty;
                var dbAccessDAL = new DBAccessDAL();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pPorteringId", Id.ToString());
                DataTable dt = dbAccessDAL.GetDataTable("uspFM_PorteringTransaction_Delete", parameters, DataSetparameters);
                if (dt != null && dt.Rows.Count > 0)
                {
                    ErrorMessage = Convert.ToString(dt.Rows[0]["ErrorMessage"]);
                }
                Log4NetLogger.LogExit(_FileName, nameof(Delete), Level.Info.ToString());
                // return (string.IsNullOrEmpty(Message)) ? true : false;
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

        public PorteringModel Get(int Id)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
            try
            {
                var dbAccessDAL = new DBAccessDAL();
                var obj = new PorteringModel();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pPorteringId", Id.ToString());
                DataSet ds = dbAccessDAL.GetDataSet("uspFM_PorteringTransaction_GetById", parameters, DataSetparameters);
                if (ds != null)
                {
                    if (ds.Tables[0] != null && ds.Tables[0].Rows.Count > 0)
                    {

                        obj.PorteringId = Convert.ToInt16(ds.Tables[0].Rows[0]["PorteringId"]);
                        obj.FromCustomerId = Convert.ToInt16(ds.Tables[0].Rows[0]["FromCustomerId"]);
                        obj.FromFacilityId = Convert.ToInt16(ds.Tables[0].Rows[0]["FromFacilityId"]);
                        obj.FromBlockId = Convert.ToInt16(ds.Tables[0].Rows[0]["FromBlockId"]);
                        obj.FromLevelId = Convert.ToInt16(ds.Tables[0].Rows[0]["FromLevelId"]);
                        obj.FromUserAreaId = Convert.ToInt16(ds.Tables[0].Rows[0]["FromUserAreaId"]);
                        obj.FromUserLocationId = Convert.ToInt16(ds.Tables[0].Rows[0]["FromUserLocationId"]);
                        obj.FacilityName = Convert.ToString(ds.Tables[0].Rows[0]["FromFacilityName"]);
                        obj.BlockName = Convert.ToString(ds.Tables[0].Rows[0]["fromBlockName"]);
                        obj.LevelName = Convert.ToString(ds.Tables[0].Rows[0]["FromLevelName"]);
                        obj.UserAreaName = Convert.ToString(ds.Tables[0].Rows[0]["FromUserAreaName"]);
                        obj.UserLocationName = Convert.ToString(ds.Tables[0].Rows[0]["FromUserLocationName"]);
                        obj.RequestorId = Convert.ToInt32(ds.Tables[0].Rows[0]["RequestorId"]);
                        obj.RequestorName = Convert.ToString(ds.Tables[0].Rows[0]["RequestorName"]);
                        obj.Position = Convert.ToString(ds.Tables[0].Rows[0]["RequestorDesignation"]);
                        obj.RequestTypeLovId = Convert.ToInt32(ds.Tables[0].Rows[0]["RequestTypeLovId"]);
                        obj.MovementCategory = ds.Tables[0].Rows[0]["MovementCategory"] != DBNull.Value ? Convert.ToInt16(ds.Tables[0].Rows[0]["MovementCategory"]) : (int?)null;

                        obj.ToFacilityId = ds.Tables[0].Rows[0]["ToFacilityId"] != DBNull.Value ? Convert.ToInt16(ds.Tables[0].Rows[0]["ToFacilityId"]) : (int?)null;
                        obj.ToCustomerId = ds.Tables[0].Rows[0]["ToCustomerId"] != DBNull.Value ? Convert.ToInt16(ds.Tables[0].Rows[0]["ToCustomerId"]) : (int?)null;
                        obj.ToBlockId = ds.Tables[0].Rows[0]["ToBlockId"] != DBNull.Value ? Convert.ToInt16(ds.Tables[0].Rows[0]["ToBlockId"]) : (int?)null;
                        obj.ToLevelId = ds.Tables[0].Rows[0]["ToLevelId"] != DBNull.Value ? Convert.ToInt16(ds.Tables[0].Rows[0]["ToLevelId"]) : (int?)null;
                        obj.ToUserAreaId = ds.Tables[0].Rows[0]["ToUserAreaId"] != DBNull.Value ? Convert.ToInt16(ds.Tables[0].Rows[0]["ToUserAreaId"]) : (int?)null;
                        obj.ToUserLocationId = ds.Tables[0].Rows[0]["ToUserLocationId"] != DBNull.Value ? Convert.ToInt16(ds.Tables[0].Rows[0]["ToUserLocationId"]) : (int?)null;
                        obj.SupplierId = ds.Tables[0].Rows[0]["SupplierId"] != DBNull.Value ? Convert.ToInt16(ds.Tables[0].Rows[0]["SupplierId"]) : (int?)null;
                        obj.SupplierLovId = ds.Tables[0].Rows[0]["SupplierLovId"] != DBNull.Value ? Convert.ToInt16(ds.Tables[0].Rows[0]["SupplierLovId"]) : (int?)null;

                        //obj.SubCategory = ds.Tables[0].Rows[0]["SubCategory"] != DBNull.Value ? Convert.ToInt16(ds.Tables[0].Rows[0]["SubCategory"]) : (int?)null;
                        obj.ModeOfTransport = ds.Tables[0].Rows[0]["ModeOfTransport"] != DBNull.Value ? (Convert.ToInt32(ds.Tables[0].Rows[0]["ModeOfTransport"])) : (int?)null;
                        obj.CurrentWorkFlowId = ds.Tables[0].Rows[0]["CurrentWorkFlowId"] != DBNull.Value ? Convert.ToInt16(ds.Tables[0].Rows[0]["CurrentWorkFlowId"]) : (int?)null;

                        obj.AssignPorterId = ds.Tables[0].Rows[0]["AssignPorterId"] != DBNull.Value ? (Convert.ToInt32(ds.Tables[0].Rows[0]["AssignPorterId"])) : (int?)null;
                        obj.ConsignmentNo = Convert.ToString(ds.Tables[0].Rows[0]["ConsignmentNo"]);
                        obj.PorteringStatus = ds.Tables[0].Rows[0]["PorteringStatus"] != DBNull.Value ? (Convert.ToInt32(ds.Tables[0].Rows[0]["PorteringStatus"])) : (int?)null;


                        obj.ReceivedBy = ds.Tables[0].Rows[0]["ReceivedBy"] != DBNull.Value ? Convert.ToInt16(ds.Tables[0].Rows[0]["ReceivedBy"]) : (int?)null;
                        obj.ReceivedByPosition = Convert.ToString(ds.Tables[0].Rows[0]["ReceivedByPosition"]);

                        obj.ReceivedByName = Convert.ToString(ds.Tables[0].Rows[0]["ReceivedByValue"]);
                        obj.AssignPorterName = Convert.ToString(ds.Tables[0].Rows[0]["AssignPorterName"]);


                        obj.Remarks = Convert.ToString(ds.Tables[0].Rows[0]["Remarks"]);
                        obj.Timestamp = Convert.ToBase64String((byte[])(ds.Tables[0].Rows[0]["Timestamp"]));
                        obj.AssetId = Convert.ToInt32(ds.Tables[0].Rows[0]["AssetId"]);
                        obj.AssetNo = Convert.ToString(ds.Tables[0].Rows[0]["AssetNo"]);
                        obj.WorkOrderId = ds.Tables[0].Rows[0]["WorkOrderId"] != DBNull.Value ? (Convert.ToInt32(ds.Tables[0].Rows[0]["WorkOrderId"])) : (int?)null;
                        obj.WorkOrderNo = Convert.ToString(ds.Tables[0].Rows[0]["MaintenanceWorkNo"]);
                        obj.PorteringDate = Convert.ToDateTime(ds.Tables[0].Rows[0]["PorteringDate"]);
                        obj.PorteringNo = Convert.ToString(ds.Tables[0].Rows[0]["PorteringNo"]);
                        obj.CourierName = Convert.ToString(ds.Tables[0].Rows[0]["CourierName"]);
                        obj.ConsignmentDate = ds.Tables[0].Rows[0]["ConsignmentDate"] != DBNull.Value ? (Convert.ToDateTime(ds.Tables[0].Rows[0]["ConsignmentDate"])) : (DateTime?)null;
                        obj.ScanAsset = Convert.ToString(ds.Tables[0].Rows[0]["ScanAsset"]);

                        obj.LoanerTestEquipmentBookingId = ds.Tables[0].Rows[0]["LoanerTestEquipmentBookingId"] != DBNull.Value ? (Convert.ToInt32(ds.Tables[0].Rows[0]["LoanerTestEquipmentBookingId"])) : (int?)null;
                        obj.HiddenId = Convert.ToString((ds.Tables[0].Rows[0]["GuId"]));
                        obj.WFStatusApprovedDate = ds.Tables[0].Rows[0]["WFStatusApprovedDate"] != DBNull.Value ? (Convert.ToDateTime(ds.Tables[0].Rows[0]["WFStatusApprovedDate"])) : (DateTime?)null;

                        obj.ToBlockCode = Convert.ToString(ds.Tables[0].Rows[0]["ToBlockCode"]);
                        obj.ToBlockName = Convert.ToString(ds.Tables[0].Rows[0]["ToBlockName"]);
                        obj.ToLevelCode = Convert.ToString(ds.Tables[0].Rows[0]["ToLevelCode"]);
                        obj.ToLevelName = Convert.ToString(ds.Tables[0].Rows[0]["ToLevelName"]);
                        obj.ToUserAreaCode = Convert.ToString(ds.Tables[0].Rows[0]["ToUserAreaCode"]);
                        obj.ToUserAreaName = Convert.ToString(ds.Tables[0].Rows[0]["ToUserAreaName"]);
                        obj.ToUserLocationCode = Convert.ToString(ds.Tables[0].Rows[0]["ToUserLocationCode"]);
                        obj.ToUserLocationName = Convert.ToString(ds.Tables[0].Rows[0]["ToUserLocationName"]);
                    }

                    if (obj.MovementCategory == 242)
                    {
                        var supplierId = (int)obj.SupplierLovId;
                        var assetId = (int)obj.AssetId;
                        var list = GetVendorInfo(supplierId, assetId);


                        if (list != null && list.VendorNameLovs != null && list.VendorNameLovs.Count > 0)
                        {
                            obj.VendorNameLovs = list.VendorNameLovs;
                        }
                    }
                    else
                    {
                        if (ds.Tables[1] != null && ds.Tables[1].Rows.Count > 0)
                        {
                            obj.ToFacilityLovs = dbAccessDAL.GetLovRecords(ds.Tables[1], "MstLocationFacility");
                            obj.ToBlockLovs = dbAccessDAL.GetLovRecords(ds.Tables[1], "MstLocationBlock");
                            obj.ToLevelLovs = dbAccessDAL.GetLovRecords(ds.Tables[1], "MstLocationLevel");
                            obj.ToUserAreaLovs = dbAccessDAL.GetLovRecords(ds.Tables[1], "MstLocationUserArea");
                            obj.ToUserLocationLovs = dbAccessDAL.GetLovRecords(ds.Tables[1], "MstLocationUserLocation");
                        }
                    }

                    if (ds.Tables.Count > 2)
                    {
                        if (ds.Tables[2] != null && ds.Tables[2].Rows.Count > 0)
                        {
                            obj.LocationInchargeId = ds.Tables[2].Rows[0]["LocationInchargeId"] != DBNull.Value ? (Convert.ToInt32(ds.Tables[2].Rows[0]["LocationInchargeId"])) : (int?)null;
                            obj.LocationInchargeName = Convert.ToString((ds.Tables[2].Rows[0]["LocationInchargeName"]));
                        }

                    }

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
                throw;
            }
        }

        public PorteringModel GetPorteringHistory(int Id)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
            try
            {
                var dbAccessDAL = new DBAccessDAL();
                var obj = new PorteringModel();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pPorteringId", Id.ToString());
                parameters.Add("@pPageIndex", Convert.ToString(1));
                parameters.Add("@pPageSize", Convert.ToString(10));
                DataSet ds = dbAccessDAL.GetDataSet("UspFM_PorteringTransactionHistory_GetById", parameters, DataSetparameters);
                if (ds != null)
                {
                    if (ds.Tables[0] != null && ds.Tables[0].Rows.Count > 0)
                    {

                        var RemarksHistory = (from n in ds.Tables[0].AsEnumerable()
                                              select new PorteringHistoryDet
                                              {
                                                  WorkFlowStatusIdValue = Convert.ToString(n["WorkFlowStatusIdValue"]),
                                                  WFDoneByValue = Convert.ToString(n["WFDoneByValue"]),
                                                  WFDoneByDate = n.Field<DateTime?>("WFDoneByDate"),
                                                  PorteringStatusLovIdValue = Convert.ToString(n["PorteringStatusLovIdValue"]),
                                                  PorterigDonebyDate = n.Field<DateTime?>("PorteringStatusDoneByDate"),
                                                  PorteringStatusDoneByValue = Convert.ToString(n["PorteringStatusDoneByValue"]),
                                                  Remarks = Convert.ToString(n["Remarks"]),
                                                  WFDoneBy = n.Field<int?>("WFDoneBy"),
                                                  PorteringStatusLovId = n.Field<int?>("PorteringStatusLovId"),
                                                  LastUpdatedDate = n.Field<DateTime?>("LastUpdatedDate"),

                                                  
                                              }).ToList();
                        if (RemarksHistory != null && RemarksHistory.Count > 0)
                            obj.PorteringHistoryDets = RemarksHistory;
                    }
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
                throw;
            }
        }

        public PorteringModel Save(PorteringModel model, out string ErrorMessage)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());
            try
            {
                ErrorMessage = string.Empty;
                var DataSetparameters = new Dictionary<string, DataTable>();
                DataTable TypecodeDt = new DataTable();
                var parameters = new Dictionary<string, string>();

                if (model.CurrentWorkFlowId == 247 && model.PorteringStatus == null)
                {
                    model.WFStatusApprovedDate = DateTime.Now;
                }


                parameters.Add("@pPorteringId", Convert.ToString(model.PorteringId));
                parameters.Add("@pFromCustomerId", Convert.ToString(_UserSession.CustomerId));
                parameters.Add("@pFromFacilityId", Convert.ToString(model.FromFacilityId));
                parameters.Add("@pFromBlockId", Convert.ToString(model.FromBlockId));
                parameters.Add("@pFromLevelId", Convert.ToString(model.FromLevelId));
                parameters.Add("@pFromUserAreaId", Convert.ToString(model.FromUserAreaId));
                parameters.Add("@pFromUserLocationId", Convert.ToString(model.FromUserLocationId));
                parameters.Add("@pRequestorId", Convert.ToString(model.RequestorId));

                parameters.Add("@pRequestTypeLovId", Convert.ToString(model.RequestTypeLovId));
                parameters.Add("@pMovementCategory", Convert.ToString(model.MovementCategory));
                parameters.Add("@pSubCategory", Convert.ToString(model.SubCategory));

                parameters.Add("@pModeOfTransport", Convert.ToString(model.ModeOfTransport));
                parameters.Add("@pToCustomerId", Convert.ToString(_UserSession.CustomerId));
                parameters.Add("@pToFacilityId", Convert.ToString(model.ToFacilityId));
                parameters.Add("@pToBlockId", Convert.ToString(model.ToBlockId));
                parameters.Add("@pToLevelId", Convert.ToString(model.ToLevelId));
                parameters.Add("@pToUserAreaId", Convert.ToString(model.ToUserAreaId));
                parameters.Add("@pToUserLocationId", Convert.ToString(model.ToUserLocationId));

                parameters.Add("@pAssignPorterId", Convert.ToString(model.AssignPorterId));
                parameters.Add("@pConsignmentNo", Convert.ToString(model.ConsignmentNo));
                parameters.Add("@pPorteringStatus", Convert.ToString(model.PorteringStatus));

                parameters.Add("@pReceivedBy", Convert.ToString(model.ReceivedBy));
                parameters.Add("@pCurrentWorkFlowId", Convert.ToString(model.CurrentWorkFlowId));
                parameters.Add("@pRemarks", Convert.ToString(model.Remarks));
                parameters.Add("@pAssetId ", Convert.ToString(model.AssetId));

                parameters.Add("@pPorteringDate", model.PorteringDate != null ? model.PorteringDate.Value.ToString("yyyy-MM-dd") : null);

                parameters.Add("@pPorteringNo", Convert.ToString(model.PorteringNo));
                parameters.Add("@pUserId", Convert.ToString(_UserSession.UserId));
                parameters.Add("@pTimestamp", Convert.ToString(model.Timestamp));

                parameters.Add("@pWorkOrderId", Convert.ToString(model.WorkOrderId));
                parameters.Add("@pSupplierId", Convert.ToString(model.SupplierId));
                parameters.Add("@pSupplierLovId", Convert.ToString(model.SupplierLovId));

                parameters.Add("@pScanAsset", Convert.ToString(model.ScanAsset));
                parameters.Add("@pConsignmentDate", model.ConsignmentDate != null ? model.ConsignmentDate.Value.ToString("yyyy-MM-dd") : null);
                parameters.Add("@pCourierName", Convert.ToString(model.CourierName));
                parameters.Add("@pApprovedDate", model.WFStatusApprovedDate != null ? model.WFStatusApprovedDate.Value.ToString("yyyy-MM-dd") : null);
                parameters.Add("@pLoanerTestEquipmentBookingId", Convert.ToString(model.LoanerTestEquipmentBookingId));

                var dbAccessDAL = new DBAccessDAL();
                DataTable dt = dbAccessDAL.GetDataTable("uspFM_PorteringTransaction_Save", parameters, DataSetparameters);
                if (dt != null)
                {
                    foreach (DataRow rows in dt.Rows)
                    {

                        if (rows["PorteringId"] != null)
                        {
                            model.PorteringId = Convert.ToInt32(rows["PorteringId"]);
                        }
                        if (rows["EngineerId"] != null)
                        {
                            model.EngineerId = Convert.ToInt32(rows["EngineerId"]);
                        }

                        ErrorMessage = Convert.ToString(rows["ErrorMessage"]);
                        model.HiddenId = Convert.ToString(rows["GuId"]);
                        if (model.CurrentWorkFlowId == 247 || model.CurrentWorkFlowId == 309 || model.CurrentWorkFlowId == 246 || model.CurrentWorkFlowId == 248)
                        {
                            updateNotificationSingle(model);

                        }
                        if (ErrorMessage == string.Empty)
                        {
                            if ((model.CurrentWorkFlowId == 247 && model.PorteringStatus == null) || (model.CurrentWorkFlowId == 246) || model.CurrentWorkFlowId == 248)
                            {
                                SendMail(model);
                            }

                        }

                    }
                }
                return model;
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

        public PorteringModel updateNotificationSingle(PorteringModel ent)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());
            PorteringModel griddata = new PorteringModel();
            var dbAccessDAL = new DBAccessDAL();
            var parameters = new Dictionary<string, string>();
            var DataSetparameters = new Dictionary<string, DataTable>();
            var Hyplink = "/bems/assettracker?id=" + ent.LoanerTestEquipmentBookingId;
            var NotiToId = 0;
            var TemplateID = 0;
            string notalert = string.Empty;
            if (ent.CurrentWorkFlowId == 247 || ent.CurrentWorkFlowId == 309)
            {
                NotiToId = ent.EngineerId.Value;
                TemplateID = 4;
                notalert = ent.AssetNo + " " + "Asset Tracker has been approved";
            }

            else if (ent.CurrentWorkFlowId == 246)
            {
                NotiToId = ent.EngineerId.Value;
                TemplateID = 16;
                notalert = ent.AssetNo + " " + "Asset Tracker has been requested";
            }

            else if (ent.CurrentWorkFlowId == 248)
            {
                NotiToId = ent.EngineerId.Value;
                TemplateID = 20;
                notalert = ent.AssetNo + " " + "Asset Tracker has been rejected";
            }

            parameters.Add("@pNotificationId", Convert.ToString(ent.NotificationId));
            parameters.Add("@pCustomerId", Convert.ToString(_UserSession.CustomerId));
            parameters.Add("@pFacilityId", Convert.ToString(_UserSession.FacilityId));
            parameters.Add("@pUserId", Convert.ToString(NotiToId));
            parameters.Add("@pNotificationAlerts", Convert.ToString(notalert));
            parameters.Add("@pRemarks", Convert.ToString(""));

            parameters.Add("@pHyperLink", Convert.ToString(Hyplink));

            parameters.Add("@pIsNew", Convert.ToString(1));
            parameters.Add("@pNotificationDateTime", Convert.ToString(null));

            parameters.Add("@pEmailTempId", Convert.ToString(TemplateID));



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
        private void SendMail(PorteringModel model)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());
            try
            {
                string emailTemplateId = string.Empty;
                string subject = string.Empty;
                string subjectVars = string.Empty;
                string templateVars = string.Empty;
                string email = string.Empty;
                string VendorEmail = string.Empty;
                if (model.MovementCategory == 242)
                {
                    var obj = GetVendorInfo((int)model.SupplierLovId, (int)model.AssetId);

                    if (obj != null && obj.VendorNameLovs != null && obj.VendorNameLovs.Count > 0)
                    {
                        var list = obj.VendorNameLovs;
                        VendorEmail = list[0].Email;
                    }

                }


                if (model.CurrentWorkFlowId == 247)
                {
                    emailTemplateId = "4";
                    //  var obj = Get(model.PorteringId);
                    var obj = new PorteringLocation();
                    obj = GetLocationToIds(model.PorteringId, 2); // approval
                    if (obj != null)
                    {
                        email = obj.Email;

                        if (!string.IsNullOrEmpty(obj.RequestorEmail))
                        {
                            email = string.Join(",", email, obj.RequestorEmail);
                        }


                        templateVars = string.Join(",", obj.AssetNo, "UETrack");
                    }
                }
                else if (model.CurrentWorkFlowId == 246)
                {
                    emailTemplateId = "16";
                    var obj = new PorteringLocation();
                    obj = GetLocationToIds(model.PorteringId, 1);

                    if (obj != null)
                    {
                        email = obj.Email;
                        if (!string.IsNullOrEmpty(obj.RequestorEmail))
                        {
                            email = string.Join(",", email, obj.RequestorEmail);
                        }
                        templateVars = string.Join(",", obj.AssetNo, "UETrack");
                    }


                }
                else if (model.CurrentWorkFlowId == 248) // rejected
                {
                    emailTemplateId = "20";
                    //  var obj = Get(model.PorteringId);
                    var obj = new PorteringLocation();
                    obj = GetLocationToIds(model.PorteringId, 2); // approval
                    if (obj != null)
                    {
                        email = obj.Email;
                        templateVars = string.Join(",", obj.AssetNo, "UETrack");
                    }
                }

                if (model.MovementCategory == 242 && !string.IsNullOrEmpty(VendorEmail))
                {
                    email = string.Join(",", email, VendorEmail);
                }


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
                var dbAccessDAL = new DBAccessDAL();
                DataTable dt = dbAccessDAL.GetDataTable("uspFM_EmailNotify_Save", parameters, DataSetparameters);
                if (dt != null)
                {
                    foreach (DataRow rows in dt.Rows)
                    {


                    }
                }
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

        public static PorteringLocation GetLocationToIds(int PorteringId, int status)
        {

            try
            {
                string Email = string.Empty;
                var obj = new PorteringLocation();
                var DataSetparameters = new Dictionary<string, DataTable>();
                DataTable TypecodeDt = new DataTable();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pPorteringId", Convert.ToString(PorteringId));
                parameters.Add("@pStatus", Convert.ToString(status));
                var dbAccessDAL = new DBAccessDAL();
                DataTable dt = dbAccessDAL.GetDataTable("uspFM_GetAssetLocationInchageMail_Get", parameters, DataSetparameters);
                if (dt != null && dt.Rows.Count > 0)
                {
                    if (status == 1)
                    {
                        obj.Email = Convert.ToString(dt.Rows[0]["Email"]);
                        obj.PorteringDate = Convert.ToDateTime(dt.Rows[0]["PorteringDate"]);
                        obj.PorteringNo = Convert.ToString(dt.Rows[0]["PorteringNo"]);
                        obj.AssetNo = Convert.ToString(dt.Rows[0]["AssetNo"]);
                        obj.RequestorEmail = Convert.ToString(dt.Rows[0]["RequestorEmail"]);


                    }
                    else if (status == 2)
                    {
                        obj.RequestorName = Convert.ToString(dt.Rows[0]["StaffName"]);
                        obj.AssetNo = Convert.ToString(dt.Rows[0]["AssetNo"]);
                        obj.WFStatusApprovedDate = dt.Rows[0]["WFStatusApprovedDate"] != DBNull.Value ? (Convert.ToDateTime(dt.Rows[0]["WFStatusApprovedDate"])) : (DateTime?)null;
                        obj.Email = Convert.ToString(dt.Rows[0]["Email"]);
                        obj.RequestorEmail = Convert.ToString(dt.Rows[0]["RequestorEmail"]);
                    }

                }



                return obj;
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

        public PorteringLovs GetVendorInfo(int SupplierCategoryid, int AssetId)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
                var warrantyProvider = new AssetRegisterWarrantyProvider();
                var Lovs = new PorteringLovs();
                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_EngAssetSupplierWarranty_GetByAssetId";
                        cmd.Parameters.AddWithValue("@pAssetId", AssetId);
                        //cmd.Parameters.AddWithValue("@pLovIdSupplierCategory", warrantyProvider.CategoryId);
                        cmd.Parameters.AddWithValue("@pPageIndex", 1);
                        cmd.Parameters.AddWithValue("@pPageSize", 5);
                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }

                if (ds != null)
                {
                    var table = new DataTable();
                    if (SupplierCategoryid == 13)
                    {
                        if (ds.Tables[0] != null && ds.Tables[0].Rows.Count > 0)
                        {
                            table = ds.Tables[0];
                        }
                    }
                    else if (SupplierCategoryid == 14)
                    {
                        if (ds.Tables[1] != null && ds.Tables[1].Rows.Count > 0)
                        {
                            table = ds.Tables[1];
                        }
                    }

                    else if (SupplierCategoryid == 15)
                    {
                        if (ds.Tables[2] != null && ds.Tables[2].Rows.Count > 0)
                        {
                            table = ds.Tables[2];
                        }
                    }

                    if (table != null && table.Rows.Count > 0)
                    {
                        var list = (from n in table.AsEnumerable()
                                    select new AssetTrackerLov
                                    {
                                        LovId = Convert.ToInt32(n["ContractorId"]),
                                        FieldValue = Convert.ToString(n["ContractorName"]),
                                        Email = Convert.ToString(n["Email"]),
                                    }).ToList();

                        if (list != null && list.Count > 0)
                        {
                            Lovs.VendorNameLovs = list;
                        }

                    }
                }

                Log4NetLogger.LogExit(_FileName, nameof(Load), Level.Info.ToString());
                return Lovs;
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

        public PorteringModel GetLoanerBookingRecord(int Id)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
            try
            {
                var dbAccessDAL = new DBAccessDAL();
                var obj = new PorteringModel();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pLoanerTestEquipmentBookingId", Id.ToString());
                DataSet ds = dbAccessDAL.GetDataSet("uspFM_ConvertBookingToPortering_GetById", parameters, DataSetparameters);
                if (ds != null)
                {
                    if (ds.Tables[0] != null && ds.Tables[0].Rows.Count > 0)
                    {
                        obj.FromCustomerId = Convert.ToInt16(ds.Tables[0].Rows[0]["FromCustomerId"]);
                        obj.FromFacilityId = Convert.ToInt16(ds.Tables[0].Rows[0]["FromFacilityId"]);
                        obj.FromBlockId = Convert.ToInt16(ds.Tables[0].Rows[0]["FromBlockId"]);
                        obj.FromLevelId = Convert.ToInt16(ds.Tables[0].Rows[0]["FromLevelId"]);
                        obj.FromUserAreaId = Convert.ToInt16(ds.Tables[0].Rows[0]["FromUserAreaId"]);
                        obj.FromUserLocationId = Convert.ToInt16(ds.Tables[0].Rows[0]["FromUserLocationId"]);
                        obj.FacilityName = Convert.ToString(ds.Tables[0].Rows[0]["FromFacilityName"]);
                        obj.BlockName = Convert.ToString(ds.Tables[0].Rows[0]["fromBlockName"]);
                        obj.LevelName = Convert.ToString(ds.Tables[0].Rows[0]["FromLevelName"]);
                        obj.UserAreaName = Convert.ToString(ds.Tables[0].Rows[0]["FromUserAreaName"]);
                        obj.UserLocationName = Convert.ToString(ds.Tables[0].Rows[0]["FromUserLocationName"]);
                        obj.RequestorId = Convert.ToInt32(ds.Tables[0].Rows[0]["RequestorId"]);
                        obj.RequestorName = Convert.ToString(ds.Tables[0].Rows[0]["RequestorName"]);
                        obj.Position = Convert.ToString(ds.Tables[0].Rows[0]["Designation"]);
                        //////obj.RequestTypeLovId = Convert.ToInt32(ds.Tables[0].Rows[0]["RequestTypeLovId"]);
                        obj.MovementCategory = ds.Tables[0].Rows[0]["MovementCategory"] != DBNull.Value ? Convert.ToInt16(ds.Tables[0].Rows[0]["MovementCategory"]) : (int?)null;

                        obj.ToFacilityId = ds.Tables[0].Rows[0]["ToFacilityId"] != DBNull.Value ? Convert.ToInt16(ds.Tables[0].Rows[0]["ToFacilityId"]) : (int?)null;
                        obj.ToCustomerId = ds.Tables[0].Rows[0]["ToCustomerId"] != DBNull.Value ? Convert.ToInt16(ds.Tables[0].Rows[0]["ToCustomerId"]) : (int?)null;
                        obj.ToBlockId = ds.Tables[0].Rows[0]["ToBlockId"] != DBNull.Value ? Convert.ToInt16(ds.Tables[0].Rows[0]["ToBlockId"]) : (int?)null;
                        obj.ToLevelId = ds.Tables[0].Rows[0]["ToLevelId"] != DBNull.Value ? Convert.ToInt16(ds.Tables[0].Rows[0]["ToLevelId"]) : (int?)null;
                        obj.ToUserAreaId = ds.Tables[0].Rows[0]["ToUserAreaId"] != DBNull.Value ? Convert.ToInt16(ds.Tables[0].Rows[0]["ToUserAreaId"]) : (int?)null;
                        obj.ToUserLocationId = ds.Tables[0].Rows[0]["ToUserLocationId"] != DBNull.Value ? Convert.ToInt16(ds.Tables[0].Rows[0]["ToUserLocationId"]) : (int?)null;
                        obj.AssetId = Convert.ToInt32(ds.Tables[0].Rows[0]["AssetId"]);
                        obj.AssetNo = Convert.ToString(ds.Tables[0].Rows[0]["AssetNo"]);
                        obj.WorkOrderId = ds.Tables[0].Rows[0]["WorkOrderId"] != DBNull.Value ? (Convert.ToInt32(ds.Tables[0].Rows[0]["WorkOrderId"])) : (int?)null;
                        obj.WorkOrderNo = Convert.ToString(ds.Tables[0].Rows[0]["MaintenanceWorkNo"]);
                        obj.ToBlockCode = Convert.ToString(ds.Tables[0].Rows[0]["ToBlockCode"]);
                        obj.ToBlockName = Convert.ToString(ds.Tables[0].Rows[0]["ToBlockName"]);
                        obj.ToLevelCode = Convert.ToString(ds.Tables[0].Rows[0]["ToLevelCode"]);
                        obj.ToLevelName = Convert.ToString(ds.Tables[0].Rows[0]["ToLevelName"]);
                        obj.ToUserAreaCode = Convert.ToString(ds.Tables[0].Rows[0]["ToUserAreaCode"]);
                        obj.ToUserAreaName = Convert.ToString(ds.Tables[0].Rows[0]["ToUserAreaName"]);
                        obj.ToUserLocationCode = Convert.ToString(ds.Tables[0].Rows[0]["ToUserLocationCode"]);
                        obj.ToUserLocationName = Convert.ToString(ds.Tables[0].Rows[0]["ToUserLocationName"]);
                        obj.LoanerTestEquipmentBookingId = ds.Tables[0].Rows[0]["LoanerTestEquipmentBookingId"] != DBNull.Value ? (Convert.ToInt32(ds.Tables[0].Rows[0]["LoanerTestEquipmentBookingId"])) : (int?)null;

                    }


                    if (ds.Tables[1] != null && ds.Tables[1].Rows.Count > 0)
                    {
                        obj.ToFacilityLovs = dbAccessDAL.GetLovRecords(ds.Tables[1], "MstLocationFacility");
                        //obj.ToBlockLovs = dbAccessDAL.GetLovRecords(ds.Tables[1], "MstLocationBlock");
                        //obj.ToLevelLovs = dbAccessDAL.GetLovRecords(ds.Tables[1], "MstLocationLevel");
                        //obj.ToUserAreaLovs = dbAccessDAL.GetLovRecords(ds.Tables[1], "MstLocationUserArea");
                        //obj.ToUserLocationLovs = dbAccessDAL.GetLovRecords(ds.Tables[1], "MstLocationUserLocation");
                    }
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
                throw;
            }
        }


    }
}
