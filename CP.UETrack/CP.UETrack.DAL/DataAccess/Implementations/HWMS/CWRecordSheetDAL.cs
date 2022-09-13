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
using CP.UETrack.Model.Common;

namespace CP.UETrack.DAL.DataAccess.Implementations.HWMS
{
   public class CWRecordSheetDAL:ICWRecordSheetDAL
    {
        private readonly string _FileName = nameof(CWRecordSheetDAL);
        readonly UserDetailsModel _UserSession = new SessionHelper().UserSession();
        public CWRecordSheetCollectionDetailsDropdown Load()
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();

                CWRecordSheetCollectionDetailsDropdown CWRecordSheetCollectionDetailDropdown = new CWRecordSheetCollectionDetailsDropdown();

                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        var da = new SqlDataAdapter();
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "Sp_HWMS_CWRecordSheetCollectionDetails_Dropdown";
                        cmd.Parameters.Clear();
                        cmd.Parameters.AddWithValue("@pScreenName", "CWRecordSheet");

                        da.SelectCommand = cmd;
                        da.Fill(ds);

                        if (ds.Tables[0] != null)
                        {
                            CWRecordSheetCollectionDetailDropdown.CollectionStatusLovs = dbAccessDAL.GetLovRecords(ds.Tables[0]);
                        }
                        if (ds.Tables[2] != null)
                        {
                            CWRecordSheetCollectionDetailDropdown.qualitycausecodeLovs = dbAccessDAL.GetLovRecords(ds.Tables[2]);
                        }
                        if (ds.Tables[1] != null)
                        {
                            CWRecordSheetCollectionDetailDropdown.SanitizeLovs = dbAccessDAL.GetLovRecords(ds.Tables[1]);
                        }
                    }
                }

                Log4NetLogger.LogExit(_FileName, nameof(Load), Level.Info.ToString());
                return CWRecordSheetCollectionDetailDropdown;
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

        public CWRecordSheet CollectionDetailsFetch(int Id)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(CollectionDetailsFetch), Level.Info.ToString());
                CWRecordSheet CWRecordSheet = new CWRecordSheet();                
                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "Sp_HWMS_CWRecordSheet_Fetch";  // Sp_HWMS_CWRecordSheet_Fetch
                        cmd.Parameters.AddWithValue("@pCWRecordSheetId", Id);
                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }
                
                if (ds.Tables[0] != null)
                {
                    if (ds.Tables[0].Rows.Count > 0)
                    {
                        List<CWRecordSheetCollectionDetails> CollectionDetails = new List<CWRecordSheetCollectionDetails>();
                        foreach (DataRow dr in ds.Tables[0].Rows)
                        {
                            CWRecordSheetCollectionDetails Details = new CWRecordSheetCollectionDetails();

                            Details.CollectionDetailsId = Convert.ToInt32(dr["CollectionDetailsId"].ToString());
                            Details.UserAreaCode = dr["UserAreaCode"].ToString();
                            Details.CollectionFrequency = dr["CollectionFrequency"].ToString();
                            Details.FrequencyType = dr["FrequencyType"].ToString();
                            Details.CollectionTime = dr["CollectionTime"].ToString();
                            Details.CollectionStatus = dr["CollectionStatus"].ToString();
                            Details.QC = dr["QC"].ToString();
                            Details.NoofBags = Convert.ToInt32(dr["NoofBags"].ToString());
                            Details.NoofReceptaclesOnsite = Convert.ToInt32(dr["NoofReceptaclesOnsite"].ToString());
                            Details.NoofReceptacleSanitize = Convert.ToInt32(dr["NoofReceptacleSanitize"].ToString());
                            Details.Sanitize = dr["Sanitize"].ToString();


                            CollectionDetails.Add(Details);
                        }

                        CWRecordSheet.CWRecordSheetCollectionDetailsList = CollectionDetails;
                    }
                }
               
                Log4NetLogger.LogExit(_FileName, nameof(CollectionDetailsFetch), Level.Info.ToString());
                return CWRecordSheet;
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

        public CWRecordSheet Save(CWRecordSheet model, out string ErrorMessage)
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
                        cmd.CommandText = "SP_HWMS_CWRecordSheet_Save";

                        cmd.Parameters.AddWithValue("@CWRecordSheetId", model.CWRecordSheetId);
                        cmd.Parameters.AddWithValue("@CustomerId", model.CustomerId);
                        cmd.Parameters.AddWithValue("@FacilityId", model.FacilityId);
                        cmd.Parameters.AddWithValue("@Date", model.Date);
                        cmd.Parameters.AddWithValue("@TotalUserArea", model.TotalUserArea);
                        cmd.Parameters.AddWithValue("@TotalBagCollected", model.TotalBagCollected);
                        cmd.Parameters.AddWithValue("@TotalSanitized", model.TotalSanitized);
                        
                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);

                        if (ds.Tables.Count != 0)
                        {
                            if (ds.Tables[0].Rows[0][0].ToString() == "-1")
                            {                                
                                ErrorMessage = "CWRS record already added/exist for the selected date ";
                            }
                            else
                            {
                                model.CWRecordSheetId = Convert.ToInt32(ds.Tables[0].Rows[0]["CWRecordSheetId"]);
                                var ds1 = new DataSet();
                                cmd.CommandText = "Sp_HWMS_CWRS_CollectionDetails_Save";

                                foreach (var Collection in model.CWRecordSheetCollectionDetailsList)
                                {
                                    cmd.Parameters.Clear();
                                    cmd.Parameters.AddWithValue("@CollectionDetailsId", Collection.CollectionDetailsId);
                                    cmd.Parameters.AddWithValue("@UserAreaCode", Collection.UserAreaCode);
                                    cmd.Parameters.AddWithValue("@CollectionFequency", Collection.CollectionFrequency);
                                    cmd.Parameters.AddWithValue("@FrequencyType", Collection.FrequencyType);
                                    cmd.Parameters.AddWithValue("@CollectionTime", Collection.CollectionTime);
                                    cmd.Parameters.AddWithValue("@CollectionStatus", Collection.CollectionStatus);
                                    cmd.Parameters.AddWithValue("@QC", Collection.QC);
                                    cmd.Parameters.AddWithValue("@NoofBags", Collection.NoofBags);
                                    cmd.Parameters.AddWithValue("@NoofReceptaclesOnsite", Collection.NoofReceptaclesOnsite);
                                    cmd.Parameters.AddWithValue("@NoofReceptacleSanitize", Collection.NoofReceptacleSanitize);
                                    cmd.Parameters.AddWithValue("@Sanitize", Collection.Sanitize);
                                    cmd.Parameters.AddWithValue("@CWRecordSheetId", model.CWRecordSheetId);
                                    cmd.Parameters.AddWithValue("@isDeleted", Collection.isDeleted);

                                    da.SelectCommand = cmd;
                                    da.Fill(ds1);
                                    cmd.Parameters.Clear();

                                }
                                model = Get(model.CWRecordSheetId);
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
                        cmd.CommandText = "Sp_HWMS_CWRecordSheet_GetAll";

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

        public CWRecordSheet Get(int Id)
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
                        cmd.CommandText = "Sp_HWMS_CWRecordSheet_Get";
                        cmd.Parameters.AddWithValue("Id", Id);
                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }
                CWRecordSheet _CWRecordSheet = new CWRecordSheet();
                if (ds.Tables[0].Rows.Count > 0)
                {
                    DataRow dr = ds.Tables[0].Rows[0];

                    _CWRecordSheet.CWRecordSheetId =Convert.ToInt32( dr["CWRecordSheetId"].ToString());
                    _CWRecordSheet.Date =Convert.ToDateTime( dr["Date"].ToString());
                    _CWRecordSheet.TotalUserArea =Convert.ToInt32( dr["TotalUserArea"].ToString());
                    _CWRecordSheet.TotalBagCollected =Convert.ToInt32( dr["TotalBagCollected"].ToString());
                    _CWRecordSheet.TotalSanitized =Convert.ToInt32( dr["TotalSanitized"].ToString());
                   
                }
                if (ds.Tables[1] != null)
                {
                    if (ds.Tables[1].Rows.Count > 0)
                    {
                        List<CWRecordSheetCollectionDetails> _CWRecordSheetCollectionDetails = new List<CWRecordSheetCollectionDetails>();
                        foreach (DataRow dr in ds.Tables[1].Rows)
                        {
                            CWRecordSheetCollectionDetails CollectionDetails = new CWRecordSheetCollectionDetails();
                            
                            CollectionDetails.CollectionDetailsId =Convert.ToInt32( dr["CollectionDetailsId"].ToString());
                            CollectionDetails.UserAreaCode = dr["UserAreaCode"].ToString();
                            CollectionDetails.FrequencyType = dr["FrequencyType"].ToString();
                            CollectionDetails.CollectionFrequency = dr["CollectionFrequency"].ToString();                           
                            CollectionDetails.CollectionTime =dr["CollectionTime"].ToString();
                            CollectionDetails.CollectionStatus = dr["CollectionStatus"].ToString();
                            CollectionDetails.QC = dr["QC"].ToString();
                            CollectionDetails.NoofBags = Convert.ToInt32(dr["NoofBags"].ToString());
                            CollectionDetails.NoofReceptaclesOnsite =Convert.ToInt32( dr["NoofReceptaclesOnsite"].ToString());
                            CollectionDetails.NoofReceptacleSanitize =Convert.ToInt32( dr["NoofReceptacleSanitize"].ToString());
                            CollectionDetails.Sanitize = dr["Sanitize"].ToString();

                            _CWRecordSheetCollectionDetails.Add(CollectionDetails);
                        }
                        _CWRecordSheet.CWRecordSheetCollectionDetailsList = _CWRecordSheetCollectionDetails;
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
                    _CWRecordSheet.AttachmentList = _attachmentList;
                }

                Log4NetLogger.LogExit(_FileName, nameof(Get), Level.Info.ToString());
                return _CWRecordSheet;
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
     
        public CWRecordSheetCollectionDetails CollectionTimeDetails(CWRecordSheetCollectionDetails model, out string ErrorMessage)
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
                        cmd.CommandText = "Sp_HWMS_CWRecordSheet_CollectionTimeDetails";

                        cmd.Parameters.AddWithValue("@CollectionTime", model.CollectionTime);
                        cmd.Parameters.AddWithValue("@UserAreaCode", model.UserAreaCode);
                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);

                        if (ds.Tables.Count != 0)
                        {
                            
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

    }
}
