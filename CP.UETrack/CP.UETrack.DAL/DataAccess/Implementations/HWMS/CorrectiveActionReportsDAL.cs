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
   public class CorrectiveActionReportsDAL:ICorrectiveActionReportsDAL
    {
        private readonly string _FileName = nameof(BlockDAL);
        readonly UserDetailsModel _UserSession = new SessionHelper().UserSession();

        public CorrectiveActionReportsDAL()
        {

        }
        public CorrectiveActionReports Save(CorrectiveActionReports model, out string ErrorMessage)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());
                ErrorMessage = string.Empty;
                var spName = string.Empty;


                var ds = new DataSet();
                var ds1 = new DataSet();
                var da = new SqlDataAdapter();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "Sp_HWMS_CorrectiveActionReport_Save";

                        cmd.Parameters.AddWithValue("@CARId", model.CARId);
                        cmd.Parameters.AddWithValue("@Customerid", model.CustomerId);
                        cmd.Parameters.AddWithValue("@Facilityid", model.FacilityId);
                        cmd.Parameters.AddWithValue("@CARGeneration", model.CARGeneration);
                        cmd.Parameters.AddWithValue("@CARNo", model.CARNo);
                        cmd.Parameters.AddWithValue("@Indicator", model.Indicator);
                        cmd.Parameters.AddWithValue("@CARDate", model.CARDate);
                        cmd.Parameters.AddWithValue("@CARPeriodFrom", model.CARPeriodFrom);
                        cmd.Parameters.AddWithValue("@CARPeriodTo", model.CARPeriodTo);
                        cmd.Parameters.AddWithValue("@FollowUpCAR", model.FollowUpCAR);
                        cmd.Parameters.AddWithValue("@Assignee", model.Assignee);
                        cmd.Parameters.AddWithValue("@ProblemStatement", model.ProblemStatement);
                        cmd.Parameters.AddWithValue("@RootCause", model.RootCause);
                        cmd.Parameters.AddWithValue("@Solution", model.Solution);
                        cmd.Parameters.AddWithValue("@Priority", model.Priority);
                        cmd.Parameters.AddWithValue("@Status", model.Status);
                        cmd.Parameters.AddWithValue("@Issuer", model.Issuer);
                        cmd.Parameters.AddWithValue("@CARTargetDate", model.CARTargetDate);
                        cmd.Parameters.AddWithValue("@VerifiedDate", model.VerifiedDate);
                        cmd.Parameters.AddWithValue("@VerifiedBy", model.VerifiedBy);
                        cmd.Parameters.AddWithValue("@Remarks", model.Remarks);
                      
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }
               
                if (ds.Tables.Count != 0)
                {                  
                        model.CARId = Convert.ToInt32(ds.Tables[0].Rows[0]["CARId"]);
                        using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                        {
                            using (SqlCommand cmd = new SqlCommand())
                            {
                                cmd.Connection = con;
                                cmd.CommandType = CommandType.StoredProcedure;
                                cmd.Parameters.Clear();                             
                                cmd.CommandText = "Sp_HWMS_CorrectiveActionReport_CARDetails_Save";
                                foreach (var CAR in model.CARActivityList)
                                {
                                    cmd.Parameters.Clear();
                                    cmd.Parameters.AddWithValue("@CARActivityId", CAR.CARActivityId);
                                    cmd.Parameters.AddWithValue("@Activity", CAR.Activity);
                                    cmd.Parameters.AddWithValue("@StartDate", CAR.StartDate);
                                    cmd.Parameters.AddWithValue("@TargetDate", CAR.TargetDate);
                                    cmd.Parameters.AddWithValue("@ActualCompletionDate", CAR.ActualCompletionDate);
                                    cmd.Parameters.AddWithValue("@Responsibility", CAR.Responsibility);
                                    cmd.Parameters.AddWithValue("@ResponsiblePerson", CAR.ResponsiblePerson);
                                    cmd.Parameters.AddWithValue("@CARId", model.CARId);
                                    cmd.Parameters.AddWithValue("@IsDeleted", CAR.isDeleted);

                                da.SelectCommand = cmd;
                                da.Fill(ds1);

                                }
                            model = Get(model.CARId);

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

        public CorrectiveActionReports AutoGeneratedCode()
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(AutoGeneratedCode), Level.Info.ToString());
                CorrectiveActionReports correctiveActionReports = new CorrectiveActionReports();

                var ds = new DataSet();

                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "Sp_HWMS_DocumentNo_AutoGenerated";
                        cmd.Parameters.AddWithValue("@pScreenName", "CAR");
                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }

                if (ds.Tables.Count != 0)
                {
                    correctiveActionReports = (from n in ds.Tables[0].AsEnumerable()
                                     select new CorrectiveActionReports
                                     {
                                         CARNo = Convert.ToString(n["CARNo"])
                                     }).FirstOrDefault();
                }
                //if (ds.Tables[1].Rows.Count > 0)
                //{
                //    List<CorrectiveActionReports> CorrectiveActionReportList = new List<CorrectiveActionReports>();
                //    foreach (DataRow dr in ds.Tables[1].Rows)
                //    {
                //        CorrectiveActionReports Corrective = new CorrectiveActionReports();
                //        Corrective.Indicator = dr["IndicatorNo"].ToString();
                //        CorrectiveActionReportList.Add(Corrective);
                //    }
                //    correctiveActionReports.AutoDisplay = CorrectiveActionReportList;
                //}


                Log4NetLogger.LogExit(_FileName, nameof(AutoGeneratedCode), Level.Info.ToString());
                return correctiveActionReports;
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


        public List<CARAttachment> AttachmentSave(CorrectiveActionReports model, out string ErrorMessage)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(AttachmentSave), Level.Info.ToString());
                ErrorMessage = string.Empty;
                var spName = string.Empty;

                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();

                List<CARAttachment> _lstCARAttachments = new List<CARAttachment>();

                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "SP_HWMS_CARAttachment_Save";

                        foreach (var att in model.CARAttachmentList)
                        {
                            cmd.Parameters.AddWithValue("@AttachmentId", att.AttachmentId);
                            cmd.Parameters.AddWithValue("@CARId", model.CARId);
                            cmd.Parameters.AddWithValue("@FileType", att.FileType);
                            cmd.Parameters.AddWithValue("@FileName", att.FileName);
                            cmd.Parameters.AddWithValue("@AttachmentName", att.AttachmentName);
                            cmd.Parameters.AddWithValue("@FilePath", att.FilePath);
                            cmd.Parameters.AddWithValue("@isDeleted", att.isDeleted);

                            var da = new SqlDataAdapter();
                            da.SelectCommand = cmd;
                            da.Fill(ds);
                            cmd.Parameters.Clear();

                        }
                    }
                }

                Log4NetLogger.LogExit(_FileName, nameof(AttachmentSave), Level.Info.ToString());
                return Get(model.CARId).CARAttachmentList;
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

        public List<CorrectiveActionReports> FollowUpCARNoFetch(CorrectiveActionReports searchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(FollowUpCARNoFetch), Level.Info.ToString());
                List<CorrectiveActionReports> result = null;
                var pageIndex = searchObject.PageIndex;
                var pageSize = Convert.ToInt32(ConfigurationManager.AppSettings["FetchPopupPageSize"]);
                var dbAccessDAL = new DBAccessDAL();
                var obj = new CorrectiveActionReport();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@CARNo", searchObject.CARNo ?? "");
                parameters.Add("@pPageIndex", Convert.ToString(pageIndex));
                parameters.Add("@pPageSize", Convert.ToString(pageSize));
                parameters.Add("@pFacilityId", _UserSession.FacilityId.ToString());
                DataTable dt = dbAccessDAL.GetDataTable("Sp_HWMS_FollowUpCARNoFetch", parameters, DataSetparameters);
                if (dt != null && dt.Rows.Count > 0)
                {
                    var totalRecords = Convert.ToInt32(dt.Rows[0]["TotalRecords"]);
                    var firstRecord = (pageIndex - 1) * pageSize + 1;
                    var lastRecord = (pageIndex - 1) * pageSize + dt.Rows.Count;
                    var lastPageIndex = totalRecords % pageSize == 0 ? totalRecords / pageSize : (totalRecords / pageSize) + 1;

                    result = (from n in dt.AsEnumerable()
                              select new CorrectiveActionReports
                              {
                                  CARId = Convert.ToInt32(n["CARId"].ToString()),
                                  CARNo = Convert.ToString(n["CARNo"]),
                                  TotalRecords = totalRecords,
                                  FirstRecord = firstRecord,
                                  LastRecord = lastRecord,
                                  LastPageIndex = lastPageIndex
                              }).ToList();
                }
                Log4NetLogger.LogExit(_FileName, nameof(FollowUpCARNoFetch), Level.Info.ToString());
                return result;
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
                        cmd.CommandText = "Sp_HWMS_CorrectiveActionReport_GetAll";

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

        public CorrectiveActionReports Get(int Id)
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
                        cmd.CommandText = "Sp_HWMS_CorrectiveActionReport_Get";
                        cmd.Parameters.AddWithValue("@CARId", Id);
                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }

                CorrectiveActionReports _correctiveActionReport = new CorrectiveActionReports();

                if (ds.Tables[0].Rows.Count > 0)
                {
                    DataRow dr = ds.Tables[0].Rows[0];

                    _correctiveActionReport.CARId = Convert.ToInt32(dr["CARId"]);
                    _correctiveActionReport.CARGeneration = dr["CARGeneration"].ToString();
                    _correctiveActionReport.CARNo = dr["CARNo"].ToString();
                    _correctiveActionReport.Indicator = dr["Indicator"].ToString();
                    if (dr["CARDate"] != System.DBNull.Value)
                        _correctiveActionReport.CARDate = Convert.ToDateTime(dr["CARDate"].ToString());

                    if (dr["CARPeriodFrom"] != System.DBNull.Value)
                        _correctiveActionReport.CARPeriodFrom = Convert.ToDateTime(dr["CARPeriodFrom"]);
                    if (dr["CARPeriodTo"] != System.DBNull.Value)
                        _correctiveActionReport.CARPeriodTo = Convert.ToDateTime(dr["CARPeriodTo"]);
                    _correctiveActionReport.FollowUpCAR = dr["FollowUpCAR"].ToString();
                    _correctiveActionReport.Assignee = dr["Assignee"].ToString();
                    _correctiveActionReport.ProblemStatement = dr["ProblemStatement"].ToString();

                    _correctiveActionReport.RootCause = dr["RootCause"].ToString();
                    _correctiveActionReport.Solution = dr["Solution"].ToString();
                    _correctiveActionReport.Priority = dr["Priority"].ToString();
                    _correctiveActionReport.Status = dr["Status"].ToString();
                    _correctiveActionReport.Issuer = dr["Issuer"].ToString();
                    if (dr["CARTargetDate"] != System.DBNull.Value)
                        _correctiveActionReport.CARTargetDate = Convert.ToDateTime(dr["CARTargetDate"]);
                    if (dr["VerifiedDate"] != System.DBNull.Value)
                        _correctiveActionReport.VerifiedDate = Convert.ToDateTime(dr["VerifiedDate"]);
                    _correctiveActionReport.VerifiedBy = dr["VerifiedBy"].ToString();
                    _correctiveActionReport.Remarks = dr["Remarks"].ToString();

                }

                if (ds.Tables[1].Rows.Count > 0)
                {
                    List<CARActivity> _CarActivityList = new List<CARActivity>();

                    foreach (DataRow dr in ds.Tables[1].Rows)
                    {
                        CARActivity Auto = new CARActivity();
                        Auto.CARActivityId = Convert.ToInt32(dr["CARDetailsId"]);
                        Auto.Activity = dr["Activity"].ToString();
                        Auto.StartDate = Convert.ToDateTime(dr["StartDate"]);
                        if (dr["TargetDate"] != System.DBNull.Value)
                            Auto.TargetDate = Convert.ToDateTime(dr["TargetDate"]);
                        if (dr["ActualCompletionDate"] != System.DBNull.Value)
                            Auto.ActualCompletionDate = Convert.ToDateTime(dr["ActualCompletionDate"]);
                        Auto.Responsibility = dr["Responsibility"].ToString();
                        Auto.ResponsiblePerson = dr["ResponsiblePerson"].ToString();

                        _CarActivityList.Add(Auto);
                    }
                    _correctiveActionReport.CARActivityList = _CarActivityList;
                }

                if (ds.Tables[2].Rows.Count > 0)
                {
                    List<CARAttachment> _carAttachmentList = new List<CARAttachment>();

                    foreach (DataRow dr in ds.Tables[2].Rows)
                    {
                        CARAttachment obj = new CARAttachment();

                        obj.AttachmentId = Convert.ToInt32(dr["AttachmentId"]);
                        obj.FileType = dr["FileType"].ToString();
                        obj.FileName = dr["FileName"].ToString();
                        obj.AttachmentName = dr["AttachmentName"].ToString();
                        obj.FilePath = dr["FilePath"].ToString();
                        _carAttachmentList.Add(obj);

                    }
                    _correctiveActionReport.CARAttachmentList = _carAttachmentList;
                }

                Log4NetLogger.LogExit(_FileName, nameof(Get), Level.Info.ToString());
                return _correctiveActionReport;
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
