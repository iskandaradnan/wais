using CP.Framework.Common.ExceptionHandler.ExceptionWrappers;
using CP.Framework.Common.Logging;
using CP.UETrack.DAL.DataAccess.Contracts.CLS;
using CP.UETrack.DAL.DataAccess.Implementation;
using CP.UETrack.Model;
using CP.UETrack.Model.CLS;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using UETrack.DAL;

namespace CP.UETrack.DAL.DataAccess.Implementations.CLS
{
    public class JIDetailsDAL : IJIDetailsDAL
    {
        private readonly string _FileName = nameof(JIDetailsDAL);
        readonly UserDetailsModel _UserSession = new SessionHelper().UserSession();

        public JIDetailsDAL()
        {
        }
        public JIDetailsListDropdown Load()
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();

                JIDetailsListDropdown jiDropdown = new JIDetailsListDropdown();

                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        var da = new SqlDataAdapter();
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "sp_CLS_JIDetails_Load";
                        cmd.Parameters.Clear();
                        cmd.Parameters.AddWithValue("@pScreenName", "JIDetails");

                        da.SelectCommand = cmd;
                        da.Fill(ds);
                        
                        if (ds.Tables[0] != null)
                        {
                            jiDropdown.DropDownLovs = dbAccessDAL.GetLovRecords(ds.Tables[0]);
                        }
                        if (ds.Tables[1] != null)
                        {
                            jiDropdown.FileTypeValues = dbAccessDAL.GetLovRecords(ds.Tables[1]);
                        }

                    }
                }

                Log4NetLogger.LogExit(_FileName, nameof(Load), Level.Info.ToString());
                return jiDropdown;
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
        public JIDetails Save(JIDetails model, out string ErrorMessage)
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
                        cmd.CommandText = "Sp_CLS_Jidetails_Save";

                        cmd.Parameters.AddWithValue("@pDetailsId", model.DetailsId);
                        cmd.Parameters.AddWithValue("@pCustomerid", model.CustomerId);
                        cmd.Parameters.AddWithValue("@pFacilityid", model.FacilityId);
                        cmd.Parameters.AddWithValue("@pJIDocumentNo", model.DocumentNo);
                        cmd.Parameters.AddWithValue("@pJIDateTime", model.DateandTime);
                        cmd.Parameters.AddWithValue("@pUserAreaCode", model.UserAreaCode);
                        cmd.Parameters.AddWithValue("@pUserAreaName", model.UserAreaName);
                        cmd.Parameters.AddWithValue("@pHospitalRepresentative", model.HospitalRepresentative);
                        cmd.Parameters.AddWithValue("@pHospitalRepresentativeDesignation", model.HospitalRepresentativeDesignation);
                        cmd.Parameters.AddWithValue("@pCompanyRepresentative", model.CompanyRepresentative);
                        cmd.Parameters.AddWithValue("@pCompanyRepresentativeDesignation", model.CompanyRepresentativeDesignation);
                        cmd.Parameters.AddWithValue("@pRemarks", model.Remarks);
                        cmd.Parameters.AddWithValue("@pRefereceNo", model.ReferenceNo);
                        cmd.Parameters.AddWithValue("@pSatisfactory", model.Satisfactory);
                        cmd.Parameters.AddWithValue("@pNoOfUserLocations", model.NoofUserLocation);
                        cmd.Parameters.AddWithValue("@pUnSatisfactory", model.UnSatisfactory);
                        cmd.Parameters.AddWithValue("@pGrandTotal", model.GrandTotalElementsInspected);
                        cmd.Parameters.AddWithValue("@pNotApplicable", model.NotApplicable);

                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                        if (ds.Tables.Count != 0)
                        {

                            cmd.Parameters.Clear();
                            model.DetailsId = Convert.ToInt32(ds.Tables[0].Rows[0]["DetailsId"]);

                            if (model.DetailsId == -1)
                            {
                                ErrorMessage = "Joint inspection details already saved for " + model.DocumentNo;
                            }
                            else
                            {
                                var ds2 = new DataSet();
                                cmd.CommandText = "sp_CLS_JiDetails_LocationCode_Save";
                                foreach (var Location in model.LocationDetailsList)
                                {
                                    cmd.Parameters.AddWithValue("@pLocationCode", Location.LocationCode);
                                    cmd.Parameters.AddWithValue("@pLocationName", Location.LocationName);
                                    cmd.Parameters.AddWithValue("@pFloor", Location.Floor);
                                    cmd.Parameters.AddWithValue("@pWalls", Location.Walls);
                                    cmd.Parameters.AddWithValue("@pCeiling", Location.Ceiling);
                                    cmd.Parameters.AddWithValue("@pWindows", Location.WindowsandDoors);
                                    cmd.Parameters.AddWithValue("@pRC", Location.ReceptaclesandContainers);
                                    cmd.Parameters.AddWithValue("@pFFE", Location.FurnitureFixtureandEquipment);
                                    cmd.Parameters.AddWithValue("@pRemarks", Location.Remark);
                                    cmd.Parameters.AddWithValue("@pDetailsId", model.DetailsId);

                                    da.SelectCommand = cmd;
                                    da.Fill(ds2);
                                    cmd.Parameters.Clear();
                                }
                            }

                        }
                    }
                }

                model = Get(model.DetailsId);

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
        public JIDetails Submit(JIDetails model, out string ErrorMessage)
        {
            try
            {
                
                Log4NetLogger.LogEntry(_FileName, nameof(Submit), Level.Info.ToString());
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
                        cmd.CommandText = "sp_CLS_JiDetails_Submit";
                        cmd.Parameters.AddWithValue("@pIsSubmitted", model.IsSubmitted);
                        cmd.Parameters.AddWithValue("@pDetailsId", model.DetailsId);

                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                        cmd.Parameters.Clear();
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
      public List<JIDetailsAttachment> AttachmentSave(JIDetails model, out string ErrorMessage)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(AttachmentSave), Level.Info.ToString());
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
                        cmd.CommandText = "Sp_CLS_JIDetails_Attachment";

                        foreach (var use in model.lstJIDetailsAttachments)
                        {

                            cmd.Parameters.AddWithValue("@AttachmentId", use.JIAttachmentId);
                            cmd.Parameters.AddWithValue("@DetailsId", model.DetailsId);
                            cmd.Parameters.AddWithValue("@FileType", use.FileType);
                            cmd.Parameters.AddWithValue("@FileName", use.FileName);
                            cmd.Parameters.AddWithValue("@AttachmentName", use.AttachmentName);
                            cmd.Parameters.AddWithValue("@FilePath", use.FilePath);
                            cmd.Parameters.AddWithValue("@isDeleted", use.isDeleted);
                           
                            var da = new SqlDataAdapter();
                            da.SelectCommand = cmd;
                            da.Fill(ds);
                            cmd.Parameters.Clear();

                        }
                    }
                }

                Log4NetLogger.LogExit(_FileName, nameof(AttachmentSave), Level.Info.ToString());

                return Get(model.DetailsId).lstJIDetailsAttachments;
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
        public JIDetails LocationCodeFetch(JIDetails dat)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(LocationCodeFetch), Level.Info.ToString());
            try
            {
                var dbAccessDAL = new DBAccessDAL();
                JIDetails entity = new JIDetails();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pDocumentNo", dat.DocumentNo);
                DataSet dt = dbAccessDAL.GetDataSet("sp_CLS_JIDetails_LocationCode_Fetch", parameters, DataSetparameters);
                if (dt != null && dt.Tables.Count > 0)
                {
                    entity.LocationDetailsList = (from n in dt.Tables[0].AsEnumerable()
                                                  select new JIFetch
                                                  {
                                                      LocationCode = n.Field<string>("LocationCode"),
                                                      LocationName = n.Field<string>("LocationName"),
                                                      Floor = n.Field<string>("Floor"),
                                                      Walls = n.Field<string>("Walls"),
                                                      Ceiling = n.Field<string>("Ceiling"),
                                                      WindowsandDoors = n.Field<string>("WindowsDoors"),
                                                      ReceptaclesandContainers = n.Field<string>("ReceptaclesContainers"),
                                                      FurnitureFixtureandEquipment = n.Field<string>("FFEquipment"),
                                                      Remark = n.Field<string>("Remarks")
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
        public List<JISchedule> DocumentNoFetch(JISchedule searchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(DocumentNoFetch), Level.Info.ToString());
                List<JISchedule> result = null;
                var pageIndex = searchObject.PageIndex;
                var pageSize = Convert.ToInt32(ConfigurationManager.AppSettings["FetchPopupPageSize"]);
                var dbAccessDAL = new DBAccessDAL();
                var obj = new JISchedule();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pDocumentNo", searchObject.DocumentNo ?? "");
                parameters.Add("@pPageIndex", Convert.ToString(pageIndex));
                parameters.Add("@pPageSize", Convert.ToString(pageSize));
                parameters.Add("@pFacilityId", _UserSession.FacilityId.ToString());
                DataTable dt = dbAccessDAL.GetDataTable("sp_CLS_JIDetails_DocumentNo", parameters, DataSetparameters);
                if (dt != null && dt.Rows.Count > 0)
                {
                    var totalRecords = Convert.ToInt32(dt.Rows[0]["TotalRecords"]);
                    var firstRecord = (pageIndex - 1) * pageSize + 1;
                    var lastRecord = (pageIndex - 1) * pageSize + dt.Rows.Count;
                    var lastPageIndex = totalRecords % pageSize == 0 ? totalRecords / pageSize : (totalRecords / pageSize) + 1;

                    result = (from n in dt.AsEnumerable()
                              select new JISchedule
                              {
                                  ScheduleId = Convert.ToInt32(n["ScheduleId"]),
                                  DocumentNo = Convert.ToString(n["DocumentNo"]),
                                  UserAreaCode = Convert.ToString(n["UserAreaCode"]),
                                  UserAreaName = Convert.ToString(n["UserAreaName"]),
                                  
                                  TotalRecords = totalRecords,
                                  FirstRecord = firstRecord,
                                  LastRecord = lastRecord,
                                  LastPageIndex = lastPageIndex
                              }).ToList();
                }
                Log4NetLogger.LogExit(_FileName, nameof(DocumentNoFetch), Level.Info.ToString());
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
                        cmd.CommandText = "sp_CLS_JiDetails_GetAll";
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

        public JIDetails Get(int Id)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
                JIDetails ji = new JIDetails();
                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "Sp_CLS_JIDetails_Get";
                        cmd.Parameters.AddWithValue("Id", Id);
                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }
               // JIDetails _Jidetails = new JIDetails();
                if (ds.Tables[0].Rows.Count > 0)
                {
                    DataRow dr = ds.Tables[0].Rows[0];
                    ji.DetailsId = Id;
                    ji.DocumentNo = dr["DocumentNo"].ToString();
                    ji.DateandTime = Convert.ToDateTime(dr["DateTime"].ToString());
                    ji.UserAreaCode = dr["UserAreaCode"].ToString();
                    ji.UserAreaName = dr["UserAreaName"].ToString();
                    ji.HospitalRepresentative = dr["HospitalRepresentative"].ToString();
                    ji.HospitalRepresentativeDesignation = dr["HospitalRepresentativeDesignation"].ToString();
                    ji.CompanyRepresentative = dr["CompanyRepresentative"].ToString();
                    ji.CompanyRepresentativeDesignation = dr["CompanyRepresentativeDesignation"].ToString();
                    ji.Remarks = dr["Remarks"].ToString();
                    ji.ReferenceNo = dr["ReferenceNo"].ToString();
                    ji.Satisfactory = Convert.ToInt32(dr["Satisfactory"].ToString());
                    ji.NoofUserLocation = Convert.ToInt32(dr["NoofUserLocation"].ToString());
                    ji.UnSatisfactory = Convert.ToInt32(dr["UnSatisfactory"].ToString());
                    ji.GrandTotalElementsInspected = Convert.ToInt32(dr["GrandTotalElementsInspected"].ToString());
                    ji.NotApplicable = Convert.ToInt32(dr["NotApplicable"].ToString());
                    ji.IsSubmitted = Convert.ToInt16(dr["IsSubmitted"]);
                }
                if (ds.Tables[1] != null)
                {
                    if (ds.Tables[1].Rows.Count > 0)
                    {
                        List<JIFetch> _JIDetailsList = new List<JIFetch>();
                        foreach (DataRow dr in ds.Tables[1].Rows)
                        {

                            JIFetch Auto = new JIFetch();
                            Auto.LocationCode = dr["LocationCode"].ToString();
                            Auto.LocationName = dr["LocationName"].ToString();
                            Auto.Floor = dr["Floor"].ToString();
                            Auto.Walls = dr["Walls"].ToString();
                            Auto.Ceiling = dr["Ceiling"].ToString();
                            Auto.WindowsandDoors = dr["WindowsDoors"].ToString();
                            Auto.ReceptaclesandContainers = dr["ReceptaclesContainers"].ToString();
                            Auto.FurnitureFixtureandEquipment = dr["FFEquipment"].ToString();
                            Auto.Remark = dr["Remarks"].ToString();
                            _JIDetailsList.Add(Auto);

                        }
                        ji.LocationDetailsList = _JIDetailsList;
                    }
                }
                if (ds.Tables[2].Rows.Count > 0)
                {
                    List<JIDetailsAttachment> _JIDetailsAttachList = new List<JIDetailsAttachment>();

                    foreach (DataRow dr in ds.Tables[2].Rows)
                    {
                        JIDetailsAttachment obj = new JIDetailsAttachment();

                        obj.JIAttachmentId = Convert.ToInt32(dr["AttachmentId"]);
                        obj.FileType = dr["FileType"].ToString();
                        obj.FileName = dr["FileName"].ToString();
                        obj.AttachmentName = dr["AttachmentName"].ToString();
                        obj.FilePath = dr["FilePath"].ToString();
                        _JIDetailsAttachList.Add(obj);

                    }
                    ji.lstJIDetailsAttachments = _JIDetailsAttachList;
                }

                Log4NetLogger.LogExit(_FileName, nameof(Get), Level.Info.ToString());
                return ji;
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
