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
using CP.UETrack.DAL.DataAccess.Contracts.BEMS;
using CP.UETrack.Model.BEMS;

namespace CP.UETrack.DAL.DataAccess.Implementations.BEMS
{
    public class EODParameterMappingDAL : IEODParameterMappingDAL
    {
        private readonly string _FileName = nameof(EODParameterMappingDAL);
        readonly UserDetailsModel _UserSession = new SessionHelper().UserSession();

        public EODParameterMappingDAL()
        {

        }

        public EODTpeCodeMapDropdownValues Load()
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
                EODTpeCodeMapDropdownValues EODParamMapDropdown = null;

                var ds = new DataSet();
                var ds1 = new DataSet();
                var ds2 = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_Dropdown_Others  ";
                        cmd.Parameters.AddWithValue("@pTableName", "EngEODParameterMapping");
                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);

                        var da1 = new SqlDataAdapter();
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_Dropdown";
                        cmd.Parameters.Clear();
                        cmd.Parameters.AddWithValue("@pLovKey", "FieldTypeValue");
                        da1.SelectCommand = cmd;
                        da1.Fill(ds1);

                        var da2 = new SqlDataAdapter();
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_Dropdown";
                        cmd.Parameters.Clear();
                        cmd.Parameters.AddWithValue("@pLovKey", "ParameterMappingFrequencyValue");
                        da2.SelectCommand = cmd;
                        da2.Fill(ds2);
                    }
                }

                EODParamMapDropdown = new EODTpeCodeMapDropdownValues();
                if (ds.Tables.Count != 0)
                {                    
                    EODParamMapDropdown.ServiceLovs = dbAccessDAL.GetLovRecords(ds.Tables[0]);
                    EODParamMapDropdown.CategorySystem = dbAccessDAL.GetLovRecords(ds.Tables[1]);
                    EODParamMapDropdown.UOM = dbAccessDAL.GetLovRecords(ds.Tables[2]);
                    EODParamMapDropdown.Status = dbAccessDAL.GetLovRecords(ds.Tables[3]);
                }
                if (ds1.Tables.Count != 0)
                {
                    EODParamMapDropdown.DataType = dbAccessDAL.GetLovRecords(ds1.Tables[0]);
                }
                if (ds2.Tables.Count != 0)
                {
                    EODParamMapDropdown.Frequency = dbAccessDAL.GetLovRecords(ds2.Tables[0]);
                }

                Log4NetLogger.LogExit(_FileName, nameof(Load), Level.Info.ToString());
                return EODParamMapDropdown;
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
        public EODParameterMapping Save(EODParameterMapping EODParamCodeMapping, out string ErrorMessage)
        {
            try
            {
                ErrorMessage = string.Empty;
                Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());
                EODParameterMapping griddata = new EODParameterMapping();
                var dbAccessDAL = new DBAccessDAL();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pParameterMappingId", Convert.ToString(EODParamCodeMapping.ParameterMappingId));
                parameters.Add("@pCustomerId", Convert.ToString(_UserSession.CustomerId));
                parameters.Add("@pFacilityId", Convert.ToString(_UserSession.FacilityId));
                parameters.Add("@pServiceId", Convert.ToString(2));
                parameters.Add("@pAssetClassificationId", Convert.ToString(EODParamCodeMapping.AssetClassificationId));
                parameters.Add("@pAssetTypeCodeId", Convert.ToString(EODParamCodeMapping.AssetTypeCodeId));
                parameters.Add("@pManufacturerId", Convert.ToString(EODParamCodeMapping.ManufacturerId));
                parameters.Add("@pModelId", Convert.ToString(EODParamCodeMapping.ModelId));
                parameters.Add("@pUserId", Convert.ToString(_UserSession.UserId));
                parameters.Add("@pTimestamp", Convert.ToString(EODParamCodeMapping.Timestamp));
                parameters.Add("@pFrequencyLovId", Convert.ToString(EODParamCodeMapping.Frequency));

                var DataSetparameters = new Dictionary<string, DataTable>();
                DataTable dt = new DataTable();
                dt.Columns.Add("ParameterMappingDetId", typeof(int));
                dt.Columns.Add("ParameterMappingId", typeof(int));
                dt.Columns.Add("Parameter", typeof(string));
                dt.Columns.Add("Standard", typeof(string));
                dt.Columns.Add("UOMId", typeof(int));
                dt.Columns.Add("DataTypeLovId", typeof(int));
                dt.Columns.Add("DataValue", typeof(string));
                dt.Columns.Add("Minimum", typeof(decimal));
                dt.Columns.Add("Maximum", typeof(decimal));
                dt.Columns.Add("FrequencyLovId", typeof(int));
                dt.Columns.Add("EffectiveFrom", typeof(DateTime));
                dt.Columns.Add("EffectiveFromUTC", typeof(DateTime));
                dt.Columns.Add("EffectiveTo", typeof(DateTime));
                dt.Columns.Add("EffectiveToUTC", typeof(DateTime));
                dt.Columns.Add("Remarks", typeof(string));
                dt.Columns.Add("StatusId", typeof(int));
                

                var deletedId = EODParamCodeMapping.EODParameterMappingGridData.Where(y => y.IsDeleted).Select(x => x.ParameterMappingDetId).ToList();
                var idstring = string.Empty;
                if (deletedId.Count() > 0)
                {
                    foreach (var item in deletedId.Select((value, i) => new { i, value }))
                    {
                        idstring += item.value;
                        if (item.i != deletedId.Count() - 1)
                        { idstring += ","; }
                    }
                    deleteChildrecords(idstring);
                }

                foreach (var i in EODParamCodeMapping.EODParameterMappingGridData.Where(y => !y.IsDeleted))
                {
                    dt.Rows.Add(i.ParameterMappingDetId, i.ParameterMappingId, i.parameter, i.Standard, i.UomId,i.DatatypeId, i.AlphanumDropdown, i.Min, i.max,
                        i.FrequencyId, i.EffectiveFrom, i.EffectiveFrom, i.EffectiveTo, i.EffectiveTo,i.Remarks, i.StatusId);
                }

                DataSetparameters.Add("@EngEODParameterMappingDet", dt);
                DataTable dt1 = dbAccessDAL.GetDataTable("uspFM_EngEODParameterMapping_Save", parameters, DataSetparameters);
                if (dt1 != null)
                {
                    foreach (DataRow row in dt1.Rows)
                    {
                        EODParamCodeMapping.ParameterMappingId = Convert.ToInt32(row["ParameterMappingId"]);
                        EODParamCodeMapping.Timestamp = Convert.ToBase64String((byte[])(row["Timestamp"]));
                        ErrorMessage = Convert.ToString(row["ErrorMessage"]);
                    }
                }
                //EODParamCodeMapping = Get(EODParamCodeMapping.ParameterMappingId, 5, 1);
                Log4NetLogger.LogExit(_FileName, nameof(Save), Level.Info.ToString());
                return EODParamCodeMapping;
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

                var QueryCondition = pageFilter.QueryWhereCondition;
                var strCondition = string.Empty;
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
                        cmd.CommandText = "uspFM_EngEODParameterMapping_GetAll";

                        cmd.Parameters.AddWithValue("@PageIndex", pageFilter.PageIndex);
                        cmd.Parameters.AddWithValue("@PageSize", pageFilter.PageSize);
                        cmd.Parameters.AddWithValue("@strCondition", strCondition);
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
                //return EODTypeCodeMappings;
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
        public EODParameterMapping Get(int Id, int pagesize, int pageindex)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
            try
            {
                var dbAccessDAL = new DBAccessDAL();
                EODParameterMapping entity = new EODParameterMapping();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                //parameters.Add("@pUserId", Convert.ToString(_UserSession.UserId));
                parameters.Add("@pParameterMappingId", Id.ToString());
                parameters.Add("@pPageIndex", pageindex.ToString());
                parameters.Add("@pPageSize", pagesize.ToString());
                DataSet ds = dbAccessDAL.GetDataSet("uspFM_EngEODParameterMapping_GetById", parameters, DataSetparameters);
                if (ds != null )
                {
                    if (ds.Tables[0] != null && ds.Tables[0].Rows.Count > 0)
                    {
                        entity.ParameterMappingId = Convert.ToInt16(ds.Tables[0].Rows[0]["ParameterMappingId"]);
                       // entity.CustomerId = Convert.ToInt16(ds.Tables[0].Rows[0]["CustomerId"]);
                        //entity.FacilityId = Convert.ToInt32(ds.Tables[0].Rows[0]["FacilityId"]);
                        entity.ServiceId = Convert.ToInt32(ds.Tables[0].Rows[0]["ServiceId"]);
                        entity.ServiceName = Convert.ToString(ds.Tables[0].Rows[0]["ServiceName"]);
                        //entity.CategorySystemId = Convert.ToInt16(ds.Tables[0].Rows[0]["CategorySystemId"]);
                        //entity.CategorySystemName = Convert.ToString(ds.Tables[0].Rows[0]["CategorySystemName"]);
                        entity.AssetClassificationId = Convert.ToInt16(ds.Tables[0].Rows[0]["AssetClassificationId"]);
                        entity.AssetClassification = Convert.ToString(ds.Tables[0].Rows[0]["AssetClassificationCode"]);
                        entity.AssetTypeCodeId = Convert.ToInt16(ds.Tables[0].Rows[0]["AssetTypeCodeId"]);
                        entity.AssetTypeCodeDesc = Convert.ToString(ds.Tables[0].Rows[0]["AssetTypeDescription"]);
                        entity.AssetTypeCode = Convert.ToString(ds.Tables[0].Rows[0]["AssetTypeCode"]);
                        entity.ManufacturerId = Convert.ToInt32(ds.Tables[0].Rows[0]["ManufacturerId"]);
                        entity.Manufacturer = Convert.ToString(ds.Tables[0].Rows[0]["Manufacturer"]);
                        entity.ModelId = Convert.ToInt32(ds.Tables[0].Rows[0]["ModelId"]);
                        entity.Model = Convert.ToString(ds.Tables[0].Rows[0]["Model"]);
                        entity.Frequency = ds.Tables[0].Rows[0].Field<int?>("FrequencyLovId");
                        entity.Timestamp = Convert.ToBase64String((byte[])(ds.Tables[0].Rows[0]["Timestamp"]));
                    }

                    entity.EODParameterMappingGridData = (from n in ds.Tables[1].AsEnumerable()
                                                         select new EODParameterMappingGrid
                                                         {
                                                             ParameterMappingDetId = Convert.ToInt16(n["ParameterMappingDetId"]),
                                                             ParameterMappingId = Convert.ToInt16(n["ParameterMappingId"]),
                                                             parameter = Convert.ToString(n["Parameter"]),
                                                             Standard = Convert.ToString(n["Standard"]),
                                                            // UomId = Convert.ToInt16(n["UOMId"]),
                                                             UomId = n.Field<int?>("UOMId"),
                                                             UOM = Convert.ToString(n["UnitOfMeasurement"]),
                                                             DatatypeId = Convert.ToInt16(n["DataTypeLovId"]),
                                                             DataType = Convert.ToString(n["DataType"]),
                                                             AlphanumDropdown = Convert.ToString(n["DataValue"]),

                                                             //Min = Convert.ToDecimal(n["Minimum"] == DBNull.Value ? 0 : (Convert.ToDecimal(n["Minimum"]))),
                                                             //max = Convert.ToDecimal(n["Maximum"] == DBNull.Value ? 0 : (Convert.ToDecimal(n["Maximum"]))) ,
                                                             Min = n.Field<decimal?>("Minimum"),
                                                             max = n.Field<decimal?>("Maximum"),
                                                             //FrequencyId = Convert.ToInt16(n["FrequencyLovId"]),
                                                             FrequencyId = n.Field<int?>("FrequencyLovId"),
                                                             Frequency = Convert.ToString(n["FrequencyValue"]),
                                                             EffectiveFrom = Convert.ToDateTime(n["EffectiveFrom"]),
                                                             //EffectiveTo = Convert.ToDateTime(n["EffectiveTo"] != DBNull.Value ? (Convert.ToDateTime(n["EffectiveTo"])) : (DateTime?)null),
                                                             //EffectiveTo = n.Field<DateTime?>("EffectiveTo"),
                                                             StatusId = n.Field<int?>("StatusId"),
                                                             Remarks = Convert.ToString(n["Remarks"]),
                                                             Isreferenced=Convert.ToBoolean(n["IsReferenced"]),
                                                             IsEffectiveDateFilled = Convert.ToBoolean(n["IsEffectiveTo"]),

                                                             TotalRecords = Convert.ToInt32(n["TotalRecords"]),
                                                             TotalPages = Convert.ToInt32(n["TotalPageCalc"]),
                                                         }).ToList();

                    entity.EODParameterMappingGridData.ForEach((x) =>
                    {
                        x.IsEffectiveDateNull = (x.EffectiveTo == default(DateTime));
                        x.PageIndex = pageindex;
                        x.FirstRecord = ((pageindex - 1) * pagesize) + 1;
                        x.LastRecord = ((pageindex - 1) * pagesize) + pagesize;

                        //x.CategorySystemId = Id;
                    });
                    entity.ParameterMappingId = Id;

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
        public bool IsRoleDuplicate(EODParameterMapping EODParamCodeMapping)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(IsRoleDuplicate), Level.Info.ToString());

                var isDuplicate = true;
                string constring = ConfigurationManager.ConnectionStrings["UETrackConnectionString"].ConnectionString;
                using (SqlConnection con = new SqlConnection(constring))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "IsRoleDuplicate";
                        cmd.Parameters.AddWithValue("@Id", EODParamCodeMapping.CategorySystemId);
                        cmd.Parameters.AddWithValue("@Name", EODParamCodeMapping.CategorySystemName);
                        cmd.Parameters.Add("@IsDuplicate", SqlDbType.Bit);
                        cmd.Parameters["@IsDuplicate"].Direction = ParameterDirection.Output;

                        con.Open();
                        cmd.ExecuteNonQuery();
                        con.Close();
                        bool.TryParse(cmd.Parameters["@IsDuplicate"].Value.ToString(), out isDuplicate);
                    }
                }

                Log4NetLogger.LogExit(_FileName, nameof(IsRoleDuplicate), Level.Info.ToString());
                return isDuplicate;
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
        public bool IsRecordModified(EODParameterMapping EODParamCodeMapping)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(IsRecordModified), Level.Info.ToString());

                var recordModifed = false;

                if (EODParamCodeMapping.CategorySystemId != 0)
                {
                    var ds = new DataSet();
                    string constring = ConfigurationManager.ConnectionStrings["UETrackConnectionString"].ConnectionString;
                    using (SqlConnection con = new SqlConnection(constring))
                    {
                        using (SqlCommand cmd = new SqlCommand())
                        {
                            cmd.Connection = con;
                            cmd.CommandType = CommandType.StoredProcedure;
                            cmd.CommandText = "GetEODTypeCodeMappingTimestamp";
                            cmd.Parameters.AddWithValue("Id", EODParamCodeMapping.CategorySystemId);
                            var da = new SqlDataAdapter();
                            da.SelectCommand = cmd;
                            da.Fill(ds);
                        }
                    }
                    if (ds.Tables.Count != 0 && ds.Tables[0].Rows.Count > 0)
                    {
                        var timestamp = Convert.ToBase64String((byte[])(ds.Tables[0].Rows[0]["Timestamp"]));
                        if (timestamp != EODParamCodeMapping.Timestamp)
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
        public void Delete(int Id, out string ErrorMessage)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Delete), Level.Info.ToString());
            try
            {

                ErrorMessage = string.Empty;
                var dbAccessDAL = new DBAccessDAL();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pParameterMappingId", Id.ToString());
                DataTable dt = dbAccessDAL.GetDataTable("uspFM_EngEODParameterMapping_Delete", parameters, DataSetparameters);
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
                        cmd.CommandText = "uspFM_EngEODParameterMappingDet_Delete";
                        cmd.Parameters.AddWithValue("@pParameterMappingDetId", id);

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

        public EODParameterMapping GetHistory(int Id)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(GetHistory), Level.Info.ToString());
            try
            {
                var dbAccessDAL = new DBAccessDAL();
                EODParameterMapping entity = new EODParameterMapping();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                //parameters.Add("@pUserId", Convert.ToString(_UserSession.UserId));
                parameters.Add("@pParameterMappingId", Id.ToString());
                //parameters.Add("@pPageIndex", pageindex.ToString());
                //parameters.Add("@pPageSize", pagesize.ToString());
                DataSet ds = dbAccessDAL.GetDataSet("uspFM_EngEODParameterMappingHistory_GetById", parameters, DataSetparameters);
                if (ds != null)
                {
                    if (ds.Tables[0] != null && ds.Tables[0].Rows.Count > 0)
                    {
                        entity.ParameterMappingId = Convert.ToInt16(ds.Tables[0].Rows[0]["ParameterMappingId"]);
                        // entity.CustomerId = Convert.ToInt16(ds.Tables[0].Rows[0]["CustomerId"]);
                        //entity.FacilityId = Convert.ToInt32(ds.Tables[0].Rows[0]["FacilityId"]);
                        entity.ServiceId = Convert.ToInt32(ds.Tables[0].Rows[0]["ServiceId"]);
                        entity.ServiceName = Convert.ToString(ds.Tables[0].Rows[0]["ServiceName"]);
                        //entity.CategorySystemId = Convert.ToInt16(ds.Tables[0].Rows[0]["CategorySystemId"]);
                        //entity.CategorySystemName = Convert.ToString(ds.Tables[0].Rows[0]["CategorySystemName"]);
                        entity.AssetClassificationId = Convert.ToInt16(ds.Tables[0].Rows[0]["AssetClassificationId"]);
                        entity.AssetClassification = Convert.ToString(ds.Tables[0].Rows[0]["AssetClassificationDescription"]);
                        entity.AssetTypeCodeId = Convert.ToInt16(ds.Tables[0].Rows[0]["AssetTypeCodeId"]);
                        entity.AssetTypeCodeDesc = Convert.ToString(ds.Tables[0].Rows[0]["AssetTypeDescription"]);
                        entity.AssetTypeCode = Convert.ToString(ds.Tables[0].Rows[0]["AssetTypeCode"]);
                        entity.ManufacturerId = Convert.ToInt32(ds.Tables[0].Rows[0]["ManufacturerId"]);
                        entity.Manufacturer = Convert.ToString(ds.Tables[0].Rows[0]["Manufacturer"]);
                        entity.ModelId = Convert.ToInt32(ds.Tables[0].Rows[0]["ModelId"]);
                        entity.Model = Convert.ToString(ds.Tables[0].Rows[0]["Model"]);
                        entity.Frequency = ds.Tables[0].Rows[0].Field<int?>("FrequencyLovId");
                        entity.Timestamp = Convert.ToBase64String((byte[])(ds.Tables[0].Rows[0]["Timestamp"]));
                    }

                    entity.EODParameterMappingGridData = (from n in ds.Tables[1].AsEnumerable()
                                                          select new EODParameterMappingGrid
                                                          {
                                                              ParameterMappingDetId = Convert.ToInt16(n["ParameterMappingDetId"]),
                                                              ParameterMappingId = Convert.ToInt16(n["ParameterMappingId"]),
                                                              parameter = Convert.ToString(n["Parameter"]),
                                                              Standard = Convert.ToString(n["Standard"]),
                                                              // UomId = Convert.ToInt16(n["UOMId"]),
                                                              UomId = n.Field<int?>("UOMId"),
                                                              UOM = Convert.ToString(n["UnitOfMeasurement"]),
                                                              DatatypeId = Convert.ToInt16(n["DataTypeLovId"]),
                                                              DataType = Convert.ToString(n["DataType"]),
                                                              AlphanumDropdown = Convert.ToString(n["DataValue"]),

                                                              //Min = Convert.ToDecimal(n["Minimum"] == DBNull.Value ? 0 : (Convert.ToDecimal(n["Minimum"]))),
                                                              //max = Convert.ToDecimal(n["Maximum"] == DBNull.Value ? 0 : (Convert.ToDecimal(n["Maximum"]))) ,
                                                              Min = n.Field<decimal?>("Minimum"),
                                                              max = n.Field<decimal?>("Maximum"),
                                                              //FrequencyId = Convert.ToInt16(n["FrequencyLovId"]),
                                                              FrequencyId = n.Field<int?>("FrequencyLovId"),
                                                              Frequency = Convert.ToString(n["FrequencyValue"]),
                                                              EffectiveFrom = Convert.ToDateTime(n["EffectiveFrom"]),
                                                              //EffectiveTo = Convert.ToDateTime(n["EffectiveTo"] != DBNull.Value ? (Convert.ToDateTime(n["EffectiveTo"])) : (DateTime?)null),
                                                              //EffectiveTo = n.Field<DateTime?>("EffectiveTo"),
                                                              StatusId = n.Field<int?>("StatusId"),
                                                              Status = n.Field<string>("Status"),
                                                              Remarks = Convert.ToString(n["Remarks"]),
                                                              Isreferenced = Convert.ToBoolean(n["IsReferenced"]),
                                                              IsEffectiveDateFilled = Convert.ToBoolean(n["IsEffectiveTo"]),
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
    }
}
