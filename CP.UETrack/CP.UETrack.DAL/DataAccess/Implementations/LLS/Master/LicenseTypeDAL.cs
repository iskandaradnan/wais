using CP.Framework.Common.ExceptionHandler.ExceptionWrappers;
using CP.Framework.Common.Logging;
using CP.UETrack.DAL.DataAccess.Contracts.LLS;
using CP.UETrack.DAL.DataAccess.Implementation;
//using CP.UETrack.DAL.DataAccess.Contracts.LLS.Master;
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
using UETrack.DAL;

namespace CP.UETrack.DAL.DataAccess.Implementations.LLS
{
    public class LicenseTypeDAL : ILicenseTypeDAL
    {
        private readonly string _FileName = nameof(DepartmentDetailsDAL);
        readonly UserDetailsModel _UserSession = new SessionHelper().UserSession();
        public LicenseTypeDAL()
        {

        }

        public LicenseTypeModelLovs Load()
        {

            Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
                LicenseTypeModelLovs licensrType = new LicenseTypeModelLovs();
                string lovs = "LicenseTypeValue,IssuingBodyValue";
                var dbAccessDAL = new DBAccessDAL();

                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pLovKey", lovs);
                DataSet ds = dbAccessDAL.GetDataSet("uspFM_Dropdown", parameters, DataSetparameters);
                if (ds.Tables.Count != 0 && ds.Tables[0].Rows.Count > 0)
                {
                   // licensrType.LicenseType = dbAccessDAL.GetLovRecords(ds.Tables[0], "LicenseTypeValue");
                    licensrType.IssuingBody = dbAccessDAL.GetLovRecords(ds.Tables[0], "IssuingBodyValue");

                }
                parameters.Add("@ModuleName", "LLS");
                parameters.Add("@ScreenName", "License Type");
                DataSet ds1 = dbAccessDAL.GetDataSet("uspFM_Dropdown_By_ModuleScreen", parameters, DataSetparameters);
                if (ds1.Tables.Count != 0 && ds1.Tables[0].Rows.Count > 0)
                {
                     licensrType.LicenseType = dbAccessDAL.GetLovRecords(ds1.Tables[0], "LicenseTypeValue");                    
                }
                Log4NetLogger.LogExit(_FileName, nameof(Load), Level.Info.ToString());
                return licensrType;
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
        public LicenseTypeModel Save(LicenseTypeModel model, out string ErrorMessage)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());
                //int _LicenseTypeId = 0;
                ErrorMessage = string.Empty;
                var spName = string.Empty;
                var spNames = string.Empty;
                var ds = new DataSet();
                var ds2 = new DataSet();
                var dbAccessDAL = new MASTERDBAccessDAL();
                var rowparameters = new Dictionary<string, string>();
                var parameters = new Dictionary<string, string>();
                var DataSetparameters = new Dictionary<string, DataTable>();
                List<LicenseTypeModelList> HKeepingList = new List<LicenseTypeModelList>();
                HKeepingList = model.LicenseTypeModelListData;
                DataTable dataTable = new DataTable("licenseTypeMst");
                DataTable varDt2 = new DataTable();
                DataTable dataTable1 = new DataTable("licenseTypeMstDet");
                // Delete grid
                var deletedId = model.LicenseTypeModelListData.Where(y => y.IsDeleted).Select(x => x.LicenseTypeDetId).ToList();
                var idstring = string.Empty;
                if (deletedId.Count() > 0)
                {
                    foreach (var item in deletedId.Select((value, var) => new { var, value }))
                    {
                        idstring += item.value;
                        if (item.var != deletedId.Count() - 1)
                        { idstring += ","; }
                    }
                    deleteChildrecords(idstring);
                }

                //foreach (var var in model.LicenseTypeModelListData.Where(y => !y.IsDeleted))
                //{
                //    varDt2.Rows.Add(var.LicenseDescription, var.IssuingBody,  var.LicenseTypeDetId);
                //}
                if (model.LicenseTypeId != 0)
                {

                    //DataTable varDt2 = new DataTable();
                    varDt2.Columns.Add("@LicenseDescription", typeof(string));
                    varDt2.Columns.Add("@IssuingBody", typeof(int));
                    varDt2.Columns.Add("@LicenseTypeDetId", typeof(int));
                    varDt2.Columns.Add("@ModifiedBy", typeof(int));
                    foreach (var var in model.LicenseTypeModelListData)
                    {
                        varDt2.Rows.Add(var.LicenseDescription, var.IssuingBody, var.LicenseTypeDetId, _UserSession.UserId.ToString());
                    }
                    parameters.Clear();
                    DataSetparameters.Add("@LLSLicenseTypeMstDet_Update", varDt2);
                    DataTable dss2 = dbAccessDAL.GetMASTERDataTable("LLSLicenseTypeMstDet_Update", parameters, DataSetparameters);

                    foreach (var obj in model.LicenseTypeModelListData)
                    {
                        if (obj.LicenseTypeDetId == 0)
                        {
                            spNames = "LLSLicenseTypeMstDet_Save";
                            dataTable1.Columns.Add("CustomerId", typeof(int));
                            dataTable1.Columns.Add("FacilityId", typeof(string));
                            dataTable1.Columns.Add("LicenseTypeId", typeof(int));
                            dataTable1.Columns.Add("LicenseCode", typeof(string));
                            dataTable1.Columns.Add("LicenseDescription", typeof(string));
                            dataTable1.Columns.Add("IssuingBody", typeof(int));
                            dataTable1.Columns.Add("CreatedBy", typeof(int));
                            dataTable1.Columns.Add("ModifiedBy", typeof(int));
                            foreach (var row in HKeepingList)
                            {
                                if (row.LicenseTypeDetId == 0)
                                {
                                    dataTable1.Rows.Add(
                                   _UserSession.CustomerId,
                               _UserSession.FacilityId,
                               model.LicenseTypeId,
                               row.LicenseCode,
                               row.LicenseDescription,
                               row.IssuingBody,
                                _UserSession.UserId.ToString(),
                    _UserSession.UserId.ToString()
                               );
                                }
                            }
                            using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                            {
                                using (SqlCommand cmd = new SqlCommand())
                                {
                                    cmd.Connection = con;
                                    cmd.CommandType = CommandType.StoredProcedure;
                                    cmd.CommandText = spNames;
                                    SqlParameter parameter = new SqlParameter();
                                    parameter.ParameterName = "@Block";
                                    parameter.SqlDbType = System.Data.SqlDbType.Structured;
                                    parameter.Value = dataTable1;
                                    cmd.Parameters.Add(parameter);
                                    var daa = new SqlDataAdapter();
                                    daa.SelectCommand = cmd;
                                    daa.Fill(ds2);
                                }
                            }
                        }
                        if (obj.LicenseTypeDetId == 0)
                        {
                            return model;
                        }
                        else { }
                    }
                    return model;
                }

                else
                {
                    spName = "LLSLicenseTypeMst_Save";
                    dataTable.Columns.Add("CustomerId", typeof(int));
                    dataTable.Columns.Add("FacilityId", typeof(int));
                    dataTable.Columns.Add("LicenseType", typeof(int));
                    dataTable.Columns.Add("CreatedBy", typeof(int));
                    dataTable.Columns.Add("ModifiedBy", typeof(int));
                    dataTable.Rows.Add(_UserSession.CustomerId, _UserSession.FacilityId, model.LicenseType, _UserSession.UserId.ToString(),
                    _UserSession.UserId.ToString());
                    using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                    {
                        using (SqlCommand cmd = new SqlCommand())
                        {
                            cmd.Connection = con;
                            cmd.CommandType = CommandType.StoredProcedure;
                            cmd.CommandText = spName;
                            SqlParameter parameter = new SqlParameter();
                            parameter.ParameterName = "@Block";
                            parameter.SqlDbType = System.Data.SqlDbType.Structured;
                            parameter.Value = dataTable;
                            cmd.Parameters.Add(parameter);
                            var da = new SqlDataAdapter();
                            da.SelectCommand = cmd;
                            da.Fill(ds);
                            if (ds != null)
                            {
                                if (ds.Tables[0].Rows.Count > 0)
                                {
                                    //string test = ds.Tables[0].Rows[0]["LicenseTypeId"].ToString();
                                    model.LicenseTypeId = Convert.ToInt32(ds.Tables[0].Rows[0]["LicenseTypeId"]);
                                }

                            }
                        }
                    }
                    if (model.LicenseTypeDetId != 0)
                    {
                    }
                    else
                    {

                        spNames = "LLSLicenseTypeMstDet_Save";
                        dataTable1.Columns.Add("CustomerId", typeof(int));
                        dataTable1.Columns.Add("FacilityId", typeof(string));
                        dataTable1.Columns.Add("LicenseTypeId", typeof(int));
                        dataTable1.Columns.Add("LicenseCode", typeof(string));
                        dataTable1.Columns.Add("LicenseDescription", typeof(string));
                        dataTable1.Columns.Add("IssuingBody", typeof(int));
                        dataTable1.Columns.Add("CreatedBy", typeof(int));
                        dataTable1.Columns.Add("ModifiedBy", typeof(int));

                        foreach (var row in HKeepingList)
                        {
                            dataTable1.Rows.Add(
                                _UserSession.CustomerId,
                            _UserSession.FacilityId,
                            model.LicenseTypeId,
                            row.LicenseCode,
                            row.LicenseDescription,
                            row.IssuingBody,
                             _UserSession.UserId.ToString(),
                             _UserSession.UserId.ToString()
                            );
                        }
                        using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                        {
                            using (SqlCommand cmd = new SqlCommand())
                            {
                                cmd.Connection = con;
                                cmd.CommandType = CommandType.StoredProcedure;
                                cmd.CommandText = spNames;
                                SqlParameter parameter = new SqlParameter();
                                parameter.ParameterName = "@Block";
                                parameter.SqlDbType = System.Data.SqlDbType.Structured;
                                parameter.Value = dataTable1;
                                cmd.Parameters.Add(parameter);
                                var daa = new SqlDataAdapter();
                                daa.SelectCommand = cmd;
                                daa.Fill(ds2);
                            }
                        }
                    }
                    Log4NetLogger.LogExit(_FileName, nameof(Save), Level.Info.ToString());

                    return model;
                }
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


        public LicenseTypeModel Get(int Id)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
                LicenseTypeModel model = new LicenseTypeModel();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                var ds = new DataSet();
                var dbAccessDAL = new MASTERDBAccessDAL();
                parameters.Add("Id", Id.ToString());
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {

                        DataSet dt1 = dbAccessDAL.MasterGetDataSet("LLSLicenseTypeMstDet_GetById", parameters, DataSetparameters);
                        if (dt1 != null && dt1.Tables.Count > 0)
                        {

                            model.LicenseTypeModelListData = (from n in dt1.Tables[0].AsEnumerable()
                                                              select new LicenseTypeModelList
                                                              {
                                                                  LicenseTypeId = Convert.ToInt32(n["LicenseTypeId"]),
                                                                  LicenseTypeDetId = Convert.ToInt32(n["LicenseTypeDetId"]),
                                                                  LicenseCode = Convert.ToString(n["LicenseCode"]),
                                                                  LicenseDescription = Convert.ToString(n["LicenseDescription"]),
                                                                  IssuingBody = Convert.ToInt32(n["IssuingBody"]),

                                                              }).ToList();

                            model.LicenseTypeModelListData.ForEach((x) =>
                            {
                                x.PageSize = model.PageSize;
                                x.PageIndex = model.PageIndex;
                                x.FirstRecord = ((model.PageIndex - 1) * model.PageSize) + 1;
                                x.LastRecord = ((model.PageIndex - 1) * model.PageSize) + model.PageSize;
                                //x.LastPageIndex = x.TotalRecords % model.PageSize == 0 ? x.TotalRecords / model.PageSize : (x.TotalRecords / model.PageSize) + 1;

                            });
                            model.LicenseTypeId = Convert.ToInt32(dt1.Tables[0].Rows[0]["LicenseTypeId"]);
                            parameters.Clear();
                            parameters.Add("Id", model.LicenseTypeId.ToString());
                            DataTable dt = dbAccessDAL.GetMASTERDataTable("LLSLicenseTypeMst_GetById", parameters, DataSetparameters);
                            if (dt != null && dt.Rows.Count > 0)
                            {

                                model.LicenseType = Convert.ToString(dt.Rows[0]["LicenseType"]);
                                model.LicenseTypeId = Convert.ToInt32(dt.Rows[0]["LicenseTypeId"]);
                                //model.LicenseTypeDetId = Convert.ToInt32(dt.Rows[0]["LicenseTypeDetId"]);
                            }
                        }


                    }
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
                var dbAccessDAL = new BEMSDBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "LLSLicenseTypeMstDet_GetAll";

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
                DataTable dt = dbAccessDAL.GetMASTERDataTable("LLSLicenseTypeMst_Delete", parameters, DataSetparameters);
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
            catch (Exception)
            {
                throw;
            }
        }
        public bool IsLicenseTypeDuplicate(LicenseTypeModel model)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(IsLicenseTypeDuplicate), Level.Info.ToString());
                List<LicenseTypeModelList> LicenseTypeModelListData = new List<LicenseTypeModelList>();
                LicenseTypeModelListData.AddRange(model.LicenseTypeModelListData);
                string LicenseCode = "";
                foreach (var obj in LicenseTypeModelListData)
                {
                    LicenseCode = obj.LicenseCode;
                    //if (string.IsNullOrEmpty(obj.LicenseCode))
                    //{
                    //    LicenseCode = obj.LicenseCode;
                    //}
                }
                var isDuplicate = true;
                var dbAccessDAL = new MASTERDBAccessDAL();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@Id", model.LicenseTypeId.ToString());
                parameters.Add("@LicenseCode", LicenseCode.ToString());
                //parameters.Add("@LaundryPlantCode", model.LaundryPlantCode);
                parameters.Add("@pCustomerId", Convert.ToString(_UserSession.CustomerId));
                parameters.Add("@pFacilityId", Convert.ToString(_UserSession.FacilityId));
                DataTable dt = dbAccessDAL.GetMASTERDataTable("LLSLicenseTypeMst_ValCode", parameters, DataSetparameters);
                if (dt != null && dt.Rows.Count > 0)
                {
                    isDuplicate = Convert.ToBoolean(dt.Rows[0]["isDuplicate"]);
                }
                Log4NetLogger.LogExit(_FileName, nameof(IsLicenseTypeDuplicate), Level.Info.ToString());
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

        public bool IsRecordModified(LicenseTypeModel model)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(IsRecordModified), Level.Info.ToString());

                var recordModifed = false;

                if (model.LicenseTypeId != 0)
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
                            cmd.Parameters.AddWithValue("Id", model.LicenseTypeId);
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

        public void deleteChildrecords(string id)
        {
            try
            {
                var ds = new DataSet();
                var dbAccessDAL = new MASTERDBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "LLSLicenseTypeMstDetSingle_Delete";
                        cmd.Parameters.AddWithValue("@ID", id);
                        cmd.Parameters.AddWithValue("@ModifiedBy", _UserSession.UserId.ToString());
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

