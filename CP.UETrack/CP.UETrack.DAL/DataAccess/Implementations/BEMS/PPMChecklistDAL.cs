using CP.Framework.Common.ExceptionHandler.ExceptionWrappers;
using CP.Framework.Common.Logging;
using CP.UETrack.DAL.DataAccess.Contracts.BEMS;
using CP.UETrack.Model;
using CP.UETrack.Model.BEMS;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using UETrack.DAL;

namespace CP.UETrack.DAL.DataAccess.Implementations.BEMS
{
    public class PPMChecklistDAL : IPPMChecklistDAL
    {
        private readonly string _FileName = nameof(PPMChecklistDAL);
        readonly UserDetailsModel _UserSession = new SessionHelper().UserSession();
        int ppmid;
        public PPMChecklistDAL()
        {

        }
        public PPMCheckListLovs Load()
        {
            try
            {

                Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
                var Lovs = new PPMCheckListLovs();
                string lovs = "PPMCheckListCategoryValue,PPMFrequencyValue";
                var dbAccessDAL = new DBAccessDAL();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pLovKey", lovs);
                DataSet ds = dbAccessDAL.GetDataSet("uspFM_Dropdown", parameters, DataSetparameters);
                if (ds.Tables.Count != 0 && ds.Tables[0].Rows.Count > 0)
                {
                    Lovs.FrequencyList = dbAccessDAL.GetLovRecords(ds.Tables[0], "PPMFrequencyValue");
                    Lovs.PpmCategoryList = dbAccessDAL.GetLovRecords(ds.Tables[0], "PPMCheckListCategoryValue");
                }

                var DataSetparameters1 = new Dictionary<string, DataTable>();
                var parameters1 = new Dictionary<string, string>();
                parameters1.Add("@pTableName", "EngEODParameterMapping");
                DataSet ds1 = dbAccessDAL.GetDataSet("uspFM_Dropdown_Others", parameters1, DataSetparameters1);


                var ds2 = new DataSet();
                var MdbAccessDAL = new MASTERDBAccessDAL();
                using (SqlConnection con = new SqlConnection(MdbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        var da2 = new SqlDataAdapter();
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_GetServices";
                        cmd.Parameters.Clear();
                        //  cmd.Parameters.AddWithValue("@UserRegistrationId", _UserSession.UserId);
                        da2.SelectCommand = cmd;
                        da2.Fill(ds2);
                    }
                }
                if (ds1 != null && ds1.Tables[0] != null && ds1.Tables[0].Rows.Count > 0)
                {
                    Lovs.UOMList = dbAccessDAL.GetLovRecords(ds1.Tables[2]);

                }
                if (ds2 != null && ds2.Tables[0] != null && ds2.Tables[0].Rows.Count > 0)
                {
                    Lovs.Services = dbAccessDAL.GetLovRecords(ds2.Tables[0]);

                }



                Log4NetLogger.LogExit(_FileName, nameof(Load), Level.Info.ToString());
                return Lovs;
            }
            catch (DALException dalex)
            {
                throw new DALException(dalex);
            }
            catch (Exception ex)
            {
                throw;
            }
        }
        public PPMCheckListModel Get(int Id)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
            try
            {
                var dbAccessDAL = new DBAccessDAL();
                var obj = new PPMCheckListModel();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pPPMCheckListId", Id.ToString());
                DataSet ds = dbAccessDAL.GetDataSet("uspFM_EngAssetPPMCheckList_GetById", parameters, DataSetparameters);
                if (ds != null)
                {
                    if (ds.Tables[0] != null && ds.Tables[0].Rows.Count > 0)
                    {
                        obj.PPMCheckListId = Convert.ToInt16(ds.Tables[0].Rows[0]["PPMCheckListId"]);
                        obj.AssetTypeCodeId = Convert.ToInt32(ds.Tables[0].Rows[0]["AssetTypeCodeId"]);
                        obj.AssetTypeCode = Convert.ToString(ds.Tables[0].Rows[0]["AssetTypeCode"]);
                        obj.AssetTypeDescription = Convert.ToString(ds.Tables[0].Rows[0]["AssetTypeCodeDesc"]);
                        obj.TaskCode = Convert.ToString(ds.Tables[0].Rows[0]["TaskCode"]);
                        obj.TaskCodeDesc = Convert.ToString(ds.Tables[0].Rows[0]["TaskDescription"]);
                        obj.PPMChecklistNo = Convert.ToString(ds.Tables[0].Rows[0]["PPMChecklistNo"]);
                        obj.ManufacturerId = Convert.ToInt16(ds.Tables[0].Rows[0]["ManufacturerId"]);
                        obj.Manufacturer = Convert.ToString(ds.Tables[0].Rows[0]["Manufacturer"]);
                        obj.Model = Convert.ToString(ds.Tables[0].Rows[0]["Model"]);
                        obj.ModelId = Convert.ToInt16(ds.Tables[0].Rows[0]["ModelId"]);
                        obj.PPMFrequency = Convert.ToInt16(ds.Tables[0].Rows[0]["PPMFrequency"]);
                        obj.PpmHours = Convert.ToDecimal(ds.Tables[0].Rows[0]["PpmHours"]);
                        obj.SpecialPrecautions = Convert.ToString(ds.Tables[0].Rows[0]["SpecialPrecautions"]);
                        obj.Remarks = Convert.ToString(ds.Tables[0].Rows[0]["Remarks"]);
                        obj.ServiceId = Convert.ToInt32(ds.Tables[0].Rows[0]["ServiceId"]);
                        obj.HiddenId = Convert.ToString(ds.Tables[0].Rows[0]["GuId"]);
                        obj.Timestamp = Convert.ToBase64String((byte[])(ds.Tables[0].Rows[0]["Timestamp"]));
                    }

                    if (ds.Tables[1] != null && ds.Tables[1].Rows.Count > 0)
                    {

                        var Quantasks = (from n in ds.Tables[1].AsEnumerable()
                                         select new PPMCheckListQuantasksMstDetModel
                                         {
                                             PPMCheckListQNId = Convert.ToInt32(n["PPMCheckListQNId"]),
                                             QuantitativeTasks = Convert.ToString(n["QuantitativeTasks"]),
                                             UOM = n.Field<int?>("UOM"),                                            
                                             SetValues = Convert.ToString(n["SetValues"]),
                                             LimitTolerance = Convert.ToString(n["LimitTolerance"]),
                                             Active = Convert.ToBoolean(n["Active"])
                                         }).ToList();

                        if (Quantasks != null && Quantasks.Count > 0)
                        {
                            obj.PPMCheckListQuantasksMstDets = Quantasks;

                        }
                        if (ds.Tables[2] != null && ds.Tables[2].Rows.Count > 0)
                        {

                            var gridList = (from n in ds.Tables[2].AsEnumerable()
                                            select new PPmChecklistCategoryDet
                                            {
                                                PPmCategoryDetId = Convert.ToInt32(n["CategoryId"]),
                                                PpmCategoryId = Convert.ToInt32(n["PPMCheckListCategoryId"]),
                                                SNo = Convert.ToInt16(n["Number"]),
                                                Description = Convert.ToString(n["Description"]),
                                                Active = Convert.ToBoolean(n["Active"])
                                            }).ToList();

                            if (gridList != null && gridList.Count > 0)
                            {
                                obj.PPmChecklistCategoryDets = gridList;

                            }
                        }
                    }
                }

                Log4NetLogger.LogExit(_FileName, nameof(Get), Level.Info.ToString());
                return obj;

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
        public PPMCheckListModel Save(PPMCheckListModel model, out string ErrorMessage)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());
            try
            {
                int Sno1 = 0;
                int Sno2 = 0;
                int Sno3 = 0;
                int Sno4 = 0; 
                var dbAccessDAL = new DBAccessDAL();
                var BdbAccessDAL = new MASTERBEMSDBAccessDAL();
                var FdbAccessDAL = new MASTERFEMSDBAccessDAL();
                ErrorMessage = string.Empty;
                var parameters = new Dictionary<string, string>();
                var SUBparameters = new Dictionary<string, string>();
                var parametersforupdate = new Dictionary<string, string>();
                var parametersID = new Dictionary<string, string>();
                parameters.Add("@PPMCheckListId",Convert.ToString(model.PPMCheckListId));
                parameters.Add("@AssetTypeCodeId", model.AssetTypeCodeId.ToString());
                parameters.Add("@ServiceId", Convert.ToString(model.ServiceId));
                parameters.Add("@ManufacturerId", model.ManufacturerId.ToString());
                parameters.Add("@ModelId", Convert.ToString(model.ModelId));
                parameters.Add("@PPMFrequency", Convert.ToString(model.PPMFrequency));
                parameters.Add("@PpmHours", Convert.ToString(model.PpmHours));
                parameters.Add("@SpecialPrecautions", Convert.ToString(model.SpecialPrecautions));

                parameters.Add("@Remarks", Convert.ToString(model.Remarks));
                parameters.Add("@UserId", Convert.ToString(_UserSession.UserId));
                parameters.Add("@TaskCode", Convert.ToString(model.TaskCode));
                parameters.Add("@TaskCodeDesc", Convert.ToString(model.TaskCodeDesc));
                

                var DataSetparameters = new Dictionary<string, DataTable>();
                var DataSetparametersEM = new Dictionary<string, DataTable>();
                DataTable dtCat = new DataTable();
                dtCat.Columns.Add("CategoryId", typeof(int));
                dtCat.Columns.Add("PPMCheckListId", typeof(int));
                dtCat.Columns.Add("PPMCheckListCategoryId", typeof(int));
                dtCat.Columns.Add("Number", typeof(string));
                dtCat.Columns.Add("Description", typeof(string));
                dtCat.Columns.Add("IsWorkOrder", typeof(bool));
                dtCat.Columns.Add("Active", typeof(bool));
                dtCat.Columns.Add("BuiltIn", typeof(bool));

                foreach (var ppm in model.PPmChecklistCategoryDets)
                {
                    var number = 0;
                    if (!ppm.Active)
                    {
                        number = 1;
                    }
                    else
                    {
                        if (ppm.PpmCategoryId == 276)
                        {
                            Sno1++;
                            number = Sno1;
                        }
                        else if (ppm.PpmCategoryId == 277)
                        {
                            Sno2++;
                            number = Sno2;
                        }
                        else if (ppm.PpmCategoryId == 278)
                        {
                            Sno3++;
                            number = Sno3;
                        }
                        else if (ppm.PpmCategoryId == 384)
                        {
                            Sno4++;
                            number = Sno4;
                        }

                    }
                    dtCat.Rows.Add(ppm.PPmCategoryDetId, model.PPMCheckListId, ppm.PpmCategoryId, number, ppm.Description,
                        true, ppm.Active == true ? "true" : "false", true);
                }




                DataTable QuantasksDt = new DataTable();
                QuantasksDt.Columns.Add("PPMCheckListQNId", typeof(int));
                QuantasksDt.Columns.Add("QuantitativeTasks", typeof(string));
                QuantasksDt.Columns.Add("UOM", typeof(int));
                QuantasksDt.Columns.Add("SetValues", typeof(string));
                QuantasksDt.Columns.Add("LimitTolerance", typeof(string));
                QuantasksDt.Columns.Add("Active", typeof(bool));
                foreach (var task in model.PPMCheckListQuantasksMstDets)
                {
                    QuantasksDt.Rows.Add(task.PPMCheckListQNId, task.QuantitativeTasks, task.UOM, task.SetValues, task.LimitTolerance,
                       task.Active == true ? "true" : "false");
                }

                DataSetparameters.Add("@EngAssetPPMCheckListCategory", dtCat);
                DataSetparameters.Add("@EngAssetPPMCheckListQuantasksMstDetType", QuantasksDt);
                DataTable dt = dbAccessDAL.GetDataTable("uspFM_EngAssetPPMCheckList_Save", parameters, DataSetparameters);
                
                if (dt != null)
                {
                    foreach (DataRow row in dt.Rows)
                    {
                         ppmid = Convert.ToInt32(row["PPMCheckListId"]);
                        if (ppmid==0)
                        {
                        }
                        else {
                            model.PPMCheckListId = Convert.ToInt32(row["PPMCheckListId"]);
                            model.PPMChecklistNo = Convert.ToString(row["OUTPPMChecklistNo"]);
                            model.TaskCode = Convert.ToString(row["Taskcodes"]);
                        }
                    }
                }
                if (ppmid == 0)
                {
                }
                else
                {
                    SUBparameters = parameters;
                    SUBparameters.Remove("@AssetTypeCodeId");
                    SUBparameters.Remove("@ManufacturerId");
                    SUBparameters.Remove("@ModelId");
                    SUBparameters.Remove("@TaskCode");
                    parametersID.Add("@pAssetTypeCodeId", Convert.ToString(model.AssetTypeCodeId));
                    parametersID.Add("@pManufacturerId", model.ManufacturerId.ToString());
                    parametersID.Add("@pModelId", Convert.ToString(model.ModelId));

                    DataTable dtMasterID = dbAccessDAL.GetDataTable("uspFM_EngAssetTypeCode_Get_AssetTypeCodeId_mappingTo_SeviceDB", parametersID, DataSetparametersEM);
                    SUBparameters.Add("@PPMChecklistNo", Convert.ToString(model.PPMChecklistNo));
                    if (dtMasterID != null)
                    {
                        foreach (DataRow row in dtMasterID.Rows)
                        {
                            model.ManufacturerId = Convert.ToInt32(row["ManufacturerId_mappingTo_SeviceDB"]);
                            model.ModelId = Convert.ToInt32(row["ModelId_mappingTo_SeviceDB"]);
                            model.AssetTypeCodeId = Convert.ToInt32(row["AssetTypeCodeId_mappingTo_SeviceDB"]);
                            ///   ErrorMessage = Convert.ToString(row["ErrorMessage"]);
                        }

                        SUBparameters.Add("@AssetTypeCodeId", model.AssetTypeCodeId.ToString());
                        // parameters.Add("@ServiceId", Convert.ToString(model.ServiceId));
                        SUBparameters.Add("@ManufacturerId", model.ManufacturerId.ToString());
                        SUBparameters.Add("@ModelId", Convert.ToString(model.ModelId));
                        SUBparameters.Add("@TaskCode", Convert.ToString(model.TaskCode));
                    }
                    string PPMID;

                    if (model.ServiceId == 2)
                    {

                        DataTable dts = BdbAccessDAL.GetMasterDataTable("uspFM_EngAssetPPMCheckList_Save", SUBparameters, DataSetparameters);
                        PPMID = dts.Rows[0]["PPMCheckListId"].ToString();
                    }
                    else
                    {
                        DataTable dts = FdbAccessDAL.GetMasterDataTable("uspFM_EngAssetPPMCheckList_Save", SUBparameters, DataSetparameters);
                        PPMID = dts.Rows[0]["PPMCheckListId"].ToString();
                    }

                    parametersforupdate.Add("@pSub_PPMCheckListId", Convert.ToString(PPMID));
                    parametersforupdate.Add("@pPPMCheckListId", Convert.ToString(model.PPMCheckListId));
                    DataTable dtMasterIDs = dbAccessDAL.GetDataTable("EngAssetPPMCheckList_subDBids_Update", parametersforupdate, DataSetparametersEM);
                    

                }
                if (dt != null)
                {
                    foreach (DataRow row in dt.Rows)
                    {
                        model.PPMCheckListId = Convert.ToInt32(row["PPMCheckListId"]);
                        ErrorMessage = Convert.ToString(row["ErrorMessage"]);
                    }
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
                throw;
            }
        }
        public void Delete(int Id, out string ErrorMessage)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Delete), Level.Info.ToString());
            var BdbAccessDAL = new MASTERBEMSDBAccessDAL();
            var FdbAccessDAL = new MASTERFEMSDBAccessDAL();
            try
            {
                ErrorMessage = string.Empty;
                var dbAccessDAL = new DBAccessDAL();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                int service=0, Sub_PPMCheckListId=0;

                parameters.Add("@Id", Id.ToString());
                DataTable dt = dbAccessDAL.GetDataTable("uspFM_EngAssetPPMCheckList_Delete", parameters, DataSetparameters);
                if (dt != null && dt.Rows.Count > 0)
                {
                    ErrorMessage = Convert.ToString(dt.Rows[0]["ErrorMessage"]);
                    service = Convert.ToInt32(dt.Rows[0]["serviceId"]);
                    Sub_PPMCheckListId= Convert.ToInt32(dt.Rows[0]["Sub_PPMCheckListId"]);
                }
                parameters.Clear();
                parameters.Add("@Id", Sub_PPMCheckListId.ToString());
                if (service==1)
                {
                    DataTable dts = FdbAccessDAL.GetMasterDataTable("uspFM_EngAssetPPMCheckList_Delete", parameters, DataSetparameters);
                }
                else
                {
                    if (service == 2)
                    {
                        DataTable dts = BdbAccessDAL.GetMasterDataTable("uspFM_EngAssetPPMCheckList_Delete", parameters, DataSetparameters);
                    }
                    else
                    {
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

        public PPMCheckListModel GetHistory(int id)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
            try
            {
                var dbAccessDAL = new DBAccessDAL();
                var obj = new PPMCheckListModel();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pPPMCheckListId", id.ToString());
                DataSet ds = dbAccessDAL.GetDataSet("uspFM_EngAssetPPMCheckList_GetHistoryById", parameters, DataSetparameters);
                if (ds != null)
                {
                    if (ds.Tables[0] != null && ds.Tables[0].Rows.Count > 0)
                    {
                        var list  = (from n in ds.Tables[0].AsEnumerable()
                                         select new CategoryHistory
                                         {
                                             Version = Convert.ToDecimal(n["Version"]),
                                             ModifiedBy = Convert.ToString(n["ModifiedBy"]),
                                             EffectiveFromDate = Convert.ToDateTime(n["EffectiveFromDate"]),                                

                                         }).ToList();

                        if (list != null && list.Count > 0)
                        {
                            obj.CategoryHistoryList = list;

                        }
                        if (ds.Tables[1] != null && ds.Tables[1].Rows.Count > 0)
                        {

                            var list1 = (from n in ds.Tables[1].AsEnumerable()
                                        select new QunantityHistory
                                        {
                                            Version = Convert.ToDecimal(n["Version"]),
                                            ModifiedBy = Convert.ToString(n["ModifiedBy"]),
                                            EffectiveFromDate = Convert.ToDateTime(n["EffectiveFromDate"]),

                                        }).ToList();
                            if (list1 != null && list1.Count > 0)
                            {
                                obj.QunantityHistoryList = list1;
                            }
                        }
                    }
                }
                Log4NetLogger.LogExit(_FileName, nameof(Get), Level.Info.ToString());
                return obj;
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

        public PPMCheckListModel GetPopupDetails(int primaryId, int version, int gridId)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
            try
            {
                var dbAccessDAL = new DBAccessDAL();
                var obj = new PPMCheckListModel();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pPPMCheckListId", primaryId.ToString());
                parameters.Add("@pVersion", version.ToString());
                parameters.Add("@pGridId", gridId.ToString());
                DataSet ds = dbAccessDAL.GetDataSet("uspFM_EngAssetPPMCheckList_GetPopupHistory", parameters, DataSetparameters);
                if (ds != null)
                {
                    if (gridId == 1)
                    {
                        if (ds.Tables[0] != null && ds.Tables[0].Rows.Count > 0)
                        {

                            var gridList = (from n in ds.Tables[0].AsEnumerable()
                                            select new PPmChecklistCategoryDet
                                            {
                                               // PPmCategoryDetId = Convert.ToInt32(n["CategoryId"]),
                                                PPmCategory = Convert.ToString(n["PPmCategory"]),
                                                SNo = Convert.ToInt16(n["Number"]),
                                                Description = Convert.ToString(n["Description"]),
                                               // Active = Convert.ToBoolean(n["Active"])
                                            }).ToList();

                            if (gridList != null && gridList.Count > 0)
                            {
                                obj.CategoryPopupHistoryList = gridList;

                            }
                        }

                        if (ds.Tables[1] != null && ds.Tables[1].Rows.Count > 0)
                        {
                            var Quantasks = (from n in ds.Tables[1].AsEnumerable()
                                             select new PPMCheckListQuantasksMstDetModel
                                             {
                                                 PPMCheckListQNId = Convert.ToInt32(n["PPMCheckListQNId"]),
                                                 QuantitativeTasks = Convert.ToString(n["QuantitativeTasks"]),
                                                 UOMValue = Convert.ToString(n["UOM"]),
                                                 SetValues = Convert.ToString(n["SetValues"]),
                                                 LimitTolerance = Convert.ToString(n["LimitTolerance"]),
                                                 //Active = Convert.ToBoolean(n["Active"])
                                             }).ToList();

                            if (Quantasks != null && Quantasks.Count > 0)
                            {
                                obj.QunantityPopupHistoryList = Quantasks;

                            }

                        }
                    }
                  
                   
                }
                Log4NetLogger.LogExit(_FileName, nameof(Get), Level.Info.ToString());
                return obj;
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

        public PPMCheckListModel SetDB(int Id)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
            try
            {
                var dbAccessDAL = new DBAccessDAL();
                var obj = new PPMCheckListModel();
               

                Log4NetLogger.LogExit(_FileName, nameof(Get), Level.Info.ToString());
                return obj;

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




//}
