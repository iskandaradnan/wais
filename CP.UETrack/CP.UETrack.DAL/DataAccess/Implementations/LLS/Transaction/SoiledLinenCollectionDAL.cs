using CP.Framework.Common.ExceptionHandler.ExceptionWrappers;
using CP.Framework.Common.Logging;
using CP.UETrack.DAL.DataAccess.Contracts.LLS;
using CP.UETrack.DAL.DataAccess.Contracts.LLS.Transaction;
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


namespace CP.UETrack.DAL.DataAccess.Implementations.LLS.Transaction
{
    public class SoiledLinenCollectionDAL : ISoiledLinenCollectionDAL
    {
        private readonly string _FileName = nameof(SoiledLinenCollectionDAL);
        readonly UserDetailsModel _UserSession = new SessionHelper().UserSession();
        public SoiledLinenCollectionDAL()
        {

        }

        public SoiledLinenCollectionModelLovs Load()
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
                SoiledLinenCollectionModelLovs SoiledLinenCollectionModelLovs = new SoiledLinenCollectionModelLovs();

                string lovs = "CollectionScheduleValue,DefaultValue";
                var dbAccessDAL = new MASTERDBAccessDAL();
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
                        cmd.Parameters.AddWithValue("@pLovKey", "");
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
                    SoiledLinenCollectionModelLovs.LaundryPlant = dbAccessDAL.GetLovRecords(ds.Tables[0]);
                }
                if (ds1.Tables.Count != 0)
                {

                    SoiledLinenCollectionModelLovs.CollectionSchedule = dbAccessDAL.GetLovRecords(ds1.Tables[0], "CollectionScheduleValue");
                    SoiledLinenCollectionModelLovs.OnTime = dbAccessDAL.GetLovRecords(ds1.Tables[0], "DefaultValue");
                }
                //SoiledLinenCollectionModelLovs.IsAdditionalFieldsExist = IsAdditionalFieldsExist();
                Log4NetLogger.LogExit(_FileName, nameof(Load), Level.Info.ToString());
                return SoiledLinenCollectionModelLovs;
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
        //public bool IsAdditionalFieldsExist()
        //{
        //    try
        //    {
        //        Log4NetLogger.LogEntry(_FileName, nameof(IsAdditionalFieldsExist), Level.Info.ToString());
        //        var isExists = false;

        //        var ds = new DataSet();
        //        var dbAccessDAL = new MASTERDBAccessDAL();
        //        using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
        //        {
        //            using (SqlCommand cmd = new SqlCommand())
        //            {
        //                cmd.Connection = con;
        //                cmd.CommandType = CommandType.StoredProcedure;
        //                cmd.CommandText = "uspFM_FMAddFieldConfig_Check";
        //                cmd.Parameters.AddWithValue("@pCustomerId", _UserSession.CustomerId);
        //                cmd.Parameters.AddWithValue("@pScreenNameLovId", (int)ConfigScreenNameValue.TestingAndCommissioning);
        //                var da = new SqlDataAdapter();
        //                da.SelectCommand = cmd;
        //                da.Fill(ds);
        //            }
        //        }
        //        if (ds.Tables.Count != 0 && ds.Tables[0].Rows.Count > 0)
        //        {
        //            isExists = Convert.ToInt32(ds.Tables[0].Rows[0][0]) > 0;
        //        }
        //        Log4NetLogger.LogExit(_FileName, nameof(IsAdditionalFieldsExist), Level.Info.ToString());
        //        return isExists;
        //    }
        //    catch (DALException dalex)
        //    {
        //        throw new DALException(dalex);
        //    }
        //    catch (Exception)
        //    {
        //        throw;
        //    }
        //}
        public soildLinencollectionsModel Save(soildLinencollectionsModel model, out string ErrorMessage)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());
                ErrorMessage = string.Empty;
                var spName = string.Empty;
                var spNames = string.Empty;
                var ds = new DataSet();
                var ds2 = new DataSet();
                //DateTime myDate = new DateTime();
                //var Effectivedate = myDate.ToString("yyyy-MM-DD HH:mm:ss");
                //String.Format("yyyy-MM-dd HH:mm:ss}", dt);
                var dbAccessDAL = new MASTERDBAccessDAL();
                var parameters = new Dictionary<string, string>();
                var rowparameters = new Dictionary<string, string>();
                var DataSetparameters = new Dictionary<string, DataTable>();
                List<LSoiledLinenItemGridListItem> soiledList = new List<LSoiledLinenItemGridListItem>();
                soiledList = model.LSoiledLinenItemGridList;
                DataTable dataTable1 = new DataTable("SoiledLinenCollectiontMstDet");
                DataTable dataTable = new DataTable("SoiledLinenCollectiontMst");
                DataTable dt1 = new DataTable();
                TimeSpan CollectionStartTime = new TimeSpan();
                // Convert String to timespan
                CollectionStartTime = TimeSpan.Parse(CollectionStartTime.ToString());
                TimeSpan CollectionEndTime = new TimeSpan();
                // Convert String to timespan
                CollectionEndTime = TimeSpan.Parse(CollectionEndTime.ToString());
                TimeSpan CollectionTime = new TimeSpan();
                // Convert String to timespan
                CollectionTime = TimeSpan.Parse(CollectionTime.ToString());

                #region for Update but as per Aida Instruction no need update for SoiledLinenCollection

                //// Delete grid
                var deletedId = model.LSoiledLinenItemGridList.Where(y => y.IsDeleted).Select(x => x.SoiledLinenCollectionDetId).ToList();
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
                if (model.SoiledLinenCollectionId != 0)
                {
                    dt1.Columns.Add("@SoiledLinenCollectionDetId", typeof(int));
                    dt1.Columns.Add("@LLSUserAreaId", typeof(int));
                    dt1.Columns.Add("@LLSUserAreaLocationId", typeof(int));
                    dt1.Columns.Add("@Weight", typeof(Decimal));
                    dt1.Columns.Add("@TotalWhiteBag", typeof(int));
                    dt1.Columns.Add("@TotalRedBag", typeof(int));
                    dt1.Columns.Add("@TotalGreenBag", typeof(int));
                    dt1.Columns.Add("@TotalQuantity", typeof(int));
                    dt1.Columns.Add("@CollectionSchedule", typeof(int));
                    dt1.Columns.Add("@CollectionStartTime", typeof(TimeSpan));
                    dt1.Columns.Add("@CollectionEndTime", typeof(TimeSpan));
                    dt1.Columns.Add("@CollectionTime", typeof(TimeSpan));
                    dt1.Columns.Add("@OnTime", typeof(int));
                    dt1.Columns.Add("@VerifiedBy", typeof(int));
                    //dt1.Columns.Add("@VerifiedDate", typeof(DateTime));
                    dt1.Columns.Add("@Remarks", typeof(string));
                    dt1.Columns.Add("@SoiledLinenCollectionId", typeof(int));
                    dt1.Columns.Add("@TotalBrownBag", typeof(int));
                    dt1.Columns.Add("@ModifiedBy", typeof(int));

                    foreach (var var in model.LSoiledLinenItemGridList)
                    {
                        dt1.Rows.Add(var.SoiledLinenCollectionDetId,
                            var.LLSUserAreaId,
                            var.LLSUserAreaLocationId, 
                            var.Weight, 
                            var.TotalWhiteBag,
                            var.TotalRedBag, 
                            var.TotalGreenBag, 
                            var.TotalQuantity,
                            var.CollectionSchedule,
                            var.CollectionStartTime,
                            var.CollectionEndTime,
                            Convert.ToString(var.CollectionTime),
                            var.OnTime, 
                            var.Verified, /*var.VerifiedDate,*/
                            var.Remarks,
                            model.SoiledLinenCollectionId,
                             var.TotalBrownBag,
                             _UserSession.UserId.ToString()
                             );
                    }
                    parameters.Clear();
                    DataSetparameters.Add("@LLSSoiledLinenCollectionTxnDet_Update", dt1);
                    DataTable dss2 = dbAccessDAL.GetMASTERDataTable("LLSSoiledLinenCollectionTxnDet_Update", parameters, DataSetparameters);
                    foreach (var jjj in model.LSoiledLinenItemGridList)
                    {
                        if (jjj.SoiledLinenCollectionDetId == 0)
                        {

                            spNames = "LLSSoiledLinenCollectionTxnDet_Save";

                            dataTable1.Columns.Add("SoiledLinenCollectionId", typeof(int));
                            dataTable1.Columns.Add("CustomerId", typeof(int));
                            dataTable1.Columns.Add("FacilityID", typeof(int));
                            dataTable1.Columns.Add("LLSUserAreaId", typeof(int));
                            dataTable1.Columns.Add("LLSUserAreaLocationId", typeof(int));
                            dataTable1.Columns.Add("Weight", typeof(decimal));
                            dataTable1.Columns.Add("TotalWhiteBag", typeof(int));
                            dataTable1.Columns.Add("TotalRedBag", typeof(int));
                            dataTable1.Columns.Add("TotalGreenBag", typeof(int));
                            dataTable1.Columns.Add("TotalBrownBag", typeof(int));
                            dataTable1.Columns.Add("TotalQuantity", typeof(int));
                            dataTable1.Columns.Add("CollectionSchedule", typeof(int));
                            dataTable1.Columns.Add("CollectionStartTime", typeof(TimeSpan));
                            dataTable1.Columns.Add("CollectionEndTime", typeof(TimeSpan));
                            dataTable1.Columns.Add("CollectionTime", typeof(TimeSpan));
                            //dataTable1.Columns.Add(new DataColumn("CollectionStartTime", typeof(DateTime)));
                            //dataTable1.Columns.Add(new DataColumn("CollectionEndTime", typeof(DateTime)));
                            //dataTable1.Columns.Add(new DataColumn("CollectionTime", typeof(DateTime)));
                            dataTable1.Columns.Add("OnTime", typeof(int));
                            dataTable1.Columns.Add("VerifiedBy", typeof(int));
                            dataTable1.Columns.Add("VerifiedDate", typeof(DateTime));
                            dataTable1.Columns.Add("Remarks", typeof(string));
                            dataTable1.Columns.Add("CreatedBy", typeof(int));
                            foreach (var row in soiledList)
                            {
                                if (row.SoiledLinenCollectionDetId == 0)
                                {
                                    dataTable1.Rows.Add(
                                model.SoiledLinenCollectionId,
                                _UserSession.CustomerId,
                                _UserSession.FacilityId,
                                row.LLSUserAreaId,
                                row.LLSUserAreaLocationId,
                                row.Weight,
                                row.TotalWhiteBag,
                                row.TotalRedBag,
                                row.TotalGreenBag,
                                row.TotalBrownBag,
                                row.TotalQuantity,
                                row.CollectionSchedule,
                                row.CollectionStartTime,
                                row.CollectionEndTime,
                                row.CollectionTime,
                                row.OnTime,
                                row.VerifiedBy,
                                row.VerifiedDate,
                                row.Remarks,
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
                        if (jjj.SoiledLinenCollectionDetId == 0)
                        {
                            return model;
                        }
                        else { }
                    }
                    return model;
                }
                else
                {
                    spName = "LLSSoiledLinenCollectionTxn_Save";
                }

                dataTable.Columns.Add("CustomerId", typeof(int));
                dataTable.Columns.Add("FacilityId", typeof(int));
                dataTable.Columns.Add("DocumentNo", typeof(string));
                dataTable.Columns.Add("CollectionDate", typeof(DateTime));
                dataTable.Columns.Add("LaundryPlantID", typeof(int));
                dataTable.Columns.Add("DespatchDate", typeof(DateTime));
                dataTable.Columns.Add("CreatedBy", typeof(int));
                dataTable.Columns.Add("ModifiedBy", typeof(int));
                dataTable.Columns.Add("Guid", typeof(string));
                dataTable.Rows.Add(
                     _UserSession.CustomerId,
                    _UserSession.FacilityId,
                    model.DocumentNo,
                    model.CollectionDate,
                    model.LaundryPlantID,
                    model.DespatchDate,
                    _UserSession.UserId.ToString(),
                    _UserSession.UserId.ToString(),
                    Guid.NewGuid()
                    );
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = spName;
                        SqlParameter parameter = new SqlParameter();
                        parameter.ParameterName = "@LLSSoiledLinenCollection";
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
                    var SoiledLinenCollectionId = Convert.ToInt32(ds.Tables[0].Rows[0]["SoiledLinenCollectionId"]);
                    if (SoiledLinenCollectionId != 0)
                        model.SoiledLinenCollectionId = SoiledLinenCollectionId;
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
                //-------------Adding ChildTable-----------------
                
                if (model.SoiledLinenCollectionDetId != 0)
                {

                }

                else
                {
                    spNames = "LLSSoiledLinenCollectionTxnDet_Save";

                    dataTable1.Columns.Add("SoiledLinenCollectionId", typeof(int));
                    dataTable1.Columns.Add("CustomerId", typeof(int));
                    dataTable1.Columns.Add("FacilityID", typeof(int));
                    dataTable1.Columns.Add("LLSUserAreaId", typeof(int));
                    dataTable1.Columns.Add("LLSUserAreaLocationId", typeof(int));
                    dataTable1.Columns.Add("Weight", typeof(decimal));
                    dataTable1.Columns.Add("TotalWhiteBag", typeof(int));
                    dataTable1.Columns.Add("TotalRedBag", typeof(int));
                    dataTable1.Columns.Add("TotalGreenBag", typeof(int));
                    dataTable1.Columns.Add("TotalBrownBag", typeof(int));
                    dataTable1.Columns.Add("TotalQuantity", typeof(int));
                    dataTable1.Columns.Add("CollectionSchedule", typeof(int));
                    dataTable1.Columns.Add("CollectionStartTime", typeof(TimeSpan));
                    dataTable1.Columns.Add("CollectionEndTime", typeof(TimeSpan));
                    dataTable1.Columns.Add("CollectionTime", typeof(TimeSpan));
                    //dataTable1.Columns.Add(new DataColumn("CollectionStartTime", typeof(DateTime)));
                    //dataTable1.Columns.Add(new DataColumn("CollectionEndTime", typeof(DateTime)));
                    //dataTable1.Columns.Add(new DataColumn("CollectionTime", typeof(DateTime)));
                    dataTable1.Columns.Add("OnTime", typeof(int));
                    dataTable1.Columns.Add("VerifiedBy", typeof(int));
                    dataTable1.Columns.Add("VerifiedDate", typeof(DateTime));
                    dataTable1.Columns.Add("Remarks", typeof(string));
                    dataTable1.Columns.Add("CreatedBy", typeof(int));
                    foreach (var row in soiledList)
                    {
                        dataTable1.Rows.Add(
                        model.SoiledLinenCollectionId,
                        _UserSession.CustomerId,
                        _UserSession.FacilityId,
                        row.LLSUserAreaId,
                        row.LLSUserAreaLocationId,
                        row.Weight,
                        row.TotalWhiteBag,
                        row.TotalRedBag,
                        row.TotalGreenBag,
                        row.TotalBrownBag,
                        row.TotalQuantity,
                        row.CollectionSchedule,
                        row.CollectionStartTime,
                        row.CollectionEndTime,
                        row.CollectionTime,
                        row.OnTime,
                        row.VerifiedBy,
                        row.VerifiedDate,
                        row.Remarks,
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

        public soildLinencollectionsModel Get(int Id)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
            try
            {
                soildLinencollectionsModel model = new soildLinencollectionsModel();
                var EffectiveDate = DateTime.Now.ToString("HH:mm:ss");
                var ds = new DataSet();
                var dbAccessDAL = new MASTERDBAccessDAL();
                LSoiledLinenItemGridListItem LSoiledLinenItemGridList = new LSoiledLinenItemGridListItem();

                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                var locationparameters = new Dictionary<string, string>();
                parameters.Add("Id", Convert.ToString(Id));
                DataTable dt = dbAccessDAL.GetMASTERDataTable("LLSSoiledLinenCollectionTxn_GetById", parameters, DataSetparameters);
                if (dt != null && dt.Rows.Count > 0)
                {

                    model.SoiledLinenCollectionId = Id;
                    model.DocumentNo = Convert.ToString(dt.Rows[0]["DocumentNo"]);
                    model.CollectionDate = Convert.ToDateTime(dt.Rows[0]["CollectionDate"]);
                    model.Weight = Convert.ToDecimal(dt.Rows[0]["TotalWeight"]);
                    model.LaundryPlantName = Convert.ToString(dt.Rows[0]["LaundryPlantId"]);
                    model.DespatchDate = Convert.ToDateTime(dt.Rows[0]["DespatchDate"]);
                    model.Ownership = Convert.ToString(dt.Rows[0]["Ownership"]);
                    model.TotalWhiteBag = Convert.ToInt32(dt.Rows[0]["TotalWhiteBag"]);
                    model.TotalRedBag = Convert.ToInt32(dt.Rows[0]["TotalRedBag"]);
                    model.TotalGreenBag = Convert.ToInt32(dt.Rows[0]["TotalGreenBag"]);
                    model.TotalBrownBag= Convert.ToInt32(dt.Rows[0]["TotalBrownBag"]);
                    model.GuId = Convert.ToString(dt.Rows[0]["GuId"]);
                }
                locationparameters.Add("Id", model.SoiledLinenCollectionId.ToString());
                LSoiledLinenItemGridListItem llll = new LSoiledLinenItemGridListItem();
              
                DataSet dt2 = dbAccessDAL.MasterGetDataSet("LLSSoiledLinenCollectionTxnDet_GetById", locationparameters, DataSetparameters);
                List<LSoiledLinenItemGridListItem> listinggrid = new List<LSoiledLinenItemGridListItem>();
                List<LSoiledLinenItemGridListItem> resultsfinal = new List<LSoiledLinenItemGridListItem>();

                if (dt2.Tables[0].Rows.Count>0)
                {
                    
                    foreach (DataRow rows in dt2.Tables[0].Rows)
                    {
                        LSoiledLinenItemGridListItem lovigrids = new LSoiledLinenItemGridListItem();
                        lovigrids.UserAreaCode = Convert.ToString(rows["UserAreaCode"]);
                        lovigrids.UserLocationCode = Convert.ToString(rows["UserLocationCode"]);
                        lovigrids.Weight = Convert.ToDecimal(rows["Weight"]);
                        lovigrids.TotalWhiteBag = Convert.ToInt32(rows["TotalWhiteBag"]);
                        lovigrids.TotalRedBag = Convert.ToInt32(rows["TotalRedBag"]);
                        lovigrids.TotalGreenBag = Convert.ToInt32(rows["TotalGreenBag"]);
                        lovigrids.TotalBrownBag = Convert.ToInt32(rows["TotalBrownBag"]);
                        lovigrids.TotalQuantity = Convert.ToInt32(rows["TotalQuantity"]);
                        lovigrids.CollectionSchedule = Convert.ToInt32(rows["CollectionSchedule"]);
                        lovigrids.CollectionStartTime = TimeSpan.Parse(handlenull(rows["CollectionStartTime"].ToString()));
                        lovigrids.CollectionEndTime = TimeSpan.Parse(handlenull(rows["CollectionEndTime"].ToString()));
                        lovigrids.CollectionTime = TimeSpan.Parse(handlenull(rows["CollectionTime"].ToString()));
                        lovigrids.OnTime = Convert.ToString(rows["OnTime"]);
                        lovigrids.VerifiedBy = Convert.ToString(rows["VerifiedBy"]);
                        lovigrids.VerifiedDate = Convert.ToDateTime(rows["VerifiedDate"]);
                        lovigrids.Remarks = Convert.ToString(rows["Remarks"]);
                        lovigrids.SoiledLinenCollectionDetId = Convert.ToInt32(rows["SoiledLinenCollectionDetId"]);
                        lovigrids.LLSUserAreaId = Convert.ToInt32(rows["LLSUserAreaId"]);
                        lovigrids.LLSUserAreaLocationId = Convert.ToInt32(rows["LLSUserAreaLocationId"]);
                        lovigrids.Verified = Convert.ToInt32(rows["Verified"]);
                        
                        listinggrid.Add(lovigrids);
                        resultsfinal= resultsfinal.Concat(listinggrid).ToList();
                        listinggrid.Clear();
                        
                    }
                    model.LSoiledLinenItemGridList = resultsfinal;
                   
                } else
                {
                }
                //foreach (var test in model.SoiledLinenCollectionId.ToString())
                //{
                //    llll.CollectionStartTime = TimeSpan.Parse(handlenull(dt2.Tables[0].Rows[0]["CollectionStartTime"].ToString()));
                //    llll.CollectionEndTime = TimeSpan.Parse(handlenull(dt2.Tables[0].Rows[0]["CollectionEndTime"].ToString()));
                //    llll.CollectionTime = TimeSpan.Parse(handlenull(dt2.Tables[0].Rows[0]["CollectionTime"].ToString()));
                //}
                

                //if (dt != null && dt2.Tables.Count > 0)
                //{

                //    //var test = model.LSoiledLinenItemGridList
                //    //foreach(test.use)
                //    //List<LSoiledLinenItemGridListItem> LSoiledLinenItemGrid = new List<LSoiledLinenItemGridListItem>();
                //    //LSoiledLinenItemGrid.AddRange(model.LSoiledLinenItemGridList);
                    
                //            model.LSoiledLinenItemGridList = (from n in dt2.Tables[0].AsEnumerable()
                //                                              select new LSoiledLinenItemGridListItem
                //                                              {

                //                                                  UserAreaCode = Convert.ToString(n["UserAreaCode"]),
                //                                                  UserLocationCode = Convert.ToString(n["UserLocationCode"]),
                //                                                  Weight = Convert.ToDecimal(n["Weight"]),
                //                                                  TotalWhiteBag = Convert.ToInt32(n["TotalWhiteBag"]),
                //                                                  TotalRedBag = Convert.ToInt32(n["TotalRedBag"]),
                //                                                  TotalGreenBag = Convert.ToInt32(n["TotalGreenBag"]),
                //                                                  TotalQuantity = Convert.ToInt32(n["TotalQuantity"]),
                //                                                  CollectionSchedule = Convert.ToInt32(n["CollectionSchedule"]),
                //                                                  CollectionStartTime = TimeSpan.Parse(n["CollectionStartTime"]),
                //                                                  CollectionEndTime = llll.CollectionEndTime,
                //                                                  CollectionTime = llll.CollectionTime,
                //                                                  OnTime = Convert.ToString(n["OnTime"]),
                //                                                  VerifiedBy = Convert.ToString(n["VerifiedBy"]),
                //                                                  VerifiedDate = Convert.ToDateTime(n["VerifiedDate"]),
                //                                                  Remarks = Convert.ToString(n["Remarks"]),
                //                                                  SoiledLinenCollectionDetId = Convert.ToInt32(n["SoiledLinenCollectionDetId"]),
                //                                                  LLSUserAreaId = Convert.ToInt32(n["LLSUserAreaId"]),
                //                                                  LLSUserAreaLocationId = Convert.ToInt32(n["LLSUserAreaLocationId"]),
                //                                                  Verified = Convert.ToInt32(n["Verified"]),
                //                                              }).ToList();
                //            //model.LSoiledLinenItemGridList.ForEach((x) =>
                //            //{
                //            //    // entity.TotalCost = x.TotalCost;
                //            //    //x.PageIndex = pageindex;
                //            //    //x.FirstRecord = ((pageindex - 1) * pagesize) + 1;
                //            //    //x.LastRecord = ((pageindex - 1) * pagesize) + pagesize;

                //            //});
                //        }
                    

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

        string handlenull(string inp)
        {
            if (inp.Length < 1)
            {
                inp = "00:00:00";
            }
            else
            { }
            return inp;
        }
        public soildLinencollectionsModel GetBy(soildLinencollectionsModel model)
          {
            Log4NetLogger.LogEntry(_FileName, nameof(GetBy), Level.Info.ToString());
            try
            {
                //soildLinencollectionsModel model = new soildLinencollectionsModel();
                var EffectiveDate = DateTime.Now.ToString("HH:mm:ss");
                var ds = new DataSet();
                var dbAccessDAL = new MASTERDBAccessDAL();
                LSoiledLinenItemGridListItem LSoiledLinenItemGridList = new LSoiledLinenItemGridListItem();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                //parameters.Add("Id", Convert.ToString(Id));
                parameters.Add("@LocationID", Convert.ToString(model.SoiledLinenCollectionDetId));
                parameters.Add("@CollectionSchedule", Convert.ToString(model.CollectionSchedule));
                DataTable dt = dbAccessDAL.GetMASTERDataTable("LLSSoiledLinenCollectionTxnDet_FetchCollectionSchedule", parameters, DataSetparameters);
                if (dt != null && dt.Rows.Count > 0)
                {

                }

                Log4NetLogger.LogExit(_FileName, nameof(GetBy), Level.Info.ToString());
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

        //public soildLinencollectionsModel GetBySchedule(soildLinencollectionsModel model, out string ErrorMessage)
        //{
        //    try
        //    {
        //        Log4NetLogger.LogEntry(_FileName, nameof(GetBySchedule), Level.Info.ToString());
        //        ErrorMessage = string.Empty;
        //        var spName = string.Empty;
        //        var spNames = string.Empty;
        //        var ds = new DataSet();
        //        var ds2 = new DataSet();
        //        var dbAccessDAL = new MASTERDBAccessDAL();
        //        var parameters = new Dictionary<string, string>();
        //        var rowparameters = new Dictionary<string, string>();
        //        var DataSetparameters = new Dictionary<string, DataTable>();
        //        List<LSoiledLinenItemGridListItem> soiledList = new List<LSoiledLinenItemGridListItem>();
        //        soiledList = model.LSoiledLinenItemGridList;

        //        parameters.Add("@LocationID", Convert.ToString(model.SoiledLinenCollectionDetId));
        //        parameters.Add("@CollectionSchedule", Convert.ToString(model.CollectionSchedule));

        //        Log4NetLogger.LogExit(_FileName, nameof(GetBySchedule), Level.Info.ToString());

        //        return model;
        //    }
        //    catch (DALException dalex)
        //    {
        //        throw new DALException(dalex);
        //    }
        //    catch (Exception ex)
        //    {
        //        throw ex;
        //    }

        //}

        //public soildLinencollectionsModel GetBySchedule(int Id)
        //{
        //    try
        //    {
        //        Log4NetLogger.LogEntry(_FileName, nameof(GetBySchedule), Level.Info.ToString());
        //        soildLinencollectionsModel model = new soildLinencollectionsModel();
        //        var ds = new DataSet();
        //        var dbAccessDAL = new MASTERDBAccessDAL();
        //        LSoiledLinenItemGridListItem LSoiledLinenItemGridList = new LSoiledLinenItemGridListItem();
        //        var EffectiveDate = DateTime.Now.ToString("yyyy-MMdd HH:mm:ss");
        //        var DataSetparameters = new Dictionary<string, DataTable>();
        //        var parameters = new Dictionary<string, string>();
        //        var parameterss = new Dictionary<string, string>();
        //        parameters.Add("@Id", Convert.ToString(Id));

        //        DataSet dt2 = dbAccessDAL.MasterGetDataSet("", parameters, DataSetparameters);
        //        if (dt2 != null && dt2.Tables.Count > 0)
        //        {
                   
        //        }
        //        Log4NetLogger.LogExit(_FileName, nameof(GetBySchedule), Level.Info.ToString());
        //        return model;
        //    }
        //    catch (DALException dalex)
        //    {
        //        throw new DALException(dalex);
        //    }
        //    catch (Exception ex)
        //    {
        //        throw ex;
        //    }
        //}
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
                        cmd.CommandText = "LLSSoiledLinenCollectionTxn_GetAll";

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
                var dbAccessDAL = new BEMSDBAccessDAL();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@Id", Id.ToString());
                parameters.Add("@ModifiedBy", _UserSession.UserId.ToString());
                DataTable dt = dbAccessDAL.GetDataTable("LLSSoiledLinenCollectionTxn_Delete", parameters, DataSetparameters);
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

        public bool IsSoiledLinenCollectionCodeDuplicate(soildLinencollectionsModel model)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(IsSoiledLinenCollectionCodeDuplicate), Level.Info.ToString());

                var IsDuplicate = true;
                var dbAccessDAL = new BEMSDBAccessDAL();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@Id", model.SoiledLinenCollectionId.ToString());
                parameters.Add("@DocumentNo", model.SoiledLinenCollectionId.ToString());
                parameters.Add("@pCustomerId", Convert.ToString(_UserSession.CustomerId));
                parameters.Add("@pFacilityId", Convert.ToString(_UserSession.FacilityId));
                DataTable dt = dbAccessDAL.GetDataTable("LLSSoiledLinenCollectionTxn_ValCode", parameters, DataSetparameters);
                if (dt != null && dt.Rows.Count > 0)
                {
                    IsDuplicate = Convert.ToBoolean(dt.Rows[0]["IsDuplicate"]);
                }
                Log4NetLogger.LogExit(_FileName, nameof(IsSoiledLinenCollectionCodeDuplicate), Level.Info.ToString());
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

        public bool IsRecordModified(soildLinencollectionsModel model)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(IsRecordModified), Level.Info.ToString());

                var recordModifed = false;

                if (model.SoiledLinenCollectionId != 0)
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
                            cmd.Parameters.AddWithValue("Id", model.SoiledLinenCollectionId);
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
            catch (Exception ex)
            {
                throw ex;
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
                        cmd.CommandText = "LLSSoiledLinenCollectionTxnDetSingle_Delete";
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
