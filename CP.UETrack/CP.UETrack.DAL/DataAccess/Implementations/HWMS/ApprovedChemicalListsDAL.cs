using CP.UETrack.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using CP.Framework.Common.Logging;
using CP.Framework.Common.ExceptionHandler.ExceptionWrappers;
using CP.UETrack.Models;
using CP.UETrack.Model.HWMS;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using UETrack.DAL;
using System.Dynamic;
using CP.UETrack.DAL.DataAccess.Implementation;
using CP.UETrack.DAL.DataAccess.Contracts.HWMS;

namespace CP.UETrack.DAL.DataAccess.Implementations.HWMS
{
   public class ApprovedChemicalListsDAL:IApprovedChemicalListsDAL
    {
        private readonly string _FileName = nameof(BlockDAL);
        readonly UserDetailsModel _UserSession = new SessionHelper().UserSession();

        public ApprovedChemicalListsDAL()
        {

        }

        public ApprovedChemicalListsDropdown Load()
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();

                ApprovedChemicalListsDropdown chemicalListsDropdown1 = new ApprovedChemicalListsDropdown();

                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        var da = new SqlDataAdapter();
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "Sp_HWMS_ApprovedChemicalList_Dropdown";
                        cmd.Parameters.Clear();
                        cmd.Parameters.AddWithValue("@pScreenName", "ApprovedChemicalLists");

                        da.SelectCommand = cmd;
                        da.Fill(ds);

                        if (ds.Tables[0] != null)
                        {
                            chemicalListsDropdown1.StatusLovs = dbAccessDAL.GetLovRecords(ds.Tables[0]);
                        }
                        if (ds.Tables[1] != null)
                        {
                            chemicalListsDropdown1.CategoryLovs2 = dbAccessDAL.GetLovRecords(ds.Tables[1]);
                        }
                        
                        if (ds.Tables[3] != null)
                        {
                            chemicalListsDropdown1.AreaOfApplicationLovs2 = dbAccessDAL.GetLovRecords(ds.Tables[3]);
                        }
                    }
                }

                Log4NetLogger.LogExit(_FileName, nameof(Load), Level.Info.ToString());
                return chemicalListsDropdown1;
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

        public ApprovedChemicalLists Save(ApprovedChemicalLists model, out string ErrorMessage)
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
                        cmd.CommandText = "Sp_HWMS_ApprovedChemicalList";

                        cmd.Parameters.AddWithValue("@ApprovedId", model.ApprovedChemicalId);
                        cmd.Parameters.AddWithValue("@Customerid", model.CustomerId);
                        cmd.Parameters.AddWithValue("@Facilityid", model.FacilityId);
                        cmd.Parameters.AddWithValue("@Category", model.Category);
                        cmd.Parameters.AddWithValue("@AreaofApplication", model.AreaofApplication);
                        cmd.Parameters.AddWithValue("@ChemicalName", model.ChemicalName);
                        cmd.Parameters.AddWithValue("@KKMNumber", model.KKMNumber);
                        cmd.Parameters.AddWithValue("@Properties", model.Properties);
                        cmd.Parameters.AddWithValue("@Status", model.Status);
                        cmd.Parameters.AddWithValue("@EffectiveFromDate", model.EffectiveFromDate);
                        cmd.Parameters.AddWithValue("@EffectiveFTodate", model.EffectiveToDate);

                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }
                if (ds.Tables.Count != 0)
                {
                    if (ds.Tables[0].Rows[0][0].ToString() == "KKMNumber already exists")
                    {
                        model.ApprovedChemicalId = 0;
                        ErrorMessage = "KKMNumber already exists";
                    }
                    else
                    {
                        model.ApprovedChemicalId = Convert.ToInt32(ds.Tables[0].Rows[0]["ApprovedId"]);
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
                        cmd.CommandText = "Sp_HWMS_ApprovedChemicalList_GetAll";

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

        public ApprovedChemicalLists Get(int Id)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
                ApprovedChemicalLists Block = null;

                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "Sp_HWMS_ApprovedChemicalList_Get";
                        cmd.Parameters.AddWithValue("Id", Id);
                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }
                if (ds.Tables.Count != 0)
                {
                    Block = (from n in ds.Tables[0].AsEnumerable()
                             select new ApprovedChemicalLists
                             {
                                 ApprovedChemicalId = Id,
                                 Category = Convert.ToString(n["Category"]),
                                 AreaofApplication = Convert.ToString(n["AreaofApplication"]),
                                 ChemicalName = Convert.ToString(n["ChemicalName"]),
                                 KKMNumber = Convert.ToString(n["KKMNumber"]),
                                 Properties = Convert.ToString(n["Properties"]),
                                 Status = Convert.ToInt32(n["Status"]),
                                 EffectiveFromDate = Convert.ToDateTime(n["EffectiveFromDate"]),
                                 EffectiveToDate = n["EffectiveToDate"] == DBNull.Value ? default(DateTime?) : Convert.ToDateTime(n["EffectiveToDate"])
                             }).FirstOrDefault();
                }
                Log4NetLogger.LogExit(_FileName, nameof(Get), Level.Info.ToString());
                return Block;
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
