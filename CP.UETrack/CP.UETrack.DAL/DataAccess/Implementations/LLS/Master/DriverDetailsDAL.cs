using CP.Framework.Common.ExceptionHandler.ExceptionWrappers;
using CP.Framework.Common.Logging;
using CP.UETrack.DAL.DataAccess.Contracts.LLS;

using CP.UETrack.DAL.DataAccess.Implementation;
using CP.UETrack.DAL.Helper;
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
    public class DriverDetailsDAL : IDriverDetailsDAL
    {
        private readonly string _FileName = nameof(DriverDetailsDAL);
        readonly UserDetailsModel _UserSession = new SessionHelper().UserSession();
        public DriverDetailsDAL()
        {

        }

        public DriverDetailsModelLovs Load()
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
                var dbAccessDAL = new MASTERDBAccessDAL();
                DriverDetailsModelLovs UserDriverDetailsModelLovs = new DriverDetailsModelLovs();
                string lovs = "StatusValue,LLSClassGradeValue,IssuingBodyValue";
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pLovKey", lovs);
                var ds = new DataSet();
                var ds1 = new DataSet();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_Dropdown_Others";
                        cmd.Parameters.AddWithValue("@pTableName", "SoiledLinenCollection");
                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);

                        var da1 = new SqlDataAdapter();
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_Dropdown";
                        cmd.Parameters.Clear();
                        cmd.Parameters.AddWithValue("@pLovKey", lovs);
                        da1.SelectCommand = cmd;
                        da1.Fill(ds1);
                    }
                }

                if (ds.Tables.Count != 0)
                {
                    UserDriverDetailsModelLovs.LaundryPlant = dbAccessDAL.GetLovRecords(ds.Tables[0]);
                }

                if (ds1.Tables.Count != 0)
                {
                    UserDriverDetailsModelLovs.Status = dbAccessDAL.GetLovRecords(ds1.Tables[0], "StatusValue");
                    UserDriverDetailsModelLovs.ClassGrade = dbAccessDAL.GetLovRecords(ds1.Tables[0], "LLSClassGradeValue");
                    UserDriverDetailsModelLovs.IssuedBy = dbAccessDAL.GetLovRecords(ds1.Tables[0], "IssuingBodyValue");
                }
                UserDriverDetailsModelLovs.IsAdditionalFieldsExist = IsAdditionalFieldsExist();
                Log4NetLogger.LogExit(_FileName, nameof(Load), Level.Info.ToString());

                return UserDriverDetailsModelLovs;
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

        public bool IsAdditionalFieldsExist()
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(IsAdditionalFieldsExist), Level.Info.ToString());
                var isExists = false;

                var ds = new DataSet();
                var dbAccessDAL = new MASTERDBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_FMAddFieldConfig_Check";
                        cmd.Parameters.AddWithValue("@pCustomerId", _UserSession.CustomerId);
                        cmd.Parameters.AddWithValue("@pScreenNameLovId", (int)ConfigScreenNameValue.TestingAndCommissioning);
                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }
                if (ds.Tables.Count != 0 && ds.Tables[0].Rows.Count > 0)
                {
                    isExists = Convert.ToInt32(ds.Tables[0].Rows[0][0]) > 0;
                }
                Log4NetLogger.LogExit(_FileName, nameof(IsAdditionalFieldsExist), Level.Info.ToString());
                return isExists;
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
        public DriverDetailsModel Save(DriverDetailsModel model, out string ErrorMessage)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());
                ErrorMessage = string.Empty;
                var spName = string.Empty;
                var spNames = string.Empty;
                var ds = new DataSet();
                var ds2 = new DataSet();
                var dbAccessDAL = new MASTERDBAccessDAL();
                var rowparameters = new Dictionary<string, string>();
                var parameters = new Dictionary<string, string>();
                var EffectiveDate = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss");
                var DataSetparameters = new Dictionary<string, DataTable>();
                List<LDriverDetailsLinenItemList> DriverdetailList = new List<LDriverDetailsLinenItemList>();
                DriverdetailList = model.LDriverDetailsLinenItemGridList;
                DataTable dataTable = new DataTable("DriverDetailsMst");
                DataTable dataTable1 = new DataTable("DriverDetailsMstDet");
                DataTable varDt2 = new DataTable();
                parameters.Add("@LaundryPlantId", Convert.ToString(model.LaundryPlantId));
                parameters.Add("@DriverName", Convert.ToString(model.DriverName));
                parameters.Add("@Status", Convert.ToString(model.Status));
                parameters.Add("@EffectiveFrom", Convert.ToString(model.EffectiveFrom == null || model.EffectiveFrom == DateTime.MinValue ? null : model.EffectiveFrom.ToString("MM-dd-yyy")));
                parameters.Add("@ContactNo", Convert.ToString(model.ContactNo));
                parameters.Add("@ICNo", Convert.ToString(model.ICNo));
                parameters.Add("@ModifiedBy", _UserSession.UserId.ToString());
                parameters.Add("@DriverId", Convert.ToString(model.DriverId));
                // Delete grid
                var deletedId = model.LDriverDetailsLinenItemGridList.Where(y => y.IsDeleted).Select(x => x.DriverDetId).ToList();
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

                //foreach (var var in model.LDriverDetailsLinenItemGridList.Where(y => !y.IsDeleted))
                //{
                //    varDt2.Rows.Add(var.DriverDetId, var.LicenseTypeDetId, var.LicenseNo, var.ClassGrades, var.IsssuedBy, var.IssuedDate, var.ExpiryDate, model.DriverId);
                //}
                if (model.DriverId != 0)
                {

                    DataTable dss = dbAccessDAL.GetMASTERDataTable("LLSDriverDetailsMst_Update", parameters, DataSetparameters);
                    if (dss != null)
                    {
                        //DataTable varDt2 = new DataTable();
                        varDt2.Columns.Add("@DriverDetId", typeof(int));
                        varDt2.Columns.Add("@LicenseTypeDetId", typeof(int));
                        varDt2.Columns.Add("@LicenseNo", typeof(string));
                        varDt2.Columns.Add("@ClassGrade", typeof(int));
                        varDt2.Columns.Add("@IssuedBy", typeof(int));
                        varDt2.Columns.Add("@IssuedDate", typeof(DateTime));
                        varDt2.Columns.Add("@ExpiryDate", typeof(DateTime));
                        varDt2.Columns.Add("@DriverId", typeof(int));
                        varDt2.Columns.Add("@ModifiedBy", typeof(int));
                        foreach (var var in model.LDriverDetailsLinenItemGridList)
                        {
                            varDt2.Rows.Add(var.DriverDetId, var.LicenseTypeDetId, var.LicenseNo, var.ClassGrades, var.IsssuedBy, var.IssuedDate, var.ExpiryDate, model.DriverId, _UserSession.UserId.ToString());
                        }
                        parameters.Clear();
                        DataSetparameters.Add("@LLSDriverDetailsMstDet_Update", varDt2);
                        DataTable dss2 = dbAccessDAL.GetMASTERDataTable("LLSDriverDetailsMstDet_Update", parameters, DataSetparameters);
                        foreach (var jjj in model.LDriverDetailsLinenItemGridList)
                        {
                            if (jjj.DriverDetId == 0)
                            {
                                spNames = "LLSDriverDetailsMstDet_Save";
                                dataTable1.Columns.Add("DriverId", typeof(int));
                                dataTable1.Columns.Add("CustomerId", typeof(int));
                                dataTable1.Columns.Add("FacilityID", typeof(int));
                                dataTable1.Columns.Add("LicenseTypeDetId", typeof(string));
                                dataTable1.Columns.Add("LicenseNo", typeof(string));
                                dataTable1.Columns.Add("ClassGrade", typeof(string));
                                dataTable1.Columns.Add("IssuedBy", typeof(string));
                                dataTable1.Columns.Add("IssuedDate", typeof(DateTime));
                                dataTable1.Columns.Add("ExpiryDate", typeof(DateTime));
                                dataTable1.Columns.Add("CreatedBy", typeof(int));
                                foreach (var row in DriverdetailList)
                                {
                                    if (row.DriverDetId == 0)
                                    {
                                        dataTable1.Rows.Add(
                                       model.DriverId,
                                       _UserSession.CustomerId,
                                       _UserSession.FacilityId,
                                       row.LicenseTypeDetId,
                                       row.LicenseNo,
                                       row.ClassGrades,
                                       row.IsssuedBy,
                                       row.IssuedDate,
                                       row.ExpiryDate,
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
                            if (jjj.DriverDetId == 0)
                            {
                                return model;
                            }
                            else { }
                        }
                        return model;
                    }

                }
                ////save function
                #region MasterForm Save--------
                else
                {
                    spName = "LLSDriverDetailsMst_Save";
                }
                dataTable.Columns.Add("CustomerId", typeof(int));
                dataTable.Columns.Add("FacilityID", typeof(int));
                dataTable.Columns.Add("@pDocumentNo", typeof(string));
                dataTable.Columns.Add("LaundryPlantId", typeof(int));
                dataTable.Columns.Add("DriverName", typeof(string));
                dataTable.Columns.Add("Status", typeof(int));
                dataTable.Columns.Add(new DataColumn("EffectiveFrom", typeof(DateTime)));
                dataTable.Columns.Add(new DataColumn("EffectiveTo", typeof(DateTime)));
                dataTable.Columns.Add("ContactNo", typeof(string));
                dataTable.Columns.Add("ICNo", typeof(string));
                dataTable.Columns.Add("CreatedBy", typeof(int));
                dataTable.Columns.Add("ModifiedBy", typeof(int));
                dataTable.Rows.Add(
                     _UserSession.CustomerId,
                    _UserSession.FacilityId,
                    model.DriverCode,
                    model.LaundryPlantId,
                    model.DriverName,
                    model.Status,
                   Convert.ToDateTime(model.EffectiveFrom),
                    Convert.ToDateTime(model.EffectiveTo),
                    model.ContactNo,
                    model.ICNo,
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
                        parameter.ParameterName = "@Block";
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
                    var Driverid = Convert.ToInt32(ds.Tables[0].Rows[0]["DriverId"]);
                    if (Driverid != 0)
                        model.DriverId = Driverid;
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
                #endregion
                #region Add Row Save
                if (model.DriverDetId != 0)
                {

                }
                else
                {

                    spNames = "LLSDriverDetailsMstDet_Save";
                    dataTable1.Columns.Add("DriverId", typeof(int));
                    dataTable1.Columns.Add("CustomerId", typeof(int));
                    dataTable1.Columns.Add("FacilityID", typeof(int));
                    dataTable1.Columns.Add("LicenseTypeDetId", typeof(string));
                    dataTable1.Columns.Add("LicenseNo", typeof(string));
                    dataTable1.Columns.Add("ClassGrade", typeof(string));
                    dataTable1.Columns.Add("IssuedBy", typeof(string));
                    dataTable1.Columns.Add("IssuedDate", typeof(DateTime));
                    dataTable1.Columns.Add("ExpiryDate", typeof(DateTime));
                    dataTable1.Columns.Add("CreatedBy", typeof(int));
                    foreach (var row in DriverdetailList)
                    {
                        dataTable1.Rows.Add(
                        model.DriverId,
                        _UserSession.CustomerId,
                        _UserSession.FacilityId,
                        row.LicenseTypeDetId,
                        row.LicenseNo,
                        row.ClassGrades,
                        row.IsssuedBy,
                        row.IssuedDate,
                        row.ExpiryDate,
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
                #endregion

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

        public DriverDetailsModel Get(int Id)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
            try
            {
                DriverDetailsModel model = new DriverDetailsModel();
                var ds = new DataSet();
                var dbAccessDAL = new MASTERDBAccessDAL();
                LDriverDetailsLinenItemList LDriverDetailsLinenItem = new LDriverDetailsLinenItemList();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("Id", Convert.ToString(Id));
                DataTable dt = dbAccessDAL.GetMASTERDataTable("LLSDriverDetailsMst_GetById", parameters, DataSetparameters);
                if (dt != null && dt.Rows.Count > 0)
                {
                    model.DriverId = Id;
                    model.DriverCode = Convert.ToString(dt.Rows[0]["DriverCode"]);
                    model.LaundryPlantName = Convert.ToString(dt.Rows[0]["LaundryPlantName"]);
                    model.DriverName = Convert.ToString(dt.Rows[0]["DriverName"]);
                    model.Status = Convert.ToInt32(dt.Rows[0]["Status"]);
                    model.EffectiveFrom = Convert.ToDateTime(dt.Rows[0]["EffectiveFrom"] != DBNull.Value ? (Convert.ToDateTime(dt.Rows[0]["EffectiveFrom"])) : (DateTime?)null);
                    model.EffectiveTo = Convert.ToDateTime(dt.Rows[0]["EffectiveTo"] != DBNull.Value ? (Convert.ToDateTime(dt.Rows[0]["EffectiveTo"])) : (DateTime?)null);
                    model.ContactNo = Convert.ToString(dt.Rows[0]["ContactNo"]);
                    model.ICNo = Convert.ToString(dt.Rows[0]["ICNo"]);

                }
                DataSet dt2 = dbAccessDAL.MasterGetDataSet("LLSDriverDetailsMstDet_GetById", parameters, DataSetparameters);
                if (dt != null && dt2.Tables.Count > 0)
                {
                    model.LDriverDetailsLinenItemGridList = (from n in dt2.Tables[0].AsEnumerable()
                                                             select new LDriverDetailsLinenItemList
                                                             {
                                                                 LicenseTypeDetId = Convert.ToInt32(n["LicenseTypeDetId"]),
                                                                 LicenseCode = Convert.ToString(n["LicenseCode"]),
                                                                 LicenseDescription = Convert.ToString(n["LicenseDescription"]),
                                                                 LicenseNo = Convert.ToString(n["LicenseNo"]),
                                                                 ClassGrades = Convert.ToString(n["ClassGrade"]),
                                                                 IsssuedBy = Convert.ToString(n["IssuedBy"]),
                                                                 IssuedDate = Convert.ToDateTime(n["IssuedDate"]),
                                                                 ExpiryDate = Convert.ToDateTime(n["ExpiryDate"]),
                                                                 DriverDetId = Convert.ToInt32(n["DriverDetId"]),
                                                             }).ToList();
                    model.LDriverDetailsLinenItemGridList.ForEach((x) =>
                    {
                        // entity.TotalCost = x.TotalCost;
                        //x.PageIndex = pageindex;
                        //x.FirstRecord = ((pageindex - 1) * pagesize) + 1;
                        //x.LastRecord = ((pageindex - 1) * pagesize) + pagesize;

                    });
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
                        cmd.CommandText = "LLSDriverDetailsMst_GetAll";

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
                DataTable dt = dbAccessDAL.GetMASTERDataTable("LLSDriverDetailsMst_Delete", parameters, DataSetparameters);
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

        public bool IsDriverCodeDuplicate(DriverDetailsModel model)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(IsDriverCodeDuplicate), Level.Info.ToString());

                var IsDuplicate = true;
                var dbAccessDAL = new MASTERDBAccessDAL();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@Id", model.DriverId.ToString());
                parameters.Add("@DriverCode", model.DriverCode.ToString());
                parameters.Add("@pCustomerId", Convert.ToString(_UserSession.CustomerId));
                parameters.Add("@pFacilityId", Convert.ToString(_UserSession.FacilityId));
                DataTable dt = dbAccessDAL.GetMASTERDataTable("LLSDriverDetailsMst_ValCode", parameters, DataSetparameters);
                if (dt != null && dt.Rows.Count > 0)
                {
                    IsDuplicate = Convert.ToBoolean(dt.Rows[0]["IsDuplicate"]);
                }
                Log4NetLogger.LogExit(_FileName, nameof(IsDriverCodeDuplicate), Level.Info.ToString());
                return IsDuplicate;
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
        public bool IsRecordModified(DriverDetailsModel model)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(IsRecordModified), Level.Info.ToString());

                var recordModifed = false;

                if (model.DriverId != 0)
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
                            cmd.Parameters.AddWithValue("Id", model.DriverId);
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
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "LLSDriverDetailsMstDetSingle_Delete";
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

