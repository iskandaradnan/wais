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
using System.Dynamic;
using CP.UETrack.DAL.DataAccess.Implementation;
using CP.UETrack.Model.HWMS;
using CP.UETrack.DAL.DataAccess.Contracts.HWMS;


namespace CP.UETrack.DAL.DataAccess.Implementations.HWMS
{
   public class TransportationCategoryDAL : ITransportationCategoryDAL
    {
        private readonly string _FileName = nameof(TransportationCategoryDAL);
        readonly UserDetailsModel _UserSession = new SessionHelper().UserSession();     
        public TransportationCategoryDropDown Load()
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                TransportationCategoryDropDown transportationDropdownvalues = new TransportationCategoryDropDown();

                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        var da = new SqlDataAdapter();
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "sp_HWMS_TransportationCategory_DropDown";
                        cmd.Parameters.Clear();
                        cmd.Parameters.AddWithValue("@pScreenName", "TransportationCategory");
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                        if (ds.Tables[0] != null)
                        {
                            transportationDropdownvalues.StatusLovs = dbAccessDAL.GetLovRecords(ds.Tables[0]);
                        }
                    }
                }
                Log4NetLogger.LogExit(_FileName, nameof(Load), Level.Info.ToString());
                return transportationDropdownvalues;
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
        public TransportationCategory Save(TransportationCategory model, out string ErrorMessage)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());
                ErrorMessage = string.Empty;
                var spName = string.Empty;

                var ds = new DataSet();
                var ds1 = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "Sp_HWMS_RouteTransportation_Save";

                        cmd.Parameters.AddWithValue("@RouteTransportationId", model.RouteTransportationId);
                        cmd.Parameters.AddWithValue("@CustomerId", model.CustomerId);
                        cmd.Parameters.AddWithValue("@FacilityId", model.FacilityId);
                        cmd.Parameters.AddWithValue("@RouteCode", model.RouteCode);
                        cmd.Parameters.AddWithValue("@RouteDescription", model.RouteDescription);
                        cmd.Parameters.AddWithValue("@RouteCategory", model.RouteCategory);
                        cmd.Parameters.AddWithValue("@Status", model.Status);

                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);

                        if (ds.Tables.Count != 0)
                        {
                            if (ds.Tables[0].Rows[0][0].ToString() == "-1")
                            {
                                ErrorMessage = "Route Code already exists";
                            }
                            else
                            {
                                model.RouteTransportationId = Convert.ToInt32(ds.Tables[0].Rows[0]["RouteTransportationId"]);
                                
                                cmd.Parameters.Clear();
                                cmd.Connection = con;
                                cmd.CommandType = CommandType.StoredProcedure;
                                cmd.CommandText = "Sp_HWMS_RouteTransportationHospital_Save";

                                foreach (var use in model.TransportationCategoryList)
                                {
                                    cmd.Parameters.AddWithValue("@RouteTransportationId", model.RouteTransportationId);
                                    cmd.Parameters.AddWithValue("@RouteHospitalId", use.RouteHospitalId);
                                    cmd.Parameters.AddWithValue("@HospitalCode", use.HospitalCode);
                                    cmd.Parameters.AddWithValue("@HospitalName", use.HospitalName);
                                    cmd.Parameters.AddWithValue("@Remarks", use.Remarks);
                                    cmd.Parameters.AddWithValue("@isDeleted", use.isDeleted);

                                    var da1 = new SqlDataAdapter();
                                    da1.SelectCommand = cmd;
                                    da1.Fill(ds1);
                                    cmd.Parameters.Clear();
                                }
                            }
                            model = Get(model.RouteTransportationId);
                        }
                    }
                }
               
                Log4NetLogger.LogExit(_FileName, nameof(Save), Level.Info.ToString());
                return model;
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
                var strCondition = string.Empty;
                var QueryCondition = pageFilter.QueryWhereCondition;
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
                        cmd.CommandText = "sp_HWMS_TransportationCategory_GetAll";

                        cmd.Parameters.AddWithValue("@PageIndex", pageFilter.PageIndex);
                        cmd.Parameters.AddWithValue("@PageSize", pageFilter.PageSize);
                        cmd.Parameters.AddWithValue("@StrCondition", strCondition);
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
                //return Blocks;
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
        public TransportationCategory Get(int Id)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "sp_HWMS_TransportationCategory_Get";
                        cmd.Parameters.AddWithValue("Id", Id);
                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }
                TransportationCategory _transportationCategory = new TransportationCategory();
                if (ds.Tables[0].Rows.Count > 0)
                {
                    DataRow dr = ds.Tables[0].Rows[0];
                    _transportationCategory.RouteTransportationId = Convert.ToInt32(dr["RouteTransportationId"]);
                    _transportationCategory.RouteCode = dr["RouteCode"].ToString();
                    _transportationCategory.RouteDescription = dr["RouteDescription"].ToString();
                    _transportationCategory.RouteCategory = dr["RouteCategory"].ToString();
                    _transportationCategory.Status = dr["Status"].ToString();
                }
                if (ds.Tables[1] != null)
                {
                    if (ds.Tables[1].Rows.Count > 0)
                    {
                        List<TransportationCategoryTable> _transportation = new List<TransportationCategoryTable>();
                        foreach (DataRow dr in ds.Tables[1].Rows)
                        {
                            TransportationCategoryTable Auto = new TransportationCategoryTable();
                            Auto.RouteHospitalId = Convert.ToInt32(dr["RouteHospitalId"].ToString());
                            Auto.HospitalCode = dr["HospitalCode"].ToString();
                            Auto.HospitalName = dr["HospitalName"].ToString();
                            Auto.Remarks = dr["Remarks"].ToString();
                            _transportation.Add(Auto);

                        }
                        _transportationCategory.TransportationCategoryList = _transportation;
                    }
                }

                Log4NetLogger.LogExit(_FileName, nameof(Get), Level.Info.ToString());
                return _transportationCategory;
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

        public List<TransportationCategoryTable> HospitalCodeFetch(TransportationCategoryTable searchObject)
        {
            try
            {
               Log4NetLogger.LogEntry(_FileName, nameof(HospitalCodeFetch), Level.Info.ToString());
                List<TransportationCategoryTable> result = null;
                var pageIndex = searchObject.PageIndex;
                var pageSize = Convert.ToInt32(ConfigurationManager.AppSettings["FetchPopupPageSize"]);
                var dbAccessDAL = new DBAccessDAL();
                var obj = new TransportationCategoryTable();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@HospitalCode", searchObject.HospitalCode ?? "");
                parameters.Add("@pPageIndex", Convert.ToString(pageIndex));
                parameters.Add("@pPageSize", Convert.ToString(pageSize));
                parameters.Add("@pFacilityId", _UserSession.FacilityId.ToString());
                DataTable dt = dbAccessDAL.GetDataTable("sp_HWMS_TransportationCodeFetch", parameters, DataSetparameters);
                if (dt != null && dt.Rows.Count > 0)
                {
                    var totalRecords = Convert.ToInt32(dt.Rows[0]["TotalRecords"]);
                    var firstRecord = (pageIndex - 1) * pageSize + 1;
                    var lastRecord = (pageIndex - 1) * pageSize + dt.Rows.Count;
                    var lastPageIndex = totalRecords % pageSize == 0 ? totalRecords / pageSize : (totalRecords / pageSize) + 1;

                    result = (from n in dt.AsEnumerable()
                              select new TransportationCategoryTable
                              {
                                  RouteHospitalId = Convert.ToInt32(n["FacilityId"]),
                                  HospitalCode = Convert.ToString(n["HospitalCode"]),
                                  HospitalName = Convert.ToString(n["HospitalName"]),
                                  TotalRecords = totalRecords,
                                  FirstRecord = firstRecord,
                                  LastRecord = lastRecord,
                                  LastPageIndex = lastPageIndex
                              }).ToList();
                }
                Log4NetLogger.LogExit(_FileName, nameof(HospitalCodeFetch), Level.Info.ToString());
                return result;
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

        public TransportationCategory HospitalNameData(string HospitalCode)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(HospitalNameData), Level.Info.ToString());
                TransportationCategory transportationCategory = new TransportationCategory();

                var ds = new DataSet();

                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "sp_HWMS_TransportationCategory_Display_UserAreaName";
                        cmd.Parameters.AddWithValue("@HospitalCode", HospitalCode);
                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }
                List<TransportationCategoryTable> CollectionAutoDispay = new List<TransportationCategoryTable>();
                foreach (DataRow dr in ds.Tables[0].Rows)
                {
                    TransportationCategoryTable Auto = new TransportationCategoryTable();
                    Auto.HospitalName = dr["HospitalName"].ToString();

                    CollectionAutoDispay.Add(Auto);
                }
                transportationCategory.TransportationCategoryList = CollectionAutoDispay;
                Log4NetLogger.LogExit(_FileName, nameof(HospitalNameData), Level.Info.ToString());
                return transportationCategory;
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
