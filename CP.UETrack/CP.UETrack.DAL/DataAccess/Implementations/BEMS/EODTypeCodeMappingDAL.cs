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
   
    public class EODTypeCodeMappingDAL : IEODTypeCodeMappingDAL
    {
        private readonly string _FileName = nameof(EODTypeCodeMappingDAL);
        readonly UserDetailsModel _UserSession = new SessionHelper().UserSession();

        public EODTypeCodeMappingDAL()
        {

        }
        public EODDropdownValues Load()
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
                EODDropdownValues EODTypeCodeMappingDropdown = null;

                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_Dropdown_Others  ";
                        cmd.Parameters.AddWithValue("@pTableName", "EngEODCategorySystemDet");
                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }
                if (ds.Tables.Count != 0)
                {
                    EODTypeCodeMappingDropdown = new EODDropdownValues();
                    EODTypeCodeMappingDropdown.ServiceLovs = dbAccessDAL.GetLovRecords(ds.Tables[0]);
                    EODTypeCodeMappingDropdown.CategorySystem = dbAccessDAL.GetLovRecords(ds.Tables[1]);
                }
                Log4NetLogger.LogExit(_FileName, nameof(Load), Level.Info.ToString());
                return EODTypeCodeMappingDropdown;
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
        public EODTypeCodeMappingViewModel Save(EODTypeCodeMappingViewModel EODTypeCodeMapping, out string ErrorMessage)
        {
            try
            {
                ErrorMessage = string.Empty;
                Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());
                EODTypeCodeMappingViewModel griddata = new EODTypeCodeMappingViewModel();
                var dbAccessDAL = new DBAccessDAL();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pCategorySystemId", Convert.ToString(EODTypeCodeMapping.CategorySystemId));
                parameters.Add("@pServiceId", Convert.ToString(EODTypeCodeMapping.ServiceId));
                parameters.Add("@pCategorySystemName", Convert.ToString(EODTypeCodeMapping.CategorySystemName));
                parameters.Add("@pEntrymode", Convert.ToString(EODTypeCodeMapping.EntryModeChk));

                var DataSetparameters = new Dictionary<string, DataTable>();
                DataTable dt = new DataTable();
                dt.Columns.Add("CategorySystemDetId", typeof(int));
                dt.Columns.Add("CategorySystemId", typeof(int));
                dt.Columns.Add("AssetTypeCodeId", typeof(int));
                dt.Columns.Add("UserId", typeof(int));

                var deletedId = EODTypeCodeMapping.EODTypeCodeMappingGridData.Where(y => y.IsDeleted).Select(x => x.CategorySystemDetId).ToList();
                var idstring = string.Empty;
                if (deletedId.Count() > 0)
                {
                    foreach (var item in deletedId.Select((value, i) => new { i, value }))
                    {
                        idstring += item.value;
                        if (item.i != deletedId.Count() - 1)
                        { idstring += ","; }
                    }
                    deleteChildrecords(idstring);
                }

                foreach (var i in EODTypeCodeMapping.EODTypeCodeMappingGridData.Where(y => !y.IsDeleted))
                {
                    dt.Rows.Add(i.CategorySystemDetId, i.CategorySystemId,i.AssetTypeCodeId, _UserSession.UserId);
                }

                DataSetparameters.Add("@EngEODCategorySystemDet", dt);
                DataTable dt1 = dbAccessDAL.GetDataTable("uspFM_EngEODCategorySystemDet_Save1", parameters, DataSetparameters);
                if (dt1 != null)
                {
                    foreach (DataRow row in dt1.Rows)
                    {
                        griddata.CategorySystemId = Convert.ToInt32(row["CategorySystemId"]);
                        griddata.Timestamp = Convert.ToBase64String((byte[])(row["Timestamp"]));
                        ErrorMessage = Convert.ToString(row["ErrorMessage"]);
                    }
                }

                Log4NetLogger.LogExit(_FileName, nameof(Save), Level.Info.ToString());
                return EODTypeCodeMapping;
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
                        cmd.CommandText = "uspFM_EngEODCategorySystemDet_GetAll";

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
                //return EODTypeCodeMappings;
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
        public EODTypeCodeMappingViewModel Get(int Id, int pagesize, int pageindex)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
            try
            {
                var dbAccessDAL = new DBAccessDAL();
                EODTypeCodeMappingViewModel entity = new EODTypeCodeMappingViewModel();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                //parameters.Add("@pUserId", Convert.ToString(_UserSession.UserId));
                parameters.Add("@pCategorySystemId", Id.ToString());
                parameters.Add("@pPageIndex", pageindex.ToString());
                parameters.Add("@pPageSize", pagesize.ToString());
                DataSet dt = dbAccessDAL.GetDataSet("UspFM_EngEODCategorySystemDet_GetById", parameters, DataSetparameters);
                if (dt != null && dt.Tables[0].Rows.Count > 0)
                {

                    entity.EODTypeCodeMappingGridData = (from n in dt.Tables[0].AsEnumerable()
                                                      select new EODTypeCodeMappingGrid
                                                      {
                                                          CategorySystemId = Convert.ToInt16(n["CategorySystemId"]),
                                                          CategorySystemDetId = Convert.ToInt16(n["CategorySystemDetId"]),
                                                          ServiceId = Convert.ToInt16(n["ServiceId"]),
                                                          ServiceName = Convert.ToString(n["ServiceKey"]),
                                                          AssetTypeCodeId = Convert.ToInt16(n["AssetTypeCodeId"]),
                                                          AssetTypeCode = Convert.ToString(n["AssetTypeCode"]),
                                                          AssetTypeDescription = Convert.ToString(n["AssetTypeDescription"]),
                                                          CategorySystemName = Convert.ToString(n["CategorySystemName"]),
                                                          TotalRecords = Convert.ToInt32(n["TotalRecords"]),
                                                          TotalPages = Convert.ToInt32(n["TotalPageCalc"]),

                                                          Isreferenced = Convert.ToBoolean(n["IsReferenced"]),
                                                      }).ToList();

                    entity.EODTypeCodeMappingGridData.ForEach((x) =>
                    {
                        x.PageIndex = pageindex;
                        x.FirstRecord = ((pageindex - 1) * pagesize) + 1;
                        x.LastRecord = ((pageindex - 1) * pagesize) + pagesize;

                        x.CategorySystemId = Id;
                    });
                    entity.CategorySystemId = Id;

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
        public bool IsRoleDuplicate(EODTypeCodeMappingViewModel EODTypeCodeMapping)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(IsRoleDuplicate), Level.Info.ToString());

                var isDuplicate = true;
                string constring = ConfigurationManager.ConnectionStrings["UETrackConnectionString"].ConnectionString;
                using (SqlConnection con = new SqlConnection(constring))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "IsRoleDuplicate";
                        cmd.Parameters.AddWithValue("@Id", EODTypeCodeMapping.CategorySystemId);
                        cmd.Parameters.AddWithValue("@Name", EODTypeCodeMapping.CategorySystemName);
                        cmd.Parameters.Add("@IsDuplicate", SqlDbType.Bit);
                        cmd.Parameters["@IsDuplicate"].Direction = ParameterDirection.Output;
                        
                        con.Open();
                        cmd.ExecuteNonQuery();
                        con.Close();
                        bool.TryParse(cmd.Parameters["@IsDuplicate"].Value.ToString(), out isDuplicate);
                    }
                }

                Log4NetLogger.LogExit(_FileName, nameof(IsRoleDuplicate), Level.Info.ToString());
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
        public bool IsRecordModified(EODTypeCodeMappingViewModel EODTypeCodeMapping)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(IsRecordModified), Level.Info.ToString());

                var recordModifed = false;
                
                if(EODTypeCodeMapping.CategorySystemId != 0)
                {
                    var ds = new DataSet();
                    string constring = ConfigurationManager.ConnectionStrings["UETrackConnectionString"].ConnectionString;
                    using (SqlConnection con = new SqlConnection(constring))
                    {
                        using (SqlCommand cmd = new SqlCommand())
                        {
                            cmd.Connection = con;
                            cmd.CommandType = CommandType.StoredProcedure;
                            cmd.CommandText = "GetEODTypeCodeMappingTimestamp";
                            cmd.Parameters.AddWithValue("Id", EODTypeCodeMapping.CategorySystemId);
                            var da = new SqlDataAdapter();
                            da.SelectCommand = cmd;
                            da.Fill(ds);
                        }
                    }
                    if (ds.Tables.Count != 0 && ds.Tables[0].Rows.Count > 0)
                    {
                        var timestamp = Convert.ToBase64String((byte[])(ds.Tables[0].Rows[0]["Timestamp"]));
                        if (timestamp != EODTypeCodeMapping.Timestamp)
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
        public void Delete(int Id, out string ErrorMessage)
        {
            try
            {
                var ds = new DataTable();
                ErrorMessage = string.Empty;
                Log4NetLogger.LogEntry(_FileName, nameof(Delete), Level.Info.ToString());
                
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_EngEODCategorySystemDet_GetAll_Delete";
                        cmd.Parameters.AddWithValue("@pCategorySystemId", Id);

                        //con.Open();
                        //cmd.ExecuteNonQuery();
                        //con.Close();
                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }
                if (ds.Rows.Count != 0)
                {
                    ErrorMessage = Convert.ToString(ds.Rows[0]["ErrorMessage"]);
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

        public void deleteChildrecords(string id)
        {
            try
            {
                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_EngEODCategorySystemDet_Delete";
                        cmd.Parameters.AddWithValue("@pCategorySystemDetId", id);

                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }
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
