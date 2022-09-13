using CP.Framework.Common.ExceptionHandler.ExceptionWrappers;
using CP.Framework.Common.Logging;
using CP.UETrack.DAL.DataAccess.Contracts.LLS;
//using CP.UETrack.DAL.DataAccess.Contracts.LLS.Master;
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

namespace CP.UETrack.DAL.DataAccess.Implementations.LLS.Master
{
    public class VehicleDetailsDAL : IVehicleDetailsDAL
    {
        private readonly string _FileName = nameof(DepartmentDetailsDAL);
        readonly UserDetailsModel _UserSession = new SessionHelper().UserSession();
        public VehicleDetailsDAL()
        {

        }

        public VehicleDetailsModelLovs Load()
        {
            try
            {
                var ds = new DataSet();
                Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
                VehicleDetailsModelLovs UserVehicleDetailsModelLovs = new VehicleDetailsModelLovs();
                var dbAccessDAL = new MASTERDBAccessDAL();
                string lovs = "ManufacturerValue,StatusValue,LLSClassGradeValue,IssuingBodyValue";
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
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
                    UserVehicleDetailsModelLovs.LaundryPlantName = dbAccessDAL.GetLovRecords(ds.Tables[0]);
                }

                if (ds1.Tables.Count != 0)
                {
                    UserVehicleDetailsModelLovs.Manufacturer = dbAccessDAL.GetLovRecords(ds1.Tables[0], "ManufacturerValue");
                    UserVehicleDetailsModelLovs.Status = dbAccessDAL.GetLovRecords(ds1.Tables[0], "StatusValue");
                    UserVehicleDetailsModelLovs.ClassGrade = dbAccessDAL.GetLovRecords(ds1.Tables[0], "LLSClassGradeValue");
                    UserVehicleDetailsModelLovs.IssuedBy = dbAccessDAL.GetLovRecords(ds1.Tables[0], "IssuingBodyValue");

                }
                UserVehicleDetailsModelLovs.IsAdditionalFieldsExist = IsAdditionalFieldsExist();
                Log4NetLogger.LogExit(_FileName, nameof(Load), Level.Info.ToString());

                return UserVehicleDetailsModelLovs;
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
        public VehicleDetailsModel Save(VehicleDetailsModel model, out string ErrorMessage)
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
                var parameters = new Dictionary<string, string>();
                var rowparameters = new Dictionary<string, string>();
                var EffectiveDate = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss");
                List<LVehicleLinenItemList> vehicledetailList = new List<LVehicleLinenItemList>();
                vehicledetailList = model.LVehicleDetailsLinenItemGridList;
                var DataSetparameters = new Dictionary<string, DataTable>();
                DataTable dataTable = new DataTable("VehicleDetailsMst");
                DataTable dataTable1 = new DataTable("VehicleDetails");
                DataTable varDt2 = new DataTable();
                parameters.Add("@pModel", Convert.ToString(model.Model));
                parameters.Add("@Manufacturer", Convert.ToString(model.Manufacturer));
                parameters.Add("@LaundryPlantId", Convert.ToString(model.LaundryPlantId));
                parameters.Add("@Status", Convert.ToString(model.Status));
                parameters.Add("@EffectiveFrom", Convert.ToString(model.EffectiveFrom == null || model.EffectiveFrom == DateTime.MinValue ? null : model.EffectiveFrom.ToString("MM-dd-yyy")));
                parameters.Add("@LoadWeight", Convert.ToString(model.LoadWeight));
                parameters.Add("@ModifiedBy", _UserSession.UserId.ToString());
                parameters.Add("@VehicleId", Convert.ToString(model.VehicleId));
                // Delete grid
                var deletedId = model.LVehicleDetailsLinenItemGridList.Where(y => y.IsDeleted).Select(x => x.VehicleDetId).ToList();
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

                if (model.VehicleId != 0)
                {
                    DataTable dss = dbAccessDAL.GetMASTERDataTable("LLSVehicleDetailsMst_Update", parameters, DataSetparameters);



                    if (dss != null)
                    {
                        //DataTable varDt2 = new DataTable();
                        varDt2.Columns.Add("@VehicleDetId", typeof(int));
                        varDt2.Columns.Add("@LicenseTypeDetId", typeof(int));
                        varDt2.Columns.Add("@LicenseNo", typeof(string));
                        varDt2.Columns.Add("@ClassGrade", typeof(int));
                        varDt2.Columns.Add("@IssuedBy", typeof(int));
                        varDt2.Columns.Add("@IssuedDate", typeof(DateTime));
                        varDt2.Columns.Add("@ExpiryDate", typeof(DateTime));
                        varDt2.Columns.Add("@VehicleId", typeof(int));
                        varDt2.Columns.Add("@ModifiedBy", typeof(int));

                        foreach (var var in model.LVehicleDetailsLinenItemGridList)
                        {
                            varDt2.Rows.Add(var.VehicleDetId, var.LicenseTypeDetId, var.LicenseNo, var.ClassGrades, var.IsssuedBy, var.IssuedDate, var.ExpiryDate, model.VehicleId, _UserSession.UserId.ToString());
                        }
                        parameters.Clear();
                        DataSetparameters.Add("@LLSVehicleDetailsMstDet_Update", varDt2);
                        DataTable dss2 = dbAccessDAL.GetMASTERDataTable("LLSVehicleDetailsMstDet_Update", parameters, DataSetparameters);
                        //parameters.Clear();
                        //DataSetparameters.Clear();
                        foreach (var jjj in model.LVehicleDetailsLinenItemGridList)
                        {
                            if (jjj.VehicleDetId == 0)
                            {
                                spNames = "LLSVehicleDetailsMstDet_Save";
                                dataTable1.Columns.Add("VehicleId", typeof(int));
                                dataTable1.Columns.Add("CustomerId", typeof(int));
                                dataTable1.Columns.Add("FacilityID", typeof(int));
                                dataTable1.Columns.Add("LicenseTypeDetId", typeof(string));
                                dataTable1.Columns.Add("LicenseNo", typeof(string));
                                dataTable1.Columns.Add("ClassGrade", typeof(string));
                                dataTable1.Columns.Add("IssuedBy", typeof(string));
                                dataTable1.Columns.Add("IssuedDate", typeof(DateTime));
                                dataTable1.Columns.Add("ExpiryDate", typeof(DateTime));
                                dataTable1.Columns.Add("CreatedBy", typeof(int));
                                foreach (var row in vehicledetailList)
                                {
                                    if (row.VehicleDetId == 0)
                                    {
                                        dataTable1.Rows.Add(
                                        model.VehicleId,
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
                            if (jjj.VehicleDetId == 0)
                            {
                                return model;
                            }
                            else { }
                        }
                        return model;
                    }

                }

                //----------------- Add Master Save

                else
                {
                    spName = "LLSVehicleDetailsMst_Save";
                }
                //if(model.EffectiveTo== null)
                //{
                //    model.EffectiveTo = Convert.ToDateTime(EffectiveDate);
                //}
                //else{
                dataTable.Columns.Add("CustomerId", typeof(int));
                dataTable.Columns.Add("FacilityID", typeof(int));
                dataTable.Columns.Add("VehicleNo", typeof(string));
                dataTable.Columns.Add("Model", typeof(string));
                dataTable.Columns.Add("Manufacturer", typeof(int));
                dataTable.Columns.Add("LaundryPlantId", typeof(int));
                dataTable.Columns.Add("Status", typeof(int));
                dataTable.Columns.Add(new DataColumn("EffectiveFrom", typeof(DateTime)));
                dataTable.Columns.Add(new DataColumn("EffectiveTo", typeof(DateTime)));
                dataTable.Columns.Add("LoadWeight", typeof(int));
                dataTable.Columns.Add("CreatedBy", typeof(int));
                dataTable.Columns.Add("ModifiedBy", typeof(int));
                dataTable.Rows.Add(
                     _UserSession.CustomerId,
                    _UserSession.FacilityId,
                    model.VehicleNo,
                    model.Model,
                    model.Manufacturer,
                    model.LaundryPlantId,
                    model.Status,
                    Convert.ToDateTime(model.EffectiveFrom),
                    Convert.ToDateTime(model.EffectiveTo),
                    model.LoadWeight,
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
                    var Vehicleid = Convert.ToInt32(ds.Tables[0].Rows[0]["VehicleId"]);
                    if (Vehicleid != 0)
                        model.VehicleId = Vehicleid;
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

                //----------------- Add Row Save
                if (model.VehicleDetId != 0)
                {


                }
                else
                {
                    spNames = "LLSVehicleDetailsMstDet_Save";
                    dataTable1.Columns.Add("VehicleId", typeof(int));
                    dataTable1.Columns.Add("CustomerId", typeof(int));
                    dataTable1.Columns.Add("FacilityID", typeof(int));
                    dataTable1.Columns.Add("LicenseTypeDetId", typeof(string));
                    dataTable1.Columns.Add("LicenseNo", typeof(string));
                    dataTable1.Columns.Add("ClassGrade", typeof(string));
                    dataTable1.Columns.Add("IssuedBy", typeof(string));
                    dataTable1.Columns.Add("IssuedDate", typeof(DateTime));
                    dataTable1.Columns.Add("ExpiryDate", typeof(DateTime));
                    dataTable1.Columns.Add("CreatedBy", typeof(int));
                    foreach (var row in vehicledetailList)
                    {
                        dataTable1.Rows.Add(
                        model.VehicleId,
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
                //--------------------End

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


        public VehicleDetailsModel Get(int Id)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
            try
            {
                VehicleDetailsModel model = new VehicleDetailsModel();
                var ds = new DataSet();
                var dbAccessDAL = new MASTERDBAccessDAL();
                LVehicleLinenItemList LVehicleLinenItemList = new LVehicleLinenItemList();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("Id", Convert.ToString(Id));
                DataTable dt = dbAccessDAL.GetMASTERDataTable("LLSVehicleDetailsMst_GetById", parameters, DataSetparameters);
                if (dt != null && dt.Rows.Count > 0)
                {
                    model.VehicleId = Id;
                    model.VehicleNo = Convert.ToString(dt.Rows[0]["VehicleNo"]);
                    model.Model = Convert.ToString(dt.Rows[0]["Model"]);
                    model.Manufacturer = Convert.ToInt32(dt.Rows[0]["Manufacturer"]);
                    model.LaundryPlantName = Convert.ToString(dt.Rows[0]["LaundryPlantName"]);
                    model.Status = Convert.ToInt32(dt.Rows[0]["Status"]);
                    model.EffectiveFrom = Convert.ToDateTime(dt.Rows[0]["EffectiveFrom"] != DBNull.Value ? (Convert.ToDateTime(dt.Rows[0]["EffectiveFrom"])) : (DateTime?)null);
                    model.EffectiveTo = Convert.ToDateTime(dt.Rows[0]["EffectiveTo"] != DBNull.Value ? (Convert.ToDateTime(dt.Rows[0]["EffectiveTo"])) : (DateTime?)null);
                    model.LoadWeight = Convert.ToInt32(dt.Rows[0]["LoadWeight"]);
                }
                DataSet dt2 = dbAccessDAL.MasterGetDataSet("LLSVehicleDetailsMstDet_GetById", parameters, DataSetparameters);
                if (dt != null && dt2.Tables.Count > 0)
                {
                    model.LVehicleDetailsLinenItemGridList = (from n in dt2.Tables[0].AsEnumerable()
                                                              select new LVehicleLinenItemList
                                                              {
                                                                  VehicleDetId = Convert.ToInt32(n["VehicleDetId"]),
                                                                  LicenseTypeDetId = Convert.ToInt32(n["LicenseTypeDetId"]),
                                                                  LicenseCode = Convert.ToString(n["LicenseCode"]),
                                                                  LicenseDescription = Convert.ToString(n["LicenseDescription"]),
                                                                  LicenseNo = Convert.ToString(n["LicenseNo"]),
                                                                  ClassGrades = Convert.ToString(n["ClassGrade"]),
                                                                  IsssuedBy = Convert.ToString(n["IssuedBy"]),
                                                                  IssuedDate = Convert.ToDateTime(n["IssuedDate"]),
                                                                  ExpiryDate = Convert.ToDateTime(n["ExpiryDate"]),

                                                              }).ToList();
                    model.LVehicleDetailsLinenItemGridList.ForEach((x) =>
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
                        cmd.CommandText = "LLSVehicleDetailsMst_GetAll";

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
                DataTable dt = dbAccessDAL.GetMASTERDataTable("LLSVehicleDetailsMst_Delete", parameters, DataSetparameters);
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

        public bool IsVehicleDetailsDuplicate(VehicleDetailsModel model)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(IsVehicleDetailsDuplicate), Level.Info.ToString());

                var isDuplicate = true;
                var dbAccessDAL = new MASTERDBAccessDAL();


                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@Id", model.VehicleId.ToString());
                parameters.Add("@VehicleNo", model.VehicleNo.ToString());
                //parameters.Add("@LaundryPlantCode", model.LaundryPlantCode);
                parameters.Add("@pCustomerId", Convert.ToString(_UserSession.CustomerId));
                parameters.Add("@pFacilityId", Convert.ToString(_UserSession.FacilityId));
                DataTable dt = dbAccessDAL.GetMASTERDataTable("LLSVehicleDetailsMst_ValCode", parameters, DataSetparameters);
                if (dt != null && dt.Rows.Count > 0)
                {
                    isDuplicate = Convert.ToBoolean(dt.Rows[0]["isDuplicate"]);
                }
                Log4NetLogger.LogExit(_FileName, nameof(IsVehicleDetailsDuplicate), Level.Info.ToString());
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

        public bool IsRecordModified(VehicleDetailsModel model)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(IsRecordModified), Level.Info.ToString());

                var recordModifed = false;

                if (model.VehicleId != 0)
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
                            cmd.Parameters.AddWithValue("Id", model.VehicleId);
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
                        cmd.CommandText = "LLSVehicleDetailsMstDetSingle_Delete";
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
            catch (Exception ex)
            {
                throw ex;
            }
        }
    }
}

