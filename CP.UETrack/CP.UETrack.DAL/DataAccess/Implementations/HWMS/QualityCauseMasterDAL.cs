using CP.UETrack.DAL.DataAccess.Contracts.HWMS;
using CP.UETrack.Model;
using CP.UETrack.Model.HWMS;
using System.Data;
using System.Data.SqlClient;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using UETrack.DAL;
using CP.UETrack.DAL.DataAccess.Implementation;
using CP.UETrack.DAL.DataAccess.Contracts.HWMS;
using CP.Framework.Common.Logging;
using CP.Framework.Common.ExceptionHandler.ExceptionWrappers;

namespace CP.UETrack.DAL.DataAccess.Implementations.HWMS
{
    public class QualityCauseMasterDAL : IQualityCauseMasterDAL
    {
        private readonly string _FileName = nameof(QualityCauseMasterDAL);
        readonly UserDetailsModel _UserSession = new SessionHelper().UserSession();

        public QualityCauseMasterDropdown Load()
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();

                QualityCauseMasterDropdown qualityCauseMasterDropdown = new QualityCauseMasterDropdown();

                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        var da = new SqlDataAdapter();
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "sp_HWMS_QualityCauseMaster_Load";
                        cmd.Parameters.Clear();
                        cmd.Parameters.AddWithValue("@pScreenName", "QualityCauseMaster");

                        da.SelectCommand = cmd;
                        da.Fill(ds);

                        if (ds.Tables[0] != null)
                        {
                            qualityCauseMasterDropdown.FailureTypeLovs = dbAccessDAL.GetLovRecords(ds.Tables[0]);
                        }
                        if (ds.Tables[1] != null)
                        {
                            qualityCauseMasterDropdown.StatusLovs = dbAccessDAL.GetLovRecords(ds.Tables[1]);
                        }
                    }
                }
                Log4NetLogger.LogExit(_FileName, nameof(Load), Level.Info.ToString());
                return qualityCauseMasterDropdown;
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
        public QualityCauseMaster Save(QualityCauseMaster model, out string ErrorMessage)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());
                ErrorMessage = string.Empty;
                var spName = string.Empty;

                var ds = new DataSet();
                var ds1 = new DataSet();
                var dbAccessDAL = new DBAccessDAL();

                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "SP_HWMS_QualityCauseMaster_Save";
                        cmd.Parameters.AddWithValue("@QualityCauseMasterId", model.QualityCauseMasterId);
                        cmd.Parameters.AddWithValue("@CustomerId", model.CustomerId);
                        cmd.Parameters.AddWithValue("@FacilityId", model.FacilityId);
                        cmd.Parameters.AddWithValue("@FailureSymptomCode", model.FailureSymptomCode);
                        cmd.Parameters.AddWithValue("@Description", model.Description);

                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }

                if (ds.Tables.Count != 0)
                {
                    model.QualityCauseMasterId = Convert.ToInt32(ds.Tables[0].Rows[0][0]);

                    if (model.QualityCauseMasterId == -1)
                    {
                        ErrorMessage = "FailureSymptomCode already exists";
                    }
                    else
                    {                        
                        using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                        {
                            using (SqlCommand cmd = new SqlCommand())
                            {
                                cmd.Connection = con;
                                cmd.CommandType = CommandType.StoredProcedure;
                                cmd.Parameters.Clear();                                

                                cmd.CommandText = "sp_HWMS_QualityCauseMaster_Save_Failure";
                                foreach (var Quality in model.FailureList)
                                {
                                    cmd.Parameters.AddWithValue("@QualityCauseMasterId", model.QualityCauseMasterId);
                                    cmd.Parameters.AddWithValue("@QualityId", Quality.QualityId);
                                    cmd.Parameters.AddWithValue("@FailureType", Quality.FailureType);
                                    cmd.Parameters.AddWithValue("@FailureRootCauseCode", Quality.FailureRootCauseCode);
                                    cmd.Parameters.AddWithValue("@Details", Quality.Details);
                                    cmd.Parameters.AddWithValue("@Status", Quality.Status);
                                    cmd.Parameters.AddWithValue("@isDeleted", Quality.isDeleted);

                                    var da1 = new SqlDataAdapter();
                                    da1.SelectCommand = cmd;
                                    da1.Fill(ds1);
                                    cmd.Parameters.Clear();

                                    if (ds1.Tables[0].Rows.Count > 0)
                                    {
                                        foreach (DataRow dr in ds1.Tables[0].Rows)
                                        {
                                            if (Convert.ToInt32(dr[0]) == -1)
                                            {
                                                ErrorMessage = "FailureRootCauseCode already exists";
                                            }
                                        }
                                    }
                                }
                            }
                        }
                    }
                }
                Log4NetLogger.LogExit(_FileName, nameof(Save), Level.Info.ToString());
                return Get(model.QualityCauseMasterId);
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
                        cmd.CommandText = "sp_HWMS_QualityCauseMaster_GetAll";

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
        public QualityCauseMaster Get(int Id)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
                QualityCauseMaster objQCM = null;
                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "Sp_HWMS_QualityCauseMaster_Get";
                        cmd.Parameters.AddWithValue("Id", Id);
                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }
                if (ds.Tables.Count != 0)
                {
                    objQCM = new QualityCauseMaster();

                    if (ds.Tables[0].Rows.Count > 0)
                    {
                        objQCM.QualityCauseMasterId = Convert.ToInt32(ds.Tables[0].Rows[0]["QualityCauseMasterId"]);
                        objQCM.FailureSymptomCode = Convert.ToString(ds.Tables[0].Rows[0]["FailureSymptomCode"]);
                        objQCM.Description = Convert.ToString(ds.Tables[0].Rows[0]["Description"]);

                        List<QualityCauseMasterFailure> lstobjQCMF = new List<QualityCauseMasterFailure>();

                        foreach (DataRow dr in ds.Tables[1].Rows)
                        {
                            QualityCauseMasterFailure objQCMF = new QualityCauseMasterFailure();

                            objQCMF.QualityId = Convert.ToInt32(dr["QualityId"]);
                            objQCMF.FailureType = Convert.ToString(dr["FailureType"]);
                            objQCMF.FailureRootCauseCode = Convert.ToString(dr["FailureRootCauseCode"]);
                            objQCMF.Details = Convert.ToString(dr["Details"]);
                            objQCMF.Status = Convert.ToInt32(dr["Status"]);

                            lstobjQCMF.Add(objQCMF);
                        }

                        objQCM.FailureList = lstobjQCMF;
                    }
                }
                Log4NetLogger.LogExit(_FileName, nameof(Get), Level.Info.ToString());
                return objQCM;
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
