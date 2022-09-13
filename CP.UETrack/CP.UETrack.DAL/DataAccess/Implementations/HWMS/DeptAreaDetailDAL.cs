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

    public class DeptAreaDetailDAL : IDeptAreaDetailDAL
    {




        private readonly string _FileName = nameof(BlockDAL);
        readonly UserDetailsModel _UserSession = new SessionHelper().UserSession();

        public DeptAreaDetailDAL()
        {

        }
        public DeptAreaDetailsDropdownList Load()
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
               // DeptAreaDetails approvedChemicalList = new DeptAreaDetails();
                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                DeptAreaDetailsDropdownList deptAreaDetailsDropdown = new DeptAreaDetailsDropdownList();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        var da = new SqlDataAdapter();
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "sp_HWMS_DeptAreaDetail_Load";
                        cmd.Parameters.Clear();
                        cmd.Parameters.AddWithValue("@pScreenName", "DeptAreaDetails");
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                        if (ds.Tables[0] != null)
                        {
                            deptAreaDetailsDropdown.StatusLovs = dbAccessDAL.GetLovRecords(ds.Tables[0]);
                        }
                        if (ds.Tables[1] != null)
                        {
                            deptAreaDetailsDropdown.CategoryLovs = dbAccessDAL.GetLovRecords(ds.Tables[1]);
                        }
                        if (ds.Tables[2] != null)
                        {
                            deptAreaDetailsDropdown.OperatingDaysLovs = dbAccessDAL.GetLovRecords(ds.Tables[2]);
                        }
                        if (ds.Tables[3] != null)
                        {
                            deptAreaDetailsDropdown.FrequencyTypeLovs = dbAccessDAL.GetLovRecords(ds.Tables[3]);
                        }
                        if (ds.Tables[4] != null)
                        {
                            deptAreaDetailsDropdown.CollectionFrequencyLovs = dbAccessDAL.GetLovRecords(ds.Tables[4]);
                        }
                        if (ds.Tables[5] != null)
                        {
                            deptAreaDetailsDropdown.WasteTypeLovs = dbAccessDAL.GetLovRecords(ds.Tables[5]);
                        }
                        if (ds.Tables[6] != null)
                        {
                            deptAreaDetailsDropdown.UOMLovs = dbAccessDAL.GetLovRecords(ds.Tables[6]);
                        }
                    }
                }
                Log4NetLogger.LogExit(_FileName, nameof(Load), Level.Info.ToString());
                return deptAreaDetailsDropdown;
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
        public DeptAreaDetails Save(DeptAreaDetails model, out string ErrorMessage)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());
                ErrorMessage = string.Empty;
                var spName = string.Empty;
                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "SP_HWMS_DeptAreaDetails_Save";
                        cmd.Parameters.AddWithValue("@pDeptAreaId", model.DeptAreaId);
                        cmd.Parameters.AddWithValue("@pUserAreaId", model.UserAreaId);
                        cmd.Parameters.AddWithValue("@pCustomerId", model.CustomerId);
                        cmd.Parameters.AddWithValue("@pFacilityid", model.FacilityId);
                        cmd.Parameters.AddWithValue("@pUserAreaCode", model.UserAreaCode);
                        cmd.Parameters.AddWithValue("@pUserAreaName", model.UserAreaName);
                        cmd.Parameters.AddWithValue("@pEffectiveFromDate", model.EffectiveFromDate);
                        cmd.Parameters.AddWithValue("@pEffectiveToDate", model.EffectiveToDate);
                        cmd.Parameters.AddWithValue("@pOperationalDays", model.OperatingDays);
                        cmd.Parameters.AddWithValue("@pStatus", model.Status);
                        cmd.Parameters.AddWithValue("@pCategory", model.Category);
                        cmd.Parameters.AddWithValue("@pRemarks", model.Remarks);
                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }
                if (ds.Tables.Count != 0)
                {
                    if (ds.Tables[0].Rows[0][0].ToString() == "UserAreaCode already exists")
                    {
                        model.DeptAreaId = 0;
                        ErrorMessage = "UserAreaCode already exists";
                    }
                    else
                    {
                        model.DeptAreaId = Convert.ToInt32(ds.Tables[0].Rows[0]["DeptAreaId"]);
                        using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                        {
                            using (SqlCommand cmd = new SqlCommand())
                            {
                                cmd.Connection = con;
                                cmd.CommandType = CommandType.StoredProcedure;

                                cmd.Parameters.Clear();
                                model.DeptAreaId = Convert.ToInt32(ds.Tables[0].Rows[0]["DeptAreaId"]);
                                var ds1 = new DataSet();
                                cmd.CommandText = "SP_HWMS_DeptAreaConsumablesReceptacles";
                                foreach (var Dept in model.DDConsumablesList)
                                {
                                    cmd.Parameters.AddWithValue("@ReceptaclesId", Dept.ReceptaclesId);
                                    cmd.Parameters.AddWithValue("@pDeptAreaId", model.DeptAreaId);
                                    cmd.Parameters.AddWithValue("@pWasteType", Dept.WasteTypeConsumables);
                                    cmd.Parameters.AddWithValue("@pItemCode", Dept.ItemCode);
                                    cmd.Parameters.AddWithValue("@pItemName", Dept.ItemName);
                                    cmd.Parameters.AddWithValue("@pSize", Dept.Size);
                                    cmd.Parameters.AddWithValue("@pUOM", Dept.UOM);
                                    cmd.Parameters.AddWithValue("@pShelfLevelQuantity", Dept.ShelfLevelQuantity);
                                    cmd.Parameters.AddWithValue("@isDeleted", Dept.isDeleted);
                                    var da1 = new SqlDataAdapter();
                                    da1.SelectCommand = cmd;
                                    da1.Fill(ds1);
                                    cmd.Parameters.Clear();
                                }
                                var ds2 = new DataSet();
                                cmd.CommandText = "SP_HWMS_DeptAreaCollectionFrequency";
                                foreach (var Dept1 in model.DDCollectionList)
                                {
                                    cmd.Parameters.AddWithValue("@FrequencyId", Dept1.FrequencyId);
                                    cmd.Parameters.AddWithValue("@pDeptAreaId", model.DeptAreaId);
                                    cmd.Parameters.AddWithValue("@pWasteType", Dept1.WasteTypeCollection);
                                    cmd.Parameters.AddWithValue("@pFrequencyType", Dept1.FrequencyType);
                                    cmd.Parameters.AddWithValue("@pCollectionFrequency", Dept1.CollectionFrequency);
                                    cmd.Parameters.AddWithValue("@pStartTime1", Dept1.StartTime1);
                                    cmd.Parameters.AddWithValue("@pEndTime1", Dept1.EndTime1);
                                    cmd.Parameters.AddWithValue("@pStartTime2", Dept1.StartTime2);
                                    cmd.Parameters.AddWithValue("@pEndTime2", Dept1.EndTime2);
                                    cmd.Parameters.AddWithValue("@pStartTime3", Dept1.StartTime3);
                                    cmd.Parameters.AddWithValue("@pEndTime3", Dept1.EndTime3);
                                    cmd.Parameters.AddWithValue("@pStartTime4", Dept1.StartTime4);
                                    cmd.Parameters.AddWithValue("@pEndTime4", Dept1.EndTime4);
                                    cmd.Parameters.AddWithValue("@isDeleted", Dept1.isDeleted);
                                    var da = new SqlDataAdapter();
                                    da.SelectCommand = cmd;
                                    da.Fill(ds2);
                                    cmd.Parameters.Clear();
                                }
                            }
                        }
                        model = Get(model.DeptAreaId);
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
                        cmd.CommandText = "sp_HWMS_DeptAreaDetails_GetAll";
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
        public DeptAreaDetails Get(int Id)
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
                        cmd.CommandText = "sp_HWMS_DeptAreaDetails_Get";
                        cmd.Parameters.AddWithValue("@pId", Id);
                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }

                DeptAreaDetails _areaDetails = new DeptAreaDetails();
                if (ds.Tables[0].Rows.Count > 0)
                {
                    DataRow dr = ds.Tables[0].Rows[0];

                    _areaDetails.DeptAreaId = Convert.ToInt32(dr["DeptAreaId"]);
                    _areaDetails.UserAreaId = Convert.ToInt32(dr["UserAreaId"]);                  
                    _areaDetails.UserAreaCode = dr["UserAreaCode"].ToString();
                    _areaDetails.UserAreaName = dr["UserAreaName"].ToString();
                    _areaDetails.EffectiveFromDate = dr["EffectiveFromDate"] == DBNull.Value ? default(DateTime?) : Convert.ToDateTime(dr["EffectiveFromDate"]);
                    _areaDetails.EffectiveToDate = dr["EffectiveToDate"] == DBNull.Value ? default(DateTime?) : Convert.ToDateTime(dr["EffectiveToDate"]);
                    _areaDetails.OperatingDays = dr["OperatingDays"].ToString();
                    _areaDetails.Status = dr["Status"].ToString();
                    _areaDetails.Category = dr["Category"].ToString();
                    _areaDetails.Remarks = dr["Remarks"].ToString();
                }
                if (ds.Tables[1] != null)
                {
                    if (ds.Tables[1].Rows.Count > 0)
                    {
                        List<DeptAreaConsumables> _ChemicalsList = new List<DeptAreaConsumables>();
                        foreach (DataRow dr in ds.Tables[1].Rows)
                        {
                            DeptAreaConsumables Auto = new DeptAreaConsumables();
                            Auto.ReceptaclesId = dr["ReceptaclesId"].ToString();
                            Auto.WasteTypeConsumables = dr["WasteType"].ToString();
                            Auto.ItemCode = dr["ItemCode"].ToString();
                            Auto.ItemName = dr["ItemName"].ToString();
                            Auto.Size = dr["Size"].ToString();
                            Auto.UOM = dr["UOM"].ToString();
                            Auto.ShelfLevelQuantity = dr["ShelfLevelQuantity"].ToString();
                            _ChemicalsList.Add(Auto);
                        }
                        _areaDetails.DDConsumablesList = _ChemicalsList;
                    }
                }
                if (ds.Tables[2] != null)
                {
                    if (ds.Tables[2].Rows.Count > 0)
                    {
                        List<DeptAreaDetailsCollectionFrequency> _ChemicalsList1 = new List<DeptAreaDetailsCollectionFrequency>();
                        foreach (DataRow dr in ds.Tables[2].Rows)
                        {
                            
                            DeptAreaDetailsCollectionFrequency dept1 = new DeptAreaDetailsCollectionFrequency();
                            dept1.FrequencyId = dr["FrequencyId"].ToString();
                            dept1.WasteTypeCollection = dr["WasteType"].ToString();
                            dept1.FrequencyType = dr["FrequencyType"].ToString();
                            dept1.CollectionFrequency = dr["CollectionFrequency"].ToString();
                            dept1.StartTime1 = dr["StartTime1"].ToString();
                            dept1.EndTime1 = dr["EndTime1"].ToString();
                            dept1.StartTime2 = dr["StartTime2"].ToString();
                            dept1.EndTime2 = dr["EndTime2"].ToString();
                            dept1.StartTime3 = dr["StartTime3"].ToString();
                            dept1.EndTime3 = dr["EndTime3"].ToString();
                            dept1.StartTime4 = dr["StartTime4"].ToString();
                            dept1.EndTime4 = dr["EndTime4"].ToString();
                            _ChemicalsList1.Add(dept1);

                        }
                        _areaDetails.DDCollectionList = _ChemicalsList1;
                    }
                }
                   
                Log4NetLogger.LogExit(_FileName, nameof(Get), Level.Info.ToString());
                return _areaDetails;
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
        public List<ItemTable> ItemCodeFetch(ItemTable searchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(ItemCodeFetch), Level.Info.ToString());
                List<ItemTable> result = null;
                var pageIndex = searchObject.PageIndex;
                var pageSize = Convert.ToInt32(ConfigurationManager.AppSettings["FetchPopupPageSize"]);
                var dbAccessDAL = new DBAccessDAL();
                var obj = new ItemTable();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>(); //WasteTypeCode
                parameters.Add("@pItemCode", searchObject.ItemCode ?? "");
                parameters.Add("@pWasteTypeCode", searchObject.WasteTypeCode.ToString());
                parameters.Add("@pPageIndex", Convert.ToString(pageIndex));
                parameters.Add("@pPageSize", Convert.ToString(pageSize));
                parameters.Add("@pFacilityId", _UserSession.FacilityId.ToString());
                DataTable dt = dbAccessDAL.GetDataTable("sp_HWMS_Dept_ItemCodeFetch", parameters, DataSetparameters);
                if (dt != null && dt.Rows.Count > 0)
                {
                    var totalRecords = Convert.ToInt32(dt.Rows[0]["TotalRecords"]);
                    var firstRecord = (pageIndex - 1) * pageSize + 1;
                    var lastRecord = (pageIndex - 1) * pageSize + dt.Rows.Count;
                    var lastPageIndex = totalRecords % pageSize == 0 ? totalRecords / pageSize : (totalRecords / pageSize) + 1;

                    result = (from n in dt.AsEnumerable()
                              select new ItemTable
                              {
                                  ItemCodeId = Convert.ToInt32(n["ItemCodeId"]),
                                  ItemCode = Convert.ToString(n["ItemCode"]),
                                  ItemName = Convert.ToString(n["ItemName"]),
                                  Size = Convert.ToString(n["Size"]),
                                  UOM = Convert.ToString(n["UOM"]),
                                  TotalRecords = totalRecords,
                                  FirstRecord = firstRecord,
                                  LastRecord = lastRecord,
                                  LastPageIndex = lastPageIndex
                              }).ToList();
                }
                Log4NetLogger.LogExit(_FileName, nameof(ItemCodeFetch), Level.Info.ToString());
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
        public DeptAreaDetails UserAreaNameData(string UserAreaCode)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(UserAreaNameData), Level.Info.ToString());
               

                var ds = new DataSet();

                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "SP_HWMS_DeptAreaDetail_Display_UserAreaName";
                        cmd.Parameters.AddWithValue("@pUserAreaCode", UserAreaCode);
                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }
                DeptAreaDetails _deptAreaDetails = new DeptAreaDetails();
                if (ds.Tables[0].Rows.Count > 0)
                {
                    DataRow dr = ds.Tables[0].Rows[0];
                    _deptAreaDetails.UserAreaName = dr["UserAreaName"].ToString();
                    _deptAreaDetails.EffectiveFromDate = Convert.ToDateTime(dr["ActiveFromDate"].ToString());
                    _deptAreaDetails.EffectiveToDate = dr["ActiveToDate"] == DBNull.Value ? default(DateTime?) : Convert.ToDateTime(dr["EffectiveToDate"]);
                }
                Log4NetLogger.LogExit(_FileName, nameof(UserAreaNameData), Level.Info.ToString());
                return _deptAreaDetails;
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
