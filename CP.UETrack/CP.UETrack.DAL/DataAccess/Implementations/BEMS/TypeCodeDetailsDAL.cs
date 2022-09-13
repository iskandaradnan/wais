using CP.UETrack.DAL.DataAccess.Contracts.BEMS;
using System;
using System.Collections.Generic;
using CP.UETrack.Model.BEMS;
using CP.Framework.Common.Logging;
using CP.UETrack.Model;
using UETrack.DAL;
using System.Data;
using CP.Framework.Common.ExceptionHandler.ExceptionWrappers;
using System.Linq;
using System.Data.SqlClient;

namespace CP.UETrack.DAL.DataAccess.Implementations.BEMS
{
    public class TypeCodeDetailsDAL : ITypeCodeDetailsDAL
    {
        private readonly string _FileName = nameof(UserRoleDAL);
        readonly UserDetailsModel _UserSession = new SessionHelper().UserSession();
        string subdb;
        public EngAssetTypeCode Get(int Id)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
            try
            {
                var dbAccessDAL = new DBAccessDAL();
                var obj = new EngAssetTypeCode();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pAssetTypeCodeId", Id.ToString());
                DataSet ds = dbAccessDAL.GetDataSet("uspFM_EngAssetTypeCode_GetById", parameters, DataSetparameters);
                if (ds != null)
                {
                    if (ds.Tables[0] != null && ds.Tables[0].Rows.Count > 0)
                    {
                        obj.AssetTypeCodeId = Convert.ToInt16(ds.Tables[0].Rows[0]["AssetTypeCodeId"]);
                        obj.ServiceId = Convert.ToInt16(ds.Tables[0].Rows[0]["ServiceId"]);
                        obj.AssetClassificationId = Convert.ToInt32(ds.Tables[0].Rows[0]["AssetClassificationId"]);
                        obj.AssetClassificationCode = Convert.ToString(ds.Tables[0].Rows[0]["AssetClassificationCode"]);
                        obj.AssetClassificationDescription = Convert.ToString(ds.Tables[0].Rows[0]["AssetClassificationDescription"]);
                        obj.AssetTypeCode = Convert.ToString(ds.Tables[0].Rows[0]["AssetTypeCode"]);
                        obj.AssetTypeDescription = Convert.ToString(ds.Tables[0].Rows[0]["AssetTypeDescription"]);
                        //obj.TypeofContractLovId = Convert.ToInt16(ds.Tables[0].Rows[0]["TypeOfContractLovId"]);
                        obj.EquipmentFunctionCatagoryLovId = Convert.ToInt16(ds.Tables[0].Rows[0]["EquipmentFunctionCatagoryLovId"]);
                        //obj.IsLicenceAndCertificateApplicable = Convert.ToBoolean(ds.Tables[0].Rows[0]["IsLicenceAndCertificateApplicable"]);
                        obj.LifeExpectancyId = ds.Tables[0].Rows[0]["LifeExpectancy"] != DBNull.Value ? Convert.ToInt32(ds.Tables[0].Rows[0]["LifeExpectancy"]) : (int?)null;
                        obj.QAPAssetTypeB1 = Convert.ToBoolean(ds.Tables[0].Rows[0]["QAPAssetTypeB1"]);
                        obj.QAPServiceAvailabilityB2 = Convert.ToBoolean(ds.Tables[0].Rows[0]["QAPServiceAvailabilityB2"]);
                        obj.QAPUptimeTargetPerc = ds.Tables[0].Rows[0]["QAPUptimeTargetPerc"] != DBNull.Value ? Convert.ToDecimal(ds.Tables[0].Rows[0]["QAPUptimeTargetPerc"]) : (decimal?)null;
                        obj.EffectiveFrom = ds.Tables[0].Rows[0]["EffectiveFrom"] != DBNull.Value ? (Convert.ToDateTime(ds.Tables[0].Rows[0]["EffectiveFrom"])) : (DateTime?)null;
                        obj.EffectiveFromUTC = ds.Tables[0].Rows[0]["EffectiveFromUTC"] != DBNull.Value ? (Convert.ToDateTime(ds.Tables[0].Rows[0]["EffectiveFromUTC"])) : (DateTime?)null;
                        obj.EffectiveTo = ds.Tables[0].Rows[0]["EffectiveTo"] != DBNull.Value ? (Convert.ToDateTime(ds.Tables[0].Rows[0]["EffectiveTo"])) : (DateTime?)null;
                        obj.EffectiveToUTC = ds.Tables[0].Rows[0]["EffectiveToUTC"] != DBNull.Value ? (Convert.ToDateTime(ds.Tables[0].Rows[0]["EffectiveToUTC"])) : (DateTime?)null;
                        obj.TRPILessThan5YrsPerc = Convert.ToDecimal(ds.Tables[0].Rows[0]["TRPILessThan5YrsPerc"]);
                        obj.TRPI5to10YrsPerc = Convert.ToDecimal(ds.Tables[0].Rows[0]["TRPI5to10YrsPerc"]);
                        obj.TRPIGreaterThan10YrsPerc = Convert.ToDecimal(ds.Tables[0].Rows[0]["TRPIGreaterThan10YrsPerc"]);
                        obj.Timestamp = Convert.ToBase64String((byte[])(ds.Tables[0].Rows[0]["Timestamp"]));
                        obj.ExpectedLifeSpan = Convert.ToInt32(ds.Tables[0].Rows[0]["ExpectedLifeSpan"]);
                        obj.Criticality = Convert.ToInt32(ds.Tables[0].Rows[0]["Criticality"]);
                        //obj.AssetTypeCodeId_mappingTo_SeviceDB= Convert.ToInt32(ds.Tables[0].Rows[0]["AssetTypeCodeId_mappingTo_SeviceDB"] != DBNull.Value ? Convert.ToInt32(ds.Tables[0].Rows[0]["AssetTypeCodeId_mappingTo_SeviceDB"]) : (Int32?)null);
                    }
                    if (ds.Tables[1] != null && ds.Tables[1].Rows.Count > 0)
                    {

                        var TestAppMstDets = (from n in ds.Tables[1].AsEnumerable()
                                              select new EngAssetTypeCodeFlag
                                              {
                                                  AssetTypeCodeFlagId = Convert.ToInt32(n["AssetTypeCodeFlagId"]),
                                                  MaintenanceFlag = Convert.ToInt32(n["MaintenanceFlag"]),
                                              }).ToList();

                        if (TestAppMstDets != null && TestAppMstDets.Count > 0)
                        {
                            obj.MaintainanceFlagList = TestAppMstDets.Select(x => x.MaintenanceFlag).ToList();
                        }
                    }
                    if (ds.Tables[2] != null && ds.Tables[2].Rows.Count > 0)
                    {

                        var variationList = (from n in ds.Tables[2].AsEnumerable()
                                             select new EngAssetTypeCodeVariationRate
                                             {
                                                 AssetTypeCodeVariationId = Convert.ToInt32(n["AssetTypeCodeVariationId"]),
                                                 TypeCodeParameterId = Convert.ToInt32(n["TypeCodeParameterId"]),
                                                 VariationRate = Convert.ToDecimal(n["VariationRate"]),
                                                 TypeCodeParameter = Convert.ToString(n["TypeCodeParameter"]),
                                                 EffectiveFromDate = Convert.ToDateTime(n["EffectiveFromDate"])
                                             }).ToList();

                        if (variationList != null && variationList.Count > 0)
                        {
                            obj.EngAssetTypeCodeVariationRates = variationList;

                        }
                    }

                    //if (ds.Tables[3] != null && ds.Tables[3].Rows.Count > 0)
                    //{

                    //    var assetSpecificationList = (from n in ds.Tables[3].AsEnumerable()
                    //                                  select new EngAssetTypeCodeAddSpecification
                    //                                  {
                    //                                      AssetTypeCodeAddSpecId = Convert.ToInt32(n["AssetTypeCodeAddSpecId"]),
                    //                                      SpecificationType = Convert.ToInt32(n["SpecificationType"]),
                    //                                      SpecificationUnit = Convert.ToInt32(n["SpecificationUnit"]),
                    //                                  }).ToList();
                    //    if (assetSpecificationList != null && assetSpecificationList.Count > 0)
                    //        obj.EngAssetTypeCodeAddSpecifications = assetSpecificationList;
                    //}
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
        public EngAssetTypeCodeLovs Load()
        {
            try
            {
                var srevicesDS = new DataSet();
                Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
                EngAssetTypeCodeLovs assets = new EngAssetTypeCodeLovs();
                string lovs = "MaintenanceFlagValue,EquipmentFunctionDescriptionValue,YesNoValue,LifeExpectancyValue,TypeOfContractValue,Criticality";
                var dbAccessDAL = new DBAccessDAL();
                var servicesDS = new DataSet();
                var obj = new EngAssetClassification();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pLovKey", lovs);
                DataSet ds = dbAccessDAL.GetDataSet("uspFM_Dropdown", parameters, DataSetparameters);
                parameters.Clear();
                DataSetparameters.Clear();
                DataSet dss = dbAccessDAL.GetDataSet("uspFM_GetServices", parameters, DataSetparameters);

                ///--------------
                /// //Get services
                //var da2 = new SqlDataAdapter();
                //cmd.Connection = con;
                //cmd.CommandType = CommandType.StoredProcedure;
                //cmd.CommandText = "uspFM_GetServices";
                //cmd.Parameters.Clear();
                ////  cmd.Parameters.AddWithValue("@UserRegistrationId", _UserSession.UserId);
                //da2.SelectCommand = cmd;
                //da2.Fill(srevicesDS);
                ////----------------------
                if (ds.Tables.Count != 0 && ds.Tables[0].Rows.Count > 0)
                {

                    assets.EngAssetTypeCodeFlagLovs = dbAccessDAL.GetLovRecords(ds.Tables[0], "MaintenanceFlagValue");
                    assets.EquipmentFunctionCatagoryLovs = dbAccessDAL.GetLovRecords(ds.Tables[0], "EquipmentFunctionDescriptionValue");
                    assets.StatusLovs = dbAccessDAL.GetLovRecords(ds.Tables[0], "YesNoValue");
                    assets.LifeExpectancyValueLovs = dbAccessDAL.GetLovRecords(ds.Tables[0], "LifeExpectancyValue");
                    assets.CriticalityList = dbAccessDAL.GetLovRecords(ds.Tables[0], "Criticality");
                    assets.TypeOfContractValueLovs = dbAccessDAL.GetLovRecords(ds.Tables[0], "TypeOfContractValue");
                    assets.Services = dbAccessDAL.GetLovRecords(dss.Tables[0]);
                }
                var DataSetparameters1 = new Dictionary<string, DataTable>();
                var parameters1 = new Dictionary<string, string>();
                parameters1.Add("@pLovKey", null);
                parameters1.Add("@pTableName", "EngAssetTypeCode");
                DataSet ds1 = dbAccessDAL.GetDataSet("uspFM_Dropdown_Others", parameters1, DataSetparameters1);
                if (ds1.Tables.Count != 0 && ds1.Tables[0].Rows.Count > 0)
                {
                    assets.ServiceList = dbAccessDAL.GetLovRecords(ds.Tables[0]);
                }
                if (ds1.Tables.Count != 0 && ds1.Tables[1].Rows.Count > 0)
                {
                    assets.EngAssetTypeCodeVariationRates = (from n in ds1.Tables[1].AsEnumerable()

                                                             select new EngAssetTypeCodeVariationRate
                                                             {
                                                                 TypeCodeParameterId = Convert.ToInt32(n["LovId"]),
                                                                 TypeCodeParameter = Convert.ToString(n["FieldValue"]),
                                                                 EffectiveFromDate= DateTime.Now
                                                             }).ToList();
                }



                Log4NetLogger.LogExit(_FileName, nameof(Load), Level.Info.ToString());
                return assets;
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
            try
            {
                ErrorMessage = string.Empty;
                //string Message = string.Empty;
                var dbAccessDAL = new DBAccessDAL();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pAssetTypeCodeId", Id.ToString());
                DataTable dt = dbAccessDAL.GetDataTable("uspFM_EngAssetTypeCode_Delete", parameters, DataSetparameters);
                if (dt != null && dt.Rows.Count > 0)
                {
                    ErrorMessage = Convert.ToString(dt.Rows[0]["ErrorMessage"]);
                }
                Log4NetLogger.LogExit(_FileName, nameof(Delete), Level.Info.ToString());
                // return (string.IsNullOrEmpty(Message)) ? true : false;
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
        

        public EngAssetTypeCode Save(EngAssetTypeCode model, out string ErrorMessage)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());
            try
            {
                ErrorMessage = string.Empty;
                var DataSetparameters = new Dictionary<string, DataTable>();
                DataTable TypecodeDt = new DataTable();
                TypecodeDt.Columns.Add("AssetTypeCodeId", typeof(int));
                TypecodeDt.Columns.Add("ServiceId", typeof(int));
                TypecodeDt.Columns.Add("AssetClassificationId", typeof(int));
                TypecodeDt.Columns.Add("AssetTypeCode", typeof(string));
                TypecodeDt.Columns.Add("AssetTypeDescription", typeof(string));
                TypecodeDt.Columns.Add("EquipmentFunctionCatagoryLovId", typeof(int));
                TypecodeDt.Columns.Add("QAPAssetTypeB1", typeof(bool));
                TypecodeDt.Columns.Add("QAPServiceAvailabilityB2", typeof(bool));
                TypecodeDt.Columns.Add("QAPUptimeTargetPerc", typeof(decimal));
                TypecodeDt.Columns.Add("EffectiveFrom", typeof(DateTime));
                TypecodeDt.Columns.Add("EffectiveFromUTC", typeof(DateTime));
                TypecodeDt.Columns.Add("EffectiveTo", typeof(DateTime));
                TypecodeDt.Columns.Add("EffectiveToUTC", typeof(DateTime));
                TypecodeDt.Columns.Add("TRPILessThan5YrsPerc", typeof(decimal));
                TypecodeDt.Columns.Add("TRPI5to10YrsPerc", typeof(decimal));
                TypecodeDt.Columns.Add("TRPIGreaterThan10YrsPerc", typeof(decimal));
                TypecodeDt.Columns.Add("UserId", typeof(int));
                TypecodeDt.Columns.Add("TypeOfContractLovId", typeof(int));
                TypecodeDt.Columns.Add("LifeExpectancy", typeof(int));
               // TypecodeDt.Columns.Add("Criticality", typeof(string));
                DataRow row = TypecodeDt.NewRow();
                row["AssetTypeCodeId"] = model.AssetTypeCodeId;
                row["ServiceId"] = model.ServiceId;
                row["AssetClassificationId"] = model.AssetClassificationId;
                row["AssetTypeCode"] = model.AssetTypeCode;
                row["AssetTypeDescription"] = model.AssetTypeDescription;
                row["EquipmentFunctionCatagoryLovId"] = model.EquipmentFunctionCatagoryLovId;
                row["QAPAssetTypeB1"] = model.QAPAssetTypeB1;
                row["QAPServiceAvailabilityB2"] = model.QAPServiceAvailabilityB2;
                //row["Criticality"] = model.Criticality;


                if (model.QAPUptimeTargetPerc.HasValue)
                {
                    row["QAPUptimeTargetPerc"] = model.QAPUptimeTargetPerc;
                }
                else {
                    row["QAPUptimeTargetPerc"] = DBNull.Value;
                }


                if (model.EffectiveFrom != null)
                {
                    row["EffectiveFrom"] = model.EffectiveFrom.Value.ToString("yyyy-MM-dd");
                }
                else
                {
                    row["EffectiveFrom"] = DBNull.Value;
                }
                if (model.EffectiveFromUTC != null)
                {
                    row["EffectiveFromUTC"] = model.EffectiveFromUTC.Value.ToString("yyyy-MM-dd");
                }
                else
                {
                    row["EffectiveFromUTC"] = DBNull.Value;
                }
                if (model.EffectiveTo != null)
                {
                    row["EffectiveTo"] = model.EffectiveTo.Value.ToString("yyyy-MM-dd");
                }
                else
                {
                    row["EffectiveTo"] = DBNull.Value;
                }
                if (model.EffectiveToUTC != null)
                {
                    row["EffectiveToUTC"] = model.EffectiveToUTC.Value.ToString("yyyy-MM-dd");
                }
                else
                {
                    row["EffectiveToUTC"] = DBNull.Value;
                }
                //if (model.Criticality != null)
                //{
                //    row["Criticality"] = model.Criticality;
                //}
               
                //row["EffectiveFromUTC"] = model.EffectiveFrom != null ? model.EffectiveFrom.Value.ToString("yyyy-MM-dd") : DBNull.Value;
                //row["EffectiveTo"] = model.EffectiveTo != null ? model.EffectiveTo.Value.ToString("yyyy-MM-dd") : null;
                //row["EffectiveToUTC"] = model.EffectiveTo != null ? model.EffectiveTo.Value.ToString("yyyy-MM-dd") : null;
                row["TRPILessThan5YrsPerc"] = model.TRPILessThan5YrsPerc;
                row["TRPI5to10YrsPerc"] = model.TRPI5to10YrsPerc;
                row["TRPIGreaterThan10YrsPerc"] = model.TRPIGreaterThan10YrsPerc;
                row["UserId"] = _UserSession.UserId;
                row["TypeOfContractLovId"] =1;

                if (model.LifeExpectancyId != null)
                {
                    row["LifeExpectancy"] = model.LifeExpectancyId;
                }
                else
                {
                    row["LifeExpectancy"] = DBNull.Value; 
                }
                
                TypecodeDt.Rows.Add(row);

                DataTable flagdt = new DataTable();
                flagdt.Columns.Add("AssetTypeCodeFlagId", typeof(int));
                flagdt.Columns.Add("AssetTypeCodeId", typeof(int));
                flagdt.Columns.Add("MaintenanceFlag", typeof(int));
                flagdt.Columns.Add("UserId", typeof(int));
                // List<int> MaintaininceFlagList = model.MaintenanceFlag.Split(',').Select(int.Parse).ToList();
                foreach (var flagid in model.MaintainanceFlagList)
                {
                    flagdt.Rows.Add(0, model.AssetTypeCodeId, flagid, _UserSession.UserId);
                }              

                DataTable varDt = new DataTable();
                varDt.Columns.Add("AssetTypeCodeVariationId", typeof(int));
                varDt.Columns.Add("AssetTypeCodeId", typeof(int));
                varDt.Columns.Add("TypeCodeParameterId", typeof(int));
                varDt.Columns.Add("VariationRate", typeof(decimal));

                varDt.Columns.Add("EffectiveFromDate", typeof(DateTime));
                varDt.Columns.Add("EffectiveFromDateUTC", typeof(DateTime));
                varDt.Columns.Add("UserId", typeof(int));
                if (model.EngAssetTypeCodeVariationRates != null)
                {
                    foreach (var var in model.EngAssetTypeCodeVariationRates)
                    {
                        string EffectiveFrom = null;
                        if (var.EffectiveFromDate != null)
                        {
                            EffectiveFrom = var.EffectiveFromDate.Value.ToString("yyyy-MM-dd");
                        }
                        varDt.Rows.Add(var.AssetTypeCodeVariationId, model.AssetTypeCodeId, var.TypeCodeParameterId, var.VariationRate, EffectiveFrom, EffectiveFrom, _UserSession.UserId);
                    }
                }
                DataSetparameters.Add("@EngAssetTypeCode", TypecodeDt);
                DataSetparameters.Add("@EngAssetTypeCodeFlag", flagdt);
                //DataSetparameters.Add("@EngAssetTypeCodeAddSpecification", popupDt);
                DataSetparameters.Add("@EngAssetTypeCodeVariationRate", varDt);

                var parameters = new Dictionary<string, string>();
                
                parameters.Add("@pAssetTypeCodeId", Convert.ToString(model.AssetTypeCodeId));
                parameters.Add("@pExpectedLifeSpan", Convert.ToString(model.ExpectedLifeSpan));
                parameters.Add("@pTimestamp", Convert.ToString(model.Timestamp));
                parameters.Add("@pCriticality", Convert.ToString(model.Criticality));
               
                //var dbAccessDAL = new MASTERBEMSDBAccessDAL();
                var dbAccessDAL = new DBAccessDAL();
                
                DataTable dt = dbAccessDAL.GetDataTable("uspFM_EngAssetTypeCode_Save", parameters, DataSetparameters);

                //-----inserto other DB
                var typeCodeparameters = new Dictionary<string, string>();
                var TypeCodeDataSetparameters = new Dictionary<string, DataTable>();
                var obj = new EngAssetTypeCode();
                DataTable otherDB = new DataTable();
                if (dt != null)
                {
                    foreach (DataRow rows in dt.Rows)
                    {
                        model.AssetTypeCodeId = Convert.ToInt32(rows["AssetTypeCodeId"]);
                        typeCodeparameters.Add("@pAssetTypeCodeId", model.AssetTypeCodeId.ToString());
                        DataSet ds = dbAccessDAL.GetDataSet("uspFM_EngAssetTypeCodesServiceMapping_GetById", typeCodeparameters, TypeCodeDataSetparameters);

                        if (ds != null)
                        {
                            if (ds.Tables[0] != null && ds.Tables[0].Rows.Count > 0)
                            {
                                obj.AssetTypeCodeId_mappingTo_SeviceDB = Convert.ToInt16(ds.Tables[0].Rows[0]["AssetTypeCodeId_mappingTo_SeviceDB"]);

                            }
                        }
                    }

                }
                if (obj.AssetTypeCodeId_mappingTo_SeviceDB == 0)
                {
                    if (model.ServiceId == 1)
                    {
                        var DataSetparametersFEMS = get_savemethods(model);
                        var dbAccessDALs = new MASTERFEMSDBAccessDAL();
                        otherDB = dbAccessDALs.GetMasterDataTable("uspFM_EngAssetTypeCode_Save", parameters, DataSetparametersFEMS);
                    }
                    else
                    {
                        var DataSetparametersBEMS = get_savemethods(model);
                        var dbAccessDALs = new MASTERBEMSDBAccessDAL();
                        otherDB = dbAccessDALs.GetMasterDataTable("uspFM_EngAssetTypeCode_Save", parameters, DataSetparametersBEMS);
                    }

                    if (otherDB != null)
                    {
                        foreach (DataRow rows in otherDB.Rows)
                        {
                            subdb = rows["AssetTypeCodeId"].ToString();
                        }
                    }
                    if (dt != null)
                    {
                        foreach (DataRow rows in dt.Rows)
                        {
                            model.AssetTypeCodeId = Convert.ToInt32(rows["AssetTypeCodeId"]);
                            if (rows["Timestamp"] == DBNull.Value)
                            {
                                model.Timestamp = "";
                            }
                            else
                            {
                                model.Timestamp = Convert.ToBase64String((byte[])(rows["Timestamp"]));
                            }
                            ErrorMessage = Convert.ToString(rows["ErrorMsg"]);
                        }
                    }
                }
                else
                {
                    var subDataSetparameters = new Dictionary<string, DataTable>();
                    //TypecodeDt.Rows[1]["AssetTypeCodeId"] = obj.AssetTypeCodeId_mappingTo_SeviceDB;
                    foreach (DataRow TypecodeDtrows in TypecodeDt.Rows)
                    {
                        if (TypecodeDtrows["AssetTypeCodeId"].ToString()!= Convert.ToString(obj.AssetTypeCodeId_mappingTo_SeviceDB))

                        {
                            TypecodeDtrows["AssetTypeCodeId"] = obj.AssetTypeCodeId_mappingTo_SeviceDB;
                        }

                    }
                    foreach (DataRow flagrows in flagdt.Rows)
                    {
                        if (flagrows["AssetTypeCodeId"].ToString() != Convert.ToString(obj.AssetTypeCodeId_mappingTo_SeviceDB))

                        {
                            flagrows["AssetTypeCodeId"] = obj.AssetTypeCodeId_mappingTo_SeviceDB;
                        }

                    }

                    subDataSetparameters.Add("@EngAssetTypeCode", TypecodeDt);
                    subDataSetparameters.Add("@EngAssetTypeCodeFlag", flagdt);
                    //DataSetparameters.Add("@EngAssetTypeCodeAddSpecification", popupDt);
                    subDataSetparameters.Add("@EngAssetTypeCodeVariationRate", varDt);


                    var subParameters = new Dictionary<string, string>();
                    subParameters.Add("@pAssetTypeCodeId", Convert.ToString(obj.AssetTypeCodeId_mappingTo_SeviceDB));
                    subParameters.Add("@pExpectedLifeSpan", Convert.ToString(model.ExpectedLifeSpan));
                    subParameters.Add("@pTimestamp", Convert.ToString(model.Timestamp));
                    subParameters.Add("@pCriticality", Convert.ToString(model.Criticality));
                    if (model.ServiceId == 1)
                    {
                        var dbAccessDALs = new MASTERFEMSDBAccessDAL();
                        otherDB = dbAccessDALs.GetMasterDataTable("uspFM_EngAssetTypeCode_Save", subParameters, subDataSetparameters);
                    }
                    else
                    {
                        
                        var dbAccessDALs = new MASTERBEMSDBAccessDAL();
                        otherDB = dbAccessDALs.GetMasterDataTable("uspFM_EngAssetTypeCode_Save", subParameters, subDataSetparameters);
                    }
                }
                    otherDB.Clear();
                    parameters.Clear();
                    DataSetparameters.Clear();
                if (subdb != null)
                {
                    parameters.Add("@EngAssetClass", subdb.ToString());
                        parameters.Add("@Master_AssetTypeCodeId", Convert.ToString(model.AssetTypeCodeId));
                        otherDB = dbAccessDAL.GetDataTable("Master_Updae_EngAssetTypeCode_AssetTypeCodeId_mappingTo_SeviceDB", parameters, DataSetparameters);
                }
           
                if (dt != null)
                {
                    foreach (DataRow rows in dt.Rows)
                    {
                        model.AssetTypeCodeId = Convert.ToInt32(rows["AssetTypeCodeId"]);
                        if (rows["Timestamp"] == DBNull.Value)
                        {
                            model.Timestamp = "";
                        }
                        else
                        {
                           // model.Timestamp = Convert.ToBase64String((byte[])(rows["Timestamp"]));
                        }
                        //ErrorMessage = Convert.ToString(rows["ErrorMsg"]);
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
                throw new DALException(ex);
            }
            
        }

        public List<EngAssetTypeCodeAddSpecification> GetAssetTypeCodeAddSpecifications(int id)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(GetAssetTypeCodeAddSpecifications), Level.Info.ToString());
            try
            {
                var dbAccessDAL = new DBAccessDAL();
                var EngAssetTypeCodeAddSpecificationsList = new List<EngAssetTypeCodeAddSpecification>();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pAssetTypeCodeId", Convert.ToString(id));
                DataTable dt = dbAccessDAL.GetDataTable("uspFM_EngAssetTypeCodeAddSpecification_GetByAssetTypeCodeId", parameters, DataSetparameters);

                if (dt != null && dt.Rows.Count > 0)
                {
                    var assetSpecificationList = (from n in dt.AsEnumerable()
                                                  select new EngAssetTypeCodeAddSpecification
                                                  {
                                                      AssetTypeCodeAddSpecId = Convert.ToInt32(n["AssetTypeCodeAddSpecId"]),
                                                      SpecificationType = Convert.ToInt32(n["SpecificationType"]),
                                                      SpecificationUnit = Convert.ToInt32(n["SpecificationUnit"]),
                                                      //AssetTypeCodeId_mappingTo_SeviceDB=Convert.ToInt32(n["AssetTypeCodeId_mappingTo_SeviceDB"]),
                                                  }).ToList();
                    if (assetSpecificationList != null && assetSpecificationList.Count > 0)
                        EngAssetTypeCodeAddSpecificationsList = assetSpecificationList;
                }
                Log4NetLogger.LogExit(_FileName, nameof(GetAssetTypeCodeAddSpecifications), Level.Info.ToString());
                return EngAssetTypeCodeAddSpecificationsList;
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
        public DataSet Get_subdb_EngAssetTypeCode_ID(int EngAssetTypeCode_ID)
        {
            DataSet ds = new DataSet();
            var dbAccessDAL = new MASTERDBAccessDAL();
            using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
            {
                using (SqlCommand cmd = new SqlCommand())
                {
                    cmd.Connection = con;
                    cmd.CommandType = CommandType.StoredProcedure;
                    cmd.CommandText = "uspFM_EngAssetTypeCode_Search_by_master_ID";
                    cmd.Parameters.AddWithValue("@pEngAssetTypeCode_ID", EngAssetTypeCode_ID);
                    var da = new SqlDataAdapter();
                    da.SelectCommand = cmd;
                    da.Fill(ds);
                }
            }

            return ds;
        }

        public Dictionary<string, DataTable> get_savemethods(EngAssetTypeCode model)
        {
            DataSet dds = Get_subdb_EngAssetTypeCode_ID(Convert.ToInt32(model.AssetClassificationId));
            Dictionary<string, Dictionary<string, DataTable>> Returnset = new Dictionary<string, Dictionary<string, DataTable>>();
            Dictionary<string, DataTable> DataSetparameters = new Dictionary<string, DataTable>();
            DataTable TypecodeDt = new DataTable();
           
            TypecodeDt.Columns.Add("AssetTypeCodeId", typeof(int));
            TypecodeDt.Columns.Add("ServiceId", typeof(int));
            TypecodeDt.Columns.Add("AssetClassificationId", typeof(int));
            TypecodeDt.Columns.Add("AssetTypeCode", typeof(string));
            TypecodeDt.Columns.Add("AssetTypeDescription", typeof(string));
            TypecodeDt.Columns.Add("EquipmentFunctionCatagoryLovId", typeof(int));
            TypecodeDt.Columns.Add("QAPAssetTypeB1", typeof(bool));
            TypecodeDt.Columns.Add("QAPServiceAvailabilityB2", typeof(bool));
            TypecodeDt.Columns.Add("QAPUptimeTargetPerc", typeof(decimal));
            TypecodeDt.Columns.Add("EffectiveFrom", typeof(DateTime));
            TypecodeDt.Columns.Add("EffectiveFromUTC", typeof(DateTime));
            TypecodeDt.Columns.Add("EffectiveTo", typeof(DateTime));
            TypecodeDt.Columns.Add("EffectiveToUTC", typeof(DateTime));
            TypecodeDt.Columns.Add("TRPILessThan5YrsPerc", typeof(decimal));
            TypecodeDt.Columns.Add("TRPI5to10YrsPerc", typeof(decimal));
            TypecodeDt.Columns.Add("TRPIGreaterThan10YrsPerc", typeof(decimal));
            TypecodeDt.Columns.Add("UserId", typeof(int));
            TypecodeDt.Columns.Add("TypeOfContractLovId", typeof(int));
            TypecodeDt.Columns.Add("LifeExpectancy", typeof(int));
            // TypecodeDt.Columns.Add("Criticality", typeof(string));
            DataRow row = TypecodeDt.NewRow();
            row["AssetTypeCodeId"] = model.AssetTypeCodeId;
            row["ServiceId"] = model.ServiceId;

            if (dds.Tables != null)
            {
                foreach (DataRow rows in dds.Tables[0].Rows)
                {
                    row["AssetClassificationId"] = Convert.ToInt32(rows["AssetClassification_mappingTo_SeviceDB"]);
                }
            }
            row["AssetTypeCode"] = model.AssetTypeCode;
            row["AssetTypeDescription"] = model.AssetTypeDescription;
            row["EquipmentFunctionCatagoryLovId"] = model.EquipmentFunctionCatagoryLovId;
            row["QAPAssetTypeB1"] = model.QAPAssetTypeB1;
            row["QAPServiceAvailabilityB2"] = model.QAPServiceAvailabilityB2;
            //row["Criticality"] = model.Criticality;


            if (model.QAPUptimeTargetPerc.HasValue)
            {
                row["QAPUptimeTargetPerc"] = model.QAPUptimeTargetPerc;
            }
            else
            {
                row["QAPUptimeTargetPerc"] = DBNull.Value;
            }


            if (model.EffectiveFrom != null)
            {
                row["EffectiveFrom"] = model.EffectiveFrom.Value.ToString("yyyy-MM-dd");
            }
            else
            {
                row["EffectiveFrom"] = DBNull.Value;
            }
            if (model.EffectiveFromUTC != null)
            {
                row["EffectiveFromUTC"] = model.EffectiveFromUTC.Value.ToString("yyyy-MM-dd");
            }
            else
            {
                row["EffectiveFromUTC"] = DBNull.Value;
            }
            if (model.EffectiveTo != null)
            {
                row["EffectiveTo"] = model.EffectiveTo.Value.ToString("yyyy-MM-dd");
            }
            else
            {
                row["EffectiveTo"] = DBNull.Value;
            }
            if (model.EffectiveToUTC != null)
            {
                row["EffectiveToUTC"] = model.EffectiveToUTC.Value.ToString("yyyy-MM-dd");
            }
            else
            {
                row["EffectiveToUTC"] = DBNull.Value;
            }
            //if (model.Criticality != null)
            //{
            //    row["Criticality"] = model.Criticality;
            //}

            //row["EffectiveFromUTC"] = model.EffectiveFrom != null ? model.EffectiveFrom.Value.ToString("yyyy-MM-dd") : DBNull.Value;
            //row["EffectiveTo"] = model.EffectiveTo != null ? model.EffectiveTo.Value.ToString("yyyy-MM-dd") : null;
            //row["EffectiveToUTC"] = model.EffectiveTo != null ? model.EffectiveTo.Value.ToString("yyyy-MM-dd") : null;
            row["TRPILessThan5YrsPerc"] = model.TRPILessThan5YrsPerc;
            row["TRPI5to10YrsPerc"] = model.TRPI5to10YrsPerc;
            row["TRPIGreaterThan10YrsPerc"] = model.TRPIGreaterThan10YrsPerc;
            row["UserId"] = _UserSession.UserId;
            row["TypeOfContractLovId"] = 1;

            if (model.LifeExpectancyId != null)
            {
                row["LifeExpectancy"] = model.LifeExpectancyId;
            }
            else
            {
                row["LifeExpectancy"] = DBNull.Value;
            }

            TypecodeDt.Rows.Add(row);

            DataTable flagdt = new DataTable();
            flagdt.Columns.Add("AssetTypeCodeFlagId", typeof(int));
            flagdt.Columns.Add("AssetTypeCodeId", typeof(int));
            flagdt.Columns.Add("MaintenanceFlag", typeof(int));
            flagdt.Columns.Add("UserId", typeof(int));
            // List<int> MaintaininceFlagList = model.MaintenanceFlag.Split(',').Select(int.Parse).ToList();
            foreach (var flagid in model.MaintainanceFlagList)
            {
                flagdt.Rows.Add(0, model.AssetTypeCodeId, flagid, _UserSession.UserId);
            }

            DataTable varDt = new DataTable();
            varDt.Columns.Add("AssetTypeCodeVariationId", typeof(int));
            varDt.Columns.Add("AssetTypeCodeId", typeof(int));
            varDt.Columns.Add("TypeCodeParameterId", typeof(int));
            varDt.Columns.Add("VariationRate", typeof(decimal));

            varDt.Columns.Add("EffectiveFromDate", typeof(DateTime));
            varDt.Columns.Add("EffectiveFromDateUTC", typeof(DateTime));
            varDt.Columns.Add("UserId", typeof(int));
            if (model.EngAssetTypeCodeVariationRates != null)
            {
                foreach (var var in model.EngAssetTypeCodeVariationRates)
                {
                    string EffectiveFrom = null;
                    if (var.EffectiveFromDate != null)
                    {
                        EffectiveFrom = var.EffectiveFromDate.Value.ToString("yyyy-MM-dd");
                    }
                    varDt.Rows.Add(var.AssetTypeCodeVariationId, model.AssetTypeCodeId, var.TypeCodeParameterId, var.VariationRate, EffectiveFrom, EffectiveFrom, _UserSession.UserId);
                }
            }
            DataSetparameters.Add("@EngAssetTypeCode", TypecodeDt);
            DataSetparameters.Add("@EngAssetTypeCodeFlag", flagdt);
            //DataSetparameters.Add("@EngAssetTypeCodeAddSpecification", popupDt);
            DataSetparameters.Add("@EngAssetTypeCodeVariationRate", varDt);

            //Returnset.Add("@DataSetparameters", DataSetparameters);
            return DataSetparameters;
        }
    }
}
