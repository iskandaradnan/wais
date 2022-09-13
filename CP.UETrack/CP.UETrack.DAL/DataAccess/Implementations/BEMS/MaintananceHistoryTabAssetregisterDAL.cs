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
    public class MaintananceHistoryTabAssetregisterDAL : IMaintananceHistoryTabAssetregisterDAL
    {
        private readonly string _FileName = nameof(MaintananceHistoryTabAssetregisterDAL);
        readonly UserDetailsModel _UserSession = new SessionHelper().UserSession();

        public MaintenanceHistoryModelList fetchMaitenanceDetails(MaitenaceDetailsTab entity)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(fetchMaitenanceDetails), Level.Info.ToString());
                var maintenaceHistoryList = new MaintenanceHistoryModelList();
               
                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "UspFM_EngAssetMaintenanceHistory_GetByAssetId";
                        cmd.Parameters.AddWithValue("@pAssetId", entity.AssetId);
                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }
                if (ds.Tables.Count != 0 && ds.Tables[0].Rows.Count > 0)
                {
                    maintenaceHistoryList.maintenanceHistory = (from n in ds.Tables[0].AsEnumerable()
                                                        select new MaintenanceHistoryModel
                                                        {
                                                            WorkOrderId = n.Field<int>("WorkOrderId"),
                                                            MaintenaceWorkNo = n.Field<string>("MaintenaceWorkNo"),
                                                            WorkOrderDate = n.Field<DateTime?>("WorkOrderDate"),
                                                            CategoryId = n.Field<int>("MaintenanceWorkCategory"),
                                                            WorkCategory = n.Field<string>("WorkCategory"),
                                                            Type = n.Field<string>("Type"),
                                                            TotalDownTime = n.Field<decimal?>("TotalDownTime"),
                                                            SparepartsCost = n.Field<decimal?>("SparepartsCost"),
                                                            LabourCost = n.Field<decimal?>("LabourCost"),
                                                            TotalCost = n.Field<decimal?>("TotalCost")
                                                        }).ToList();
                }
                if (ds.Tables.Count != 0 && ds.Tables[1].Rows.Count > 0)
                {
                    maintenaceHistoryList.partsDetails = (from n in ds.Tables[1].AsEnumerable()
                                                               select new PartsDetails
                                                               {
                                                                    WorkOrderId = n.Field<int>("WorkOrderId"),
                                                                    PartNo = n.Field<string>("PartNo"),
                                                                    PartDescription = n.Field<string>("PartDescription"),
                                                                    ItemNo = n.Field<string>("ItemNo"),
                                                                    ItemDescription = n.Field<string>("ItemDescription"),
                                                                    MinCost = n.Field<decimal?>("MinCost"),
                                                                    MaxCost = n.Field<decimal?>("MaxCost"),
                                                                    Quantity = n.Field<decimal?>("Quantity"),
                                                                    CostPerUnit = n.Field<decimal?>("CostPerUnit"),
                                                                    StockType = n.Field<string>("StockType")
                                                               }).ToList();
                }
                Log4NetLogger.LogEntry(_FileName, nameof(fetchMaitenanceDetails), Level.Info.ToString());
                return maintenaceHistoryList;
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
