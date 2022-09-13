using CP.UETrack.Model;
using System;
using CP.Framework.Common.Logging;
using CP.Framework.Common.ExceptionHandler.ExceptionWrappers;
using System.Data;
using System.Data.SqlClient;
using UETrack.DAL;
using System.Configuration;
using CP.UETrack.Model.EMail;
using System.Collections.Generic;
using CP.ASIS.DAL.Helper;

namespace CP.UETrack.DAL.DataAccess
{
    public class ForgotPasswordDAL : IForgotPasswordDAL
    {
        private readonly string _FileName = nameof(ForgotPasswordDAL);
        //readonly UserDetailsModel _UserSession = new SessionHelper().UserSession();
        readonly string _mailSubject = "Forgot Password";
        public ForgotPassword Save(ForgotPassword forgotPassword, out string ErrorMessage)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());

                ErrorMessage = string.Empty;
                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_UserGetDetails_Save";

                        SqlParameter parameter = new SqlParameter();
                        cmd.Parameters.AddWithValue("@pEmail", forgotPassword.Email);
                        
                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }
                if (ds.Tables.Count != 0 && ds.Tables[0].Rows.Count > 0)
                {
                    forgotPassword.StaffName = Convert.ToString(ds.Tables[0].Rows[0]["StaffName"]);
                    forgotPassword.Email = Convert.ToString(ds.Tables[0].Rows[0]["Email"]);
                    forgotPassword.Password = Convert.ToString(ds.Tables[0].Rows[0]["Password"]);
                    forgotPassword.Username = Convert.ToString(ds.Tables[0].Rows[0]["Username"]);
                    forgotPassword.ErrorMessage = "successfully sent your password to your email ";
                }
                else
                {
                }
                SendMail(forgotPassword);

                Log4NetLogger.LogExit(_FileName, nameof(Save), Level.Info.ToString());
                return forgotPassword;
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
        private void SendMail(ForgotPassword forgotPassword)
        {
            var loginName = string.Empty;
            var staffName = string.Empty;
            var password = string.Empty;
            var emailId = string.Empty;
            var createdBy = 0;
            try
            {
                loginName = forgotPassword.Username;
                staffName = forgotPassword.StaffName;
                password = forgotPassword.Password;
                emailId = forgotPassword.Email;
                //createdBy = _UserSession.UserId;
                //var queueingUserName = _UserSession.UserName;

                if (!string.IsNullOrWhiteSpace(emailId))
                {
                    var hostName = ConfigurationManager.AppSettings["EmailIUrl"].ToString();
                    var emailContent = new EmailContent
                    {
                        ToEmailIds = new List<string> { emailId },
                        Subject = _mailSubject,
                        EmailTemplateId = 2,
                        TemplateVars = new List<string> { staffName, hostName, loginName, password },
                        MailPriority = EmailPriority.High,
                        sendAsHtml = true,
                        SubjectVars = new List<string> { "UETrack - Forgot Password" }
                    };

                    var queueId = EMailHelper.QueueEmail(emailContent, createdBy, 0, 0);
                   
                }
            }
            catch (Exception ex)
            {
                throw;
            }
        }
        public bool IsUsernameInValid(ForgotPassword forgotPassword)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(IsUsernameInValid), Level.Info.ToString());

                var IsInvalid = true;
                string constring = ConfigurationManager.ConnectionStrings["UETrackConnectionString"].ConnectionString;
                using (SqlConnection con = new SqlConnection(constring))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_UserRegistration_UserCheck";
                        cmd.Parameters.AddWithValue("@pUserName", forgotPassword.Username);
                        
                        cmd.Parameters.Add("@IsInvalid", SqlDbType.Bit);
                        cmd.Parameters["@IsInvalid"].Direction = ParameterDirection.Output;

                        con.Open();
                        cmd.ExecuteNonQuery();
                        con.Close();
                        bool.TryParse(cmd.Parameters["@IsInvalid"].Value.ToString(), out IsInvalid);
                    }
                }

                Log4NetLogger.LogExit(_FileName, nameof(IsUsernameInValid), Level.Info.ToString());
                return IsInvalid;
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
        public bool IsInvalidEmailId(ForgotPassword forgotPassword)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(IsInvalidEmailId), Level.Info.ToString());

                var isInvalid = true;
                string constring = ConfigurationManager.ConnectionStrings["UETrackConnectionString"].ConnectionString;
                using (SqlConnection con = new SqlConnection(constring))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_UserRegistration_UserEmailCheck";
                        cmd.Parameters.AddWithValue("@pEmail", forgotPassword.Email);

                        cmd.Parameters.Add("@IsInvalidEmail", SqlDbType.Bit);
                        cmd.Parameters["@IsInvalidEmail"].Direction = ParameterDirection.Output;

                        con.Open();
                        cmd.ExecuteNonQuery();
                        con.Close();
                        bool.TryParse(cmd.Parameters["@IsInvalidEmail"].Value.ToString(), out isInvalid);
                    }
                }

                Log4NetLogger.LogExit(_FileName, nameof(IsInvalidEmailId), Level.Info.ToString());
                return isInvalid;
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