using CP.Framework.Common.ExceptionHandler.ExceptionWrappers;
using CP.Framework.Common.Logging;
using CP.UETrack.DAL.DataAccess.Contracts.LLS;
using CP.UETrack.DAL.DataAccess.Implementation;
using CP.UETrack.Model;
using CP.UETrack.Model.LLS;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Configuration;
using System.Text;
using System.Threading.Tasks;
using UETrack.DAL;

namespace CP.UETrack.DAL.DataAccess.Implementations.LLS
{
    public class WeighingScaleDAL : IWeighingScaleDAL
    {
        private readonly string _FileName = nameof(WeighingScaleDAL);
        readonly UserDetailsModel _UserSession = new SessionHelper().UserSession();
        public WeighingScaleDAL()
        {

        }

        public WeighingScaleEquipmentModelLovs Load()
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
                WeighingScaleEquipmentModelLovs WeighingScaleEquipmentModelLovs = new WeighingScaleEquipmentModelLovs();
                string lovs = "StatusValue,IssuingBodyValue";
                var dbAccessDAL = new MASTERDBAccessDAL();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pLovKey", lovs);
                DataSet ds = dbAccessDAL.MasterGetDataSet("uspFM_Dropdown", parameters, DataSetparameters);
                if (ds.Tables[0].Rows.Count > 0)
                {
                    WeighingScaleEquipmentModelLovs.IssuedBy = dbAccessDAL.GetLovRecords(ds.Tables[0], "StatusValue");
                    WeighingScaleEquipmentModelLovs.Status = dbAccessDAL.GetLovRecords(ds.Tables[0], "IssuingBodyValue");

                }
                Log4NetLogger.LogExit(_FileName, nameof(Load), Level.Info.ToString());

                return WeighingScaleEquipmentModelLovs;
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

        public WeighingScaleEquipmentModel Save(WeighingScaleEquipmentModel model, out string ErrorMessage)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());
                ErrorMessage = string.Empty;
                var spNames = string.Empty;
                var ds2 = new DataSet();
                var EffectiveDate = DateTime.Now.ToString("yyyy-MM-dd HH:mm:ss");
                //List<LweighingLinenItemList> weigdetailList = new List<LweighingLinenItemList>();
                //weigdetailList = model.LweighingLinenItemGridList;
                var dbAccessDAL = new MASTERDBAccessDAL();
                var parameters = new Dictionary<string, string>();
                var DataSetparameters = new Dictionary<string, DataTable>();
                DataTable dataTable1 = new DataTable("WeighingScaleDetails");
                parameters.Add("@IssuedBy", Convert.ToString(model.IssuedBy));
                parameters.Add("@ItemDescription", Convert.ToString(model.ItemDescription));
                parameters.Add("@IssuedDate", Convert.ToString(model.IssuedDate == null || model.IssuedDate == DateTime.MinValue ? null : model.IssuedDate.ToString("MM-dd-yyy HH:mm")));
                parameters.Add("@ExpiryDate", Convert.ToString(model.ExpiryDate == null || model.ExpiryDate == DateTime.MinValue ? null : model.ExpiryDate.ToString("MM-dd-yyy HH:mm")));
                parameters.Add("@Status", Convert.ToString(model.Status));
                parameters.Add("@WeighingScaleId", Convert.ToString(model.WeighingScaleId));
                parameters.Add("@ModifiedBy", _UserSession.UserId.ToString());
                if (model.WeighingScaleId != 0)
                {

                    DataTable dss = dbAccessDAL.GetMASTERDataTable("LLSWeighingScaleMst_Update", parameters, DataSetparameters);

                    return model;
                }
                else
                {
                    spNames = "LLSWeighingScaleMst_Save";
                    dataTable1.Columns.Add("CustomerId", typeof(int));
                    dataTable1.Columns.Add("FacilityID", typeof(int));
                    dataTable1.Columns.Add("IssuedBy", typeof(string));
                    dataTable1.Columns.Add("ItemDescription", typeof(string));
                    dataTable1.Columns.Add("SerialNo", typeof(string));
                    dataTable1.Columns.Add("IssuedDate", typeof(DateTime));
                    dataTable1.Columns.Add("ExpiryDate", typeof(DateTime));
                    dataTable1.Columns.Add("Status", typeof(int));
                    dataTable1.Columns.Add("CreatedBy", typeof(int));
                    dataTable1.Columns.Add("ModifiedBy", typeof(int));
                    dataTable1.Rows.Add(
                        _UserSession.CustomerId,
                        _UserSession.FacilityId,
                        model.IssuedBy,
                        model.ItemDescription,
                        model.SerialNo,
                        model.IssuedDate,
                        model.ExpiryDate,
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
                    if (ds2.Tables.Count != 0)
                    {
                        var weighingid = Convert.ToInt32(ds2.Tables[0].Rows[0]["WeighingScaleId"]);
                        if (weighingid != 0)
                            model.WeighingScaleId = weighingid;
                        if (ds2.Tables[0].Rows[0]["Timestamp"] == DBNull.Value)
                        {
                            model.Timestamp = "";
                        }
                        else
                        {
                            model.Timestamp = Convert.ToBase64String((byte[])ds2.Tables[0].Rows[0]["Timestamp"]);
                            //model.GuId = Convert.ToBase64String((byte[])ds2.Tables[0].Rows[0]["GuId"]);
                        }
                        //ErrorMessage = Convert.ToString(ds2.Tables[0].Rows[0]["ErrorMsg"]);
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


        public WeighingScaleEquipmentModel Get(int Id)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
            try
            {
                WeighingScaleEquipmentModel model = new WeighingScaleEquipmentModel();
                var ds = new DataSet();
                var dbAccessDAL = new MASTERDBAccessDAL();
                LweighingLinenItemList LweighingLinenItemList = new LweighingLinenItemList();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("Id", Convert.ToString(Id));
                DataTable dt = dbAccessDAL.GetMASTERDataTable("LLSWeighingScaleMst_GetById", parameters, DataSetparameters);
                if (dt != null && dt.Rows.Count > 0)
                {
                    model.WeighingScaleId = Id;
                    model.IssuedBy = Convert.ToString(dt.Rows[0]["IssuedBy"]);
                    model.ItemDescription = Convert.ToString(dt.Rows[0]["ItemDescription"]);
                    model.SerialNo = Convert.ToString(dt.Rows[0]["SerialNo"]);
                    model.IssuedDate = Convert.ToDateTime(dt.Rows[0]["IssuedDate"]);
                    model.ExpiryDate = Convert.ToDateTime(dt.Rows[0]["ExpiryDate"] != DBNull.Value ? (Convert.ToDateTime(dt.Rows[0]["ExpiryDate"])) : (DateTime?)null);
                    model.Status = Convert.ToInt32(dt.Rows[0]["Status"]);
                    model.GuId = Convert.ToString(dt.Rows[0]["GuId"]);

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
                        cmd.CommandText = "LLSWeighingScaleMst_GetAll";

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
                parameters.Add("@Id", Id.ToString());
                parameters.Add("@ModifiedBy", _UserSession.UserId.ToString());
                DataTable dt = dbAccessDAL.GetMASTERDataTable("LLSWeighingScaleMst_Delete", parameters, DataSetparameters);
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
        public bool IsWeighingCodeDuplicate(WeighingScaleEquipmentModel model)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(IsWeighingCodeDuplicate), Level.Info.ToString());
                List<LweighingLinenItemList> LweighingLinenItemGridList = new List<LweighingLinenItemList>();
                //LweighingLinenItemGridList.AddRange(model.LweighingLinenItemGridList);
                //string SerialNo = "";
                //foreach (var jjj in LweighingLinenItemGridList)
                //{
                //    SerialNo = jjj.SerialNo;
                //}
                var IsDuplicate = true;
                var dbAccessDAL = new BEMSDBAccessDAL();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@Id", model.WeighingScaleId.ToString());
                parameters.Add("@pCustomerId", Convert.ToString(_UserSession.CustomerId));
                parameters.Add("@pFacilityId", Convert.ToString(_UserSession.FacilityId));
                parameters.Add("@SerialNo", model.SerialNo.ToString());
                DataTable dt = dbAccessDAL.GetDataTable("LLSWeighingScaleMst_ValCode", parameters, DataSetparameters);
                if (dt != null && dt.Rows.Count > 0)
                {
                    IsDuplicate = Convert.ToBoolean(dt.Rows[0]["IsDuplicate"]);
                }
                Log4NetLogger.LogExit(_FileName, nameof(IsWeighingCodeDuplicate), Level.Info.ToString());
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
        public bool IsRecordModified(WeighingScaleEquipmentModel model)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(IsRecordModified), Level.Info.ToString());

                var recordModifed = false;

                if (model.WeighingScaleId != 0)
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
                            cmd.Parameters.AddWithValue("Id", model.WeighingScaleId);
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

