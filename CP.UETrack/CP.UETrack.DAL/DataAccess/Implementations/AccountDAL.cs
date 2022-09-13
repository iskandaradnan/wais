using CP.UETrack.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using CP.Framework.Common.Logging;
using CP.Framework.Common.ExceptionHandler.ExceptionWrappers;
using CP.UETrack.Models;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using UETrack.DAL;

namespace CP.UETrack.DAL.DataAccess
{
    enum HistoryType
    {
        ConCurrent = 1,
        Visitor = 2
    }
    public class AccountDAL : IAccountDAL
    {
        Log4NetLogger log = new Log4NetLogger();
        readonly UserDetailsModel _UserSession = new SessionHelper().UserSession();
        private readonly string _FileName = nameof(AccountDAL);
        public LoginViewModel IsAuthenticated(LoginViewModel loginUser)
        {
            try
            {
                var decodedUserName = System.Web.HttpUtility.UrlDecode(loginUser.LoginName);
                var enteredPassword = loginUser.Password.Trim();

                DateTime? invalidAttemptDateTime = DateTime.Now;

                var ds = new DataSet();
                string constring = ConfigurationManager.ConnectionStrings["UETrackConnectionString"].ConnectionString;
                using (SqlConnection con = new SqlConnection(constring))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_UMAuthenicateUser_Contractor_GetById";
                        cmd.Parameters.AddWithValue("@UserName", decodedUserName);
                        cmd.Parameters.AddWithValue("@Password", enteredPassword);
                        cmd.Parameters.AddWithValue("@AccessLevel", loginUser.AccessLevel);
                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);

                        if (ds.Tables.Count != 0 && ds.Tables[0].Rows.Count > 0)
                        {
                            if (ds.Tables[0].Rows[0]["InvalidAttemptDateTime"] == DBNull.Value)
                            {
                                invalidAttemptDateTime = null;
                            }
                            else
                            {
                                invalidAttemptDateTime = (DateTime)ds.Tables[0].Rows[0]["InvalidAttemptDateTime"];
                            }

                            loginUser = (from n in ds.Tables[0].AsEnumerable()
                                         select new LoginViewModel
                                         {
                                             UserId = Convert.ToInt32(n["UserId"]),
                                             IsAuthenticated = Convert.ToBoolean(n["IsAuthenticated"]),
                                             IsBlocked = Convert.ToBoolean(n["IsBlocked"]),
                                             IsUserValid = Convert.ToBoolean(n["IsUserValid"]),
                                             InvalidAttempts = Convert.ToInt32(n["InvalidAttempts"]),
                                             InvalidAttemptDateTime = invalidAttemptDateTime,
                                             StaffName = Convert.ToString(n["StaffName"]),
                                             IsValidCustomer = n.Field<bool>("IsValidCustomer"),
                                             UserTypeId = n.Field<int>("UserTypeId"),
                                         }).FirstOrDefault();

                        }
                    }
                }

                if (!loginUser.IsValidCustomer)
                {
                    loginUser.ErrorMessage = "Customer invalid for the user";
                }
                else
                {
                    var isAuthenticated = loginUser.IsAuthenticated;

                    if (isAuthenticated && !loginUser.IsBlocked)
                    {
                        loginUser.IsAuthenticated = true;
                    }
                    if (isAuthenticated && (!loginUser.IsBlocked && loginUser.InvalidAttempts > 0))
                    {
                        ResetInvalidAttempts(loginUser.UserId);
                        loginUser.InvalidAttempts = 0;
                    }

                    if (!isAuthenticated && loginUser.IsUserValid)
                    {
                        UpdateInvalidAttempts(loginUser);
                    }
                    if (loginUser.IsBlocked)
                    {
                        loginUser.IsAuthenticated = false;
                    }

                    if (loginUser.IsBlocked)
                    {
                        loginUser.ErrorMessage = "Your account has been blocked. Please contact your system administrator.";
                    }
                    else if (loginUser.InvalidAttempts > 0)
                    {
                        loginUser.ErrorMessage = "You have made " + loginUser.InvalidAttempts + " unsuccessful attempt(s). The maximum retry attempts allowed for login are " + loginUser.MaxInvalidAttempts + ".";
                    }
                    else if (!loginUser.IsAuthenticated)
                    {
                        loginUser.ErrorMessage = "Invalid Credentials.";
                    }
                }

                if((loginUser.IsAuthenticated == true) && (loginUser.ErrorMessage == null))
                {
                    GetFacilityCount(loginUser);
                }

                return loginUser;

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
        private void ResetInvalidAttempts(int userRegistrationId)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(ResetInvalidAttempts), Level.Info.ToString());

                string constring = ConfigurationManager.ConnectionStrings["UETrackConnectionString"].ConnectionString;
                using (SqlConnection con = new SqlConnection(constring))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_ResetInvalidAttempts_Save";
                        cmd.Parameters.AddWithValue("@pUserRegistrationId", userRegistrationId);

                        con.Open();
                        cmd.ExecuteNonQuery();
                        con.Close();
                    }
                }

                Log4NetLogger.LogExit(_FileName, nameof(ResetInvalidAttempts), Level.Info.ToString());
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
        private static void UpdateInvalidAttempts(LoginViewModel loginUser)
        {
            var currentDateTime = DateTime.Now;

            var invalidAttempts = 0;
            DateTime? invalidAttempteDateTime = null;
            var isBlocked = false;

            if (loginUser.InvalidAttemptDateTime == null
               || currentDateTime.Date == ((DateTime)loginUser.InvalidAttemptDateTime).Date)
            {
                invalidAttempts = ++loginUser.InvalidAttempts;
            }
            else if (currentDateTime.Date != ((DateTime)loginUser.InvalidAttemptDateTime).Date)
            {
                invalidAttempts = 1;
            }

            invalidAttempteDateTime = currentDateTime;
            var maxInvalidAttempts = Convert.ToInt32(ConfigurationManager.AppSettings["MaxInvalidAttempts"]);
            if (invalidAttempts >= maxInvalidAttempts)
            {
                isBlocked = true;
                loginUser.IsBlocked = true;
            }
            loginUser.InvalidAttempts = invalidAttempts;
            loginUser.MaxInvalidAttempts = maxInvalidAttempts;


            string constring = ConfigurationManager.ConnectionStrings["UETrackConnectionString"].ConnectionString;
            using (SqlConnection con = new SqlConnection(constring))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = con;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "uspFM_ResetBlockedUser_Save";
                    cmd.Parameters.AddWithValue("@pUserRegistrationId", loginUser.UserId);
                    cmd.Parameters.AddWithValue("@pInvalidAttempts", invalidAttempts);
                    cmd.Parameters.AddWithValue("@pInvalidAttemptDateTime", invalidAttempteDateTime);
                    cmd.Parameters.AddWithValue("@pIsBlocked", isBlocked);

                    con.Open();
                    cmd.ExecuteNonQuery();
                    con.Close();
                }
            }
        }
        public bool UpdateLoginAudit(string LoginName, string Password)
        {
            try
            {
                //using (var context = new ASISWebDatabaseEntities())
                //{
                //    using (var _asisUserRegistration = new Repository<AsisUserRegistration>(context))
                //    {
                //        using (var _asisLoginAudit = new Repository<UMLoginAudit>(context))
                //        {
                //            var ValidUser = _asisUserRegistration.Single(x => x.UserName.ToUpper() == LoginName.ToUpper()
                //                            && !x.IsDeleted
                //                            && x.Status == 413
                //                            && x.IsBlocked != true);
                //            if (ValidUser != null)
                //            {
                //                var currentDate = CommonFormatHelper.getCommonDateFormat(DateTime.Now);
                //                var ValidUserCredentials = _asisUserRegistration.Single(x => x.UserName.ToUpper() == LoginName.ToUpper() &&
                //                                            x.Password == Password && !x.IsDeleted);
                //                if (ValidUserCredentials != null)
                //                {
                //                    var LoginUserAudit = _asisLoginAudit.Single(x => x.NewUserRegistrationId == ValidUserCredentials.UserRegistrationId);
                //                    if (LoginUserAudit != null)
                //                    {
                //                        LoginUserAudit.CurrentFailedAttempts = 0;
                //                        LoginUserAudit.ModifiedBy = ValidUserCredentials.UserRegistrationId;
                //                        LoginUserAudit.ModifiedDate = currentDate;
                //                        LoginUserAudit.LastLoggedonDate = currentDate;
                //                        _asisLoginAudit.Update(LoginUserAudit);
                //                    }

                //                }
                //                else
                //                {
                //                    var LoginUserAudit = _asisLoginAudit.Single(x => x.NewUserRegistrationId == ValidUser.UserRegistrationId);

                //                    if (LoginUserAudit != null)
                //                    {

                //                        LoginUserAudit.TotalNumberofFailedAttempts = LoginUserAudit.TotalNumberofFailedAttempts == null ? 0 : LoginUserAudit.TotalNumberofFailedAttempts + 1;
                //                        LoginUserAudit.CurrentFailedAttempts = LoginUserAudit.CurrentFailedAttempts == null ? 0 : LoginUserAudit.CurrentFailedAttempts + 1;
                //                        LoginUserAudit.ModifiedBy = ValidUser.UserRegistrationId;
                //                        LoginUserAudit.ModifiedDate = currentDate;
                //                        LoginUserAudit.LastLoggedonDate = currentDate;
                //                        _asisLoginAudit.Update(LoginUserAudit);
                //                    }

                //                }
                //            }
                //        }
                //    }

                //}
            }
            catch (DALException ex)
            {

                log.LogMessage("An error has occured because of exception", Level.Info);
                throw new DALException(ex);
            }
            catch (Exception ex)
            {
                throw new Exception(ex.ToString());
            }
            return true;
        }
        public void SaveChangePasswordLinkDetails(string userName, string password)
        {
            try
            {
                //Log4NetLogger.LogEntry(fileName, nameof(SaveChangePasswordLinkDetails), Level.Info.ToString());

                //var createdBy = 0;

                //int count = 0;

                //using (var context = new ASISWebDatabaseEntities())
                //{
                //    count = (from n in context.UMChangePasswordLinkDetails
                //             where n.LoginName == userName && n.Password == password
                //             select n).Count();

                //    createdBy = 1;
                //}
                //if (count > 0) return;

                //var createdDate = CommonFormatHelper.getCommonDateFormat(DateTime.Now);
                //var modifiedDate = CommonFormatHelper.getCommonDateFormat(DateTime.Now);


                //var tranHelper = new TransactionHelper(new ASISWebDatabaseEntities());
                //var audit = new AuditDAL();
                ////var add = audit.GetAddedProperties(ClauseModel, nameof(AuditTable)) as List<object>;
                //var relatedEntities = new List<object>();

                ////if (add != null)
                ////{
                ////    foreach (var item in add)
                ////    {
                ////        relatedEntities.Add(item);
                ////    }
                ////}

                ////relatedEntities.Add(ClauseModel);
                //tranHelper.AddRelated(relatedEntities);

                //Log4NetLogger.LogExit(fileName, nameof(SaveChangePasswordLinkDetails), Level.Info.ToString());
            }
            catch (DALException dalException)
            {
                throw new DALException(dalException);
            }
            catch (Exception ex)
            {
                throw new DALException(ex);
            }
        }
        public bool IsLinkExpired(string userName, string password)
        {
            var linkExpired = false;
            try
            {
                //Log4NetLogger.LogEntry(fileName, nameof(IsLinkExpired), Level.Info.ToString());

                //using (var context = new ASISWebDatabaseEntities())
                //{
                //    var count = (from n in context.UMChangePasswordLinkDetails
                //                 where n.LoginName == userName && n.Password == password
                //                 && n.IsExpired
                //                 select n).Count();

                //    if (count > 0) linkExpired = true;
                //}

                //Log4NetLogger.LogExit(fileName, nameof(IsLinkExpired), Level.Info.ToString());
            }
            catch (Exception ex)
            {
                throw new GeneralException(ex);
            }

            return linkExpired;
        }
        public bool GetMultipleLoginSetting()     //Get User Details
        {
            try
            {
                //var allowMultipleLogins = false;
                //using (var context = new ASISWebDatabaseEntities())
                //{
                //    allowMultipleLogins = (from n in context.UmSystemParameters
                //                           where n.SystemKey == "AllowMultipleLogins"
                //                           select n.SystemValue).FirstOrDefault() == "1";
                //}
                //return allowMultipleLogins;
            }
            catch (DALException dalException)
            {
                throw new DALException(dalException);
            }
            catch (Exception ex)
            {
                throw new DALException(ex);
            }
            return true;
        }
        public bool UserSessionLogin(AboutModel LoginModel)
        {
            try
            {
                var allowMultipleLogins = false;
                //var sessionId = LoginModel.sessionId;
                //var loginType = LoginModel.loginType;
                //var UserId = _UserSession.UserId;
                //using (var context = new ASISWebDatabaseEntities())
                //{
                //    if (UserId == 0)
                //    {
                //        var UserDetails = context.AsisUserRegistrations.FirstOrDefault(r => !r.IsDeleted && r.UserName == LoginModel.LoginName);
                //        if (UserDetails != null)
                //        {
                //            UserId = UserDetails.UserRegistrationId;
                //        }
                //        var UserDetails1 = context.AsisVisitorHistories.FirstOrDefault(r => r.SessionId == LoginModel.sessionId);
                //        if (UserDetails1 != null)
                //        {
                //            UserId = UserDetails1.UserId;
                //        }
                //    }

                //}

                //var connectionString = ConfigurationManager.ConnectionStrings["AsisReportDataBase"].ConnectionString;
                //using (SqlConnection con = new SqlConnection(connectionString))
                //{
                //    if (loginType == (int)LoginType.Login)
                //    {
                //        using (SqlCommand cmd = new SqlCommand("GetUserSessionLogin", con))
                //        {
                //            cmd.CommandType = CommandType.StoredProcedure;
                //            cmd.Parameters.AddWithValue("@UserId", UserId);
                //            cmd.Parameters.AddWithValue("@SessionId", sessionId);
                //            con.Open();
                //            cmd.ExecuteNonQuery();
                //            con.Close();
                //            allowMultipleLogins = true;
                //        }
                //    }
                //    if (loginType == (int)LoginType.Logout)
                //    {

                //        using (SqlCommand cmd = new SqlCommand("GetUserSessionLogout", con))
                //        {
                //            cmd.CommandType = CommandType.StoredProcedure;
                //            cmd.Parameters.AddWithValue("@SessionId", sessionId);
                //            cmd.Parameters.AddWithValue("@UserId", UserId);
                //            con.Open();
                //            cmd.ExecuteNonQuery();
                //            con.Close();
                //            allowMultipleLogins = true;
                //        }

                //    }
                //}



                return allowMultipleLogins;
            }
            catch (DALException dalException)
            {
                throw new DALException(dalException);
            }
            catch (Exception ex)
            {
                throw new DALException(ex);
            }
        }
        public AboutModel GetConcurrentLoggedAndVistorHistory()
        {
            var Historyobj = new AboutModel();
            //var FromDate = DateTime.Now.Date;
            //var Todate = FromDate.AddDays(-6).Date;
            //using (var context = new ASISWebDatabaseEntities())
            //{

            //    var VistorHistory = context.AsisVisitorHistories.Where(f => f.LoggedIn == true &&  f.LoginTime >= Todate)//f.LoginTime <= FromDate ||
            //        .Select(s => new VistorHistoryCount
            //        {
            //            Date = s.LoginTime.ToString(),
            //            VisitorId = s.VisitorId
            //        }).ToList();
            //    VistorHistory.ForEach(c => { c.Date = Convert.ToDateTime(c.Date).ToString("dd-MM-yyyy"); });
            //    Historyobj.VistorHistory = (from History in VistorHistory
            //                                group History by History.Date into HistoryT
            //                                select new VistorHistoryCount
            //                                {
            //                                    Date = HistoryT.Key.ToString(),
            //                                    DateViceCount = HistoryT.Count()
            //                                }).Where(r => r.Date != string.Empty).OrderByDescending(or=>or.Date).ToList();


            //}
            //var connectionString = ConfigurationManager.ConnectionStrings["AsisReportDataBase"].ConnectionString;
            //using (SqlConnection con = new SqlConnection(connectionString))
            //{

            //    SqlCommand com = new SqlCommand("GetConcurrentLoggedHistoryList", con);
            //    com.CommandType = CommandType.StoredProcedure;
            //    SqlDataAdapter da = new SqlDataAdapter(com);
            //    DataTable dt = new DataTable();
            //    con.Open();
            //    da.Fill(dt);
            //    con.Close();
            //    var ConcurrentCount = (from DataRow dr in dt.Rows
            //                           select new VistorHistoryDetails()
            //                           {
            //                               UserId = Convert.ToString(dr["UserId"]),
            //                               SessionId = Convert.ToString(dr["SessionId"]),
            //                           }).Distinct().Count();
            //    Historyobj.LoggedConcurrentCount = ConcurrentCount;

            //}

            return Historyobj;
        }
        public List<VistorHistoryDetails> VisitorHistoryDetails(string Selecteddate, int? HistryType)
        {
            try
            {
                List<VistorHistoryDetails> VisitoryHistoryList = new List<VistorHistoryDetails>();
                // var SelectDate = Selecteddate == "null" ? (object)null : Convert.ToDateTime(Selecteddate).Date.ToString("yyyy-MM-dd");
                var connectionString = ConfigurationManager.ConnectionStrings["AsisReportDataBase"].ConnectionString;
                using (SqlConnection con = new SqlConnection(connectionString))
                {
                    if (HistryType == (int)HistoryType.Visitor)
                    {
                        SqlCommand com = new SqlCommand("GetVisitorHistoryList", con);
                        com.CommandType = CommandType.StoredProcedure;
                        com.Parameters.AddWithValue("@FromDate", Selecteddate);
                        com.Parameters.AddWithValue("@ToDate", Selecteddate);
                        SqlDataAdapter da = new SqlDataAdapter(com);
                        DataTable dt = new DataTable();
                        con.Open();
                        da.Fill(dt);
                        VisitoryHistoryList = (from DataRow dr in dt.Rows
                                               select new VistorHistoryDetails()
                                               {
                                                   UserId = Convert.ToString(dr["UserId"]),
                                                   UserName = Convert.ToString(dr["UserName"]),
                                                   SessionId = Convert.ToString(dr["SessionId"]),
                                                   LoginTime = Convert.ToString(dr["LoginTime"]),
                                                   LogoutTime = Convert.ToString(dr["LogoutTime"])
                                               }).ToList();
                    }

                    if (HistryType == (int)HistoryType.ConCurrent)
                    {
                        SqlCommand com = new SqlCommand("GetConcurrentLoggedHistoryList", con);
                        com.CommandType = CommandType.StoredProcedure;
                        SqlDataAdapter da = new SqlDataAdapter(com);
                        DataTable dt = new DataTable();
                        con.Open();
                        da.Fill(dt);
                        // con.Close();
                        VisitoryHistoryList = (from DataRow dr in dt.Rows
                                               select new VistorHistoryDetails()
                                               {
                                                   UserId = Convert.ToString(dr["UserId"]),
                                                   UserName = Convert.ToString(dr["UserName"]),
                                                   SessionId = Convert.ToString(dr["SessionId"]),
                                                   LoginTime = Convert.ToString(dr["LoginTime"])
                                               }).ToList();
                    }
                    con.Close();
                }


                return VisitoryHistoryList;

            }
            catch (DALException dalException)
            {
                throw new DALException(dalException);
            }
            catch (Exception ex)
            {
                throw new DALException(ex);
            }
        }


        public LoginViewModel GetFacilityCount(LoginViewModel ent)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(GetFacilityCount), Level.Info.ToString());
            LoginViewModel griddata = new LoginViewModel();
            // var dbAccessDAL = new MASTERDBAccessDAL();
            var dbAccessDAL = new MASTERDBAccessDAL();
            var parameters = new Dictionary<string, string>();
            var DataSetparameters = new Dictionary<string, DataTable>();


            parameters.Add("@pUserRegistrationId", Convert.ToString(ent.UserId));

            DataTable dt = dbAccessDAL.GetMASTERDataTable("uspFM_UserRegistrationCountDetails_GetById", parameters, DataSetparameters);
            if (dt != null && dt.Rows.Count > 0)
            {
                ent.IsMultipleFacility = Convert.ToBoolean(dt.Rows[0]["Result"]);
                //if (ent.IsMultipleFacility == false)
                    //{
                    //    ent.CustomerId = Convert.ToInt32(dt.Rows[0]["CustomerId"]);
                    //    ent.FacilityId = Convert.ToInt32(dt.Rows[0]["FacilityId"]);
                    //}
                    ent.CustomerId = Convert.ToInt32(dt.Rows[0]["CustomerId"]);
                    ent.FacilityId = Convert.ToInt32(dt.Rows[0]["FacilityId"]);
            }

            return ent;
        }

    }
}