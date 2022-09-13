using CP.UETrack.DAL.DataAccess.Contracts.UM;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using CP.UETrack.Model;
using CP.UETrack.Model.UM;
using CP.Framework.Common.Logging;
using System.Data;
using UETrack.DAL;
using System.Data.SqlClient;
using CP.Framework.Common.ExceptionHandler.ExceptionWrappers;
using CP.UETrack.DAL.DataAccess.Implementation;

namespace CP.UETrack.DAL.DataAccess.Implementations.UM
{
    public class NotificationDeliveryConfigurationDAL : INotificationDeliveryConfigurationDAL
    {
        private readonly string _FileName = nameof(NotificationDeliveryConfigurationDAL);
        readonly UserDetailsModel _UserSession = new SessionHelper().UserSession();
        public NotificationTypedropdown Load()
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
                NotificationTypedropdown NotificationTypedropdown = null;

                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_Dropdown_Others";
                        cmd.Parameters.AddWithValue("@pTablename", "Service");
                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);

                        if (ds.Tables.Count != 0)
                        {
                            NotificationTypedropdown = new NotificationTypedropdown();
                            NotificationTypedropdown.NotificationServiceTypeData = dbAccessDAL.GetLovRecords(ds.Tables[0]);
                        }

                        ds.Clear();                        
                        cmd.Parameters.Clear();
                        cmd.Parameters.AddWithValue("@pTableName" , "NotificationTemplate");                       
                        da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);

                        if (ds.Tables.Count != 0)
                        {
                            NotificationTypedropdown.NotificationUserTypeData = dbAccessDAL.GetLovRecords(ds.Tables[0]);                           
                        }                       

                    }
                }

                Log4NetLogger.LogExit(_FileName, nameof(Load), Level.Info.ToString());
                return NotificationTypedropdown;
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

                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_NotificationTemplate_GetAll";   //change SP Name

                        cmd.Parameters.AddWithValue("@PageIndex", pageFilter.PageIndex);
                        cmd.Parameters.AddWithValue("@PageSize", pageFilter.PageSize);
                        cmd.Parameters.AddWithValue("@strCondition", pageFilter.QueryWhereCondition);
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

        public NotificationDeliveryConfigurationModel Save(NotificationDeliveryConfigurationModel Notification, out string ErrorMessage)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());
                ErrorMessage = string.Empty;
                var dbAccessDAL = new DBAccessDAL();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pDisableNotification", Convert.ToString(Notification.DisableNotification));
                parameters.Add("@pNotificationTemplateId", Convert.ToString(Notification.NotificationTemplateId));

                var DataSetparameters = new Dictionary<string, DataTable>();
                DataTable dt = new DataTable();
                dt.Columns.Add("NotificationDeliveryId", typeof(int));
                dt.Columns.Add("NotificationTemplateId", typeof(int));
                dt.Columns.Add("RecepientType", typeof(int));
                dt.Columns.Add("UserRoleId", typeof(int));
                dt.Columns.Add("UserRegistrationId", typeof(int));
                dt.Columns.Add("FacilityId", typeof(int));
                dt.Columns.Add("UserId", typeof(int));
                //dt.Columns.Add("Status", typeof(int));
                dt.Columns.Add("EmailId", typeof(string));
                dt.Columns.Add("CompanyId", typeof(int));

                if (Notification.NotificationToCcListData != null) {
                    foreach (var i in Notification.NotificationToCcListData)
                    {
                        dt.Rows.Add(i.NotificationDeliveryId, Notification.NotificationTemplateId, i.RecepientType, i.UserRoleId, i.UserRegistrationId,
                       _UserSession.FacilityId, _UserSession.UserId, i.CcEmailId, i.CompanyId);
                    }

                    DataSetparameters.Add("@NotificationDeliveryDet", dt);
                }
                DataTable dt1 = dbAccessDAL.GetDataTable("uspFM_NotificationDeliveryDet_Save", parameters, DataSetparameters);
                if (dt1 != null)
                {
                    foreach (DataRow row in dt1.Rows)
                         {
                           // Notification.NotificationTemplateId= Convert.ToInt32(row["NotificationTemplateId"]);
                            Notification.NotificationDeliveryId = Convert.ToInt32(row["NotificationDeliveryId"]);
                        Notification.Timestamp = Convert.ToBase64String((byte[])(row["Timestamp"]));
                        ErrorMessage = Convert.ToString(row["ErrorMessage"]);
                    }
                }
            
                Log4NetLogger.LogExit(_FileName, nameof(Save), Level.Info.ToString());
                return Notification;
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
        
        public NotificationDeliveryConfigurationModel Get(int Id)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
            try
            {
                var dbAccessDAL = new DBAccessDAL();
                var entity = new NotificationDeliveryConfigurationModel();

                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pUserId", Convert.ToString(_UserSession.UserId));
                parameters.Add("@pNotificationTemplateId", Convert.ToString(Id));
                parameters.Add("@pFacilityId", Convert.ToString(_UserSession.FacilityId));

                DataTable dt1 = dbAccessDAL.GetDataTable("UspFM_NotificationDeliveryDet_GetById", parameters, DataSetparameters);
                if (dt1 != null && dt1.Rows.Count > 0)
                {
                    entity.NotificationTemplateId = Id; 
                    entity.NotificationType = Convert.ToString(dt1.Rows[0]["TypeValue"]);
                    entity.NotificationName = Convert.ToString(dt1.Rows[0]["Name"]);
                    entity.ServiceId = Convert.ToInt32(dt1.Rows[0]["ServiceId"]);
                    entity.DisableNotification = Convert.ToBoolean(dt1.Rows[0]["DisableNotificationId"]);
                    entity.Subject = Convert.ToString(dt1.Rows[0]["Subject"]);                    
                    entity.Timestamp = Convert.ToBase64String((byte[])(dt1.Rows[0]["Timestamp"]));
                    //entity.RecepientType= Convert.ToInt32(dt1.Rows[0]["RecepientType"]);
                }
                DataSet dt = dbAccessDAL.GetDataSet("UspFM_NotificationDeliveryDet_GetById", parameters, DataSetparameters);
                if (dt != null && dt.Tables.Count > 0)
                {
                    entity.NotificationToCcListData = (from n in dt.Tables[1].AsEnumerable()
                                                       select new NotificationToCcList
                                                       {
                                                           NotificationDeliveryId = Convert.ToInt32(n["NotificationDeliveryId"]),
                                                           UserRoleId = Convert.ToInt32(n["UserRoleId"]),
                                                           RecepientType = Convert.ToInt32(n["RecepientType"]),
                                                           UserRegistrationId = Convert.ToInt32(n["UserRegistrationId"]),
                                                           CompanyId= Convert.ToInt32(n["CompanyId"]),
                                                        
                                                           ToRole = Convert.ToString(n["UserRoleValue"]),
                                                           ToUser = n.Field<string>("UserTypeName") == null ? "" : n.Field<string>("UserTypeName"),
                                                           ToCompany = Convert.ToString(n["CompanyValue"]),
                                                       
                                                           CcRole = Convert.ToString(n["UserRoleValue"]),
                                                           CcUser = n.Field<string>("UserTypeName") == null ? "" : n.Field<string>("UserTypeName"),
                                                           CcEmailId = n.Field<string>("EmailId") == null ? "" : n.Field<string>("EmailId"),
                                                           CcCompany = Convert.ToString(n["CompanyValue"]),                                                                                                        

                                                       }).ToList();                    
                }
                Log4NetLogger.LogExit(_FileName, nameof(Get), Level.Info.ToString());
                return entity;
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


        public NotificationTypedropdown GetRole(int Id)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(GetRole), Level.Info.ToString());
                NotificationTypedropdown NotificationTypedropdown = null;

                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "UspFM_UserRoleFetchUsingUserType_GetById";
                        cmd.Parameters.AddWithValue("@pUserTypeId", Id);
                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);

                        if (ds.Tables.Count != 0)
                        {
                            NotificationTypedropdown = new NotificationTypedropdown();
                            NotificationTypedropdown.NotificationRoleTypeData = dbAccessDAL.GetLovRecords(ds.Tables[0]);
                        }

                    }
                }
                Log4NetLogger.LogExit(_FileName, nameof(GetRole), Level.Info.ToString());
                return NotificationTypedropdown;               

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

        public NotificationTypedropdown GetCompany(int Id)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(GetCompany), Level.Info.ToString());
                NotificationTypedropdown NotificationTypedropdown = null;

                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "UspFM_UserRoleFetchUsingGetCompany_GetById";
                        cmd.Parameters.AddWithValue("@pRoleId", Id);
                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);

                        if (ds.Tables.Count != 0)
                        {
                            NotificationTypedropdown = new NotificationTypedropdown();
                            NotificationTypedropdown.NotificationCompanyTypeData = dbAccessDAL.GetLovRecords(ds.Tables[0]);
                        }

                    }
                }
                Log4NetLogger.LogExit(_FileName, nameof(GetCompany), Level.Info.ToString());
                return NotificationTypedropdown;

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

        public NotificationTypedropdown GetLocation(int Id)          // No Need
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(GetLocation), Level.Info.ToString());
                NotificationTypedropdown NotificationTypedropdown = null;

                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "UspFM_UserRoleFetchUsingGetLocation_GetById";
                        cmd.Parameters.AddWithValue("@pCustomerId", Id);
                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);

                        if (ds.Tables.Count != 0)
                        {
                            NotificationTypedropdown = new NotificationTypedropdown();
                            NotificationTypedropdown.NotificationLocationTypeData = dbAccessDAL.GetLovRecords(ds.Tables[0]);
                        }

                    }
                }
                Log4NetLogger.LogExit(_FileName, nameof(GetLocation), Level.Info.ToString());
                return NotificationTypedropdown;

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

        public bool Delete(string Id)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Delete), Level.Info.ToString());
            try
            {
                var dbAccessDAL = new DBAccessDAL();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pNotificationDeliveryId", Id.ToString());
                DataTable dt = dbAccessDAL.GetDataTable("UspFM_NotificationDeliveryDet_Delete", parameters, DataSetparameters);
                if (dt != null && dt.Rows.Count > 0)
                {
                    string Message = Convert.ToString(dt.Rows[0]["Message"]);
                }
                Log4NetLogger.LogExit(_FileName, nameof(Delete), Level.Info.ToString());
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

        public bool IsNotificationCodeDuplicate(NotificationDeliveryConfigurationModel Notification)
        {
            throw new NotImplementedException();
        }

        public bool IsRecordModified(NotificationDeliveryConfigurationModel Notification)
        {
            throw new NotImplementedException();
        }
    }
}
