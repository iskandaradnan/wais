using CP.Framework.Common.ExceptionHandler.ExceptionWrappers;
using CP.Framework.Common.Logging;
using CP.UETrack.DAL.DataAccess.Contracts.HWMS;
using CP.UETrack.DAL.DataAccess.Implementation;
using CP.UETrack.Model;
using CP.UETrack.Model.HWMS;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using UETrack.DAL;

namespace CP.UETrack.DAL.DataAccess.Implementations.HWMS
{
    public class ConsumablesReceptaclesDAL : IConsumablesReceptaclesDAL
    {
        private readonly string _FileName = nameof(BlockDAL);
        readonly UserDetailsModel _UserSession = new SessionHelper().UserSession();
        public ConsumablesReceptacles Save(ConsumablesReceptacles model, out string ErrorMessage)
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
                        cmd.CommandText = "SP_HWMS_ConsumablesReceptacles_Save";
                        cmd.Parameters.AddWithValue("@ConsumablesId", model.ConsumablesId);
                        cmd.Parameters.AddWithValue("@Customerid", model.CustomerId);
                        cmd.Parameters.AddWithValue("@Facilityid", model.FacilityId);
                        cmd.Parameters.AddWithValue("@WasteCategory", model.WasteCategory);
                        cmd.Parameters.AddWithValue("@WasteType", model.WasteType);
                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);

                        if (ds.Tables.Count != 0)
                        {
                            cmd.Parameters.Clear();
                            model.ConsumablesId = Convert.ToInt32(ds.Tables[0].Rows[0]["ConsumablesId"]);
                            var ds1 = new DataSet();
                            cmd.CommandText = "SP_HWMS_ConsumablesReceptacles_Items";
                            foreach (var use in model.ItemList)
                            {
                                cmd.Parameters.Clear();
                                cmd.Parameters.AddWithValue("@ItemCodeId", use.ItemCodeId);
                                cmd.Parameters.AddWithValue("@ConsumablesId", model.ConsumablesId);
                                cmd.Parameters.AddWithValue("@ItemCode", use.ItemCode);
                                cmd.Parameters.AddWithValue("@ItemName", use.ItemName);
                                cmd.Parameters.AddWithValue("@ItemType", use.ItemType);
                                cmd.Parameters.AddWithValue("@Size", use.Size);
                                cmd.Parameters.AddWithValue("@UOM", use.UOM);
                                cmd.Parameters.AddWithValue("@isDeleted", use.isDeleted);
                                da.SelectCommand = cmd;
                                da.Fill(ds1);
                            }

                            model = Get(model.ConsumablesId);
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
        public ItemTypeDropdown Load()
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());           
                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                ItemTypeDropdown itemTypeDropdown = new ItemTypeDropdown();    
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        var da = new SqlDataAdapter();
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "Sp_HWMS_ConsumablesReceptacles_Load";
                        cmd.Parameters.Clear();
                        cmd.Parameters.AddWithValue("@pScreenName", "ConsumablesReceptacles");
                        da.SelectCommand = cmd;
                        da.Fill(ds);                

                        if (ds.Tables[0] != null)
                        {                           
                            itemTypeDropdown.ItemTypeConsumables = dbAccessDAL.GetLovRecords(ds.Tables[0]);
                        }
                        if (ds.Tables[1] != null)
                        {
                            itemTypeDropdown.WasteTypeConsumables = dbAccessDAL.GetLovRecords(ds.Tables[1]);
                        }
                        if (ds.Tables[2] != null)
                        {
                            itemTypeDropdown.WasteCategoryLovs = dbAccessDAL.GetLovRecords(ds.Tables[2]);
                        }
                        if (ds.Tables[3] != null)
                        {
                            itemTypeDropdown.UOMLovs = dbAccessDAL.GetLovRecords(ds.Tables[3]);
                        }
                    }
                }           
                Log4NetLogger.LogExit(_FileName, nameof(Load), Level.Info.ToString());
                return itemTypeDropdown;
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
                        cmd.CommandText = "sp_HWMS_ConsumablesReceptacles_GetAll";

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
        public ConsumablesReceptacles Get(int Id)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
                ConsumablesReceptacles receptacles = new ConsumablesReceptacles();
                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "Sp_HWMS_ConsumablesReceptacles_Get";
                        cmd.Parameters.AddWithValue("Id", Id);
                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }
                ConsumablesReceptacles _consumablesreceptacles = new ConsumablesReceptacles();
                if (ds.Tables[0].Rows.Count > 0)
                {
                    DataRow dr = ds.Tables[0].Rows[0];
                    _consumablesreceptacles.ConsumablesId =  Convert.ToInt32(dr["ConsumablesId"]);
                    _consumablesreceptacles.WasteCategory = dr["WasteCategory"].ToString();
                    _consumablesreceptacles.WasteType = dr["WasteType"].ToString();
                }
                if (ds.Tables[1] != null)
                {
                    if (ds.Tables[1].Rows.Count > 0)
                    {
                        List<ItemTable> _consumablesList = new List<ItemTable>();
                         foreach (DataRow dr in ds.Tables[1].Rows)
                         {

                            ItemTable Auto = new ItemTable();
                            Auto.ItemCodeId = Convert.ToInt16(dr["ItemCodeId"]);                           
                            Auto.ItemCode = dr["ItemCode"].ToString();
                            Auto.ItemName = dr["ItemName"].ToString();
                            Auto.ItemType = dr["ItemType"].ToString();
                            Auto.Size = dr["Size"].ToString();
                            Auto.UOM = dr["UOM"].ToString();
                            _consumablesList.Add(Auto);

                         }
                        _consumablesreceptacles.ItemList = _consumablesList;
                    }
                }
                
                Log4NetLogger.LogExit(_FileName, nameof(Get), Level.Info.ToString());
                return _consumablesreceptacles;
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