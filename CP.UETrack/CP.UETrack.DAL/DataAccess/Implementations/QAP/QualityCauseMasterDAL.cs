using CP.UETrack.DAL.DataAccess.Contracts.QAP;
using CP.UETrack.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using CP.UETrack.Model.QAP;
using System.Data.SqlClient;
using CP.Framework.Common.Logging;
using CP.Framework.Common.ExceptionHandler.ExceptionWrappers;
using System.Data;
using UETrack.DAL;
using CP.UETrack.DAL.DataAccess.Implementation;

namespace CP.UETrack.DAL.DataAccess.Implementations.QAP
{
    public class QualityCauseMasterDAL: IQualityCauseMasterDAL
    {
        private readonly string _FileName = nameof(QualityCauseMasterDAL);
        readonly UserDetailsModel _UserSession = new SessionHelper().UserSession();

        public QualityCauseTypeDropdown Load()
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
                QualityCauseTypeDropdown QualityCauseTypeDropdown = null;

                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_Dropdown_Others";
                        cmd.Parameters.AddWithValue("@pTablename", "ServiceAll");
                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);

                        if (ds.Tables.Count != 0)
                        {
                            QualityCauseTypeDropdown = new QualityCauseTypeDropdown();
                            QualityCauseTypeDropdown.QualityServiceTypeData = dbAccessDAL.GetLovRecords(ds.Tables[0]);
                        }

                        ds.Clear();
                        cmd.CommandText = "uspFM_Dropdown";
                        cmd.Parameters.Clear();
                        cmd.Parameters.AddWithValue("@pLovKey", "StatusValue");
                        da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);

                        if (ds.Tables.Count != 0)
                        {
                            QualityCauseTypeDropdown.QualityStatusTypeData = dbAccessDAL.GetLovRecords(ds.Tables[0]);
                        }

                        ds.Clear();
                        cmd.Parameters.Clear();
                        cmd.Parameters.AddWithValue("@pLovKey", "ProblemCodeValue");
                        da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);

                        if (ds.Tables.Count != 0)
                        {
                            QualityCauseTypeDropdown.QualityProblemTypeData = dbAccessDAL.GetLovRecords(ds.Tables[0]);
                        }
                       
                    }
                }

                Log4NetLogger.LogExit(_FileName, nameof(Load), Level.Info.ToString());
                return QualityCauseTypeDropdown;
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

        public QualityCauseMasterModel Get(int Id,int pagesize,int pageindex)
        { 
            Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
            try
            {
                var dbAccessDAL = new DBAccessDAL();
                var entity = new QualityCauseMasterModel();

                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pQualityCauseId", Convert.ToString(Id));               
                parameters.Add("@pPageIndex", Convert.ToString(pageindex));
                parameters.Add("@pPageSize", Convert.ToString(pagesize));

                DataTable dt1 = dbAccessDAL.GetDataTable("uspFM_MstQAPQualityCause_GetById", parameters, DataSetparameters);
                if (dt1 != null && dt1.Rows.Count > 0)
                {
                    entity.QualityCauseId = Convert.ToInt32(dt1.Rows[0]["QualityCauseId"]);
                    entity.ServiceId = Convert.ToInt32(dt1.Rows[0]["ServiceId"]);
                    entity.Description = dt1.Rows[0]["Description"].ToString();
                    entity.CauseCode = dt1.Rows[0]["CauseCode"].ToString();
                    entity.Timestamp = Convert.ToBase64String((byte[])(dt1.Rows[0]["Timestamp"]));
                }
                DataSet dt = dbAccessDAL.GetDataSet("uspFM_MstQAPQualityCause_GetById", parameters, DataSetparameters);
                if (dt != null && dt.Tables.Count > 0)
                {
                    entity.QualityCauseListData = (from n in dt.Tables[1].AsEnumerable()
                                                   select new ItemQualityCauseMasterList
                                                   {
                                                       QualityCauseId = Convert.ToInt32(n["QualityCauseId"]),
                                                       ProblemCode = Convert.ToInt32(n["ProblemCode"]),
                                                       QcCode = Convert.ToString(n["QcCode"]),
                                                       Details = Convert.ToString(n["Details"]),
                                                       Status = Convert.ToInt32(n["Status"]),
                                                       QualityCauseDetId = Convert.ToInt32(n["QualityCauseDetId"]),

                                                       TotalRecords = Convert.ToInt32(n["TotalRecords"]),
                                                       TotalPages = Convert.ToInt32(n["TotalPageCalc"]),
                                                       //Timestamp = Convert.ToBase64String((byte[])(n["Timestamp"]))
                                                   }).ToList();
                    entity.QualityCauseListData.ForEach((x) => {
                        // entity.TotalCost = x.TotalCost;
                        x.PageIndex = pageindex;
                        x.FirstRecord = ((pageindex - 1) * pagesize) + 1;
                        x.LastRecord = ((pageindex - 1) * pagesize) + pagesize;                        
                    });

                }
                Log4NetLogger.LogExit(_FileName, nameof(Get), Level.Info.ToString());
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
                        cmd.CommandText = "uspFM_MstQAPQualityCause_GetAll";   //change SP Name

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
                //return userRoles;
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
        

        public QualityCauseMasterModel Save(QualityCauseMasterModel Quality, out string ErrorMessage)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());
                ErrorMessage = string.Empty;
                var dbAccessDAL = new DBAccessDAL();
                var parameters = new Dictionary<string, string>();

                parameters.Add("@pUserId", Convert.ToString(_UserSession.UserId));
                parameters.Add("@pQualityCauseId", Convert.ToString(Quality.QualityCauseId));
                parameters.Add("@pServiceId", Convert.ToString(Quality.ServiceId));
                parameters.Add("@pCauseCode", Convert.ToString(Quality.CauseCode));
                parameters.Add("@pDescription", Convert.ToString(Quality.Description));
                parameters.Add("@pTimestamp", Convert.ToString(Quality.Timestamp));


                var DataSetparameters = new Dictionary<string, DataTable>();
                DataTable dt = new DataTable();
                dt.Columns.Add("QualityCauseDetId", typeof(int));
                dt.Columns.Add("QualityCauseId", typeof(int));
                dt.Columns.Add("ProblemCode", typeof(int));
                dt.Columns.Add("QcCode", typeof(string));
                dt.Columns.Add("Details", typeof(string));
                dt.Columns.Add("Status", typeof(int));
                //dt.Columns.Add("UserId", typeof(int));

                var deletedId = Quality.QualityCauseListData.Where(y => y.IsDeleted).Select(x => x.QualityCauseDetId).ToList();
                var idstring = string.Empty;
                if (deletedId.Count() > 0)
                {
                    foreach (var item in deletedId.Select((value, i) => new { i, value }))
                    {
                        idstring += item.value;
                        if (item.i != deletedId.Count() - 1)
                        { idstring += ","; }
                    }
                    deleteChildRecords(idstring);
                }

                foreach (var i in Quality.QualityCauseListData.Where(y => !y.IsDeleted))
                {
                    dt.Rows.Add(i.QualityCauseDetId, i.QualityCauseId, i.ProblemCode, i.QcCode, i.Details, i.Status);

                    //dt.Rows.Add(i.IndicatorDetId, i.IndicatorId, "kk", "kkk", "kkkkk", 10, 22.2, 91);

                }

                DataSetparameters.Add("@MstQAPQualityCauseDet", dt);
                DataTable dt1 = dbAccessDAL.GetDataTable("uspFM_MstQAPQualityCause_Save", parameters, DataSetparameters);
                if (dt1 != null)
                {
                    foreach (DataRow row in dt1.Rows)
                    {
                        foreach (var val in Quality.QualityCauseListData)

                        {
                            val.QualityCauseId = Convert.ToInt32(row["QualityCauseId"]);
                            Quality.QualityCauseId = Convert.ToInt32(row["QualityCauseId"]);
                            Quality.Timestamp = Convert.ToBase64String((byte[])(row["Timestamp"]));
                            ErrorMessage = Convert.ToString(row["ErrorMessage"]);
                        }
                    }
                }

                Log4NetLogger.LogExit(_FileName, nameof(Save), Level.Info.ToString());
                return Quality;
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

        public void deleteChildRecords(string id)
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
                        cmd.CommandText = "uspFM_MstQAPQualityCauseDet_Delete";
                        cmd.Parameters.AddWithValue("@pQualityCauseDetId", id);

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

        public bool Delete(int Id)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Delete), Level.Info.ToString());
            try
            {
                var dbAccessDAL = new DBAccessDAL();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pQualityCauseId", Id.ToString());
                DataTable dt = dbAccessDAL.GetDataTable("uspFM_MstQAPQualityCause_Delete", parameters, DataSetparameters);//sp name change
                if (dt != null && dt.Rows.Count > 0)
                {
                    string Message = Convert.ToString(dt.Rows[0]["Message"]);
                }
                Log4NetLogger.LogExit(_FileName, nameof(Delete), Level.Info.ToString());
                return true;
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
        public bool IsQualityCauseMasterCodeDuplicate(QualityCauseMasterModel Quality)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(IsQualityCauseMasterCodeDuplicate), Level.Info.ToString());

                var IsDuplicate = true;
                var dbAccessDAL = new DBAccessDAL();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@RescheduleWOId", Quality.QualityCauseId.ToString());
                //parameters.Add("@RescheduleWOCode", RescheduleWO.WorkOrderNo.ToString());
                DataTable dt = dbAccessDAL.GetDataTable("UspFM_RescheduleWO_ValCode", parameters, DataSetparameters); //change sp name
                if (dt != null && dt.Rows.Count > 0)
                {
                    IsDuplicate = Convert.ToBoolean(dt.Rows[0]["IsDuplicate"]);
                }
                return IsDuplicate;
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

        public bool IsRecordModified(QualityCauseMasterModel Quality)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(IsRecordModified), Level.Info.ToString());
                var dbAccessDAL = new DBAccessDAL();
                var recordModifed = false;

                if (Quality.QualityCauseId != 0)
                {

                    var DataSetparameters = new Dictionary<string, DataTable>();
                    var parameters = new Dictionary<string, string>();
                    parameters.Add("@RescheduleWOId", Quality.QualityCauseId.ToString());
                    parameters.Add("@Operation", "GetTimestamp");
                    DataTable dt = dbAccessDAL.GetDataTable("UspFM_RescheduleWO_Get", parameters, DataSetparameters);//change sp name

                    if (dt != null && dt.Rows.Count > 0)
                    {
                        var timestamp = Convert.ToBase64String((byte[])(dt.Rows[0]["Timestamp"]));
                        //if (timestamp != RescheduleWO.Timestamp)
                        //{
                        recordModifed = true;
                        //}
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

    }
}
