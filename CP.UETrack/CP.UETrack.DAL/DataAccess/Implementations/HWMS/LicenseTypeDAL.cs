using CP.Framework.Common.ExceptionHandler.ExceptionWrappers;
using CP.Framework.Common.Logging;
using CP.UETrack.DAL.DataAccess.Contracts.HWMS;
using CP.UETrack.DAL.DataAccess.Implementation;
using CP.UETrack.Model;
using CP.UETrack.Model.Common;
using CP.UETrack.Model.HWMS;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using UETrack.DAL;


namespace CP.UETrack.DAL.DataAccess.Implementations.HWMS
{

    public class LicenseTypeDAL : ILicenseTypeDAL
    {
        private readonly string _FileName = nameof(BlockDAL);
        readonly UserDetailsModel _UserSession = new SessionHelper().UserSession();

        public LicenseType Save(LicenseType model, out string ErrorMessage)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());
                ErrorMessage = string.Empty;
                var spName = string.Empty;
                var da = new SqlDataAdapter();
                var ds = new DataSet();
               
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "Sp_HWMS_LicenseType_Save";

                        cmd.Parameters.AddWithValue("@LicenseTypeId", Convert.ToString(model.LicenseTypeId));
                        cmd.Parameters.AddWithValue("@CustomerId", Convert.ToString(model.CustomerId));
                        cmd.Parameters.AddWithValue("@FacilityId", Convert.ToString(model.FacilityId));
                        cmd.Parameters.AddWithValue("@LicenseType", Convert.ToString(model.LicenseOfType));
                        cmd.Parameters.AddWithValue("@WasteCategory", Convert.ToString(model.WasteCategory));
                        cmd.Parameters.AddWithValue("@WasteType", Convert.ToString(model.WasteType));

                        
                        da.SelectCommand = cmd;
                        da.Fill(ds);

                        if (ds.Tables.Count != 0)
                        {
                            model.LicenseTypeId = Convert.ToInt32(ds.Tables[0].Rows[0]["LicenseTypeId"]);


                            cmd.Parameters.Clear();
                            cmd.Connection = con;
                            cmd.CommandType = CommandType.StoredProcedure;
                            cmd.CommandText = "Sp_HWMS_LicenseTypeDetails_Save";

                            var isDuplicateLicenceCode = 0;
                            
                            foreach (var License in model.licenseCodeList)
                            {
                                var dt = new DataTable();

                                cmd.Parameters.AddWithValue("@LicenseId", Convert.ToString(License.LicenseId));
                                cmd.Parameters.AddWithValue("@LicenseTypeId", Convert.ToString(model.LicenseTypeId));
                                cmd.Parameters.AddWithValue("@LicenseCode", Convert.ToString(License.LicenseCode));
                                cmd.Parameters.AddWithValue("@LicenseDescription", Convert.ToString(License.LicenseDescription));
                                cmd.Parameters.AddWithValue("@issuingBody", Convert.ToString(License.IssuingBody));
                                cmd.Parameters.AddWithValue("@isDeleted", License.isDeleted);

                                da.SelectCommand = cmd;
                                da.Fill(dt);
                                cmd.Parameters.Clear();

                                if (dt.Rows[0][0].ToString() == "-1")
                                {
                                    isDuplicateLicenceCode += 1;
                                }
                            }
                          

                            if(isDuplicateLicenceCode > 0)
                            {
                                ErrorMessage = "Duplicate LicenseCode";
                            }
                            else
                            {
                                model = Get(model.LicenseTypeId);
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
                        cmd.CommandText = "sp_HWMS_LicenseType_GetAll";

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
        public LicenseType Get(int Id)
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
                        cmd.CommandText = "Sp_HWMS_LicenseType_Get";
                        cmd.Parameters.AddWithValue("Id", Id);
                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }
                LicenseType _licenseType = new LicenseType();
                if (ds.Tables[0].Rows.Count > 0)
                {
                    DataRow dr = ds.Tables[0].Rows[0];
                    _licenseType.LicenseTypeId = Convert.ToInt32(dr["LicenseTypeId"]);
                    _licenseType.LicenseOfType = dr["LicenseType"].ToString();
                    _licenseType.WasteCategory = dr["WasteCategory"].ToString();
                    _licenseType.WasteType = dr["WasteType"].ToString();
                }
                if (ds.Tables[1] != null)
                {
                    if (ds.Tables[1].Rows.Count > 0)
                    {
                        List<LicCodeDes> _licCodeDes = new List<LicCodeDes>();

                        foreach (DataRow dr in ds.Tables[1].Rows)
                        {
                            LicCodeDes Des = new LicCodeDes();
                            Des.LicenseId = Convert.ToInt32( dr["LicenseId"].ToString());                            
                            Des.LicenseCode = dr["LicenseCode"].ToString();
                            Des.LicenseDescription = dr["LicenseDescription"].ToString();
                            Des.IssuingBody = dr["IssuingBody"].ToString();
                            _licCodeDes.Add(Des);
                        }
                        _licenseType.licenseCodeList = _licCodeDes;
                    }
                }
                if (ds.Tables[2].Rows.Count > 0)
                {
                    List<Attachment> _attachmentList = new List<Attachment>();

                    foreach (DataRow dr in ds.Tables[2].Rows)
                    {
                        Attachment obj = new Attachment();

                        obj.AttachmentId = Convert.ToInt32(dr["AttachmentId"]);
                        obj.FileType = dr["FileType"].ToString();
                        obj.FileName = dr["FileName"].ToString();
                        obj.AttachmentName = dr["AttachmentName"].ToString();
                        obj.FilePath = dr["FilePath"].ToString();
                        _attachmentList.Add(obj);

                    }
                    _licenseType.AttachmentList = _attachmentList;
                }

                Log4NetLogger.LogExit(_FileName, nameof(Get), Level.Info.ToString());
                return _licenseType;

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

        public LicenseTypeeDropdown Load()
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                LicenseTypeeDropdown licenseTypeeDropdown = new LicenseTypeeDropdown();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        var da = new SqlDataAdapter();
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "Sp_HWMS_LicenseType_Load";
                        cmd.Parameters.Clear();
                        cmd.Parameters.AddWithValue("@pScreenName", "LicenseType");
                        //cmd.Parameters.AddWithValue("@pScreenName", "LicenseType");
                        da.SelectCommand = cmd;
                        da.Fill(ds);

                        if (ds.Tables[0] != null)
                        {
                            licenseTypeeDropdown.LicenseTypeeLovs = dbAccessDAL.GetLovRecords(ds.Tables[0]);
                        }
                        if (ds.Tables[1] != null)
                        {
                            licenseTypeeDropdown.IssuingBodyLovs = dbAccessDAL.GetLovRecords(ds.Tables[1]);
                        }
                        if (ds.Tables[2] != null)
                        {
                            licenseTypeeDropdown.WasteTypeLovs = dbAccessDAL.GetLovRecords(ds.Tables[2]);
                        }
                        if (ds.Tables[3] != null)
                        {
                            licenseTypeeDropdown.WasteCategoryLovs = dbAccessDAL.GetLovRecords(ds.Tables[3]);
                        }

                    }
                }
                Log4NetLogger.LogExit(_FileName, nameof(Load), Level.Info.ToString());
                return licenseTypeeDropdown;
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
