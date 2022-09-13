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
using CP.UETrack.DAL.DataAccess.Contracts;
using CP.UETrack.DAL.DataAccess.Implementations.BEMS;


namespace CP.UETrack.DAL.DataAccess
{

    public class MasterBlockDAL : IMasterBlockDAL
    {
        private readonly string _FileName = nameof(MasterBlockDAL);
        readonly UserDetailsModel _UserSession = new SessionHelper().UserSession();
        private int block_ID, FEMS_Block_ID, BEMS_Block_ID, Master_block_ID;
       
        public MasterBlockDAL()
        {

        }
        public BlockFacilityDropdown Load()
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
                BlockFacilityDropdown BlockFacilityDropdown = null;

                var ds = new DataSet();
                var dbAccessDAL = new MASTERDBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "BlockMst_FacilityDropdown";
                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }
                if (ds.Tables.Count != 0)
                {
                    BlockFacilityDropdown = new BlockFacilityDropdown();
                    BlockFacilityDropdown.FacilityData = dbAccessDAL.GetLovRecords(ds.Tables[0]);
                }
                Log4NetLogger.LogExit(_FileName, nameof(Load), Level.Info.ToString());
                BlockFacilityDropdown.FacilityId = _UserSession.FacilityId;
                return BlockFacilityDropdown;
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
        public BlockMstViewModel Save(BlockMstViewModel Block, out string ErrorMessage)
        {
            DataTable FEMSdataTable = new DataTable();
            DataTable BEMSdataTable = new DataTable();
            Blocks BlockIDS = new Blocks();
            Blocks Facility_Mapping_IDS = new Blocks();
            Blocks Customar_Mapping_IDS = new Blocks();
            CustomerDAL customer = new CustomerDAL();
            Block.FEMS = _UserSession.FEMS;
            Block.BEMS = _UserSession.BEMS;
            Facility_Mapping_IDS= GET_Facility_Mapping_IDS(Block.FacilityId);
            Customar_Mapping_IDS = customer.GET_Customar_Mapping_IDS(_UserSession.CustomerId);
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());
                ErrorMessage = string.Empty;
                var spName = string.Empty;                
                DataTable dataTable = new DataTable("BemsBlockMst");
                dataTable.Columns.Add("BlockId", typeof(int));
                dataTable.Columns.Add("FacilityId", typeof(int));
                dataTable.Columns.Add("BlockCode", typeof(string));
                dataTable.Columns.Add("BlockName", typeof(string));
                dataTable.Columns.Add("ShortName", typeof(string));
                dataTable.Columns.Add("Active", typeof(bool));
                dataTable.Columns.Add("UserId", typeof(int));
                dataTable.Columns.Add("CustomerId", typeof(int));
                // dataTable.Columns.Add("BEMS", typeof(int));
                //dataTable.Columns.Add("FEMS", typeof(int));
                //dataTable.Columns.Add("CLS", typeof(int));
                // dataTable.Columns.Add("LLS", typeof(int));
                // dataTable.Columns.Add("HWMS", typeof(int));
                dataTable.Rows.Add(Block.BlockId, Block.FacilityId, Block.BlockCode, Block.BlockName, Block.ShortName, Block.Active, _UserSession.UserId, _UserSession.CustomerId);
                FEMSdataTable = dataTable.Copy();
                BEMSdataTable = dataTable.Copy();
               // Master_block_ID = Block.BlockId;
                     // Facility_Mapping_IDS

                //FEMSdataTable.Rows[0]["FacilityId"] = Facility_Mapping_IDS.FEMS_B_ID;
                //BEMSdataTable.Rows[0]["FacilityId"] = Facility_Mapping_IDS.BEMS_B_ID;
                //FEMSdataTable.Rows[0]["CustomerId"] = Customar_Mapping_IDS.FEMS_B_ID;
                //BEMSdataTable.Rows[0]["CustomerId"] = Customar_Mapping_IDS.BEMS_B_ID;
                if (Block.BlockId != 0)
                {
                    spName = "BlockMst_Update";
                    BlockIDS= GET_Block_IDS(Block.BlockId);
                    FEMSdataTable.Rows[0]["BlockId"] = BlockIDS.FEMS_B_ID;
                    BEMSdataTable.Rows[0]["BlockId"] = BlockIDS.BEMS_B_ID;
                }
                else
                {
                    spName = "BlockMst_Save";
                }

                

                var ds = new DataSet();
                // inserting into Master DB
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["UETrackConnectionString"].ToString()))
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

                    Block.HiddenId = Convert.ToString(ds.Tables[0].Rows[0]["GuId"]);
                    var blockid = Convert.ToInt32(ds.Tables[0].Rows[0]["BlockId"]);
                    block_ID = blockid;
                    if (blockid != 0)
                        Block.BlockId = blockid;
                    Master_block_ID = Block.BlockId;
                    if (ds.Tables[0].Rows[0]["Timestamp"] == DBNull.Value)
                    {
                        Block.Timestamp = "";
                    }
                    else
                    {
                        Block.Timestamp = Convert.ToBase64String((byte[])(ds.Tables[0].Rows[0]["Timestamp"]));
                    }
                    ErrorMessage = Convert.ToString(ds.Tables[0].Rows[0]["ErrorMsg"]);
                }


               // Log4NetLogger.LogExit(_FileName, nameof(Save), Level.Info.ToString());
                ds.Clear();
                //-insert into mapping table
                if (spName == "BlockMst_Update")
                {
                }
                else
                { 
                    using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["UETrackConnectionString"].ToString()))
                    {
                        using (SqlCommand cmd = new SqlCommand())
                        {
                            cmd.Connection = con;
                            cmd.CommandType = CommandType.StoredProcedure;
                            cmd.CommandText = "Master_BlockTMst_Save";

                            SqlParameter parameter = new SqlParameter();
                            cmd.Parameters.Add("@BlockId", SqlDbType.Int).Value = block_ID;

                            // cmd.Parameters.Add(parameter);
                            var da = new SqlDataAdapter();
                            da.SelectCommand = cmd;
                            da.Fill(ds);
                        }
                    }
                }
                ds.Clear();
                // Inserting into FBMS DB
                if (Block.FEMS==1)
                {
                    Block.FacilityId = Facility_Mapping_IDS.FEMS_B_ID;
                    var FEMSdbAccessDAL = new FEMSDBAccessDAL();
                    using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["FEMSUETrackCommonConnectionString"].ToString()))
                    {
                        using (SqlCommand cmd = new SqlCommand())
                        {
                            cmd.Connection = con;
                            cmd.CommandType = CommandType.StoredProcedure;
                            cmd.CommandText = spName;

                            SqlParameter parameter = new SqlParameter();
                            parameter.ParameterName = "@Block";
                            parameter.SqlDbType = System.Data.SqlDbType.Structured;
                            parameter.Value = FEMSdataTable;
                            cmd.Parameters.Add(parameter);

                            var da = new SqlDataAdapter();
                            da.SelectCommand = cmd;
                            da.Fill(ds);
                        }
                    }
                    //------------Update Relation Primary key from FBMS TO MASTER
                   // Update_FEMS(block_ID, FEMS_Block_ID, 1);

                    if (ds.Tables.Count != 0)
                    {
                        Block.HiddenId = Convert.ToString(ds.Tables[0].Rows[0]["GuId"]);
                        var blockid = Convert.ToInt32(ds.Tables[0].Rows[0]["BlockId"]);
                        FEMS_Block_ID = blockid;
                        if (spName == "BlockMst_Update")
                        {
                        }
                        else
                        { Update_FEMS(block_ID, FEMS_Block_ID, 1);
                        }
                       
                        if (blockid != 0)
                            Block.BlockId = blockid;
                        if (ds.Tables[0].Rows[0]["Timestamp"] == DBNull.Value)
                        {
                            Block.Timestamp = "";
                        }
                        else
                        {
                            Block.Timestamp = Convert.ToBase64String((byte[])(ds.Tables[0].Rows[0]["Timestamp"]));
                        }
                        ErrorMessage = Convert.ToString(ds.Tables[0].Rows[0]["ErrorMsg"]);
                    }
                    // inserting into BEMS DB
                    ds.Clear();
                   
                }
                if (Block.BEMS == 1)
                {
                    Block.FacilityId = Facility_Mapping_IDS.BEMS_B_ID;
                    var DBAccessDAL = new BEMSDBAccessDAL();
                    using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["UETrackCommonConnectionString"].ToString()))
                    {
                        using (SqlCommand cmd = new SqlCommand())
                        {
                            cmd.Connection = con;
                            cmd.CommandType = CommandType.StoredProcedure;
                            cmd.CommandText = spName;

                            SqlParameter parameter = new SqlParameter();
                            parameter.ParameterName = "@Block";
                            parameter.SqlDbType = System.Data.SqlDbType.Structured;
                            parameter.Value = BEMSdataTable;
                            cmd.Parameters.Add(parameter);

                            var da = new SqlDataAdapter();
                            da.SelectCommand = cmd;
                            da.Fill(ds);
                        }
                    }

                    if (ds.Tables.Count != 0)
                    {
                        Block.HiddenId = Convert.ToString(ds.Tables[0].Rows[0]["GuId"]);
                        var blockid = Convert.ToInt32(ds.Tables[0].Rows[0]["BlockId"]);
                        BEMS_Block_ID = blockid;
                        //------------Update Relation Primary key from FBMS TO MASTER
                        if (spName == "BlockMst_Update")
                        {
                        }
                        else
                        {
                            Update_FEMS(block_ID, BEMS_Block_ID, 2);
                        }

                        if (blockid != 0)
                            Block.BlockId = blockid;
                        if (ds.Tables[0].Rows[0]["Timestamp"] == DBNull.Value)
                        {
                            Block.Timestamp = "";
                        }
                        else
                        {
                            Block.Timestamp = Convert.ToBase64String((byte[])(ds.Tables[0].Rows[0]["Timestamp"]));
                        }
                        ErrorMessage = Convert.ToString(ds.Tables[0].Rows[0]["ErrorMsg"]);
                    }

                }

                Log4NetLogger.LogExit(_FileName, nameof(Save), Level.Info.ToString());
                Block.BlockId = Master_block_ID;
                return Block;
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
        public void Update_FEMS(int Master_BlockID, int Module_ID,int Module_Type)
        {
            try
            {
                var ds = new DataSet();
                var userid=_UserSession.UserId;
                // inserting into Master DB
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["UETrackConnectionString"].ToString()))//
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "Master_Updae_Block_All";

                        SqlParameter parameter = new SqlParameter();
                        cmd.Parameters.Add("@Master_BlockID", SqlDbType.Int).Value = Master_BlockID;
                        cmd.Parameters.Add("@Module_ID", SqlDbType.Int).Value = Module_ID;
                        cmd.Parameters.Add("@Module_Type", SqlDbType.Int).Value = Module_Type;
                        // cmd.Parameters.Add(parameter);

                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }
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
                using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["UETrackConnectionString"].ToString()))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_MstLocationLevel_GetAll";

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

        public GridFilterResult MasterGetAll(SortPaginateFilter pageFilter)
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
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["UETrackConnectionString"].ToString()))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_MstLocationLevel_GetAll";

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
        public BlockMstViewModel Get(int Id)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
                BlockMstViewModel Block = null;

                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["UETrackConnectionString"].ToString()))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "BlockMst_Get";
                        cmd.Parameters.AddWithValue("Id", Id);
                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }
                if (ds.Tables.Count != 0)
                {
                    Block = (from n in ds.Tables[0].AsEnumerable()
                             select new BlockMstViewModel
                             {
                                 BlockId = Id,
                                 BlockCode = Convert.ToString(n["BlockCode"]),
                                 FacilityId = Convert.ToInt32(n["FacilityId"]),
                                 Active = Convert.ToInt32(n["Active"]),
                                 BlockName = Convert.ToString(n["BlockName"]),
                                 ShortName = Convert.ToString(n["ShortName"]),
                                 HiddenId = Convert.ToString(n["GuId"]),
                                 Timestamp = Convert.ToBase64String((byte[])(n["Timestamp"]))
                             }).FirstOrDefault();
                }
                Log4NetLogger.LogExit(_FileName, nameof(Get), Level.Info.ToString());
                return Block;
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
        public bool IsBlockCodeDuplicate(BlockMstViewModel Block)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(IsBlockCodeDuplicate), Level.Info.ToString());

                var isDuplicate = true;
                string constring = ConfigurationManager.ConnectionStrings["UETrackConnectionString"].ConnectionString;
                using (SqlConnection con = new SqlConnection(constring))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "BlockMst_IsBlockCodeDuplicate";
                        cmd.Parameters.AddWithValue("@pBlockId", Block.BlockId);
                        cmd.Parameters.AddWithValue("@pCustomerId", _UserSession.CustomerId);
                        cmd.Parameters.AddWithValue("@pFacilityId", _UserSession.FacilityId);
                        cmd.Parameters.AddWithValue("@BlockCode", Block.BlockCode);
                        cmd.Parameters.Add("@IsDuplicate", SqlDbType.Bit);
                        cmd.Parameters["@IsDuplicate"].Direction = ParameterDirection.Output;

                        con.Open();
                        cmd.ExecuteNonQuery();
                        con.Close();
                        bool.TryParse(cmd.Parameters["@IsDuplicate"].Value.ToString(), out isDuplicate);
                    }
                }

                Log4NetLogger.LogExit(_FileName, nameof(IsBlockCodeDuplicate), Level.Info.ToString());
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
        public bool IsRecordModified(BlockMstViewModel Block)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(IsRecordModified), Level.Info.ToString());

                var recordModifed = false;

                if (Block.BlockId != 0)
                {
                    var ds = new DataSet();
                    string constring = ConfigurationManager.ConnectionStrings["UETrackConnectionString"].ConnectionString;
                    using (SqlConnection con = new SqlConnection(constring))
                    {
                        using (SqlCommand cmd = new SqlCommand())
                        {
                            cmd.Connection = con;
                            cmd.CommandType = CommandType.StoredProcedure;
                            cmd.CommandText = "GetBlockTimestamp";
                            cmd.Parameters.AddWithValue("Id", Block.BlockId);
                            var da = new SqlDataAdapter();
                            da.SelectCommand = cmd;
                            da.Fill(ds);
                        }
                    }
                    if (ds.Tables.Count != 0 && ds.Tables[0].Rows.Count > 0)
                    {
                        var timestamp = Convert.ToBase64String((byte[])(ds.Tables[0].Rows[0]["Timestamp"]));
                        if (timestamp != Block.Timestamp)
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
                var dbAccessDAL = new MASTERDBAccessDAL();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@Id", Id.ToString());
                DataTable dt = dbAccessDAL.GetMASTERDataTable("BlockMst_Delete", parameters, DataSetparameters);
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
        public Blocks GET_Block_IDS(int Block_ID)
        {
            ///-------------Get Modules FEMS OR BEMS Block IDS to update
            ///

            Blocks Blok_get = new Blocks();
            var dss = new DataSet();
        var MasterdbAccessDAL = new MASTERDBAccessDAL();
                    using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["UETrackConnectionString"].ToString()))
                    {
                        using (SqlCommand cmd = new SqlCommand())
                        {
                            cmd.Connection = con;
                            cmd.CommandType = CommandType.StoredProcedure;
                            cmd.CommandText = "Get_MasterServices_byBlockId";
                            cmd.Parameters.AddWithValue("MasterBlockID", Block_ID);
                            var da = new SqlDataAdapter();
    da.SelectCommand = cmd;
                            da.Fill(dss);
                        }
                    }
                    if (dss.Tables.Count != 0)
                    {

                Blok_get.FEMS_B_ID = Convert.ToInt32(dss.Tables[0].Rows[0]["FEMS"]);
                Blok_get.BEMS_B_ID = Convert.ToInt32(dss.Tables[0].Rows[0]["BEMS"]);
                }
                   // Log4NetLogger.LogExit(_FileName, nameof(Load), Level.Info.ToString());
            return Blok_get;
        }
        public Blocks GET_Facility_Mapping_IDS(int Facility_Mapping_IDS)
        {
            ///-------------Get Modules FEMS OR BEMS Block IDS to update
            ///

            Blocks Blok_get = new Blocks();
            var dss = new DataSet();
            var MasterdbAccessDAL = new MASTERDBAccessDAL();
            using (SqlConnection con = new SqlConnection(ConfigurationManager.ConnectionStrings["UETrackConnectionString"].ToString()))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = con;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "Master_MstLocationFacility_Getall_ByID";
                    cmd.Parameters.AddWithValue("@Master_FacilityID", Facility_Mapping_IDS);
                    var da = new SqlDataAdapter();
                    da.SelectCommand = cmd;
                    da.Fill(dss);
                }
            }
            if (dss.Tables.Count != 0)
            {

                Blok_get.FEMS_B_ID = Convert.ToInt32(dss.Tables[0].Rows[0]["FEMS_ID"]);
                Blok_get.BEMS_B_ID = Convert.ToInt32(dss.Tables[0].Rows[0]["BEMS_ID"]);
            }
            // Log4NetLogger.LogExit(_FileName, nameof(Load), Level.Info.ToString());
            return Blok_get;
        }
        


    }
}
