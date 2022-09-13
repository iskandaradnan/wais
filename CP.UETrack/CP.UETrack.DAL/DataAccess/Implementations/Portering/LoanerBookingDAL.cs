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

namespace CP.UETrack.DAL.DataAccess.Implementations.Portering
{
    public class LoanerBookingDAL : ILoanerBookingDAL
    {
        private readonly string _FileName = nameof(PorteringDAL);
        readonly UserDetailsModel _UserSession = new SessionHelper().UserSession();
        public void Delete(int Id, out string ErrorMessage)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Delete), Level.Info.ToString());
            try
            {
                ErrorMessage = string.Empty;
                var dbAccessDAL = new DBAccessDAL();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pLoanerTestEquipmentBookingId", Id.ToString());
                DataTable dt = dbAccessDAL.GetDataTable("uspFM_EngLoanerTestEquipmentBookingTxn_Delete", parameters, DataSetparameters);
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

        public LoanerBooking GetBookingDates(int Id)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
            try
            {
                var dbAccessDAL = new DBAccessDAL();
                var obj = new LoanerBooking();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pAssetId", Id.ToString());
                DataSet ds = dbAccessDAL.GetDataSet("UspFM_EngLoanerTestEquipmentBookingTxn_GetBooking", parameters, DataSetparameters);
                if (ds != null)
                {
                    if (ds.Tables[0] != null && ds.Tables[0].Rows.Count > 0)
                    {
                        obj.AssetFacilityId = Convert.ToInt16(ds.Tables[0].Rows[0]["FacilityId"]);
                    }

                    if (ds.Tables[1] != null && ds.Tables[1].Rows.Count > 0)
                    {
                        var list = (from n in ds.Tables[1].AsEnumerable()
                                    select new AssetBookingDate
                                    {
                                        BookingStartFrom = n.Field<DateTime>("BookingStartFrom"),
                                        BookingEnd = n.Field<DateTime>("BookingEnd"),
                                        LoanerTestEquipmentBookingId = n.Field<int>("LoanerTestEquipmentBookingId"),

                                    }).ToList();

                        if (list != null && list.Count > 0)
                        {
                            obj.AssetBookingDateList = list;
                            List<DateTime> dat = new List<DateTime>();

                            foreach (var item in list)
                            {
                                var count = (item.BookingEnd.Date - item.BookingStartFrom.Date).TotalDays;
                                DateTime startdate = item.BookingStartFrom;
                                for (int i = 0; i <= count; i++)
                                {
                                    dat.Add(startdate.AddDays(i));
                                }
                            }

                            obj.BookedDateList = dat;
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
        public LoanerBooking Get(int Id)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
            try
            {
                var dbAccessDAL = new DBAccessDAL();
                var obj = new LoanerBooking();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pLoanerTestEquipmentBookingId", Id.ToString());
                DataSet ds = dbAccessDAL.GetDataSet("UspFM_EngLoanerTestEquipmentBookingTxn_GetById", parameters, DataSetparameters);
                if (ds != null)
                {
                    if (ds.Tables[0] != null && ds.Tables[0].Rows.Count > 0)
                    {

                        obj.LoanerTestEquipmentBookingId = Convert.ToInt32(ds.Tables[0].Rows[0]["LoanerTestEquipmentBookingId"]);
                        obj.AssetId = Convert.ToInt32(ds.Tables[0].Rows[0]["AssetId"]);
                        obj.FacilityName = Convert.ToString(ds.Tables[0].Rows[0]["FacilityName"]);
                        obj.BookingStartFrom = Convert.ToDateTime(ds.Tables[0].Rows[0]["BookingStartFrom"]);
                        obj.BookingEnd = Convert.ToDateTime(ds.Tables[0].Rows[0]["BookingEnd"]);
                        obj.MovementCategory = Convert.ToInt32(ds.Tables[0].Rows[0]["MovementCategory"]);
                        obj.ToFacilityId = Convert.ToInt32(ds.Tables[0].Rows[0]["ToFacility"]);
                        obj.ToBlockId = Convert.ToInt32(ds.Tables[0].Rows[0]["ToBlock"]);
                        obj.ToLevelId = Convert.ToInt32(ds.Tables[0].Rows[0]["ToLevel"]);
                        obj.ToUserAreaId = Convert.ToInt32(ds.Tables[0].Rows[0]["ToUserArea"]);
                        obj.ToUserLocationId = Convert.ToInt32(ds.Tables[0].Rows[0]["ToUserLocation"]);

                        obj.RequestorId = Convert.ToInt32(ds.Tables[0].Rows[0]["RequestorId"]);
                        obj.RequestorName = Convert.ToString(ds.Tables[0].Rows[0]["RequestorName"]);
                        obj.Position = Convert.ToString(ds.Tables[0].Rows[0]["Designation"]);
                        obj.RequestType = Convert.ToInt32(ds.Tables[0].Rows[0]["RequestType"]);
                        obj.BookingStatus = Convert.ToInt32(ds.Tables[0].Rows[0]["BookingStatus"]);
                        obj.Timestamp = Convert.ToBase64String((byte[])(ds.Tables[0].Rows[0]["Timestamp"]));
                        obj.AssetNo = Convert.ToString(ds.Tables[0].Rows[0]["AssetNo"]);
                        obj.WorkOrderId = ds.Tables[0].Rows[0]["WorkOrderId"] != DBNull.Value ? (Convert.ToInt32(ds.Tables[0].Rows[0]["WorkOrderId"])) : (int?)null;
                        obj.WorkOrderNo = Convert.ToString(ds.Tables[0].Rows[0]["MaintenanceWorkNo"]);
                        obj.IsExtension = Convert.ToBoolean(ds.Tables[0].Rows[0]["IsExtension"]);
                        obj.IsPorteringDone = Convert.ToBoolean(ds.Tables[0].Rows[0]["IsProteringDone"]);
                        obj.HiddenId = Convert.ToString((ds.Tables[0].Rows[0]["GuId"]));


                        obj.BlockCode = Convert.ToString(ds.Tables[0].Rows[0]["BlockCode"]);
                        obj.BlockName = Convert.ToString(ds.Tables[0].Rows[0]["BlockName"]);
                        obj.LevelCode = Convert.ToString(ds.Tables[0].Rows[0]["LevelCode"]);
                        obj.LevelName = Convert.ToString(ds.Tables[0].Rows[0]["LevelName"]);
                        obj.UserAreaCode = Convert.ToString(ds.Tables[0].Rows[0]["UserAreaCode"]);
                        obj.UserAreaName = Convert.ToString(ds.Tables[0].Rows[0]["UserAreaName"]);
                        obj.UserLocationCode = Convert.ToString(ds.Tables[0].Rows[0]["UserLocationCode"]);
                        obj.UserLocationName = Convert.ToString(ds.Tables[0].Rows[0]["UserLocationName"]);
                        obj.LocationInchargeId = ds.Tables[0].Rows[0]["LocationInchargeId"] != DBNull.Value ? (Convert.ToInt32(ds.Tables[0].Rows[0]["LocationInchargeId"])) : (int?)null;
                        obj.CurrentLoginId = _UserSession.UserId; 
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
                    Lovs.PorteringStatusLovs = dbAccessDAL.GetLovRecords(ds.Tables[0], "PorterWFStatusValue");
                    Lovs.MovementCategoryLovs = Lovs.MovementCategoryLovs.Where(x => x.LovId == 239 || x.LovId == 240).ToList();

                }

                var curentDate = DateTime.Now;
                var date = curentDate.Date;

                Lovs.CurrentDate = date;
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
                Lovs.ToFacilityId = _UserSession.FacilityId;
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

        public LoanerBooking Save(LoanerBooking model, out string ErrorMessage)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());
            try
            {
                var isApproved = (model.BookingStatus == 247 || model.BookingStatus == 248) ? true : false;

                ErrorMessage = string.Empty;
                var comrepid = model.CompanyRepId;
                var CompanyRepEmail = model.CompanyRepEmail;

                var DataSetparameters = new Dictionary<string, DataTable>();
                DataTable TypecodeDt = new DataTable();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pLoanerTestEquipmentBookingId", Convert.ToString(model.LoanerTestEquipmentBookingId));
                parameters.Add("@pCustomerId", Convert.ToString(_UserSession.CustomerId));
                parameters.Add("@pFacilityId", Convert.ToString(_UserSession.FacilityId));
                parameters.Add("@pServiceId", Convert.ToString(2));
                parameters.Add("@pWorkOrderId", Convert.ToString(model.WorkOrderId));
                parameters.Add("@pAssetId", Convert.ToString(model.AssetId));
                parameters.Add("@pBookingStartFrom", model.BookingStartFrom != null ? model.BookingStartFrom.ToString("yyyy-MM-dd") : null);
                parameters.Add("@pBookingEnd", model.BookingEnd != null ? model.BookingEnd.ToString("yyyy-MM-dd") : null);
                parameters.Add("@pMovementCategory", Convert.ToString(model.MovementCategory));
                parameters.Add("@pToFacility", Convert.ToString(model.ToFacilityId));
                parameters.Add("@pToBlock", Convert.ToString(model.ToBlockId));
                parameters.Add("@pToLevel", Convert.ToString(model.ToLevelId));
                parameters.Add("@pToUserArea", Convert.ToString(model.ToUserAreaId));
                parameters.Add("@pToUserLocation", Convert.ToString(model.ToUserLocationId));
                parameters.Add("@pRequestorId", Convert.ToString(model.RequestorId));
                parameters.Add("@pBookingStatus", Convert.ToString(model.BookingStatus));
                parameters.Add("@pUserId", Convert.ToString(_UserSession.UserId));
                parameters.Add("@pTimestamp", Convert.ToString(model.Timestamp));
                parameters.Add("@pRequestType", Convert.ToString(model.RequestType));


                var dbAccessDAL = new DBAccessDAL();
                DataTable dt = dbAccessDAL.GetDataTable("uspFM_EngLoanerTestEquipmentBookingTxn_Save", parameters, DataSetparameters);
                if (dt != null)
                {
                    foreach (DataRow rows in dt.Rows)
                    {
                        model.LoanerTestEquipmentBookingId = Convert.ToInt32(rows["LoanerTestEquipmentBookingId"]);
                        ErrorMessage = Convert.ToString(rows["ErrorMessage"]);
                        model.HiddenId = Convert.ToString(rows["GuId"]);
                        model.CreatedBy = Convert.ToInt32(rows["CreatedBy"]);
                        if (ErrorMessage == ""  )                        {
                            model.CompanyRepId = comrepid;
                            model.CompanyRepEmail = CompanyRepEmail;
                            SendMail(model);
                            updateNotificationSingle(model);
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

        public LoanerBooking updateNotificationSingle(LoanerBooking ent)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());
            LoanerBooking griddata = new LoanerBooking();
            var dbAccessDAL = new DBAccessDAL();
            var parameters = new Dictionary<string, string>();
            var DataSetparameters = new Dictionary<string, DataTable>();
            var Hyplink = "/bems/booking?id=" + ent.LoanerTestEquipmentBookingId;
            var allIds = ent.CompanyRepId + "," + ent.CreatedBy;
            var TemplateID = 0;
            string notalert = string.Empty;
            if (ent.BookingStatus == 246)
            {
                TemplateID = 80;
                notalert = ent.AssetNo + " " + "Loaner / Test Equipment No. Booking has been Requested";
            }
            else if (ent.BookingStatus == 309)
            {
                TemplateID = 81;
                notalert = ent.AssetNo + " " + "Loaner / Test Equipment No. Booking has been Verified";
            }
            else if (ent.BookingStatus == 247)
            {
                TemplateID = 24;
                notalert = ent.AssetNo + " " + "Loaner / Test Equipment No. Booking has been Approved";
            }            
            else if (ent.BookingStatus == 248)
            {
                TemplateID = 72;
                notalert = ent.AssetNo + " " + "Loaner / Test Equipment No. Booking has been rejected";
            }
                
            parameters.Add("@pNotificationId", Convert.ToString(ent.NotificationId));
            parameters.Add("@pCustomerId", Convert.ToString(_UserSession.CustomerId));
            parameters.Add("@pFacilityId", Convert.ToString(_UserSession.FacilityId));
            parameters.Add("@pUserId", Convert.ToString(0));
            parameters.Add("@pNotificationAlerts", Convert.ToString(notalert));
            parameters.Add("@pRemarks", Convert.ToString(""));
            parameters.Add("@pHyperLink", Convert.ToString(Hyplink));
            parameters.Add("@pIsNew", Convert.ToString(1));
            parameters.Add("@pNotificationDateTime", Convert.ToString(null));
            parameters.Add("@pMultipleUserIds", Convert.ToString(allIds));
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
        private void SendMail(LoanerBooking model)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(SendMail), Level.Info.ToString());
            try
            {
                string emailTemplateId = string.Empty;
                string subject = string.Empty;
                string subjectVars = string.Empty;
                string templateVars = string.Empty;
                string email = string.Empty;
                string AssetNo = string.Empty;
                var dbAccessDAL = new DBAccessDAL();
                var emailid = model.CompanyRepEmail;

                
                if (model.BookingStatus == 246 ||model.BookingStatus == 247 || model.BookingStatus == 248 || model.BookingStatus == 309)
                {
                    if (model.BookingStatus == 246)
                    {
                        emailTemplateId = "80";
                    }
                    else if (model.BookingStatus == 247)
                    {
                        emailTemplateId = "24";

                    }
                    else if (model.BookingStatus == 309)
                    {
                        emailTemplateId = "81";

                    }
                    else if (model.BookingStatus == 248)
                    {
                        emailTemplateId = "72";
                    }
                        
                    var DataSetparameters1 = new Dictionary<string, DataTable>();
                    var parameters1 = new Dictionary<string, string>();
                    parameters1.Add("@pAssetId", Convert.ToString(model.AssetId));
                    parameters1.Add("@pRequestorId", Convert.ToString(model.RequestorId));
                    parameters1.Add("@pLoanerTestEquipmentBookingId", Convert.ToString(model.LoanerTestEquipmentBookingId));
                    DataSet ds = dbAccessDAL.GetDataSet("uspFM_AssetCompanyStaff_Fetch", parameters1, DataSetparameters1);
                    if (ds != null)
                    {

                        if (ds.Tables[0] != null && ds.Tables[0].Rows.Count > 0)
                        {
                            foreach (DataRow rows in ds.Tables[0].Rows)
                            {
                                email = Convert.ToString(rows["Email"]);
                                AssetNo = Convert.ToString(rows["AssetNo"]);
                                templateVars = AssetNo;
                            }
                        }
                        if (ds.Tables[1] != null && ds.Tables[1].Rows.Count > 0)
                        {
                            foreach (DataRow rows in ds.Tables[1].Rows)
                            {
                                var requestorEmail = Convert.ToString(rows["Email"]);

                                if (!string.IsNullOrEmpty(requestorEmail))
                                {
                                    email = string.Join(",", email, requestorEmail);

                                }

                            }

                        }
                    }
                }
                if (!string.IsNullOrEmpty(email))
                {
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
                    DataTable dt = dbAccessDAL.GetDataTable("uspFM_EmailNotify_Save", parameters, DataSetparameters);
                    if (dt != null)
                    {
                        foreach (DataRow rows in dt.Rows)
                        {
                        }
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
    }


}
