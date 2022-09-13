using CP.Framework.Common.ExceptionHandler.ExceptionWrappers;
using CP.Framework.Common.Logging;
using CP.UETrack.DAL.DataAccess.Contracts;
using CP.UETrack.DAL.DataAccess.Contracts.VM;
using CP.UETrack.DAL.DataAccess.Implementation;
using CP.UETrack.Model;
using CP.UETrack.Model.Enum;
using CP.UETrack.Model.VM;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using UETrack.DAL;

namespace CP.UETrack.DAL.DataAccess.Implementations.VM
{
    public class SNFDAL : ISNFDAL
    {

        private readonly string _FileName = nameof(SNFDAL);
        readonly UserDetailsModel _UserSession = new SessionHelper().UserSession();
        private IEmailDAL _EmailDAL;
        public SNFDAL()
        {
            _EmailDAL = new EmailDAL();
        }
        public LovEntity Load()
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
                LovEntity testingAndCommissioningLovs = null;

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
                        cmd.Parameters.AddWithValue("@pLovKey", "VariationStatusValue,YesNoValue");
                        da1.SelectCommand = cmd;
                        da1.Fill(ds1);
                    }
                }
                testingAndCommissioningLovs = new LovEntity();

                if (ds1.Tables.Count != 0)
                {


                    var variationStatus = dbAccessDAL.GetLovRecords(ds1.Tables[0], "VariationStatusValue");
                    var variationIds = new List<int> {126,127, 129 };
                    testingAndCommissioningLovs.VariationStatus = variationStatus.Where(x => variationIds.Contains(x.LovId)).ToList();
                    testingAndCommissioningLovs.YesNoValues = dbAccessDAL.GetLovRecords(ds1.Tables[0], "YesNoValue");
                }
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
        public SNFEntity Save(SNFEntity testingAndCommissioning, out string ErrorMessage)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());

                ErrorMessage = string.Empty;
                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    testingAndCommissioning.Timestamp = testingAndCommissioning.Timestamp == "null" ? null : testingAndCommissioning.Timestamp;
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_EngTestingandCommissioningTxnSNF_Save";

                        SqlParameter parameter = new SqlParameter();
                        cmd.Parameters.AddWithValue("@pUserId", _UserSession.UserId);
                        cmd.Parameters.AddWithValue("@pCustomerId", _UserSession.CustomerId);
                        cmd.Parameters.AddWithValue("@pFacilityId", _UserSession.FacilityId);
                        cmd.Parameters.AddWithValue("@pServiceId", testingAndCommissioning.ServiceId);
                        cmd.Parameters.AddWithValue("@pTandCDate", testingAndCommissioning.TandCDate);
                        cmd.Parameters.AddWithValue("@pVariationStatus", testingAndCommissioning.VariationStatus);
                        cmd.Parameters.AddWithValue("@pPurchaseDate", testingAndCommissioning.PurchaseDate);
                        cmd.Parameters.AddWithValue("@pPurchaseCost", testingAndCommissioning.PurchaseCost);
                        cmd.Parameters.AddWithValue("@pServiceStartDate", testingAndCommissioning.ServiceStartDate);
                        cmd.Parameters.AddWithValue("@pServiceEndDate", testingAndCommissioning.ServiceEndDate);
                        cmd.Parameters.AddWithValue("@pAssetId", testingAndCommissioning.AssetId);
                        cmd.Parameters.AddWithValue("@pRemarks", testingAndCommissioning.SNFRemarks);
                        cmd.Parameters.AddWithValue("@pIsSNF", true);
                        
                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }
                if (ds.Tables.Count != 0 && ds.Tables[0].Rows.Count > 0)
                {
                    testingAndCommissioning.SNFNo = Convert.ToString(ds.Tables[0].Rows[0]["SNFDocumentNo"]);
                    _EmailDAL.SendStopNotificationEMail(testingAndCommissioning.AssetNo, testingAndCommissioning.IsLoaner);

                    //var UserId = 0;
                    //GetAssigneeUserId(testingAndCommissioning.IsLoaner, out UserId);
                    UpdateNotification(testingAndCommissioning.AssetId, testingAndCommissioning.AssetNo, testingAndCommissioning.IsLoaner);
                }
                Log4NetLogger.LogExit(_FileName, nameof(Save), Level.Info.ToString());
                return testingAndCommissioning;
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
                if (string.IsNullOrEmpty(pageFilter.QueryWhereCondition))
                {
                    pageFilter.QueryWhereCondition = " FacilityId = " + _UserSession.FacilityId.ToString();
                }
                else
                {
                    pageFilter.QueryWhereCondition += " AND FacilityId = " + _UserSession.FacilityId.ToString();
                }

                strOrderBy = string.IsNullOrEmpty(strOrderBy) ? pageFilter.SortColumn + " " + pageFilter.SortOrder : strOrderBy;

                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_EngTestingandCommissioningTxnSNF_GetAll";

                        cmd.Parameters.AddWithValue("@PageIndex", pageFilter.PageIndex);
                        cmd.Parameters.AddWithValue("@PageSize", pageFilter.PageSize);
                        cmd.Parameters.AddWithValue("@StrCondition", pageFilter.QueryWhereCondition);
                        cmd.Parameters.AddWithValue("@StrSorting", strOrderBy);

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
        public SNFEntity Get(int Id)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
                var testingAndCommissioning = new SNFEntity();

                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_EngTestingandCommissioningTxnSNF_GetById";
                        cmd.Parameters.AddWithValue("@pAssetId", Id);
                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }
                if (ds.Tables.Count != 0 && ds.Tables[0].Rows.Count > 0)
                {
                    testingAndCommissioning = (from n in ds.Tables[0].AsEnumerable()
                                               select new SNFEntity
                                               {
                                                   TandCDate = n.Field<DateTime>("TandCDate"),
                                                   VariationStatus = n.Field<int>("VariationStatus"),
                                                   ServiceEndDate = n.Field<DateTime>("ServiceEndDate"),
                                                   SNFRemarks = n.Field<string>("Remarks"),
                                                   SNFNo = n.Field<string>("SNFDocumentNo")
                                               }).FirstOrDefault();

                }
                Log4NetLogger.LogExit(_FileName, nameof(Get), Level.Info.ToString());
                return testingAndCommissioning;
            }
            catch (DALException dalex)
            {
                throw new DALException(dalex);
            }
            catch (Exception exce)
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
        private void UpdateNotification(int AssetId, string AssetNo, bool IsLoaner)
        {
            var dbAccessDAL = new DBAccessDAL();
            var parameters = new Dictionary<string, string>();
            var DataSetparameters = new Dictionary<string, DataTable>();

            var notalert = string.Empty;
            var hyplink = string.Empty;
            var emailTemplateId = 0;
            if (IsLoaner)
            {
                notalert = "The Loaner / Test Equipment "+AssetNo+" is updated with Stop Notification.";
                hyplink = "/bems/loanerequipment/get/" + AssetId;
                emailTemplateId = 59;
            }
            else
            {
                notalert = "The Asset " + AssetNo + " is updated with Stop Notification.";
                hyplink = "/bems/assetregister/get/" + AssetId;
                emailTemplateId = 65;
            }

            parameters.Add("@pNotificationId", Convert.ToString(0));
            parameters.Add("@pCustomerId", Convert.ToString(_UserSession.CustomerId));
            parameters.Add("@pFacilityId", Convert.ToString(_UserSession.FacilityId));
            parameters.Add("@pUserId", Convert.ToString(0));
            parameters.Add("@pNotificationAlerts", Convert.ToString(notalert));
            parameters.Add("@pRemarks", Convert.ToString(""));
            parameters.Add("@pHyperLink", Convert.ToString(hyplink));
            parameters.Add("@pIsNew", Convert.ToString(1));
            parameters.Add("@pNotificationDateTime", Convert.ToString(null));
            parameters.Add("@pEmailTempId", Convert.ToString(emailTemplateId));

            DataTable ds = dbAccessDAL.GetDataTable("uspFM_WebNotificationSingle_Save", parameters, DataSetparameters);
        }
        private void GetAssigneeUserId(bool IsLoaner, out int UserId)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(GetAssigneeUserId), Level.Info.ToString());
                UserId = 0;
                var NotificationTemplateId = 0;
                if (IsLoaner)
                {
                    NotificationTemplateId = 59;
                }
                else
                {
                    NotificationTemplateId = 65;
                }

                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_NotificationDeliveryDetEmail_GetById";
                        cmd.Parameters.AddWithValue("@pNotificationTemplateId", NotificationTemplateId);
                        cmd.Parameters.AddWithValue("@pFacilityId", _UserSession.UserId);
                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }
                if (ds.Tables.Count != 0 && ds.Tables[0].Rows.Count > 0)
                {
                    var userIdInt = 0;
                    int.TryParse(ds.Tables[0].Rows[0]["UserRegistrationId"].ToString(), out userIdInt);
                    UserId = userIdInt;
                }
                Log4NetLogger.LogExit(_FileName, nameof(GetAssigneeUserId), Level.Info.ToString());
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
