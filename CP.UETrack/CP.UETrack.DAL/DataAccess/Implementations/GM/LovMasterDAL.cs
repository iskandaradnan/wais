using CP.Framework.Common.ExceptionHandler.ExceptionWrappers;
using CP.Framework.Common.Logging;
using CP.UETrack.DAL.DataAccess.Contracts.GM;
using CP.UETrack.DAL.DataAccess.Implementation;
using CP.UETrack.Model;
using CP.UETrack.Model.GM;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using UETrack.DAL;

namespace CP.UETrack.DAL.DataAccess.Implementations.GM
{
    public class LovMasterDAL : ILovMasterDAL
    {
        private readonly string _FileName = nameof(LovMasterDAL);
        readonly UserDetailsModel _UserSession = new SessionHelper().UserSession();

        public LovMasterDAL()
        {

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
                
                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_FMLovMst_GetAll ";

                        cmd.Parameters.AddWithValue("@PageIndex", pageFilter.PageIndex);
                        cmd.Parameters.AddWithValue("@PageSize", pageFilter.PageSize);
                        cmd.Parameters.AddWithValue("@strCondition", pageFilter.QueryWhereCondition);
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

        public LovMasterDropdownValues Load()
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
                LovMasterDropdownValues LovMasterDropdownValues = null;

                var ds = new DataSet();
                var srevicesDS = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_Dropdown";
                        cmd.Parameters.AddWithValue("@pLovKey", "LovTypeValue");
                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                        //Get services
                        var da2 = new SqlDataAdapter();
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_GetServices";
                        cmd.Parameters.Clear();
                        //  cmd.Parameters.AddWithValue("@UserRegistrationId", _UserSession.UserId);
                       // da2.SelectCommand = cmd;
                       // da2.Fill(srevicesDS);

                        if (ds.Tables.Count != 0)
                        {
                            LovMasterDropdownValues = new LovMasterDropdownValues();
                            LovMasterDropdownValues.LovType = dbAccessDAL.GetLovRecords(ds.Tables[0]);
                          

                        }
                        //if (srevicesDS.Tables.Count != 0)
                        //{
                        //    LovMasterDropdownValues.Services = dbAccessDAL.GetLovRecords(srevicesDS.Tables[0]);
                        //}


                        }
                }

                Log4NetLogger.LogExit(_FileName, nameof(Load), Level.Info.ToString());
                return LovMasterDropdownValues;
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

        public LovMasterViewModel Get(string Id)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
            try
            {
                var dbAccessDAL = new DBAccessDAL();
                LovMasterViewModel entity = new LovMasterViewModel();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pUserId", Convert.ToString(_UserSession.UserId));
                parameters.Add("@pLovKey", Id);
                DataSet ds = dbAccessDAL.GetDataSet("UspFM_FMLovMst_GetById  ", parameters, DataSetparameters);
                if (ds != null)
                {
                    if (ds.Tables[0] != null && ds.Tables[0].Rows.Count > 0)
                    {
                        
                        entity.LovId = Convert.ToInt16(ds.Tables[0].Rows[0]["LovId"]);
                        entity.LovKey = Convert.ToString(ds.Tables[0].Rows[0]["LovKey"]);
                        entity.IsDefault = Convert.ToString(ds.Tables[0].Rows[0]["IsDefault"]);
                        entity.ScreenName = Convert.ToString(ds.Tables[0].Rows[0]["ScreenName"]);
                        entity.ModuleName = Convert.ToString(ds.Tables[0].Rows[0]["ModuleName"]);
                        entity.Timestamp = Convert.ToBase64String((byte[])(ds.Tables[0].Rows[0]["Timestamp"]));
                    }

                    entity.LovMasterGridData = (from n in ds.Tables[0].AsEnumerable()
                                                select new LovMasterGrid
                                                {
                                                    LovType = Convert.ToString(n["LovType"]),
                                                    LovId = Convert.ToInt16(n["LovId"]),
                                                    Fieldcode = Convert.ToString(n["FieldCode"]),
                                                    FieldValue = Convert.ToString(n["FieldValue"]),
                                                    Remarks = Convert.ToString(n["Remarks"]),
                                                    SortNo = Convert.ToInt16(n["SortNo"]),
                                                    IsDefault = Convert.ToBoolean(n["IsDefault"]),
                                                    BuiltIn = Convert.ToBoolean(n["BuiltIn"]),
                                                }).ToList();



                }
                return entity;
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

        public LovMasterViewModel Save(LovMasterViewModel LovMaster, out string ErrorMessage)
        {
            try

            {
                ErrorMessage = string.Empty;
                Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());
                LovMasterViewModel griddata = new LovMasterViewModel();
                var dbAccessDAL = new DBAccessDAL();
                var parameters = new Dictionary<string, string>();
                var DataSetparameters = new Dictionary<string, DataTable>();
                DataTable dt = new DataTable();
                dt.Columns.Add("LovId", typeof(int));
                dt.Columns.Add("ModuleName", typeof(string));
                dt.Columns.Add("ScreenName", typeof(string));
                dt.Columns.Add("FieldName", typeof(string));
                dt.Columns.Add("LovKey", typeof(string));
                dt.Columns.Add("Fieldcode", typeof(string));
                dt.Columns.Add("FieldValue", typeof(string));
                dt.Columns.Add("Remarks", typeof(string));
                dt.Columns.Add("ParentId", typeof(int));
                dt.Columns.Add("SortNo", typeof(int));
                dt.Columns.Add("IsDefault", typeof(bool));
                dt.Columns.Add("IsEditable", typeof(bool));
                dt.Columns.Add("Active", typeof(bool));
                dt.Columns.Add("BuiltIn", typeof(bool));
                dt.Columns.Add("UserId", typeof(int));
                dt.Columns.Add("LovType", typeof(int));
               
             
                foreach (var i in LovMaster.LovMasterGridData)
                {
                    dt.Rows.Add(i.LovId, i.ModuleName, i.ScreenName, 1, i.LovKey, i.Fieldcode, i.FieldValue, i.Remarks, null, i.SortNo, i.IsDefault, 1, 1, 0, _UserSession.UserId, i.LovType);
                }
                DataSetparameters.Add("@FMLovMst", dt);
                DataTable dt1 = dbAccessDAL.GetDataTable("uspFM_FMLovMst_Save", parameters, DataSetparameters);
                if (dt1 != null)
                {
                    foreach (DataRow row in dt1.Rows)
                    {
                        LovMaster.LovId = Convert.ToInt16(row["LovId"]);
                        LovMaster.Timestamp = Convert.ToBase64String((byte[])(row["Timestamp"]));
                        ErrorMessage = Convert.ToString(row["ErrorMessage"]);
                    }
                }
                Log4NetLogger.LogExit(_FileName, nameof(Save), Level.Info.ToString());
                return LovMaster;
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



