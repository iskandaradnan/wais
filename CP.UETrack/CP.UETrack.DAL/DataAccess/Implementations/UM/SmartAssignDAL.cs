using System.Linq;
using CP.Framework.Common.Logging;
using CP.Framework.Common.ExceptionHandler.ExceptionWrappers;
using CP.UETrack.Models;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using UETrack.DAL;
using System.Dynamic;
using CP.UETrack.DAL.DataAccess.Implementation;
using CP.UETrack.DAL.DataAccess.Contracts.UM;
using CP.UETrack.Model.UM;
using CP.UETrack.Model;
using System.Collections.Generic;
using System;
using System.Net.Http;
using System.Collections;
using System.Web;
using Newtonsoft.Json;
using Newtonsoft.Json.Linq;
using System.Net;
using System.IO;
using System.Text;

namespace CP.UETrack.DAL.DataAccess.Implementations.UM
{
    public class SmartAssignDAL : ISmartAssignDAL
    {
        private readonly string _FileName = nameof(TrackingTechnicianDAL);
        readonly UserDetailsModel _UserSession = new SessionHelper().UserSession();
        public void RunSmartAssign()
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(RunSmartAssign), Level.Info.ToString());
                List<SmartAssign_GetPending> SmartAssign_GetPending = new List<SmartAssign_GetPending>();
                List<SmartAssign_GetAvailableFieldEngineers> SmartAssign_GetAvailableFieldEngineers = new List<SmartAssign_GetAvailableFieldEngineers>();

                var SmartAssign_GetPending_ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
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
                ////Raise Breakdown Smart Assign
                if (SmartAssign_GetPending_ds.Tables.Count != 0 && SmartAssign_GetPending_ds.Tables[0].Rows.Count > 0)
                {

                    SmartAssign_GetPending = (from n in SmartAssign_GetPending_ds.Tables[0].AsEnumerable()
                                              select new SmartAssign_GetPending
                                              {
                                                  WorkOrderId = Convert.ToInt32(n["WorkOrderId"]),
                                                  FacilityId = Convert.ToInt32(n["FacilityId"]),
                                                  Latitude = Convert.ToDecimal(n["Latitude"]),
                                                  Longitude = Convert.ToDecimal(n["Longitude"]),
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

                Log4NetLogger.LogExit(_FileName, nameof(RunSmartAssign), Level.Info.ToString());



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

        public float getDistance(string origin, string destination)
        {

            float km = 0;         
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




        public GridFilterResult SmartAssignGetAll(SortPaginateFilter pageFilter)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(SmartAssignGetAll), Level.Info.ToString());
                GridFilterResult filterResult = null;

                var multipleOrderBy = pageFilter.SortColumn.Split(',');
                var strOrderBy = string.Empty;
                var strOrdery1 = new StringBuilder();
                foreach (var order in multipleOrderBy)
                {
                    strOrdery1.Append(order);
                    strOrdery1.Append(" ");
                    strOrdery1.Append(pageFilter.SortOrder);
                    strOrdery1.Append(",");
                }
                strOrderBy = strOrdery1.ToString();
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
                        cmd.CommandText = "uspFM_GetAssignedWorkOrder_GetAll";

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







                Log4NetLogger.LogExit(_FileName, nameof(SmartAssignGetAll), Level.Info.ToString());
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

        public GridFilterResult PorteringSmartAssignGetAll(SortPaginateFilter pageFilter)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(PorteringSmartAssignGetAll), Level.Info.ToString());
                GridFilterResult filterResult = null;

                var multipleOrderBy = pageFilter.SortColumn.Split(',');
                var strOrderBy = string.Empty;
                var strOrdery1 = new StringBuilder();
                foreach (var order in multipleOrderBy)
                {
                    strOrdery1.Append(order);
                    strOrdery1.Append(" ");
                    strOrdery1.Append(pageFilter.SortOrder);
                    strOrdery1.Append(",");
                }
                strOrderBy = strOrdery1.ToString();
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
                        cmd.CommandText = "uspFM_GetAssignedPortering_GetAll";
                        cmd.Parameters.AddWithValue("@PageSize", pageFilter.PageSize);
                        cmd.Parameters.AddWithValue("@PageIndex", pageFilter.PageIndex);
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
                Log4NetLogger.LogExit(_FileName, nameof(PorteringSmartAssignGetAll), Level.Info.ToString());
                return filterResult;
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
        
    }
}
