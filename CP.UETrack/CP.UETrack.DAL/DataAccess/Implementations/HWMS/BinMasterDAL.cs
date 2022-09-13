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
using UETrack.DAL;

namespace CP.UETrack.DAL.DataAccess.Implementations.HWMS
{
    public class BinMasterDAL : IBinMasterDAL
    {
        private readonly string _FileName = nameof(BlockDAL);
        readonly UserDetailsModel _UserSession = new SessionHelper().UserSession();

        public BinMasterDropDown Load()
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());              
                 var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                BinMasterDropDown binMasterDropdownvalues = new BinMasterDropDown();

                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "Sp_HWMS_BinMaster_DropDown";
                        cmd.Parameters.Clear();
                        cmd.Parameters.AddWithValue("@pScreenName", "BinMaster");                    
                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);

                        if (ds.Tables[0] != null)
                        {
                            binMasterDropdownvalues.StatusLovs = dbAccessDAL.GetLovRecords(ds.Tables[0]);
                        }
                        if (ds.Tables[1] != null)
                        {
                            binMasterDropdownvalues.CapacityCodeLovs = dbAccessDAL.GetLovRecords(ds.Tables[1]);
                        }
                        if (ds.Tables[2] != null)
                        {
                            binMasterDropdownvalues.WasteTypeLovs = dbAccessDAL.GetLovRecords(ds.Tables[2]);
                        }
                    }
                }

                Log4NetLogger.LogExit(_FileName, nameof(Load), Level.Info.ToString());
                return binMasterDropdownvalues;
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
        public BinMaster Save(BinMaster model, out string ErrorMessage)
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
                        cmd.CommandText = "Sp_HWMS_BinMaster_Save";

                        cmd.Parameters.AddWithValue("@BinMasterId", model.BinMasterId);
                        cmd.Parameters.AddWithValue("@CustomerId", model.CustomerId);
                        cmd.Parameters.AddWithValue("@FacilityId", model.FacilityId);
                        cmd.Parameters.AddWithValue("@CapacityCode", model.CapacityCode);
                        cmd.Parameters.AddWithValue("@Description", model.Description);
                        cmd.Parameters.AddWithValue("@WasteType", model.WasteType);
                        cmd.Parameters.AddWithValue("@NoofBins", model.NoofBins);

                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);

                        if (ds.Tables.Count != 0)
                        {
                            cmd.Parameters.Clear();
                            model.BinMasterId = Convert.ToInt32(ds.Tables[0].Rows[0]["BinMasterId"]);
                            var ds1 = new DataSet();
                            cmd.CommandText = "Sp_HWMS_BinMasterBins_Save";

                            foreach (var use in model.binDetailslist)
                            {

                                cmd.Parameters.AddWithValue("@BinMasterId", model.BinMasterId);
                                cmd.Parameters.AddWithValue("@BinNoId", use.BinNoId);
                                cmd.Parameters.AddWithValue("@BinNo", use.BinNo);
                                cmd.Parameters.AddWithValue("@Manufacturer", use.Manufacturer);
                                cmd.Parameters.AddWithValue("@Weight", use.Weight);
                                cmd.Parameters.AddWithValue("@OperationDate", use.OperationDate);
                                cmd.Parameters.AddWithValue("@Status", use.Status);                            
                                cmd.Parameters.AddWithValue("@DisposedDate", use.DisposedDate);
                                cmd.Parameters.AddWithValue("@IsDeleted", use.isDeleted);

                                da.SelectCommand = cmd;
                                da.Fill(ds1);
                                cmd.Parameters.Clear();
                            }
                        }
                    }
                }

                model = Get(model.BinMasterId);

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
                        cmd.CommandText = "Sp_HWMS_BinMaster_GetAll";

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
        public BinMaster Get(int Id)
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
                        cmd.CommandText = "Sp_HWMS_BinMaster_Get";
                        cmd.Parameters.AddWithValue("@BinMasterId", Id);
                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }
                BinMaster _binMaster = new BinMaster();

                if (ds.Tables[0].Rows.Count > 0)
                {
                    DataRow dr = ds.Tables[0].Rows[0];

                    _binMaster.BinMasterId =  Convert.ToInt32(dr["BinMasterId"]);
                    _binMaster.CapacityCode = dr["CapacityCode"].ToString();
                    _binMaster.Description = dr["Description"].ToString();
                    _binMaster.WasteType = dr["WasteType"].ToString();
                    _binMaster.NoofBins = Convert.ToInt32(dr["NoofBins"].ToString());
                }
                if (ds.Tables[1] != null)
                {
                    if (ds.Tables[1].Rows.Count > 0)
                    {
                        List<BinMasterTable> _binMasterList = new List<BinMasterTable>()
;                          foreach (DataRow dr in ds.Tables[1].Rows)
                        {
                            BinMasterTable Auto = new BinMasterTable();
                            
                            Auto.BinNoId = Convert.ToInt32(dr["BinNoId"].ToString());
                            Auto.BinNo = dr["BinNo"].ToString();
                            Auto.Manufacturer = dr["Manufacturer"].ToString();
                            Auto.Weight = dr["Weight"].ToString();
                            Auto.OperationDate = Convert.ToDateTime(dr["OperationDate"]);
                            Auto.Status = dr["Status"].ToString();
                            Auto.DisposedDate = CommonDAL.checkDate(dr["DisposedDate"]);
                            _binMasterList.Add(Auto);
                        }
                        _binMaster.binDetailslist = _binMasterList;
                    }
                }
                Log4NetLogger.LogExit(_FileName, nameof(Get), Level.Info.ToString());
                return _binMaster;
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
