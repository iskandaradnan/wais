using CP.UETrack.Model;
using System;
using System.Linq;
using CP.Framework.Common.Logging;
using CP.Framework.Common.ExceptionHandler.ExceptionWrappers;
using System.Data;
using System.Data.SqlClient;
using UETrack.DAL;
using CP.UETrack.DAL.DataAccess.Implementation;

namespace CP.UETrack.DAL.DataAccess
{
    public class AdditionalFieldsDAL : IAdditionalFieldsDAL
    {
        private readonly string _FileName = nameof(AdditionalFieldsDAL);
        readonly UserDetailsModel _UserSession = new SessionHelper().UserSession();
        public AdditionalFieldsLovs Load()
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
                AdditionalFieldsLovs additionalFieldsLovs = null;
                var ds1 = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        var da1 = new SqlDataAdapter();
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_Dropdown";
                        cmd.Parameters.Clear();
                        cmd.Parameters.AddWithValue("@pLovKey", "ConfigScreenNameValue,YesNoValue,ConfigFieldTypeValue,ConfigPatternValue");
                        da1.SelectCommand = cmd;
                        da1.Fill(ds1);

                    }
                }
                additionalFieldsLovs = new AdditionalFieldsLovs();
                if (ds1.Tables.Count != 0)
                {

                    additionalFieldsLovs.ConfigScreenNameValues = dbAccessDAL.GetLovRecords(ds1.Tables[0], "ConfigScreenNameValue");
                    additionalFieldsLovs.YesNoValues = dbAccessDAL.GetLovRecords(ds1.Tables[0], "YesNoValue");
                    additionalFieldsLovs.FieldTypeValues = dbAccessDAL.GetLovRecords(ds1.Tables[0], "ConfigFieldTypeValue");
                    additionalFieldsLovs.ConfigPatternValues = dbAccessDAL.GetLovRecords(ds1.Tables[0], "ConfigPatternValue");
                }
                Log4NetLogger.LogExit(_FileName, nameof(Load), Level.Info.ToString());
                return additionalFieldsLovs;
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
        public AdditionalFieldsConfig Save(AdditionalFieldsConfig AdditionalFieldsConfig, out string ErrorMessage)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());

                ErrorMessage = string.Empty;
                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_FMAddFieldConfig_Save";

                        SqlParameter parameter = new SqlParameter();

                        if (AdditionalFieldsConfig.additionalFields != null)
                        {
                            DataTable dataTable = new DataTable("udt_FMAddFieldConfig");
                            dataTable.Columns.Add("AddFieldConfigId", typeof(int));
                            dataTable.Columns.Add("CustomerId", typeof(int));
                            dataTable.Columns.Add("ScreenNameLovId", typeof(int));
                            dataTable.Columns.Add("FieldTypeLovId", typeof(int));
                            dataTable.Columns.Add("FieldName", typeof(string));
                            dataTable.Columns.Add("Name", typeof(string));
                            dataTable.Columns.Add("DropDownValues", typeof(string));
                            dataTable.Columns.Add("RequiredLovId", typeof(int));
                            dataTable.Columns.Add("PatternLovId", typeof(int));
                            dataTable.Columns.Add("MaxLength", typeof(int));
                            dataTable.Columns.Add("UserId", typeof(int));
                            dataTable.Columns.Add("IsDeleted", typeof(bool));
                            cmd.Parameters.Add("@pErrorMessage", SqlDbType.NVarChar);
                            cmd.Parameters["@pErrorMessage"].Size = 1000;
                            cmd.Parameters["@pErrorMessage"].Direction = ParameterDirection.Output;

                            foreach (var item in AdditionalFieldsConfig.additionalFields)
                            {
                                dataTable.Rows.Add(item.AddFieldConfigId, item.CustomerId, item.ScreenNameLovId, item.FieldTypeLovId, item.FieldName,
                                                    item.Name, item.DropDownValues, item.RequiredLovId, item.PatternLovId, item.MaxLength, 
                                                    _UserSession.UserId, item.IsDeleted);
                            }

                            parameter.ParameterName = "@pFMAddFieldConfig";
                            parameter.SqlDbType = SqlDbType.Structured;
                            parameter.Value = dataTable;
                            cmd.Parameters.Add(parameter);
                        }

                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                        ErrorMessage = cmd.Parameters["@pErrorMessage"].Value.ToString();
                    }
                }
                if (ds.Tables.Count != 0 && ds.Tables[0].Rows.Count > 0)
                {
                    AdditionalFieldsConfig.additionalFields = (from n in ds.Tables[0].AsEnumerable()
                                                               select new AdditionalFields
                                                               {
                                                                   AddFieldConfigId = n.Field<int>("AddFieldConfigId"),
                                                                   FieldTypeLovId = n.Field<int>("FieldTypeLovId"),
                                                                   Name = n.Field<string>("Name"),
                                                                   DropDownValues = n.Field<string>("DropDownValues"),
                                                                   RequiredLovId = n.Field<int>("RequiredLovId"),
                                                                   PatternLovId = n.Field<int?>("PatternLovId"),
                                                                   MaxLength = n.Field<int?>("MaxLength"),
                                                                   IsUsed = n.Field<bool>("IsUsed")
                                                               }).ToList();
                }

                Log4NetLogger.LogExit(_FileName, nameof(Save), Level.Info.ToString());
                return AdditionalFieldsConfig;
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

                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_Test_GetAll";

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
        public AdditionalFieldsConfig Get(int CustomerId, int ScreenId)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
                var additionalFieldsConfig = new AdditionalFieldsConfig();

                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_FMAddFieldConfig_GetById";
                        cmd.Parameters.AddWithValue("@pCustomerId", CustomerId);
                        cmd.Parameters.AddWithValue("@pScreenNameLovId", ScreenId);
                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }
                if (ds.Tables.Count != 0 && ds.Tables[0].Rows.Count > 0)
                {
                    additionalFieldsConfig.additionalFields = (from n in ds.Tables[0].AsEnumerable()
                                                               select new AdditionalFields
                                                               {
                                                                   AddFieldConfigId = n.Field<int>("AddFieldConfigId"),
                                                                   FieldTypeLovId = n.Field<int>("FieldTypeLovId"),
                                                                   Name = n.Field<string>("Name"),
                                                                   FieldName = n.Field<string>("FieldName"),
                                                                   DropDownValues = n.Field<string>("DropDownValues"),
                                                                   RequiredLovId = n.Field<int>("RequiredLovId"),
                                                                   PatternLovId = n.Field<int?>("PatternLovId"),
                                                                   MaxLength = n.Field<int?>("MaxLength"),
                                                                   PatternValue = n.Field<string>("PatternValue"),
                                                                   IsUsed = n.Field<bool>("IsUsed")
                                                               }).ToList();
                }
                Log4NetLogger.LogExit(_FileName, nameof(Get), Level.Info.ToString());
                return additionalFieldsConfig;
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
        public void Delete(int Id)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Delete), Level.Info.ToString());

                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_Test_Delete";
                        cmd.Parameters.AddWithValue("@pAddFieldConfigId", Id);

                        con.Open();
                        cmd.ExecuteNonQuery();
                        con.Close();
                    }
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
        public AssetRegisterAdditionalFields GetAdditionalInfoForAsset (int AssetId)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(GetAdditionalInfoForAsset), Level.Info.ToString());
                var additionalFields = new AssetRegisterAdditionalFields();

                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_EngAssetAddFields_GetById";
                        cmd.Parameters.AddWithValue("@pAssetId", AssetId);
                        
                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }
                if (ds.Tables.Count != 0 && ds.Tables[0].Rows.Count > 0)
                {
                    additionalFields = (from n in ds.Tables[0].AsEnumerable()
                                        select new AssetRegisterAdditionalFields
                                        {
                                            AssetId = AssetId,
                                            Field1 = n.Field<string>("Field1"),
                                            Field2 = n.Field<string>("Field2"),
                                            Field3 = n.Field<string>("Field3"),
                                            Field4 = n.Field<string>("Field4"),
                                            Field5 = n.Field<string>("Field5"),
                                            Field6 = n.Field<string>("Field6"),
                                            Field7 = n.Field<string>("Field7"),
                                            Field8 = n.Field<string>("Field8"),
                                            Field9 = n.Field<string>("Field9"),
                                            Field10 = n.Field<string>("Field10"),
                                        }).FirstOrDefault();
                }
                Log4NetLogger.LogExit(_FileName, nameof(GetAdditionalInfoForAsset), Level.Info.ToString());
                return additionalFields;
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
        public AssetRegisterAdditionalFields SaveAdditionalInfoForAsset(AssetRegisterAdditionalFields AdditionalInfo, out string ErrorMessage)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());

                ErrorMessage = string.Empty;
                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_EngAssetAddFields_Save";

                        SqlParameter parameter = new SqlParameter();
                        cmd.Parameters.AddWithValue("@pAssetId", AdditionalInfo.AssetId);
                        cmd.Parameters.AddWithValue("@pField1", AdditionalInfo.Field1);
                        cmd.Parameters.AddWithValue("@pField2", AdditionalInfo.Field2);
                        cmd.Parameters.AddWithValue("@pField3", AdditionalInfo.Field3);
                        cmd.Parameters.AddWithValue("@pField4", AdditionalInfo.Field4);
                        cmd.Parameters.AddWithValue("@pField5", AdditionalInfo.Field5);
                        cmd.Parameters.AddWithValue("@pField6", AdditionalInfo.Field6);
                        cmd.Parameters.AddWithValue("@pField7", AdditionalInfo.Field7);
                        cmd.Parameters.AddWithValue("@pField8", AdditionalInfo.Field8);
                        cmd.Parameters.AddWithValue("@pField9", AdditionalInfo.Field9);
                        cmd.Parameters.AddWithValue("@pField10", AdditionalInfo.Field10);

                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }
                Log4NetLogger.LogExit(_FileName, nameof(Save), Level.Info.ToString());
                return AdditionalInfo;
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
        public TestingAndCommissioningAdditionalFields GetAdditionalInfoForTAndC(int TestingandCommissioningId)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(GetAdditionalInfoForTAndC), Level.Info.ToString());
                var additionalFields = new TestingAndCommissioningAdditionalFields();

                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_TandCAddFields_GetById";
                        cmd.Parameters.AddWithValue("@pTestingandCommissioningId", TestingandCommissioningId);

                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }
                if (ds.Tables.Count != 0 && ds.Tables[0].Rows.Count > 0)
                {
                    additionalFields = (from n in ds.Tables[0].AsEnumerable()
                                        select new TestingAndCommissioningAdditionalFields
                                        {
                                            TestingandCommissioningId = TestingandCommissioningId,
                                            Field1 = n.Field<string>("Field1"),
                                            Field2 = n.Field<string>("Field2"),
                                            Field3 = n.Field<string>("Field3"),
                                            Field4 = n.Field<string>("Field4"),
                                            Field5 = n.Field<string>("Field5"),
                                            Field6 = n.Field<string>("Field6"),
                                            Field7 = n.Field<string>("Field7"),
                                            Field8 = n.Field<string>("Field8"),
                                            Field9 = n.Field<string>("Field9"),
                                            Field10 = n.Field<string>("Field10"),
                                        }).FirstOrDefault();
                }
                Log4NetLogger.LogExit(_FileName, nameof(GetAdditionalInfoForTAndC), Level.Info.ToString());
                return additionalFields;
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
        public TestingAndCommissioningAdditionalFields SaveAdditionalInfoTAndC(TestingAndCommissioningAdditionalFields AdditionalInfo, out string ErrorMessage)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());

                ErrorMessage = string.Empty;
                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_TandCAddFields_Save";

                        SqlParameter parameter = new SqlParameter();
                        cmd.Parameters.AddWithValue("@pTestingandCommissioningId", AdditionalInfo.TestingandCommissioningId);
                        cmd.Parameters.AddWithValue("@pField1", AdditionalInfo.Field1);
                        cmd.Parameters.AddWithValue("@pField2", AdditionalInfo.Field2);
                        cmd.Parameters.AddWithValue("@pField3", AdditionalInfo.Field3);
                        cmd.Parameters.AddWithValue("@pField4", AdditionalInfo.Field4);
                        cmd.Parameters.AddWithValue("@pField5", AdditionalInfo.Field5);
                        cmd.Parameters.AddWithValue("@pField6", AdditionalInfo.Field6);
                        cmd.Parameters.AddWithValue("@pField7", AdditionalInfo.Field7);
                        cmd.Parameters.AddWithValue("@pField8", AdditionalInfo.Field8);
                        cmd.Parameters.AddWithValue("@pField9", AdditionalInfo.Field9);
                        cmd.Parameters.AddWithValue("@pField10", AdditionalInfo.Field10);

                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }
                Log4NetLogger.LogExit(_FileName, nameof(Save), Level.Info.ToString());
                return AdditionalInfo;
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

        public workorderAdditionalFields GetAdditionalInfoForWorkorder(int WorkOrderId)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(GetAdditionalInfoForWorkorder), Level.Info.ToString());
                var additionalFields = new workorderAdditionalFields();

                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_WorkOrderAddFields_GetById";
                        cmd.Parameters.AddWithValue("@pWorkOrderId", WorkOrderId);

                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }
                if (ds.Tables.Count != 0 && ds.Tables[0].Rows.Count > 0)
                {
                    additionalFields = (from n in ds.Tables[0].AsEnumerable()
                                        select new workorderAdditionalFields
                                        {
                                            WorkOrderId = WorkOrderId,
                                            Field1 = n.Field<string>("Field1"),
                                            Field2 = n.Field<string>("Field2"),
                                            Field3 = n.Field<string>("Field3"),
                                            Field4 = n.Field<string>("Field4"),
                                            Field5 = n.Field<string>("Field5"),
                                            Field6 = n.Field<string>("Field6"),
                                            Field7 = n.Field<string>("Field7"),
                                            Field8 = n.Field<string>("Field8"),
                                            Field9 = n.Field<string>("Field9"),
                                            Field10 = n.Field<string>("Field10"),
                                        }).FirstOrDefault();
                }
                Log4NetLogger.LogExit(_FileName, nameof(GetAdditionalInfoForWorkorder), Level.Info.ToString());
                return additionalFields;
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
        public workorderAdditionalFields SaveAdditionalInfoWorkorder(workorderAdditionalFields AdditionalInfo, out string ErrorMessage)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());

                ErrorMessage = string.Empty;
                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_WorkOrderAddFields_Save";

                        SqlParameter parameter = new SqlParameter();
                        cmd.Parameters.AddWithValue("@pWorkOrderId", AdditionalInfo.WorkOrderId);
                        cmd.Parameters.AddWithValue("@pField1", AdditionalInfo.Field1);
                        cmd.Parameters.AddWithValue("@pField2", AdditionalInfo.Field2);
                        cmd.Parameters.AddWithValue("@pField3", AdditionalInfo.Field3);
                        cmd.Parameters.AddWithValue("@pField4", AdditionalInfo.Field4);
                        cmd.Parameters.AddWithValue("@pField5", AdditionalInfo.Field5);
                        cmd.Parameters.AddWithValue("@pField6", AdditionalInfo.Field6);
                        cmd.Parameters.AddWithValue("@pField7", AdditionalInfo.Field7);
                        cmd.Parameters.AddWithValue("@pField8", AdditionalInfo.Field8);
                        cmd.Parameters.AddWithValue("@pField9", AdditionalInfo.Field9);
                        cmd.Parameters.AddWithValue("@pField10", AdditionalInfo.Field10);

                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }
                Log4NetLogger.LogExit(_FileName, nameof(Save), Level.Info.ToString());
                return AdditionalInfo;
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