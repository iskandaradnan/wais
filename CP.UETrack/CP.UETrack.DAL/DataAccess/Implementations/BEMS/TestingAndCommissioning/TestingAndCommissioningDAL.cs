using CP.UETrack.Model;
using System;
using System.Linq;
using CP.Framework.Common.Logging;
using CP.Framework.Common.ExceptionHandler.ExceptionWrappers;
using System.Data;
using System.Data.SqlClient;
using UETrack.DAL;
using CP.UETrack.DAL.DataAccess.Implementation;
using System.Collections.Generic;
using CP.UETrack.Model.Enum;
using CP.UETrack.DAL.Helper;
using System.Configuration;
using CP.UETrack.DAL.DataAccess.Contracts;

namespace CP.UETrack.DAL.DataAccess
{
    public class TestingAndCommissioningDAL : ITestingAndCommissioningDAL
    {
        private readonly string _FileName = nameof(TestingAndCommissioningDAL);
        readonly UserDetailsModel _UserSession = new SessionHelper().UserSession();
        int mastercrmID;
        private IEmailDAL _EmailDAL;
        public TestingAndCommissioningDAL()
        {
            _EmailDAL = new EmailDAL();
        }
        public TestingAndCommissioningLovs Load()
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
                TestingAndCommissioningLovs testingAndCommissioningLovs = null;

                var ds = new DataSet();
                var ds1 = new DataSet();

                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_Dropdown_Others";
                        cmd.Parameters.AddWithValue("@pLovKey", "");
                        cmd.Parameters.AddWithValue("@pTableName", "Service");

                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);

                        var da1 = new SqlDataAdapter();
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_Dropdown";
                        cmd.Parameters.Clear();
                        cmd.Parameters.AddWithValue("@pLovKey", "TCTypeValue,VariationStatusValue,YesNoValue,TCStatusValue,/*TypeOfService*/,BatchNo");
                        da1.SelectCommand = cmd;
                        da1.Fill(ds1);
                    }
                }
                testingAndCommissioningLovs = new TestingAndCommissioningLovs();
                if (ds.Tables.Count != 0)
                {
                    var serviceLovs = dbAccessDAL.GetLovRecords(ds.Tables[0]);
                    testingAndCommissioningLovs.Services = serviceLovs.Where(x => x.LovId == 2).ToList();
                }
                if (ds1.Tables.Count != 0)
                {

                    testingAndCommissioningLovs.TAndCTypes = dbAccessDAL.GetLovRecords(ds1.Tables[0], "TCTypeValue");
                    var variationStatus = dbAccessDAL.GetLovRecords(ds1.Tables[0], "VariationStatusValue");
                   // var variationIds = new List<int> { 1509, 1510, 1511, 1512, 1513 };
                   // testingAndCommissioningLovs.VariationStatus = variationStatus.Where(x => variationIds.Contains(x.LovId)).ToList();
                    testingAndCommissioningLovs.VariationStatus = variationStatus;
                    testingAndCommissioningLovs.YesNoValues = dbAccessDAL.GetLovRecords(ds1.Tables[0], "YesNoValue");
                    testingAndCommissioningLovs.TAndCStatusValues = dbAccessDAL.GetLovRecords(ds1.Tables[0], "TCStatusValue");
                    //testingAndCommissioningLovs.TypeOfService = dbAccessDAL.GetLovRecords(ds1.Tables[0], "TypeOfService");
                    testingAndCommissioningLovs.BatchNo = dbAccessDAL.GetLovRecords(ds1.Tables[0], "BatchNo");
                }
                testingAndCommissioningLovs.IsAdditionalFieldsExist = IsAdditionalFieldsExist();
                Log4NetLogger.LogExit(_FileName, nameof(Load), Level.Info.ToString());
                return testingAndCommissioningLovs;
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
                        cmd.Parameters.AddWithValue("@pScreenNameLovId", (int)ConfigScreenNameValue.TestingAndCommissioning);
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
        public TestingAndCommissioning Save(TestingAndCommissioning testingAndCommissioning, out string ErrorMessage)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());

                ErrorMessage = string.Empty;
                var ds = new DataSet();
                var MdbAccessDAL = new MASTERDBAccessDAL();
                var dbAccessDAL = new DBAccessDAL();
                var crmReqNo = testingAndCommissioning.CRMRequestNo;
                var crmReqId = testingAndCommissioning.CRMRequestId;
                var RequesterId = testingAndCommissioning.CRMRequesterId;
                var reqEmail = testingAndCommissioning.RequesterEmail;

                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_EngTestingandCommissioningTxn_Save";

                        SqlParameter parameter = new SqlParameter();
                        cmd.Parameters.AddWithValue("@pTestingandCommissioningId", testingAndCommissioning.TestingandCommissioningId);
                        if (testingAndCommissioning.TestingandCommissioningId == 0)
                        {
                            cmd.Parameters.AddWithValue("@pCustomerId", _UserSession.CustomerId);
                            cmd.Parameters.AddWithValue("@pFacilityId", _UserSession.FacilityId);

                        }
                        else
                        {
                            cmd.Parameters.AddWithValue("@pTimestamp", Convert.FromBase64String(testingAndCommissioning.Timestamp));
                        }

                        cmd.Parameters.AddWithValue("@pServiceId", testingAndCommissioning.ServiceId);

                        cmd.Parameters.AddWithValue("@pRequestDate", testingAndCommissioning.RequestDate);
                        cmd.Parameters.AddWithValue("@pTandCDate", testingAndCommissioning.TandCDate);
                        cmd.Parameters.AddWithValue("@pAssetCategoryLovId", testingAndCommissioning.AssetCategoryLovId);
                        cmd.Parameters.AddWithValue("@pCRMRequestId", testingAndCommissioning.CRMRequestId);

                        cmd.Parameters.AddWithValue("@pAssetTypeCodeId", testingAndCommissioning.AssetTypeCodeId);
                        cmd.Parameters.AddWithValue("@pTandCStatus", testingAndCommissioning.TandCStatus);
                        cmd.Parameters.AddWithValue("@pRequiredCompletionDate", testingAndCommissioning.RequiredCompletionDate);

                        cmd.Parameters.AddWithValue("@pModelId", testingAndCommissioning.ModelId);
                        cmd.Parameters.AddWithValue("@pManufacturerId", testingAndCommissioning.ManufacturerId);
                        cmd.Parameters.AddWithValue("@pSerialNo", testingAndCommissioning.SerialNo);
                        cmd.Parameters.AddWithValue("@pAssetNoOld", testingAndCommissioning.AssetNoOld);
                        cmd.Parameters.AddWithValue("@pUserLocationId", testingAndCommissioning.UserLocationId);
                        cmd.Parameters.AddWithValue("@pUserAreaId", testingAndCommissioning.UserAreaId);

                        cmd.Parameters.AddWithValue("@pTandCCompletedDate", testingAndCommissioning.TandCCompletedDate);
                        cmd.Parameters.AddWithValue("@pHandoverDate", testingAndCommissioning.HandoverDate);
                        cmd.Parameters.AddWithValue("@pVariationStatus", testingAndCommissioning.VariationStatus);
                        cmd.Parameters.AddWithValue("@pTandCContractorRepresentative", testingAndCommissioning.TandCContractorRepresentative);
                        cmd.Parameters.AddWithValue("@pFmsCustomerRepresentativeId", testingAndCommissioning.FmsCustomerRepresentativeId);
                        cmd.Parameters.AddWithValue("@pFmsFacilityRepresentativeId", testingAndCommissioning.FmsFacilityRepresentativeId);
                        cmd.Parameters.AddWithValue("@pRemarks", testingAndCommissioning.Remarks);

                        //cmd.Parameters.AddWithValue("@pTypeOfService", testingAndCommissioning.TypeOfService);
                        cmd.Parameters.AddWithValue("@pBatchNo", testingAndCommissioning.BatchNo);

                        cmd.Parameters.AddWithValue("@pStatus", testingAndCommissioning.Status);
                        cmd.Parameters.AddWithValue("@pUserId", _UserSession.UserId);

                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);

                        if (testingAndCommissioning.TandCStatus==72)
                        {
                            DataSet dssub = new DataSet();
                            var da1 = new SqlDataAdapter();
                            cmd.CommandText = "uspFM_Get_Master_CRMID_BY_TestingandCommissioningIds";
                            SqlParameter parameters = new SqlParameter();
                            cmd.Parameters.Clear();
                            cmd.Parameters.AddWithValue("@pTestingandCommissioningId", testingAndCommissioning.TestingandCommissioningId);
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
                    }
                }
                if (testingAndCommissioning.TandCStatus == 72)
                {
                    using (SqlConnection con = new SqlConnection(MdbAccessDAL.ConnectionString))
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
                    }
                }
                else
                {
                }
                    if (ds.Tables.Count != 0 && ds.Tables[0].Rows.Count > 0)
                {
                    testingAndCommissioning.TestingandCommissioningId = Convert.ToInt32(ds.Tables[0].Rows[0]["TestingandCommissioningId"]);
                    testingAndCommissioning.Timestamp = Convert.ToBase64String((byte[])(ds.Tables[0].Rows[0]["Timestamp"]));
                    ErrorMessage = Convert.ToString(ds.Tables[0].Rows[0]["ErrorMessage"]);
                    testingAndCommissioning.TandCDocumentNo = Convert.ToString(ds.Tables[0].Rows[0]["TandCDocumentNo"]);
                    testingAndCommissioning.AssetPreRegistrationNo = Convert.ToString(ds.Tables[0].Rows[0]["AssetPreRegistrationNo"]);
                    testingAndCommissioning.StatusName = Convert.ToString(ds.Tables[0].Rows[0]["StatusName"]);
                    testingAndCommissioning.HiddenId = Convert.ToString(ds.Tables[0].Rows[0]["GuId"]);

                    testingAndCommissioning.CRMRequestId = crmReqId;
                    testingAndCommissioning.CRMRequestNo = crmReqNo;
                    testingAndCommissioning.CRMRequesterId = RequesterId;
                    testingAndCommissioning.RequesterEmail = reqEmail;
                    if (testingAndCommissioning.Status == 286)
                    {
                        var requesterUserId = 0;
                        var requesterEmailId = GetRequesterEmailId(testingAndCommissioning.TestingandCommissioningId, out requesterUserId);
                        _EmailDAL.SendTandCSubmittedEMail(testingAndCommissioning.TandCDocumentNo, requesterEmailId);
                        updateNotificationSingle(testingAndCommissioning.TestingandCommissioningId, testingAndCommissioning.TandCDocumentNo, 286, requesterUserId);
                        SendMailCRM(testingAndCommissioning);
                    }
                }

                Log4NetLogger.LogExit(_FileName, nameof(Save), Level.Info.ToString());
                return testingAndCommissioning;
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
        private void updateNotificationSingle(int TestingAndCommissioningId, string TAndCDocumentNumber, int Status, int RequesterUserId)
        {
            var dbAccessDAL = new DBAccessDAL();
            var parameters = new Dictionary<string, string>();
            var DataSetparameters = new Dictionary<string, DataTable>();

            var action = string.Empty;
            var emailTemplateId = 0;
            if (Status == 286)
            {
                action = "created";
                emailTemplateId = 52;
            } else if (Status == 290) {
                action = "approved";
                emailTemplateId = 53;
            }

            var notalert = "The T & C document number "+ TAndCDocumentNumber + " is "+ action;
            var hyplink = "";
            if (_UserSession.UserDB == 1)
            {
                hyplink = "/bems/testingandcommissioning?id=" + TestingAndCommissioningId;
            }
            else
            {
                if (_UserSession.UserDB == 2)
                {
                    hyplink = "/Fems/testingandcommissioning?id=" + TestingAndCommissioningId;
                }
                else
                {

                }
            }

            parameters.Add("@pNotificationId", Convert.ToString(0));
            parameters.Add("@pCustomerId", Convert.ToString(_UserSession.CustomerId));
            parameters.Add("@pFacilityId", Convert.ToString(_UserSession.FacilityId));
            parameters.Add("@pUserId", Convert.ToString(RequesterUserId));
            parameters.Add("@pNotificationAlerts", Convert.ToString(notalert));
            parameters.Add("@pRemarks", Convert.ToString(""));
            parameters.Add("@pHyperLink", Convert.ToString(hyplink));
            parameters.Add("@pIsNew", Convert.ToString(1));
            parameters.Add("@pNotificationDateTime", Convert.ToString(null));
            parameters.Add("@pEmailTempId", Convert.ToString(emailTemplateId));

            DataTable ds = dbAccessDAL.GetDataTable("uspFM_WebNotificationSingle_Save", parameters, DataSetparameters);
        }

        private void SendMailCRM(TestingAndCommissioning model)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(SendMailCRM), Level.Info.ToString());
            try
            {
                string emailTemplateId = string.Empty;
                string subject = string.Empty;
                string subjectVars = string.Empty;
                string templateVars = string.Empty;
                string email = string.Empty;

                email = model.RequesterEmail;
                emailTemplateId = "50";

                var tempid = Convert.ToInt32(emailTemplateId);
               

                templateVars = string.Join(",", model.CRMRequestNo);

                var DataSetparameters = new Dictionary<string, DataTable>();
                DataTable TypecodeDt = new DataTable();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pEmailTemplateId", Convert.ToString(tempid));
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
                SendNotCRM(model);
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
        public TestingAndCommissioning SendNotCRM(TestingAndCommissioning ent)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(SendNotCRM), Level.Info.ToString());
            TestingAndCommissioning griddata = new TestingAndCommissioning();
            var dbAccessDAL = new DBAccessDAL();
            var parameters = new Dictionary<string, string>();
            var DataSetparameters = new Dictionary<string, DataTable>();

            var notalert = ent.CRMRequestNo + " " + "CRM Request Closed";

            var hyplink = "/master/mastercrmrequest?id=" + ent.CRMRequestId;

            parameters.Add("@pNotificationId", Convert.ToString(ent.NotificationId));
            parameters.Add("@pCustomerId", Convert.ToString(_UserSession.CustomerId));
            parameters.Add("@pFacilityId", Convert.ToString(_UserSession.FacilityId));
            parameters.Add("@pUserId", Convert.ToString(ent.CRMRequesterId));
            parameters.Add("@pNotificationAlerts", Convert.ToString(notalert));
            parameters.Add("@pRemarks", Convert.ToString(""));
            parameters.Add("@pHyperLink", Convert.ToString(hyplink));
            parameters.Add("@pIsNew", Convert.ToString(1));
            parameters.Add("@pNotificationDateTime", Convert.ToString(null));
            parameters.Add("@pEmailTempId", Convert.ToString(50));

            parameters.Add("@pmScreenName", Convert.ToString("CRMRequestStatus"));
            parameters.Add("@pMGuid", Convert.ToString(ent.HiddenId));

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
        private string GetRequesterEmailId(int TestingAndCommissioningId, out int RequesterId)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(GetRequesterEmailId), Level.Info.ToString());

                var EmailId = string.Empty;
                RequesterId = 0;

                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_TandCRequesterEmail_GetById";
                        cmd.Parameters.AddWithValue("@pTestingandCommissioningId", TestingAndCommissioningId);
                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }
                if (ds.Tables.Count != 0 && ds.Tables[0].Rows.Count > 0)
                {
                    EmailId = ds.Tables[0].Rows[0]["Email"].ToString();
                    var requesterIdInt = 0;
                    int.TryParse(ds.Tables[0].Rows[0]["Requester"].ToString(), out requesterIdInt);
                    RequesterId = requesterIdInt;
                }
                Log4NetLogger.LogExit(_FileName, nameof(GetRequesterEmailId), Level.Info.ToString());
                return EmailId;
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
        public bool IsSerialNoDuplicate(TestingAndCommissioning testingAndCommissioning)
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
                        cmd.CommandText = "uspFM_TAndCSerialNo_DuplicateCheck";
                        cmd.Parameters.AddWithValue("@pTestingandCommissioningId", testingAndCommissioning.TestingandCommissioningId);
                        cmd.Parameters.AddWithValue("@pSerialNo", testingAndCommissioning.SerialNo);
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
        public TAndCSNF SaveSNF(TAndCSNF testingAndCommissioning, out string ErrorMessage)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());

                var facilityCode = string.Empty;
               
                ErrorMessage = string.Empty;
                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_SNFTestingandCommissioning_Save";

                        testingAndCommissioning.WarrantyEndDate = ((DateTime)testingAndCommissioning.WarrantyStartDate).AddMonths((int)testingAndCommissioning.WarrantyDuration);

                        SqlParameter parameter = new SqlParameter();
                        cmd.Parameters.AddWithValue("@pTestingandCommissioningId", testingAndCommissioning.TestingandCommissioningId);
                        cmd.Parameters.AddWithValue("@pPurchaseOrderNo", testingAndCommissioning.PurchaseOrderNo);
                        cmd.Parameters.AddWithValue("@pPurchaseDate", testingAndCommissioning.PurchaseDate);
                        cmd.Parameters.AddWithValue("@pPurchaseCost", testingAndCommissioning.PurchaseCost);
                        cmd.Parameters.AddWithValue("@pContractLPONo", testingAndCommissioning.ContractLPONo);
                        cmd.Parameters.AddWithValue("@pServiceStartDate", testingAndCommissioning.ServiceStartDate);
                        cmd.Parameters.AddWithValue("@pServiceEndDate", testingAndCommissioning.ServiceEndDate);
                        cmd.Parameters.AddWithValue("@pContractorId", testingAndCommissioning.ContractorId);
                        cmd.Parameters.AddWithValue("@pWarrantyStartDate", testingAndCommissioning.WarrantyStartDate);
                        cmd.Parameters.AddWithValue("@pWarrantyDuration", testingAndCommissioning.WarrantyDuration);

                        cmd.Parameters.AddWithValue("@pWarrantyEndDate", testingAndCommissioning.WarrantyEndDate);

                        if (testingAndCommissioning.Status == (int)TestingAndCommissioningStatus.Verify)
                            cmd.Parameters.AddWithValue("@pVerifyRemarks", testingAndCommissioning.SNFRemarks);
                        if (testingAndCommissioning.Status == (int)TestingAndCommissioningStatus.Approve)
                            cmd.Parameters.AddWithValue("@pApprovalRemarks", testingAndCommissioning.SNFRemarks);
                        if (testingAndCommissioning.Status == (int)TestingAndCommissioningStatus.Reject)
                            cmd.Parameters.AddWithValue("@pRejectRemarks", testingAndCommissioning.SNFRemarks);

                        cmd.Parameters.AddWithValue("@pStatus", testingAndCommissioning.Status);
                        cmd.Parameters.AddWithValue("@pUserId", _UserSession.UserId);
                        cmd.Parameters.AddWithValue("@pTimestamp", Convert.FromBase64String(testingAndCommissioning.Timestamp));

                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }
                if (ds.Tables.Count != 0 && ds.Tables[0].Rows.Count > 0)
                {
                    testingAndCommissioning.Timestamp = Convert.ToBase64String((byte[])(ds.Tables[0].Rows[0]["Timestamp"]));
                    ErrorMessage = Convert.ToString(ds.Tables[0].Rows[0]["ErrorMessage"]);
                    var warrantyStatus = ds.Tables[0].Rows[0]["WarrantyStatus"];
                    if (warrantyStatus == DBNull.Value)
                        testingAndCommissioning.WarrantyStatus = null;
                    else
                        testingAndCommissioning.WarrantyStatus = Convert.ToInt32(warrantyStatus);
                    testingAndCommissioning.StatusName = Convert.ToString(ds.Tables[0].Rows[0]["StatusName"]);

                    if (testingAndCommissioning.Status == 290)
                    {
                        var requesterUserId = 0;
                        var requesterEmailId = GetRequesterEmailId(testingAndCommissioning.TestingandCommissioningId, out requesterUserId);
                        _EmailDAL.SendTandCApprovedEMail(testingAndCommissioning.TandCDocumentNo, requesterEmailId);
                        updateNotificationSingle(testingAndCommissioning.TestingandCommissioningId, testingAndCommissioning.TandCDocumentNo, 290, requesterUserId);
                    }
                }

                Log4NetLogger.LogExit(_FileName, nameof(Save), Level.Info.ToString());
                return testingAndCommissioning;
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
        private string GetFacilityCode(int FacilityId)
        {
            var locationCode = "";
            var ds = new DataSet();
            var dbAccessDAL = new DBAccessDAL();
            using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = con;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "uspFM_FacilityCode_GetById";

                    SqlParameter parameter = new SqlParameter();
                    cmd.Parameters.AddWithValue("@pFacilityId", _UserSession.FacilityId);

                    var da = new SqlDataAdapter();
                    da.SelectCommand = cmd;
                    da.Fill(ds);
                }
            }
            if (ds.Tables.Count > 0 && ds.Tables[0].Rows.Count > 0)
            {
                locationCode = ds.Tables[0].Rows[0]["FacilityCode"].ToString();
            }
            return locationCode;
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
                    strCondition = QueryCondition + " AND FacilityId = " + _UserSession.FacilityId.ToString();
                }

                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_EngTestingandCommissioningTxn_GetAll";

                        cmd.Parameters.AddWithValue("@PageIndex", pageFilter.PageIndex);
                        cmd.Parameters.AddWithValue("@PageSize", pageFilter.PageSize);
                        cmd.Parameters.AddWithValue("@strCondition", strCondition);
                        cmd.Parameters.AddWithValue("@strSorting", strOrderBy);

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
        public TestingAndCommissioning Get(int Id)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
                TestingAndCommissioning testingAndCommissioning = null;

                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_EngTestingandCommissioningTxn_GetById";
                        cmd.Parameters.AddWithValue("@pTestingandCommissioningId", Id);
                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }
                if (ds.Tables.Count != 0 && ds.Tables[0].Rows.Count > 0)
                {
                    testingAndCommissioning = (from n in ds.Tables[0].AsEnumerable()
                                               select new TestingAndCommissioning
                                               {
                                                   TestingandCommissioningId = Convert.ToInt32((n["TestingandCommissioningId"])),
                                                   ServiceId = Convert.ToInt32((n["ServiceId"])),
                                                   TandCDocumentNo = Convert.ToString(n["TandCDocumentNo"]),
                                                   RequestDate = n.Field<DateTime?>("RequestDate"),
                                                   TandCDate = Convert.ToDateTime((n["TandCDate"])),
                                                   AssetCategoryLovId = Convert.ToInt32((n["AssetCategoryLovId"])),
                                                   CRMRequestId = n.Field<int?>("CRMRequestId"),
                                                   CRMRequestNo = n.Field<string>("RequestNo"),
                                                   AssetTypeCodeId = n["AssetTypeCodeId"] == DBNull.Value ? 0 : Convert.ToInt32((n["AssetTypeCodeId"])),
                                                   AssetTypeCode = n["AssetTypeCode"] == DBNull.Value ? "" : Convert.ToString(n["AssetTypeCode"]),
                                                   AssetTypeDescription = n["AssetTypeDescription"] == DBNull.Value ? "" : Convert.ToString(n["AssetTypeDescription"]),
                                                   TandCStatus = Convert.ToInt32((n["TandCStatus"])),
                                                   AssetPreRegistrationNo = Convert.ToString(n["AssetPreRegistrationNo"]),
                                                   TandCCompletedDate = n["TandCCompletedDate"] == DBNull.Value ? DateTime.MinValue : Convert.ToDateTime((n["TandCCompletedDate"])),
                                                   HandoverDate = n["HandoverDate"] == DBNull.Value ? DateTime.MinValue : Convert.ToDateTime((n["HandoverDate"])),
                                                   VariationStatus = Convert.ToInt32((n["VariationStatus"])),
                                                   TandCContractorRepresentative = Convert.ToString(n["TandCContractorRepresentative"]),
                                                   FmsCustomerRepresentativeId = Convert.ToInt32((n["CustomerRepresentativeUserId"])),
                                                   CustomerRepresentativeName = Convert.ToString(n["CustomerRepresentativeName"]),
                                                   FmsFacilityRepresentativeId = Convert.ToInt32((n["FacilityRepresentativeUserId"])),
                                                   FacilityRepresentativeName = Convert.ToString(n["FacilityRepresentativeName"]),
                                                   Designation = Convert.ToString(n["Designation"]),
                                                   Remarks = Convert.ToString(n["Remarks"]),
                                                   //TypeOfService = Convert.ToString((n["TypeOfService"])),
                                                   BatchNo = Convert.ToString((n["BatchNo"])),
                                                   RequiredCompletionDate = n.Field<DateTime>("RequiredCompletionDate"),
                                                   ModelId = n.Field<int>("ModelId"),
                                                   Model = n.Field<string>("Model"),
                                                   ManufacturerId = n.Field<int>("ManufacturerId"),
                                                   Manufacturer = n.Field<string>("Manufacturer"),
                                                   SerialNo = n.Field<string>("SerialNo"),
                                                   AssetNoOld = n.Field<string>("AssetNoOld"),
                                                   //PONo = n.Field<string>("PONo"),
                                                   UserLocationId = n.Field<int>("UserLocationId"),
                                                   UserLocationName = n.Field<string>("UserLocationName"),
                                                   UserAreaId = n.Field<int>("UserAreaId"),
                                                   UserAreaName = n.Field<string>("UserAreaName"),
                                                   LevelName = n.Field<string>("LevelName"),
                                                   BlockName = n.Field<string>("BlockName"),
                                                   PurchaseOrderNo = n.Field<string>("PurchaseOrderNo"),
                                                   PurchaseDate = n["PurchaseDate"] == DBNull.Value ? DateTime.MinValue : Convert.ToDateTime((n["PurchaseDate"])),
                                                   PurchaseCost = n["PurchaseCost"] == DBNull.Value ? 0 : Convert.ToDecimal((n["PurchaseCost"])),
                                                   ContractLPONo = n["ContractLPONo"] == DBNull.Value ? "" : Convert.ToString(n["ContractLPONo"]),
                                                   ServiceStartDate = n["ServiceStartDate"] == DBNull.Value ? DateTime.MinValue : Convert.ToDateTime((n["ServiceStartDate"])),
                                                   ServiceEndDate = n["ServiceEndDate"] == DBNull.Value ? DateTime.MinValue : Convert.ToDateTime((n["ServiceEndDate"])),
                                                   ContractorId = n.Field<int?>("ContractorId"),
                                                   MainSupplierCode = n.Field<string>("ContractorCode"),
                                                   MainSupplierName = n.Field<string>("ContractorName"),
                                                   WarrantyStartDate = n["WarrantyStartDate"] == DBNull.Value ? DateTime.MinValue : Convert.ToDateTime((n["WarrantyStartDate"])),
                                                   WarrantyDuration = n["WarrantyDuration"] == DBNull.Value ? 0 : Convert.ToInt32((n["WarrantyDuration"])),
                                                   WarrantyEndDate = n["WarrantyEndDate"] == DBNull.Value ? DateTime.MinValue : Convert.ToDateTime((n["WarrantyEndDate"])),
                                                   WarrantyStatus = n["WarrantyStatus"] == DBNull.Value ? 0 : Convert.ToInt32((n["WarrantyStatus"])),
                                                   QRCode = n["QRCode"] == DBNull.Value ? "" : Convert.ToBase64String((byte[])n["QRCode"]),
                                                   Status = n.Field<int?>("Status"),
                                                   StatusName = n.Field<string>("StatusName"),
                                                   HiddenId = Convert.ToString(n["GuId"]),
                                                   IsUsed = n.Field<bool?>("IsUsed"),

                                                   ApprovalRemarks = n.Field<string>("ApprovalRemarks"),
                                                   RejectRemarks = n.Field<string>("RejectRemarks"),

                                                   Timestamp = Convert.ToBase64String((byte[])(n["Timestamp"]))
                                               }).FirstOrDefault();

                    if (testingAndCommissioning.TandCCompletedDate == DateTime.MinValue) testingAndCommissioning.TandCCompletedDate = null;
                    if (testingAndCommissioning.HandoverDate == DateTime.MinValue) testingAndCommissioning.HandoverDate = null;
                    if (testingAndCommissioning.PurchaseDate == DateTime.MinValue) testingAndCommissioning.PurchaseDate = null;
                    if (testingAndCommissioning.ServiceStartDate == DateTime.MinValue) testingAndCommissioning.ServiceStartDate = null;
                    if (testingAndCommissioning.ServiceEndDate == DateTime.MinValue) testingAndCommissioning.ServiceEndDate = null;
                    if (testingAndCommissioning.WarrantyStartDate == DateTime.MinValue) testingAndCommissioning.WarrantyStartDate = null;
                    if (testingAndCommissioning.WarrantyEndDate == DateTime.MinValue) testingAndCommissioning.WarrantyEndDate = null;

                    if (testingAndCommissioning.AssetTypeCodeId == 0) testingAndCommissioning.AssetTypeCodeId = null;
                    if (testingAndCommissioning.PurchaseCost == 0) testingAndCommissioning.PurchaseCost = null;
                    if (testingAndCommissioning.WarrantyDuration == 0) testingAndCommissioning.WarrantyDuration = null;
                    if (testingAndCommissioning.WarrantyStatus == 0) testingAndCommissioning.WarrantyStatus = null;

                    var snfRemarks = string.Empty;
                    if (testingAndCommissioning.Status == 290)
                    {
                        snfRemarks = testingAndCommissioning.ApprovalRemarks;
                    }
                    if (testingAndCommissioning.Status == 291)
                    {
                        snfRemarks = testingAndCommissioning.RejectRemarks;
                    }
                    testingAndCommissioning.SNFRemarks = snfRemarks;
                }
                Log4NetLogger.LogExit(_FileName, nameof(Get), Level.Info.ToString());
                return testingAndCommissioning;
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
        private void GetWarrantyStatus()
        {

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
                        cmd.CommandText = "uspFM_EngTestingandCommissioningTxn_Delete";
                        cmd.Parameters.AddWithValue("@pTestingandCommissioningId", Id);

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
    }
}