using CP.Framework.Common.ExceptionHandler.ExceptionWrappers;
using CP.Framework.Common.Logging;
using CP.UETrack.DAL.DataAccess.Contracts.BER;
using CP.UETrack.DAL.DataAccess.Implementation;
using CP.UETrack.Model;
using CP.UETrack.Model.BEMS;
using CP.UETrack.Model.BER;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using UETrack.DAL;

namespace CP.UETrack.DAL.DataAccess.Implementations.BER
{
    public class BER1ApplicationDAL : IBER1ApplicationDAL
    {
        private readonly string _FileName = nameof(BER1ApplicationDAL);
        readonly UserDetailsModel _UserSession = new SessionHelper().UserSession();



        public BERApplicationTxn Get(string Id)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
            try
            {
                var split = Id.Split('☺').ToArray();

                return Get(Convert.ToInt16(split[0]), Convert.ToInt16(split[1]));

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





        public BERApplicationTxn Get(int Service, int Id)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
            try
            {
                var dbAccessDAL = new DBAccessDAL();
                var obj = new BERApplicationTxn();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pApplicationId", Id.ToString());
                parameters.Add("@pPageIndex", Convert.ToString(1));
                parameters.Add("@pPageSize", Convert.ToString(5));

                DataSet ds = new DataSet();


                ds = dbAccessDAL.GetDataSetUsingServiceId("UspFM_BERApplicationTxn_GetById", parameters, DataSetparameters, Service);





                if (ds != null)
                {
                    if (ds.Tables[0] != null && ds.Tables[0].Rows.Count > 0)
                    {
                        obj.ApplicationId = Convert.ToInt16(ds.Tables[0].Rows[0]["ApplicationId"]);
                        obj.CustomerId = Convert.ToInt16(ds.Tables[0].Rows[0]["CustomerId"]);
                        obj.FacilityId = Convert.ToInt16(ds.Tables[0].Rows[0]["FacilityId"]);
                        obj.ServiceId = Convert.ToInt16(ds.Tables[0].Rows[0]["ServiceId"]);
                        obj.BERno = Convert.ToString(ds.Tables[0].Rows[0]["BERno"]);
                        obj.AssetNo = Convert.ToString(ds.Tables[0].Rows[0]["AssetNo"]);
                        obj.AssetId = Convert.ToInt16(ds.Tables[0].Rows[0]["AssetId"]);
                        obj.AssetDescription = Convert.ToString(ds.Tables[0].Rows[0]["AssetDescription"]);
                        //  obj.FreqDamSincPurchased = ds.Tables[0].Rows[0]["FreqDamSincPurchased"] != DBNull.Value ? (Convert.ToDecimal(ds.Tables[0].Rows[0]["FreqDamSincPurchased"])) : (Decimal?)null;
                        //  obj.TotalCostImprovement = ds.Tables[0].Rows[0]["TotalCostImprovement"] != DBNull.Value ? Convert.ToDecimal(ds.Tables[0].Rows[0]["TotalCostImprovement"]) : (Decimal?)null;

                        obj.RepairEstimate = ds.Tables[0].Rows[0]["RepairEstimate"] != DBNull.Value ? Convert.ToDecimal(ds.Tables[0].Rows[0]["RepairEstimate"]) : (Decimal?)null;
                        obj.ValueAfterRepair = ds.Tables[0].Rows[0]["ValueAfterRepair"] != DBNull.Value ? (Convert.ToDecimal(ds.Tables[0].Rows[0]["ValueAfterRepair"])) : (Decimal?)null;
                        obj.EstDurUsgAfterRepair = ds.Tables[0].Rows[0]["EstDurUsgAfterRepair"] != DBNull.Value ? (Convert.ToDecimal(ds.Tables[0].Rows[0]["EstDurUsgAfterRepair"])) : (Decimal?)null;


                        // obj.EstRepcostToExpensive = ds.Tables[0].Rows[0]["EstRepcostToExpensive"] != DBNull.Value ? Convert.ToDecimal(ds.Tables[0].Rows[0]["EstRepcostToExpensive"]) : (Decimal?)null;
                        obj.EstRepcostToExpensive = Convert.ToBoolean(ds.Tables[0].Rows[0]["EstRepcostToExpensive"]);
                        obj.NotReliable = Convert.ToBoolean(ds.Tables[0].Rows[0]["NotReliable"]);
                        obj.StatutoryRequirements = Convert.ToBoolean(ds.Tables[0].Rows[0]["StatutoryRequirements"]);
                        obj.Obsolescence = Convert.ToBoolean(ds.Tables[0].Rows[0]["Obsolescence"]);
                        obj.CannotRepair = Convert.ToBoolean(ds.Tables[0].Rows[0]["CannotRepair"]);
                        obj.BIL = Convert.ToString(ds.Tables[0].Rows[0]["BIL"]);
                        // obj.StatutoryRequirements = Convert.ToInt16(ds.Tables[0].Rows[0]["StatutoryRequirements"]);
                        obj.OtherObservations = Convert.ToString(ds.Tables[0].Rows[0]["OtherObservations"]);
                        obj.ApplicantStaffId = Convert.ToInt32(ds.Tables[0].Rows[0]["ApplicantStaffId"]);
                        obj.ApplicantStaffName = Convert.ToString(ds.Tables[0].Rows[0]["StaffName"]);
                        obj.ApplicantDesignation = Convert.ToString(ds.Tables[0].Rows[0]["Designation"]);
                        obj.BERStatus = Convert.ToInt32(ds.Tables[0].Rows[0]["BERStatus"]);
                        obj.BERStatusValue = Convert.ToString(ds.Tables[0].Rows[0]["BERStatusValue"]);
                        obj.BER2TechnicalCondition = Convert.ToString(ds.Tables[0].Rows[0]["BER2TechnicalCondition"]);
                        // obj.BER2TechnicalCondition = ds.Tables[0].Rows[0]["BER2TechnicalCondition"] != DBNull.Value ? Convert.ToInt32(ds.Tables[0].Rows[0]["BER2TechnicalCondition"]) : (int?)null;
                        obj.BER2RepairedWell = Convert.ToString(ds.Tables[0].Rows[0]["BER2RepairedWell"]);
                        obj.BER2SafeReliable = Convert.ToString(ds.Tables[0].Rows[0]["BER2SafeReliable"]);
                        //obj.BER2SafeReliable = ds.Tables[0].Rows[0]["BER2SafeReliable"] != DBNull.Value ? Convert.ToInt32(ds.Tables[0].Rows[0]["BER2SafeReliable"]) : (int?)null;
                        obj.BER2EstimateLifeTime = Convert.ToString(ds.Tables[0].Rows[0]["BER2EstimateLifeTime"]);
                        // obj.BER2EstimateLifeTime = ds.Tables[0].Rows[0]["BER2EstimateLifeTime"] != DBNull.Value ? Convert.ToInt32(ds.Tables[0].Rows[0]["BER2EstimateLifeTime"]) : (int?)null;
                        //obj.BER2Syor = ds.Tables[0].Rows[0]["BER2Syor"] != DBNull.Value ? Convert.ToInt32(ds.Tables[0].Rows[0]["BER2Syor"]) : (int?)null;
                        obj.BER2Syor = Convert.ToString(ds.Tables[0].Rows[0]["BER2Syor"]);
                        obj.BER2Remarks = Convert.ToString(ds.Tables[0].Rows[0]["BER2Remarks"]);
                        obj.BER1Remarks = Convert.ToString(ds.Tables[0].Rows[0]["BER1Remarks"]);
                        obj.ParentApplicationId = ds.Tables[0].Rows[0]["ParentApplicationId"] != DBNull.Value ? (Convert.ToInt32(ds.Tables[0].Rows[0]["ParentApplicationId"])) : (int?)null;
                        obj.ApprovedDate = ds.Tables[0].Rows[0]["ApprovedDate"] != DBNull.Value ? (Convert.ToDateTime(ds.Tables[0].Rows[0]["ApprovedDate"])) : (DateTime?)null;
                        obj.ApprovedDateUTC = ds.Tables[0].Rows[0]["ApprovedDateUTC"] != DBNull.Value ? (Convert.ToDateTime(ds.Tables[0].Rows[0]["ApprovedDateUTC"])) : (DateTime?)null;
                        obj.ApplicationDate = Convert.ToDateTime(ds.Tables[0].Rows[0]["ApplicationDate"]);
                        obj.RejectedBERReferenceId = ds.Tables[0].Rows[0]["RejectedBERReferenceId"] != DBNull.Value ? (Convert.ToInt32(ds.Tables[0].Rows[0]["RejectedBERReferenceId"])) : (int?)null;
                        obj.BER2TechnicalConditionOthers = Convert.ToString(ds.Tables[0].Rows[0]["BER2TechnicalConditionOthers"]);
                        obj.BER2SafeReliableOthers = Convert.ToString(ds.Tables[0].Rows[0]["BER2SafeReliableOthers"]);
                        obj.BERStage = Convert.ToInt32(ds.Tables[0].Rows[0]["BERStage"]);
                        obj.CircumstanceOthers = Convert.ToString(ds.Tables[0].Rows[0]["CircumstanceOthers"]);
                        obj.ExaminationFirstResultOthers = Convert.ToString(ds.Tables[0].Rows[0]["ExaminationFirstResultOthers"]);
                        obj.EstimatedRepairCost = ds.Tables[0].Rows[0]["EstimatedRepairCost"] != DBNull.Value ? (Convert.ToDecimal(ds.Tables[0].Rows[0]["EstimatedRepairCost"])) : (Decimal?)null;
                        obj.Timestamp = Convert.ToBase64String((byte[])(ds.Tables[0].Rows[0]["Timestamp"]));
                        obj.UserLocationCode = Convert.ToString(ds.Tables[0].Rows[0]["UserLocationCode"]);
                        obj.UserLocationName = Convert.ToString(ds.Tables[0].Rows[0]["UserLocationName"]);
                        obj.Manufacturer = Convert.ToString(ds.Tables[0].Rows[0]["Manufacturer"]);
                        obj.Model = Convert.ToString(ds.Tables[0].Rows[0]["Model"]);
                        obj.SupplierName = Convert.ToString(ds.Tables[0].Rows[0]["MainSupplier"]);
                        obj.PurchaseCost = ds.Tables[0].Rows[0]["PurchaseCostRM"] != DBNull.Value ? (Convert.ToDecimal(ds.Tables[0].Rows[0]["PurchaseCostRM"])) : (Decimal?)null;
                        obj.PurchaseDate = ds.Tables[0].Rows[0]["PurchaseDate"] != DBNull.Value ? (Convert.ToDateTime(ds.Tables[0].Rows[0]["PurchaseDate"])) : (DateTime?)null;
                        obj.RequestorId = ds.Tables[0].Rows[0]["RequestorId"] != DBNull.Value ? Convert.ToInt32(ds.Tables[0].Rows[0]["RequestorId"]) : (int?)null;
                        obj.RequestorName = Convert.ToString(ds.Tables[0].Rows[0]["RequestorName"]);
                        obj.RequestorDesignation = Convert.ToString(ds.Tables[0].Rows[0]["RequestorDesignation"]);
                        obj.CurrentValue = ds.Tables[0].Rows[0]["CurrentValue"] != DBNull.Value ? (Convert.ToDecimal(ds.Tables[0].Rows[0]["CurrentValue"])) : (Decimal?)null;
                        obj.AssetAge = ds.Tables[0].Rows[0]["AssetAge"] != DBNull.Value ? (Convert.ToDecimal(ds.Tables[0].Rows[0]["AssetAge"])) : (Decimal?)null;
                        obj.StillwithInLifeSpan = ds.Tables[0].Rows[0]["StillwithInLifeSpan"] != DBNull.Value ? (Convert.ToInt32(ds.Tables[0].Rows[0]["StillwithInLifeSpan"])) : (int?)null;
                        obj.HiddenId = Convert.ToString(ds.Tables[0].Rows[0]["GuId"]);
                        obj.CurrentRepairCost = ds.Tables[0].Rows[0]["CurrentRepairCost"] != DBNull.Value ? (Convert.ToDecimal(ds.Tables[0].Rows[0]["CurrentRepairCost"])) : (Decimal?)null;
                        obj.PastMaintenanceCost = ds.Tables[0].Rows[0]["TotalCost"] != DBNull.Value ? (Convert.ToDecimal(ds.Tables[0].Rows[0]["TotalCost"])) : (Decimal?)null;
                        obj.ValueAfterRepair = (obj.PastMaintenanceCost.HasValue ? obj.PastMaintenanceCost : 0) + (obj.EstimatedRepairCost.HasValue ? obj.EstimatedRepairCost : 0);

                        if (!string.IsNullOrEmpty(obj.BER2Syor))
                        {
                            obj.BER2SyorList = obj.BER2Syor.Split(',').Select(int.Parse).ToList();
                        }

                    }
                    if (ds.Tables[1] != null && ds.Tables[1].Rows.Count > 0)
                    {

                        var RemarksHistory = (from n in ds.Tables[1].AsEnumerable()
                                              select new BERApplicationRemarksHistoryTxn
                                              {
                                                  Remarks = Convert.ToString(n["Remarks"]),
                                                  UpdatedDate = n.Field<DateTime?>("UpdatedDate"),
                                                  EnteredBy = Convert.ToString(n["EnteredBy"]),
                                              }).ToList();

                        if (RemarksHistory != null && RemarksHistory.Count > 0)
                        {
                            obj.BERApplicationRemarksHistoryTxns = RemarksHistory;
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




        public BERApplicationTxn Get(int Id)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
            try
            {
                var dbAccessDAL = new DBAccessDAL();
                var obj = new BERApplicationTxn();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pApplicationId", Id.ToString());
                parameters.Add("@pPageIndex", Convert.ToString(1));
                parameters.Add("@pPageSize", Convert.ToString(5));



                var _service = 0;
                switch (_UserSession.ModuleId)
                {
                    case 3:
                        {
                            _service = 2;
                            break;
                        }

                    case 6:
                        {
                            _service = 2;
                            break;
                        }

                    case 13:
                        {
                            _service = 1;
                            break;
                        }
                    case 19:
                        {
                            _service = 6;
                            break;
                        }
                }

                DataSet ds = dbAccessDAL.GetDataSetUsingServiceId("UspFM_BERApplicationTxn_GetById", parameters, DataSetparameters, _service);

                if (ds != null)
                {
                    if (ds.Tables[0] != null && ds.Tables[0].Rows.Count > 0)
                    {
                        obj.ApplicationId = Convert.ToInt16(ds.Tables[0].Rows[0]["ApplicationId"]);
                        obj.CustomerId = Convert.ToInt16(ds.Tables[0].Rows[0]["CustomerId"]);
                        obj.FacilityId = Convert.ToInt16(ds.Tables[0].Rows[0]["FacilityId"]);
                        obj.ServiceId = Convert.ToInt16(ds.Tables[0].Rows[0]["ServiceId"]);
                        obj.BERno = Convert.ToString(ds.Tables[0].Rows[0]["BERno"]);
                        obj.AssetNo = Convert.ToString(ds.Tables[0].Rows[0]["AssetNo"]);
                        obj.AssetId = Convert.ToInt16(ds.Tables[0].Rows[0]["AssetId"]);
                        obj.AssetDescription = Convert.ToString(ds.Tables[0].Rows[0]["AssetDescription"]);
                        //  obj.FreqDamSincPurchased = ds.Tables[0].Rows[0]["FreqDamSincPurchased"] != DBNull.Value ? (Convert.ToDecimal(ds.Tables[0].Rows[0]["FreqDamSincPurchased"])) : (Decimal?)null;
                        //  obj.TotalCostImprovement = ds.Tables[0].Rows[0]["TotalCostImprovement"] != DBNull.Value ? Convert.ToDecimal(ds.Tables[0].Rows[0]["TotalCostImprovement"]) : (Decimal?)null;

                        obj.RepairEstimate = ds.Tables[0].Rows[0]["RepairEstimate"] != DBNull.Value ? Convert.ToDecimal(ds.Tables[0].Rows[0]["RepairEstimate"]) : (Decimal?)null;
                        obj.ValueAfterRepair = ds.Tables[0].Rows[0]["ValueAfterRepair"] != DBNull.Value ? (Convert.ToDecimal(ds.Tables[0].Rows[0]["ValueAfterRepair"])) : (Decimal?)null;
                        obj.EstDurUsgAfterRepair = ds.Tables[0].Rows[0]["EstDurUsgAfterRepair"] != DBNull.Value ? (Convert.ToDecimal(ds.Tables[0].Rows[0]["EstDurUsgAfterRepair"])) : (Decimal?)null;


                        // obj.EstRepcostToExpensive = ds.Tables[0].Rows[0]["EstRepcostToExpensive"] != DBNull.Value ? Convert.ToDecimal(ds.Tables[0].Rows[0]["EstRepcostToExpensive"]) : (Decimal?)null;
                        obj.EstRepcostToExpensive = Convert.ToBoolean(ds.Tables[0].Rows[0]["EstRepcostToExpensive"]);
                        obj.NotReliable = Convert.ToBoolean(ds.Tables[0].Rows[0]["NotReliable"]);
                        obj.StatutoryRequirements = Convert.ToBoolean(ds.Tables[0].Rows[0]["StatutoryRequirements"]);
                        obj.Obsolescence = Convert.ToBoolean(ds.Tables[0].Rows[0]["Obsolescence"]);
                        obj.CannotRepair = Convert.ToBoolean(ds.Tables[0].Rows[0]["CannotRepair"]);
                        obj.BIL = Convert.ToString(ds.Tables[0].Rows[0]["BIL"]);
                        // obj.StatutoryRequirements = Convert.ToInt16(ds.Tables[0].Rows[0]["StatutoryRequirements"]);
                        obj.OtherObservations = Convert.ToString(ds.Tables[0].Rows[0]["OtherObservations"]);
                        obj.ApplicantStaffId = Convert.ToInt32(ds.Tables[0].Rows[0]["ApplicantStaffId"]);
                        obj.ApplicantStaffName = Convert.ToString(ds.Tables[0].Rows[0]["StaffName"]);
                        obj.ApplicantDesignation = Convert.ToString(ds.Tables[0].Rows[0]["Designation"]);
                        obj.BERStatus = Convert.ToInt32(ds.Tables[0].Rows[0]["BERStatus"]);
                        obj.BERStatusValue = Convert.ToString(ds.Tables[0].Rows[0]["BERStatusValue"]);
                        obj.BER2TechnicalCondition = Convert.ToString(ds.Tables[0].Rows[0]["BER2TechnicalCondition"]);
                        // obj.BER2TechnicalCondition = ds.Tables[0].Rows[0]["BER2TechnicalCondition"] != DBNull.Value ? Convert.ToInt32(ds.Tables[0].Rows[0]["BER2TechnicalCondition"]) : (int?)null;
                        obj.BER2RepairedWell = Convert.ToString(ds.Tables[0].Rows[0]["BER2RepairedWell"]);
                        obj.BER2SafeReliable = Convert.ToString(ds.Tables[0].Rows[0]["BER2SafeReliable"]);
                        //obj.BER2SafeReliable = ds.Tables[0].Rows[0]["BER2SafeReliable"] != DBNull.Value ? Convert.ToInt32(ds.Tables[0].Rows[0]["BER2SafeReliable"]) : (int?)null;
                        obj.BER2EstimateLifeTime = Convert.ToString(ds.Tables[0].Rows[0]["BER2EstimateLifeTime"]);
                        // obj.BER2EstimateLifeTime = ds.Tables[0].Rows[0]["BER2EstimateLifeTime"] != DBNull.Value ? Convert.ToInt32(ds.Tables[0].Rows[0]["BER2EstimateLifeTime"]) : (int?)null;
                        //obj.BER2Syor = ds.Tables[0].Rows[0]["BER2Syor"] != DBNull.Value ? Convert.ToInt32(ds.Tables[0].Rows[0]["BER2Syor"]) : (int?)null;
                        obj.BER2Syor = Convert.ToString(ds.Tables[0].Rows[0]["BER2Syor"]);
                        obj.BER2Remarks = Convert.ToString(ds.Tables[0].Rows[0]["BER2Remarks"]);
                        obj.BER1Remarks = Convert.ToString(ds.Tables[0].Rows[0]["BER1Remarks"]);
                        obj.ParentApplicationId = ds.Tables[0].Rows[0]["ParentApplicationId"] != DBNull.Value ? (Convert.ToInt32(ds.Tables[0].Rows[0]["ParentApplicationId"])) : (int?)null;
                        obj.ApprovedDate = ds.Tables[0].Rows[0]["ApprovedDate"] != DBNull.Value ? (Convert.ToDateTime(ds.Tables[0].Rows[0]["ApprovedDate"])) : (DateTime?)null;
                        obj.ApprovedDateUTC = ds.Tables[0].Rows[0]["ApprovedDateUTC"] != DBNull.Value ? (Convert.ToDateTime(ds.Tables[0].Rows[0]["ApprovedDateUTC"])) : (DateTime?)null;
                        obj.ApplicationDate = Convert.ToDateTime(ds.Tables[0].Rows[0]["ApplicationDate"]);
                        obj.RejectedBERReferenceId = ds.Tables[0].Rows[0]["RejectedBERReferenceId"] != DBNull.Value ? (Convert.ToInt32(ds.Tables[0].Rows[0]["RejectedBERReferenceId"])) : (int?)null;
                        obj.BER2TechnicalConditionOthers = Convert.ToString(ds.Tables[0].Rows[0]["BER2TechnicalConditionOthers"]);
                        obj.BER2SafeReliableOthers = Convert.ToString(ds.Tables[0].Rows[0]["BER2SafeReliableOthers"]);
                        obj.BERStage = Convert.ToInt32(ds.Tables[0].Rows[0]["BERStage"]);
                        obj.CircumstanceOthers = Convert.ToString(ds.Tables[0].Rows[0]["CircumstanceOthers"]);
                        obj.ExaminationFirstResultOthers = Convert.ToString(ds.Tables[0].Rows[0]["ExaminationFirstResultOthers"]);
                        obj.EstimatedRepairCost = ds.Tables[0].Rows[0]["EstimatedRepairCost"] != DBNull.Value ? (Convert.ToDecimal(ds.Tables[0].Rows[0]["EstimatedRepairCost"])) : (Decimal?)null;
                        obj.Timestamp = Convert.ToBase64String((byte[])(ds.Tables[0].Rows[0]["Timestamp"]));
                        obj.UserLocationCode = Convert.ToString(ds.Tables[0].Rows[0]["UserLocationCode"]);
                        obj.UserLocationName = Convert.ToString(ds.Tables[0].Rows[0]["UserLocationName"]);
                        obj.Manufacturer = Convert.ToString(ds.Tables[0].Rows[0]["Manufacturer"]);
                        obj.Model = Convert.ToString(ds.Tables[0].Rows[0]["Model"]);
                        obj.SupplierName = Convert.ToString(ds.Tables[0].Rows[0]["MainSupplier"]);
                        obj.PurchaseCost = ds.Tables[0].Rows[0]["PurchaseCostRM"] != DBNull.Value ? (Convert.ToDecimal(ds.Tables[0].Rows[0]["PurchaseCostRM"])) : (Decimal?)null;
                        obj.PurchaseDate = ds.Tables[0].Rows[0]["PurchaseDate"] != DBNull.Value ? (Convert.ToDateTime(ds.Tables[0].Rows[0]["PurchaseDate"])) : (DateTime?)null;
                        obj.RequestorId = ds.Tables[0].Rows[0]["RequestorId"] != DBNull.Value ? Convert.ToInt32(ds.Tables[0].Rows[0]["RequestorId"]) : (int?)null;
                        obj.RequestorName = Convert.ToString(ds.Tables[0].Rows[0]["RequestorName"]);
                        obj.RequestorDesignation = Convert.ToString(ds.Tables[0].Rows[0]["RequestorDesignation"]);
                        obj.CurrentValue = ds.Tables[0].Rows[0]["CurrentValue"] != DBNull.Value ? (Convert.ToDecimal(ds.Tables[0].Rows[0]["CurrentValue"])) : (Decimal?)null;
                        obj.AssetAge = ds.Tables[0].Rows[0]["AssetAge"] != DBNull.Value ? (Convert.ToDecimal(ds.Tables[0].Rows[0]["AssetAge"])) : (Decimal?)null;
                        obj.StillwithInLifeSpan = ds.Tables[0].Rows[0]["StillwithInLifeSpan"] != DBNull.Value ? (Convert.ToInt32(ds.Tables[0].Rows[0]["StillwithInLifeSpan"])) : (int?)null;
                        obj.HiddenId = Convert.ToString(ds.Tables[0].Rows[0]["GuId"]);
                        obj.CurrentRepairCost = ds.Tables[0].Rows[0]["CurrentRepairCost"] != DBNull.Value ? (Convert.ToDecimal(ds.Tables[0].Rows[0]["CurrentRepairCost"])) : (Decimal?)null;
                        obj.PastMaintenanceCost = ds.Tables[0].Rows[0]["TotalCost"] != DBNull.Value ? (Convert.ToDecimal(ds.Tables[0].Rows[0]["TotalCost"])) : (Decimal?)null;
                        obj.ValueAfterRepair = (obj.PastMaintenanceCost.HasValue ? obj.PastMaintenanceCost : 0) + (obj.EstimatedRepairCost.HasValue ? obj.EstimatedRepairCost : 0);

                        if (!string.IsNullOrEmpty(obj.BER2Syor))
                        {
                            obj.BER2SyorList = obj.BER2Syor.Split(',').Select(int.Parse).ToList();
                        }

                    }
                    if (ds.Tables[1] != null && ds.Tables[1].Rows.Count > 0)
                    {

                        var RemarksHistory = (from n in ds.Tables[1].AsEnumerable()
                                              select new BERApplicationRemarksHistoryTxn
                                              {
                                                  Remarks = Convert.ToString(n["Remarks"]),
                                                  UpdatedDate = n.Field<DateTime?>("UpdatedDate"),
                                                  EnteredBy = Convert.ToString(n["EnteredBy"]),
                                              }).ToList();

                        if (RemarksHistory != null && RemarksHistory.Count > 0)
                        {
                            obj.BERApplicationRemarksHistoryTxns = RemarksHistory;
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





        public BERApplicationTxn ArpGet(int Id)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(ArpGet), Level.Info.ToString());
            try
            {
                var dbAccessDAL = new MASTERBEMSDBAccessDAL();
                var dbAccessDALs = new CommonDAL();
                var obj = new BERApplicationTxn();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();

                parameters.Add("@pBERno", Id.ToString());

                DataSet ds = dbAccessDAL.GetDataSet("UspFM_ARP_info_GetByBERno", parameters, DataSetparameters);
                //DataSet ds = dbAccessDAL.GetDataSet("UspFM_ARPApplication_GetById", parameters, DataSetparameters);
                if (ds != null)
                {
                    if (ds.Tables[0] != null && ds.Tables[0].Rows.Count > 0)
                    {
                        obj.BERno = Convert.ToString(ds.Tables[0].Rows[0]["BERNo"]);
                        obj.AssetNo = Convert.ToString(ds.Tables[0].Rows[0]["AssetNo"]);
                        obj.AssetId = Convert.ToInt32(ds.Tables[0].Rows[0]["AssetId"]);
                        obj.ConditionAppraisalRefNo = Convert.ToString(ds.Tables[0].Rows[0]["ConditionAppraisalNo"]);
                        obj.AssetDescription = Convert.ToString(ds.Tables[0].Rows[0]["AssetDescription"]);
                        obj.BERRemarks = Convert.ToString(ds.Tables[0].Rows[0]["BER1Remarks"]);
                        obj.ApplicationDate = Convert.ToDateTime(ds.Tables[0].Rows[0]["ApplicationDate"]);
                        obj.AssetName = Convert.ToString(ds.Tables[0].Rows[0]["Asset_Name"]);
                        obj.UserLocationCode = Convert.ToString(ds.Tables[0].Rows[0]["UserLocationCode"]);
                        obj.UserLocationName = Convert.ToString(ds.Tables[0].Rows[0]["UserLocationName"]);
                        obj.UserAreaName = Convert.ToString(ds.Tables[0].Rows[0]["UserAreaName"]);
                        obj.PurchaseCost = ds.Tables[0].Rows[0]["PurchaseCostRM"] != DBNull.Value ? (Convert.ToDecimal(ds.Tables[0].Rows[0]["PurchaseCostRM"])) : (Decimal?)null;
                        obj.PurchaseDate = ds.Tables[0].Rows[0]["PurchaseDate"] != DBNull.Value ? (Convert.ToDateTime(ds.Tables[0].Rows[0]["PurchaseDate"])) : (DateTime?)null;
                        obj.ItemNo = Convert.ToString(ds.Tables[0].Rows[0]["Item_Code"]);
                        obj.AssetTypeDescription = Convert.ToString(ds.Tables[0].Rows[0]["AssetTypeDescription"]);
                        obj.PackageCode = Convert.ToString(ds.Tables[0].Rows[0]["Package_Code"]);
                        obj.BatchNo = Convert.ToInt32(ds.Tables[0].Rows[0]["BatchNo"]);

                    }
                    if (ds.Tables[1] != null && ds.Tables[1].Rows.Count > 0)
                    {

                        var RemarksHistory = (from n in ds.Tables[1].AsEnumerable()
                                              select new BERApplicationRemarksHistoryTxn
                                              {
                                                  Remarks = Convert.ToString(n["Remarks"]),
                                                  UpdatedDate = n.Field<DateTime?>("UpdatedDate"),
                                                  EnteredBy = Convert.ToString(n["EnteredBy"]),
                                              }).ToList();

                        //if (RemarksHistory != null && RemarksHistory.Count > 0)
                        //{
                        //    obj.BERApplicationRemarksHistoryTxns = RemarksHistory;
                        //}
                    }

                }

                Log4NetLogger.LogExit(_FileName, nameof(ArpGet), Level.Info.ToString());
                return obj;

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
        public BERApplicationTxnLovs Load()
        {
            try
            {

                Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
                BERApplicationTxnLovs Lovs = new BERApplicationTxnLovs();
                NavigationDAL GetPermission = new NavigationDAL();
                List<UserActionPermissions> permission = new List<UserActionPermissions>();
                permission = GetPermission.ActionPermissionData();

                string lovs = "StatutoryRequirementsValue,NotReliableValue,BER2TechnicalConditionValue,BER2SafeReliableValue,BER2EstimateLifeTimeValue,ApplicationStatusValue";
                var dbAccessDAL = new DBAccessDAL();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pLovKey", lovs);
                DataSet ds = dbAccessDAL.GetDataSet("uspFM_Dropdown", parameters, DataSetparameters);

                parameters.Clear();
                DataSetparameters.Clear();

                if (ds.Tables.Count != 0 && ds.Tables[0].Rows.Count > 0)
                {
                    Lovs.BER2TechnicalConditionLovs = dbAccessDAL.GetLovRecords(ds.Tables[0], "BER2TechnicalConditionValue");
                    Lovs.NotReliableLovs = dbAccessDAL.GetLovRecords(ds.Tables[0], "NotReliableValue");
                    Lovs.StatuaryRequirementLovs = dbAccessDAL.GetLovRecords(ds.Tables[0], "StatutoryRequirementsValue");
                    Lovs.BER1StatusLovs = dbAccessDAL.GetLovRecords(ds.Tables[0], "ApplicationStatusValue");
                    Lovs.BER2SafeReliableLovs = dbAccessDAL.GetLovRecords(ds.Tables[0], "BER2SafeReliableValue");
                    Lovs.BER2EstimateLifeTimeLovs = dbAccessDAL.GetLovRecords(ds.Tables[0], "BER2EstimateLifeTimeValue");
                    Lovs.ActionPermissions = permission;
                    Lovs.Services = _UserSession.ModuleId == 3 ? "BEMS" : (_UserSession.ModuleId == 13 ? "FEMS" : "ICT");
                }
                var DataSetparameters1 = new Dictionary<string, DataTable>();
                var parameters1 = new Dictionary<string, string>();

                var facilityid = _UserSession.FacilityId;
                var userid = _UserSession.UserId;
                var lovkey = facilityid.ToString() + "," + userid.ToString();

                parameters1.Add("@pLovKey", lovkey);
                parameters1.Add("@pTableName", "BERApplicationTxn");
                DataSet ds1 = dbAccessDAL.GetDataSet("uspFM_Dropdown_Others", parameters1, DataSetparameters1);
                if (ds1.Tables[0] != null && ds1.Tables[0].Rows.Count > 0)
                {
                    Lovs.FacilityCode = Convert.ToString(ds1.Tables[0].Rows[0]["FacilityCode"]);
                    Lovs.FacilityName = Convert.ToString(ds1.Tables[0].Rows[0]["FacilityName"]);
                    Lovs.FacilityId = _UserSession.FacilityId;
                }
                if (ds1.Tables[1] != null && ds1.Tables[1].Rows.Count > 0)
                {
                    Lovs.ApplicantStaffId = Convert.ToInt32(ds1.Tables[1].Rows[0]["StaffMasterId"]);
                    Lovs.ApplicantStaffName = Convert.ToString(ds1.Tables[1].Rows[0]["StaffName"]);
                    Lovs.ApplicantDesignation = Convert.ToString(ds1.Tables[1].Rows[0]["Designation"]);
                }

                Lovs.FacilityId = _UserSession.FacilityId;
                var date = DateTime.Now;
                Lovs.CurrentDate = date.Date;








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

        public void Delete(int Id, out string ErrorMessage)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Delete), Level.Info.ToString());
            try
            {
                ErrorMessage = string.Empty;
                var dbAccessDAL = new DBAccessDAL();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pApplicationId", Id.ToString());
                DataTable dt = dbAccessDAL.GetDataTable("uspFM_BERApplicationTxn_Delete", parameters, DataSetparameters);
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


        public BERApplicationTxn Save(BERApplicationTxn model, out string ErrorMessage)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());
            try
            {
                var count = model.ApplicationId == 0 ? 1 : 2;
                // var reqId = model.RequestorId;

                if (model.BERStatus == 206)
                {
                    model.ApprovedDate = DateTime.Now;
                }
                else
                {
                    model.ApprovedDate = null;
                }
                ErrorMessage = string.Empty;
                var berstage = model.BERStage;
                string syoValues = string.Empty;
                if (model.BER2SyorList != null && model.BER2SyorList.Count > 0)
                {
                    syoValues = string.Join(",", model.BER2SyorList.Select(i => i.ToString()).ToArray());
                }
                var DataSetparameters = new Dictionary<string, DataTable>();
                DataTable TypecodeDt = new DataTable();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pApplicationId", Convert.ToString(model.ApplicationId));
                parameters.Add("@pRejectedBERReferenceId", Convert.ToString(model.RejectedBERReferenceId));
                parameters.Add("@pUserId", Convert.ToString(_UserSession.UserId));
                parameters.Add("@pCustomerId", Convert.ToString(_UserSession.CustomerId));
                parameters.Add("@pFacilityId", Convert.ToString(_UserSession.FacilityId));
                parameters.Add("@pServiceId", Convert.ToString(model.ServiceId));
                parameters.Add("@pBERno", Convert.ToString(model.BERno));
                parameters.Add("@pAssetId", Convert.ToString(model.AssetId));
                // parameters.Add("@pFreqDamSincPurchased", Convert.ToString(model.FreqDamSincPurchased));
                // parameters.Add("@pTotalCostImprovement", Convert.ToString(model.TotalCostImprovement));
                parameters.Add("@pEstRepcostToExpensive", model.EstRepcostToExpensive == true ? "true" : "false");
                parameters.Add("@pRepairEstimate", Convert.ToString(model.RepairEstimate));
                parameters.Add("@pValueAfterRepair", Convert.ToString(model.ValueAfterRepair));
                parameters.Add("@pEstDurUsgAfterRepair", Convert.ToString(model.EstDurUsgAfterRepair));
                parameters.Add("@pNotReliable", model.NotReliable == true ? "true" : "false");
                parameters.Add("@pStatutoryRequirements", model.StatutoryRequirements == true ? "true" : "false");
                parameters.Add("@pOtherObservations", Convert.ToString(model.OtherObservations));
                parameters.Add("@pApplicantStaffId", Convert.ToString(model.ApplicantStaffId));
                parameters.Add("@pBERStatus", Convert.ToString(model.BERStatus));
                parameters.Add("@pBER2TechnicalCondition", Convert.ToString(model.BER2TechnicalCondition));
                parameters.Add("@pBER2RepairedWell", Convert.ToString(model.BER2RepairedWell));
                parameters.Add("@pBER2SafeReliable", Convert.ToString(model.BER2SafeReliable));
                parameters.Add("@pBER2EstimateLifeTime", Convert.ToString(model.BER2EstimateLifeTime));
                parameters.Add("@pBER2Syor", Convert.ToString(syoValues));
                parameters.Add("@pBER2Remarks", Convert.ToString(model.BER2Remarks));
                parameters.Add("@pTBER2StillLifeSpan ", Convert.ToString(model.TBER2StillLifeSpan));
                parameters.Add("@pBIL", Convert.ToString(model.BIL));
                parameters.Add("@pBER1Remarks", Convert.ToString(model.BER1Remarks));
                parameters.Add("@pParentApplicationId", Convert.ToString(model.ParentApplicationId));
                parameters.Add("@pApprovedDate", model.ApprovedDate != null ? model.ApprovedDate.Value.ToString("yyyy-MM-dd") : null);
                parameters.Add("@pApprovedDateUTC", model.ApprovedDate != null ? model.ApprovedDate.Value.ToString("yyyy-MM-dd") : null);
                parameters.Add("@pJustificationForCertificates ", Convert.ToString(model.JustificationForCertificates));
                parameters.Add("@pApplicationDate", model.ApplicationDate != null ? model.ApplicationDate.ToString("yyyy-MM-dd") : null);
                parameters.Add("@pBER2TechnicalConditionOthers", Convert.ToString(model.BER2TechnicalConditionOthers));
                parameters.Add("@pBER2SafeReliableOthers", Convert.ToString(model.BER2SafeReliableOthers));
                parameters.Add("@pBER2EstimateLifeTimeOthers", Convert.ToString(model.BER2EstimateLifeTimeOthers));
                parameters.Add("@pBERStage", Convert.ToString(model.BERStage));
                parameters.Add("@pCircumstanceOthers", Convert.ToString(model.CircumstanceOthers));
                parameters.Add("@pExaminationFirstResultOthers", Convert.ToString(model.ExaminationFirstResultOthers));
                parameters.Add("@pEstimatedRepairCost", Convert.ToString(model.EstimatedRepairCost));
                parameters.Add("@pTimestamp", Convert.ToString(model.Timestamp));
                parameters.Add("@pCurrentValue", Convert.ToString(model.CurrentValue));
                parameters.Add("@pRequestorStaffId", Convert.ToString(model.RequestorId));
                parameters.Add("@pCurrentValueRemarks", Convert.ToString(model.CurrentValueRemarks));
                parameters.Add("@pObsolescence", model.Obsolescence == true ? "true" : "false");
                parameters.Add("@pCurrentRepairCost", Convert.ToString(model.CurrentRepairCost));
                parameters.Add("@pCannotRepair", model.CannotRepair == true ? "true" : "false");
                var dbAccessDAL = new DBAccessDAL();
                DataTable dt = new DataTable();
                //DataTable dt = dbAccessDAL.GetDataTable("uspFM_BERApplicationTxn_Save", parameters, DataSetparameters);


                var _service = 0;
                switch (_UserSession.ModuleId)
                {
                    case 3:
                        {
                            _service = 2;
                            break;
                        }

                    case 6:
                        {
                            _service = 2;
                            break;
                        }

                    case 13:
                        {
                            _service = 1;
                            break;
                        }
                    case 19:
                        {
                            _service = 6;
                            break;
                        }
                }


                dt = dbAccessDAL.GetDataTableUsingServiceId("uspFM_BERApplicationTxn_Save", parameters, DataSetparameters, _service);

                if (dt != null)
                {
                    string berno = string.Empty;
                    foreach (DataRow rows in dt.Rows)
                    {
                        model.ApplicationId = Convert.ToInt32(rows["ApplicationId"]);
                        if (rows["Timestamp"] == DBNull.Value)
                        {
                            model.Timestamp = "";
                        }
                        else
                        {
                            model.Timestamp = Convert.ToBase64String((byte[])(rows["Timestamp"]));
                        }
                        model.BERno = Convert.ToString(rows["BERno"]);
                        ErrorMessage = Convert.ToString(rows["ErrorMessage"]);
                        model.RequestorEmail = Convert.ToString(rows["EngineerEmail"]);
                        model.EngineerId = Convert.ToInt16(rows["EngineerId"]);
                    }

                    if (model.ApplicationId != 0)
                    {
                        if (model.BERStatus == 208 || model.BERStatus == 207 || model.BERStatus == 204 || model.BERStatus == 205 || model.BERStatus == 210 ||
                            model.BERStatus == 209 || model.BERStatus == 206 || (model.BERStatus == 202 && count == 1) || model.BERStatus == 203)
                        {
                            updateNotificationSingle(model, berstage);
                        }

                        if ((count == 1 && model.BERStatus == 202) || model.BERStatus == 203 ||
                             model.BERStatus == 204 || model.BERStatus == 205
                             || model.BERStatus == 209 || model.BERStatus == 207 || model.BERStatus == 208 || model.BERStatus == 206 || model.BERStatus == 210)
                        {
                            SendMail(model);
                        }



                    }

                }
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

        private void SendMail(BERApplicationTxn model)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(SendMail), Level.Info.ToString());
            try
            {
                string emailTemplateId = string.Empty;
                string subject = string.Empty;
                string subjectVars = string.Empty;
                string templateVars = string.Empty;
                string email = string.Empty;

                string AssetNo = string.Empty;
                var dbAccessDAL = new DBAccessDAL();

                if (model.BERStatus == 202)
                {
                    emailTemplateId = "42";
                    email = model.RequestorEmail;
                }

                else if (model.BERStatus == 203)
                {
                    emailTemplateId = "43";
                }
                else if (model.BERStatus == 204) // clarification sought by hd  
                {
                    emailTemplateId = "44";
                    email = model.RequestorEmail;
                }

                else if (model.BERStatus == 205) //  clarification sought by LA
                {
                    emailTemplateId = "45";
                    email = model.RequestorEmail;
                }

                else if (model.BERStatus == 209) //   clarified              
                    emailTemplateId = "46";
                else if (model.BERStatus == 207) //   forwarded to LA              
                {
                    emailTemplateId = "47";
                    email = model.RequestorEmail;
                }

                else if (model.BERStatus == 208) //   Recommeneded             
                    emailTemplateId = "48";
                else if (model.BERStatus == 206) //   Recommeneded  
                {
                    emailTemplateId = "49";
                    email = model.RequestorEmail;
                }
                if (model.BERStatus == 210)
                {
                    emailTemplateId = "74";
                    email = model.RequestorEmail;
                }

                templateVars = string.Join(",", model.AssetNo, "UETrack");

                //if (!string.IsNullOrEmpty(email))
                //{
                var DataSetparameters = new Dictionary<string, DataTable>();
                DataTable TypecodeDt = new DataTable();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pEmailTemplateId", Convert.ToString(emailTemplateId));
                parameters.Add("@pToEmailIds", email);
                parameters.Add("@pSubject", Convert.ToString(subject));
                parameters.Add("@pPriority", Convert.ToString(1));
                parameters.Add("@pSendAsHtml", Convert.ToString(1));
                parameters.Add("@pSubjectVars", Convert.ToString(subjectVars));
                parameters.Add("@pTemplateVars", Convert.ToString(templateVars));
                parameters.Add("@pFacilityId", Convert.ToString(_UserSession.FacilityId));
                DataTable dt = dbAccessDAL.GetDataTable("uspFM_EmailNotify_Save", parameters, DataSetparameters);
                if (dt != null)
                {
                    foreach (DataRow rows in dt.Rows)
                    {
                    }
                }
                //}
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
        public BERApplicationTxn updateNotificationSingle(BERApplicationTxn ent, int berstage)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());
            BERApplicationTxn griddata = new BERApplicationTxn();
            var dbAccessDAL = new DBAccessDAL();
            var parameters = new Dictionary<string, string>();
            var DataSetparameters = new Dictionary<string, DataTable>();
            var Hyplink = "/ber/ber1application?id=" + ent.ApplicationId;
            if (berstage == 2)
                Hyplink = "/ber/ber2application?id=" + ent.ApplicationId;
            else
                Hyplink = "/ber/ber1application?id=" + ent.ApplicationId;
            string notalert = string.Empty;
            var NotiToId = 0;
            var TemplateID = 0;
            if (ent.BERStatus == 206)
            {
                notalert = ent.BERno + " " + "BER has been approved";
                NotiToId = ent.EngineerId.Value;
                TemplateID = 49;
            }
            else if (ent.BERStatus == 202)
            {
                notalert = ent.BERno + " " + "BER has been generated";
                NotiToId = ent.EngineerId.Value;
                TemplateID = 42;
            }

            else if (ent.BERStatus == 203)
            {
                notalert = ent.BERno + " " + "BER has been verified";
                TemplateID = 43;
            }

            else if (ent.BERStatus == 204)
            {
                notalert = ent.BERno + " " + "BER clatification sought by HD";
                NotiToId = ent.EngineerId.Value;
                TemplateID = 44;
            }

            else if (ent.BERStatus == 205)
            {
                notalert = ent.BERno + " " + "BER clarification sought By Liaison Officer";
                NotiToId = ent.EngineerId.Value;
                TemplateID = 45;
            }

            else if (ent.BERStatus == 209)
                notalert = ent.BERno + " " + "BER has been clarified By Applicant";
            else if (ent.BERStatus == 207)
            {
                notalert = ent.BERno + " " + "BER forwarded to Liaison Officer";
                NotiToId = ent.EngineerId.Value;
                TemplateID = 47;
            }

            else if (ent.BERStatus == 208)
            {
                notalert = ent.BERno + " " + "BER acknowledged by Liaison Officer";
                NotiToId = ent.EngineerId.Value;
                TemplateID = 48;
            }

            else if (ent.BERStatus == 210)
            {
                notalert = ent.BERno + " " + "BER has been Rejected";
                NotiToId = ent.EngineerId.Value;
                TemplateID = 74;
            }

            parameters.Add("@pNotificationId", Convert.ToString(ent.NotificationId));
            parameters.Add("@pCustomerId", Convert.ToString(_UserSession.CustomerId));
            parameters.Add("@pFacilityId", Convert.ToString(_UserSession.FacilityId));
            parameters.Add("@pUserId", Convert.ToString(NotiToId));
            parameters.Add("@pNotificationAlerts", Convert.ToString(notalert));
            parameters.Add("@pRemarks", Convert.ToString(""));
            if (ent.BERStage == 1)
                parameters.Add("@pHyperLink", Convert.ToString(Hyplink));
            if (ent.BERStage == 2)
                parameters.Add("@pHyperLink", Convert.ToString(Hyplink));
            parameters.Add("@pIsNew", Convert.ToString(1));
            parameters.Add("@pNotificationDateTime", Convert.ToString(null));
            if (ent.BERStatus != 209)
            {
                parameters.Add("@pEmailTempId", Convert.ToString(TemplateID));
            }


            DataTable ds = dbAccessDAL.GetDataTable("uspFM_WebNotificationSingle_Save", parameters, DataSetparameters);
            if (ds != null)
            {
                foreach (DataRow row in ds.Rows)
                {
                    //model.CRMRequestId = Convert.ToInt32(row["CRMRequestId"]);
                    //model.Timestamp = Convert.ToBase64String((byte[])(row["Timestamp"]));
                    //// model.err = Convert.ToBase64String((byte[])(row["Timestamp"]));
                    //model.HiddenId = Convert.ToString(row["GuId"]);
                }
            }

            return ent;
        }




        public BERApplicationTxn GetApplicationHistiry(int id)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
            try
            {
                var dbAccessDAL = new DBAccessDAL();
                var obj = new BERApplicationTxn();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();

                parameters.Add("@pUserId", _UserSession.UserId.ToString());
                parameters.Add("@pApplicationId", Convert.ToString(id));
                DataTable dt = dbAccessDAL.GetDataTable("UspFM_BERApplicationHistoryTxn_GetById", parameters, DataSetparameters);

                if (dt != null && dt.Rows.Count > 0)
                {
                    var HistoryList = (from n in dt.AsEnumerable()
                                       select new BERApplicationHistoryTxn
                                       {
                                           ApplicationId = Convert.ToInt32(n["ApplicationId"]),
                                           BERno = Convert.ToString(n["BERno"]),
                                           ApplicationDate = n.Field<DateTime?>("ApplicationDate"),
                                           Status = Convert.ToInt32(n["Status"]),
                                           StatusValue = Convert.ToString(n["StatusValue"]),
                                           StaffName = Convert.ToString(n["StaffName"]),
                                           Designation = Convert.ToString(n["Designation"]),
                                           CreatedDate = n.Field<DateTime?>("ApplicationDate"),
                                           RejectedBERNo = Convert.ToString(n["RejectedBERNo"]),
                                       }).ToList();

                    if (HistoryList != null && HistoryList.Count > 0)
                    {
                        obj.BERApplicationHistoryTxns = HistoryList;
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


        public BERApplicationTxn GetMaintainanceHistory(int id)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(GetMaintainanceHistory), Level.Info.ToString());
                var dbAccessDAL = new DBAccessDAL();
                var obj = new BERApplicationTxn();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();

                parameters.Add("@pApplicationId", Convert.ToString(id));
                DataTable dt = dbAccessDAL.GetDataTable("UspFM_BERMaintenanceHistory_GetById", parameters, DataSetparameters);

                if (dt != null && dt.Rows.Count > 0)
                {
                    var HistoryList = (from n in dt.AsEnumerable()
                                       select new BERMaintananceHistoryDet
                                       {
                                           ApplicationId = Convert.ToInt32(n["ApplicationId"]),
                                           MaintenanceWorkNo = Convert.ToString(n["MaintenanceWorkNo"]),
                                           TotalContractCost = n.Field<Decimal?>("ContractorCost"),
                                           TotalCost = n.Field<Decimal?>("TotalCost"),
                                           MaintenanceWorkCategory = Convert.ToString(n["MaintenanceWorkCategory"]),
                                           MaintenanceWorkType = Convert.ToString(n["MaintenanceWorkType"]),
                                           DowntimeHoursMin = n.Field<Decimal?>("DowntimeHoursMin"),
                                           MaintenanceWorkDateTime = n.Field<DateTime?>("MaintenanceWorkDateTime"),
                                           TotalSpareCost = n.Field<Decimal?>("SparePartCost"),
                                           TotalLabourCost = n.Field<Decimal?>("LabourCost"),
                                           TotalVendorCost = n.Field<Decimal?>("VendorCost"),
                                       }).ToList();

                    if (HistoryList != null && HistoryList.Count > 0)
                    {
                        obj.BERMaintananceHistoryDets = HistoryList;
                    }
                }

                Log4NetLogger.LogExit(_FileName, nameof(Get), Level.Info.ToString());
                return obj;



                //Log4NetLogger.LogEntry(_FileName, nameof(GetMaintainanceHistory), Level.Info.ToString());
                //GridFilterResult filterResult = null;
                ////  var ApplicationId = 25;
                //var multipleOrderBy = pageFilter.SortColumn.Split(',');
                //var strOrderBy = string.Empty;
                //foreach (var order in multipleOrderBy)
                //{
                //    strOrderBy += order + " " + pageFilter.SortOrder + ",";
                //}
                //if (!string.IsNullOrEmpty(strOrderBy))
                //{
                //    strOrderBy = strOrderBy.TrimEnd(',');
                //}

                //strOrderBy = string.IsNullOrEmpty(strOrderBy) ? pageFilter.SortColumn + " " + pageFilter.SortOrder : strOrderBy;
                //var ds = new DataSet();
                //var dbAccessDAL = new DBAccessDAL();

                //var DataSetparameters = new Dictionary<string, DataTable>();
                //var parameters = new Dictionary<string, string>();
                //parameters.Add("@PageIndex", pageFilter.PageIndex.ToString());
                //parameters.Add("@PageSize", pageFilter.PageSize.ToString());
                //parameters.Add("@strCondition", pageFilter.QueryWhereCondition);
                //parameters.Add("@strSorting", strOrderBy);
                //// parameters.Add("@pApplicationId", Convert.ToString(ApplicationId));

                //DataTable dt = dbAccessDAL.GetDataTable("uspFM_BERMaintenanceWOHistory_GetAll", parameters, DataSetparameters);

                //if (dt != null && dt.Rows.Count > 0)
                //{
                //    var totalRecords = Convert.ToInt32(dt.Rows[0]["TotalRecords"]);
                //    var totalPages = (int)Math.Ceiling((float)totalRecords / (float)pageFilter.Rows);

                //    var commonDAL = new CommonDAL();
                //    var currentPageList = commonDAL.ToDynamicList(dt);
                //    filterResult = new GridFilterResult
                //    {
                //        TotalRecords = totalRecords,
                //        TotalPages = totalPages,
                //        RecordsList = currentPageList,
                //        CurrentPage = pageFilter.Page
                //    };
                //}
                //Log4NetLogger.LogExit(_FileName, nameof(GetMaintainanceHistory), Level.Info.ToString());
                ////return userRoles;
                //return filterResult;
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


        public BERApplicationTxn GetBerCurrentValueHistory(int id)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
            try
            {
                var dbAccessDAL = new DBAccessDAL();
                var obj = new BERApplicationTxn();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pApplicationId", Convert.ToString(id));
                DataTable dt = dbAccessDAL.GetDataTable("uspFM_BerCurrentValueHistoryTxnDet_GetByApplicationId", parameters, DataSetparameters);
                if (dt != null && dt.Rows.Count > 0)
                {
                    var HistoryList = (from n in dt.AsEnumerable()
                                       select new BerCurrentValueHistoryTxnDet
                                       {
                                           CurrentValue = n.Field<decimal?>("CurrentValue"),
                                           Remarks = Convert.ToString(n["Remarks"]),
                                           UpdatedBy = Convert.ToString(n["UpdatedBy"]),

                                       }).ToList();

                    if (HistoryList != null && HistoryList.Count > 0)
                    {
                        obj.BerCurrentValueHistoryTxnDets = HistoryList;
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


        public BERApplicationTxn SaveDocument(BERApplicationTxn Document, out string ErrorMessage)
        {

            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());
                ErrorMessage = string.Empty;
                var dbAccessDAL = new DBAccessDAL();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pCustomerId", Convert.ToString(_UserSession.CustomerId));
                parameters.Add("@pFacilityId", Convert.ToString(_UserSession.FacilityId));
                parameters.Add("@pServiceId", Convert.ToString(2));
                parameters.Add("@pApplicationId", Convert.ToString(Document.ApplicationId));
                parameters.Add("@pAttachedBy", Convert.ToString(_UserSession.UserId));
                parameters.Add("@pUserId", Convert.ToString(_UserSession.UserId));


                var DataSetparameters = new Dictionary<string, DataTable>();
                DataTable dt = new DataTable();
                dt.Columns.Add("DocumentId", typeof(int));
                dt.Columns.Add("GuId", typeof(string));
                dt.Columns.Add("CustomerId", typeof(int));
                dt.Columns.Add("FacilityId", typeof(int));
                dt.Columns.Add("DocumentNo", typeof(string));
                dt.Columns.Add("DocumentTitle", typeof(string));
                dt.Columns.Add("DocumentDescription", typeof(string));
                dt.Columns.Add("DocumentCategory", typeof(int));
                dt.Columns.Add("DocumentCategoryOthers", typeof(string));
                dt.Columns.Add("DocumentExtension", typeof(string));
                dt.Columns.Add("MajorVersion", typeof(int));
                dt.Columns.Add("MinorVersion", typeof(int));
                dt.Columns.Add("FileType", typeof(int));
                dt.Columns.Add("FilePath", typeof(string));
                dt.Columns.Add("FileName", typeof(string));
                dt.Columns.Add("UploadedDateUTC", typeof(DateTime));
                dt.Columns.Add("ScreenId", typeof(int));
                dt.Columns.Add("Remarks", typeof(string));
                dt.Columns.Add("UserId", typeof(int));
                dt.Columns.Add("Active", typeof(bool));

                var deletedId = Document.FileUploadList.Where(y => y.IsDeleted).Select(x => x.DocumentId).ToList();
                var idstring = string.Empty;
                if (deletedId.Count() > 0)
                {
                    foreach (var item in deletedId.Select((value, i) => new { i, value }))
                    {
                        idstring += item.value;
                        if (item.i != deletedId.Count() - 1)
                        { idstring += ","; }
                    }
                    deleteChildRecords(idstring);
                }

                foreach (var i in Document.FileUploadList.Where(y => !y.IsDeleted))
                {

                    dt.Rows.Add(i.DocumentId, i.GuId, _UserSession.CustomerId, _UserSession.FacilityId, i.DocumentNo, i.DocumentTitle, i.DocumentDescription, i.DocumentCategory, i.DocumentCategoryOthers,
                            i.DocumentExtension, i.MajorVersion, i.MinorVersion, i.FileType, i.FilePath, i.FileName, i.UploadedDateUTC, i.ScreenId, i.Remarks, _UserSession.UserId
                            , i.Active == true ? "true" : "false");
                }

                DataSetparameters.Add("@pFMDocument", dt);
                DataTable dt1 = dbAccessDAL.GetDataTable("uspFM_BERApplicationAttachmentTxn_Save", parameters, DataSetparameters);
                if (dt1 != null)
                {
                    foreach (DataRow row in dt1.Rows)
                    {
                        foreach (var val in Document.FileUploadList)

                        {
                            //val.Ap = Convert.ToInt32(row["DocumentId"]);
                            val.Timestamp = Convert.ToBase64String((byte[])(row["Timestamp"]));
                        }
                    }
                }

                Log4NetLogger.LogExit(_FileName, nameof(Save), Level.Info.ToString());
                return Document;
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

        public void deleteChildRecords(string id)
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
                        cmd.CommandText = "UspFM_EngStockAdjustmentTxnDet_Delete";      //Change SP
                        cmd.Parameters.AddWithValue("@pStockAdjustmentDetId", id);

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
        public BERApplicationTxn GetAttachmentDetails(int id)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
            try
            {
                var dbAccessDAL = new DBAccessDAL();
                var obj = new BERApplicationTxn();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pApplicationId", id.ToString());

                DataTable dt = dbAccessDAL.GetDataTable("uspFM_BERApplicationAttachmentTxn_GetById", parameters, DataSetparameters);
                if (dt != null && dt.Rows.Count > 0)
                {

                    var historyList = (from n in dt.AsEnumerable()
                                       select new FileUploadDetModel
                                       {
                                           FileType = Convert.ToInt32(n["FileType"]),
                                           FileName = Convert.ToString(n["FileName"]),
                                           FilePath = Convert.ToString(n["FilePath"]),
                                           DocumentId = Convert.ToInt32(n["DocumentId"]),
                                           DocumentTitle = Convert.ToString(n["DocumentTitle"]),
                                           DocumentExtension = Convert.ToString(n["DocumentExtension"]),
                                           Active = false,
                                           GuId = Convert.ToString(n["GuId"])

                                       }).ToList();


                    if (historyList != null && historyList.Count > 0)
                    {
                        obj.FileUploadList = historyList;
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

        public BerAdditionalFields GetAdditionalInfoForBer(int ApplicationId)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(GetAdditionalInfoForBer), Level.Info.ToString());
                var additionalFields = new BerAdditionalFields();

                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_BERAddFields_GetById";
                        cmd.Parameters.AddWithValue("@pApplicationId", ApplicationId);

                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }
                if (ds.Tables.Count != 0 && ds.Tables[0].Rows.Count > 0)
                {
                    additionalFields = (from n in ds.Tables[0].AsEnumerable()
                                        select new BerAdditionalFields
                                        {
                                            ApplicationId = ApplicationId,
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
                Log4NetLogger.LogExit(_FileName, nameof(GetAdditionalInfoForBer), Level.Info.ToString());
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

        public BerAdditionalFields SaveAdditionalInfoForBer(BerAdditionalFields AdditionalInfo, out string ErrorMessage)
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
                        cmd.CommandText = "uspFM_BERAddFields_Save";

                        SqlParameter parameter = new SqlParameter();
                        cmd.Parameters.AddWithValue("@pApplicationId", AdditionalInfo.ApplicationId);
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
