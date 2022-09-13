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

namespace CP.UETrack.DAL.DataAccess
{
   
    public class CurrentMaintenanceDAL : ICurrentMaintenanceDAL
    {
        private readonly string _FileName = nameof(AssetInformationDAL);
        readonly UserDetailsModel _UserSession = new SessionHelper().UserSession();
        public CurrentMaintenance Get(int Id)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
                var currentMaintenace = new CurrentMaintenance();

                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "UspFM_EngAsset_CurrentMaintenace_GetById";
                        cmd.Parameters.AddWithValue("@pAssetId", Id);
                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }
                if (ds.Tables.Count != 0 && ds.Tables[0].Rows.Count > 0)
                {
                    currentMaintenace.ppmMaintenance = (from n in ds.Tables[0].AsEnumerable()
                                                        select new PPMMaintenance
                                                        {
                                                            WorkOrderId = n.Field<int>("WorkOrderId"),
                                                            MaintenaceWorkNo = n.Field<string>("MaintenaceWorkNo"),
                                                            CategoryId = n.Field<int>("TypeId"),
                                                            WorkOrderDate = n.Field<DateTime?>("WorkOrderDate"),
                                                            WorkCategory = n.Field<string>("WorkCategory"),
                                                            Type = n.Field<string>("Type")
                                                        }).ToList();
                }
                if (ds.Tables.Count != 0 && ds.Tables[1].Rows.Count > 0)
                {
                    currentMaintenace.unScheduleMaintenance = (from n in ds.Tables[1].AsEnumerable()
                                                        select new UnScheduleMaintenance
                                                        {
                                                            WorkOrderId = n.Field<int>("WorkOrderId"),
                                                            MaintenaceWorkNo = n.Field<string>("MaintenaceWorkNo"),
                                                            CategoryId = n.Field<int>("TypeId"),
                                                            WorkOrderDate = n.Field<DateTime?>("WorkOrderDate"),
                                                            WorkCategory = n.Field<string>("WorkCategory"),
                                                            Type = n.Field<string>("Type")
                                                        }).ToList();
                }
                Log4NetLogger.LogExit(_FileName, nameof(Get), Level.Info.ToString());
                return currentMaintenace;
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
