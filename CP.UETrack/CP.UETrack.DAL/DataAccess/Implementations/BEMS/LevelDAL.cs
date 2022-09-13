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

namespace CP.UETrack.DAL.DataAccess
{
   
    public class LevelDAL : ILevelDAL
    {
        private readonly string _FileName = nameof(LevelDAL);
        readonly UserDetailsModel _UserSession = new SessionHelper().UserSession();

        public LevelDAL()
        {

        }
        public LevelFacilityBlockDropdown Load()
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
                LevelFacilityBlockDropdown LevelFacilityBlockDropdown = null;

                var ds = new DataSet();
                var dbAccessDAL = new FEMSDBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "LevelMst_FacilityBlockDropdown";
                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }
                if (ds.Tables.Count != 0)
                {
                    LevelFacilityBlockDropdown = new LevelFacilityBlockDropdown();
                    LevelFacilityBlockDropdown.FacilityData = dbAccessDAL.GetLovRecords(ds.Tables[0]);
                    LevelFacilityBlockDropdown.BlockData = dbAccessDAL.GetLovRecords(ds.Tables[1]);
                    LevelFacilityBlockDropdown.FacilityId = _UserSession.FacilityId;

                }
                Log4NetLogger.LogExit(_FileName, nameof(Load), Level.Info.ToString());
                return LevelFacilityBlockDropdown;
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
        public LevelMstViewModel Save(LevelMstViewModel level)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());

                var spName = string.Empty;
                if (level.LevelId != 0)
                {
                    spName = "LevelMst_Update";
                }
                else
                {
                    spName = "LevelMst_Save";
                }

                DataTable dataTable = new DataTable("BemsLevelMst");
                dataTable.Columns.Add("LevelId", typeof(int));
                dataTable.Columns.Add("FacilityId", typeof(int));
                dataTable.Columns.Add("BlockId", typeof(int));
                dataTable.Columns.Add("LevelCode", typeof(string));
                dataTable.Columns.Add("LevelName", typeof(string));
                dataTable.Columns.Add("ShortName", typeof(string));
                dataTable.Columns.Add("Active", typeof(bool));
                dataTable.Columns.Add("UserId", typeof(int));
                dataTable.Columns.Add("CustomerId", typeof(int));

                dataTable.Rows.Add(level.LevelId, level.FacilityId, level.BlockId, level.LevelCode, level.LevelName, level.ShortName, level.Active, _UserSession.UserId, _UserSession.CustomerId);

                var ds = new DataSet();
                var dbAccessDAL = new FEMSDBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = spName;

                        SqlParameter parameter = new SqlParameter();
                        parameter.ParameterName = "@Level";
                        parameter.SqlDbType = System.Data.SqlDbType.Structured;
                        parameter.Value = dataTable;
                        cmd.Parameters.Add(parameter);

                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }
                if (ds.Tables.Count != 0)
                {
                    level.LevelId = Convert.ToInt32(ds.Tables[0].Rows[0]["LevelId"]);
                    level.Timestamp = Convert.ToBase64String((byte[])(ds.Tables[0].Rows[0]["Timestamp"]));
                    level.HiddenId = Convert.ToString(ds.Tables[0].Rows[0]["GuId"]);
                }

                Log4NetLogger.LogExit(_FileName, nameof(Save), Level.Info.ToString());
                return level;
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

                var ds = new DataSet();
                var dbAccessDAL = new FEMSDBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_MstLocationLevel_GetAll";

                        cmd.Parameters.AddWithValue("@PageIndex", pageFilter.PageIndex);
                        cmd.Parameters.AddWithValue("@PageSize", pageFilter.PageSize);
                        cmd.Parameters.AddWithValue("@StrCondition", pageFilter.QueryWhereCondition);
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
        public LevelMstViewModel    Get(int Id)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
                LevelMstViewModel level = null;

                var ds = new DataSet();
                var dbAccessDAL = new FEMSDBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "LevelMst_Get";
                        cmd.Parameters.AddWithValue("Id", Id);
                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }
                if (ds.Tables.Count != 0)
                {
                    //level.HiddenId = Convert.ToString(ds.Tables[0].Rows[0]["GuId"]);

                    level = (from n in ds.Tables[0].AsEnumerable()
                                         select new LevelMstViewModel
                                         {
                                             LevelId = Id,
                                             LevelCode = Convert.ToString(n["LevelCode"]),
                                             FacilityId = Convert.ToInt32(n["FacilityId"]),
                                             BlockId = Convert.ToInt32(n["BlockId"]),
                                             Active = Convert.ToInt32(n["Active"]),
                                             LevelName = Convert.ToString(n["LevelName"]),
                                             ShortName = Convert.ToString(n["ShortName"]),
                                             BlockCode = Convert.ToString(n["BlockCode"]),
                                             BlockName = Convert.ToString(n["BlockName"]),
                                             HiddenId = Convert.ToString(n["GuId"]),
                                             Timestamp = Convert.ToBase64String((byte[])(n["Timestamp"]))
                                         }).FirstOrDefault();
                }
                Log4NetLogger.LogExit(_FileName, nameof(Get), Level.Info.ToString());
                return level;
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

        public LevelFacilityBlockDropdown GetBlockData(int levelFacilityId)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
                LevelFacilityBlockDropdown LevelFacilityBlockDropdown = null;

                var ds = new DataSet();
                var dbAccessDAL = new FEMSDBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "LevelMst_BlockDropdown";
                        cmd.Parameters.AddWithValue("levelFacilityId", levelFacilityId);
                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }
                if (ds.Tables.Count != 0)
                {
                    LevelFacilityBlockDropdown = new LevelFacilityBlockDropdown();
                    LevelFacilityBlockDropdown.BlockData = dbAccessDAL.GetLovRecords(ds.Tables[0]);
                }
                Log4NetLogger.LogExit(_FileName, nameof(Load), Level.Info.ToString());
                return LevelFacilityBlockDropdown;
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
        public bool IsLevelCodeDuplicate(LevelMstViewModel level)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(IsLevelCodeDuplicate), Level.Info.ToString());

                var isDuplicate = true;
                var isvalid = 1; 
                var dbAccessDAL = new FEMSDBAccessDAL();
              //  var facilityObj = new MstLocationFacilityViewModel();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pLevelId",Convert.ToString( level.LevelId));
                parameters.Add("@pCustomerId", Convert.ToString(_UserSession.CustomerId));
                parameters.Add("@pFacilityId", Convert.ToString(_UserSession.FacilityId));
                parameters.Add("@LevelCode", Convert.ToString(level.LevelCode));
                
            
                DataSet ds = dbAccessDAL.GetDataSet("LevelMst_IsLevelCodeDuplicate", parameters, DataSetparameters);
                if (ds != null && ds.Tables[0] != null && ds.Tables[0].Rows.Count > 0)
                {
                   isvalid = Convert.ToInt16(ds.Tables[0].Rows[0]["Isvalid"]);
                }


                if (isvalid == 1)
                {
                    isDuplicate = true;
                }
                else {
                    isDuplicate = false;
                }
                

                //
                //string constring = ConfigurationManager.ConnectionStrings["UETrackConnectionString"].ConnectionString;
                //using (SqlConnection con = new SqlConnection(constring))
                //{
                //    using (SqlCommand cmd = new SqlCommand())
                //    {
                //        cmd.Connection = con;
                //        cmd.CommandType = CommandType.StoredProcedure;
                //        cmd.CommandText = "LevelMst_IsLevelCodeDuplicate";
                //        cmd.Parameters.AddWithValue("@pLevelId", level.LevelId);
                //        cmd.Parameters.AddWithValue("@pCustomerId", _UserSession.CustomerId);
                //        cmd.Parameters.AddWithValue("@pFacilityId", _UserSession.FacilityId);
                //        cmd.Parameters.AddWithValue("@LevelCode", level.LevelCode);
                //        cmd.Parameters.Add("@IsDuplicate", SqlDbType.Bit);
                //        cmd.Parameters["@IsDuplicate"].Direction = ParameterDirection.Output;

                //        con.Open();
                //        cmd.ExecuteNonQuery();
                //        con.Close();
                //        bool.TryParse(cmd.Parameters["@IsDuplicate"].Value.ToString(), out isDuplicate);
                //    }
                //}

                Log4NetLogger.LogExit(_FileName, nameof(IsLevelCodeDuplicate), Level.Info.ToString());
                return isDuplicate;
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
        public bool IsRecordModified(LevelMstViewModel level)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(IsRecordModified), Level.Info.ToString());

                var recordModifed = false;
                
                if(level.BlockId != 0)
                {
                    var ds = new DataSet();
                    string constring = ConfigurationManager.ConnectionStrings["UETrackConnectionString"].ConnectionString;
                    using (SqlConnection con = new SqlConnection(constring))
                    {
                        using (SqlCommand cmd = new SqlCommand())
                        {
                            cmd.Connection = con;
                            cmd.CommandType = CommandType.StoredProcedure;
                            cmd.CommandText = "GetLevelTimestamp";
                            cmd.Parameters.AddWithValue("Id", level.BlockId);
                            var da = new SqlDataAdapter();
                            da.SelectCommand = cmd;
                            da.Fill(ds);
                        }
                    }
                    if (ds.Tables.Count != 0 && ds.Tables[0].Rows.Count > 0)
                    {
                        var timestamp = Convert.ToBase64String((byte[])(ds.Tables[0].Rows[0]["Timestamp"]));
                        if (timestamp != level.Timestamp)
                        {
                            recordModifed = true;
                        }
                    }
                }

                Log4NetLogger.LogExit(_FileName, nameof(IsRecordModified), Level.Info.ToString());
                return recordModifed;
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
        public void Delete(int Id)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Delete), Level.Info.ToString());
                
                var dbAccessDAL = new FEMSDBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "LevelMst_Delete";
                        cmd.Parameters.AddWithValue("Id", Id);

                        con.Open();
                        cmd.ExecuteNonQuery();
                        con.Close();
                    }
                }
                Log4NetLogger.LogExit(_FileName, nameof(Delete), Level.Info.ToString());
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
