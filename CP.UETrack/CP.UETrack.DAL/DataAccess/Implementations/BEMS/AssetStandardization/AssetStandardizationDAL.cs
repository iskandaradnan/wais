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
    public class AssetStandardizationDAL : IAssetStandardizationDAL
    {
        private readonly string _FileName = nameof(AssetStandardizationDAL);
        readonly UserDetailsModel _UserSession = new SessionHelper().UserSession();
        
        public AssetStandardizationLovs Load()
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
                AssetStandardizationLovs assetStandardizationLovs = null;
                var ds = new DataSet();
                var ds1 = new DataSet();
                var da2 = new SqlDataAdapter();
                var dbAccessDAL = new DBAccessDAL();
                var srevicesDS = new DataSet();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_Dropdown_Others";
                        cmd.Parameters.AddWithValue("@pLovKey", "");
                        cmd.Parameters.AddWithValue("@pTableName", "Service");

                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                        var da1 = new SqlDataAdapter();
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_Dropdown";
                        cmd.Parameters.Clear();
                        cmd.Parameters.AddWithValue("@pLovKey", "StatusValue");
                        da1.SelectCommand = cmd;
                        da1.Fill(ds1);
                       
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_GetServices";
                        cmd.Parameters.Clear();
                        //  cmd.Parameters.AddWithValue("@UserRegistrationId", _UserSession.UserId);
                        da2.SelectCommand = cmd;
                        da2.Fill(srevicesDS);

                    }
                }
                assetStandardizationLovs = new AssetStandardizationLovs();
                //if (ds.Tables.Count != 0)
                //{
                //    assetStandardizationLovs.Services = dbAccessDAL.GetLovRecords(ds.Tables[0]);
                //}
                if (ds1.Tables.Count != 0)
                {

                    assetStandardizationLovs.Statuses = dbAccessDAL.GetLovRecords(ds1.Tables[0], "StatusValue");
                }
                if (srevicesDS.Tables.Count != 0)
                {

                    assetStandardizationLovs.Services = dbAccessDAL.GetLovRecords(srevicesDS.Tables[0]);
                }
                Log4NetLogger.LogExit(_FileName, nameof(Load), Level.Info.ToString());
                return assetStandardizationLovs;
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
        public AssetStandardization Save(AssetStandardization assetStandardization, out string ErrorMessage)
        {
            AssetStandardization assetStandardizationfems = assetStandardization;
            AssetStandardization assetStandardizationBems = assetStandardization;
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());
                ErrorMessage = string.Empty;
                var ds = new DataSet();
                var dss = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                var FEMSdbAccessDAL = new MASTERFEMSDBAccessDAL();
                var BEMSdbAccessDAL = new MASTERBEMSDBAccessDAL();
                var Master_typecode = 0;
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_EngAssetStandardization_Save";

                        SqlParameter parameter = new SqlParameter();
                        cmd.Parameters.AddWithValue("@pAssetStandardizationId", assetStandardization.AssetStandardizationId);
                        cmd.Parameters.AddWithValue("@pAssetTypeCodeId", assetStandardization.AssetTypeCodeId);
                        cmd.Parameters.AddWithValue("@pServiceId", assetStandardization.ServiceId);
                        cmd.Parameters.AddWithValue("@pManufacturerId", assetStandardization.ManufacturerId);
                        cmd.Parameters.AddWithValue("@pManufacturer", assetStandardization.Manufacturer);
                        cmd.Parameters.AddWithValue("@pModelId", assetStandardization.ModelId);
                        cmd.Parameters.AddWithValue("@pModel", assetStandardization.Model);
                        cmd.Parameters.AddWithValue("@pStatus", assetStandardization.StatusId);
                        cmd.Parameters.AddWithValue("@pUserId", _UserSession.UserId);
                        cmd.Parameters.AddWithValue("@pTimestamp", Convert.FromBase64String(assetStandardization.Timestamp));
                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(dss);
                    }
                }
                if (dss.Tables.Count != 0 && dss.Tables[0].Rows.Count > 0)
                {
                    ErrorMessage = Convert.ToString(dss.Tables[0].Rows[0]["ErrorMessage"]);
                    DataSet typc = new DataSet();
                    typc = Get_subtypecode(assetStandardization.AssetTypeCodeId);
                    assetStandardization.AssetTypeCodeId = Convert.ToInt32(typc.Tables[0].Rows[0]["AssetTypeCodeId_mappingTo_SeviceDB"]);
                    if(assetStandardization.ManufacturerId != 0)
                    {
                        typc = Get_subManufacturer(assetStandardization.ManufacturerId);
                        assetStandardization.ManufacturerId = Convert.ToInt32(typc.Tables[0].Rows[0]["ManufacturerId_mappingTo_SeviceDB"]);
                    }
                    //if (ErrorMessage == string.Empty)
                    //{
                    //    assetStandardization.AssetStandardizationId = Convert.ToInt32(ds.Tables[0].Rows[0]["AssetStandardizationId"]);
                    //    assetStandardization.Timestamp = Convert.ToBase64String((byte[])(ds.Tables[0].Rows[0]["Timestamp"]));
                    //    assetStandardization.ModelId = Convert.ToInt32(ds.Tables[0].Rows[0]["ModelId"]);
                    //    assetStandardization.ManufacturerId = Convert.ToInt32(ds.Tables[0].Rows[0]["ManufacturerId"]);
                    //}
                }
               //-----------Inserting to another DB-------------------//
                if (assetStandardization.ServiceId == 1)
                {
                    ds.Clear();
                    using (SqlConnection con = new SqlConnection(FEMSdbAccessDAL.ConnectionString))
                    {
                        using (SqlCommand cmd = new SqlCommand())
                        {
                            cmd.Connection = con;
                            cmd.CommandType = CommandType.StoredProcedure;
                            cmd.CommandText = "uspFM_EngAssetStandardization_Save";

                            SqlParameter parameter = new SqlParameter();
                            cmd.Parameters.AddWithValue("@pAssetStandardizationId", assetStandardization.AssetStandardizationId);
                            cmd.Parameters.AddWithValue("@pAssetTypeCodeId", assetStandardization.AssetTypeCodeId);
                            cmd.Parameters.AddWithValue("@pServiceId", assetStandardization.ServiceId);
                            cmd.Parameters.AddWithValue("@pManufacturerId", assetStandardization.ManufacturerId);
                            cmd.Parameters.AddWithValue("@pManufacturer", assetStandardization.Manufacturer);
                            cmd.Parameters.AddWithValue("@pModelId", assetStandardization.ModelId);
                            cmd.Parameters.AddWithValue("@pModel", assetStandardization.Model);
                            cmd.Parameters.AddWithValue("@pStatus", assetStandardization.StatusId);
                            cmd.Parameters.AddWithValue("@pUserId", _UserSession.UserId);
                            cmd.Parameters.AddWithValue("@pTimestamp", Convert.FromBase64String(assetStandardization.Timestamp));
                            var da = new SqlDataAdapter();
                            da.SelectCommand = cmd;
                            da.Fill(ds);
                        }
                    }
                    if (ds.Tables.Count != 0 && ds.Tables[0].Rows.Count > 0)
                    {
                        ErrorMessage = Convert.ToString(ds.Tables[0].Rows[0]["ErrorMessage"]);
                        //if (ErrorMessage == string.Empty)
                        //{
                        //    assetStandardization.AssetStandardizationId = Convert.ToInt32(ds.Tables[0].Rows[0]["AssetStandardizationId"]);
                        //    assetStandardization.Timestamp = Convert.ToBase64String((byte[])(ds.Tables[0].Rows[0]["Timestamp"]));
                        //    assetStandardization.ModelId = Convert.ToInt32(ds.Tables[0].Rows[0]["ModelId"]);
                        //    assetStandardization.ManufacturerId = Convert.ToInt32(ds.Tables[0].Rows[0]["ManufacturerId"]);
                        //}
                    }
                }
                if (assetStandardization.ServiceId == 2)
                {
                    using (SqlConnection con = new SqlConnection(BEMSdbAccessDAL.ConnectionString))
                    {
                        ds.Clear();
                        using (SqlCommand cmd = new SqlCommand())
                        {
                            cmd.Connection = con;
                            cmd.CommandType = CommandType.StoredProcedure;
                            cmd.CommandText = "uspFM_EngAssetStandardization_Save";

                            SqlParameter parameter = new SqlParameter();
                            cmd.Parameters.AddWithValue("@pAssetStandardizationId", assetStandardization.AssetStandardizationId);
                            cmd.Parameters.AddWithValue("@pAssetTypeCodeId", assetStandardization.AssetTypeCodeId);
                            cmd.Parameters.AddWithValue("@pServiceId", assetStandardization.ServiceId);
                            cmd.Parameters.AddWithValue("@pManufacturerId", assetStandardization.ManufacturerId);
                            cmd.Parameters.AddWithValue("@pManufacturer", assetStandardization.Manufacturer);
                            cmd.Parameters.AddWithValue("@pModelId", assetStandardization.ModelId);
                            cmd.Parameters.AddWithValue("@pModel", assetStandardization.Model);
                            cmd.Parameters.AddWithValue("@pStatus", assetStandardization.StatusId);
                            cmd.Parameters.AddWithValue("@pUserId", _UserSession.UserId);
                            cmd.Parameters.AddWithValue("@pTimestamp", Convert.FromBase64String(assetStandardization.Timestamp));
                            var da = new SqlDataAdapter();
                            da.SelectCommand = cmd;
                            da.Fill(ds);
                        }
                    }

                    
                }
                if (ds.Tables.Count != 0 && ds.Tables[0].Rows.Count > 0)
                {
                    DataSet upds = new DataSet();
                    ErrorMessage = Convert.ToString(ds.Tables[0].Rows[0]["ErrorMessage"]);
                    if (ErrorMessage == string.Empty)
                    {
                        using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                        {
                            using (SqlCommand cmd = new SqlCommand())
                            {
                                cmd.Connection = con;
                                cmd.CommandType = CommandType.StoredProcedure;
                                cmd.CommandText = "Master_Updae_EngAssetStandardization_mappingTo_SeviceDB";
                                SqlParameter parameter = new SqlParameter();
                                cmd.Parameters.AddWithValue("@EngAssetStandardization", ds.Tables[0].Rows[0]["AssetStandardizationId"]);
                                cmd.Parameters.AddWithValue("@Master_AssetStandardizationID", dss.Tables[0].Rows[0]["AssetStandardizationId"]);
                                cmd.Parameters.AddWithValue("@EngAssetStandardizationManf", ds.Tables[0].Rows[0]["ManufacturerId"]);
                                cmd.Parameters.AddWithValue("@EngAssetStandardizationModel", ds.Tables[0].Rows[0]["ModelId"]);
                                var da = new SqlDataAdapter();
                                da.SelectCommand = cmd;
                                da.Fill(upds);
                            }
                        }
                    }
                }
                if (dss.Tables.Count != 0 && dss.Tables[0].Rows.Count > 0)
                {
                    ErrorMessage = Convert.ToString(dss.Tables[0].Rows[0]["ErrorMessage"]);
                    if (ErrorMessage == string.Empty)
                    {
                        assetStandardization.AssetStandardizationId = Convert.ToInt32(dss.Tables[0].Rows[0]["AssetStandardizationId"]);
                        assetStandardization.Timestamp = Convert.ToBase64String((byte[])(dss.Tables[0].Rows[0]["Timestamp"]));
                        assetStandardization.ModelId = Convert.ToInt32(dss.Tables[0].Rows[0]["ModelId"]);
                        assetStandardization.ManufacturerId = Convert.ToInt32(dss.Tables[0].Rows[0]["ManufacturerId"]);
                    }
                }
                Log4NetLogger.LogExit(_FileName, nameof(Save), Level.Info.ToString());
                return assetStandardization;
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
                        cmd.CommandText = "uspFM_EngAssetStandardization_GetAll";

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
        public AssetStandardization Get(int Id)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
                AssetStandardization assetStandardization = null;

                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_EngAssetStandardization_GetById";
                        cmd.Parameters.AddWithValue("@pAssetStandardizationId", Id);
                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }
                if (ds.Tables.Count != 0 && ds.Tables[0].Rows.Count > 0)
                {
                    assetStandardization = (from n in ds.Tables[0].AsEnumerable()
                                            select new AssetStandardization
                                            {
                                                AssetStandardizationId = Convert.ToInt32((n["AssetStandardizationId"])),
                                                AssetTypeCodeId = Convert.ToInt32((n["AssetTypeCodeId"])),
                                                AssetTypeCode = n.Field<string>("AssetTypeCode"),
                                                AssetTypeDescription = n.Field<string>("AssetTypeDescription"),
                                                ServiceId = Convert.ToInt32((n["ServiceId"])),
                                                ManufacturerId = Convert.ToInt32((n["ManufacturerId"])),
                                                Manufacturer = n.Field<string>("Manufacturer"),
                                                ModelId = Convert.ToInt32((n["ModelId"])),
                                                Model = n.Field<string>("Model"),
                                                StatusId = Convert.ToInt32((n["Status"])),
                                                Timestamp = Convert.ToBase64String((byte[])(n["Timestamp"]))
                                            }).FirstOrDefault();
                }
                Log4NetLogger.LogExit(_FileName, nameof(Get), Level.Info.ToString());
                return assetStandardization;
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
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Delete), Level.Info.ToString());
                ErrorMessage = string.Empty;

                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_EngAssetStandardization_Delete";
                        cmd.Parameters.AddWithValue("@pAssetStandardizationId", Id);

                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }
                if (ds.Tables.Count != 0 && ds.Tables[0].Rows.Count > 0)
                {
                    ErrorMessage = ds.Tables[0].Rows[0][0].ToString();
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
        public bool IsManufacturerModelDuplicate(AssetStandardization assetStandardization)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(IsManufacturerModelDuplicate), Level.Info.ToString());

                var isDuplicate = true;
                if (assetStandardization.ManufacturerId != 0 && assetStandardization.ModelId != 0)
                {
                    var dbAccessDAL = new DBAccessDAL();
                    using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                    {
                        using (SqlCommand cmd = new SqlCommand())
                        {
                            cmd.Connection = con;
                            cmd.CommandType = CommandType.StoredProcedure;
                            cmd.CommandText = "uspFM_EngAssetStandardization_DuplicateCheck";
                            cmd.Parameters.AddWithValue("@pAssetStandardizationId", assetStandardization.AssetStandardizationId);
                            cmd.Parameters.AddWithValue("@pAssetTypeCodeId", assetStandardization.AssetTypeCodeId);
                            cmd.Parameters.AddWithValue("@pManufacturerId", assetStandardization.ManufacturerId);
                            cmd.Parameters.AddWithValue("@pModelId", assetStandardization.ModelId);
                            cmd.Parameters.Add("@IsDuplicate", SqlDbType.Bit);
                            cmd.Parameters["@IsDuplicate"].Direction = ParameterDirection.Output;

                            con.Open();
                            cmd.ExecuteNonQuery();
                            con.Close();
                            bool.TryParse(cmd.Parameters["@IsDuplicate"].Value.ToString(), out isDuplicate);
                        }
                    }
                }
                else
                {
                    isDuplicate = false;
                }
                Log4NetLogger.LogExit(_FileName, nameof(IsManufacturerModelDuplicate), Level.Info.ToString());
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
        public bool IsManufacturerDuplicate(AssetStandardization assetStandardization)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(IsManufacturerDuplicate), Level.Info.ToString());

                var isDuplicate = true;
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_Manufacturer_DuplicateCheck";
                        cmd.Parameters.AddWithValue("@pManufacturerId", assetStandardization.ManufacturerId);
                        cmd.Parameters.AddWithValue("@pManufacturer", assetStandardization.Manufacturer);

                        cmd.Parameters.Add("@IsDuplicate", SqlDbType.Bit);
                        cmd.Parameters["@IsDuplicate"].Direction = ParameterDirection.Output;

                        con.Open();
                        cmd.ExecuteNonQuery();
                        con.Close();
                        bool.TryParse(cmd.Parameters["@IsDuplicate"].Value.ToString(), out isDuplicate);
                    }
                }

                Log4NetLogger.LogExit(_FileName, nameof(IsManufacturerDuplicate), Level.Info.ToString());
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
        public bool IsModelDuplicate(AssetStandardization assetStandardization)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(IsManufacturerModelDuplicate), Level.Info.ToString());

                var isDuplicate = true;

                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_Model_DuplicateCheck";
                        cmd.Parameters.AddWithValue("@pModelId", assetStandardization.ModelId);
                        cmd.Parameters.AddWithValue("@pModel", assetStandardization.Model);

                        cmd.Parameters.Add("@IsDuplicate", SqlDbType.Bit);
                        cmd.Parameters["@IsDuplicate"].Direction = ParameterDirection.Output;

                        con.Open();
                        cmd.ExecuteNonQuery();
                        con.Close();
                        bool.TryParse(cmd.Parameters["@IsDuplicate"].Value.ToString(), out isDuplicate);
                    }
                }

                Log4NetLogger.LogExit(_FileName, nameof(IsManufacturerModelDuplicate), Level.Info.ToString());
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

        public DataSet Get_subtypecode(int Id)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
                AssetStandardization assetStandardization = null;

                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.Text;
                        cmd.CommandText = "SELECT AssetTypeCodeId_mappingTo_SeviceDB  FROM[dbo].[EngAssetTypeCode] where AssetTypeCodeId ="+Id;
                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }
               
                Log4NetLogger.LogExit(_FileName, nameof(Get), Level.Info.ToString());
                return ds;
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

        public DataSet Get_subManufacturer(int Id)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
                AssetStandardization assetStandardization = null;

                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.Text;
                        cmd.CommandText = "SELECT ManufacturerId_mappingTo_SeviceDB FROM[dbo].[EngAssetStandardization] where ManufacturerId =" + Id;
                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }

                Log4NetLogger.LogExit(_FileName, nameof(Get), Level.Info.ToString());
                return ds;
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
        public DataSet Get_Manu(int Id)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
                AssetStandardization assetStandardization = null;

                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.Text;
                        cmd.CommandText = "select AssetStandardizationId ,ManufacturerId, ModelId,AssetTypeCodeId FROM EngAssetStandardization"
;
                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }

                Log4NetLogger.LogExit(_FileName, nameof(Get), Level.Info.ToString());
                return ds;
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