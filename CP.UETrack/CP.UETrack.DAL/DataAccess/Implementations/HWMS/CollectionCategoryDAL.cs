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
   public class CollectionCategoryDAL : ICollectionCategoryDAL
   {
        private readonly string _FileName = nameof(CollectionCategoryDAL);
        readonly UserDetailsModel _UserSession = new SessionHelper().UserSession();

        public CollectionCategoryDropDown Load()
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                CollectionCategoryDropDown collectionDropdownvalues = new CollectionCategoryDropDown();

                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        var da = new SqlDataAdapter();
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "sp_HWMS_CollectionCategory_DropDown";
                        cmd.Parameters.Clear();
                        cmd.Parameters.AddWithValue("@pScreenName", "CollectionCategory");                      
                        da.SelectCommand = cmd;
                        da.Fill(ds);

                        if (ds.Tables[0] != null)
                        {
                            collectionDropdownvalues.StatusLovs = dbAccessDAL.GetLovRecords(ds.Tables[0]);
                        }
                        if (ds.Tables[1] != null)
                        {
                            collectionDropdownvalues.RouteCategoryLovs = dbAccessDAL.GetLovRecords(ds.Tables[1]);
                        }
                    }
                }

                Log4NetLogger.LogExit(_FileName, nameof(Load), Level.Info.ToString());
                return collectionDropdownvalues;
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
        public CollectionCategory Save(CollectionCategory model, out string ErrorMessage)
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
                        cmd.CommandText = "Sp_HWMS_CollectionCategory_Save";

                        cmd.Parameters.AddWithValue("@RouteCollectionId", model.RouteCollectionId);
                        cmd.Parameters.AddWithValue("@CustomerId", model.CustomerId);
                        cmd.Parameters.AddWithValue("@FacilityId", model.FacilityId);
                        cmd.Parameters.AddWithValue("@RouteCode", model.RouteCode);
                        cmd.Parameters.AddWithValue("@RouteDescription", model.RouteDescription);
                        cmd.Parameters.AddWithValue("@RouteCategory", model.RouteCategory);
                        cmd.Parameters.AddWithValue("@Status", model.Status);

                         var da = new SqlDataAdapter();
                         da.SelectCommand = cmd;
                         da.Fill(ds);
                        
                    }
                }
                if (ds.Tables.Count != 0)
                {
                    if (ds.Tables[0].Rows[0][0].ToString() == "-1")
                    {
                        model.RouteCollectionId = 0;
                        ErrorMessage = "Route Code already exists";
                    }
                    else
                    {
                        model.RouteCollectionId = Convert.ToInt32(ds.Tables[0].Rows[0]["RouteCollectionId"]);
                        using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                        {
                            using (SqlCommand cmd = new SqlCommand())
                            {
                                cmd.Connection = con;
                                cmd.CommandType = CommandType.StoredProcedure;
                                cmd.Parameters.Clear();                                

                                cmd.CommandText = "sp_HWMS_CollectionCategoryUserArea_Save";

                                foreach (var use in model.CollectionCategoryList)
                                {
                                    cmd.Parameters.AddWithValue("@RouteCollectionUserAreaId", use.RouteCollectionUserAreaId);
                                    cmd.Parameters.AddWithValue("@RouteCollectionId", model.RouteCollectionId);
                                    cmd.Parameters.AddWithValue("@UserAreaCode", use.UserAreaCode);
                                    cmd.Parameters.AddWithValue("@UserAreaName", use.UserAreaName);
                                    cmd.Parameters.AddWithValue("@Remarks", use.Remarks);
                                    cmd.Parameters.AddWithValue("@isDeleted", use.isDeleted);

                                    var da = new SqlDataAdapter();
                                    da.SelectCommand = cmd;
                                    da.Fill(ds1);
                                    cmd.Parameters.Clear();
                                }
                            }
                        }

                        model = Get(model.RouteCollectionId);
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
                        cmd.CommandText = "sp_HWMS_CollectionCategory_GetAll";

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
        public CollectionCategory Get(int Id)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
                CollectionCategory receptacles = new CollectionCategory();
                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "sp_HWMS_CollectionCategory_Get";
                        cmd.Parameters.AddWithValue("@RouteCollectionId", Id);
                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }
                CollectionCategory _collectionCategory = new CollectionCategory();
                if (ds.Tables[0].Rows.Count > 0)
                {
                    DataRow dr = ds.Tables[0].Rows[0];
                    _collectionCategory.RouteCollectionId = Convert.ToInt32(dr["RouteCollectionId"]);
                    _collectionCategory.RouteCode = dr["RouteCode"].ToString();
                    _collectionCategory.RouteDescription = dr["RouteDescription"].ToString();
                    _collectionCategory.RouteCategory = dr["RouteCategory"].ToString();
                    _collectionCategory.Status = dr["Status"].ToString();
                }
                if (ds.Tables[1] != null)
                {
                    if (ds.Tables[1].Rows.Count > 0)
                    {
                        List<CollectionCategoryTable> _collection = new List<CollectionCategoryTable>();
                        foreach (DataRow dr in ds.Tables[1].Rows)
                        {

                            CollectionCategoryTable Auto = new CollectionCategoryTable();
                            Auto.RouteCollectionUserAreaId = Convert.ToInt32(dr["RouteCollectionUserAreaId"]);
                            Auto.UserAreaCode = dr["UserAreaCode"].ToString();
                            Auto.UserAreaName = dr["UserAreaName"].ToString();
                            Auto.Remarks = dr["Remarks"].ToString();
                            _collection.Add(Auto);

                        }
                        _collectionCategory.CollectionCategoryList = _collection;
                    }
                }
              
                Log4NetLogger.LogExit(_FileName, nameof(Get), Level.Info.ToString());
                return _collectionCategory;
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
        public List<DeptAreaDetails> UserAreaCodeFetch(DeptAreaDetails searchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(UserAreaCodeFetch), Level.Info.ToString());
                List<DeptAreaDetails> result = null;
                var pageIndex = searchObject.PageIndex;
                var pageSize = Convert.ToInt32(ConfigurationManager.AppSettings["FetchPopupPageSize"]);
                var dbAccessDAL = new DBAccessDAL();
                var obj = new DeptAreaDetails();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@UserAreaCode", searchObject.UserAreaCode ?? "");
                parameters.Add("@pPageIndex", Convert.ToString(pageIndex));
                parameters.Add("@pPageSize", Convert.ToString(pageSize));
                parameters.Add("@pFacilityId", _UserSession.FacilityId.ToString());
                DataTable dt = dbAccessDAL.GetDataTable("sp_HWMS_CollectionCodeFetch", parameters, DataSetparameters);
                if (dt != null && dt.Rows.Count > 0)
                {
                    var totalRecords = Convert.ToInt32(dt.Rows[0]["TotalRecords"]);
                    var firstRecord = (pageIndex - 1) * pageSize + 1;
                    var lastRecord = (pageIndex - 1) * pageSize + dt.Rows.Count;
                    var lastPageIndex = totalRecords % pageSize == 0 ? totalRecords / pageSize : (totalRecords / pageSize) + 1;

                    result = (from n in dt.AsEnumerable()
                              select new DeptAreaDetails
                              {
                                  DeptAreaId = Convert.ToInt32(n["DeptAreaId"]),
                                  UserAreaCode = Convert.ToString(n["UserAreaCode"]),
                                  UserAreaName = Convert.ToString(n["UserAreaName"]),
                                  TotalRecords = totalRecords,
                                  FirstRecord = firstRecord,
                                  LastRecord = lastRecord,
                                  LastPageIndex = lastPageIndex
                              }).ToList();
                }
                Log4NetLogger.LogExit(_FileName, nameof(UserAreaCodeFetch), Level.Info.ToString());
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

        public CollectionCategory UserAreaNameData(string UserAreaCode)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(UserAreaNameData), Level.Info.ToString());
                CollectionCategory collectionCategory = new CollectionCategory();

                var ds = new DataSet();

                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "sp_HWMS_CollectionCategory_Display_UserAreaName";
                        cmd.Parameters.AddWithValue("@UserAreaCode", UserAreaCode);
                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }
                List<CollectionCategoryTable> CollectionAutoDispay = new List<CollectionCategoryTable>();
                foreach (DataRow dr in ds.Tables[0].Rows)
                {
                    CollectionCategoryTable Auto = new CollectionCategoryTable();
                    Auto.UserAreaName = dr["UserAreaName"].ToString();

                    CollectionAutoDispay.Add(Auto);
                }
                collectionCategory.CollectionCategoryList = CollectionAutoDispay;
                Log4NetLogger.LogExit(_FileName, nameof(UserAreaNameData), Level.Info.ToString());
                return collectionCategory;
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
