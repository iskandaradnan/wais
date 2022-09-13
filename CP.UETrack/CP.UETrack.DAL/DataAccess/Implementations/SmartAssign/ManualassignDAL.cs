using CP.Framework.Common.ExceptionHandler.ExceptionWrappers;
using CP.Framework.Common.Logging;
using CP.UETrack.DAL.DataAccess.Contracts.UM;
using CP.UETrack.Model;
using CP.UETrack.Model.UM;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using UETrack.DAL;

namespace CP.UETrack.DAL.DataAccess.Implementations.UM
{
  public class ManualassignDAL: IManualassignDAL
    {
        private readonly string _FileName = nameof(ManualassignDAL);
        readonly UserDetailsModel _UserSession = new SessionHelper().UserSession();
        public ManualassignDAL()
        {

        }
        public ManualassignLovs Load()
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
                ManualassignLovs lovcollection = new ManualassignLovs();

                var ds1 = new DataSet();
                var ds2 = new DataSet();
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
                        cmd.Parameters.AddWithValue("@pLovKey", "MWOProcessStatusReasonValue,WarrantyTypeValue,WorkOrderStatusValue,RescheduleReasonValue,WorkOrderPriorityValue,MWOTransferReasonValue,MWOWorkOrderCategoryValue");
                        da.SelectCommand = cmd;
                        da.Fill(ds1);

                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_Dropdown_Others";
                        cmd.Parameters.Clear();
                        cmd.Parameters.AddWithValue("@pLovKey", "");
                        cmd.Parameters.AddWithValue("@pTableName", "EngMaintenanceWorkOrderTxn");

                        da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds2);
                    }
                }

                if (ds1.Tables.Count != 0)
                {
                    lovcollection.ReasonList = dbAccessDAL.GetLovRecords(ds1.Tables[0], "MWOProcessStatusReasonValue");
                    lovcollection.WarrentyTypeList = dbAccessDAL.GetLovRecords(ds1.Tables[0], "WarrantyTypeValue");
                    lovcollection.StatusList = dbAccessDAL.GetLovRecords(ds1.Tables[0], "WorkOrderStatusValue");
                    lovcollection.TransferReasonList = dbAccessDAL.GetLovRecords(ds1.Tables[0], "MWOTransferReasonValue");
                    lovcollection.WorkOrderCategoryList = dbAccessDAL.GetLovRecords(ds1.Tables[0], "MWOWorkOrderCategoryValue");
                    lovcollection.WorkOrderPriorityList = dbAccessDAL.GetLovRecords(ds1.Tables[0], "WorkOrderPriorityValue");
                    lovcollection.StatusList = lovcollection.StatusList.Where(x => x.LovId == 197).ToList();

                }
                if (ds2.Tables.Count != 0)
                {
                    lovcollection.CauseCodeList = dbAccessDAL.GetLovRecords(ds2.Tables[0]);
                    lovcollection.QCCodeList = dbAccessDAL.GetLovRecords(ds2.Tables[1]);
                }
                Log4NetLogger.LogExit(_FileName, nameof(Load), Level.Info.ToString());
                return lovcollection;
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
        public ManualassignViewModel Get(int Id)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
            try
            {
                var dbAccessDAL = new DBAccessDAL();
                var obj = new ManualassignViewModel();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pWorkOrderId", Id.ToString());
                DataSet ds = dbAccessDAL.GetDataSet("UspFM_EngMaintenanceWorkOrderTxn_GetById", parameters, DataSetparameters);
                if (ds != null)
                {
                    if (ds.Tables[0] != null && ds.Tables[0].Rows.Count > 0)
                    {
                        obj.AssetRegisterId = Convert.ToInt16(ds.Tables[0].Rows[0]["AssetId"] == System.DBNull.Value ? null : ds.Tables[0].Rows[0]["AssetId"]);
                        obj.AssetNo = Convert.ToString(ds.Tables[0].Rows[0]["AssetNo"]);
                        obj.Model = Convert.ToString(ds.Tables[0].Rows[0]["Model"] == System.DBNull.Value ? null : ds.Tables[0].Rows[0]["Model"]);
                        obj.Manufacturer = Convert.ToString(ds.Tables[0].Rows[0]["Manufacturer"] == System.DBNull.Value ? null : ds.Tables[0].Rows[0]["Manufacturer"]);
                        obj.RequestorId = Convert.ToInt16(ds.Tables[0].Rows[0]["RequestorStaffId"] == System.DBNull.Value ? null : ds.Tables[0].Rows[0]["RequestorStaffId"]);
                        obj.Requestor = Convert.ToString(ds.Tables[0].Rows[0]["RequestorStaffIdValue"] == System.DBNull.Value ? null : ds.Tables[0].Rows[0]["RequestorStaffIdValue"]);
                        obj.WorkOrderPriority = Convert.ToInt16(ds.Tables[0].Rows[0]["WorkOrderPriority"] == System.DBNull.Value ? null : ds.Tables[0].Rows[0]["WorkOrderPriority"]);
                        obj.TypeOfWorkOrder = Convert.ToInt32(ds.Tables[0].Rows[0]["TypeOfWorkOrder"]);
                        obj.MaintenanceType = Convert.ToInt32(ds.Tables[0].Rows[0]["MaintenanceWorkType"]);
                        obj.AssignedUserId= Convert.ToInt32(ds.Tables[0].Rows[0]["AssignedUserId"] == System.DBNull.Value ? null : ds.Tables[0].Rows[0]["AssignedUserId"]);
                        obj.Assignee = Convert.ToString(ds.Tables[0].Rows[0]["AssigneeUserName"] == System.DBNull.Value ? null : ds.Tables[0].Rows[0]["AssigneeUserName"]);
                        obj.MaintenanceDetails= Convert.ToString(ds.Tables[0].Rows[0]["MaintenanceDetails"] == System.DBNull.Value ? null : ds.Tables[0].Rows[0]["MaintenanceDetails"]);

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
       
        public ManualassignViewModel Save(ManualassignViewModel model)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());
            try
            {
                var dbAccessDAL = new DBAccessDAL();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                if (model.EngineerId == 0)
                    model.EngineerId = null;
                //if (model.AssingnId == 0)
                //    model.AssingnId = null;

                parameters.Add("@pWorkOrderId", Convert.ToString(model.WorkOrderId));
                parameters.Add("@pAssignedUserId", Convert.ToString(model.AssingnId));
                parameters.Add("@pAssigneeLovId", "332");              
                //parameters.Add("@pAssetId", Convert.ToString(model.AssetRegisterId));
                //parameters.Add("@pRequestorStaffId", Convert.ToString(model.RequestorId));
                //parameters.Add("@pWorkOrderPriority", Convert.ToString(model.WorkOrderPriority));
                //parameters.Add("@pPlannerId	", null);
                //parameters.Add("@pWorkGroupId", null);
                //parameters.Add("@pRemarks", null);
                //parameters.Add("@pBreakDownRequestId", null);
                //parameters.Add("@pUserId", Convert.ToString(_UserSession.UserId));

                DataTable dt = dbAccessDAL.GetDataTable("uspFM_WorkOrderAssigne_Save", parameters, DataSetparameters);
                if (dt != null)
                {
                    foreach (DataRow row in dt.Rows)
                    {
                        model.WorkOrderId = Convert.ToInt32(row["WorkOrderId"]);
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

    }
}
