namespace CP.Framework.Common.SmartAssign.Implementation
{
    using Logging;
    using System;
    using System.Data;
    using System.Linq;
    using System.Collections.Generic;
    using System.Configuration;
    using System.Data.Entity;
    using System.Data.Entity.SqlServer;
    using System.Net;
    using System.Data.SqlClient;
    using Entity;
    using System.Net.Http;
    using System.IO;
    using System.Text;
    using Newtonsoft.Json.Linq;
    public class QueueSmartAssign
    {
        private readonly Log4NetLogger _logger;
        private readonly DbContext _emailDbContext;
        private int processedCount = 0;
        public QueueSmartAssign()
        {
            _logger = new Log4NetLogger();
        }
        public QueueSmartAssign(Log4NetLogger logger)
        {
            _logger = logger;
        }
        public QueueSmartAssign(Log4NetLogger logger, DbContext dbContext)
        {
            _logger = logger;
            _emailDbContext = dbContext;
        }

        public int ProcessNotAssignedEmail()
        {
            try
            {
                List<SmartAssign_GetPending> SmartAssign_GetPending = new List<SmartAssign_GetPending>();
                var SmartAssign_GetPendingEmail_ds = new DataSet();
                var dbAccessDAL = new DBAccess();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_SmartAssign_GetPendingBDRequest_SendMail";
                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(SmartAssign_GetPendingEmail_ds);
                        if (SmartAssign_GetPendingEmail_ds.Tables.Count != 0 && SmartAssign_GetPendingEmail_ds.Tables[0].Rows.Count > 0)
                        {
                            SmartAssign_GetPending = (from n in SmartAssign_GetPendingEmail_ds.Tables[0].AsEnumerable()
                                                      select new SmartAssign_GetPending
                                                      {
                                                          WorkOrderId = Convert.ToInt32(n["WorkOrderId"]),
                                                          FacilityId = Convert.ToInt32(n["FacilityId"]),
                                                          Latitude = Convert.ToDecimal(n["Latitude"]),
                                                          Longitude = Convert.ToDecimal(n["Longitude"]),
                                                          MaintenanceWorkNo = Convert.ToString(n["MaintenanceWorkNo"]),
                                                      }).ToList();

                            foreach (var n in SmartAssign_GetPending)
                            {
                                SendMailSmartNotAssign(n.MaintenanceWorkNo, n.FacilityId);
                            }
                        }
                    }
                }
            }
            catch (Exception ex)
            {
                if (_logger != null)
                    _logger.LogException(ex, Level.Error);

                throw ex;
            }
            return 0;
        }
        public int ProcessSmartAssign()
        {
            try
            {

                List<SmartAssign_GetPending> SmartAssign_GetPending = new List<SmartAssign_GetPending>();
                List<SmartAssign_GetAvailableFieldEngineers> SmartAssign_GetAvailableFieldEngineers = new List<SmartAssign_GetAvailableFieldEngineers>();
                SamrtAssign_Email _samrtAssign_Email = new SamrtAssign_Email();
                var SmartAssign_GetPending_ds = new DataSet();
                var dbAccessDAL = new DBAccess();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_SmartAssign_GetPendingBDRequest";
                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(SmartAssign_GetPending_ds);
                    }
                }
                #region Raise Breakdown Smart Assign
                if (SmartAssign_GetPending_ds.Tables.Count != 0 && SmartAssign_GetPending_ds.Tables[0].Rows.Count > 0)
                {
                    SmartAssign_GetPending = (from n in SmartAssign_GetPending_ds.Tables[0].AsEnumerable()
                                              select new SmartAssign_GetPending
                                              {
                                                  WorkOrderId = Convert.ToInt32(n["WorkOrderId"]),
                                                  FacilityId = Convert.ToInt32(n["FacilityId"]),
                                                  Latitude = Convert.ToDecimal(n["Latitude"]),
                                                  Longitude = Convert.ToDecimal(n["Longitude"]),
                                                  MaintenanceWorkNo = Convert.ToString(n["MaintenanceWorkNo"]),
                                              }).ToList();
                    foreach (var n in SmartAssign_GetPending)
                    {
                        var origin = n.Latitude + "," + n.Longitude;
                        var SmartAssign_GetEngineer_ds = new DataSet();
                        using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                        {
                            using (SqlCommand cmd = new SqlCommand())
                            {
                                cmd.Connection = con;
                                cmd.CommandType = CommandType.StoredProcedure;
                                cmd.CommandText = "uspFM_SmartAssign_GetAvailableFieldEngineers";
                                cmd.Parameters.AddWithValue("@pWorkOrderId", n.WorkOrderId);
                                cmd.Parameters.AddWithValue("@pSourceLatitude", n.Latitude);
                                cmd.Parameters.AddWithValue("@pSourceLongitude", n.Longitude);
                                var da = new SqlDataAdapter();
                                da.SelectCommand = cmd;
                                da.Fill(SmartAssign_GetEngineer_ds);
                            }
                        }
                        if (SmartAssign_GetEngineer_ds.Tables.Count != 0 && SmartAssign_GetEngineer_ds.Tables[0].Rows.Count > 0)
                        {
                            SmartAssign_GetAvailableFieldEngineers = (from n1 in SmartAssign_GetEngineer_ds.Tables[0].AsEnumerable()
                                                                      select new SmartAssign_GetAvailableFieldEngineers
                                                                      {
                                                                          UserRegistrationId = Convert.ToInt32(n1["UserRegistrationId"]),
                                                                          UserGradeId = Convert.ToInt32(n1["UserGradeId"]),
                                                                          UserGrade = Convert.ToString(n1["UserGrade"]),
                                                                          DistanceInKms = Convert.ToDecimal(n1["DistanceInKms"]),
                                                                          Latitude = Convert.ToDecimal(n1["Latitude"]),
                                                                          Longitude = Convert.ToDecimal(n1["Longitude"]),
                                                                          DistanceInRoad = Convert.ToDecimal(n1["DistanceInRoad"])
                                                                      }).ToList();
                            foreach (var n1 in SmartAssign_GetAvailableFieldEngineers)
                            {
                                var destination = n1.Latitude + "," + n1.Longitude;
                                float kilometer = getDistance(origin, destination);

                                var data = SmartAssign_GetAvailableFieldEngineers.FirstOrDefault(d => d.UserRegistrationId == n1.UserRegistrationId);
                                if (data != null)
                                {
                                    SmartAssign_GetAvailableFieldEngineers.FirstOrDefault(d => d.UserRegistrationId == n1.UserRegistrationId).DistanceInRoad = Convert.ToDecimal(kilometer);
                                }

                            }
                            var newList = SmartAssign_GetAvailableFieldEngineers.OrderBy(x => x.DistanceInRoad)
                                         .ThenBy(x => x.UserGradeId)
                                         .First();
                            var SmartAssign_SuccesReturnval_ds = new DataSet();
                            using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                            {
                                using (SqlCommand cmd = new SqlCommand())
                                {
                                    cmd.Connection = con;
                                    cmd.CommandType = CommandType.StoredProcedure;
                                    cmd.CommandText = "uspFM_WorkOrderAssigne_Save";
                                    cmd.Parameters.AddWithValue("@pWorkOrderId", n.WorkOrderId);
                                    cmd.Parameters.AddWithValue("@pAssignedUserId", newList.UserRegistrationId);
                                    cmd.Parameters.AddWithValue("@pAssigneeLovId", 331);
                                    var da = new SqlDataAdapter();
                                    da.SelectCommand = cmd;
                                    da.Fill(SmartAssign_SuccesReturnval_ds);

                                }
                            }
                            if (SmartAssign_SuccesReturnval_ds.Tables.Count != 0 && SmartAssign_SuccesReturnval_ds.Tables[0].Rows.Count > 0)
                            {
                                processedCount = processedCount + 1;
                                _samrtAssign_Email = (from n1 in SmartAssign_SuccesReturnval_ds.Tables[0].AsEnumerable()
                                                      select new SamrtAssign_Email
                                                      {
                                                          WorkOrderId = Convert.ToInt32(n1["WorkOrderId"]),
                                                          AssignedUserId = Convert.ToInt32(n1["AssignedUserId"]),
                                                          AssigneEmail = Convert.ToString(n1["AssigneEmail"]),
                                                          MaintenanceWorkNo = Convert.ToString(n1["MaintenanceWorkNo"]),
                                                          AssignDate = Convert.ToDateTime(n1["AssignDate"]),
                                                          FacilityId = Convert.ToInt32(n1["FacilityId"]),
                                                          AssigneeName = Convert.ToString(n1["AssigneeName"]),
                                                      }).FirstOrDefault();
                                SendMailSmartAssign(_samrtAssign_Email);
                                SendMailSmartAssignFM(_samrtAssign_Email);
                            }
                        }

                    }
                }

                #endregion
                #region Portering Smart Assign
                List<SmartAssign_GetPending> PorteringSmartAssign_GetPending = new List<SmartAssign_GetPending>();
                List<SmartAssign_GetAvailableFieldEngineers> PorteringSmartAssign_GetAvailableFieldEngineers = new List<SmartAssign_GetAvailableFieldEngineers>();
                var SmartAssign_GetPendingPorteringRequest_ds = new DataSet();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_SmartAssign_GetPendingPortering";
                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(SmartAssign_GetPendingPorteringRequest_ds);
                    }
                }

                if (SmartAssign_GetPendingPorteringRequest_ds.Tables.Count != 0 && SmartAssign_GetPendingPorteringRequest_ds.Tables[0].Rows.Count > 0)
                {

                    PorteringSmartAssign_GetPending = (from n in SmartAssign_GetPendingPorteringRequest_ds.Tables[0].AsEnumerable()
                                                       select new SmartAssign_GetPending
                                                       {
                                                           WorkOrderId = Convert.ToInt32(n["PorteringId"]),
                                                           FacilityId = Convert.ToInt32(n["FacilityId"]),
                                                           Latitude = Convert.ToDecimal(n["Latitude"]),
                                                           Longitude = Convert.ToDecimal(n["Longitude"]),
                                                       }).ToList();

                    foreach (var n in PorteringSmartAssign_GetPending)
                    {
                        var origin = n.Latitude + "," + n.Longitude;
                        var PorteringSmartAssign_GetEngineer_ds = new DataSet();
                        using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                        {
                            using (SqlCommand cmd = new SqlCommand())
                            {
                                cmd.Connection = con;
                                cmd.CommandType = CommandType.StoredProcedure;
                                cmd.CommandText = "uspFM_SmartAssign_GetAvailablePorters";
                                cmd.Parameters.AddWithValue("@pPorteringId", n.WorkOrderId);
                                cmd.Parameters.AddWithValue("@pSourceLatitude", n.Latitude);
                                cmd.Parameters.AddWithValue("@pSourceLongitude", n.Longitude);
                                var da = new SqlDataAdapter();
                                da.SelectCommand = cmd;
                                da.Fill(PorteringSmartAssign_GetEngineer_ds);
                            }
                        }
                        if (PorteringSmartAssign_GetEngineer_ds.Tables.Count != 0 && PorteringSmartAssign_GetEngineer_ds.Tables[0].Rows.Count > 0)
                        {

                            PorteringSmartAssign_GetAvailableFieldEngineers = (from n1 in PorteringSmartAssign_GetEngineer_ds.Tables[0].AsEnumerable()
                                                                               select new SmartAssign_GetAvailableFieldEngineers
                                                                               {
                                                                                   UserRegistrationId = Convert.ToInt32(n1["UserRegistrationId"]),
                                                                                   UserGradeId = Convert.ToInt32(n1["UserGradeId"]),
                                                                                   UserGrade = Convert.ToString(n1["UserGrade"]),
                                                                                   DistanceInKms = Convert.ToDecimal(n1["DistanceInKms"]),
                                                                                   Latitude = Convert.ToDecimal(n1["Latitude"]),
                                                                                   Longitude = Convert.ToDecimal(n1["Longitude"]),
                                                                                   DistanceInRoad = Convert.ToDecimal(n1["DistanceInRoad"])
                                                                               }).ToList();
                            foreach (var n1 in PorteringSmartAssign_GetAvailableFieldEngineers)
                            {
                                var destination = n1.Latitude + "," + n1.Longitude;
                                float kilometer = getDistance(origin, destination);
                                var data = PorteringSmartAssign_GetAvailableFieldEngineers.FirstOrDefault(d => d.UserRegistrationId == n1.UserRegistrationId);
                                if (data != null)
                                {
                                    PorteringSmartAssign_GetAvailableFieldEngineers.FirstOrDefault(d => d.UserRegistrationId == n1.UserRegistrationId).DistanceInRoad = Convert.ToDecimal(kilometer);
                                }

                            }
                            var newList = PorteringSmartAssign_GetAvailableFieldEngineers.OrderBy(x => x.DistanceInRoad)
                                         .ThenBy(x => x.UserGradeId)
                                         .First();
                            var SmartAssign_SuccesReturnval_ds = new DataSet();
                            using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                            {
                                using (SqlCommand cmd = new SqlCommand())
                                {
                                    cmd.Connection = con;
                                    cmd.CommandType = CommandType.StoredProcedure;
                                    cmd.CommandText = "uspFM_PorteringAssigne_Save";
                                    cmd.Parameters.AddWithValue("@pPorteringId", n.WorkOrderId);
                                    cmd.Parameters.AddWithValue("@pAssignedUserId", newList.UserRegistrationId);
                                    cmd.Parameters.AddWithValue("@pAssigneeLovId", 331);
                                    var da = new SqlDataAdapter();
                                    da.SelectCommand = cmd;
                                    da.Fill(SmartAssign_SuccesReturnval_ds);
                                }
                            }
                        }

                    }

                }
                #endregion
            }
            catch (Exception ex)
            {
                if (_logger != null)
                    _logger.LogException(ex, Level.Error);

                throw ex;
            }

            return processedCount;
        }

        public float getDistance(string origin, string destination)
        {
            float km = 0;
            try
            {

                System.Net.Http.HttpClient Client = new System.Net.Http.HttpClient(new HttpClientHandler { UseProxy = false });
                string wayPoints = null;
                string baseUrl = "https://maps.googleapis.com/maps/api/directions/json?origin=" + origin + "&destination=" + destination + "&waypoints=" + wayPoints + "&key=AIzaSyAkqCkh3sb4lVPt4U-DHmnHej5AWYKbtIo";

                HttpResponseMessage response = Client.GetAsync(baseUrl).Result;
                if (response.IsSuccessStatusCode)
                {
                    string result = response.Content.ReadAsStringAsync().Result;
                    JObject o = JObject.Parse(result);
                    try
                    {
                        int distance = (int)o.SelectToken("routes[0].legs[0].distance.value");
                        km = (float)distance / 1000;
                        return km;
                    }
                    catch
                    {
                        return km;
                    }
                }
                return km;

            }
            catch (Exception ex)
            {
                if (_logger != null)
                    _logger.LogException(ex, Level.Error);

                throw ex;
            }
            return km;
        }
        private void SendMailSmartNotAssign(string Wno, int FacilityId)
        {

            try
            {
                string emailTemplateId = string.Empty;
                string subject = string.Empty;
                string subjectVars = string.Empty;
                string templateVars = string.Empty;
                string email = string.Empty;

                emailTemplateId = "41";
                templateVars = string.Join(",", Wno);


                var ds = new DataSet();
                var dbAccessDAL = new DBAccess();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_EmailNotify_Save";
                        cmd.Parameters.AddWithValue("@pEmailTemplateId", Convert.ToString(emailTemplateId));
                        cmd.Parameters.AddWithValue("@pToEmailIds", Convert.ToString(email));
                        cmd.Parameters.AddWithValue("@pSubject", Convert.ToString(subject));
                        cmd.Parameters.AddWithValue("@pPriority", Convert.ToString(1));
                        cmd.Parameters.AddWithValue("@pSendAsHtml", Convert.ToString(1));
                        cmd.Parameters.AddWithValue("@pSubjectVars", Convert.ToString(subjectVars));
                        cmd.Parameters.AddWithValue("@pTemplateVars", Convert.ToString(templateVars));
                        cmd.Parameters.AddWithValue("@pFacilityId", Convert.ToString(FacilityId));
                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }

            }
            catch (Exception ex)
            {
                throw;
            }
        }
        private void SendMailSmartAssign(SamrtAssign_Email Emaildata)
        {

            try
            {
                string emailTemplateId = string.Empty;
                string subject = string.Empty;
                string subjectVars = string.Empty;
                string templateVars = string.Empty;
                string email = Emaildata.AssigneEmail;
                emailTemplateId = "36";
                templateVars = string.Join(",", Emaildata.MaintenanceWorkNo);


                var ds = new DataSet();
                var dbAccessDAL = new DBAccess();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_EmailNotify_Save";
                        cmd.Parameters.AddWithValue("@pEmailTemplateId", Convert.ToString(emailTemplateId));
                        cmd.Parameters.AddWithValue("@pToEmailIds", Convert.ToString(email));
                        cmd.Parameters.AddWithValue("@pSubject", Convert.ToString(subject));
                        cmd.Parameters.AddWithValue("@pPriority", Convert.ToString(1));
                        cmd.Parameters.AddWithValue("@pSendAsHtml", Convert.ToString(1));
                        cmd.Parameters.AddWithValue("@pSubjectVars", Convert.ToString(subjectVars));
                        cmd.Parameters.AddWithValue("@pTemplateVars", Convert.ToString(templateVars));
                        cmd.Parameters.AddWithValue("@pFacilityId", Convert.ToString(Emaildata.FacilityId));
                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }




            }

            catch (Exception ex)
            {
                throw;
            }
        }
        private void SendMailSmartAssignFM(SamrtAssign_Email Emaildata)
        {

            try
            {
                string emailTemplateId = string.Empty;
                string subject = string.Empty;
                string subjectVars = string.Empty;
                string templateVars = string.Empty;
                string email = string.Empty;
                emailTemplateId = "40";
                templateVars = string.Join(",", Emaildata.MaintenanceWorkNo, Emaildata.AssigneeName);


                var ds = new DataSet();
                var dbAccessDAL = new DBAccess();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_EmailNotify_Save";
                        cmd.Parameters.AddWithValue("@pEmailTemplateId", Convert.ToString(emailTemplateId));
                        cmd.Parameters.AddWithValue("@pToEmailIds", Convert.ToString(email));
                        cmd.Parameters.AddWithValue("@pSubject", Convert.ToString(subject));
                        cmd.Parameters.AddWithValue("@pPriority", Convert.ToString(1));
                        cmd.Parameters.AddWithValue("@pSendAsHtml", Convert.ToString(1));
                        cmd.Parameters.AddWithValue("@pSubjectVars", Convert.ToString(subjectVars));
                        cmd.Parameters.AddWithValue("@pTemplateVars", Convert.ToString(templateVars));
                        cmd.Parameters.AddWithValue("@pFacilityId", Convert.ToString(Emaildata.FacilityId));
                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }




            }

            catch (Exception ex)
            {
                throw;
            }
        }
    }
}
