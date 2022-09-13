using CP.Framework.Common.ExceptionHandler.ExceptionWrappers;
using CP.Framework.Common.Logging;
using CP.UETrack.DAL.DataAccess.Contracts.VM;
using CP.UETrack.DAL.DataAccess.Implementation;
using CP.UETrack.Model;
using CP.UETrack.Model.VM;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using UETrack.DAL;

namespace CP.UETrack.DAL.DataAccess.Implementations.VM
{
    public class BulkAuthorizationDAL : IBulkAuthorizationDAL
    {
        private readonly string _FileName = nameof(BulkAuthorizationDAL);
        readonly UserDetailsModel _UserSession = new SessionHelper().UserSession();

        public BulkAuthorizationViewModel Load()
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
                BulkAuthorizationViewModel BulkAuthorizationViewModel = null;

                var ds = new DataSet();
                var dbAccessDALMaster = new MASTERDBAccessDAL();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDALMaster.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_Dropdown_Others";
                        cmd.Parameters.AddWithValue("@pTableName", "ServiceAll");
                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);

                        if (ds.Tables.Count != 0)
                        {
                            BulkAuthorizationViewModel = new BulkAuthorizationViewModel();
                            BulkAuthorizationViewModel.ServiceData = dbAccessDAL.GetLovRecords(ds.Tables[0]);
                        }
                    }
                }

                Log4NetLogger.LogExit(_FileName, nameof(Load), Level.Info.ToString());
                return BulkAuthorizationViewModel;
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

        #region Data Access Methods
        public BulkAuthorizationViewModel Get(int Year, int Month,int ServiceId, int PageSize, int PageIndex)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
            try
            {
                BulkAuthorizationViewModel entity = new BulkAuthorizationViewModel();

                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                
                using (SqlConnection con = new SqlConnection(dbAccessDAL.DBAccessDALByServiceId_Param(ServiceId)))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_VmVariationTxn_BulkAuthorization_GetAll";
                        //cmd.Parameters.AddWithValue("@pUserId", _UserSession.UserId);
                        cmd.Parameters.AddWithValue("@pYear", Year);
                        cmd.Parameters.AddWithValue("@pMonth", Month);
                        cmd.Parameters.AddWithValue("@pServiceId", ServiceId);
                        cmd.Parameters.AddWithValue("@pPageIndex", PageIndex);
                        cmd.Parameters.AddWithValue("@pPageSize", PageSize);
                        cmd.Parameters.AddWithValue("@pFacilityId", _UserSession.FacilityId);

                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }
                if (ds.Tables.Count != 0 && ds.Tables[0].Rows.Count > 0)
                {
                    entity.BulkAuthorizationListData = (from n in ds.Tables[0].AsEnumerable()
                                                               select new BulkAuthorizationListData
                                                               {
                                                                   VariationId = Convert.ToInt32(n["VariationId"]),
                                                                   AssetId = Convert.ToInt32(n["AssetId"]),
                                                                   AssetNo = Convert.ToString(n["AssetNo"]),
                                                                   AssetDescription = Convert.ToString(n["AssetDescription"]),
                                                                   UserLocationName = Convert.ToString(n["UserLocationName"]),
                                                                   SNFDocumentNo = Convert.ToString(n["SNFDocumentNo"]),
                                                                   VariationStatus = Convert.ToString(n["VariationStatus"]),
                                                                   PurchaseProjectCost = Convert.ToDecimal(n["PurchaseProjectCost"]),
                                                                   CommissioningDate = n["CommissioningDate"] == DBNull.Value ? (DateTime?)null : Convert.ToDateTime((n["CommissioningDate"])),
                                                                   StartServiceDate = n["StartServiceDate"] == DBNull.Value ? (DateTime?)null : Convert.ToDateTime((n["StartServiceDate"])),
                                                                   WarrantyEndDate = n["WarrantyEndDate"] == DBNull.Value ? (DateTime?)null : Convert.ToDateTime((n["WarrantyEndDate"])),
                                                                   VariationDate = n["VariationDate"] == DBNull.Value ? (DateTime?)null : Convert.ToDateTime((n["VariationDate"])),
                                                                   ServiceStopDate = n["ServiceStopDate"] == DBNull.Value ? (DateTime?)null : Convert.ToDateTime((n["ServiceStopDate"])),
                                                                   AuthorizedStatus = n.Field<bool?>("AuthorizedStatus"),//n["AuthorizedStatus"] == DBNull.Value ?null: Convert.ToBoolean(n["AuthorizedStatus"]),
                                                                   Timestamp =  Convert.ToString(n["Timestamp"]),
                                                                   TotalRecords = Convert.ToInt32(n["TotalRecords"]),
                                                                   TotalPages = Convert.ToInt32(n["TotalPageCalc"])
                                                               }).ToList();

                    entity.BulkAuthorizationListData.ForEach((x) => {
                        x.PageIndex = PageIndex;
                        x.FirstRecord = ((PageIndex - 1) * PageSize) + 1;
                        x.LastRecord = ((PageIndex - 1) * PageSize) + PageSize;
                    });

                }
                Log4NetLogger.LogExit(_FileName, nameof(Get), Level.Info.ToString());
                return entity;

            }
            catch (DALException dalex)
            {
                throw new DALException(dalex);
            }
            catch (Exception excep)
            {
                throw;
            }
        }
        public BulkAuthorizationViewModel Save(BulkAuthorizationViewModel BulkAuthorization)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());
                int ServiceId = BulkAuthorization.ServiceId;
                DataTable dataTable = new DataTable("udt_VmVariationTxn");
                dataTable.Columns.Add("VariationId", typeof(int));
                dataTable.Columns.Add("SNFDocumentNo", typeof(string));
                dataTable.Columns.Add("AssetId", typeof(int));
                dataTable.Columns.Add("AuthorizedStatus", typeof(bool));
                dataTable.Columns.Add("UserId", typeof(int));

                foreach (var item in BulkAuthorization.BulkAuthorizationListData.Where(x => x.AuthorizedStatus==true))
                {
                    dataTable.Rows.Add(item.VariationId, item.SNFDocumentNo, item.AssetId, item.AuthorizedStatus, _UserSession.UserId);
                }

                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.DBAccessDALByServiceId_Param(ServiceId)))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_VmVariationTxn_BulkAuthorization_Save";

                        SqlParameter parameter = new SqlParameter();
                        parameter.ParameterName = "@VmVariationTxn";
                        parameter.SqlDbType = System.Data.SqlDbType.Structured;
                        parameter.Value = dataTable;
                        cmd.Parameters.Add(parameter);

                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }

                Log4NetLogger.LogExit(_FileName, nameof(Save), Level.Info.ToString());
                return BulkAuthorization;
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
        #endregion
    }
}
