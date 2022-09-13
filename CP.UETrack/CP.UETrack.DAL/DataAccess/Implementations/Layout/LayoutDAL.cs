using CP.UETrack.Model;
using System;
using CP.Framework.Common.Logging;
using CP.Framework.Common.ExceptionHandler.ExceptionWrappers;
using System.Data;
using System.Data.SqlClient;
using UETrack.DAL;
using CP.UETrack.Model.Layout;
using System.Linq;
using System.Configuration;
using System.Collections.Generic;
using CP.Framework.Common.StateManagement;

namespace CP.UETrack.DAL.DataAccess
{

    public class LayoutDAL : ILayoutDAL
    {
        private readonly string _FileName = nameof(LayoutDAL);
        readonly UserDetailsModel _UserSession = new SessionHelper().UserSession();
 

        public CustomerFacilityLovs GetCustomerAndFacilities()
        {
            try
            {
              
                Log4NetLogger.LogEntry(_FileName, nameof(GetCustomerAndFacilities), Level.Info.ToString());
                CustomerFacilityLovs customers = null;

                var ds = new DataSet();
                var ds1 = new DataSet();
                var ds2 = new DataSet();
                var dbAccessDAL = new MASTERDBAccessDAL();

                var customerId = _UserSession.CustomerId;
                var facilityId = _UserSession.FacilityId;
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        var spName = string.Empty;

                        spName = "uspFM_UMUserRegistrationCustomer_Fetch";
                        cmd.CommandText = spName;
                        cmd.Parameters.AddWithValue("@pUserRegistrationId", _UserSession.UserId);
                        cmd.Parameters.AddWithValue("@pCustomerId", customerId);

                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }

                if (ds.Tables.Count != 0 && ds.Tables[0].Rows.Count > 0)
                {
                    customers = new CustomerFacilityLovs();
                    var isDevelopmentMode = Convert.ToBoolean(ConfigurationManager.AppSettings["IsDevelopmentMode"]);

                    customers.IsDevelopmentMode = isDevelopmentMode ? 1 : 0;

                    customers.Customers = dbAccessDAL.GetLovRecords(ds.Tables[0]);
                    customers.Facilities = dbAccessDAL.GetLovRecords(ds.Tables[1]);

                }
                customers.CustomerId = customerId;
                customers.FacilityId = facilityId;

                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        var da1 = new SqlDataAdapter();
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_FMConfigCustomerValues_GetCustomerConfig";
                        cmd.Parameters.Clear();
                        cmd.Parameters.AddWithValue("@pCustomerId", customers.CustomerId);
                        da1.SelectCommand = cmd;
                        da1.Fill(ds1);
                    }
                }

                if (ds1.Tables.Count != 0 && ds1.Tables[0].Rows.Count > 0)
                {
                    foreach (DataRow row in ds1.Tables[0].Rows)
                    {
                        if (row["KeyName"].ToString() == "Date")
                        {
                            customers.DateFormat = row["KeyValues"].ToString();
                        }
                        if (row["KeyName"].ToString() == "Currency")
                        {
                            customers.Currency = row["KeyValues"].ToString();
                        }
                        //if (row["KeyName"].ToString() == "Theme Color")
                        //{
                        //    customers.ThemeColorName = row["KeyValues"].ToString();
                        //}
                    }
                }

                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        var da2 = new SqlDataAdapter();
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_UMUserRole_GetByFacilityId";
                        cmd.Parameters.Clear();
                        cmd.Parameters.AddWithValue("@pUserRegId", _UserSession.UserId);
                        cmd.Parameters.AddWithValue("@pFacilityId", customers.FacilityId);
                        da2.SelectCommand = cmd;
                        da2.Fill(ds2);
                    }
                }

                if (ds2.Tables.Count != 0 && ds2.Tables[0].Rows.Count > 0)
                {
                    customers.UserRoleId = Convert.ToInt32(ds2.Tables[0].Rows[0]["UMUserRoleId"]);
                    customers.UserRoleName = Convert.ToString(ds2.Tables[0].Rows[0]["UserRoleName"]);
                }

                //---------------
                ds.Clear();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        var spName = string.Empty;

                        spName = "Get_Services_byFacilityId";
                        cmd.CommandText = spName;
                        //  cmd.Parameters.AddWithValue("@pUserRegistrationId", _UserSession.UserId);
                        cmd.Parameters.AddWithValue("@FacilityID", _UserSession.FacilityId);

                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }

                if (ds.Tables.Count != 0 && ds.Tables[0].Rows.Count > 0)
                {


                    customers.FEMS = Convert.ToInt32(ds.Tables[0].Rows[0]["FEMS"]);
                    customers.BEMS = Convert.ToInt32(ds.Tables[0].Rows[0]["BEMS"]);
                    customers.CLS = Convert.ToInt32(ds.Tables[0].Rows[0]["CLS"]);
                    customers.LLS = Convert.ToInt32(ds.Tables[0].Rows[0]["LLS"]);
                    customers.HWMS = Convert.ToInt32(ds.Tables[0].Rows[0]["HWMS"]);


                }
                //-----------





                Log4NetLogger.LogExit(_FileName, nameof(GetCustomerAndFacilities), Level.Info.ToString());
               
                return customers;
            }
            catch (DALException dalex)
            {
                throw new DALException(dalex);
            }
            catch (Exception ex)
            {
                throw ex;
            }
          // int jac= GetServices();
        }
        public CustomerFacilityLovs GetFacilities(int CustomerId)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(GetFacilities), Level.Info.ToString());
                CustomerFacilityLovs customers = null;

                var ds = new DataSet();
                var ds2 = new DataSet();
                var dbAccessDAL = new MASTERDBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_Facility_GetByCustomerId";
                        cmd.Parameters.AddWithValue("@pCustomerId", CustomerId);
                        cmd.Parameters.AddWithValue("@pUserRegistrationId", _UserSession.UserId);
                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }
                if (ds.Tables.Count != 0 && ds.Tables[0].Rows.Count > 0)
                {
                    customers = new CustomerFacilityLovs();
                    customers.Facilities = dbAccessDAL.GetLovRecords(ds.Tables[0]);
                }
                
                customers.CustomerId = CustomerId;
                customers.FacilityId = (from n in customers.Facilities
                                        orderby n.FieldValue
                                        select n.LovId).FirstOrDefault();

                Log4NetLogger.LogExit(_FileName, nameof(GetFacilities), Level.Info.ToString());
                return customers;
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



        public NotificationCount GetNotificationCount(int FacilityId, int UserId)
        {
            try
            {
                var dbAccessDAL = new MASTERDBAccessDAL();
                var FdbAccessDAL = new MASTERFEMSDBAccessDAL();
                var BdbAccessDAL = new MASTERBEMSDBAccessDAL();
                NotificationCount entity = new NotificationCount();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();

                parameters.Add("@pUserId", Convert.ToString(_UserSession.UserId));
                parameters.Add("@pFacilityId", Convert.ToString(_UserSession.FacilityId));
                User_Maping_ID userids = new User_Maping_ID();
                userids = Get_User_IDS(_UserSession.UserId);
                DataSet ds = dbAccessDAL.MasterGetDataSet("uspFM_WebNotification_GetCount", parameters, DataSetparameters);
                if (ds != null)
                {
                    if (ds.Tables[0] != null && ds.Tables[0].Rows.Count > 0)
                    {
                        entity.TotalCount = Convert.ToInt16(ds.Tables[0].Rows[0]["NewCount"]);
                                          
                    }

                }
                parameters.Remove("@pUserId");
                parameters.Add("@pUserId", Convert.ToString(userids.FEMS_U_ID));
                DataSet dsF = FdbAccessDAL.GetDataSet("uspFM_WebNotification_GetCount", parameters, DataSetparameters);
                if (dsF != null)
                {
                   
                    if (dsF.Tables[0] != null && dsF.Tables[0].Rows.Count > 0)
                    {
                        entity.TotalCount = entity.TotalCount+Convert.ToInt16(dsF.Tables[0].Rows[0]["NewCount"]);

                    }

                }
                parameters.Remove("@pUserId");
                parameters.Add("@pUserId", Convert.ToString(userids.BEMS_U_ID));
                DataSet dsB = BdbAccessDAL.GetDataSet("uspFM_WebNotification_GetCount", parameters, DataSetparameters);
                if (dsB != null)
                {
                   
                    if (dsB.Tables[0] != null && dsB.Tables[0].Rows.Count > 0)
                    {
                        entity.TotalCount = entity.TotalCount + Convert.ToInt16(dsB.Tables[0].Rows[0]["NewCount"]);

                    }

                }
                Log4NetLogger.LogExit(_FileName, nameof(GetNotification), Level.Info.ToString());
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
        public Notification GetNotification(int pagesize, int pageindex)
        {
            try
            {
                var dbAccessDAL = new MASTERDBAccessDAL();
                var FdbAccessDAL = new MASTERFEMSDBAccessDAL();
                var BdbAccessDAL = new MASTERBEMSDBAccessDAL();
                Notification entity = new Notification();
                List<Notificationgrid> notifications = new List<Notificationgrid>();
               var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                User_Maping_ID userids = new User_Maping_ID();
                userids = Get_User_IDS(_UserSession.UserId);
                parameters.Add("@pUserId", Convert.ToString(_UserSession.UserId));
                parameters.Add("@pFacilityId", Convert.ToString(_UserSession.FacilityId));
                parameters.Add("@pPageSize", Convert.ToString(10000));
                parameters.Add("@pPageIndex", Convert.ToString(pageindex));

                DataSet ds = dbAccessDAL.MasterGetDataSet("uspFM_WebNotification_GetById", parameters, DataSetparameters);
                if (ds.Tables[0] != null && ds.Tables[0].Rows.Count > 0)
                {
                    //if (ds.Tables[0] != null && ds.Tables[0].Rows.Count > 0)
                    //{
                    //    //entity.CRMRequestId = Convert.ToInt16(ds.Tables[0].Rows[0]["CRMRequestId"]);
                    //    //entity.RequestNo = Convert.ToString(ds.Tables[0].Rows[0]["RequestNo"]);                     
                    //}

                    List<Notificationgrid> griddata = (from n in ds.Tables[0].AsEnumerable()
                                    select new Notificationgrid
                                    {
                                        NotificationId = Convert.ToInt32(n["NotificationId"]),
                                        //Date = n.Field<DateTime?>("NotificationDateTime"),
                                        NotificationDateTime = Convert.ToDateTime(n["NotificationDateTime"]),
                                        Remarks = Convert.ToString(n["NotificationAlerts"] == DBNull.Value ? "" : (Convert.ToString(n["NotificationAlerts"]))),
                                        URL = Convert.ToString(n["HyperLink"]),                                        
                                        IsNew = Convert.ToBoolean(n["IsNew"]),
                                        Module = Convert.ToString(n["Module"]),
                                        TotalRecords = Convert.ToInt32(n["TotalRecords"]),
                                        TotalPages = Convert.ToInt32(n["TotalPageCalc"]),
                                    }).ToList();
                    if (griddata != null && griddata.Count > 0)
                    {
                        // entity.NotificationgridData.AddRange(griddata);
                        notifications.AddRange(griddata);
                    }
                   
                        //entity.NotificationgridData.ForEach((x) =>
                        //{
                        //    x.PageIndex = pageindex;
                        //    x.FirstRecord = ((pageindex - 1) * pagesize) + 1;
                        //    x.LastRecord = ((pageindex - 1) * pagesize) + pagesize;
                        //});
                    
                }
               // ----FEMS
                parameters.Remove("@pUserId");
                parameters.Add("@pUserId", Convert.ToString(userids.FEMS_U_ID));
                DataSet Fds = FdbAccessDAL.GetDataSet("uspFM_WebNotification_GetById", parameters, DataSetparameters);
                if (Fds.Tables[0] != null && Fds.Tables[0].Rows.Count > 0)
                {
                    //if (ds.Tables[0] != null && ds.Tables[0].Rows.Count > 0)
                    //{
                    //    //entity.CRMRequestId = Convert.ToInt16(ds.Tables[0].Rows[0]["CRMRequestId"]);
                    //    //entity.RequestNo = Convert.ToString(ds.Tables[0].Rows[0]["RequestNo"]);                     
                    //}

                    List<Notificationgrid> griddata = (from n in Fds.Tables[0].AsEnumerable()
                                    select new Notificationgrid
                                    {
                                        NotificationId = Convert.ToInt32(n["NotificationId"]),
                                        //Date = n.Field<DateTime?>("NotificationDateTime"),
                                        NotificationDateTime = Convert.ToDateTime(n["NotificationDateTime"]),
                                        Remarks = Convert.ToString(n["NotificationAlerts"] == DBNull.Value ? "" : (Convert.ToString(n["NotificationAlerts"]))),
                                        URL = Convert.ToString(n["HyperLink"]),
                                        IsNew = Convert.ToBoolean(n["IsNew"]),
                                        Module = Convert.ToString(n["Module"]),
                                        TotalRecords = Convert.ToInt32(n["TotalRecords"]),
                                        TotalPages = Convert.ToInt32(n["TotalPageCalc"]),
                                    }).ToList();
                    if (griddata != null && griddata.Count > 0)
                    {
                        // entity.NotificationgridData.AddRange(griddata);
                        notifications.AddRange(griddata);
                    }

                    //entity.NotificationgridData.ForEach((x) =>
                    //{
                    //    x.PageIndex = pageindex;
                    //    x.FirstRecord = ((pageindex - 1) * pagesize) + 1;
                    //    x.LastRecord = ((pageindex - 1) * pagesize) + pagesize;
                    //});

                }
                // ----BEMS
                parameters.Remove("@pUserId");
                parameters.Add("@pUserId", Convert.ToString(userids.BEMS_U_ID));
                DataSet Bds = BdbAccessDAL.GetDataSet("uspFM_WebNotification_GetById", parameters, DataSetparameters);
                if (Bds.Tables[0] != null && Bds.Tables[0].Rows.Count > 0)
                {
                    //if (ds.Tables[0] != null && ds.Tables[0].Rows.Count > 0)
                    //{
                    //    //entity.CRMRequestId = Convert.ToInt16(ds.Tables[0].Rows[0]["CRMRequestId"]);
                    //    //entity.RequestNo = Convert.ToString(ds.Tables[0].Rows[0]["RequestNo"]);                     
                    //}

                    List<Notificationgrid> griddata = (from n in Bds.Tables[0].AsEnumerable()
                                    select new Notificationgrid
                                    {
                                        NotificationId = Convert.ToInt32(n["NotificationId"]),
                                        //Date = n.Field<DateTime?>("NotificationDateTime"),
                                        NotificationDateTime = Convert.ToDateTime(n["NotificationDateTime"]),
                                        Remarks = Convert.ToString(n["NotificationAlerts"] == DBNull.Value ? "" : (Convert.ToString(n["NotificationAlerts"]))),
                                        URL = Convert.ToString(n["HyperLink"]),
                                        IsNew = Convert.ToBoolean(n["IsNew"]),
                                        Module = Convert.ToString(n["Module"]),
                                        TotalRecords = Convert.ToInt32(n["TotalRecords"]),
                                        TotalPages = Convert.ToInt32(n["TotalPageCalc"]),
                                    }).ToList();
                    if (griddata != null && griddata.Count > 0)
                    {
                        //entity.NotificationgridData.AddRange(griddata);
                        notifications.AddRange(griddata);
                    }

                    //entity.NotificationgridData.ForEach((x) =>
                    //{
                    //    x.PageIndex = pageindex;
                    //    x.FirstRecord = ((pageindex - 1) * pagesize) + 1;
                    //    x.LastRecord = ((pageindex - 1) * pagesize) + pagesize;
                    //});

                }
                entity.NotificationgridData = notifications;
                entity.NotificationgridData.ForEach((x) =>
                {
                    x.PageIndex = pageindex;
                    x.FirstRecord = ((pageindex - 1) * pagesize) + 1;
                    x.LastRecord = ((pageindex - 1) * pagesize) + pagesize;
                });

                Log4NetLogger.LogExit(_FileName, nameof(GetNotification), Level.Info.ToString());
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
        public Notification ReseteNotificationCount(Notification notifi)
        {
            try
            {

                Log4NetLogger.LogEntry(_FileName, nameof(ReseteNotificationCount), Level.Info.ToString());
                Notification griddata = new Notification();
                var dbAccessDAL = new MASTERDBAccessDAL();
                var parameters = new Dictionary<string, string>();

                var DataSetparameters = new Dictionary<string, DataTable>();
                DataTable dt = new DataTable();
                dt.Columns.Add("NotificationId", typeof(int));
                dt.Columns.Add("CustomerId", typeof(int));
                dt.Columns.Add("FacilityId", typeof(int));
                dt.Columns.Add("UserId", typeof(int));

                dt.Columns.Add("NotificationAlerts", typeof(string));
                dt.Columns.Add("Remarks", typeof(string));
                dt.Columns.Add("HyperLink", typeof(string));
                dt.Columns.Add("IsNew", typeof(Boolean));
                dt.Columns.Add("SessionUserId", typeof(int));
                dt.Columns.Add("NotificationDateTime", typeof(DateTime));

                foreach (var i in notifi.NotificationgridData)
                {
                    dt.Rows.Add(i.NotificationId, _UserSession.CustomerId, _UserSession.FacilityId, _UserSession.UserId,
                        null, null, null, i.IsNew, _UserSession.UserId,null);
                }

                DataSetparameters.Add("@pWebNotification", dt);
                DataTable dt1 = dbAccessDAL.GetMASTERDataTable("uspFM_WebNotification_Save", parameters, DataSetparameters);
                if (dt1 != null)
                {
                    foreach (DataRow row in dt1.Rows)
                    {
                        //notifi.NotificationId = Convert.ToInt32(row["CaptureId"]);
                        //notifi.Timestamp = Convert.ToBase64String((byte[])(row["Timestamp"]));
                    }
                    
                }

                Log4NetLogger.LogExit(_FileName, nameof(ReseteNotificationCount), Level.Info.ToString());
                return notifi;
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
        public Notification ClearNavigatedRec(Notification notifi)
        {
            try
            {

                Log4NetLogger.LogEntry(_FileName, nameof(ClearNavigatedRec), Level.Info.ToString());
                Notification griddata = new Notification();
                var dbAccessDAL = new MASTERDBAccessDAL();
                var parameters = new Dictionary<string, string>();

                var DataSetparameters = new Dictionary<string, DataTable>();
                DataTable dt = new DataTable();
                dt.Columns.Add("NotificationId", typeof(int));
                dt.Columns.Add("IsNavigate", typeof(int));
                dt.Columns.Add("UserId", typeof(int));

                foreach (var i in notifi.NotificationgridData)
                {
                    dt.Rows.Add(i.NotificationId, i.Isnavigated, _UserSession.UserId);
                }

                DataSetparameters.Add("@WebNotificationNavigate", dt);
                DataTable dt1 = dbAccessDAL.GetMASTERDataTable("uspFM_WebNotificationNavigate_Update", parameters, DataSetparameters);
                if (dt1 != null)
                {
                    foreach (DataRow row in dt1.Rows)
                    {
                       // EODCaptur.CaptureId = Convert.ToInt32(row["CaptureId"]);                       
                    }
                }
                Log4NetLogger.LogExit(_FileName, nameof(ClearNavigatedRec), Level.Info.ToString());
                return notifi;
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

        public CustomerFacilityLovs LoadCustomer()
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(LoadCustomer), Level.Info.ToString());
                CustomerFacilityLovs EODCapDropdown = null;

                var ds = new DataSet();
                var ds1 = new DataSet();
                var ds2 = new DataSet();
                var dbAccessDAL = new MASTERDBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_UMUserRegistrationLoc_Fetch";
                        cmd.Parameters.AddWithValue("@pUserRegistrationId", _UserSession.UserId);                       
                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }

                EODCapDropdown = new CustomerFacilityLovs();
                if (ds.Tables.Count != 0)
                {
                    EODCapDropdown.Customers = dbAccessDAL.GetLovRecords(ds.Tables[0]);
                   // EODCapDropdown.CategorySystem = dbAccessDAL.GetLovRecords(ds.Tables[1]);
                }


                Log4NetLogger.LogExit(_FileName, nameof(LoadCustomer), Level.Info.ToString());
                return EODCapDropdown;
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
        public CustomerFacilityLovs LoadFacility(int CusId)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(LoadFacility), Level.Info.ToString());
                CustomerFacilityLovs EODCapDropdown = null;

                var ds = new DataSet();
                var ds1 = new DataSet();
                var ds2 = new DataSet();
                var dbAccessDAL = new MASTERDBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_Facility_GetByCustomerId";
                        cmd.Parameters.AddWithValue("@pUserRegistrationId", _UserSession.UserId);
                        cmd.Parameters.AddWithValue("@pCustomerId", CusId);
                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }

                EODCapDropdown = new CustomerFacilityLovs();
                if (ds.Tables.Count != 0)
                {
                    EODCapDropdown.Facilities = dbAccessDAL.GetLovRecords(ds.Tables[0]);
                    // EODCapDropdown.CategorySystem = dbAccessDAL.GetLovRecords(ds.Tables[1]);
                }


                Log4NetLogger.LogExit(_FileName, nameof(LoadCustomer), Level.Info.ToString());
                return EODCapDropdown;
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

        public CustomerFacilityLovs GetCustomerFacilityDet(int CusId, int FacId)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(GetCustomerAndFacilities), Level.Info.ToString());
                CustomerFacilityLovs customers = null;

                var ds = new DataSet();
                var ds1 = new DataSet();
                var ds2 = new DataSet();
                var dbAccessDAL = new MASTERDBAccessDAL();

                var customerId = _UserSession.CustomerId;
                var facilityId = _UserSession.FacilityId;
                //using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                //{
                //    using (SqlCommand cmd = new SqlCommand())
                //    {
                //        cmd.Connection = con;
                //        cmd.CommandType = CommandType.StoredProcedure;
                //        var spName = string.Empty;

                //        if (customerId == 0)
                //        {
                //            spName = "uspFM_UMUserRegistrationLoc_Fetch";
                //        }
                //        else
                //        {
                //            spName = "uspFM_UMUserRegistrationCustomer_Fetch";
                //        }
                //        cmd.CommandText = spName;
                //        cmd.Parameters.AddWithValue("@pUserRegistrationId", _UserSession.UserId);

                //        var da = new SqlDataAdapter();
                //        da.SelectCommand = cmd;
                //        da.Fill(ds);
                //    }
                //}

                //if (ds.Tables.Count != 0 && ds.Tables[0].Rows.Count > 0)
                //{
                   customers = new CustomerFacilityLovs();
                    var isDevelopmentMode = Convert.ToBoolean(ConfigurationManager.AppSettings["IsDevelopmentMode"]);

                    customers.IsDevelopmentMode = isDevelopmentMode ? 1 : 0;

                customers.CustomerId = _UserSession.CustomerId;
                customers.FacilityId = _UserSession.FacilityId;

                customers.CustomerName = _UserSession.CustomerName;
                customers.FacilityName = _UserSession.FacilityName;

                //customers.Customers = dbAccessDAL.GetLovRecords(ds.Tables[0]);

                //if (customerId == 0)
                //{
                //    customers.Facilities = dbAccessDAL.GetLovRecords(ds.Tables[1]);
                //}
                //else
                //{
                //    customers.Facilities = GetFacilities(customerId).Facilities;
                //}
                //}
                //if (customerId == 0)
                //{
                //    customers.CustomerId = (from n in customers.Customers
                //                            orderby n.FieldValue
                //                            select n.LovId).FirstOrDefault();
                //}
                //else
                //{
                //    customers.CustomerId = customerId;
                //}
                //if (facilityId == 0)
                //{
                //    customers.FacilityId = (from n in customers.Facilities
                //                            orderby n.FieldValue
                //                            select n.LovId).FirstOrDefault();
                //}
                //else
                //{
                //    customers.FacilityId = facilityId;
                //}

                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        var da1 = new SqlDataAdapter();
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_FMConfigCustomerValues_GetCustomerConfig";
                        cmd.Parameters.Clear();
                        cmd.Parameters.AddWithValue("@pCustomerId", _UserSession.CustomerId);
                        da1.SelectCommand = cmd;
                        da1.Fill(ds1);
                    }
                }

                if (ds1.Tables.Count != 0 && ds1.Tables[0].Rows.Count > 0)
                {
                    foreach (DataRow row in ds1.Tables[0].Rows)
                    {
                        if (row["KeyName"].ToString() == "Date")
                        {
                            customers.DateFormat = row["KeyValues"].ToString();
                        }
                        if (row["KeyName"].ToString() == "Currency")
                        {
                            customers.Currency = row["KeyValues"].ToString();
                        }
                    }
                }

                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        var da2 = new SqlDataAdapter();
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_UMUserRole_GetByFacilityId";
                        cmd.Parameters.Clear();
                        cmd.Parameters.AddWithValue("@pUserRegId", _UserSession.UserId);
                        cmd.Parameters.AddWithValue("@pFacilityId", _UserSession.FacilityId);
                        da2.SelectCommand = cmd;
                        da2.Fill(ds2);
                    }
                }

                if (ds2.Tables.Count != 0 && ds2.Tables[0].Rows.Count > 0)
                {
                    customers.UserRoleId = Convert.ToInt32(ds2.Tables[0].Rows[0]["UMUserRoleId"]);
                    customers.UserRoleName = Convert.ToString(ds2.Tables[0].Rows[0]["UserRoleName"]);
                }

                Log4NetLogger.LogExit(_FileName, nameof(GetCustomerAndFacilities), Level.Info.ToString());
                return customers;
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
        public int GetServices()
        {


            try
            {
                ISessionProvider _sessionProvider = SessionProviderFactory.GetSessionProvider();
                Log4NetLogger.LogEntry(_FileName, nameof(GetCustomerAndFacilities), Level.Info.ToString());
                CustomerFacilityLovs customers = null;

                var ds = new DataSet();

                var dbAccessDAL = new MASTERDBAccessDAL();
                //  var customerId = _UserSession.CustomerId;
                var facilityId = _UserSession.FacilityId;
                var userDetail = ((UserDetailsModel)_sessionProvider.Get(nameof(UserDetailsModel)));


                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        var spName = string.Empty;

                        spName = "Get_Services_byFacilityId";
                        cmd.CommandText = spName;
                        //  cmd.Parameters.AddWithValue("@pUserRegistrationId", _UserSession.UserId);
                        cmd.Parameters.AddWithValue("@FacilityID", _UserSession.FacilityId);

                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }

                if (ds.Tables.Count != 0 && ds.Tables[0].Rows.Count > 0)
                {


                    userDetail.FEMS = Convert.ToInt32(ds.Tables[0].Rows[0]["FEMS"]);
                    userDetail.BEMS = Convert.ToInt32(ds.Tables[0].Rows[0]["BEMS"]);
                    userDetail.CLS = Convert.ToInt32(ds.Tables[0].Rows[0]["CLS"]);
                    userDetail.LLS = Convert.ToInt32(ds.Tables[0].Rows[0]["LLS"]);
                    userDetail.HWMS = Convert.ToInt32(ds.Tables[0].Rows[0]["HWMS"]);


                }
                //  customers.CustomerId = customerId;
                // customers.FacilityId = facilityId;


                _sessionProvider.Set(nameof(UserDetailsModel), userDetail);

            }
            catch (DALException dalex)
            {
                throw new DALException(dalex);
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return 0;
        }
        public User_Maping_ID Get_User_IDS(int Master_User_IDS)
        {
            User_Maping_ID ULersids = new User_Maping_ID();
            var dss = new DataSet();
            var MasterdbAccessDAL = new MASTERDBAccessDAL();
            using (SqlConnection con = new SqlConnection(MasterdbAccessDAL.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = con;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "Get_MasterServices_byUserId";
                    cmd.Parameters.AddWithValue("@UserID", Master_User_IDS);
                    var da = new SqlDataAdapter();
                    da.SelectCommand = cmd;
                    da.Fill(dss);
                }
            }
            if (dss.Tables.Count != 0)
            {

                ULersids.FEMS_U_ID = Convert.ToInt32(dss.Tables[0].Rows[0]["FEMS"]);
                ULersids.BEMS_U_ID = Convert.ToInt32(dss.Tables[0].Rows[0]["BEMS"]);
            }
            // Log4NetLogger.LogExit(_FileName, nameof(Load), Level.Info.ToString());
            return ULersids;
        }

        public class User_Maping_ID
        {
            public int FEMS_U_ID { get; set; }
            public int BEMS_U_ID { get; set; }
        }
    }
}
