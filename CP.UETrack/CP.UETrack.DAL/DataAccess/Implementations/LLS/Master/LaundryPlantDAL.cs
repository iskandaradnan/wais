using CP.Framework.Common.ExceptionHandler.ExceptionWrappers;
using CP.Framework.Common.Logging;
using CP.UETrack.DAL.DataAccess.Contracts.LLS;

using CP.UETrack.DAL.DataAccess.Implementation;
using CP.UETrack.Model;
using CP.UETrack.Model.LLS;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Web.Razor.Parser.SyntaxTree;
using UETrack.DAL;

namespace CP.UETrack.DAL.DataAccess.Implementations.LLS
{
    public class LaundryPlantDAL : ILaundryPlantDAL
    {
        private readonly string _FileName = nameof(LaundryPlantDAL);
        readonly UserDetailsModel _UserSession = new SessionHelper().UserSession();



        public LaundryPlantDAL()
        {

        }

        public LaundryPlantModelLovs Load()
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
                LaundryPlantModelLovs UserLaundryPlantModelLovs = new LaundryPlantModelLovs();
                string lovs = "OwnershipValue,StatusValue";
                var dbAccessDAL = new DBAccessDAL();

                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pLovKey", lovs);
                DataSet ds = dbAccessDAL.GetDataSet("uspFM_Dropdown", parameters, DataSetparameters);
                if (ds.Tables.Count != 0 && ds.Tables[0].Rows.Count > 0)
                {
                    UserLaundryPlantModelLovs.Ownership = dbAccessDAL.GetLovRecords(ds.Tables[0], "OwnershipValue");
                    UserLaundryPlantModelLovs.Status = dbAccessDAL.GetLovRecords(ds.Tables[0], "StatusValue");

                }


                Log4NetLogger.LogExit(_FileName, nameof(Load), Level.Info.ToString());

                return UserLaundryPlantModelLovs;
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

        public LaundryPlantModel Save(LaundryPlantModel model, out string ErrorMessage)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());

                ErrorMessage = string.Empty;
                var spName = string.Empty;
                var ds = new DataSet();
                var dbAccessDAL = new MASTERDBAccessDAL();
                var parameters = new Dictionary<string, string>();
                var DataSetparameters = new Dictionary<string, DataTable>();
                DataTable dataTable = new DataTable("LaundryPlantMst");
                parameters.Add("@LaundryPlantCode", Convert.ToString(model.LaundryPlantCode));
                parameters.Add("@LaundryPlantName", Convert.ToString(model.LaundryPlantName));
                parameters.Add("@Ownership", Convert.ToString(model.Ownership));
                parameters.Add("@Capacity", Convert.ToString(model.Capacity));
                parameters.Add("@ContactPerson", Convert.ToString(model.ContactPerson));
                parameters.Add("@Status", Convert.ToString(model.Status));
                parameters.Add("@ModifiedBy", _UserSession.UserId.ToString());
                parameters.Add("@LaundryPlantId", Convert.ToString(model.LaundryPlantId));
                if (model.LaundryPlantId != 0)
                {
                    DataTable dss = dbAccessDAL.GetMASTERDataTable("LLSLaundryPlantMst_Update", parameters, DataSetparameters);
                    //if (dss != null)
                    //{
                    //    foreach (DataRow row in dss.Rows)
                    //    {
                    //        model.LaundryPlantCode = Convert.ToString(row["LaundryPlantCode"]);
                    //        model.LaundryPlantName = Convert.ToString(row["LaundryPlantName"]);
                    //        model.Ownership = Convert.ToInt32(row["Ownership"]);
                    //        model.Capacity = Convert.ToInt32(row["Capacity"]);
                    //        model.ContactPerson = Convert.ToString(row["ContactPerson"]);
                    //        model.Status = Convert.ToInt32(row["Status"]);

                    //    }
                    //}
                    return model;
                }
                else
                {
                    spName = "LLSLaundryPlantMst_Save";
                }
                dataTable.Columns.Add("CustomerId", typeof(int));
                dataTable.Columns.Add("FacilityID", typeof(int));
                dataTable.Columns.Add("LaundryPlantCode", typeof(string));
                dataTable.Columns.Add("LaundryPlantName", typeof(string));
                dataTable.Columns.Add("Ownership", typeof(int));
                dataTable.Columns.Add("Capacity", typeof(int));
                dataTable.Columns.Add("ContactPerson", typeof(string));
                dataTable.Columns.Add("Status", typeof(int));
                dataTable.Columns.Add("CreatedBy", typeof(int));
                dataTable.Columns.Add("ModifiedBy", typeof(int));
                dataTable.Rows.Add(
                         _UserSession.CustomerId,
                        _UserSession.FacilityId,
                        model.LaundryPlantCode,
                        model.LaundryPlantName,
                        model.Ownership,
                        model.Capacity,
                        model.ContactPerson,
                        model.Status,
                        _UserSession.UserId.ToString(),
                        _UserSession.UserId.ToString()
                        );
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = spName;
                        SqlParameter parameter = new SqlParameter();
                        parameter.ParameterName = "@LaundryPlant";
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
                    var LaundryPlantid = Convert.ToInt32(ds.Tables[0].Rows[0]["LaundryPlantId"]);
                    if (LaundryPlantid != 0)
                        model.LaundryPlantId = LaundryPlantid;
                    if (ds.Tables[0].Rows[0]["Timestamp"] == DBNull.Value)
                    {
                        model.Timestamp = "";
                    }
                    else
                    {
                        model.Timestamp = Convert.ToBase64String((byte[])(ds.Tables[0].Rows[0]["Timestamp"]));
                    }
                    ErrorMessage = Convert.ToString(ds.Tables[0].Rows[0]["ErrorMsg"]);
                }

                Log4NetLogger.LogExit(_FileName, nameof(Save), Level.Info.ToString());
                return model;
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

        public LaundryPlantModel Get(int Id)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
                LaundryPlantModel model = null;

                var ds = new DataSet();
                var dbAccessDAL = new MASTERDBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "LLSLaundryPlantMst_GetById";
                        cmd.Parameters.AddWithValue("Id", Id);
                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }
                if (ds.Tables.Count != 0)
                {
                    model = (from n in ds.Tables[0].AsEnumerable()
                             select new LaundryPlantModel
                             {
                                 LaundryPlantId = Id,
                                 LaundryPlantCode = Convert.ToString(n["LaundryPlantCode"]),
                                 LaundryPlantName = Convert.ToString(n["LaundryPlantName"]),
                                 Ownerships = Convert.ToString(n["Ownership"]),
                                 Capacity = Convert.ToInt32(n["Capacity"]),
                                 ContactPerson = Convert.ToString(n["ContactPerson"]),
                                 Statuss = Convert.ToString(n["Status"]),
                                 //Timestamp = Convert.ToBase64String((byte[])(n["Timestamp"]))
                             }).FirstOrDefault();
                }
                Log4NetLogger.LogExit(_FileName, nameof(Get), Level.Info.ToString());
                return model;
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
                var dbAccessDAL = new MASTERDBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "LLSLaundryPlantMst_GetAll";

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
            catch (Exception ex)
            {
                throw ex;
            }
        }

        public void Delete(int Id, out string ErrorMessage)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Delete), Level.Info.ToString());
            try
            {
                ErrorMessage = string.Empty;
                var dbAccessDAL = new MASTERDBAccessDAL();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@ID", Id.ToString());
                parameters.Add("@ModifiedBy", _UserSession.UserId.ToString());
                DataTable dt = dbAccessDAL.GetMASTERDataTable("LLSLaundryPlantMst_Delete", parameters, DataSetparameters);
                if (dt != null && dt.Rows.Count > 0)
                {
                    ErrorMessage = Convert.ToString(dt.Rows[0]["ErrorMessage"]);
                }

                Log4NetLogger.LogExit(_FileName, nameof(Delete), Level.Info.ToString());
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

        public bool IsLaundryPlantDuplicate(LaundryPlantModel model)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(IsLaundryPlantDuplicate), Level.Info.ToString());

                var isDuplicate = true;
                var dbAccessDAL = new MASTERDBAccessDAL();


                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@Id", model.LaundryPlantId.ToString());
                //parameters.Add("@LaundryPlantCode", model.LaundryPlantCode);
                parameters.Add("@pCustomerId", Convert.ToString(_UserSession.CustomerId));
                parameters.Add("@pFacilityId", Convert.ToString(_UserSession.FacilityId));
                parameters.Add("@LaundryPlantCode", model.LaundryPlantCode.ToString());
                DataTable dt = dbAccessDAL.GetMASTERDataTable("LLSLaundryPlantMst_ValCode", parameters, DataSetparameters);
                if (dt != null && dt.Rows.Count > 0)
                {
                    isDuplicate = Convert.ToBoolean(dt.Rows[0]["isDuplicate"]);
                }
                Log4NetLogger.LogExit(_FileName, nameof(IsLaundryPlantDuplicate), Level.Info.ToString());
                return isDuplicate;
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

        public bool IsRecordModified(LaundryPlantModel model)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(IsRecordModified), Level.Info.ToString());

                var recordModifed = false;

                if (model.LaundryPlantId != 0)
                {
                    var ds = new DataSet();
                    string constring = ConfigurationManager.ConnectionStrings["BEMSUETrackConnectionString"].ConnectionString;
                    using (SqlConnection con = new SqlConnection(constring))
                    {
                        using (SqlCommand cmd = new SqlCommand())
                        {
                            cmd.Connection = con;
                            cmd.CommandType = CommandType.StoredProcedure;
                            cmd.CommandText = "GetBlockTimestamp";
                            cmd.Parameters.AddWithValue("Id", model.LaundryPlantId);
                            var da = new SqlDataAdapter();
                            da.SelectCommand = cmd;
                            da.Fill(ds);
                        }
                    }
                    if (ds.Tables.Count != 0 && ds.Tables[0].Rows.Count > 0)
                    {
                        var timestamp = Convert.ToBase64String((byte[])(ds.Tables[0].Rows[0]["Timestamp"]));
                        if (timestamp != model.Timestamp)
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


    }
}

