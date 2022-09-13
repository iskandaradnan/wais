using CP.Framework.Common.ExceptionHandler.ExceptionWrappers;using CP.Framework.Common.Logging;using CP.UETrack.DAL.DataAccess.Contracts.HWMS;using CP.UETrack.DAL.DataAccess.Implementation;using CP.UETrack.Model;using CP.UETrack.Model.HWMS;using System;using System.Collections.Generic;using System.Data;using System.Data.SqlClient;using UETrack.DAL;

namespace CP.UETrack.DAL.DataAccess.Implementations.HWMS
{
   public class WasteTypeDAL: IWasteTypeDAL
    {
        private readonly string _FileName = nameof(BlockDAL);
        readonly UserDetailsModel _UserSession = new SessionHelper().UserSession();      
        public WasteTypeLoad Load()
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                WasteTypeLoad wasteTypeLoad = new WasteTypeLoad();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        var da = new SqlDataAdapter();
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "Sp_HWMS_WasteType_DropDown";
                        cmd.Parameters.Clear();
                        cmd.Parameters.AddWithValue("@pScreenName", "Waste Type");
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                        if (ds.Tables[0] != null)
                        {
                            wasteTypeLoad.WasteCategoryLovs = dbAccessDAL.GetLovRecords(ds.Tables[0]);
                        }
                        if (ds.Tables[1] != null)
                        {
                            wasteTypeLoad.WasteTypeLovs = dbAccessDAL.GetLovRecords(ds.Tables[1]);
                        }
                    }
                }
                Log4NetLogger.LogExit(_FileName, nameof(Load), Level.Info.ToString());
                return wasteTypeLoad;
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
        public WasteType Save(WasteType model, out string ErrorMessage)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());
                ErrorMessage = string.Empty;
                var spName = string.Empty;

                var da = new SqlDataAdapter();
                var ds = new DataSet();
                var ds1 = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "Sp_HWMS_WasteType_Save";

                        cmd.Parameters.AddWithValue("@WasteTypeId", model.WasteTypeId);
                        cmd.Parameters.AddWithValue("@CustomerId", model.CustomerId);
                        cmd.Parameters.AddWithValue("@FacilityId", model.FacilityId);
                        cmd.Parameters.AddWithValue("@WasteCategory", model.WasteCategory);
                        cmd.Parameters.AddWithValue("@WasteType", model.WasteOfType);

                        
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }
                if (ds.Tables.Count != 0)
                {
                    model.WasteTypeId = Convert.ToInt32(ds.Tables[0].Rows[0]["WasteTypeId"]);
                    if (model.WasteTypeId == -1)
                    {
                        ErrorMessage = "Waste Category and Waste Type must be unique combination, " + model.WasteCategory + " and " + model.WasteOfType + "details already saved.";
                    }
                    else {
                        using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                        {
                            using (SqlCommand cmd = new SqlCommand())
                            {
                                cmd.Connection = con;
                                cmd.CommandType = CommandType.StoredProcedure;
                                cmd.Parameters.Clear();
                                cmd.CommandText = "sp_HWMS_WasteType_WasteCode";

                                int isWasteCodeExists = 0;

                                foreach (var table in model.WasteTypeDetailsList)
                                {
                                    cmd.Parameters.AddWithValue("@WasteId", table.WasteId);
                                    cmd.Parameters.AddWithValue("@WasteTypeId", model.WasteTypeId);
                                    cmd.Parameters.AddWithValue("@WasteCode", table.WasteCode);
                                    cmd.Parameters.AddWithValue("@WasteDescription", table.WasteDescription);
                                    cmd.Parameters.AddWithValue("@isDeleted", table.isDeleted);

                                    da.SelectCommand = cmd;
                                    da.Fill(ds1);
                                    cmd.Parameters.Clear();

                                    if (ds1.Tables[0].Rows[0][0].ToString() == "Waste Code already exists")
                                    {
                                        isWasteCodeExists += 1;
                                    }
                                }

                                if (isWasteCodeExists > 0)
                                {
                                    ErrorMessage = "Waste Code already exists";
                                }
                                else
                                {
                                    model = Get(model.WasteTypeId);
                                }
                            }
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
                        cmd.CommandText = "sp_HWMS_WasteType_GetAll";
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

        public WasteType Get(int Id)
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
                        cmd.CommandText = "Sp_HWMS_WasteType_Get";
                        cmd.Parameters.AddWithValue("Id", Id);
                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }
                WasteType _type = new WasteType();
                if (ds.Tables[0].Rows.Count > 0)
                {
                    DataRow dr = ds.Tables[0].Rows[0];
                    _type.WasteTypeId = Convert.ToInt32(dr["WasteTypeId"]);
                   _type.WasteCategory = dr["WasteCategory"].ToString();
                    _type.WasteOfType = dr["WasteType"].ToString();
                }
                if (ds.Tables[1] != null)
                {
                    if (ds.Tables[1].Rows.Count > 0)
                    {
                        List<WasteTypeTable> _wasteTypeTables = new List<WasteTypeTable>();
                        foreach (DataRow dr in ds.Tables[1].Rows)
                        {
                            WasteTypeTable wasteTypes = new WasteTypeTable();
                            wasteTypes.WasteId = Convert.ToInt32(dr["WasteId"].ToString());
                            wasteTypes.WasteCode= dr["WasteCode"].ToString();
                            wasteTypes.WasteDescription = dr["WasteDescription"].ToString();
                            _wasteTypeTables.Add(wasteTypes);
                        }
                        _type.WasteTypeDetailsList = _wasteTypeTables;
                    }
                }
                Log4NetLogger.LogExit(_FileName, nameof(Get), Level.Info.ToString());
                 return _type;
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
