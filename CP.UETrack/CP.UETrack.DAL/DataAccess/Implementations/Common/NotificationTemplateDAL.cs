using CP.Framework.Common.ExceptionHandler.ExceptionWrappers;
using CP.UETrack.CodeLib.Helpers;
using CP.UETrack.DAL.DataAccess;
using CP.UETrack.Model;
using CP.UETrack.Model.EMail;
using CP.UETrack.Models.EMail;
using System;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Linq.Dynamic;
using UETrack.DAL;

namespace CP.ASIS.DAL.DataAccess.Implementations
{
    public class NotificationTemplateDAL
    {        
        //LovDAL lovDAL { get; }
        readonly UserDetailsModel userSession;
        readonly UserDetailsModel _UserSession = new SessionHelper().UserSession();
        public NotificationTemplateDAL()
        {
            userSession = new SessionHelper().UserSession();
            //lovDAL = new LovDAL();
        }

        //public string GetTemplateType(int templateId)
        //{

        //    try
        //    {
        //        var typeName = string.Empty;
        //        using (var context = new ASISWebDatabaseEntities())
        //        {
        //            var x = context.NotificationTemplates
        //                                    .Join(context.AsisSysLovMsts,
        //                                            n => n.TypeId,
        //                                            l => l.LovId,
        //                                            (n, l) => new { n, l })
        //                                    .Where(a => a.n.NotificationTemplateId == templateId);
                    
        //        }
        //        return typeName;
        //    }
        //    catch (DALException dalException)
        //    {
        //        throw new DALException(dalException);
        //    }
        //    catch (Exception ex)
        //    {
        //        throw new DALException(ex);
        //    }

        //}

        //public bool IsCustomIdsAllowed(int emailTemplateId, string recepientType)
        //{
        //    try
        //    {
        //        var isAllowed = false;
        //        using (var context = new ASISWebDatabaseEntities())
        //        {
        //            var templateEntity = context.NotificationTemplates.First(x => x.NotificationTemplateId == emailTemplateId);
        //            if (templateEntity != null)
        //            {
        //                if (string.Equals(recepientType, "To", StringComparison.InvariantCultureIgnoreCase))
        //                    isAllowed = templateEntity.AllowCustomToIds;
        //                else if (string.Equals(recepientType, "Cc", StringComparison.InvariantCultureIgnoreCase))
        //                    isAllowed = templateEntity.AllowCustomCcIds;
        //            }
        //        }

        //        return isAllowed;
        //    }
        //    catch (DALException dalException)
        //    {
        //        throw new DALException(dalException);
        //    }
        //    catch (Exception ex)
        //    {
        //        throw new DALException(ex);
        //    }

        //}

        //public int? GetTemplateLevel(int emailTemplateId)
        //{
        //    try
        //    {
        //        using (var context = new ASISWebDatabaseEntities())
        //        {
        //            var templateLevel = context.NotificationTemplates.First(x => x.NotificationTemplateId == emailTemplateId).LeastEntityLevel;
        //            return templateLevel;
        //        }
        //    }
        //    catch (DALException dalException)
        //    {
        //        throw new DALException(dalException);
        //    }
        //    catch (Exception ex)
        //    {
        //        throw new DALException(ex);
        //    }
        //}

        public NotificationTemplate GetTemplate(int emailTemplateId)
        {
            try
            {
                NotificationTemplate result = null;

                var ds = new DataSet();
                var dbAccessDAL = new MASTERDBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_NotificationTemplate_GetById";

                        SqlParameter parameter = new SqlParameter();
                        cmd.Parameters.AddWithValue("@pNotificationTemplateId", emailTemplateId);

                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }

                if (ds.Tables.Count != 0 && ds.Tables[0].Rows.Count > 0)
                {
                    result = new NotificationTemplate();
                    result.NotificationTemplateId = Convert.ToInt32(ds.Tables[0].Rows[0]["NotificationTemplateId"]);
                    result.Name = Convert.ToString(ds.Tables[0].Rows[0]["Name"]);
                    result.Definition = Convert.ToString(ds.Tables[0].Rows[0]["Definition"]);
                    result.Subject = Convert.ToString(ds.Tables[0].Rows[0]["Subject"]);
                    result.AllowCustomToIds = Convert.ToBoolean(ds.Tables[0].Rows[0]["AllowCustomToIds"]);
                    result.AllowCustomCcIds = Convert.ToBoolean(ds.Tables[0].Rows[0]["AllowCustomCcIds"]);
                    result.LeastEntityLevel = Convert.ToInt32(ds.Tables[0].Rows[0]["LeastEntityLevel"]);
                    result.IsConfigurable = Convert.ToBoolean(ds.Tables[0].Rows[0]["IsConfigurable"]);
                }
                return result;
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

        //public List<Models.EMail.Email> GetEmailsForTemplate(int emailTemplateId, NotificationTemplateLevelEnum templateLevel, int companyId, int hospitalId)
        //{
        //    var allEmails = new List<Models.EMail.Email>();

        //    try
        //    {
        //        using (var context = new ASISWebDatabaseEntities())
        //        {
        //            var level1Emails = (from UR in context.UMUserRoles
        //                                join UL in context.AsisUserLocationMstDets on UR.UMUserRoleId equals UL.UserRoleId
        //                                join U in context.AsisUserRegistrations on UL.UserRegistrationId equals U.UserRegistrationId
        //                                join ND in context.NotificationDeliveryDets on UR.UMUserRoleId equals ND.UserRoleId
        //                                join NT in context.NotificationTemplates on ND.NotificationTemplateId equals NT.NotificationTemplateId
        //                                join UT in context.UMUserTypes on UR.UserTypeId equals UT.UserTypeId
        //                                where !UR.IsDeleted
        //                                        && !U.IsDeleted
        //                                        && !UL.IsDeleted
        //                                        && !ND.IsDeleted
        //                                        && !NT.IsDeleted
        //                                        && U.Status == (int)LovEnum.Active
        //                                        && NT.NotificationTemplateId == emailTemplateId
        //                                        && UT.EntityLevel == 1
        //                                        && ND.UserRegistrationId == null
        //                                select new Models.EMail.Email
        //                                {
        //                                    RecepientType = ND.RecepientType,
        //                                    EmailId = U.Email,
        //                                    HospitalId = UL.HospitalId
        //                                })
        //                                .Union(
        //                                from U in context.AsisUserRegistrations
        //                                join UL in context.AsisUserLocationMstDets on U.UserRegistrationId equals UL.UserRegistrationId
        //                                join UR in context.UMUserRoles on UL.UserRoleId equals UR.UMUserRoleId
        //                                join UT in context.UMUserTypes on UR.UserTypeId equals UT.UserTypeId
        //                                join ND in context.NotificationDeliveryDets on U.UserRegistrationId equals ND.UserRegistrationId
        //                                join NT in context.NotificationTemplates on ND.NotificationTemplateId equals NT.NotificationTemplateId
        //                                where !U.IsDeleted
        //                                            && !UR.IsDeleted
        //                                            && !UL.IsDeleted
        //                                            && !ND.IsDeleted                                                    
        //                                            && !NT.IsDeleted
        //                                            && U.Status == (int)LovEnum.Active
        //                                            && NT.NotificationTemplateId == emailTemplateId
        //                                            && UT.EntityLevel == 1
        //                                select new Models.EMail.Email
        //                                {
        //                                    RecepientType = ND.RecepientType,
        //                                    EmailId = U.Email,
        //                                    HospitalId = UL.HospitalId
        //                                }).Distinct().ToList();

        //            var level2Emails = (from UR in context.UMUserRoles
        //                                join UL in context.AsisUserLocationMstDets on UR.UMUserRoleId equals UL.UserRoleId
        //                                join U in context.AsisUserRegistrations on UL.UserRegistrationId equals U.UserRegistrationId
        //                                join ND in context.NotificationDeliveryDets on UR.UMUserRoleId equals ND.UserRoleId
        //                                join NT in context.NotificationTemplates on ND.NotificationTemplateId equals NT.NotificationTemplateId
        //                                join HM in context.GMHospitalMsts on UL.HospitalId equals HM.HospitalId
        //                                join UT in context.UMUserTypes on UR.UserTypeId equals UT.UserTypeId
        //                                where !UR.IsDeleted
        //                                            && !UL.IsDeleted
        //                                            && !U.IsDeleted
        //                                            && !ND.IsDeleted
        //                                            && !NT.IsDeleted
        //                                            && !HM.IsDeleted
        //                                            && U.Status == (int)LovEnum.Active
        //                                            && NT.NotificationTemplateId == emailTemplateId
        //                                            && HM.CompanyId == companyId
        //                                            && UT.EntityLevel == 2
        //                                            && ND.UserRegistrationId == null
        //                                select new Models.EMail.Email
        //                                {
        //                                    RecepientType = ND.RecepientType,
        //                                    EmailId = U.Email,
        //                                    HospitalId = UL.HospitalId
        //                                })
        //                                .Union(
        //                                from U in context.AsisUserRegistrations
        //                                join UL in context.AsisUserLocationMstDets on U.UserRegistrationId equals UL.UserRegistrationId
        //                                join UR in context.UMUserRoles on UL.UserRoleId equals UR.UMUserRoleId
        //                                join UT in context.UMUserTypes on UR.UserTypeId equals UT.UserTypeId
        //                                join ND in context.NotificationDeliveryDets on U.UserRegistrationId equals ND.UserRegistrationId
        //                                join NT in context.NotificationTemplates on ND.NotificationTemplateId equals NT.NotificationTemplateId
        //                                join HM in context.GMHospitalMsts on UL.HospitalId equals HM.HospitalId
        //                                where !U.IsDeleted
        //                                            && !UL.IsDeleted
        //                                            && !UR.IsDeleted
        //                                            && !ND.IsDeleted
        //                                            && !NT.IsDeleted
        //                                            && !HM.IsDeleted
        //                                            && U.Status == (int)LovEnum.Active
        //                                            && NT.NotificationTemplateId == emailTemplateId
        //                                            && HM.CompanyId == companyId
        //                                            && UT.EntityLevel == 2
        //                                select new Models.EMail.Email
        //                                {
        //                                    RecepientType = ND.RecepientType,
        //                                    EmailId = U.Email,
        //                                    HospitalId = UL.HospitalId
        //                                })                                        
        //                                .Distinct().ToList();

        //            var level3Emails = (from UR in context.UMUserRoles
        //                                join UL in context.AsisUserLocationMstDets on UR.UMUserRoleId equals UL.UserRoleId
        //                                join U in context.AsisUserRegistrations on UL.UserRegistrationId equals U.UserRegistrationId
        //                                join ND in context.NotificationDeliveryDets on UR.UMUserRoleId equals ND.UserRoleId
        //                                join NT in context.NotificationTemplates on ND.NotificationTemplateId equals NT.NotificationTemplateId
        //                                join UT in context.UMUserTypes on UR.UserTypeId equals UT.UserTypeId
        //                                where !UR.IsDeleted
        //                                        && !UL.IsDeleted
        //                                        && !U.IsDeleted
        //                                        && !ND.IsDeleted
        //                                        && !NT.IsDeleted
        //                                        && U.Status == (int)LovEnum.Active
        //                                        && NT.NotificationTemplateId == emailTemplateId
        //                                        && UT.EntityLevel == 3
        //                                        && ND.UserRegistrationId == null
        //                                select new Models.EMail.Email
        //                                {
        //                                    RecepientType = ND.RecepientType,
        //                                    EmailId = U.Email,
        //                                    HospitalId = UL.HospitalId
        //                                })
        //                                .Union(
        //                                from U in context.AsisUserRegistrations
        //                                join UL in context.AsisUserLocationMstDets on U.UserRegistrationId equals UL.UserRegistrationId
        //                                join UR in context.UMUserRoles on UL.UserRoleId equals UR.UMUserRoleId
        //                                join UT in context.UMUserTypes on UR.UserTypeId equals UT.UserTypeId
        //                                join ND in context.NotificationDeliveryDets on U.UserRegistrationId equals ND.UserRegistrationId
        //                                join NT in context.NotificationTemplates on ND.NotificationTemplateId equals NT.NotificationTemplateId
        //                                where !U.IsDeleted
        //                                            && !UL.IsDeleted
        //                                            && !UR.IsDeleted
        //                                            && !ND.IsDeleted
        //                                            && !NT.IsDeleted
        //                                            && U.Status == (int)LovEnum.Active
        //                                            && NT.NotificationTemplateId == emailTemplateId
        //                                            && UT.EntityLevel == 3
        //                                select new Models.EMail.Email
        //                                {
        //                                    RecepientType = ND.RecepientType,
        //                                    EmailId = U.Email,
        //                                    HospitalId = UL.HospitalId
        //                                })
        //                                .Distinct().ToList();

        //            if (templateLevel == NotificationTemplateLevelEnum.MoHLevel)
        //                allEmails = level1Emails;
        //            else if (templateLevel == NotificationTemplateLevelEnum.CompanyLevel)
        //            {
        //                allEmails = level1Emails;
        //                allEmails.AddRange(level2Emails);
        //            }
        //            else if (templateLevel == NotificationTemplateLevelEnum.HospitalLevel)
        //            {
        //                allEmails = level1Emails;
        //                allEmails.AddRange(level2Emails);
        //                allEmails.AddRange(level3Emails);
        //            }
        //            //emailTemplateId =16 (ProposalOfStandardCodeApproved) mail should go to all hospitals 
        //            //emailTemplateId = 12 (ProposalOfStandardCodeCreated) && emailTemplateId = 15 (ProposalOfStandardCodeDeleted) for the selected hospitals
        //            if (hospitalId != 0 && emailTemplateId != 12 && emailTemplateId != 367 && emailTemplateId != 39 &&
        //                emailTemplateId != 16 && emailTemplateId != 371 && emailTemplateId != 40 &&
        //                emailTemplateId != 71 && emailTemplateId != 373 && emailTemplateId != 70 &&
        //                emailTemplateId != 15 && emailTemplateId != 369 && emailTemplateId != 41)
        //            {
        //                allEmails = (from n in allEmails
        //                             where n.HospitalId == hospitalId
        //                             select new Models.EMail.Email
        //                             {
        //                                 RecepientType = n.RecepientType,
        //                                 EmailId = n.EmailId,
        //                             }).ToList();
        //            }
        //        }
        //        return allEmails.AsQueryable().Distinct().ToList();

        //    }
        //    catch (DALException dalException)
        //    {
        //        throw new DALException(dalException);
        //    }
        //    catch (Exception ex)
        //    {
        //        throw new DALException(ex);
        //    }

        //}

        //public List<Models.EMail.SMS> GetSMSForTemplate(int emailTemplateId, NotificationTemplateLevelEnum templateLevel, int companyId, int hospitalId)
        //{
        //    var allEmails = new List<Models.EMail.SMS>();

        //    try
        //    {
        //        using (var context = new ASISWebDatabaseEntities())
        //        {
        //            var level1Emails = (from UR in context.UMUserRoles
        //                                join UL in context.AsisUserLocationMstDets on UR.UMUserRoleId equals UL.UserRoleId
        //                                join U in context.AsisUserRegistrations on UL.UserRegistrationId equals U.UserRegistrationId
        //                                join ND in context.NotificationDeliveryDets on UR.UMUserRoleId equals ND.UserRoleId
        //                                join NT in context.NotificationTemplates on ND.NotificationTemplateId equals NT.NotificationTemplateId
        //                                join UT in context.UMUserTypes on UR.UserTypeId equals UT.UserTypeId
        //                                where !UR.IsDeleted
        //                                        && !U.IsDeleted
        //                                        && !UL.IsDeleted
        //                                        && !ND.IsDeleted
        //                                        && !NT.IsDeleted
        //                                        && U.Status == (int)LovEnum.Active
        //                                        && NT.NotificationTemplateId == emailTemplateId
        //                                        && UT.EntityLevel == 1
        //                                        && ND.UserRegistrationId == null
        //                                select new Models.EMail.SMS
        //                                {
        //                                    DestinationNo = U.MobileNumber,
        //                                    HospitalId = UL.HospitalId
        //                                })
        //                                .Union(
        //                                from U in context.AsisUserRegistrations
        //                                join UL in context.AsisUserLocationMstDets on U.UserRegistrationId equals UL.UserRegistrationId
        //                                join UR in context.UMUserRoles on UL.UserRoleId equals UR.UMUserRoleId
        //                                join UT in context.UMUserTypes on UR.UserTypeId equals UT.UserTypeId
        //                                join ND in context.NotificationDeliveryDets on U.UserRegistrationId equals ND.UserRegistrationId
        //                                join NT in context.NotificationTemplates on ND.NotificationTemplateId equals NT.NotificationTemplateId
        //                                where !U.IsDeleted
        //                                            && !UR.IsDeleted
        //                                            && !UL.IsDeleted
        //                                            && !ND.IsDeleted
        //                                            && !NT.IsDeleted
        //                                            && U.Status == (int)LovEnum.Active
        //                                            && NT.NotificationTemplateId == emailTemplateId
        //                                            && UT.EntityLevel == 1
        //                                select new Models.EMail.SMS
        //                                {
        //                                    DestinationNo = U.MobileNumber,
        //                                    HospitalId = UL.HospitalId
        //                                })
        //                                .ToList();

        //            var level2Emails = (from UR in context.UMUserRoles
        //                                join UL in context.AsisUserLocationMstDets on UR.UMUserRoleId equals UL.UserRoleId
        //                                join U in context.AsisUserRegistrations on UL.UserRegistrationId equals U.UserRegistrationId
        //                                join ND in context.NotificationDeliveryDets on UR.UMUserRoleId equals ND.UserRoleId
        //                                join NT in context.NotificationTemplates on ND.NotificationTemplateId equals NT.NotificationTemplateId
        //                                join HM in context.GMHospitalMsts on UL.HospitalId equals HM.HospitalId
        //                                join UT in context.UMUserTypes on UR.UserTypeId equals UT.UserTypeId
        //                                where !UR.IsDeleted
        //                                            && !UL.IsDeleted
        //                                            && !U.IsDeleted
        //                                            && !ND.IsDeleted
        //                                            && !NT.IsDeleted
        //                                            && !HM.IsDeleted
        //                                            && U.Status == (int)LovEnum.Active
        //                                            && NT.NotificationTemplateId == emailTemplateId
        //                                            && HM.CompanyId == companyId
        //                                            && UT.EntityLevel == 2
        //                                            && ND.UserRegistrationId == null
        //                                select new Models.EMail.SMS
        //                                {
        //                                    DestinationNo = U.MobileNumber,
        //                                    HospitalId = UL.HospitalId
        //                                })
        //                                .Union(
        //                                from U in context.AsisUserRegistrations
        //                                join UL in context.AsisUserLocationMstDets on U.UserRegistrationId equals UL.UserRegistrationId
        //                                join UR in context.UMUserRoles on UL.UserRoleId equals UR.UMUserRoleId
        //                                join UT in context.UMUserTypes on UR.UserTypeId equals UT.UserTypeId
        //                                join ND in context.NotificationDeliveryDets on U.UserRegistrationId equals ND.UserRegistrationId
        //                                join NT in context.NotificationTemplates on ND.NotificationTemplateId equals NT.NotificationTemplateId
        //                                join HM in context.GMHospitalMsts on UL.HospitalId equals HM.HospitalId
        //                                where !U.IsDeleted
        //                                            && !UL.IsDeleted
        //                                            && !UR.IsDeleted
        //                                            && !ND.IsDeleted
        //                                            && !NT.IsDeleted
        //                                            && !HM.IsDeleted
        //                                            && U.Status == (int)LovEnum.Active
        //                                            && NT.NotificationTemplateId == emailTemplateId
        //                                            //&& ND.HospitalId == hospitalId
        //                                            && HM.CompanyId == companyId
        //                                            && UT.EntityLevel == 2
        //                                select new Models.EMail.SMS
        //                                {
        //                                    DestinationNo = U.MobileNumber,
        //                                    HospitalId = UL.HospitalId
        //                                })
        //                                .ToList();

        //            var level3Emails = (from UR in context.UMUserRoles
        //                                join UL in context.AsisUserLocationMstDets on UR.UMUserRoleId equals UL.UserRoleId
        //                                join U in context.AsisUserRegistrations on UL.UserRegistrationId equals U.UserRegistrationId
        //                                join ND in context.NotificationDeliveryDets on UR.UMUserRoleId equals ND.UserRoleId
        //                                join NT in context.NotificationTemplates on ND.NotificationTemplateId equals NT.NotificationTemplateId
        //                                join UT in context.UMUserTypes on UR.UserTypeId equals UT.UserTypeId
        //                                where !UR.IsDeleted
        //                                        && !UL.IsDeleted
        //                                        && !U.IsDeleted
        //                                        && !ND.IsDeleted
        //                                        && !NT.IsDeleted
        //                                        && U.Status == (int)LovEnum.Active
        //                                        //&& UL.HospitalId == hospitalId
        //                                        && NT.NotificationTemplateId == emailTemplateId
        //                                        && UT.EntityLevel == 3
        //                                        && ND.UserRegistrationId == null
        //                                select new Models.EMail.SMS
        //                                {
        //                                    DestinationNo = U.MobileNumber,
        //                                    HospitalId = UL.HospitalId
        //                                })
        //                                .Union(
        //                                from U in context.AsisUserRegistrations
        //                                join UL in context.AsisUserLocationMstDets on U.UserRegistrationId equals UL.UserRegistrationId
        //                                join UR in context.UMUserRoles on UL.UserRoleId equals UR.UMUserRoleId
        //                                join UT in context.UMUserTypes on UR.UserTypeId equals UT.UserTypeId
        //                                join ND in context.NotificationDeliveryDets on U.UserRegistrationId equals ND.UserRegistrationId
        //                                join NT in context.NotificationTemplates on ND.NotificationTemplateId equals NT.NotificationTemplateId
        //                                where !U.IsDeleted
        //                                            && !UL.IsDeleted
        //                                            && !UR.IsDeleted
        //                                            && !ND.IsDeleted
        //                                            && !NT.IsDeleted
        //                                            && U.Status == (int)LovEnum.Active
        //                                            //&& ND.HospitalId == hospitalId
        //                                            && NT.NotificationTemplateId == emailTemplateId
        //                                            && UT.EntityLevel == 3
        //                                select new Models.EMail.SMS
        //                                {
        //                                    DestinationNo = U.MobileNumber,
        //                                    HospitalId = UL.HospitalId
        //                                })
        //                                .ToList();

        //            if (templateLevel == NotificationTemplateLevelEnum.MoHLevel)
        //                allEmails = level1Emails;
        //            else if(templateLevel == NotificationTemplateLevelEnum.CompanyLevel)
        //            {
        //                allEmails = level1Emails;
        //                allEmails.AddRange(level2Emails);
        //            }
        //            else if (templateLevel == NotificationTemplateLevelEnum.HospitalLevel)
        //            {
        //                allEmails = level1Emails;
        //                allEmails.AddRange(level2Emails);
        //                allEmails.AddRange(level3Emails);
        //            }
        //        if (hospitalId != 0)
        //        {
        //            allEmails = (from n in allEmails
        //                         where n.HospitalId == hospitalId
        //                         select new Models.EMail.SMS
        //                         {
        //                             DestinationNo = n.DestinationNo

        //                         }).ToList();
        //        }
        //        }
        //        return allEmails.AsQueryable().Distinct().ToList();

        //    }
        //    catch (DALException dalException)
        //    {
        //        throw new DALException(dalException);
        //    }
        //    catch (Exception ex)
        //    {
        //        throw new DALException(ex);
        //    }

        //}

        public int QueueEmail(EmailQueue queueItem)
        {
            var newId = 0;
            try
            {
                var ds = new DataSet();
                var dbAccessDAL = new MASTERDBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_EmailQueue_Save";

                        SqlParameter parameter = new SqlParameter();
                        if (_UserSession.CustomerId != 0)
                        {
                            cmd.Parameters.AddWithValue("@pCustomerId", _UserSession.CustomerId);
                        }

                        if (_UserSession.FacilityId != 0)
                        {
                            cmd.Parameters.AddWithValue("@pFacilityId", _UserSession.FacilityId);
                        }
                        cmd.Parameters.AddWithValue("@pToIds", queueItem.ToIds);
                        cmd.Parameters.AddWithValue("@pCcIds", queueItem.CcIds);
                        cmd.Parameters.AddWithValue("@pBccIds", queueItem.BccIds);
                        cmd.Parameters.AddWithValue("@pReplyIds", queueItem.ReplyIds);
                        cmd.Parameters.AddWithValue("@pSubject", queueItem.Subject);
                        cmd.Parameters.AddWithValue("@pEmailTemplateId", queueItem.EmailTemplateId);
                        cmd.Parameters.AddWithValue("@pTemplateVars", queueItem.TemplateVars);
                        cmd.Parameters.AddWithValue("@pContentBody", queueItem.ContentBody);
                        cmd.Parameters.AddWithValue("@pSendAsHtml", queueItem.SendAsHtml);
                        cmd.Parameters.AddWithValue("@pPriority", queueItem.Priority);
                        cmd.Parameters.AddWithValue("@pStatus", 1);
                        cmd.Parameters.AddWithValue("@pTypeId", queueItem.TypeId);
                        cmd.Parameters.AddWithValue("@pGroupId", queueItem.GroupId);
                        if (_UserSession.UserId != 0)
                        {
                            cmd.Parameters.AddWithValue("@pQueuedBy", _UserSession.UserId);
                        }
                        cmd.Parameters.AddWithValue("@pSubjectVars", queueItem.SubjectVars);
                        if (_UserSession.UserId != 0)
                        {
                            cmd.Parameters.AddWithValue("@pUserId", _UserSession.UserId);
                        }

                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }

                if (ds.Tables.Count != 0 && ds.Tables[0].Rows.Count > 0)
                {
                    queueItem.EmailQueueId = Convert.ToInt32(ds.Tables[0].Rows[0]["EmailQueueId"]);
                }
            }
            catch (DALException dx)
            {
                throw new DALException(dx);
            }
            catch (Exception ex)
            {
                //throw new DALException(ex);
                UETrackLogger.Log(ex);
                UETrackLogger.Log(ex.StackTrace);
            }
            return newId;

        }

        //public List<int> QueueSMS(List<SMSQueue> queueItems)
        //{
        //    var ids = new List<int>();

        //    try
        //    {
        //        var tranHelper = new TransactionHelper(new ASISWebDatabaseEntities());
        //        var result = tranHelper.AddAndGetRelatedEntities(queueItems);

        //        if (result != null)
        //        {
        //            ids = (from n in result
        //                    select n.Id).ToList();
        //        }
        //        //using (var context = new ASISWebDatabaseEntities())
        //        //{
                    
        //        //    foreach (var item in queueItems)
        //        //    {
        //        //        context.SMSQueues.Add(item);
        //        //    }
        //        //    context.SaveChanges();
        //        //}
        //    }
        //    catch (DALException dx)
        //    {
        //        throw new DALException(dx);
        //    }
        //    catch (Exception ex)
        //    {
        //        //throw new DALException(ex);
        //        UETrackLogger.Log(ex.Message);
        //    }
        //    return ids;
        //}

     
    }

}
