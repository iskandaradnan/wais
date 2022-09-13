using CP.Framework.Common.ExceptionHandler.ExceptionWrappers;
using CP.Framework.Common.Logging;
using CP.UETrack.DAL.DataAccess.Contracts;
using CP.UETrack.DAL.DataAccess.Contracts.BEMS;
using CP.UETrack.DAL.DataAccess.Implementation;
using CP.UETrack.DAL.Helper;
using CP.UETrack.Model;
using CP.UETrack.Model.BEMS;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using UETrack.DAL;

namespace CP.UETrack.DAL.DataAccess.Implementations.BEMS
{
    public class ScheduledWorkOrderDAL : IScheduledWorkOrderDAL
    {
        private readonly string _FileName = nameof(ScheduledWorkOrderDAL);
        readonly UserDetailsModel _UserSession = new SessionHelper().UserSession();
        private IEmailDAL _EmailDAL;
        public ScheduledWorkOrderDAL()
        {
            _EmailDAL = new EmailDAL();
        }
        #region
        //public ScheduledWorkOrderLovs Load()
        //{
        //    try
        //    {
        //        Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
        //        ScheduledWorkOrderLovs lovcollection = new ScheduledWorkOrderLovs();


        //        var ds1 = new DataSet();
        //        var ds2 = new DataSet();
        //        var dbAccessDAL = new DBAccessDAL();
        //        using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
        //        {
        //            using (SqlCommand cmd = new SqlCommand())
        //            {
        //                var da = new SqlDataAdapter();
        //                cmd.Connection = con;
        //                cmd.CommandType = CommandType.StoredProcedure;
        //                cmd.CommandText = "uspFM_Dropdown";
        //                cmd.Parameters.Clear();
        //                cmd.Parameters.AddWithValue("@pLovKey", "MWOProcessStatusReasonValue,WarrantyTypeValue,WorkOrderStatusValue,RescheduleReasonValue,WorkOrderPriorityValue,MWOTransferReasonValue,MWOWorkOrderCategoryValue,RealTimeStatusValue,PPMChecklistStatusValue,PPMCheckListStatusCategoryValue,YesNoValue,StockTypeValue,CustomerFeedbackValue,TypeOfContractValue,ReasonRemarks");
        //                da.SelectCommand = cmd;
        //                da.Fill(ds1);

        //                cmd.Connection = con;
        //                cmd.CommandType = CommandType.StoredProcedure;
        //                cmd.CommandText = "uspFM_Dropdown_Others";
        //                cmd.Parameters.Clear();
        //                cmd.Parameters.AddWithValue("@pLovKey", "");
        //                cmd.Parameters.AddWithValue("@pTableName", "EngMaintenanceWorkOrderTxn");

        //                da = new SqlDataAdapter();
        //                da.SelectCommand = cmd;
        //                da.Fill(ds2);
        //            }
        //        }

        //        if (ds1.Tables.Count != 0)
        //        {
        //            lovcollection.ReasonList = dbAccessDAL.GetLovRecords(ds1.Tables[0], "MWOProcessStatusReasonValue");
        //            lovcollection.WarrentyTypeList = dbAccessDAL.GetLovRecords(ds1.Tables[0], "WarrantyTypeValue");
        //            lovcollection.StatusList = dbAccessDAL.GetLovRecords(ds1.Tables[0], "WorkOrderStatusValue");
        //            lovcollection.TransferReasonList = dbAccessDAL.GetLovRecords(ds1.Tables[0], "MWOTransferReasonValue");
        //            lovcollection.WorkOrderCategoryList = dbAccessDAL.GetLovRecords(ds1.Tables[0], "MWOWorkOrderCategoryValue");
        //            lovcollection.WorkOrderPriorityList = dbAccessDAL.GetLovRecords(ds1.Tables[0], "WorkOrderPriorityValue");
        //            lovcollection.StatusList = lovcollection.StatusList.Where(x => x.LovId == 197).ToList();
        //            lovcollection.RealTimeStatusList = dbAccessDAL.GetLovRecords(ds1.Tables[0], "RealTimeStatusValue");
        //            lovcollection.PPMCheckListStatusList = dbAccessDAL.GetLovRecords(ds1.Tables[0], "PPMChecklistStatusValue");
        //            lovcollection.PPMCheckListStatusCategoryList = dbAccessDAL.GetLovRecords(ds1.Tables[0], "PPMCheckListStatusCategoryValue");
        //            lovcollection.PartReplacementCostInvolvedList = dbAccessDAL.GetLovRecords(ds1.Tables[0], "YesNoValue");
        //            lovcollection.StockTypeList = dbAccessDAL.GetLovRecords(ds1.Tables[0], "StockTypeValue");
        //            lovcollection.CustomerFeedbak = dbAccessDAL.GetLovRecords(ds1.Tables[0], "CustomerFeedbackValue");
        //            lovcollection.TypeofContractList = dbAccessDAL.GetLovRecords(ds1.Tables[0], "TypeOfContractValue");
        //            lovcollection.Reason = dbAccessDAL.GetLovRecords(ds1.Tables[0], "ReasonRemarks");
        //        }
        //        if (ds2.Tables.Count != 0)
        //        {
        //            lovcollection.CauseCodeList = dbAccessDAL.GetLovRecords(ds2.Tables[1]);
        //            lovcollection.QCCodeList = dbAccessDAL.GetLovRecords(ds2.Tables[0]);
        //        }
        //        lovcollection.IsAdditionalFieldsExist = IsAdditionalFieldsExist();
        //        lovcollection.IsExternal = _UserSession.AccessLevel == 4 ? true : false;
        //        Log4NetLogger.LogExit(_FileName, nameof(Load), Level.Info.ToString());
        //        return lovcollection;
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

        //public ScheduledWorkOrderModel Get(int Id)
        //{
        //    Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
        //    try
        //    {
        //        var dbAccessDAL = new DBAccessDAL();
        //        var obj = new ScheduledWorkOrderModel();
        //        var DataSetparameters = new Dictionary<string, DataTable>();
        //        var parameters = new Dictionary<string, string>();
        //        parameters.Add("@pWorkOrderId", Id.ToString());
        //        DataSet ds = dbAccessDAL.GetDataSet("UspFM_EngMaintenanceWorkOrderTxn_GetById", parameters, DataSetparameters);
        //        if (ds != null)
        //        {
        //            if (ds.Tables[0] != null && ds.Tables[0].Rows.Count > 0)
        //            {
        //                //public List<LovValue> Reason { get; set; }
        //                obj.WorkOrderId = Convert.ToInt32(ds.Tables[0].Rows[0]["WorkOrderId"]);
        //                obj.Remarks = Convert.ToString(ds.Tables[0].Rows[0]["Remarks"] == System.DBNull.Value ? null : ds.Tables[0].Rows[0]["Remarks"]);
        //                obj.AssetRegisterId = Convert.ToInt16(ds.Tables[0].Rows[0]["AssetId"] == System.DBNull.Value ? null : ds.Tables[0].Rows[0]["AssetId"]);
        //                obj.AssetNo = Convert.ToString(ds.Tables[0].Rows[0]["AssetNo"]);
        //                obj.AssetDescription = Convert.ToString(ds.Tables[0].Rows[0]["AssetDescription"] == System.DBNull.Value ? null : ds.Tables[0].Rows[0]["AssetDescription"]);
        //                obj.UserArea = Convert.ToString(ds.Tables[0].Rows[0]["UserAreaCode"] == System.DBNull.Value ? null : ds.Tables[0].Rows[0]["UserAreaCode"]);
        //                obj.UserLocation = Convert.ToString(ds.Tables[0].Rows[0]["UserLocationCode"] == System.DBNull.Value ? null : ds.Tables[0].Rows[0]["UserLocationCode"]);
        //                obj.Level = Convert.ToString(ds.Tables[0].Rows[0]["LevelCode"] == System.DBNull.Value ? null : ds.Tables[0].Rows[0]["LevelCode"]);
        //                obj.Block = Convert.ToString(ds.Tables[0].Rows[0]["BlockCode"] == System.DBNull.Value ? null : ds.Tables[0].Rows[0]["BlockCode"]);
        //                obj.Model = Convert.ToString(ds.Tables[0].Rows[0]["Model"] == System.DBNull.Value ? null : ds.Tables[0].Rows[0]["Model"]);
        //                obj.ContractTypeValue = Convert.ToString(ds.Tables[0].Rows[0]["ContractTypeValue"] == System.DBNull.Value ? null : ds.Tables[0].Rows[0]["ContractTypeValue"]);
        //                obj.AssetNoCost = Convert.ToString(ds.Tables[0].Rows[0]["ContractValue"] == System.DBNull.Value ? null : ds.Tables[0].Rows[0]["ContractValue"]);
        //                obj.Manufacturer = Convert.ToString(ds.Tables[0].Rows[0]["Manufacturer"] == System.DBNull.Value ? null : ds.Tables[0].Rows[0]["Manufacturer"]);
        //                obj.EngineerId = Convert.ToInt16(ds.Tables[0].Rows[0]["EngineerStaffId"] == System.DBNull.Value ? null : ds.Tables[0].Rows[0]["EngineerStaffId"]);
        //                obj.Engineer = Convert.ToString(ds.Tables[0].Rows[0]["EngineerStaffIdValue"] == System.DBNull.Value ? null : ds.Tables[0].Rows[0]["EngineerStaffIdValue"]);
        //                obj.RequestorId = Convert.ToInt16(ds.Tables[0].Rows[0]["RequestorStaffId"] == System.DBNull.Value ? null : ds.Tables[0].Rows[0]["RequestorStaffId"]);
        //                obj.Requestor = Convert.ToString(ds.Tables[0].Rows[0]["RequestorStaffIdValue"] == System.DBNull.Value ? null : ds.Tables[0].Rows[0]["RequestorStaffIdValue"]);
        //                obj.MaintenanceType = Convert.ToInt32(ds.Tables[0].Rows[0]["MaintenanceWorkType"] == System.DBNull.Value ? null : ds.Tables[0].Rows[0]["MaintenanceWorkType"]);
        //                obj.WorkOrderPriority = Convert.ToInt16(ds.Tables[0].Rows[0]["WorkOrderPriority"] == System.DBNull.Value ? null : ds.Tables[0].Rows[0]["WorkOrderPriority"]);
        //                obj.TypeOfWorkOrder = Convert.ToInt32(ds.Tables[0].Rows[0]["TypeOfWorkOrder"]);
        //                obj.PartWorkOrderDate = Convert.ToDateTime(ds.Tables[0].Rows[0]["MaintenanceWorkDateTime"]);
        //                obj.WorkOrderNo = Convert.ToString(ds.Tables[0].Rows[0]["MaintenanceWorkNo"]);
        //                obj.MaintenanceDetails = Convert.ToString(ds.Tables[0].Rows[0]["MaintenanceDetails"]);
        //                obj.WorkOrderStatus = Convert.ToInt32(ds.Tables[0].Rows[0]["WorkOrderStatus"]);
        //                obj.WorkOrderStatusValue = Convert.ToString(ds.Tables[0].Rows[0]["WorkOrderStatusValue"]);
        //                obj.TargetDate = Convert.ToDateTime(ds.Tables[0].Rows[0]["TargetDateTime"] == System.DBNull.Value ? null : ds.Tables[0].Rows[0]["TargetDateTime"]);
        //                obj.Timestamp = Convert.ToBase64String((byte[])(ds.Tables[0].Rows[0]["Timestamp"]));
        //                obj.HiddenId = Convert.ToString(ds.Tables[0].Rows[0]["GuId"]);
        //                obj.RunningHoursCapture = Convert.ToInt16(ds.Tables[0].Rows[0]["RunningHoursCapture"] == System.DBNull.Value ? null : ds.Tables[0].Rows[0]["RunningHoursCapture"]);
        //                obj.Base64StringImage = ds.Tables[0].Rows[0]["WOImage"] != DBNull.Value ? (Convert.ToBase64String((byte[])(ds.Tables[0].Rows[0]["WOImage"]))) : null;
        //                obj.Base64StringSignature = ds.Tables[0].Rows[0]["WOSignature"] != DBNull.Value ? (Convert.ToBase64String((byte[])(ds.Tables[0].Rows[0]["WOSignature"]))) : null;
        //                obj.Base64StringVideo = ds.Tables[0].Rows[0]["WOVideo"] != DBNull.Value ? (Convert.ToBase64String((byte[])(ds.Tables[0].Rows[0]["WOVideo"]))) : null;
        //                obj.WorkOrderAssignee = Convert.ToString(ds.Tables[0].Rows[0]["AssigneeUserName"]);
        //                obj.WorkOrderAssigneeId = Convert.ToInt16(ds.Tables[0].Rows[0]["AssignedUserId"] == System.DBNull.Value ? null : ds.Tables[0].Rows[0]["AssignedUserId"]);
        //                obj.AssetWorkingStatusValue = Convert.ToString(ds.Tables[0].Rows[0]["AssetWorkingStatusValue"] == System.DBNull.Value ? null : ds.Tables[0].Rows[0]["AssetWorkingStatusValue"]);
        //                obj.AssessmentId = Convert.ToInt16(ds.Tables[0].Rows[0]["AssesmentId"] == System.DBNull.Value ? null : ds.Tables[0].Rows[0]["AssesmentId"]);
        //            }
        //        }
        //        Log4NetLogger.LogExit(_FileName, nameof(Get), Level.Info.ToString());
        //        return obj;
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
        #endregion
        public ScheduledWorkOrderLovs Load()
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
                ScheduledWorkOrderLovs lovcollection = new ScheduledWorkOrderLovs();
                ScheduleGenerationLovs lovcollections = new ScheduleGenerationLovs();

                var ds1 = new DataSet();
                var ds2 = new DataSet();
                var ds3 = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        var da = new SqlDataAdapter();
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_Dropdown";
                        cmd.Parameters.Clear();
                        cmd.Parameters.AddWithValue("@pLovKey", "MWOProcessStatusReasonValue,PlannerClassificationValue,WarrantyTypeValue,WorkOrderStatusValue,RescheduleReasonValue,WorkOrderPriorityValue,MWOTransferReasonValue,MWOWorkOrderCategoryValue,RealTimeStatusValue,PPMChecklistStatusValue,PPMCheckListStatusCategoryValue,YesNoValue,StockTypeValue,CustomerFeedbackValue,TypeOfContractValue,WorkGroup");
                        da.SelectCommand = cmd;
                        da.Fill(ds1);

                        //cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_Dropdown_Others";
                        cmd.Parameters.Clear();
                        cmd.Parameters.AddWithValue("@pLovKey", "");
                        cmd.Parameters.AddWithValue("@pTableName", "EngMaintenanceWorkOrderTxn");

                        //da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds2);
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_Dropdown_group";
                        cmd.Parameters.Clear();
                        da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds3);
                    }
                }

                if (ds1.Tables.Count != 0)
                {
                    lovcollection.ReasonList = dbAccessDAL.GetLovRecords(ds1.Tables[0], "MWOProcessStatusReasonValue");
                    lovcollection.TypeOfPlannerList = dbAccessDAL.GetLovRecords(ds1.Tables[0], "PlannerClassificationValue");
                    lovcollection.WarrentyTypeList = dbAccessDAL.GetLovRecords(ds1.Tables[0], "WarrantyTypeValue");
                    lovcollection.StatusList = dbAccessDAL.GetLovRecords(ds1.Tables[0], "WorkOrderStatusValue");
                    lovcollection.TransferReasonList = dbAccessDAL.GetLovRecords(ds1.Tables[0], "MWOTransferReasonValue");
                    lovcollection.WorkOrderCategoryList = dbAccessDAL.GetLovRecords(ds1.Tables[0], "MWOWorkOrderCategoryValue");
                    lovcollection.WorkOrderPriorityList = dbAccessDAL.GetLovRecords(ds1.Tables[0], "WorkOrderPriorityValue");
                    lovcollection.StatusList = lovcollection.StatusList.Where(x => x.LovId == 197).ToList();
                    lovcollection.RealTimeStatusList = dbAccessDAL.GetLovRecords(ds1.Tables[0], "RealTimeStatusValue");
                    lovcollection.PPMCheckListStatusList = dbAccessDAL.GetLovRecords(ds1.Tables[0], "PPMChecklistStatusValue");
                    lovcollection.PPMCheckListStatusCategoryList = dbAccessDAL.GetLovRecords(ds1.Tables[0], "PPMCheckListStatusCategoryValue");
                    lovcollection.PartReplacementCostInvolvedList = dbAccessDAL.GetLovRecords(ds1.Tables[0], "YesNoValue");
                    lovcollection.StockTypeList = dbAccessDAL.GetLovRecords(ds1.Tables[0], "StockTypeValue");
                    lovcollection.CustomerFeedbak = dbAccessDAL.GetLovRecords(ds1.Tables[0], "CustomerFeedbackValue");
                    lovcollection.TypeofContractList = dbAccessDAL.GetLovRecords(ds1.Tables[0], "TypeOfContractValue");
                    lovcollection.Criticality = dbAccessDAL.GetLovRecords(ds1.Tables[0], "Criticality");

                }
                if (ds2.Tables.Count != 0)
                {
                    lovcollection.CauseCodeList = dbAccessDAL.GetLovRecords(ds2.Tables[1]);
                    lovcollection.QCCodeList = dbAccessDAL.GetLovRecords(ds2.Tables[0]);

                }
                if (ds3.Tables.Count != 0)
                {
                    lovcollection.WorkGroupVaule = dbAccessDAL.GetLovRecords(ds3.Tables[0]);
                }
                lovcollection.IsAdditionalFieldsExist = IsAdditionalFieldsExist();
                lovcollection.IsExternal = _UserSession.AccessLevel == 4 ? true : false;
                Log4NetLogger.LogExit(_FileName, nameof(Load), Level.Info.ToString());
                return lovcollection;
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

        public ScheduledWorkOrderModel Get(int Id)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
            try
            {
                var dbAccessDAL = new DBAccessDAL();
                var obj = new ScheduledWorkOrderModel();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pWorkOrderId", Id.ToString());
                var objs = new EngAssetTypeCode();
                var objDataSetparameters = new Dictionary<string, DataTable>();
                var objparameters = new Dictionary<string, string>();
                objparameters.Add("@pAssetTypeCodeId", Id.ToString());
                var cri = "";
                DataSet dss = dbAccessDAL.GetDataSet("uspFM_EngAssetTypeCode_GetById", objparameters, objDataSetparameters);
                if (dss != null)
                {
                    if (dss.Tables[0] != null && dss.Tables[0].Rows.Count > 0)
                    {
                        objs.AssetTypeCodeId = Convert.ToInt32(dss.Tables[0].Rows[0]["AssetTypeCodeId"]);
                        objs.ServiceId = Convert.ToInt32(dss.Tables[0].Rows[0]["ServiceId"]);
                        objs.Criticality = Convert.ToInt32(dss.Tables[0].Rows[0]["Criticality"]);
                        cri = objs.Criticality.ToString();
                    }
                }

                if (cri == "10024")
                {

                }
                DataSet ds = dbAccessDAL.GetDataSet("UspFM_EngMaintenanceWorkOrderTxn_GetById", parameters, DataSetparameters);
                if (ds != null)
                {
                    if (ds.Tables[0] != null && ds.Tables[0].Rows.Count > 0)
                    {
                        obj.WorkOrderId = Convert.ToInt32(ds.Tables[0].Rows[0]["WorkOrderId"]);
                        obj.AssetRegisterId = Convert.ToInt32(ds.Tables[0].Rows[0]["AssetId"] == System.DBNull.Value ? null : ds.Tables[0].Rows[0]["AssetId"]);
                        obj.AssetNo = Convert.ToString(ds.Tables[0].Rows[0]["AssetNo"]);
                        obj.AssetDescription = Convert.ToString(ds.Tables[0].Rows[0]["AssetDescription"] == System.DBNull.Value ? null : ds.Tables[0].Rows[0]["AssetDescription"]);
                        obj.UserArea = Convert.ToString(ds.Tables[0].Rows[0]["UserAreaCode"] == System.DBNull.Value ? null : ds.Tables[0].Rows[0]["UserAreaCode"]);
                        obj.UserLocation = Convert.ToString(ds.Tables[0].Rows[0]["UserLocationCode"] == System.DBNull.Value ? null : ds.Tables[0].Rows[0]["UserLocationCode"]);
                        //Added for printform
                        //obj.UserAreaName = Convert.ToString(ds.Tables[0].Rows[0]["UserAreaNames"] == System.DBNull.Value ? null : ds.Tables[0].Rows[0]["UserAreaNames"]);
                        obj.UserLocationName = Convert.ToString(ds.Tables[0].Rows[0]["UserLocationName"] == System.DBNull.Value ? null : ds.Tables[0].Rows[0]["UserLocationName"]);
                        obj.AssetStatus = Convert.ToString(ds.Tables[0].Rows[0]["AssetStatus"] == System.DBNull.Value ? null : ds.Tables[0].Rows[0]["AssetStatus"]);
                        obj.AssetCrticality = Convert.ToString(ds.Tables[0].Rows[0]["AssetCrticality"] == System.DBNull.Value ? null : ds.Tables[0].Rows[0]["AssetCrticality"]);
                        obj.VariationStatus = Convert.ToString(ds.Tables[0].Rows[0]["VariationStatus"] == System.DBNull.Value ? null : ds.Tables[0].Rows[0]["VariationStatus"]);
                        obj.AssetCondition = Convert.ToString(ds.Tables[0].Rows[0]["AssetCondition"] == System.DBNull.Value ? null : ds.Tables[0].Rows[0]["AssetCondition"]);
                        obj.SerialNo = Convert.ToString(ds.Tables[0].Rows[0]["SerialNo"] == System.DBNull.Value ? null : ds.Tables[0].Rows[0]["SerialNo"]);
                        obj.ServiceLife = Convert.ToDecimal(ds.Tables[0].Rows[0]["ServiceLife"] == System.DBNull.Value ? null : ds.Tables[0].Rows[0]["ServiceLife"]);
                        obj.WarrantyStartDate = Convert.ToDateTime(ds.Tables[0].Rows[0]["WarrantyStartDate"] == System.DBNull.Value ? null : ds.Tables[0].Rows[0]["WarrantyStartDate"]);
                        obj.WarrantyEndDate = Convert.ToDateTime(ds.Tables[0].Rows[0]["WarrantyEndDate"] == System.DBNull.Value ? null : ds.Tables[0].Rows[0]["WarrantyEndDate"]);
                        obj.MobileNumber = Convert.ToString(ds.Tables[0].Rows[0]["MobileNumber"] == System.DBNull.Value ? null : ds.Tables[0].Rows[0]["MobileNumber"]);
                        //End 
                        obj.Level = Convert.ToString(ds.Tables[0].Rows[0]["LevelCode"] == System.DBNull.Value ? null : ds.Tables[0].Rows[0]["LevelCode"]);
                        obj.Block = Convert.ToString(ds.Tables[0].Rows[0]["BlockCode"] == System.DBNull.Value ? null : ds.Tables[0].Rows[0]["BlockCode"]);
                        obj.Model = Convert.ToString(ds.Tables[0].Rows[0]["Model"] == System.DBNull.Value ? null : ds.Tables[0].Rows[0]["Model"]);
                        obj.ContractTypeValue = Convert.ToString(ds.Tables[0].Rows[0]["ContractTypeValue"] == System.DBNull.Value ? null : ds.Tables[0].Rows[0]["ContractTypeValue"]);
                        obj.AssetNoCost = Convert.ToString(ds.Tables[0].Rows[0]["ContractValue"] == System.DBNull.Value ? null : ds.Tables[0].Rows[0]["ContractValue"]);
                        obj.Manufacturer = Convert.ToString(ds.Tables[0].Rows[0]["Manufacturer"] == System.DBNull.Value ? null : ds.Tables[0].Rows[0]["Manufacturer"]);
                        obj.EngineerId = Convert.ToInt32(ds.Tables[0].Rows[0]["EngineerStaffId"] == System.DBNull.Value ? null : ds.Tables[0].Rows[0]["EngineerStaffId"]);
                        obj.Engineer = Convert.ToString(ds.Tables[0].Rows[0]["EngineerStaffIdValue"] == System.DBNull.Value ? null : ds.Tables[0].Rows[0]["EngineerStaffIdValue"]);
                        obj.RequestorId = Convert.ToInt32(ds.Tables[0].Rows[0]["RequestorStaffId"] == System.DBNull.Value ? null : ds.Tables[0].Rows[0]["RequestorStaffId"]);
                        obj.Requestor = Convert.ToString(ds.Tables[0].Rows[0]["RequestorStaffIdValue"] == System.DBNull.Value ? null : ds.Tables[0].Rows[0]["RequestorStaffIdValue"]);
                        obj.MaintenanceType = Convert.ToInt32(ds.Tables[0].Rows[0]["MaintenanceWorkType"] == System.DBNull.Value ? null : ds.Tables[0].Rows[0]["MaintenanceWorkType"]);
                        obj.MaintenanceTypeVaule = Convert.ToString(ds.Tables[0].Rows[0]["MaintenanceWorkTypeValue"] == System.DBNull.Value ? null : ds.Tables[0].Rows[0]["MaintenanceWorkTypeValue"]);
                        obj.WorkOrderPriority = Convert.ToInt32(ds.Tables[0].Rows[0]["WorkOrderPriority"] == System.DBNull.Value ? null : ds.Tables[0].Rows[0]["WorkOrderPriority"]);
                        obj.TypeOfWorkOrder = Convert.ToInt32(ds.Tables[0].Rows[0]["TypeOfWorkOrder"]);
                        obj.PartWorkOrderDate = Convert.ToDateTime(ds.Tables[0].Rows[0]["MaintenanceWorkDateTime"]);
                        obj.WorkOrderNo = Convert.ToString(ds.Tables[0].Rows[0]["MaintenanceWorkNo"]);
                        obj.MaintenanceDetails = Convert.ToString(ds.Tables[0].Rows[0]["MaintenanceDetails"]);
                        obj.WorkOrderStatus = Convert.ToInt32(ds.Tables[0].Rows[0]["WorkOrderStatus"]);
                        obj.WorkOrderStatusValue = Convert.ToString(ds.Tables[0].Rows[0]["WorkOrderStatusValue"]);
                        obj.TargetDate = Convert.ToDateTime(ds.Tables[0].Rows[0]["TargetDateTime"] == System.DBNull.Value ? null : ds.Tables[0].Rows[0]["TargetDateTime"]);
                        obj.Timestamp = Convert.ToBase64String((byte[])(ds.Tables[0].Rows[0]["Timestamp"]));
                        obj.HiddenId = Convert.ToString(ds.Tables[0].Rows[0]["GuId"]);
                        obj.RunningHoursCapture = Convert.ToInt32(ds.Tables[0].Rows[0]["RunningHoursCapture"] == System.DBNull.Value ? null : ds.Tables[0].Rows[0]["RunningHoursCapture"]);
                        obj.Base64StringImage = ds.Tables[0].Rows[0]["WOImage"] != DBNull.Value ? (Convert.ToBase64String((byte[])(ds.Tables[0].Rows[0]["WOImage"]))) : null;
                        obj.Base64StringSignature = ds.Tables[0].Rows[0]["WOSignature"] != DBNull.Value ? (Convert.ToBase64String((byte[])(ds.Tables[0].Rows[0]["WOSignature"]))) : null;
                        obj.Base64StringVideo = ds.Tables[0].Rows[0]["WOVideo"] != DBNull.Value ? (Convert.ToBase64String((byte[])(ds.Tables[0].Rows[0]["WOVideo"]))) : null;
                        obj.WorkOrderAssignee = Convert.ToString(ds.Tables[0].Rows[0]["AssigneeUserName"]);
                        obj.WorkOrderAssigneeId = Convert.ToInt32(ds.Tables[0].Rows[0]["AssignedUserId"] == System.DBNull.Value ? null : ds.Tables[0].Rows[0]["AssignedUserId"]);
                        obj.AssetWorkingStatusValue = Convert.ToString(ds.Tables[0].Rows[0]["AssetWorkingStatusValue"] == System.DBNull.Value ? null : ds.Tables[0].Rows[0]["AssetWorkingStatusValue"]);
                        obj.AssessmentId = Convert.ToInt32(ds.Tables[0].Rows[0]["AssesmentId"] == System.DBNull.Value ? null : ds.Tables[0].Rows[0]["AssesmentId"]);
                        obj.AssetTypeCodeId = Convert.ToInt32(ds.Tables[0].Rows[0]["AssetTypeCodeId"] == System.DBNull.Value ? null : ds.Tables[0].Rows[0]["AssetTypeCodeId"]);
                        obj.AssetTypeCode = Convert.ToString(ds.Tables[0].Rows[0]["AssetTypeCode"] == System.DBNull.Value ? null : ds.Tables[0].Rows[0]["AssetTypeCode"]);
                        obj.AssetTypeDescription = Convert.ToString(ds.Tables[0].Rows[0]["AssetTypeDescription"] == System.DBNull.Value ? null : ds.Tables[0].Rows[0]["AssetTypeDescription"]);
                        obj.AssetName = Convert.ToString(ds.Tables[0].Rows[0]["Asset_Name"] == System.DBNull.Value ? null : ds.Tables[0].Rows[0]["Asset_Name"]);
                        obj.RequesterDesignation = Convert.ToString(ds.Tables[0].Rows[0]["Designation"] == System.DBNull.Value ? null : ds.Tables[0].Rows[0]["Designation"]);
                        obj.AssigneeDesignation = Convert.ToString(ds.Tables[0].Rows[0]["AssigneeDesignation"] == System.DBNull.Value ? null : ds.Tables[0].Rows[0]["AssigneeDesignation"]);
                        obj.WorkGroup = Convert.ToString(ds.Tables[0].Rows[0]["WorkGroup"] == System.DBNull.Value ? null : ds.Tables[0].Rows[0]["WorkGroup"]);
                        obj.UserAreaName = Convert.ToString(ds.Tables[0].Rows[0]["UserAreaName"] == System.DBNull.Value ? null : ds.Tables[0].Rows[0]["UserAreaName"]);
                        //obj.AssessmentFeedBack = Convert.ToString(ds.Tables[0].Rows[0]["Justification"]);
                        obj.ServiceId = Convert.ToInt32(ds.Tables[0].Rows[0]["ServiceId"]);
                        obj.WorkOrderPriorityValue = Convert.ToString(ds.Tables[0].Rows[0]["WorkOrderPriorityValue"]);
                        obj.RepairDetails = Convert.ToString(ds.Tables[0].Rows[0]["RepairDetails"] == System.DBNull.Value ? null : ds.Tables[0].Rows[0]["RepairDetails"]);
                        obj.WorkOrderCategory = Convert.ToInt32(ds.Tables[0].Rows[0]["WorkOrderCategoryType"] == System.DBNull.Value ? null : ds.Tables[0].Rows[0]["WorkOrderCategoryType"]);
                        obj.PPMCheckListRemarks = Convert.ToString(ds.Tables[0].Rows[0]["Remarks"]);
                        if (_UserSession.UserDB == 2)
                        {
                            obj.AssetClassificationDescription = ds.Tables[0].Rows[0]["WorkGroup"].ToString();
                            obj.WorkGroupVaule = Convert.ToInt32(ds.Tables[0].Rows[0]["WorkGroupType"] == System.DBNull.Value ? null : ds.Tables[0].Rows[0]["WorkGroupType"]);
                        }
                        else
                        {
                        }
                    }
                    if (_UserSession.ServiceId == 2)
                    {
                        obj.AssetClassificationDescription = Convert.ToString(ds.Tables[0].Rows[0]["WorkGroup"]);
                    }
                    else
                    {

                    }
                }
                Log4NetLogger.LogExit(_FileName, nameof(Get), Level.Info.ToString());
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

        public ScheduledWorkOrderModel GetQC(int Id)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
            try
            {
                var dbAccessDAL = new DBAccessDAL();
                var obj = new ScheduledWorkOrderModel();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pQualityCauseDetId", Id.ToString());
                DataSet ds = dbAccessDAL.GetDataSet("UspFM_QCCodeFetchUsingUserType_GetById", parameters, DataSetparameters);

                if (ds != null)
                {
                    if (ds.Tables[0] != null && ds.Tables[0].Rows.Count > 0)
                    {
                        obj.QCCode = Convert.ToString(ds.Tables[0].Rows[0]["QcCode"]);
                    }
                    if (ds.Tables[1] != null && ds.Tables[1].Rows.Count > 0)
                    {

                        obj.QCCodeListBased = dbAccessDAL.GetLovRecords(ds.Tables[1]);
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

        public ScheduledWorkOrderModel GetCC(int Id)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
            try
            {
                var dbAccessDAL = new DBAccessDAL();
                var obj = new ScheduledWorkOrderModel();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pQualityCauseId", Id.ToString());
                DataSet ds = dbAccessDAL.GetDataSet("UspFM_CauseCodeFetchUsingUserType_GetById", parameters, DataSetparameters);
                if (ds != null)
                {
                    if (ds.Tables[0] != null && ds.Tables[0].Rows.Count > 0)
                    {
                        obj.CauseCode = Convert.ToString(ds.Tables[0].Rows[0]["CauseCode"]);
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

        public ScheduledWorkOrderLovs GetCheckListDD(int Id)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
            try
            {
                var dbAccessDAL = new DBAccessDAL();
                var obj = new ScheduledWorkOrderLovs();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pWorkOrderId", Id.ToString());
                DataSet ds = dbAccessDAL.GetDataSet("uspFM_GetPPMChecklistUsingWorkOrderId_GetById", parameters, DataSetparameters);
                if (ds != null)
                {
                    if (ds.Tables[0] != null && ds.Tables[0].Rows.Count > 0)
                    {
                        obj.PPMCheckListNoIdList = dbAccessDAL.GetLovRecords(ds.Tables[0]);
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

        public ScheduledWorkOrderModel GetAssessment(int Id)

        {
            Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
            try
            {
                var dbAccessDAL = new DBAccessDAL();
                var obj = new ScheduledWorkOrderModel();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pWorkOrderId", Id.ToString());
                parameters.Add("@pUserId", Convert.ToString(_UserSession.UserId));
                DataSet ds = dbAccessDAL.GetDataSet("UspFM_EngMwoAssesmentTxn_GetById", parameters, DataSetparameters);
                if (ds != null)
                {
                    if (ds.Tables[0] != null && ds.Tables[0].Rows.Count > 0)
                    {
                        obj.WorkOrderId = Convert.ToInt32(ds.Tables[0].Rows[0]["WorkOrderId"]);
                        obj.AssessmentId = Convert.ToInt32(ds.Tables[0].Rows[0]["AssesmentId"]);
                        obj.AssessmentResponsedate = Convert.ToDateTime(ds.Tables[0].Rows[0]["ResponseDateTime"]);
                        obj.AssessmentTargetDate = Convert.ToDateTime(ds.Tables[0].Rows[0]["TargetDateTime"] == System.DBNull.Value ? null : ds.Tables[0].Rows[0]["TargetDateTime"]);
                        obj.AssessmentFeedBack = Convert.ToString(ds.Tables[0].Rows[0]["Justification"]);
                        obj.RealTimeStatus = Convert.ToInt32(ds.Tables[0].Rows[0]["AssetRealTimeStatus"] == System.DBNull.Value ? null : ds.Tables[0].Rows[0]["AssetRealTimeStatus"]);
                        obj.AssessmentStaffName = _UserSession.UserName;
                        obj.AssessmentResponseDuration = Convert.ToString(ds.Tables[0].Rows[0]["ResponseDuration"]);
                        obj.Timestamp = Convert.ToBase64String((byte[])(ds.Tables[0].Rows[0]["Timestamp"]));
                        obj.IsAssignedToVendor = Convert.ToInt32(ds.Tables[0].Rows[0]["IsChangeToVendor"] == System.DBNull.Value ? null : ds.Tables[0].Rows[0]["IsChangeToVendor"]);
                        obj.AssignedVendor = Convert.ToInt32(ds.Tables[0].Rows[0]["AssignedVendor"] == System.DBNull.Value ? null : ds.Tables[0].Rows[0]["AssignedVendor"]);
                        obj.AssignedVendorName = Convert.ToString(ds.Tables[0].Rows[0]["AssignedVendorName"] == System.DBNull.Value ? null : ds.Tables[0].Rows[0]["AssignedVendorName"]);
                        obj.WorkOrderStatus = Convert.ToInt32(ds.Tables[0].Rows[0]["WorkOrderStatus"]);
                        obj.WorkOrderStatusValue = Convert.ToString(ds.Tables[0].Rows[0]["WorkOrderStatusValue"]);
                        obj.VendorProStatus = Convert.ToString(ds.Tables[0].Rows[0]["FMvendorApproveStatus"] == System.DBNull.Value ? null : ds.Tables[0].Rows[0]["FMvendorApproveStatus"]);
                        obj.WorkOrderAssignee = Convert.ToString(ds.Tables[0].Rows[0]["EngineerStaffIdValue"] == System.DBNull.Value ? null : ds.Tables[0].Rows[0]["EngineerStaffIdValue"]);
                        obj.WorkOrderAssigneeId = Convert.ToInt32(ds.Tables[0].Rows[0]["EngineerStaffId"] == System.DBNull.Value ? null : ds.Tables[0].Rows[0]["EngineerStaffId"]);

                    }
                }
                obj.AssessmentStaffName = _UserSession.UserName;
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

        public ScheduledWorkOrderModel GetCompletionInfo(int Id, int pagesize, int pageindex)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
            try
            {
                var dbAccessDAL = new DBAccessDAL();
                var obj = new ScheduledWorkOrderModel();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pUserId", Convert.ToString(_UserSession.UserId));
                parameters.Add("@pWorkOrderId", Id.ToString());
                parameters.Add("@pPageIndex", pageindex.ToString());
                parameters.Add("@pPageSize", pagesize.ToString());
                DataSet ds = dbAccessDAL.GetDataSet("UspFM_EngMwoCompletionInfoTxn_GetById", parameters, DataSetparameters);

                if (ds.Tables.Count != 0 && ds.Tables[0].Rows.Count > 0)
                {
                    obj = (from n in ds.Tables[0].AsEnumerable()
                           select new ScheduledWorkOrderModel
                           {
                               CompletionInfoId = n.Field<int>("CompletionInfoId"),
                               WorkOrderId = n.Field<int>("WorkOrderId"),
                               //WorkOrderNo = n.Field<string>("MaintenanceWorkNo"),
                               WorkOrderNo = Convert.ToString(n["MaintenanceWorkNo"] == System.DBNull.Value ? null : n["MaintenanceWorkNo"]),
                               StartDate = n.Field<DateTime>("StartDateTime"),
                               EndDate = n.Field<DateTime?>("EndDateTime"),
                               StartDateMain = n.Field<DateTime>("StartDateTime"),
                               EndDateMain = n.Field<DateTime?>("EndDateTime"),
                               CompletedById = n.Field<int>("CompletedBy"),
                               CompletedBy = n.Field<string>("CompletedByValue"),
                               CompletedByDesignation = n.Field<string>("CompletedByDesignation"),
                               HandOverDate = Convert.ToDateTime(n["HandOverDateTime"] == System.DBNull.Value ? null : n["HandOverDateTime"]),
                               //HandOverDate = n.Field<DateTime>("HandOverDateTime"),
                               VerifiedById = n.Field<int?>("AcceptedBy"),
                               VerifiedBy = n.Field<string>("AcceptedByName"),
                               VerifiedByDesignation = n.Field<string>("AcceptedByDesignation"),
                               QCDescription = n.Field<int?>("QCCode"),
                               QCCode = n.Field<string>("QCCodeValue"),
                               QCCodeFieldVaule = n.Field<string>("QCCodeFieldVaule"),
                               CauseCodeDescription = n.Field<int?>("CauseCode"),
                               CauseCode = n.Field<string>("CauseCodeValue"),
                               RepairDetails = n.Field<string>("RepairDetails"),
                               Status = n.Field<int?>("ProcessStatus"),
                               WorkOrderStatusValue = n.Field<string>("WorkOrderStatusValue"),
                               Date = n.Field<DateTime?>("ProcessStatusDate"),
                               AgreedDate = n.Field<DateTime?>("PPMAgreedDate"),
                               Reason = n.Field<int?>("ProcessStatusReason"),
                               Timestamp = Convert.ToBase64String((byte[])(ds.Tables[0].Rows[0]["Timestamp"])),
                               RunningHours = Convert.ToString(n["RunningHours"] == System.DBNull.Value ? null : n["RunningHours"]),
                               VendorServicecost = Convert.ToDecimal(n["VendorCost"] == System.DBNull.Value ? null : n["VendorCost"]),
                               PorteringNo = Convert.ToString(n["PorteringNo"] == System.DBNull.Value ? null : n["PorteringNo"]),
                               PorteringAssetNo = Convert.ToString(n["PorteringAssetNo"] == System.DBNull.Value ? null : n["PorteringAssetNo"]),
                               DownTimeHours = n.Field<decimal?>("DownTimeHours"),
                               ReScheduledDate = Convert.ToDateTime(n["RescheduleDate"] == System.DBNull.Value ? null : n["RescheduleDate"]),
                               CustomerFeedback = n.Field<int?>("CustomerFeedback"),
                               //  Base64StringSignature = Convert.ToString(n["WOSignature"] != DBNull.Value ? (Convert.ToBase64String((byte[])(n["WOSignature"]))) : null,

                               // PorteringNo = n.Field<string>("MaintenanceWorkNo"),
                               // PorteringAssetNo = n.Field<string>("MaintenanceWorkNo"),
                               AccessLevel = _UserSession.AccessLevel,
                               Base64StringSignature = Convert.ToString(n["WOSignature"] == System.DBNull.Value ? null : (Convert.ToBase64String((byte[])(n["WOSignature"])))),
                               //Base64StringSignature = Convert.ToString(n["WOSignature"] != DBNull.Value ? (Convert.ToBase64String((byte[])(n["WOSignature"]))) : null,
                           }).FirstOrDefault();

                    obj.CompletionInfoDets = (from n in ds.Tables[0].AsEnumerable()
                                              select new ScheduledWorkOrderCompletionInfoModel
                                              {
                                                  CompletionInfoDetId = n.Field<int>("CompletionInfoDetId"),
                                                  StaffMasterId = n.Field<int>("StaffMasterId"),
                                                  // EmployeeId = n.Field<string>("StaffEmployeeId"),
                                                  EmployeeName = n.Field<string>("StaffMasterIdValue"),
                                                  StandardTaskDetId = n.Field<int?>("StandardTaskDetId"),
                                                  TaskCode = n.Field<string>("TaskCode"),
                                                  TaskDescription = n.Field<string>("TaskDescription"),
                                                  StartDate = n.Field<DateTime>("UdtStartDateTime"),
                                                  EndDate = n.Field<DateTime?>("UdtEndDateTime"),
                                                  PPMHours = n.Field<decimal?>("RepairHours"),
                                                  PPMHoursTiming = n.Field<string>("RepairTiming"),
                                                  TotalRecords = Convert.ToInt32(n["TotalRecords"]),
                                                  TotalPages = Convert.ToInt32(n["TotalPageCalc"])
                                              }).ToList();

                    obj.CompletionInfoDets.ForEach((x) =>
                    {
                        x.PageIndex = pageindex;
                        x.FirstRecord = ((pageindex - 1) * pagesize) + 1;
                        x.LastRecord = ((pageindex - 1) * pagesize) + pagesize;
                    });
                    var length = obj.CompletionInfoDets.Count;
                    obj.StartDate = obj.CompletionInfoDets[length - 1].StartDate;
                    obj.EndDate = obj.CompletionInfoDets[length - 1].EndDate;
                }
                //if (obj.CompletionInfoId == 0)
                //{
                //    obj.CompletionInfoDets = null;
                //}
                Log4NetLogger.LogExit(_FileName, nameof(Get), Level.Info.ToString());
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

        public ScheduledWorkOrderModel GetPartReplacement(int Id, int pagesize, int pageindex)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
            try
            {
                var dbAccessDAL = new DBAccessDAL();
                var obj = new ScheduledWorkOrderModel();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pWorkOrderId", Id.ToString());
                parameters.Add("@pPageIndex", pageindex.ToString());
                parameters.Add("@pPageSize", pagesize.ToString());
                parameters.Add("@pUserId", Convert.ToString(_UserSession.UserId));
                DataSet ds = dbAccessDAL.GetDataSet("UspFM_EngMwoPartReplacementTxn_GetById", parameters, DataSetparameters);

                if (ds.Tables.Count != 0 && ds.Tables[0].Rows.Count > 0)
                {
                    obj = (from n in ds.Tables[0].AsEnumerable()
                           select new ScheduledWorkOrderModel
                           {
                               WorkOrderId = n.Field<int>("WorkOrderId"),
                               WorkOrderNo = n.Field<string>("MaintenanceWorkNo"),
                               PartWorkOrderDate = n.Field<DateTime>("MaintenanceWorkDateTime"),
                               TotalSparePartCost = n.Field<decimal>("TotalSparepartsCostSum"),
                               TotalLabourCost = n.Field<decimal?>("TotalLabourCostSum"),
                               TotalCost = n.Field<decimal>("TotalCostSum"),
                               TotalVendorCost = n.Field<decimal>("TotalVendorCostSum"),
                               ScheduleTotalLabourCost = n.Field<decimal>("TotalLabourCostCompinfo"),
                               ScheduleTotalCost = n.Field<decimal>("ScheduleTotalCost"),
                               WorkOrderStatusValue = n.Field<string>("WorkOrderStatusValue"),
                           }).FirstOrDefault();

                    obj.PartReplacementDets = (from n in ds.Tables[0].AsEnumerable()
                                               select new ScheduledWorkOrderPartReplacementModel
                                               {
                                                   PartReplacementId = n.Field<int>("PartReplacementId"),
                                                   SparePartStockRegisterId = n.Field<int>("SparePartStockRegisterId"),
                                                   StockUpdateDetId = n.Field<int>("StockUpdateDetId"),
                                                   PartNo = n.Field<string>("PartNo"),
                                                   PartDescription = n.Field<string>("PartDescription"),
                                                   EstimatedLifeSpan = n.Field<int?>("EstimatedLifeSpan"),
                                                   LifeSpanOptionId = n.Field<int?>("LifeSpanOptionId1"),
                                                   EstimatedLifeSpanOption = n.Field<string>("LifeSpanOptionIdValue"),
                                                   EstimatedLifeSpanDate = n.Field<DateTime?>("LifeSpanExpiryDate"),
                                                   ItemNo = n.Field<string>("ItemNo"),
                                                   ItemDescription = n.Field<string>("ItemDescription"),
                                                   StockType = n.Field<int?>("StockType"),
                                                   Quantity = n.Field<decimal>("Quantity"),
                                                   CostPerUnit = n.Field<decimal>("Cost"),
                                                   InvoiceNo = n.Field<string>("InvoiceNo"),
                                                   VendorName = n.Field<string>("VendorName"),
                                                   LabourCost = n.Field<decimal>("LabourCost"),
                                                   TotalCost = n.Field<decimal>("TotalCost"),
                                                   TotalRecords = Convert.ToInt32(n["TotalRecords"]),
                                                   TotalPages = Convert.ToInt32(n["TotalPageCalc"]),
                                                   AverageUsageHours = n.Field<decimal?>("SparePartRunningHours"),
                                                   PartReplacementCostInvolved = n.Field<int>("IsPartReplacedCost"),
                                                   PartReplacementCost = n.Field<decimal?>("PartReplacementCost"),
                                               }).ToList();

                    obj.PartReplacementDets.ForEach((x) =>
                    {
                        x.PageIndex = pageindex;
                        x.FirstRecord = ((pageindex - 1) * pagesize) + 1;
                        x.LastRecord = ((pageindex - 1) * pagesize) + pagesize;
                    });
                    if (obj.PartReplacementDets == null)
                        obj = null;
                }
                obj.UserRole = _UserSession.UserRoleName;
                Log4NetLogger.LogExit(_FileName, nameof(Get), Level.Info.ToString());
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

        public ScheduledWorkOrderModel GetPurchaseRequest(int Id)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
            try
            {
                var dbAccessDAL = new DBAccessDAL();
                var obj = new ScheduledWorkOrderModel();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pWorkOrderId", Id.ToString());
                // parameters.Add("@pUserId", Convert.ToString(_UserSession.UserId));
                DataSet ds = dbAccessDAL.GetDataSet("uspFM_EngSparePartPurchaseRequest_GetById", parameters, DataSetparameters);

                if (ds.Tables.Count != 0 && ds.Tables[0].Rows.Count > 0)
                {
                    obj.PurchaseRequestDets = (from n in ds.Tables[0].AsEnumerable()
                                               select new ScheduledWorkOrderPurchaseRequestPopUpDetModel
                                               {
                                                   PurchaseRequestId = n.Field<int>("SparePartsRequsetId"),
                                                   PurchaseSparePartStockRegisterId = n.Field<int>("SparePartsId"),
                                                   PurchasePartNo = n.Field<string>("PartNo"),
                                                   PurchasePartDescription = n.Field<string>("PartDescription"),
                                                   PurchaseItemCode = n.Field<string>("ItemCode"),
                                                   PurchaseItemDescription = n.Field<string>("ItemDescription"),
                                                   PurchaseQuantity = n.Field<int>("Quantity"),
                                                   WorkOrderNo = n.Field<string>("MaintenanceWorkNo"),

                                               }).ToList();

                    if (obj.PurchaseRequestDets == null)
                        obj = null;
                }
                //obj.UserRole = _UserSession.UserRoleName;
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

        public ScheduledWorkOrderModel GetPPMCheckList(int Id, int CheckListId)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
            try
            {
                var dbAccessDAL = new DBAccessDAL();
                var obj = new ScheduledWorkOrderModel();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pWorkOrderId", Id.ToString());
                parameters.Add("@pPPMCheckListId", CheckListId.ToString());
                DataSet ds = dbAccessDAL.GetDataSet("uspFM_WOEngAssetPPMCheckList_GetById", parameters, DataSetparameters);

                if (ds != null)
                {
                    if (ds.Tables[0] != null && ds.Tables[0].Rows.Count > 0)
                    {
                        obj.PPMCheckListId = Convert.ToInt32(ds.Tables[0].Rows[0]["PPMCheckListId"]);
                        obj.WOPPMCheckListId = Convert.ToInt32(ds.Tables[0].Rows[0]["WOPPMCheckListId"]);
                        obj.PPMCheckListAssetTypeCodeId = Convert.ToInt32(ds.Tables[0].Rows[0]["AssetTypeCodeId"]);
                        obj.PPMCheckListAssetTypeCode = Convert.ToString(ds.Tables[0].Rows[0]["AssetTypeCode"]);
                        obj.PPMCheckListAssetTypeDescription = Convert.ToString(ds.Tables[0].Rows[0]["AssetTypeCodeDesc"]);
                        obj.PPMCheckListTaskCode = Convert.ToString(ds.Tables[0].Rows[0]["TaskCode"]);
                        obj.PPMCheckListTaskCodeDesc = Convert.ToString(ds.Tables[0].Rows[0]["TaskDescription"]);
                        obj.PPMCheckListPPMChecklistNo = Convert.ToString(ds.Tables[0].Rows[0]["PPMChecklistNo"]);
                        obj.PPMCheckListManufacturerId = Convert.ToInt32(ds.Tables[0].Rows[0]["ManufacturerId"]);
                        obj.PPMCheckListManufacturer = Convert.ToString(ds.Tables[0].Rows[0]["Manufacturer"]);
                        obj.PPMCheckListModel = Convert.ToString(ds.Tables[0].Rows[0]["Model"]);
                        obj.PPMCheckListModelId = Convert.ToInt32(ds.Tables[0].Rows[0]["ModelId"]);
                        obj.PPMCheckListPPMFrequency = Convert.ToString(ds.Tables[0].Rows[0]["PPMFrequencyName"]);
                        obj.PPMCheckListPpmHours = Convert.ToDecimal(ds.Tables[0].Rows[0]["PpmHours"]);
                        obj.PPMCheckListSpecialPrecautions = Convert.ToString(ds.Tables[0].Rows[0]["SpecialPrecautions"]);
                        obj.PPMCheckListRemarks = Convert.ToString(ds.Tables[0].Rows[0]["Remarks"]);
                        obj.ServiceId = Convert.ToInt32(ds.Tables[0].Rows[0]["ServiceId"]);
                        obj.PPMCheckListTimestamp = Convert.ToBase64String((byte[])(ds.Tables[0].Rows[0]["Timestamp"]));
                    }

                    if (ds.Tables[1] != null && ds.Tables[1].Rows.Count > 0)
                    {

                        var Quantasks = (from n in ds.Tables[1].AsEnumerable()
                                         select new WOPPMCheckListQuantasksMstDetModel
                                         {
                                             WOPPMCheckListQNId = Convert.ToInt32(n["WOPPMCheckListQNId"]),
                                             PPMCheckListQNId = Convert.ToInt32(n["PPMCheckListQNId"]),
                                             QuantitativeTasks = Convert.ToString(n["QuantitativeTasks"]),
                                             UOM = Convert.ToString(n["UnitOfMeasurement"]),
                                             SetValues = Convert.ToString(n["SetValues"]),
                                             LimitTolerance = Convert.ToString(n["LimitTolerance"]),
                                             Value = Convert.ToString(n["Value"]),
                                             Remarks = Convert.ToString(n["Remarks"]),
                                             Status = Convert.ToInt32(n["Status"]),
                                             //Active = Convert.ToBoolean(n["Active"])
                                         }).ToList();

                        if (Quantasks != null && Quantasks.Count > 0)
                        {
                            obj.PPMCheckListQuantasksMstDets = Quantasks;

                        }
                        if (ds.Tables[2] != null && ds.Tables[2].Rows.Count > 0)
                        {

                            var gridList = (from n in ds.Tables[2].AsEnumerable()
                                            select new WOPPmChecklistCategoryDet
                                            {
                                                WOPPmCategoryDetId = Convert.ToInt32(n["WOCategoryId"]),
                                                PPmCategoryDetId = Convert.ToInt32(n["PPMCheckListCategoryId"]),
                                                PpmCategoryId = Convert.ToString(n["CategoryIdValue"]),
                                                SNo = Convert.ToInt32(n["Number"]),
                                                Description = Convert.ToString(n["Description"]),
                                                Remarks = Convert.ToString(n["Remarks"]),
                                                Status = Convert.ToInt32(n["Status"]),
                                                // Active = Convert.ToBoolean(n["Active"])
                                            }).ToList();

                            if (gridList != null && gridList.Count > 0)
                            {
                                obj.PPmChecklistCategoryDets = gridList;

                            }
                        }
                    }
                    if (obj.PPMCheckListId == 0)
                    {
                        obj = GetPPMCheckListDefault(CheckListId);
                    }
                }
                obj.UserRole = _UserSession.UserRoleName;
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

        public ScheduledWorkOrderModel GetPPMCheckListDefault(int CheckListId)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
            try
            {
                var dbAccessDAL = new DBAccessDAL();
                var obj = new ScheduledWorkOrderModel();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pPPMCheckListId", CheckListId.ToString());
                DataSet ds = dbAccessDAL.GetDataSet("uspFM_EngAssetPPMCheckList_GetById", parameters, DataSetparameters);
                if (ds != null)
                {
                    if (ds.Tables[0] != null && ds.Tables[0].Rows.Count > 0)
                    {
                        obj.PPMCheckListId = Convert.ToInt32(ds.Tables[0].Rows[0]["PPMCheckListId"]);
                        obj.PPMCheckListAssetTypeCodeId = Convert.ToInt32(ds.Tables[0].Rows[0]["AssetTypeCodeId"]);
                        obj.PPMCheckListAssetTypeCode = Convert.ToString(ds.Tables[0].Rows[0]["AssetTypeCode"]);
                        obj.PPMCheckListAssetTypeDescription = Convert.ToString(ds.Tables[0].Rows[0]["AssetTypeCodeDesc"]);
                        obj.PPMCheckListTaskCode = Convert.ToString(ds.Tables[0].Rows[0]["TaskCode"]);
                        obj.PPMCheckListTaskCodeDesc = Convert.ToString(ds.Tables[0].Rows[0]["TaskDescription"]);
                        obj.PPMCheckListPPMChecklistNo = Convert.ToString(ds.Tables[0].Rows[0]["PPMChecklistNo"]);
                        obj.PPMCheckListManufacturerId = Convert.ToInt32(ds.Tables[0].Rows[0]["ManufacturerId"]);
                        obj.PPMCheckListManufacturer = Convert.ToString(ds.Tables[0].Rows[0]["Manufacturer"]);
                        obj.PPMCheckListModel = Convert.ToString(ds.Tables[0].Rows[0]["Model"]);
                        obj.PPMCheckListModelId = Convert.ToInt32(ds.Tables[0].Rows[0]["ModelId"]);
                        obj.PPMCheckListPPMFrequency = Convert.ToString(ds.Tables[0].Rows[0]["PPMFrequencyName"]);
                        obj.PPMCheckListPpmHours = Convert.ToDecimal(ds.Tables[0].Rows[0]["PpmHours"]);
                        obj.PPMCheckListSpecialPrecautions = Convert.ToString(ds.Tables[0].Rows[0]["SpecialPrecautions"]);
                        obj.PPMCheckListRemarks = Convert.ToString(ds.Tables[0].Rows[0]["Remarks"]);
                        obj.ServiceId = Convert.ToInt32(ds.Tables[0].Rows[0]["ServiceId"]);
                        obj.PPMCheckListTimestamp = Convert.ToBase64String((byte[])(ds.Tables[0].Rows[0]["Timestamp"]));
                    }

                    if (ds.Tables[1] != null && ds.Tables[1].Rows.Count > 0)
                    {

                        var Quantasks = (from n in ds.Tables[1].AsEnumerable()
                                         select new WOPPMCheckListQuantasksMstDetModel
                                         {
                                             PPMCheckListQNId = Convert.ToInt32(n["PPMCheckListQNId"]),
                                             QuantitativeTasks = Convert.ToString(n["QuantitativeTasks"]),
                                             UOM = Convert.ToString(n["UnitOfMeasurement"]),
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
                                            select new WOPPmChecklistCategoryDet
                                            {
                                                PPmCategoryDetId = Convert.ToInt32(n["CategoryId"]),
                                                PpmCategoryId = Convert.ToString(n["CategoryIdValue"]),
                                                SNo = Convert.ToInt32(n["Number"]),
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

        public ScheduledWorkOrderModel GetTransfer(int Id, int pagesize, int pageindex)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
            try
            {
                var dbAccessDAL = new DBAccessDAL();
                var obj = new ScheduledWorkOrderModel();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pWorkOrderId", Id.ToString());
                parameters.Add("@pPageIndex", pageindex.ToString());
                parameters.Add("@pPageSize", pagesize.ToString());
                //parameters.Add("@pUserId", Convert.ToString(_UserSession.UserId));
                DataSet ds = dbAccessDAL.GetDataSet("UspFM_EngMwoTransferTxn_GetById", parameters, DataSetparameters);

                if (ds.Tables.Count != 0 && ds.Tables[0].Rows.Count > 0)
                {
                    obj = (from n in ds.Tables[0].AsEnumerable()
                           select new ScheduledWorkOrderModel
                           {
                               WOTransferId = n.Field<int>("WOTransferId"),
                               TransferAssetNo = n.Field<string>("AssetNo"),
                               TransferAssetDescription = n.Field<string>("AssetDescription"),
                               TransferTypeCode = n.Field<string>("AssetTypecode"),
                               TransferService = n.Field<string>("ServiceKeyValue"),
                               TransferAssignedPerson = n.Field<string>("AssignedStaffName"),
                               TransferAssignedPersonId = n.Field<int>("AssignedUserId"),
                               WorkOrderId = n.Field<int>("WorkOrderId"),
                               TransferReason = n.Field<int>("TransferReasonLovId"),
                               Timestamp = Convert.ToBase64String((byte[])(ds.Tables[0].Rows[0]["Timestamp"])),

                               WorkOrderStatus = Convert.ToInt32(ds.Tables[0].Rows[0]["WorkOrderStatus"]),
                               WorkOrderStatusValue = Convert.ToString(ds.Tables[0].Rows[0]["WorkOrderStatusValue"])
                           }).FirstOrDefault();
                    if (obj.TransferReason == 0)
                        obj.TransferReason = null;
                    obj.TransferDets = (from n in ds.Tables[0].AsEnumerable()
                                        select new ScheduledWorkOrderTransferModel
                                        {
                                            TransferWorkOrderNo = n.Field<string>("MaintenanceWorkNo"),
                                            TransferWorkOrderDate = n.Field<DateTime>("MaintenanceWorkDateTime"),
                                            TransferWorkOrderCategory = n.Field<string>("WorkOrderCategory"),
                                            TransferGridAssignedPerson = n.Field<string>("AssignedStaffName"),
                                            TransferAssignedDate = n.Field<DateTime>("AssignedDate"),
                                            TotalRecords = Convert.ToInt32(n["TotalRecords"]),
                                            TotalPages = Convert.ToInt32(n["TotalPageCalc"])
                                        }).ToList();

                    obj.TransferDets.ForEach((x) =>
                    {
                        x.PageIndex = pageindex;
                        x.FirstRecord = ((pageindex - 1) * pagesize) + 1;
                        x.LastRecord = ((pageindex - 1) * pagesize) + pagesize;
                    });
                    if (obj.WOTransferId == 0)
                        obj = null;
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

        //public ScheduledWorkOrderModel GetReschedule(int Id, int pagesize, int pageindex)
        //{
        //    Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
        //    try
        //    {
        //        var dbAccessDAL = new DBAccessDAL();
        //        var obj = new ScheduledWorkOrderModel();
        //        var DataSetparameters = new Dictionary<string, DataTable>();
        //        var parameters = new Dictionary<string, string>();
        //        parameters.Add("@pWorkOrderId", Id.ToString());
        //        //parameters.Add("@pPageIndex", pageindex.ToString());
        //        //parameters.Add("@pPageSize", pagesize.ToString());
        //        parameters.Add("@pUserId", Convert.ToString(_UserSession.UserId));
        //        DataSet ds = dbAccessDAL.GetDataSet("UspFM_EngMwoReschedulingTxn_GetById", parameters, DataSetparameters);

        //        if (ds.Tables.Count != 0 && ds.Tables[0].Rows.Count > 0)
        //        {
        //            obj = (from n in ds.Tables[0].AsEnumerable()
        //                   select new ScheduledWorkOrderModel
        //                   {
        //                       RescheduleWorkOrderNo = n.Field<string>("MaintenanceWorkNo"),
        //                       RescheduleWorkOrderDate = n.Field<DateTime>("MaintenanceWorkDateTime"),
        //                       RescheduleAssetNo = n.Field<string>("AssetNo"),
        //                       RescheduleTargetDate = n.Field<DateTime>("TargetDateTime"),


        //                   }).FirstOrDefault();

        //            obj.RescheduleDets = (from n in ds.Tables[0].AsEnumerable()
        //                                  select new ScheduledWorkOrderRescheduleModel
        //                                  {
        //                                      RescheduleDate = n.Field<DateTime>("RescheduleDate"),
        //                                      //RescheduleApprovedby = n.Field<string>("RescheduleApprovedbyValue"),
        //                                      //RescheduleReason = n.Field<string>("Remarks"),
        //                                      RescheduleReason = n.Field<string>("ReasonName"),
        //                                      RescheduleImpactSchedulePlanner = n.Field<string>("ImpactSchedulePlanner"),
        //                                      //TotalRecords = Convert.ToInt32(n["TotalRecords"]),
        //                                      //TotalPages = Convert.ToInt32(n["TotalPageCalc"])

        //                                  }).ToList();

        //            obj.RescheduleDets.ForEach((x) =>
        //            {
        //                x.PageIndex = pageindex;
        //                x.FirstRecord = ((pageindex - 1) * pagesize) + 1;
        //                x.LastRecord = ((pageindex - 1) * pagesize) + pagesize;
        //            });

        //        }
        //        Log4NetLogger.LogExit(_FileName, nameof(Get), Level.Info.ToString());
        //        return obj;
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

        public ScheduledWorkOrderModel GetReschedule(int Id, int pagesize, int pageindex)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
            try
            {
                var dbAccessDAL = new DBAccessDAL();
                var obj = new ScheduledWorkOrderModel();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pWorkOrderId", Id.ToString());
                //parameters.Add("@pPageIndex", pageindex.ToString());
                //parameters.Add("@pPageSize", pagesize.ToString());
                parameters.Add("@pUserId", Convert.ToString(_UserSession.UserId));
                DataSet ds = dbAccessDAL.GetDataSet("UspFM_EngMwoReschedulingTxn_GetById", parameters, DataSetparameters);

                if (ds.Tables.Count != 0 && ds.Tables[0].Rows.Count > 0)
                {
                    obj = (from n in ds.Tables[0].AsEnumerable()
                           select new ScheduledWorkOrderModel
                           {
                               RescheduleWorkOrderNo = n.Field<string>("MaintenanceWorkNo"),
                               RescheduleWorkOrderDate = n.Field<DateTime>("MaintenanceWorkDateTime"),
                               RescheduleAssetNo = n.Field<string>("AssetNo"),
                               RescheduleTargetDate = n.Field<DateTime>("TargetDateTime"),

                           }).FirstOrDefault();

                    obj.RescheduleDets = (from n in ds.Tables[0].AsEnumerable()
                                          select new ScheduledWorkOrderRescheduleModel
                                          {
                                              RescheduleDate = n.Field<DateTime>("RescheduleDate"),
                                              //RescheduleApprovedby = n.Field<string>("RescheduleApprovedbyValue"),
                                              RescheduleReason = n.Field<string>("ReasonName"),
                                              //RescheduleRemarks= n.Field<string>("RescheduleRemarks"),
                                              RescheduleImpactSchedulePlanner = n.Field<string>("ImpactSchedulePlanner"),
                                              //TotalRecords = Convert.ToInt32(n["TotalRecords"]),
                                              //TotalPages = Convert.ToInt32(n["TotalPageCalc"])
                                          }).ToList();

                    obj.RescheduleDets.ForEach((x) =>
                    {
                        x.PageIndex = pageindex;
                        x.FirstRecord = ((pageindex - 1) * pagesize) + 1;
                        x.LastRecord = ((pageindex - 1) * pagesize) + pagesize;
                    });

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

        public ScheduledWorkOrderModel GetHistory(int Id, int pagesize, int pageindex)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
            try
            {
                var dbAccessDAL = new DBAccessDAL();
                var obj = new ScheduledWorkOrderModel();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pWorkOrderId", Id.ToString());
                parameters.Add("@pUserId", Convert.ToString(_UserSession.UserId));
                //parameters.Add("@pPageIndex", pageindex.ToString());
                //parameters.Add("@pPageSize", pagesize.ToString());

                DataSet ds = dbAccessDAL.GetDataSet("UspFM_EngMaintenanceWorkOrderStatusHistory_GetById", parameters, DataSetparameters);

                if (ds.Tables.Count != 0 && ds.Tables[0].Rows.Count > 0)
                {
                    obj = (from n in ds.Tables[0].AsEnumerable()
                           select new ScheduledWorkOrderModel
                           {
                               HistoryWorkOrderNo = n.Field<string>("MaintenanceWorkNo"),
                               HistoryWorkOrderDate = n.Field<DateTime>("MaintenanceWorkDateTime"),
                               HistoryAssetNo = n.Field<string>("AssetNo"),

                           }).FirstOrDefault();

                    obj.HistoryDets = (from n in ds.Tables[0].AsEnumerable()
                                       select new ScheduledWorkOrderHistoryModel
                                       {
                                           HistoryDate = n.Field<DateTime>("CreatedDate"),
                                           HistoryAssignedPerson = n.Field<string>("ModifiedStaffName"),
                                           HistoryStatus = n.Field<string>("WorkOrderStatusValue"),
                                           HistoryAssignedPersonDesig = n.Field<string>("ModifiedStaffDesig") == null ? "" : n.Field<string>("ModifiedStaffDesig")
                                           //TotalRecords = Convert.ToInt32(n["TotalRecords"]),
                                           //TotalPages = Convert.ToInt32(n["TotalPageCalc"])
                                       }).ToList();

                    //obj.RescheduleDets.ForEach((x) => {
                    //    x.PageIndex = pageindex;
                    //    x.FirstRecord = ((pageindex - 1) * pagesize) + 1;
                    //    x.LastRecord = ((pageindex - 1) * pagesize) + pagesize;
                    //});

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

        public ScheduledWorkOrderModel FeedbackPopUp(int Id)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
            try
            {
                var dbAccessDAL = new DBAccessDAL();
                var obj = new ScheduledWorkOrderModel();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pAssesmentId", Id.ToString());
                // parameters.Add("@pFacilityId", _UserSession.FacilityId.ToString());
                DataSet ds = dbAccessDAL.GetDataSet("uspFM_EngMwoAssesmentTxnHistory_GetById ", parameters, DataSetparameters);

                if (ds.Tables.Count != 0 && ds.Tables[0].Rows.Count > 0)
                {
                    obj.FeedbackPopUpDets = (from n in ds.Tables[0].AsEnumerable()
                                             select new ScheduledWorkOrderFeedbackPopUpDetModel
                                             {
                                                 AssessmentHistoryId = Convert.ToInt32(n["AssesmentHistoryId"]),
                                                 AssessmentId = Convert.ToInt32(n["AssesmentId"]),
                                                 // SNo = Convert.ToInt32(n["SNo"]),
                                                 Remarks = Convert.ToString(n["FeedBack"] == DBNull.Value ? "" : (Convert.ToString(n["FeedBack"]))),
                                                 DoneBy = Convert.ToString(n["DoneBy"] == DBNull.Value ? "" : (Convert.ToString(n["DoneBy"]))),
                                                 DoneByDesignation = Convert.ToString(n["DoneByDesignation"] == DBNull.Value ? "" : (Convert.ToString(n["DoneByDesignation"]))),
                                                 Date = n.Field<DateTime?>("DoneDate"),
                                             }).ToList();

                    //obj.PartReplacementDets.ForEach((x) => {
                    //    x.PageIndex = pageindex;
                    //    x.FirstRecord = ((pageindex - 1) * pagesize) + 1;
                    //    x.LastRecord = ((pageindex - 1) * pagesize) + pagesize;
                    //});

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

        public ScheduledWorkOrderModel PartReplacementPopUp(int Id)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
            try
            {
                var dbAccessDAL = new DBAccessDAL();
                var obj = new ScheduledWorkOrderModel();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pSparePartsId", Id.ToString());
                // parameters.Add("@pFacilityId", _UserSession.FacilityId.ToString());
                DataSet ds = dbAccessDAL.GetDataSet("uspFM_EngSparesStockUpdatePopup_Fetch ", parameters, DataSetparameters);

                if (ds.Tables.Count != 0 && ds.Tables[0].Rows.Count > 0)
                {
                    obj.PartReplacementPopUpDets = (from n in ds.Tables[0].AsEnumerable()
                                                    select new ScheduledWorkOrderPartReplacementPopUpModel
                                                    {
                                                        SparePartStockRegisterId = n.Field<int>("SparePartsId"),
                                                        StockUpdateDetId = n.Field<int>("StockUpdateDetId"),
                                                        PopUpPartNo = n.Field<string>("PartNo"),
                                                        PopUpPartDescription = n.Field<string>("PartDescription"),
                                                        PopUpQuantityAvailable = n.Field<decimal>("Quantity"),
                                                        PopUpCostPerUnit = n.Field<decimal>("Cost"),
                                                        PopUpInvoiceNo = n.Field<string>("InvoiceNo"),
                                                        PopUpVendorName = n.Field<string>("VendorName"),
                                                        //PopUpSelected= n.Field<bool>("IsReferred"),
                                                    }).ToList();

                    //obj.PartReplacementDets.ForEach((x) => {
                    //    x.PageIndex = pageindex;
                    //    x.FirstRecord = ((pageindex - 1) * pagesize) + 1;
                    //    x.LastRecord = ((pageindex - 1) * pagesize) + pagesize;
                    //});

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

        public ScheduledWorkOrderModel Popup(int Id, int pagesize, int pageindex)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
            try
            {
                var dbAccessDAL = new DBAccessDAL();

                var obj = new ScheduledWorkOrderModel();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pUserAreaId", Id.ToString());
                parameters.Add("@pPageIndex", pageindex.ToString());
                parameters.Add("@pPageSize", pagesize.ToString());
                DataSet ds = dbAccessDAL.GetDataSet("uspFM_EngPlannerTxnAssets_GetByUserAreaId", parameters, DataSetparameters);
                if (ds != null)
                {
                    if (ds.Tables[0] != null && ds.Tables[0].Rows.Count > 0)
                    {

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

        public ScheduledWorkOrderModel Summary(int Service, int WorkGroup, int Year, int TOP, int pagesize, int pageindex)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
            try
            {
                var dbAccessDAL = new DBAccessDAL();

                var obj = new ScheduledWorkOrderModel();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                if (TOP == 34)
                {
                    parameters.Add("@pServiceId", Service.ToString());
                    parameters.Add("@pWorkGroupid", WorkGroup.ToString());
                    parameters.Add("@pFacilityId", _UserSession.FacilityId.ToString());
                    parameters.Add("@pYear", Year.ToString());
                    // parameters.Add("@pTypeOfPlanner", TOP.ToString());
                    parameters.Add("@pPageIndex", pageindex.ToString());
                    parameters.Add("@pPageSize", pagesize.ToString());
                    DataSet ds = dbAccessDAL.GetDataSet("uspFM_EngPlanner_PPM_Summary", parameters, DataSetparameters);
                    if (ds != null)
                    {
                        if (ds.Tables[0] != null && ds.Tables[0].Rows.Count > 0)
                        {

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

        public ScheduledWorkOrderModel CalculateResponse(ScheduledWorkOrderModel model)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());
            try
            {
                var dbAccessDAL = new DBAccessDAL();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();

                parameters.Add("@pWorkOrderId", Convert.ToString(model.WorkOrderId));
                parameters.Add("@pResponseDateTime", Convert.ToString(model.AssessmentResponsedate));

                DataTable dt = dbAccessDAL.GetDataTable("uspFM_EngMwoAssesment_ResponseTime_Get", parameters, DataSetparameters);
                if (dt != null)
                {
                    foreach (DataRow row in dt.Rows)
                    {
                        model.AssessmentResponseDuration = Convert.ToString(row["ResponseDurationInMinute"]);
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

        public ScheduledWorkOrderModel Save(ScheduledWorkOrderModel model)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());
            try
            {
                if (model.WorkOrderStatus == 143)
                {
                    model.WorkOrderStatus = 192;
                }
                else
                {
                }
                var AssignneId = model.EngineerId;
                var TempWorkOrderId = model.WorkOrderId;
                var TempWorkOrderType = model.WorkOrderType;
                var dbAccessDAL = new DBAccessDAL();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                if (model.EngineerId == 0)
                    model.EngineerId = null;
                if (model.RequestorId == 0)
                    model.RequestorId = null;
                if (model.WorkOrderType == 188)
                    model.TargetDate = null;
                if (model.AssetRegisterId == 0)
                    model.AssetRegisterId = null;

                parameters.Add("@pWorkOrderId", Convert.ToString(model.WorkOrderId));
                parameters.Add("@pCustomerId", Convert.ToString(_UserSession.CustomerId));
                parameters.Add("@pFacilityId", Convert.ToString(_UserSession.FacilityId));
                parameters.Add("@pServiceId", Convert.ToString(2));
                parameters.Add("@pAssetId", Convert.ToString(model.AssetRegisterId));
                //parameters.Add("@pAssetTypeCodeId", Convert.ToString(model.AssetTypeCodeId));
                parameters.Add("@pMaintenanceWorkNo", Convert.ToString(model.WorkOrderNo));
                parameters.Add("@pMaintenanceDetails", Convert.ToString(model.MaintenanceDetails));
                parameters.Add("@pMaintenanceWorkCategory", Convert.ToString(model.WorkOrderType));
                parameters.Add("@pMaintenanceWorkType", Convert.ToString(model.MaintenanceType));
                parameters.Add("@pTypeOfWorkOrder", Convert.ToString(model.MaintenanceType));
                parameters.Add("@pQRCode", null);
                //parameters.Add("@pMaintenanceWorkDateTime", Convert.ToString(model.PartWorkOrderDate));
                parameters.Add("@pMaintenanceWorkDateTime", Convert.ToString(model.PartWorkOrderDate == null || model.PartWorkOrderDate == DateTime.MinValue ? null : ((DateTime)model.PartWorkOrderDate).ToString("MM-dd-yyy HH:mm")));
                if (model.TargetDate != null)
                {
                    parameters.Add("@pTargetDateTime", model.TargetDate.Value.ToString("yyyy-MM-dd hh:mm"));

                }
                else
                {
                    parameters.Add("@pTargetDateTime", null);

                }
                parameters.Add("@pEngineerStaffId", Convert.ToString(model.EngineerId));
                parameters.Add("@pRequestorStaffId", Convert.ToString(model.RequestorId));
                parameters.Add("@pWorkOrderPriority", Convert.ToString(model.WorkOrderPriority));
                parameters.Add("@pImage1FMDocumentId", null);
                parameters.Add("@pImage2FMDocumentId", null);
                parameters.Add("@pImage3FMDocumentId", null);
                //parameters.Add("@pPlannerId	", null);
                parameters.Add("@pWorkGroupId", null);
                parameters.Add("@pWorkOrderStatus", Convert.ToString(model.WorkOrderStatus));
                parameters.Add("@pPlannerHistoryId", null);
                parameters.Add("@pRemarks", null);
                parameters.Add("@pBreakDownRequestId", null);
                parameters.Add("@pWOAssignmentId", null);
                parameters.Add("@pUserAreaId", null);
                parameters.Add("@pUserLocationId", null);
                parameters.Add("@pStandardTaskDetId", null);
                parameters.Add("@pUserId", Convert.ToString(_UserSession.UserId));
                parameters.Add("@pTimestamp", model.Timestamp);
                parameters.Add("@pWorkOrderCategoryType", Convert.ToString(model.WorkOrderCategory));
                /// Added work group for only fems thats why written if and else condition////
                if (model.WorkGroupVaule != 0)
                {
                    parameters.Add("@pWorkGroupType", Convert.ToString(model.WorkGroupVaule));
                }
                else
                {

                }
                //parameters.Add("@pWOImage", model.Base64StringImage);
                //parameters.Add("@pWOVideo", model.Base64StringVideo);

                DataTable dt = dbAccessDAL.GetDataTable("uspFM_EngMaintenanceWorkOrderTxn_Save", parameters, DataSetparameters);
                if (dt != null)
                {
                    foreach (DataRow row in dt.Rows)
                    {
                        model.WorkOrderId = Convert.ToInt32(row["WorkOrderId"]);
                        model.Timestamp = Convert.ToBase64String((byte[])(row["Timestamp"]));
                        model.HiddenId = Convert.ToString(row["GuId"]);
                        model.WorkOrderNo = Convert.ToString(row["MaintenanceWorkNo"]);
                    }
                    model.EngineerId = AssignneId;
                    if (model.EngineerId > 0)
                    {
                        SaveWORequestSendMail(model);
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
                throw ex;
            }
        }

        private void SaveWORequestSendMail(ScheduledWorkOrderModel model)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(SaveWORequestSendMail), Level.Info.ToString());
            try
            {
                string emailTemplateId = string.Empty;
                string subject = string.Empty;
                string subjectVars = string.Empty;
                string templateVars = string.Empty;


                emailTemplateId = "17";
                var tempid = Convert.ToInt32(emailTemplateId);
                model.TemplateId = tempid;

                var obj = Get(model.WorkOrderId);
                if (obj != null)
                {
                    templateVars = string.Join(",", obj.WorkOrderNo);
                }

                var GetObj = GetMail(obj);
                string email = GetObj.Email;

                var DataSetparameters = new Dictionary<string, DataTable>();
                DataTable TypecodeDt = new DataTable();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pEmailTemplateId", Convert.ToString(emailTemplateId));
                parameters.Add("@pToEmailIds", email);
                parameters.Add("@pSubject", Convert.ToString(subject));
                parameters.Add("@pPriority", Convert.ToString(1));
                parameters.Add("@pSendAsHtml", Convert.ToString(1));
                parameters.Add("@pFacilityId", Convert.ToString(_UserSession.FacilityId));

                parameters.Add("@pSubjectVars", Convert.ToString(subjectVars));
                parameters.Add("@pTemplateVars", Convert.ToString(templateVars));

                var dbAccessDAL = new DBAccessDAL();
                DataTable dt = dbAccessDAL.GetDataTable("uspFM_EmailNotify_Save", parameters, DataSetparameters);
                if (dt != null)
                {
                    foreach (DataRow rows in dt.Rows)
                    {
                    }
                }
                SaveWORequestNotification(model);
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

        public ScheduledWorkOrderModel SaveWORequestNotification(ScheduledWorkOrderModel ent)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(SaveWORequestNotification), Level.Info.ToString());
            ScheduledWorkOrderModel griddata = new ScheduledWorkOrderModel();
            var dbAccessDAL = new DBAccessDAL();
            var parameters = new Dictionary<string, string>();
            var DataSetparameters = new Dictionary<string, DataTable>();
            var TempWorkOrderType = ent.WorkOrderType;
            var notalert = string.Empty;
            var hyplink = string.Empty;

            if (TempWorkOrderType == 187)
            {
                notalert = ent.WorkOrderNo + " " + "Scheduled Work Order has been generated";
                hyplink = "/bems/scheduledworkorder?id=" + ent.WorkOrderId;

            }
            else if (TempWorkOrderType == 188)
            {
                notalert = ent.WorkOrderNo + " " + "UnScheduled Work Order has been generated";
                hyplink = "/bems/unscheduledworkorder?id=" + ent.WorkOrderId;
            }

            parameters.Add("@pNotificationId", Convert.ToString(ent.NotificationId));
            parameters.Add("@pCustomerId", Convert.ToString(_UserSession.CustomerId));
            parameters.Add("@pFacilityId", Convert.ToString(_UserSession.FacilityId));
            parameters.Add("@pUserId", Convert.ToString(ent.EngineerId));
            parameters.Add("@pNotificationAlerts", Convert.ToString(notalert));
            parameters.Add("@pRemarks", Convert.ToString(""));
            parameters.Add("@pHyperLink", Convert.ToString(hyplink));
            parameters.Add("@pIsNew", Convert.ToString(1));
            parameters.Add("@pNotificationDateTime", Convert.ToString(null));
            parameters.Add("@pEmailTempId", Convert.ToString(ent.TemplateId));

            parameters.Add("@pmScreenName", Convert.ToString("EngMaintenanceWorkOrderTxn"));
            //parameters.Add("@pMGuid", Convert.ToString(ent.WorkOrderNo));
            //if (TempWorkOrderType == 187)
            //{
            //    parameters.Add("@pmScreenName", Convert.ToString("Scheduled Work Order"));
            //}
            //else if (TempWorkOrderType == 188)
            //{
            //    parameters.Add("@pmScreenName", Convert.ToString("UnScheduled Work Order"));
            //}
            parameters.Add("@pMGuid", Convert.ToString(ent.WorkOrderNo));

            DataTable ds = dbAccessDAL.GetDataTable("uspFM_WebNotificationSingle_Save", parameters, DataSetparameters);
            if (ds != null)
            {
                foreach (DataRow row in ds.Rows)
                {

                }
            }
            return ent;
        }

        public ScheduledWorkOrderModel GetMail(ScheduledWorkOrderModel model)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(GetMail), Level.Info.ToString());
            try
            {
                var dbAccessDAL = new DBAccessDAL();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();

                parameters.Add("@pUserRegistrationId", Convert.ToString(model.WorkOrderAssigneeId));

                DataTable dt = dbAccessDAL.MASTERGetDataTable("uspFM_UMUserRegistration_GetEmailId", parameters, DataSetparameters);
                if (dt != null)
                {
                    foreach (DataRow row in dt.Rows)
                    {
                        model.Email = Convert.ToString(row["Email"]);
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
                throw ex;
            }
        }

        public string GetMailPurcahsereq(int id)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());
            var Email = "";
            try
            {
                var dbAccessDAL = new DBAccessDAL();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();

                parameters.Add("@pUserRegistrationId", Convert.ToString(id));

                DataTable dt = dbAccessDAL.GetDataTable("uspFM_UMUserRegistration_GetEmailId", parameters, DataSetparameters);
                if (dt != null)
                {
                    foreach (DataRow row in dt.Rows)
                    {
                        Email = Convert.ToString(row["Email"]);
                    }

                }
                Log4NetLogger.LogExit(_FileName, nameof(Save), Level.Info.ToString());
                return Email;
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

        public ScheduledWorkOrderModel SaveReschedule(ScheduledWorkOrderModel model)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());
                RescheduleWOViewModel tempobj = new RescheduleWOViewModel();
                tempobj = GetTempReschedule(model.WorkOrderId);

                foreach (var i in tempobj.RescheduleWOListData)
                {
                    i.NewStaffMasterId = model.hdnRescheduleById;
                    i.RescheduleDate = model.RescheduleDate;
                }

                var dbAccessDAL = new DBAccessDAL();
                var parameters = new Dictionary<string, string>();

                //parameters.Add("@pFacilityId", Convert.ToString(_UserSession.FacilityId));

                var DataSetparameters = new Dictionary<string, DataTable>();
                DataTable dt = new DataTable();
                dt.Columns.Add("WorkOrderId", typeof(int));
                dt.Columns.Add("AssetId", typeof(int));
                dt.Columns.Add("AssignedUserId", typeof(int));
                dt.Columns.Add("RescheduleDate", typeof(DateTime));

                dt.Columns.Add("CustomerId", typeof(int));
                dt.Columns.Add("FacilityId", typeof(int));
                dt.Columns.Add("UserId", typeof(int));
                dt.Columns.Add("Remarks", typeof(string));

                foreach (var i in tempobj.RescheduleWOListData)
                {
                    dt.Rows.Add(i.WorkOrderId, i.AssetId, i.NewStaffMasterId, i.RescheduleDate, _UserSession.CustomerId, _UserSession.FacilityId, _UserSession.UserId, i.Reason);
                }

                DataSetparameters.Add("@pRescheduling", dt);
                DataTable dt1 = dbAccessDAL.GetDataTable("uspFM_Rescheduling_Save", parameters, DataSetparameters);
                if (dt1 != null)
                {
                    foreach (DataRow row in dt1.Rows)
                    {
                        //EODCaptur.CaptureId = Convert.ToInt32(row["CaptureId"]);
                        //EODCaptur.Timestamp = Convert.ToBase64String((byte[])(row["Timestamp"]));
                        //ErrorMessage = Convert.ToString(row["ErrorMessage"]);
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

        public RescheduleWOViewModel GetTempReschedule(int RescheduleWOId)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
            try
            {
                var dbAccessDAL = new DBAccessDAL();
                RescheduleWOViewModel entity = new RescheduleWOViewModel();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pWorkOrderId", RescheduleWOId.ToString());
                DataSet ds = dbAccessDAL.GetDataSet("uspFM_Rescheduling_GetById", parameters, DataSetparameters);
                if (ds != null)
                {
                    if (ds.Tables[0] != null && ds.Tables[0].Rows.Count > 0)
                    {
                        entity.WorkOrderId = Convert.ToInt32(ds.Tables[0].Rows[0]["WorkOrderId"]);
                        entity.UserAreaName = Convert.ToString(ds.Tables[0].Rows[0]["UserAreaName"]);
                        entity.UserLocationName = Convert.ToString(ds.Tables[0].Rows[0]["UserLocationName"]);
                        entity.PlannerId = Convert.ToInt32(ds.Tables[0].Rows[0]["TypeOfPlanner"]);
                        entity.StaffMasterId = Convert.ToInt32(ds.Tables[0].Rows[0]["AssignedUserId"]);
                        entity.StaffName = Convert.ToString(ds.Tables[0].Rows[0]["Assignee"]);
                        entity.Reason = Convert.ToString(ds.Tables[0].Rows[0]["Reason"]);
                    }

                    var griddata = (from n in ds.Tables[1].AsEnumerable()
                                    select new RescheduleWOListData
                                    {
                                        WorkOrderId = Convert.ToInt32(n["WorkOrderId"]),
                                        AssetId = Convert.ToInt32(n["AssetId"]),
                                        AssetNo = Convert.ToString(n["AssetNo"]),
                                        WorkOrderNo = Convert.ToString(n["MaintenanceWorkNo"]),
                                        scheduleDate = n.Field<DateTime?>("ScheduledDate"),
                                        RescheduleDate = n.Field<DateTime?>("ReScheduledDate"),
                                    }).ToList();

                    if (griddata != null && griddata.Count > 0)
                    {
                        entity.RescheduleWOListData = griddata;
                    }
                }
                Log4NetLogger.LogExit(_FileName, nameof(Get), Level.Info.ToString());
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

        public ScheduledWorkOrderModel SaveAssessment(ScheduledWorkOrderModel model)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());
            try
            {
                var dbAccessDAL = new DBAccessDAL();
                var WOType = model.WorkOrderType;
                var AssigneeId = model.EngineerId;
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                //if (model.Timestamp == null)
                //  model.Timestamp = "AAAAAAABNKc = ";
                parameters.Add("@pAssesmentId", Convert.ToString(model.AssessmentId));
                parameters.Add("@pCustomerId", Convert.ToString(_UserSession.CustomerId));
                parameters.Add("@pFacilityId", Convert.ToString(_UserSession.FacilityId));
                parameters.Add("@pServiceId", Convert.ToString(2));
                parameters.Add("@pWorkOrderId", Convert.ToString(model.WorkOrderId));
                parameters.Add("@pStaffMasterId", null);
                parameters.Add("@pJustification", Convert.ToString(model.AssessmentFeedBack));
                //parameters.Add("@pResponseDateTime", model.AssessmentResponsedate.ToString("yyyy-MM-dd hh:mm"));
                parameters.Add("@pResponseDateTime", Convert.ToString(model.AssessmentResponsedate == null || model.AssessmentResponsedate == DateTime.MinValue ? null : model.AssessmentResponsedate.ToString("MM-dd-yyy HH:mm")));
                parameters.Add("@pResponseDateTimeUTC", model.AssessmentResponsedate.ToString("MM-dd-yyy HH:mm"));
                parameters.Add("@pResponseDuration", Convert.ToString(model.AssessmentResponseDuration));
                parameters.Add("@pAssetRealtimeStatus", Convert.ToString(model.RealTimeStatus));
                //  parameters.Add("@pTargetDateTime", model.AssessmentTargetDate.ToString("yyyy-MM-dd hh:mm"));
                parameters.Add("@pUserId", Convert.ToString(_UserSession.UserId));
                parameters.Add("@pTimestamp", model.Timestamp);
                parameters.Add("@pIsChangeToVendor", Convert.ToString(model.IsAssignedToVendor));
                parameters.Add("@pAssignedVendor", Convert.ToString(model.AssignedVendor));
                //parameters.Add("@pAssetRealtimeStatus", Convert.ToString(model.RealTimeStatus));

                DataTable dt = dbAccessDAL.GetDataTable("uspFM_EngMwoAssesmentTxn_Save", parameters, DataSetparameters);
                if (dt != null)
                {
                    foreach (DataRow row in dt.Rows)
                    {
                        model.WorkOrderId = Convert.ToInt32(row["WorkOrderId"]);
                        model.Timestamp = Convert.ToBase64String((byte[])(row["Timestamp"]));
                        model.ErrorMessage = Convert.ToString(row["ErrorMessage"]);
                    }
                    model.WorkOrderType = WOType;
                    model.EngineerId = AssigneeId;
                    //  SendMailRequestAssessment(model);
                }
                //if (model.IsAssignedToVendor == (int)YesNo.Yes) {
                //    _EmailDAL.SendWorkOrderVendorAssignEmail(model);
                //    UpdateNotification(model, "Vendor");
                //}
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

        public ScheduledWorkOrderModel VendorAssessProcess(ScheduledWorkOrderModel model)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());
            try
            {
                var dbAccessDAL = new DBAccessDAL();
                var WOType = model.WorkOrderType;
                var AssigneeId = model.EngineerId;
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();

                parameters.Add("@pWorkOrderId", Convert.ToString(model.WorkOrderId));
                parameters.Add("@pUserId", Convert.ToString(_UserSession.UserId));
                parameters.Add("@ApproveStatus", Convert.ToString(model.VendorProFlag));

                DataTable dt = dbAccessDAL.GetDataTable("uspFM_uspFM_EngAssesmentChangeToVendor_Save", parameters, DataSetparameters);
                if (dt != null)
                {
                    foreach (DataRow row in dt.Rows)
                    {
                        model.AssignedVendorEmail = Convert.ToString(row["email"]);
                        model.VendorProFlag = Convert.ToString(row["ApproveStatus"]);
                        model.WorkOrderNo = Convert.ToString(row["WorkorderNo"]);
                    }
                }

                if (model.VendorProFlag == "Approve")
                {
                    SendMailVendorAssessProcess(model);
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

        private void SendMailVendorAssessProcess(ScheduledWorkOrderModel model)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(SendMailVendorAssessProcess), Level.Info.ToString());
            try
            {
                string emailTemplateId = string.Empty;
                string subject = string.Empty;
                string subjectVars = string.Empty;
                string templateVars = string.Empty;


                emailTemplateId = "78";
                var tempid = Convert.ToInt32(emailTemplateId);
                model.TemplateId = tempid;

                //var obj = Get(model.WorkOrderId);
                //if (obj != null)
                // {
                templateVars = string.Join(",", model.WorkOrderNo);
                // }

                string email = model.AssignedVendorEmail;

                var DataSetparameters = new Dictionary<string, DataTable>();
                DataTable TypecodeDt = new DataTable();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pEmailTemplateId", Convert.ToString(model.TemplateId));
                parameters.Add("@pToEmailIds", email);
                parameters.Add("@pSubject", Convert.ToString(subject));
                parameters.Add("@pPriority", Convert.ToString(1));
                parameters.Add("@pSendAsHtml", Convert.ToString(1));
                parameters.Add("@pFacilityId", Convert.ToString(_UserSession.FacilityId));

                parameters.Add("@pSubjectVars", Convert.ToString(subjectVars));
                parameters.Add("@pTemplateVars", Convert.ToString(templateVars));


                var dbAccessDAL = new DBAccessDAL();
                DataTable dt = dbAccessDAL.GetDataTable("uspFM_EmailNotify_Save", parameters, DataSetparameters);
                if (dt != null)
                {
                    foreach (DataRow rows in dt.Rows)
                    {

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

        private void SendMailRequestAssessment(ScheduledWorkOrderModel model)       // unused
        {
            Log4NetLogger.LogEntry(_FileName, nameof(SendMailRequestAssessment), Level.Info.ToString());
            try
            {
                string emailTemplateId = string.Empty;
                string subject = string.Empty;
                string subjectVars = string.Empty;
                string templateVars = string.Empty;


                emailTemplateId = "17";
                var tempid = Convert.ToInt32(emailTemplateId);
                model.TemplateId = tempid;

                var obj = Get(model.WorkOrderId);
                if (obj != null)
                {
                    templateVars = string.Join(",", obj.WorkOrderNo);
                }

                var GetObj = GetMail(obj);
                string email = GetObj.Email;

                var DataSetparameters = new Dictionary<string, DataTable>();
                DataTable TypecodeDt = new DataTable();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pEmailTemplateId", Convert.ToString(emailTemplateId));
                parameters.Add("@pToEmailIds", email);
                parameters.Add("@pSubject", Convert.ToString(subject));
                parameters.Add("@pPriority", Convert.ToString(1));
                parameters.Add("@pSendAsHtml", Convert.ToString(1));
                parameters.Add("@pFacilityId", Convert.ToString(_UserSession.FacilityId));

                parameters.Add("@pSubjectVars", Convert.ToString(subjectVars));
                parameters.Add("@pTemplateVars", Convert.ToString(templateVars));


                var dbAccessDAL = new DBAccessDAL();
                DataTable dt = dbAccessDAL.GetDataTable("uspFM_EmailNotify_Save", parameters, DataSetparameters);
                if (dt != null)
                {
                    foreach (DataRow rows in dt.Rows)
                    {

                    }
                }
                SendMailRequestAssessmentNotify(model);
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

        public ScheduledWorkOrderModel SendMailRequestAssessmentNotify(ScheduledWorkOrderModel model)       // unused
        {
            Log4NetLogger.LogEntry(_FileName, nameof(SendMailRequestAssessmentNotify), Level.Info.ToString());
            ScheduledWorkOrderModel griddata = new ScheduledWorkOrderModel();
            var dbAccessDAL = new DBAccessDAL();
            var parameters = new Dictionary<string, string>();
            var DataSetparameters = new Dictionary<string, DataTable>();
            var TempWorkOrderType = model.WorkOrderType;
            var notalert = string.Empty;
            var hyplink = string.Empty;

            //if (TempWorkOrderType == 187)
            //{
            //    notalert = model.WorkOrderNo + " " + "Scheduled Work Order has been generated";
            //    hyplink = "/bems/scheduledworkorder?id=" + model.WorkOrderId;

            //}
            if (TempWorkOrderType == 188)
            {
                notalert = model.WorkOrderNo + " " + "UnScheduled Work Order Assessment has been generated";
                hyplink = "/bems/unscheduledworkorder?id=" + model.WorkOrderId;
            }

            parameters.Add("@pNotificationId", Convert.ToString(model.NotificationId));
            parameters.Add("@pCustomerId", Convert.ToString(_UserSession.CustomerId));
            parameters.Add("@pFacilityId", Convert.ToString(_UserSession.FacilityId));
            parameters.Add("@pUserId", Convert.ToString(model.EngineerId));
            parameters.Add("@pNotificationAlerts", Convert.ToString(notalert));
            parameters.Add("@pRemarks", Convert.ToString(""));
            parameters.Add("@pHyperLink", Convert.ToString(hyplink));
            parameters.Add("@pIsNew", Convert.ToString(1));
            parameters.Add("@pNotificationDateTime", Convert.ToString(null));
            parameters.Add("@pEmailTempId", Convert.ToString(model.TemplateId));

            DataTable ds = dbAccessDAL.GetDataTable("uspFM_WebNotificationSingle_Save", parameters, DataSetparameters);
            if (ds != null)
            {
                foreach (DataRow row in ds.Rows)
                {

                }
            }

            return model;
        }

        public ScheduledWorkOrderModel SaveTransfer(ScheduledWorkOrderModel model)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());
            if (model.Timestamp == null)
                model.Timestamp = "AAAAAAABNKc = ";
            try
            {
                var dbAccessDAL = new DBAccessDAL();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pWOTransferId", Convert.ToString(model.WOTransferId));
                parameters.Add("@pCustomerId", Convert.ToString(_UserSession.CustomerId));
                parameters.Add("@pFacilityId", Convert.ToString(_UserSession.FacilityId));
                parameters.Add("@pServiceId", Convert.ToString(2));
                parameters.Add("@pWorkOrderId", Convert.ToString(model.WorkOrderId));
                parameters.Add("@pAssignedUserId ", Convert.ToString(model.TransferAssignedPersonId));
                parameters.Add("@pUserId", Convert.ToString(_UserSession.UserId));
                parameters.Add("@pTransferReasonLovId", Convert.ToString(model.TransferReason));
                parameters.Add("@pTimestamp", model.Timestamp);

                DataTable dt = dbAccessDAL.GetDataTable("uspFM_EngMwoTransferTxn_Save", parameters, DataSetparameters);
                if (dt != null)
                {
                    foreach (DataRow row in dt.Rows)
                    {
                        model.WorkOrderId = Convert.ToInt32(row["WorkOrderId"]);
                        model.Timestamp = Convert.ToBase64String((byte[])(row["Timestamp"]));
                        model.ErrorMessage = Convert.ToString(row["ErrorMessage"]);
                    }
                }

                _EmailDAL.SendWorkOrderReassignEmail(model);
                UpdateNotification(model, "Assignee");

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
        public ScheduledWorkOrderModel SaveCompletionInfo(ScheduledWorkOrderModel model)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());
            try
            {
                var dbAccessDAL = new DBAccessDAL();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pCompletionInfoId", Convert.ToString(model.CompletionInfoId));
                parameters.Add("@pCustomerId", Convert.ToString(_UserSession.CustomerId));
                parameters.Add("@pFacilityId", Convert.ToString(_UserSession.FacilityId));
                parameters.Add("@pServiceId", Convert.ToString(2));
                parameters.Add("@pWorkOrderId", Convert.ToString(model.WorkOrderId));
                parameters.Add("@pRepairDetails", Convert.ToString(model.RepairDetails));
                parameters.Add("@pPPMAgreedDate", model.AgreedDate != null ? model.AgreedDate.Value.ToString("yyyy-MM-dd hh:mm") : null);
                parameters.Add("@pPPMAgreedDateUTC", null);
                parameters.Add("@pStartDateTime", model.StartDate != null ? model.StartDate.ToString("yyyy-MM-dd hh:mm") : null);
                parameters.Add("@pStartDateTimeUTC", model.StartDate != null ? model.StartDate.ToString("yyyy-MM-dd hh:mm") : null);
                parameters.Add("@pEndDateTime", model.EndDate != null ? model.EndDate.Value.ToString("yyyy-MM-dd hh:mm") : null);
                parameters.Add("@pEndDateTimeUTC", model.EndDate != null ? model.EndDate.Value.ToString("yyyy-MM-dd hh:mm") : null);
                //parameters.Add("@pHandoverDateTime", model.HandOverDate != null ? model.HandOverDate.Value.ToString("yyyy-MM-dd hh:mm") : null);
                parameters.Add("@pHandoverDateTime", Convert.ToString(model.HandOverDate == null || model.HandOverDate == DateTime.MinValue ? null : ((DateTime)model.HandOverDate).ToString("MM-dd-yyy HH:mm")));
                parameters.Add("@pHandoverDateTimeUTC", model.HandOverDate != null ? model.HandOverDate.Value.ToString("yyyy-MM-dd hh:mm") : null);
                parameters.Add("@pCompletedBy", Convert.ToString(model.CompletedById));
                parameters.Add("@pAcceptedBy", Convert.ToString(model.VerifiedById));
                parameters.Add("@pSignature", null);
                parameters.Add("@pServiceAvailability", null);
                parameters.Add("@pLoanerProvision", null);
                parameters.Add("@pDowntimeHoursMin", Convert.ToString(model.DownTimeHours));
                parameters.Add("@pCauseCode", Convert.ToString(model.CauseCodeDescription));
                parameters.Add("@pQCCode", Convert.ToString(model.QCDescription));
                parameters.Add("@pResourceType", null);
                parameters.Add("@pLabourCost", null);
                parameters.Add("@pPartsCost", null);
                parameters.Add("@pContractorCost", null);
                parameters.Add("@pTotalCost", null);
                parameters.Add("@pContractorId", null);
                parameters.Add("@pContractorHours", null);
                parameters.Add("@pPartsRequired", null);
                parameters.Add("@pApproved", null);
                parameters.Add("@pAppType", null);
                parameters.Add("@pRepairHours", null);
                parameters.Add("@pProcessStatus", Convert.ToString(model.Status));
                parameters.Add("@pProcessStatusDate", model.Date != null ? model.Date.Value.ToString("yyyy-MM-dd") : null);
                parameters.Add("@pProcessStatusReason", Convert.ToString(model.Reason));
                parameters.Add("@pUserId", Convert.ToString(_UserSession.UserId));
                parameters.Add("@pIsSubmitted", Convert.ToString(model.IsSubmitted));
                parameters.Add("@pTimestamp", model.Timestamp);
                parameters.Add("@pRunningHours", model.RunningHours);
                parameters.Add("@pVendorCost", Convert.ToString(model.VendorServicecost));
                parameters.Add("@pDownTimeHours", Convert.ToString(model.DownTimeHours));
                parameters.Add("@pCustomerFeedback", Convert.ToString(model.CustomerFeedback));

                DataTable dt = new DataTable();
                dt.Columns.Add("CompletionInfoDetId", typeof(int));
                dt.Columns.Add("CustomerId", typeof(int));
                dt.Columns.Add("FacilityId", typeof(int));
                dt.Columns.Add("ServiceId", typeof(int));
                dt.Columns.Add("StaffMasterId", typeof(int));
                dt.Columns.Add("StandardTaskDetId", typeof(int));
                dt.Columns.Add("StartDateTime", typeof(DateTime));
                dt.Columns.Add("StartDateTimeUTC", typeof(DateTime));
                dt.Columns.Add("EndDateTime", typeof(DateTime));
                dt.Columns.Add("EndDateTimeUTC", typeof(DateTime));
                //dt.Columns.Add("RepairHours", typeof(decimal));
                //dt.Columns.Add("CompletionInfoId", typeof(int));

                // Delete grid
                var deletedId = model.CompletionInfoDets.Where(y => y.IsDeleted).Select(x => x.CompletionInfoDetId).ToList();
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

                foreach (var item in model.CompletionInfoDets.Where(x => !x.IsDeleted))
                {
                    item.CreatedDate = Convert.ToDateTime(DateTime.Now.ToString("yyyy-MM-dd h:mm tt"));
                    //string test = item.EndDate.ToString("yyyy-MM-dd");
                    //string EndDate = null;
                    //if(test != "0001-01-01")
                    //{
                    //    EndDate = test;
                    //}
                    dt.Rows.Add(item.CompletionInfoDetId, _UserSession.CustomerId, _UserSession.FacilityId, 2, item.StaffMasterId, item.StandardTaskDetId, item.StartDate, item.StartDate, item.EndDate, item.EndDate);

                }
                DataSetparameters.Add("@EngMwoCompletionInfoTxnDet", dt);

                DataTable ds = dbAccessDAL.GetDataTable("uspFM_EngMwoCompletionInfoTxn_Save", parameters, DataSetparameters);
                if (ds != null)
                {
                    foreach (DataRow row in ds.Rows)
                    {
                        model.CompletionInfoId = Convert.ToInt32(row["CompletionInfoId"]);
                        model.WorkOrderId = Convert.ToInt32(row["WorkOrderId"]);
                        model.Timestamp = Convert.ToBase64String((byte[])(row["Timestamp"]));
                        model.ErrorMessage = Convert.ToString(row["ErrorMessage"]);
                    }
                }
                if (model.ErrorMessage == "" || model.ErrorMessage == null)
                {
                    model = GetCompletionInfo(model.WorkOrderId, 5, 1);

                }
                Log4NetLogger.LogEntry(_FileName, nameof(SaveCompletionInfo), Level.Info.ToString());
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
        public ScheduledWorkOrderModel SavePartReplacement(ScheduledWorkOrderModel model)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());
            try
            {
                var dbAccessDAL = new DBAccessDAL();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pWorkOrderId", Convert.ToString(model.WorkOrderId));
                DataTable dt = new DataTable();
                dt.Columns.Add("PartReplacementId", typeof(int));
                dt.Columns.Add("CustomerId", typeof(int));
                dt.Columns.Add("FacilityId", typeof(int));
                dt.Columns.Add("ServiceId", typeof(int));

                dt.Columns.Add("WorkOrderId", typeof(int));
                dt.Columns.Add("SparePartStockRegisterId", typeof(int));
                dt.Columns.Add("Quantity", typeof(int));
                dt.Columns.Add("Cost", typeof(int));
                dt.Columns.Add("TotalPartsCost", typeof(decimal));
                dt.Columns.Add("LabourCost", typeof(decimal));
                dt.Columns.Add("StockUpdateDetId", typeof(int));
                dt.Columns.Add("ActualQuantityinStockUpdate", typeof(int));
                dt.Columns.Add("UserId", typeof(int));
                dt.Columns.Add("AverageUsageHours", typeof(string));
                dt.Columns.Add("SparePartRunningHours", typeof(decimal));
                dt.Columns.Add("IsPartReplacedCost", typeof(int));
                dt.Columns.Add("PartReplacementCost", typeof(decimal));
                dt.Columns.Add("EstimatedLifespan", typeof(int));
                dt.Columns.Add("LifeSpanExpiryDate", typeof(DateTime));
                dt.Columns.Add("StockType", typeof(int));
                dt.Columns.Add("PopUpQuantityTaken", typeof(decimal));
                // Delete grid
                var deletedId = model.PartReplacementDets.Where(y => y.IsDeleted).Select(x => x.PartReplacementId).ToList();
                var idstring = string.Empty;
                if (deletedId.Count() > 0)
                {
                    foreach (var item in deletedId.Select((value, i) => new { i, value }))
                    {
                        idstring += item.value;
                        if (item.i != deletedId.Count() - 1)
                        { idstring += ","; }
                    }
                    deletePartChildrecords(idstring);
                }

                decimal totalPartReplacementCost = 0m;
                decimal QuantityTaken = 0m;
                foreach (var item in model.PartReplacementDets.Where(x => !x.IsDeleted))
                {
                    if (item.PartReplacementCostInvolved == 99)
                    {
                        totalPartReplacementCost += item.PopUpQuantityAvailable;
                        QuantityTaken += item.PopUpQuantityTaken;
                    }
                    else
                    {
                        totalPartReplacementCost += item.PopUpQuantityAvailable;
                        QuantityTaken += item.PopUpQuantityTaken;
                    }
                }

                foreach (var item in model.PartReplacementDets.Where(x => !x.IsDeleted))
                {

                    dt.Rows.Add(item.PartReplacementId, _UserSession.CustomerId, _UserSession.FacilityId, 2,
                    item.WorkOrderId, item.SparePartStockRegisterId, item.Quantity, item.CostPerUnit,
                    item.TotalCost,
                    item.LabourCost, item.StockUpdateDetId, item.PopUpQuantityAvailable, _UserSession.UserId, null, item.AverageUsageHours, item.PartReplacementCostInvolved, item.PartReplacementCost, item.EstimatedLifeSpan, item.EstimatedLifeSpanDate, item.StockType, item.PopUpQuantityTaken);

                }
                DataSetparameters.Add("@pEngMwoPartReplacementTxn", dt);

                DataTable ds = dbAccessDAL.GetDataTable("uspFM_EngMwoPartReplacementTxn_Save", parameters, DataSetparameters);
                if (ds != null)
                {
                    foreach (DataRow row in ds.Rows)
                    {
                        // model.CompletionInfoId = Convert.ToInt32(row["CompletionInfoId"]);
                        model.Timestamp = Convert.ToBase64String((byte[])(row["Timestamp"]));
                        //model.ErrorMessage = Convert.ToString(row["ErrorMessage"]);
                    }
                }
                if (model.ErrorMessage == "" || model.ErrorMessage == null)
                {
                    model = GetPartReplacement(model.WorkOrderId, 5, 1);

                }
                //model.TotalPartReplacementCost = totalPartReplacementCost;
                Log4NetLogger.LogEntry(_FileName, nameof(SaveCompletionInfo), Level.Info.ToString());
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

        public ScheduledWorkOrderModel SavePurchaseRequest(ScheduledWorkOrderModel model)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());
            try
            {
                var AssigneeId = model.EngineerId;
                var GetWOId = model.WorkOrderId;
                var WOType = model.WorkOrderType;
                var WONumber = model.WorkOrderNo;
                var Assignee = model.Assignee;
                var PartWorkOrderDate = model.PartWorkOrderDate;
                var AssetNo = model.AssetNo;
                var Model = model.Model;
                var manufacturer = model.Manufacturer;
                var dbAccessDAL = new DBAccessDAL();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                // parameters.Add("@pWorkOrderId", Convert.ToString(model.WorkOrderId));
                DataTable dt = new DataTable();
                dt.Columns.Add("SparePartsRequsetId", typeof(int));
                dt.Columns.Add("SparePartsId", typeof(int));
                dt.Columns.Add("WorkOrderId", typeof(int));
                dt.Columns.Add("Quantity", typeof(int));
                dt.Columns.Add("Remarks", typeof(int));
                dt.Columns.Add("UserId", typeof(int));


                foreach (var item in model.PurchaseRequestDets)
                {
                    dt.Rows.Add(item.PurchaseRequestId, item.PurchaseSparePartStockRegisterId, item.WorkOrderId, item.PurchaseQuantity, null, _UserSession.UserId);

                }
                DataSetparameters.Add("@pSparePartPurchaseRequest", dt);

                DataTable ds = dbAccessDAL.GetDataTable("uspFM_EngSparePartPurchaseRequest_Save", parameters, DataSetparameters);
                if (ds != null)
                {
                    foreach (DataRow row in ds.Rows)
                    {
                        // model.CompletionInfoId = Convert.ToInt32(row["CompletionInfoId"]);
                        model.Timestamp = Convert.ToBase64String((byte[])(row["Timestamp"]));
                        //model.ErrorMessage = Convert.ToString(row["ErrorMessage"]);
                    }
                }
                if (model.ErrorMessage == "" || model.ErrorMessage == null)
                {
                    model = GetPurchaseRequest(model.WorkOrderId);
                    //model.WorkOrderNo= GetPurchaseRequest(model.WorkOrderNo);                    
                    model.WorkOrderId = GetWOId;
                    model.WorkOrderType = WOType;
                    model.EngineerId = AssigneeId;
                    model.WorkOrderNo = WONumber;
                    model.Assignee = Assignee;
                    model.PartWorkOrderDate = PartWorkOrderDate;
                    model.AssetNo = AssetNo;
                    model.Model = Model;
                    model.Manufacturer = manufacturer;
                    SendPurchaseMail(model);
                }
                Log4NetLogger.LogEntry(_FileName, nameof(SaveCompletionInfo), Level.Info.ToString());
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

        private void SendPurchaseMail(ScheduledWorkOrderModel model)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(SendPurchaseMail), Level.Info.ToString());
            try
            {
                string emailTemplateId = string.Empty;
                string subject = string.Empty;
                string subjectVars = string.Empty;
                string templateVars = string.Empty;
                string email = string.Empty;
                string Parts = string.Empty;
                string Quantity = string.Empty;

                var AssEmail = GetMailPurcahsereq(model.EngineerId.Value);
                email = AssEmail;

                emailTemplateId = "22";
                var tempid = Convert.ToInt32(emailTemplateId);
                model.TemplateId = tempid;

                var obj = GetPurchaseRequest(model.WorkOrderId);
                var WorkorderNo = model.WorkOrderNo;
                var Assignee = model.Assignee;
                var FaciltyName = _UserSession.FacilityName;
                var Workorderdate = ((DateTime)model.PartWorkOrderDate).ToString("dd-MMM-yyy HH:mm");
                var AssetNo = model.AssetNo;
                var Model = model.Model;
                var Manufacturer = model.Manufacturer;
                var str = "<table border=\"1\" style=\"border-collapse:collapse;\" cellpadding=\"5\">";
                str += "<th>Part No</th> <th>Part Description</th> <th>Item Code</th> <th>Item Description</th> <th>Quantity</th>";
                for (int i = 0; i < obj.PurchaseRequestDets.Count; i++)
                {
                    str += "<tr>" +
                           "<td>" + obj.PurchaseRequestDets[i].PurchasePartNo.ToString() + "</td>" +
                          "<td>" + obj.PurchaseRequestDets[i].PurchasePartDescription.ToString() + "</td>" +
                          "<td>" + obj.PurchaseRequestDets[i].PurchaseItemCode.ToString() + "</td>" +
                          "<td>" + obj.PurchaseRequestDets[i].PurchaseItemDescription.ToString() + "</td>" +
                          "<td>" + obj.PurchaseRequestDets[i].PurchaseQuantity.ToString() + "</td>" +
                          "</tr>";
                }
                str += "</table>";
                //if (obj != null)
                //{
                //    var count = obj.PurchaseRequestDets.Count() - 1;
                //    for (var i = 0; i <= count; i++)
                //    {
                //        var Partresult = (i == count) ? obj.PurchaseRequestDets[i].PurchasePartNo : obj.PurchaseRequestDets[i].PurchasePartNo + "/";
                //        Parts += Partresult;
                //        var Quantityresult = (i == count) ? obj.PurchaseRequestDets[i].PurchaseQuantity.ToString() : obj.PurchaseRequestDets[i].PurchaseQuantity.ToString() + "/";
                //        Quantity += Quantityresult;
                //    }
                //}

                templateVars = string.Join(",", WorkorderNo, _UserSession.StaffName, FaciltyName, Workorderdate, AssetNo, Model, Manufacturer, str);

                var DataSetparameters = new Dictionary<string, DataTable>();
                DataTable TypecodeDt = new DataTable();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pEmailTemplateId", Convert.ToString(emailTemplateId));
                parameters.Add("@pToEmailIds", email);
                parameters.Add("@pSubject", Convert.ToString(subject));
                parameters.Add("@pPriority", Convert.ToString(1));
                parameters.Add("@pSendAsHtml", Convert.ToString(1));
                parameters.Add("@pFacilityId", Convert.ToString(_UserSession.FacilityId));
                parameters.Add("@pSubjectVars", Convert.ToString(subjectVars));
                parameters.Add("@pTemplateVars", Convert.ToString(templateVars));

                var dbAccessDAL = new DBAccessDAL();
                DataTable dt = dbAccessDAL.GetDataTable("uspFM_EmailNotify_Save", parameters, DataSetparameters);
                if (dt != null)
                {
                    foreach (DataRow rows in dt.Rows)
                    {
                    }
                }
                SendPurchaseMailNotify(model);
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

        public ScheduledWorkOrderModel SendPurchaseMailNotify(ScheduledWorkOrderModel ent)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(SendPurchaseMailNotify), Level.Info.ToString());
            ScheduledWorkOrderModel griddata = new ScheduledWorkOrderModel();
            var dbAccessDAL = new DBAccessDAL();
            var parameters = new Dictionary<string, string>();
            var DataSetparameters = new Dictionary<string, DataTable>();
            var TempWorkOrderType = ent.WorkOrderType;
            var notalert = string.Empty;
            var hyplink = string.Empty;

            if (TempWorkOrderType == 187)
            {
                notalert = ent.WorkOrderNo + " " + "Scheduled Work Order Purchase Request has been raised";
                hyplink = "/bems/scheduledworkorder?id=" + ent.WorkOrderId;
            }
            else if (TempWorkOrderType == 188)
            {
                notalert = ent.WorkOrderNo + " " + "UnScheduled Work Order Purchase Request has been raised";
                hyplink = "/bems/unscheduledworkorder?id=" + ent.WorkOrderId;
            }

            parameters.Add("@pNotificationId", Convert.ToString(ent.NotificationId));
            parameters.Add("@pCustomerId", Convert.ToString(_UserSession.CustomerId));
            parameters.Add("@pFacilityId", Convert.ToString(_UserSession.FacilityId));
            parameters.Add("@pUserId", Convert.ToString(ent.EngineerId));
            parameters.Add("@pNotificationAlerts", Convert.ToString(notalert));
            parameters.Add("@pRemarks", Convert.ToString(""));
            parameters.Add("@pHyperLink", Convert.ToString(hyplink));
            parameters.Add("@pIsNew", Convert.ToString(1));
            parameters.Add("@pNotificationDateTime", Convert.ToString(null));
            parameters.Add("@pEmailTempId", Convert.ToString(ent.TemplateId));
            parameters.Add("@pmScreenName", Convert.ToString("WorkOrder"));

            //parameters.Add("@pmScreenName", Convert.ToString("Work Order"));
            //parameters.Add("@pMGuid", Convert.ToString(ent.HiddenId));

            DataTable ds = dbAccessDAL.GetDataTable("uspFM_WebNotificationSingle_Save", parameters, DataSetparameters);
            if (ds != null)
            {
                foreach (DataRow row in ds.Rows)
                {

                }
            }
            return ent;
        }

        public ScheduledWorkOrderModel SavePPMCheckList(ScheduledWorkOrderModel model)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());
            try
            {
                var dbAccessDAL = new DBAccessDAL();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@PWOPPMCheckListId", model.WOPPMCheckListId.ToString());
                parameters.Add("@pPPMCheckListId", model.PPMCheckListId.ToString());
                parameters.Add("@pWorkOrderId", model.WorkOrderId.ToString());
                parameters.Add("@pUserId", Convert.ToString(_UserSession.UserId));

                var DataSetparameters = new Dictionary<string, DataTable>();
                DataTable dtCat = new DataTable();
                dtCat.Columns.Add("WOCategoryId", typeof(int));
                dtCat.Columns.Add("CategoryId", typeof(int));
                dtCat.Columns.Add("Status", typeof(int));
                dtCat.Columns.Add("Remarks", typeof(string));
                dtCat.Columns.Add("UserId", typeof(int));

                foreach (var ppm in model.PPmChecklistCategoryDets)
                {
                    dtCat.Rows.Add(ppm.WOPPmCategoryDetId, ppm.PPmCategoryDetId, ppm.Status, ppm.Remarks, _UserSession.UserId);
                }

                DataTable QuantasksDt = new DataTable();
                QuantasksDt.Columns.Add("WOPPMCheckListQNId", typeof(int));
                QuantasksDt.Columns.Add("PPMCheckListQNId", typeof(int));
                QuantasksDt.Columns.Add("Value", typeof(string));
                QuantasksDt.Columns.Add("Status", typeof(int));
                QuantasksDt.Columns.Add("Remarks", typeof(string));
                QuantasksDt.Columns.Add("UserId", typeof(int));

                foreach (var task in model.PPMCheckListQuantasksMstDets)
                {
                    QuantasksDt.Rows.Add(task.WOPPMCheckListQNId, task.PPMCheckListQNId, task.Value, task.Status, task.Remarks, _UserSession.UserId);
                }

                DataSetparameters.Add("@WOEngAssetPPMCheckListCategory", dtCat);
                DataSetparameters.Add("@WOEngAssetPPMCheckListQuantasksMstDetType", QuantasksDt);
                DataTable dt = dbAccessDAL.GetDataTable("uspFM_WOEngAssetPPMCheckList_Save", parameters, DataSetparameters);

                if (dt != null)
                {
                    foreach (DataRow row in dt.Rows)
                    {
                        model.WorkOrderId = Convert.ToInt32(row["WorkOrderId"]);
                        model.PPMCheckListId = Convert.ToInt32(row["PPMCheckListId"]);
                        //ErrorMessage = Convert.ToString(row["ErrorMessage"]);
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

        public bool Delete(int Id)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Delete), Level.Info.ToString());
            try
            {
                var dbAccessDAL = new DBAccessDAL();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pWorkOrderId", Id.ToString());
                DataTable dt = dbAccessDAL.GetDataTable("uspFM_EngMaintenanceWorkOrderTxn_Delete", parameters, DataSetparameters);
                if (dt != null && dt.Rows.Count > 0)
                {
                    string Message = Convert.ToString(dt.Rows[0]["ErrorMessage"]);
                }
                Log4NetLogger.LogExit(_FileName, nameof(Delete), Level.Info.ToString());
                return true;
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

        public bool ApproveReject(int Id, string Remarks, string Type)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(ApproveReject), Level.Info.ToString());
            try
            {
                DataTable dt;
                var dbAccessDAL = new DBAccessDAL();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pWorkOrderId", Id.ToString());
                parameters.Add("@pRemarks", Remarks.ToString());
                if(Type == "Cancel")
                { 
                 dt = dbAccessDAL.GetDataTable("uspFM_EngMaintenanceWorkOrderTxn_Delete", parameters, DataSetparameters);
                }
                else
                { 
                 dt = dbAccessDAL.GetDataTable("UspFM_EngMaintenanceWorkOrderTxn_DeletionApproval", parameters, DataSetparameters);
                }
                if (dt != null && dt.Rows.Count > 0)
                {
                    string Message = Convert.ToString(dt.Rows[0]["ErrorMessage"]);
                }
                Log4NetLogger.LogExit(_FileName, nameof(ApproveReject), Level.Info.ToString());
                return true;
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
        public bool IsRecordModified(ScheduledWorkOrderModel model)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(IsRecordModified), Level.Info.ToString());
                var dbAccessDAL = new DBAccessDAL();
                var recordModifed = false;

                if (model.WorkOrderId != 0)
                {
                    var DataSetparameters = new Dictionary<string, DataTable>();
                    var parameters = new Dictionary<string, string>();
                    parameters.Add("@Id", model.WorkOrderId.ToString());
                    DataTable dt = dbAccessDAL.GetDataTable("uspFM_EngPPMRegisterMst__GetTimestamp", parameters, DataSetparameters);

                    if (dt != null && dt.Rows.Count > 0)
                    {
                        var timestamp = Convert.ToBase64String((byte[])(dt.Rows[0]["Timestamp"]));
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
                        cmd.CommandText = "uspFM_EngMwoCompletionInfoTxnDet_Delete";
                        cmd.Parameters.AddWithValue("@pCompletionInfoDetId", id);

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

        public void deletePartChildrecords(string id)
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
                        cmd.CommandText = "uspFM_EngMwoPartReplacementTxn_Delete";
                        cmd.Parameters.AddWithValue("@pPartReplacementId", id);

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
        public bool IsAdditionalFieldsExist()
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(IsAdditionalFieldsExist), Level.Info.ToString());
                var isExists = false;

                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_FMAddFieldConfig_Check";
                        cmd.Parameters.AddWithValue("@pCustomerId", _UserSession.CustomerId);
                        cmd.Parameters.AddWithValue("@pScreenNameLovId", (int)ConfigScreenNameValue.WorkorderScheduled);
                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }
                if (ds.Tables.Count != 0 && ds.Tables[0].Rows.Count > 0)
                {
                    isExists = Convert.ToInt32(ds.Tables[0].Rows[0][0]) > 0;
                }
                Log4NetLogger.LogExit(_FileName, nameof(IsAdditionalFieldsExist), Level.Info.ToString());
                return isExists;
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
        private void UpdateNotification(ScheduledWorkOrderModel workOrder, String ReassignType)
        {
            var dbAccessDAL = new DBAccessDAL();
            var parameters = new Dictionary<string, string>();
            var DataSetparameters = new Dictionary<string, DataTable>();

            var action = string.Empty;
            var emailTemplateId = 0;
            var notalert = string.Empty;
            var hyplink = string.Empty;
            var userId = 0;

            switch (ReassignType)
            {
                case "Assignee":
                    emailTemplateId = (int)NotificationTemplateIds.WorkOrderReassigned;
                    userId = workOrder.TransferAssignedPersonId;

                    var workOrderCatory = string.Empty;
                    switch (workOrder.WorkOrderCategory)
                    {
                        case (int)WorkOrderCategory.Scheduled:
                            workOrderCatory = "Scheduled";
                            hyplink = "/bems/scheduledworkorder?id=" + workOrder.WorkOrderId;
                            break;
                        case (int)WorkOrderCategory.Unscheduled:
                            workOrderCatory = "Unscheduled";
                            hyplink = "/bems/unscheduledworkorder?id=" + workOrder.WorkOrderId;
                            break;
                    }

                    notalert = "The " + workOrderCatory + " Work Order " + workOrder.WorkOrderNo + " is reassigned";

                    break;
                case "Vendor":
                    var vendorId = workOrder.AssignedVendor == null ? 0 : (int)workOrder.AssignedVendor;
                    emailTemplateId = (int)NotificationTemplateIds.WorkOrderReassignedToVendor;
                    var userDetails = _EmailDAL.GetContractorInfo(vendorId);
                    userId = userDetails.UserId == null ? 0 : (int)userDetails.UserId;
                    notalert = "The Work Order " + workOrder.WorkOrderNo + " is reassigned to Vendor";
                    hyplink = "/bems/unscheduledworkorder?id=" + workOrder.WorkOrderId;
                    break;
            }

            parameters.Add("@pNotificationId", Convert.ToString(0));
            parameters.Add("@pCustomerId", Convert.ToString(_UserSession.CustomerId));
            parameters.Add("@pFacilityId", Convert.ToString(_UserSession.FacilityId));
            parameters.Add("@pUserId", Convert.ToString(userId));
            parameters.Add("@pNotificationAlerts", Convert.ToString(notalert));
            parameters.Add("@pRemarks", Convert.ToString(""));
            parameters.Add("@pHyperLink", Convert.ToString(hyplink));
            parameters.Add("@pIsNew", Convert.ToString(1));
            parameters.Add("@pNotificationDateTime", Convert.ToString(null));
            parameters.Add("@pEmailTempId", Convert.ToString(emailTemplateId));

            DataTable ds = dbAccessDAL.GetDataTable("uspFM_WebNotificationSingle_Save", parameters, DataSetparameters);
        }
    }
}
