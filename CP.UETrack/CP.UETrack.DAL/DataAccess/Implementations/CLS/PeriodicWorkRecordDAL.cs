using CP.Framework.Common.ExceptionHandler.ExceptionWrappers;
using CP.Framework.Common.Logging;
using CP.UETrack.DAL.DataAccess.Contracts.CLS;
using CP.UETrack.DAL.DataAccess.Implementation;
using CP.UETrack.Model;
using CP.UETrack.Model.CLS;
using CP.UETrack.Model.Common;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using UETrack.DAL;

namespace CP.UETrack.DAL.DataAccess.Implementations.CLS
{
    public class PeriodicWorkRecordDAL : IPeriodicWorkRecordDAL
    {
        private readonly string _FileName = nameof(BlockDAL);
        readonly UserDetailsModel _UserSession = new SessionHelper().UserSession();
        public PeriodicWorkRecordDAL()
        {

        }

        public PeriodidcWorkRecordDropdown Load()
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();

                PeriodidcWorkRecordDropdown periodidcWorkRecordDropdown = new PeriodidcWorkRecordDropdown();

                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        var da = new SqlDataAdapter();
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "Sp_CLS_PeriodicWorkRecord_Dropdown";
                        cmd.Parameters.Clear();
                        cmd.Parameters.AddWithValue("@pScreenName", "PeriodicWorkRecord");

                        da.SelectCommand = cmd;
                        da.Fill(ds);


                        if (ds.Tables[0] != null)
                        {
                            periodidcWorkRecordDropdown.YearLov = dbAccessDAL.GetLovRecords(ds.Tables[0]);
                        }
                        if (ds.Tables[1] != null)
                        {
                            periodidcWorkRecordDropdown.MonthLov = dbAccessDAL.GetLovRecords(ds.Tables[1]);
                        }
                        if (ds.Tables[2] != null)
                        {
                            periodidcWorkRecordDropdown.StatusLov = dbAccessDAL.GetLovRecords(ds.Tables[2]);
                        }
                        
                    }
                }

                Log4NetLogger.LogExit(_FileName, nameof(Load), Level.Info.ToString());
                return periodidcWorkRecordDropdown;
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
                        cmd.CommandText = "SP_CLS_PeriodicWorkRecord_GetAll";

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

        public PeriodicWorkRecord Get(int Id)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
                PeriodicWorkRecord periodic = null;

                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "Sp_CLS_PeriodicWorkRecord_Get";
                        cmd.Parameters.AddWithValue("Id", Id);
                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }
                PeriodicWorkRecord _periodicWorkRecord = new PeriodicWorkRecord();
                if (ds.Tables[0].Rows.Count > 0)
                {
                    DataRow dr = ds.Tables[0].Rows[0];

                    _periodicWorkRecord.DocumentNo = dr["DocumentNo"].ToString();
                    _periodicWorkRecord.Year = Convert.ToInt32(dr["Year"].ToString());
                    _periodicWorkRecord.Month = dr["Month"].ToString();
                }
                if (ds.Tables[1] != null)
                {
                    if (ds.Tables[1].Rows.Count > 0)
                    {
                        List<UserAreaDetails> _userAreaDetailsList = new List<UserAreaDetails>();
                        foreach (DataRow dr in ds.Tables[1].Rows)
                        {
                            UserAreaDetails Auto = new UserAreaDetails();
                            Auto.UserAreaCode = dr["UserAreaCode"].ToString();
                            Auto.Status = Convert.ToInt32(dr["Status"].ToString());
                            Auto.ScopeofWorkA1 = dr["A1"].ToString();
                            Auto.ScopeofWorkA2 = dr["A2"].ToString();
                            Auto.ScopeofWorkA3 = dr["A3"].ToString();
                            Auto.ScopeofWorkA4 = dr["A4"].ToString();
                            Auto.ScopeofWorkA5 = dr["A5"].ToString();
                            Auto.ScopeofWorkA6 = dr["A6"].ToString();
                            Auto.ScopeofWorkA7 = dr["A7"].ToString();
                            Auto.ScopeofWorkA8 = dr["A8"].ToString();
                            Auto.ScopeofWorkA9 = dr["A9"].ToString();
                            Auto.ScopeofWorkA10 = dr["A10"].ToString();
                            Auto.ScopeofWorkA11 = dr["A11"].ToString();
                            Auto.ScopeofWorkA12 = dr["A12"].ToString();
                            Auto.ScopeofWorkA13 = dr["A13"].ToString();
                            Auto.ScopeofWorkA14 = dr["A14"].ToString();
                            Auto.ScopeofWorkA15 = dr["A15"].ToString();
                            Auto.ScopeofWorkA16 = dr["A16"].ToString();
                            Auto.ScopeofWorkA17 = dr["A17"].ToString();
                            Auto.ScopeofWorkA18 = dr["A18"].ToString();
                            Auto.ScopeofWorkA19 = dr["A19"].ToString();
                            Auto.ScopeofWorkA20 = dr["A20"].ToString();
                            Auto.ScopeofWorkA21 = dr["A21"].ToString();
                            Auto.ScopeofWorkA22 = dr["A22"].ToString();
                            Auto.ScopeofWorkA23 = dr["A23"].ToString();
                            Auto.ScopeofWorkA24 = dr["A24"].ToString();

                            _userAreaDetailsList.Add(Auto);
                        }
                        _periodicWorkRecord.UserAreaDetailsList = _userAreaDetailsList;
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
                    _periodicWorkRecord.AttachmentList = _attachmentList;
                }

                Log4NetLogger.LogExit(_FileName, nameof(Get), Level.Info.ToString());
                return _periodicWorkRecord;
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

        public PeriodicWorkRecord AutoGeneratedCode()
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(AutoGeneratedCode), Level.Info.ToString());
                PeriodicWorkRecord periodicWorkRecord = new PeriodicWorkRecord();

                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "Sp_CLS_PeriodicWorkRecordAutoGeneratedCode";

                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }
                if (ds.Tables.Count != 0)
                {
                    periodicWorkRecord = (from n in ds.Tables[0].AsEnumerable()
                                     select new PeriodicWorkRecord
                                     {
                                         DocumentNo = Convert.ToString(n["DocumentNo"])
                                     }).FirstOrDefault();
                }
                Log4NetLogger.LogExit(_FileName, nameof(AutoGeneratedCode), Level.Info.ToString());
                return periodicWorkRecord;
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

        public PeriodicWorkRecord DocFetch(PeriodicWorkRecord periodic)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(DocFetch), Level.Info.ToString());
            try
            {
                var dbAccessDAL = new DBAccessDAL();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@PeriodicId", Convert.ToString(periodic.PeriodicId));
                DataSet dt = dbAccessDAL.GetDataSet("SP_CLS_PeriodicWorkRecordFetch", parameters, DataSetparameters);

                List<UserAreaDetails> _userAreaDetailsList = new List<UserAreaDetails>();

                if (dt != null && dt.Tables.Count > 0)
                {

                    foreach(DataRow dr in dt.Tables[0].Rows)
                    {
                        UserAreaDetails Auto = new UserAreaDetails();
                        Auto.UserAreaCode = dr["UserAreaCode"].ToString();
                        Auto.Status = Convert.ToInt32(dr["Status"].ToString());
                        Auto.ScopeofWorkA1 = dr["ContainerWashing"].ToString();
                        Auto.ScopeofWorkA2 = dr["Ceiling"].ToString();
                        Auto.ScopeofWorkA3 = dr["Lights"].ToString();
                        Auto.ScopeofWorkA4 = dr["FloorScrubbing"].ToString();
                        Auto.ScopeofWorkA5 = dr["FloorPolishing"].ToString();
                        Auto.ScopeofWorkA6 = dr["FloorBuffing"].ToString();
                        Auto.ScopeofWorkA7 = dr["FloorBB"].ToString();
                        Auto.ScopeofWorkA8 = dr["FloorShampooing"].ToString();
                        Auto.ScopeofWorkA9 = dr["FloorExtraction"].ToString();
                        Auto.ScopeofWorkA10 = dr["WallWiping"].ToString();
                        Auto.ScopeofWorkA11 = dr["WindowDW"].ToString();
                        Auto.ScopeofWorkA12 = dr["PerimeterDrain"].ToString();
                        Auto.ScopeofWorkA13 = dr["ToiletDescaling"].ToString();
                        Auto.ScopeofWorkA14 = dr["HighRiseNetting"].ToString();
                        Auto.ScopeofWorkA15 = dr["ExternalFacade"].ToString();
                        Auto.ScopeofWorkA16 = dr["ExternalHighLevelGlass"].ToString();
                        Auto.ScopeofWorkA17 = dr["InternetGlass"].ToString();
                        Auto.ScopeofWorkA18 = dr["FlatRoof"].ToString();
                        Auto.ScopeofWorkA19 = dr["StainlessSteelPolishing"].ToString();
                        Auto.ScopeofWorkA20 = dr["ExposeCeiling"].ToString();
                        Auto.ScopeofWorkA21 = dr["LedgesDampWipe"].ToString();
                        Auto.ScopeofWorkA22 = dr["SkylightHighDusting"].ToString();
                        Auto.ScopeofWorkA23 = dr["SignagesWiping"].ToString();
                        Auto.ScopeofWorkA24 = dr["DecksHighDusting"].ToString();

                        _userAreaDetailsList.Add(Auto);
                    }

                    periodic.UserAreaDetailsList = _userAreaDetailsList;
                }
                return periodic;
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

        public PeriodicWorkRecord Save(PeriodicWorkRecord model, out string ErrorMessage)
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
                        cmd.CommandText = "SP_CLS_PeriodicWorkRecordSave";
                        cmd.Parameters.AddWithValue("@pPeriodicId", model.PeriodicId);
                        cmd.Parameters.AddWithValue("@pCustomerId", model.CustomerId);
                        cmd.Parameters.AddWithValue("@pFacilityId", model.FacilityId);
                        cmd.Parameters.AddWithValue("@pDocumentNo", model.DocumentNo);
                        cmd.Parameters.AddWithValue("@pYear", model.Year);
                        cmd.Parameters.AddWithValue("@pMonth", model.Month);
                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);

                        if (ds.Tables.Count != 0)
                        {
                            cmd.Parameters.Clear();

                            if(Convert.ToInt32(ds.Tables[0].Rows[0]["PeriodicId"]) == -1)
                            {
                                var Year = ds.Tables[0].Rows[0]["Year"].ToString();
                                var Month = ds.Tables[0].Rows[0]["Month"].ToString();
                                var DocumentNo = ds.Tables[0].Rows[0]["DocumentNo"].ToString();

                                ErrorMessage = "Periodic Work Record is already saved for the Year: " + Year + " and Month: " + Month + " for the Document No: " + DocumentNo;
                            }
                            if (Convert.ToInt32(ds.Tables[0].Rows[0]["PeriodicId"]) == -2)
                            {                               
                                var DocumentNo = ds.Tables[0].Rows[0]["DocumentNo"].ToString();

                                ErrorMessage = "Periodic Work Record is already saved for the Document No: " + DocumentNo + ". Please do Reset";
                            }
                            else
                            {
                                model.PeriodicId = Convert.ToInt32(ds.Tables[0].Rows[0]["PeriodicId"]);

                                var ds1 = new DataSet();
                                cmd.CommandText = "SP_CLS_PeriodicWorkRecordTableSave";

                                foreach (var user in model.UserAreaDetailsList)
                                {
                                    cmd.Parameters.AddWithValue("@pPeriodicId", model.PeriodicId);
                                    cmd.Parameters.AddWithValue("@pUserAreaCode", user.UserAreaCode);
                                    cmd.Parameters.AddWithValue("@pStatus", user.Status);
                                    cmd.Parameters.AddWithValue("@pScopeofWorkA1", user.ScopeofWorkA1);
                                    cmd.Parameters.AddWithValue("@pScopeofWorkA2", user.ScopeofWorkA2);
                                    cmd.Parameters.AddWithValue("@pScopeofWorkA3", user.ScopeofWorkA3);
                                    cmd.Parameters.AddWithValue("@pScopeofWorkA4", user.ScopeofWorkA4);
                                    cmd.Parameters.AddWithValue("@pScopeofWorkA5", user.ScopeofWorkA5);
                                    cmd.Parameters.AddWithValue("@pScopeofWorkA6", user.ScopeofWorkA6);
                                    cmd.Parameters.AddWithValue("@pScopeofWorkA7", user.ScopeofWorkA7);
                                    cmd.Parameters.AddWithValue("@pScopeofWorkA8", user.ScopeofWorkA8);
                                    cmd.Parameters.AddWithValue("@pScopeofWorkA9", user.ScopeofWorkA9);
                                    cmd.Parameters.AddWithValue("@pScopeofWorkA10", user.ScopeofWorkA10);
                                    cmd.Parameters.AddWithValue("@pScopeofWorkA11", user.ScopeofWorkA11);
                                    cmd.Parameters.AddWithValue("@pScopeofWorkA12", user.ScopeofWorkA12);
                                    cmd.Parameters.AddWithValue("@pScopeofWorkA13", user.ScopeofWorkA13);
                                    cmd.Parameters.AddWithValue("@pScopeofWorkA14", user.ScopeofWorkA14);
                                    cmd.Parameters.AddWithValue("@pScopeofWorkA15", user.ScopeofWorkA15);
                                    cmd.Parameters.AddWithValue("@pScopeofWorkA16", user.ScopeofWorkA16);
                                    cmd.Parameters.AddWithValue("@pScopeofWorkA17", user.ScopeofWorkA17);
                                    cmd.Parameters.AddWithValue("@pScopeofWorkA18", user.ScopeofWorkA18);
                                    cmd.Parameters.AddWithValue("@pScopeofWorkA19", user.ScopeofWorkA19);
                                    cmd.Parameters.AddWithValue("@pScopeofWorkA20", user.ScopeofWorkA20);
                                    cmd.Parameters.AddWithValue("@pScopeofWorkA21", user.ScopeofWorkA21);
                                    cmd.Parameters.AddWithValue("@pScopeofWorkA22", user.ScopeofWorkA22);
                                    cmd.Parameters.AddWithValue("@pScopeofWorkA23", user.ScopeofWorkA23);
                                    cmd.Parameters.AddWithValue("@pScopeofWorkA24", user.ScopeofWorkA24);

                                    da.SelectCommand = cmd;
                                    da.Fill(ds1);
                                    cmd.Parameters.Clear();
                                }
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
    }
}