using CP.UETrack.DAL.DataAccess.Contracts.LLS;
using CP.UETrack.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using CP.Framework.Common.Logging;
using CP.Framework.Common.ExceptionHandler.ExceptionWrappers;
using CP.UETrack.Models;
using System.Data;
using System.Data.SqlClient;
using System.Configuration;
using UETrack.DAL;
using System.Dynamic;
using CP.UETrack.DAL.DataAccess.Implementation;
using CP.UETrack.Model.LLS;



namespace CP.UETrack.DAL.DataAccess.Implementations.LLS
{
    public class LinenItemDetailsDAL : ILinenItemDetailsDAL
    {
        private readonly string _FileName = nameof(LinenItemDetailsDAL);
        readonly UserDetailsModel _UserSession = new SessionHelper().UserSession();

        public BlockFacilityDropdown BlockFacilityDropdown { get; private set; }

        public LinenItemDetailsDAL()
        {

        }

        public LinenItemDetailsModelLovs Load()
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
                LinenItemDetailsModelLovs LinenItemDetailsModelLovs = new LinenItemDetailsModelLovs();
                string lovs = "LLSUOMValue,StatusValue,ColourValue,StandardValue,MaterialValue";
                var dbAccessDAL = new DBAccessDAL();

                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pLovKey", lovs);
                DataSet ds = dbAccessDAL.GetDataSet("uspFM_Dropdown", parameters, DataSetparameters);
                if (ds.Tables.Count != 0 && ds.Tables[0].Rows.Count > 0)
                {
                    LinenItemDetailsModelLovs.UOM = dbAccessDAL.GetLovRecords(ds.Tables[0], "LLSUOMValue");
                    LinenItemDetailsModelLovs.Status = dbAccessDAL.GetLovRecords(ds.Tables[0], "StatusValue");
                    LinenItemDetailsModelLovs.Colour = dbAccessDAL.GetLovRecords(ds.Tables[0], "ColourValue");
                    LinenItemDetailsModelLovs.Standard = dbAccessDAL.GetLovRecords(ds.Tables[0], "StandardValue");
                    LinenItemDetailsModelLovs.Material = dbAccessDAL.GetLovRecords(ds.Tables[0], "MaterialValue");
                }

                Log4NetLogger.LogExit(_FileName, nameof(Load), Level.Info.ToString());           
                return LinenItemDetailsModelLovs;

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

        public LinenItemDetailsModel Save(LinenItemDetailsModel model, out string ErrorMessage)
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
                var EffectiveDate = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss");
                DataTable dataTable = new DataTable("LinenItemDetailsMst");
                //parameters.Add("@pCustomerId", Convert.ToString(_UserSession.CustomerId));
                //parameters.Add("@pFacilityId", Convert.ToString(_UserSession.FacilityId));
                parameters.Add("@LinenDescription", Convert.ToString(model.LinenDescription));
                parameters.Add("@UOM", Convert.ToString(model.UOM));
                parameters.Add("@Status", Convert.ToString(model.Status));
                parameters.Add("@Material", Convert.ToString(model.Material));
                parameters.Add("@EffectiveDate",EffectiveDate);
                parameters.Add("@Size", Convert.ToString(model.Size));
                parameters.Add("@Colour", Convert.ToString(model.Color));
                parameters.Add("@Standard", Convert.ToString(model.Standard));
                parameters.Add("@IdentificationMark", Convert.ToString(model.IdentificationMark));
                parameters.Add("@ModifiedBy", _UserSession.UserId.ToString());
                parameters.Add("@LinenItemId", Convert.ToString(model.LinenItemId));
                parameters.Add("@LinenPrice", Convert.ToString(model.LinenPrice));
                if (model.LinenItemId != 0)
                {
                    DataTable dss = dbAccessDAL.GetMASTERDataTable("LLSLinenItemDetailsMst_Update", parameters, DataSetparameters);
                    if (dss != null)
                    {
                        foreach (DataRow row in dss.Rows)
                        {
                           

                        }
                    }
                    return model;
                }
                else
                {
                    spName = "LLSLinenItemDetailsMst_Save";
                }
                dataTable.Columns.Add("CustomerId", typeof(int));
                dataTable.Columns.Add("FacilityID", typeof(int));
                dataTable.Columns.Add("LinenCode", typeof(string));
                dataTable.Columns.Add("LinenDescription", typeof(string));
                dataTable.Columns.Add("UOM", typeof(string));
                dataTable.Columns.Add("Status", typeof(string));
                dataTable.Columns.Add("Material", typeof(string));
                dataTable.Columns.Add("EffectiveDate", typeof(DateTime));
                dataTable.Columns.Add("Size", typeof(string));
                dataTable.Columns.Add("Colour", typeof(string));
                dataTable.Columns.Add("IdentificationMark", typeof(string));
                dataTable.Columns.Add("Standard", typeof(string));
                dataTable.Columns.Add("CreatedBy", typeof(int));
                dataTable.Columns.Add("ModifiedBy", typeof(int));
                dataTable.Columns.Add("LinenPrice", typeof(Decimal));


                dataTable.Rows.Add(
                     _UserSession.CustomerId,
                    _UserSession.FacilityId,
                    model.LinenCode,
                    model.LinenDescription,
                    model.UOM,
                    model.Status,
                    model.Material,
                    model.EffectiveDate,
                    model.Size,
                    model.Color,
                    model.IdentificationMark,
                    model.Standard,
                    _UserSession.UserId.ToString(),
                    _UserSession.UserId.ToString(),
                     model.LinenPrice

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
                    var LinenItemid = Convert.ToInt32(ds.Tables[0].Rows[0]["LinenItemId"]);
                    if (LinenItemid != 0)
                        model.LinenItemId = LinenItemid;
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

        public bool IsLinenItemDuplicate(LinenItemDetailsModel model)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(IsLinenItemDuplicate), Level.Info.ToString());

                var isDuplicate = true;
                var dbAccessDAL = new MASTERDBAccessDAL();


                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@Id", model.LinenItemId.ToString());
                parameters.Add("@LinenCode", model.LinenCode.ToString());
                //parameters.Add("@LaundryPlantCode", model.LaundryPlantCode);
                parameters.Add("@pCustomerId", Convert.ToString(_UserSession.CustomerId));
                parameters.Add("@pFacilityId", Convert.ToString(_UserSession.FacilityId));
                DataTable dt = dbAccessDAL.GetMASTERDataTable("LLSLinenItemDetailsMst_ValCode", parameters, DataSetparameters);
                if (dt != null && dt.Rows.Count > 0)
                {
                    isDuplicate = Convert.ToBoolean(dt.Rows[0]["isDuplicate"]);
                }
                Log4NetLogger.LogExit(_FileName, nameof(IsLinenItemDuplicate), Level.Info.ToString());
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

        public bool IsRecordModified(LinenItemDetailsModel model)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(IsRecordModified), Level.Info.ToString());

                var recordModifed = false;

                if (model.LinenItemId != 0)
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
                            cmd.Parameters.AddWithValue("Id", model.LinenItemId);
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

        public LinenItemDetailsModel Get(int Id)
       {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
                LinenItemDetailsModel model = null;

                var ds = new DataSet();
                var dbAccessDAL = new MASTERDBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "LLSLinenItemDetailsMst_GetById";
                        cmd.Parameters.AddWithValue("Id", Id);
                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }
                if (ds.Tables.Count != 0)
                {
                    model = (from n in ds.Tables[0].AsEnumerable()
                             select new LinenItemDetailsModel
                             {
                                 LinenItemId = Id,
                                 LinenCode = Convert.ToString(n["LinenCode"]),
                                 LinenDescription = Convert.ToString(n["LinenDescription"]),
                                 UOM = Convert.ToString(n["UOM"]),
                                 Material = Convert.ToString(n["Material"]),
                                 Status = Convert.ToString(n["Status"]),
                                 EffectiveDate = Convert.ToDateTime(n["EffectiveDate"]),
                                 Size = Convert.ToString(n["Size"]),
                                 Colour = Convert.ToString(n["Colour"]),
                                 Standard = Convert.ToString(n["Standard"]),
                                 IdentificationMark = Convert.ToString(n["IdentificationMark"]),
                                 LinenPrice = Convert.ToString(n["LinenPrice"]),
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
                        cmd.CommandText = "LLSLinenItemDetailsMst_GetAll";

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
                parameters.Add("@ModifiedBy", _UserSession.UserId.ToString());
                parameters.Add("@ID", Id.ToString());
                DataTable dt = dbAccessDAL.GetMASTERDataTable("LLSLinenItemDetailsMst_Delete", parameters, DataSetparameters);
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

       
    }
} 
