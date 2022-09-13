using CP.UETrack.Model;
using System;
using System.Linq;
using CP.Framework.Common.Logging;
using CP.Framework.Common.ExceptionHandler.ExceptionWrappers;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using UETrack.DAL;
using System.Collections.Generic;
using CP.UETrack.Models;

namespace CP.UETrack.DAL.DataAccess
{
    public class PPMLoadBalancingDAL : IPPMLoadBalancingDAL
    {
        private readonly string _FileName = nameof(PPMLoadBalancingDAL);
        readonly UserDetailsModel _UserSession = new SessionHelper().UserSession();
        public PPMLoadBalancingLovs Load()
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
                var pPMLoadBalancingLovs = new PPMLoadBalancingLovs();
                var currentYear = DateTime.Now.Year;
                var nextYear = currentYear + 1;
                pPMLoadBalancingLovs.Years = new List<LovValue> { new LovValue { LovId= currentYear, FieldValue= currentYear.ToString() }, new LovValue { LovId= nextYear, FieldValue = nextYear.ToString() } };
                pPMLoadBalancingLovs.CurrentYear = currentYear;
                Log4NetLogger.LogExit(_FileName, nameof(Load), Level.Info.ToString());
                return pPMLoadBalancingLovs;
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
        public PPMLoadBalancing GetWorkOrderDetails(PPMLoadBalancingFetch loadBalancingFetch)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(GetWorkOrderDetails), Level.Info.ToString());
                PPMLoadBalancing pPMLoadBalancing = null;

                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_PPMLoadBalancing_GetAll";
                        cmd.Parameters.AddWithValue("@pYear", loadBalancingFetch.Year);
                        cmd.Parameters.AddWithValue("@pAssetClassificationId", loadBalancingFetch.AssetClassificationId);
                        cmd.Parameters.AddWithValue("@pStaffMasterId", loadBalancingFetch.StaffMasterId);
                        cmd.Parameters.AddWithValue("@pUserAreaId", loadBalancingFetch.UserAreaId);
                        cmd.Parameters.AddWithValue("@pUserLocationId", loadBalancingFetch.UserLocationId);
                        cmd.Parameters.AddWithValue("@pFacilityId", _UserSession.FacilityId);

                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }
                if (ds.Tables.Count != 0 && ds.Tables[0].Rows.Count > 0)
                {
                    var totalRecords = Convert.ToInt32((ds.Tables[0].Rows[0]["TotalRecordsPerYear"]));
                    if (totalRecords > 0)
                    {
                        pPMLoadBalancing = new PPMLoadBalancing
                        {
                            TotalNoOfWorkOrders = Convert.ToInt32((ds.Tables[0].Rows[0]["TotalRecordsPerYear"])),
                            AverageNoOfWorkOrders = Convert.ToDouble((ds.Tables[0].Rows[0]["AvgRecordsPerMonth"])),
                        };
                    }
                }
                if (ds.Tables.Count != 0 && ds.Tables[1].Rows.Count > 0)
                {
                    for (int i = 0; i < ds.Tables[1].Rows.Count; i++)
                    {
                        var row = ds.Tables[1].Rows[i];
                        switch (row["Month"].ToString().ToLower())
                        {
                            case "jan":
                                pPMLoadBalancing.Jan1 = Convert.ToInt32(row[1]);
                                pPMLoadBalancing.Jan2 = Convert.ToInt32(row[2]);
                                pPMLoadBalancing.Jan3 = Convert.ToInt32(row[3]);
                                pPMLoadBalancing.Jan4 = Convert.ToInt32(row[4]);
                                pPMLoadBalancing.Jan5 = Convert.ToInt32(row[5]);
                                pPMLoadBalancing.Total1 = pPMLoadBalancing.Jan1 + pPMLoadBalancing.Jan2 + pPMLoadBalancing.Jan3 + pPMLoadBalancing.Jan4 + pPMLoadBalancing.Jan5;
                                break;                                                                   
                            case "feb":                                                                   
                                pPMLoadBalancing.Feb1 = Convert.ToInt32(row[1]);
                                pPMLoadBalancing.Feb2 = Convert.ToInt32(row[2]);
                                pPMLoadBalancing.Feb3 = Convert.ToInt32(row[3]);
                                pPMLoadBalancing.Feb4 = Convert.ToInt32(row[4]);
                                pPMLoadBalancing.Feb5 = Convert.ToInt32(row[5]);
                                pPMLoadBalancing.Total2 = pPMLoadBalancing.Feb1 + pPMLoadBalancing.Feb2 + pPMLoadBalancing.Feb3 + pPMLoadBalancing.Feb4 + pPMLoadBalancing.Feb5;
                                break;
                            case "mar":
                                pPMLoadBalancing.Mar1 = Convert.ToInt32(row[1]);
                                pPMLoadBalancing.Mar2 = Convert.ToInt32(row[2]);
                                pPMLoadBalancing.Mar3 = Convert.ToInt32(row[3]);
                                pPMLoadBalancing.Mar4 = Convert.ToInt32(row[4]);
                                pPMLoadBalancing.Mar5 = Convert.ToInt32(row[5]);
                                pPMLoadBalancing.Total3 = pPMLoadBalancing.Mar1 + pPMLoadBalancing.Mar2 + pPMLoadBalancing.Mar3 + pPMLoadBalancing.Mar4 + pPMLoadBalancing.Mar5;
                                break;
                            case "apr":
                                pPMLoadBalancing.Apr1 = Convert.ToInt32(row[1]);
                                pPMLoadBalancing.Apr2 = Convert.ToInt32(row[2]);
                                pPMLoadBalancing.Apr3 = Convert.ToInt32(row[3]);
                                pPMLoadBalancing.Apr4 = Convert.ToInt32(row[4]);
                                pPMLoadBalancing.Apr5 = Convert.ToInt32(row[5]);
                                pPMLoadBalancing.Total4 = pPMLoadBalancing.Apr1 + pPMLoadBalancing.Apr2 + pPMLoadBalancing.Apr3 + pPMLoadBalancing.Apr4 + pPMLoadBalancing.Apr5;
                                break;
                            case "may":
                                pPMLoadBalancing.May1 = Convert.ToInt32(row[1]);
                                pPMLoadBalancing.May2 = Convert.ToInt32(row[2]);
                                pPMLoadBalancing.May3 = Convert.ToInt32(row[3]);
                                pPMLoadBalancing.May4 = Convert.ToInt32(row[4]);
                                pPMLoadBalancing.May5 = Convert.ToInt32(row[5]);
                                pPMLoadBalancing.Total5 = pPMLoadBalancing.May1 + pPMLoadBalancing.May2 + pPMLoadBalancing.May3 + pPMLoadBalancing.May4 + pPMLoadBalancing.May5;
                                break;
                            case "jun":
                                pPMLoadBalancing.Jun1 = Convert.ToInt32(row[1]);
                                pPMLoadBalancing.Jun2 = Convert.ToInt32(row[2]);
                                pPMLoadBalancing.Jun3 = Convert.ToInt32(row[3]);
                                pPMLoadBalancing.Jun4 = Convert.ToInt32(row[4]);
                                pPMLoadBalancing.Jun5 = Convert.ToInt32(row[5]);
                                pPMLoadBalancing.Total6 = pPMLoadBalancing.Jun1 + pPMLoadBalancing.Jun2 + pPMLoadBalancing.Jun3 + pPMLoadBalancing.Jun4 + pPMLoadBalancing.Jun5;
                                break;
                            case "jul":
                                pPMLoadBalancing.Jul1 = Convert.ToInt32(row[1]);
                                pPMLoadBalancing.Jul2 = Convert.ToInt32(row[2]);
                                pPMLoadBalancing.Jul3 = Convert.ToInt32(row[3]);
                                pPMLoadBalancing.Jul4 = Convert.ToInt32(row[4]);
                                pPMLoadBalancing.Jul5 = Convert.ToInt32(row[5]);
                                pPMLoadBalancing.Total7 = pPMLoadBalancing.Jul1 + pPMLoadBalancing.Jul2 + pPMLoadBalancing.Jul3 + pPMLoadBalancing.Jul4 + pPMLoadBalancing.Jul5;
                                break;
                            case "aug":
                                pPMLoadBalancing.Aug1 = Convert.ToInt32(row[1]);
                                pPMLoadBalancing.Aug2 = Convert.ToInt32(row[2]);
                                pPMLoadBalancing.Aug3 = Convert.ToInt32(row[3]);
                                pPMLoadBalancing.Aug4 = Convert.ToInt32(row[4]);
                                pPMLoadBalancing.Aug5 = Convert.ToInt32(row[5]);
                                pPMLoadBalancing.Total8 = pPMLoadBalancing.Aug1 + pPMLoadBalancing.Aug2 + pPMLoadBalancing.Aug3 + pPMLoadBalancing.Aug4 + pPMLoadBalancing.Aug5;
                                break;
                            case "sep":
                                pPMLoadBalancing.Sep1 = Convert.ToInt32(row[1]);
                                pPMLoadBalancing.Sep2 = Convert.ToInt32(row[2]);
                                pPMLoadBalancing.Sep3 = Convert.ToInt32(row[3]);
                                pPMLoadBalancing.Sep4 = Convert.ToInt32(row[4]);
                                pPMLoadBalancing.Sep5 = Convert.ToInt32(row[5]);
                                pPMLoadBalancing.Total9 = pPMLoadBalancing.Sep1 + pPMLoadBalancing.Sep2 + pPMLoadBalancing.Sep3 + pPMLoadBalancing.Sep4 + pPMLoadBalancing.Sep5;
                                break;
                            case "oct":
                                pPMLoadBalancing.Oct1 = Convert.ToInt32(row[1]);
                                pPMLoadBalancing.Oct2 = Convert.ToInt32(row[2]);
                                pPMLoadBalancing.Oct3 = Convert.ToInt32(row[3]);
                                pPMLoadBalancing.Oct4 = Convert.ToInt32(row[4]);
                                pPMLoadBalancing.Oct5 = Convert.ToInt32(row[5]);
                                pPMLoadBalancing.Total10 = pPMLoadBalancing.Oct1 + pPMLoadBalancing.Oct2 + pPMLoadBalancing.Oct3 + pPMLoadBalancing.Oct4 + pPMLoadBalancing.Oct5;
                                break;
                            case "nov":
                                pPMLoadBalancing.Nov1 = Convert.ToInt32(row[1]);
                                pPMLoadBalancing.Nov2 = Convert.ToInt32(row[2]);
                                pPMLoadBalancing.Nov3 = Convert.ToInt32(row[3]);
                                pPMLoadBalancing.Nov4 = Convert.ToInt32(row[4]);
                                pPMLoadBalancing.Nov5 = Convert.ToInt32(row[5]);
                                pPMLoadBalancing.Total11 = pPMLoadBalancing.Nov1 + pPMLoadBalancing.Nov2 + pPMLoadBalancing.Nov3 + pPMLoadBalancing.Nov4 + pPMLoadBalancing.Nov5;
                                break;
                            case "dec":
                                pPMLoadBalancing.Dec1 = Convert.ToInt32(row[1]);
                                pPMLoadBalancing.Dec2 = Convert.ToInt32(row[2]);
                                pPMLoadBalancing.Dec3 = Convert.ToInt32(row[3]);
                                pPMLoadBalancing.Dec4 = Convert.ToInt32(row[4]);
                                pPMLoadBalancing.Dec5 = Convert.ToInt32(row[5]);
                                pPMLoadBalancing.Total12 = pPMLoadBalancing.Dec1 + pPMLoadBalancing.Dec2 + pPMLoadBalancing.Dec3 + pPMLoadBalancing.Dec4 + pPMLoadBalancing.Dec5;
                                break;
                        }
                    }
                }
                Log4NetLogger.LogExit(_FileName, nameof(GetWorkOrderDetails), Level.Info.ToString());
                return pPMLoadBalancing;
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
        public List<PPMLoadBalancingWorkOrder> GetWorkOrders(PPMLoadBalancingWorkOrder loadBalancingWorkOrder)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(GetWorkOrders), Level.Info.ToString());
                List<PPMLoadBalancingWorkOrder> result = null;
                var pageIndex = loadBalancingWorkOrder.PageIndex;
                var pageSize = Convert.ToInt32(ConfigurationManager.AppSettings["LoadBalancingPageSize"]);

                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con; 
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_PPMLoadBalancing_PopUp";

                        cmd.Parameters.AddWithValue("@pYear", loadBalancingWorkOrder.Year);
                        cmd.Parameters.AddWithValue("@pAssetClassificationId", loadBalancingWorkOrder.AssetClassificationId);
                        cmd.Parameters.AddWithValue("@pStaffMasterId", loadBalancingWorkOrder.StaffMasterId);
                        cmd.Parameters.AddWithValue("@pUserAreaId", loadBalancingWorkOrder.UserAreaId);
                        cmd.Parameters.AddWithValue("@pUserLocationId", loadBalancingWorkOrder.UserLocationId);
                        cmd.Parameters.AddWithValue("@pMonth", loadBalancingWorkOrder.Month);
                        cmd.Parameters.AddWithValue("@pWeek", loadBalancingWorkOrder.Week);
                        cmd.Parameters.AddWithValue("@pFacilityId", _UserSession.FacilityId);
                        cmd.Parameters.AddWithValue("@pPageIndex", pageIndex);
                        cmd.Parameters.AddWithValue("@pPageSize", pageSize);

                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }
                if (ds.Tables.Count != 0 && ds.Tables[0].Rows.Count > 0)
                {
                    var totalRecords = Convert.ToInt32(ds.Tables[0].Rows[0]["TotalRecords"]);
                    var firstRecord = (pageIndex - 1) * pageSize + 1;
                    var lastRecord = (pageIndex - 1) * pageSize + ds.Tables[0].Rows.Count;
                    var lastPageIndex = totalRecords % pageSize == 0 ? totalRecords / pageSize : (totalRecords / pageSize) + 1;

                    result = (from n in ds.Tables[0].AsEnumerable()
                              select new PPMLoadBalancingWorkOrder
                              {
                                  WorkOrderId = n.Field<int>("WorkOrderId"),
                                  MaintenanceWorkNo = n.Field<string>("MaintenanceWorkNo"),
                                  AssetNo = n.Field<string>("AssetNo"),
                                  AssetDescription = n.Field<string>("AssetDescription"),
                                  TargetDateTime = n.Field<DateTime>("TargetDateTime"),
                                  WorkOrderStatus = n.Field<int>("WorkOrderStatus"),
                                  WorkOrderStatusValue = n.Field<string>("WorkOrderStatusValue"),
                                  Assignee = n.Field<string>("Assignee"),
                                  Timestamp = Convert.ToBase64String(n.Field<byte[]>("Timestamp")),
                                  TotalRecords = totalRecords,
                                  FirstRecord = firstRecord,
                                  LastRecord = lastRecord,
                                  LastPageIndex = lastPageIndex
                              }).ToList();
                }

                Log4NetLogger.LogExit(_FileName, nameof(GetWorkOrders), Level.Info.ToString());
                return result;
            }
            catch (DALException dalex)
            {
                throw new DALException(dalex);
            }
            catch (Exception ex)
            {
                Log4NetLogger.LogEntry("ERROR", ex.Message + ex.InnerException, Level.Error.ToString());
                throw;
            }
        }
        public PPMLoadBalancingWorkOrders Save(PPMLoadBalancingWorkOrders pPMLoadBalancing, out string ErrorMessage)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());

                ErrorMessage = string.Empty;

                var dataTable = new DataTable("udt_PPMLoadBalancing");
                dataTable.Columns.Add("WorkOrderId", typeof(int));
                dataTable.Columns.Add("TargetDateTime", typeof(DateTime));
                dataTable.Columns.Add("NewAssigneeId", typeof(int));
                dataTable.Columns.Add("UserId", typeof(int));
                dataTable.Columns.Add("Timestamp", typeof(byte[]));

                var userId = _UserSession.UserId;
                foreach (var item in pPMLoadBalancing.WorkOrders)
                {
                    dataTable.Rows.Add(item.WorkOrderId, item.TargetDateTime, item.NewAssigneeId, userId, Convert.FromBase64String(item.Timestamp));
                }


                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_PPMLoadBalancing_Save";

                        var parameter = new SqlParameter();
                        parameter.ParameterName = "@PPMLoadBalancing";
                        parameter.SqlDbType = SqlDbType.Structured;
                        parameter.Value = dataTable;
                        cmd.Parameters.Add(parameter);
                       
                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }
                if (ds.Tables.Count != 0 && ds.Tables[0].Rows.Count > 0)
                {
                    ErrorMessage = Convert.ToString(ds.Tables[0].Rows[0]["ErrorMessage"]);
                }

                Log4NetLogger.LogExit(_FileName, nameof(Save), Level.Info.ToString());
                return pPMLoadBalancing;
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