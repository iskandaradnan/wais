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
using System.Text;
using System.Threading.Tasks;
using UETrack.DAL;

namespace CP.UETrack.DAL.DataAccess.Implementations.BEMS
{
    public class AssertregisterVariationDetailsTabDAL : IAssertregisterVariationDetailsTabDAL
    {

        private readonly string _FileName = nameof(AssertregisterVariationDetailsTabDAL);
        readonly UserDetailsModel _UserSession = new SessionHelper().UserSession();
        public VariationSaveEntity Save(VariationSaveEntity model/*, out string ErrorMessage*/)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());

                //ErrorMessage = string.Empty;
                var dbAccessDAL = new DBAccessDAL();
                var obj = new EngAssetClassification();
                var parameters = new Dictionary<string, string>();
                //parameters.Add("@pUserId", Convert.ToString(userid));
                //parameters.Add("@pStockUpdateId", Convert.ToString(model.StockUpdateId));
                //parameters.Add("@CustomerId", Convert.ToString(model.CustomerId));
                //parameters.Add("@FacilityId", Convert.ToString(model.FacilityId));
                //parameters.Add("@ServiceId", Convert.ToString(model.ServiceId));
                //parameters.Add("@StockUpdateNo", Convert.ToString(model.StockUpdateNo));
                //parameters.Add("@Date", model.Date.ToString("yyyy-MM-dd h:mm tt"));
                //parameters.Add("@DateUTC", model.DateUTC.ToString("yyyy-MM-dd h:mm tt"));
                //parameters.Add("@TotalCost", Convert.ToString(model.TotalCost));
                ////parameters.Add("@CreatedBy", Convert.ToString(model.CreatedBy));
                ////parameters.Add("@CreatedDate", Convert.ToString(model.CreatedDate));

                var DataSetparameters = new Dictionary<string, DataTable>();
                DataTable dt = new DataTable();
                dt.Columns.Add("VariationId", typeof(int));
                dt.Columns.Add("CustomerId", typeof(int));
                dt.Columns.Add("FacilityId", typeof(int));
                dt.Columns.Add("ServiceId", typeof(int));
                dt.Columns.Add("SNFDocumentNo", typeof(string));
                dt.Columns.Add("SnfDate", typeof(DateTime));

                dt.Columns.Add("AssetId", typeof(int));
                dt.Columns.Add("AssetClassification", typeof(int));
                dt.Columns.Add("VariationStatus", typeof(int));
                dt.Columns.Add("PurchaseProjectCost", typeof(decimal));
                dt.Columns.Add("VariationDate", typeof(DateTime));
                dt.Columns.Add("VariationDateUTC", typeof(DateTime));
                dt.Columns.Add("StartServiceDate", typeof(DateTime));
                dt.Columns.Add("StartServiceDateUTC", typeof(DateTime));
                dt.Columns.Add("ServiceStopDate", typeof(DateTime));
                dt.Columns.Add("ServiceStopDateUTC", typeof(DateTime));
                dt.Columns.Add("CommissioningDate", typeof(DateTime));
                dt.Columns.Add("CommissioningDateUTC", typeof(DateTime));
                dt.Columns.Add("WarrantyDurationMonth", typeof(int));
                dt.Columns.Add("WarrantyStartDate", typeof(DateTime));
                dt.Columns.Add("WarrantyStartDateUTC", typeof(DateTime));
                dt.Columns.Add("WarrantyEndDate", typeof(DateTime));
                dt.Columns.Add("WarrantyEndDateUTC", typeof(DateTime));
                dt.Columns.Add("VariationApprovedStatus", typeof(int));
                dt.Columns.Add("Remarks", typeof(string));
                dt.Columns.Add("AuthorizedStatus", typeof(bool));
                dt.Columns.Add("VariationRaisedDate", typeof(DateTime));
                //dt.Columns.Add("AuthorizedStatus", typeof(bool));1  
                dt.Columns.Add("VariationRaisedDateUTC", typeof(DateTime));
                //dt.Columns.Add("AssetOldVariationData", typeof(bool));
                dt.Columns.Add("VariationWFStatus", typeof(int));
                dt.Columns.Add("PurchaseDate", typeof(DateTime));
                dt.Columns.Add("PurchaseDateUTC", typeof(DateTime));
                dt.Columns.Add("VariationPurchaseCost", typeof(decimal));
                dt.Columns.Add("ContractCost", typeof(decimal));
                dt.Columns.Add("ContractLpoNo", typeof(string));
                dt.Columns.Add("MainSupplierCode", typeof(string));
                dt.Columns.Add("MainSupplierName", typeof(string));
                dt.Columns.Add("CreatedBy", typeof(string));
                // If variation approved In Asset directly fetch to VVF
                foreach (var item in model.SaveList.Where(x => !x.IsDeleted))
                {
                    if (item.AuthorizedStatusForVariation == 373)
                    {
                        item.AuthorizedStatus = null;
                    }
                    else if (item.AuthorizedStatusForVariation == 371)
                    {
                        item.AuthorizedStatus = true;

                    }
                    else if(item.AuthorizedStatusForVariation == 372)
                    {
                        item.AuthorizedStatus = false;
                    }
                    // End
                    //item.StockExpDate = item.CreatedDate = item.CreatedDateUTC = Convert.ToDateTime(DateTime.Now.ToString("yyyy-MM-dd h:mm tt"));
                    dt.Rows.Add(item.VariationId, _UserSession.CustomerId, _UserSession.FacilityId, 2,item.SNFDocumentNo,/*item.SnfDate*/DateTime.Now.Date,item.AssetId,item.AssetClassification
                        ,item.VariationStatus,item.PurchaseProjectCost, item.VariationDate, item.VariationDateUTC,
                                                item.StartServiceDate,
                                                item.StartServiceDate,
                                                item.StopServiceDate,
                                                item.StopServiceDate,
                                                item.CommissioningDate,
                                                item.CommissioningDate,
                                                item.WarrantyDurationMonth,
                                                item.WarrantyStartDate,
                                                item.WarrantyStartDate,
                                                item.WarrantyEndDate,
                                                item.WarrantyEndDate,
                                               
                                                item.VariationApprovedStatus,
                                               
                                                item.Remarks,
                                                item.AuthorizedStatus,
                                                item.VariationDate,
                                                item.VariationDate,
                                                //item.AssetOldVariationData,
                                                item.VariationWFStatus,
                                                item.PurchaseDate,
                                                item.PurchaseDate,
                                                item.VariationPurchaseCost,
                                                item.ContractCost,
                                                item.ContractLpoNo,
                                                item.MainSupplierCode,
                                                item.MainSupplierName,
                                                _UserSession.UserId
                        );

                }
                DataSetparameters.Add("@VmVariationTxn", dt);

                DataTable ds = dbAccessDAL.GetDataTable("uspFM_EngAssetVmVariationTxn_Save", parameters, DataSetparameters);
                if (ds != null)
                {
                    foreach (DataRow row in ds.Rows)
                    {
                        //model.VariationId = Convert.ToInt32(row["VariationId"]);
                        //model.Timestamp = Convert.ToBase64String((byte[])(row["Timestamp"]));
                    }
                    var childList=model.SaveList.Where(x => !x.IsDeleted).ToList();
                    for (var childListindex = 0; childListindex < childList.Count; childListindex++)
                    {
                        for (var irowindex = 0; irowindex < ds.Rows.Count; irowindex++)
                        {
                            if(childListindex== irowindex)
                                childList[childListindex].VariationId= Convert.ToInt32(ds.Rows[irowindex]["VariationId"]);


                        }

                    }
                    

                }
                //if (ds.Tables.Count != 0 && ds.Tables[0].Rows.Count > 0)
                //{
                //    //VariationSaveEntitymodel.VariationId = Convert.ToInt32(ds.Tables[0].Rows[0]["VariationId"]);
                //    VariationSaveEntitymodel.Timestamp = Convert.ToBase64String((byte[])(ds.Tables[0].Rows[0]["Timestamp"]));
                //   // ErrorMessage = Convert.ToString(ds.Tables[0].Rows[0]["ErrorMessage"]);
                  
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
                throw;
            }
        }
        public List<Varabledetails> FetchSNFRef(Varabledetails entity)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(FetchSNFRef), Level.Info.ToString());
                var obl = new List<Varabledetails>();

                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_Dropdown";
                        cmd.Parameters.AddWithValue("@pLovKey", "ActionStatusValue");
                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);

                        if (ds.Tables.Count != 0)
                        {
                            entity.YesNoList = dbAccessDAL.GetLovRecords(ds.Tables[0]);
                        }
                        ds.Clear();
                    }
                }

                using (var con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    var cmd = new SqlCommand();
                    using (SqlDataAdapter da = new SqlDataAdapter())
                    {
                        using (DataTable dt = new DataTable())
                        {
                            using (cmd = new SqlCommand("UspFM_EngAssetVmVariation_GetByAssetId", con))
                            {
                                cmd.Parameters.Add(new SqlParameter("@pAssetId", entity.AssetId));
                               // cmd.Parameters.Add(new SqlParameter("@pFacilityId", _UserSession.FacilityId));
                                cmd.Parameters.Add(new SqlParameter("@pPageIndex", 1));
                                cmd.Parameters.Add(new SqlParameter("@pPageSize", 5));
                                // cmd.Parameters.Add(new SqlParameter("@pageIndex", pageIndex));
                                cmd.CommandType = CommandType.StoredProcedure;
                                da.SelectCommand = cmd;
                                da.Fill(dt);

                                var myEnumerable = dt.AsEnumerable();
                                obl =
                                    (from item in myEnumerable
                                     select new Varabledetails
                                     {
                                         TestingandCommissioningId=item.Field<int>("TestingandCommissioningId"),
                                         SNFDocumentNo = item.Field<string>("SNFDocumentNo"),
                                         VariationStatusName = item.Field<string>("VariationStatusLovName"),
                                         PurchaseProjectCost = item.Field<Nullable<decimal>>("PurchaseProjectCost"),
                                         VariationDate = item["VariationDate"] == DBNull.Value ? DateTime.MinValue : Convert.ToDateTime((item["VariationDate"])),
                                         StartServiceDate = item["StartServiceDate"] == DBNull.Value ? DateTime.MinValue : Convert.ToDateTime((item["StartServiceDate"])),
                                         StopServiceDate = item["StopServiceDate"] == DBNull.Value ? DateTime.MinValue : Convert.ToDateTime((item["StopServiceDate"])),
                                         CommissioningDate = item["CommissioningDate"] == DBNull.Value ? DateTime.MinValue : Convert.ToDateTime((item["CommissioningDate"])),
                                         WarrantyEndDate = item["WarrantyEndDate"] == DBNull.Value ? DateTime.MinValue : Convert.ToDateTime((item["WarrantyEndDate"])),
                                         VariationMonth = item.Field<Nullable<int>>("VariationMonth"),
                                         VariationYear = item.Field<Nullable<int>>("VariationYear"),
                                         VariationApprovedStatusLovName = item.Field<string>("VariationApprovedStatusLovName"),
                                         VariationStatusLovId=item.Field<int?>("VariationStatusLovId"),
                                         VariationApprovedStatusLovId = item.Field<int?>("VariationApprovedStatusLovId"),
                                         AssetClassification = item.Field<int?>("AssetClassification"),
                                         WarrantyDuration = item.Field<int?>("WarrantyDuration"),
                                         WarrantyStartDate = item["WarrantyStartDate"] == DBNull.Value ? DateTime.MinValue : Convert.ToDateTime((item["WarrantyStartDate"])),
                                         MainSupplierName = item.Field<string>("MainSupplierName"),
                                         MainSupplierCode = item.Field<string>("MainSupplierCode"),
                                         ContractLPONo = item.Field<string>("ContractLPONo"),
                                         VariationId = item["VariationId"] == DBNull.Value ? 0:item.Field<int>("VariationId"),
                                         AssetId = entity.AssetId,
                                         VariationMonthName=item.Field<string>("VariationMonthName"),                                         
                                         AuthorizedStatus= item.Field <bool ?>("AuthorizedStatus"),
                                     }).ToList();
                            }
                        }
                    }
                    cmd.Dispose();
                  
                }
                obl.FirstOrDefault().YesNoList = entity.YesNoList;
                obl.ForEach((x) => { if (x.WarrantyStartDate == DateTime.MinValue) { x.WarrantyStartDate = null; }
                    if (x.StopServiceDate == DateTime.MinValue)
                    {
                        x.StopServiceDate = null;
                    } });
                // If variation approved In Asset directly fetch to VVF
                foreach (var item in obl)
                {
                    if (item.AuthorizedStatus == null)
                    {
                        item.AuthorizedStatusForVariation = 373;
                    }
                    else if ((bool)item.AuthorizedStatus)
                    {
                        item.AuthorizedStatusForVariation = 371;

                    }
                    else
                    {
                        item.AuthorizedStatusForVariation = 372;
                    }
                }
                //End

                Log4NetLogger.LogExit(_FileName, nameof(FetchSNFRef), Level.Info.ToString());
                return obl.ToList();
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
        public VaritableDetailsList FetchSNFRef1(Varabledetails entity)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(FetchSNFRef), Level.Info.ToString());
                var result = new VaritableDetailsList();

                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_Dropdown";
                        cmd.Parameters.AddWithValue("@pLovKey", "ActionStatusValue");
                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);

                        if (ds.Tables.Count != 0)
                        {
                            entity.YesNoList = dbAccessDAL.GetLovRecords(ds.Tables[0]);
                        }
                        ds.Clear();
                    }
                }

                using (var con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    var cmd = new SqlCommand();
                    using (SqlDataAdapter da = new SqlDataAdapter())
                    {
                        using (DataTable dt = new DataTable())
                        {
                            using (cmd = new SqlCommand("UspFM_EngAssetVmVariation_GetByAssetId", con))
                            {
                                cmd.Parameters.Add(new SqlParameter("@pAssetId", entity.AssetId));
                                cmd.Parameters.Add(new SqlParameter("@pPageIndex", 1));
                                cmd.Parameters.Add(new SqlParameter("@pPageSize", 5));
                                cmd.CommandType = CommandType.StoredProcedure;
                                da.SelectCommand = cmd;
                                da.Fill(dt);

                                var myEnumerable = dt.AsEnumerable();
                                var obl =
                                    (from item in myEnumerable
                                     select new Varabledetails
                                     {
                                         TestingandCommissioningId = item.Field<int>("TestingandCommissioningId"),
                                         SNFDocumentNo = item.Field<string>("SNFDocumentNo"),
                                         VariationStatusName = item.Field<string>("VariationStatusLovName"),
                                         PurchaseProjectCost = item.Field<Nullable<decimal>>("PurchaseProjectCost"),
                                         VariationDate = item["VariationDate"] == DBNull.Value ? DateTime.MinValue : Convert.ToDateTime((item["VariationDate"])),
                                         StartServiceDate = item["StartServiceDate"] == DBNull.Value ? DateTime.MinValue : Convert.ToDateTime((item["StartServiceDate"])),
                                         StopServiceDate = item["StopServiceDate"] == DBNull.Value ? DateTime.MinValue : Convert.ToDateTime((item["StopServiceDate"])),
                                         CommissioningDate = item["CommissioningDate"] == DBNull.Value ? DateTime.MinValue : Convert.ToDateTime((item["CommissioningDate"])),
                                         WarrantyEndDate = item["WarrantyEndDate"] == DBNull.Value ? DateTime.MinValue : Convert.ToDateTime((item["WarrantyEndDate"])),
                                         VariationMonth = item.Field<Nullable<int>>("VariationMonth"),
                                         VariationYear = item.Field<Nullable<int>>("VariationYear"),
                                         VariationApprovedStatusLovName = item.Field<string>("VariationApprovedStatusLovName"),
                                         VariationStatusLovId = item.Field<int?>("VariationStatusLovId"),
                                         VariationApprovedStatusLovId = item.Field<int?>("VariationApprovedStatusLovId"),
                                         AssetClassification = item.Field<int?>("AssetClassification"),
                                         WarrantyDuration = item.Field<int?>("WarrantyDuration"),
                                         WarrantyStartDate = item["WarrantyStartDate"] == DBNull.Value ? DateTime.MinValue : Convert.ToDateTime((item["WarrantyStartDate"])),
                                         MainSupplierName = item.Field<string>("MainSupplierName"),
                                         MainSupplierCode = item.Field<string>("MainSupplierCode"),
                                         ContractLPONo = item.Field<string>("ContractLPONo"),
                                         VariationId = item["VariationId"] == DBNull.Value ? 0 : item.Field<int>("VariationId"),
                                         VariationMonthName = item.Field<string>("VariationMonthName"),
                                         AuthorizedStatus = item.Field<bool?>("AuthorizedStatus"),
                                         AssetId = entity.AssetId
                                     }).ToList();

                                obl.ForEach((x) => {
                                    if (x.WarrantyStartDate == DateTime.MinValue) { x.WarrantyStartDate = null; }
                                    if (x.StopServiceDate == DateTime.MinValue)
                                    {
                                        x.StopServiceDate = null;
                                    }
                                   
                                });
                                foreach (var item in obl)
                                {
                                    if (item.AuthorizedStatus == null)
                                    {
                                        item.AuthorizedStatusForVariation = 373;
                                    }
                                    else if ((bool)item.AuthorizedStatus)
                                    {
                                        item.AuthorizedStatusForVariation = 371;

                                    }
                                    else
                                    {
                                        item.AuthorizedStatusForVariation = 372;
                                    }
                                }
                                result.detailsList = obl;
                            }
                        }
                    }
                    cmd.Dispose();

                }
                result.YesNoList = entity.YesNoList;

                Log4NetLogger.LogExit(_FileName, nameof(FetchSNFRef), Level.Info.ToString());
                return result;
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
