using CP.UETrack.DAL.DataAccess.Contracts.BEMS;
using CP.UETrack.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using CP.UETrack.Model.BEMS;
using CP.Framework.Common.Logging;
using System.Data;
using UETrack.DAL;
using CP.UETrack.Models;
using System.Data.SqlClient;
using CP.Framework.Common.ExceptionHandler.ExceptionWrappers;

namespace CP.UETrack.DAL.DataAccess.Implementations.BEMS
{
    public class MonthlyStockRegisterDAL : IMonthlyStockRegisterDAL
    {
        private readonly string _FileName = nameof(MonthlyStockRegisterDAL);
        readonly UserDetailsModel _UserSession = new SessionHelper().UserSession();

        public MonthlyStockRegisterTypeDropdown Load()
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
                var MonthlyStockRegisterTypeDropdown = new MonthlyStockRegisterTypeDropdown();

                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                var currentYear = DateTime.Now.Year;
                var prevoiusYear = currentYear - 1;
                MonthlyStockRegisterTypeDropdown.Years = new List<LovValue> { new LovValue { LovId = currentYear, FieldValue = currentYear.ToString() }, new LovValue { LovId = prevoiusYear, FieldValue = prevoiusYear.ToString() } };
                MonthlyStockRegisterTypeDropdown.CurrentYear = currentYear;
                
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_Dropdown_Others";
                        cmd.Parameters.AddWithValue("@pTablename", "FinMonthlyFeeTxn");
                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);

                        if (ds.Tables.Count != 0)
                        {
                             MonthlyStockRegisterTypeDropdown.MonthListTypedata = dbAccessDAL.GetLovRecords(ds.Tables[0]);
                        }
                        ds.Clear();
                        cmd.CommandText = "uspFM_Dropdown";
                        cmd.Parameters.Clear();
                        cmd.Parameters.AddWithValue("@pLovKey", "StockTypeValue");
                        da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);

                        if (ds.Tables.Count != 0)
                        {
                            MonthlyStockRegisterTypeDropdown.SparePartTypedata = dbAccessDAL.GetLovRecords(ds.Tables[0]);
                        }

                    }
                }
                Log4NetLogger.LogExit(_FileName, nameof(Load), Level.Info.ToString());
                return MonthlyStockRegisterTypeDropdown;
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

        public MonthlyStockRegisterModel Get(MonthlyStockRegisterModel MonthlyStock)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
            try
            {
                var dbAccessDAL = new DBAccessDAL();
                 var entity = new ItemMonthlyStockRegisterList();

                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
               // parameters.Add("@pFacilityId", Convert.ToString(_UserSession.FacilityId));
                parameters.Add("@pYear", Convert.ToString(MonthlyStock.Year));
                parameters.Add("@pMonth", Convert.ToString(MonthlyStock.Month));
                parameters.Add("@pPartNo", Convert.ToString(MonthlyStock.PartNo));
                parameters.Add("@pPartDescription", Convert.ToString(MonthlyStock.PartDescription));
                parameters.Add("@pItemCode", Convert.ToString(MonthlyStock.ItemCode));
                parameters.Add("@pItemDescription", Convert.ToString(MonthlyStock.ItemDescription));
                parameters.Add("@pSparePartType", Convert.ToString(MonthlyStock.SparePartTypeName));                
                parameters.Add("@pPageIndex", Convert.ToString(MonthlyStock.PageIndex));
                parameters.Add("@pPageSize", Convert.ToString(MonthlyStock.PageSize));
                parameters.Add("@pCustomerId", Convert.ToString(_UserSession.CustomerId));


                DataTable dt = dbAccessDAL.GetDataTable("uspFM_EngStockMonthlyRegisterTxn_Fetch", parameters, DataSetparameters);
                if (dt != null && dt.Rows.Count > 0)
                {
                   // MonthlyStock.Year = Convert.ToInt32(dt.Rows[0]["Year"]);
                   // MonthlyStock.Month = Convert.ToInt32(dt.Rows[0]["Month"]);
                    MonthlyStock.SparePartsId= Convert.ToInt32(dt.Rows[0]["SparePartsId"]);
                    MonthlyStock.PartNo = Convert.ToString(dt.Rows[0]["PartNo"]);
                    MonthlyStock.PartDescription = Convert.ToString(dt.Rows[0]["PartDescription"]);
                    MonthlyStock.ItemCode = Convert.ToString(dt.Rows[0]["ItemNo"]);
                    MonthlyStock.ItemDescription = Convert.ToString(dt.Rows[0]["ItemDescription"]);
                    MonthlyStock.SparePartTypeName = Convert.ToString(dt.Rows[0]["StockType"]);
                }
                DataSet dt1 = dbAccessDAL.GetDataSet("uspFM_EngStockMonthlyRegisterTxn_Fetch", parameters, DataSetparameters);
                if (dt1 != null && dt1.Tables.Count > 0)
                {

                    MonthlyStock.MonthlyStockRegisterListData = (from n in dt1.Tables[0].AsEnumerable()
                                                        select new ItemMonthlyStockRegisterList
                                                        {
                                                           // Year = Convert.ToInt32(n["Year"]),
                                                           // Month = Convert.ToInt32(n["Month"]),
                                                            FacilityCode = Convert.ToString(n["FacilityCode"]),
                                                            FacilityName = Convert.ToString(n["FacilityName"]),
                                                            BinNo = Convert.ToString(n["BinNo"]),
                                                            SparePartsId = Convert.ToInt32(n["SparePartsId"]),
                                                            PartNo = Convert.ToString(n["PartNo"]),
                                                            PartDescription = Convert.ToString(n["PartDescription"]),
                                                            ItemCode = Convert.ToString(n["ItemNo"]),
                                                            ItemDescription = Convert.ToString(n["ItemDescription"]),
                                                            SparePartTypeName = Convert.ToString(n["StockType"]),
                                                            UOM = Convert.ToString(n["UOM"]),                                                            
                                                            MinimumLevel = Convert.ToDecimal(n["MinimumLevel"]),
                                                            CurrentQuantity = Convert.ToDecimal(n["CURRENTQUANTITY"]),
                                                            ClosingMonthQuantity = Convert.ToDecimal(n["PREVIOUSQUANTITY"]),

                                                            TotalRecords = Convert.ToInt32(n["TotalRecords"]),
                                                            TotalPages = Convert.ToInt32(n["TotalPageCalc"]),
                                                        }).ToList();

                    MonthlyStock.MonthlyStockRegisterListData.ForEach((x) =>
                    {
                        x.PageSize = MonthlyStock.PageSize;
                        x.PageIndex = MonthlyStock.PageIndex;
                        x.FirstRecord = ((MonthlyStock.PageIndex - 1) * MonthlyStock.PageSize) + 1;
                        x.LastRecord = ((MonthlyStock.PageIndex - 1) * MonthlyStock.PageSize) + MonthlyStock.PageSize;  
                        x.LastPageIndex=  x.TotalRecords % MonthlyStock.PageSize == 0 ? x.TotalRecords / MonthlyStock.PageSize : (x.TotalRecords / MonthlyStock.PageSize) + 1;
                        x.Remarks = x.Remarks == null ? string.Empty : x.Remarks;
                    });

                }               

                Log4NetLogger.LogExit(_FileName, nameof(Get), Level.Info.ToString());
                return MonthlyStock;

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

        public MonthlyStockRegisterModel GetModal(ItemMonthlyStockRegisterModal MonthlyReg)      
        {
            Log4NetLogger.LogEntry(_FileName, nameof(GetModal), Level.Info.ToString());
            try
            {
                var dbAccessDAL = new DBAccessDAL();                
                var MonthlyStock =new MonthlyStockRegisterModel();

                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                
                parameters.Add("@pUserId", Convert.ToString(_UserSession.UserId));
                parameters.Add("@pSparePartsId", Convert.ToString(MonthlyReg.SparePartsId));
                parameters.Add("@pYear", Convert.ToString(MonthlyReg.Year));
                parameters.Add("@pMonth", Convert.ToString(MonthlyReg.Month));
                parameters.Add("@pBinNo", Convert.ToString(MonthlyReg.BinNo));
                //parameters.Add("@pPageIndex", Convert.ToString(1));
                //parameters.Add("@pPageSize", Convert.ToString(5));

                DataSet dt = dbAccessDAL.GetDataSet("UspFM_EngStockMonthlyRegisterTxnDetPopup_GetById", parameters, DataSetparameters);
                if (dt != null && dt.Tables.Count > 0)
                {
                    MonthlyStock.MonthlyStockRegisterModalData = (from n in dt.Tables[0].AsEnumerable()
                                                                  select new ItemMonthlyStockRegisterModal
                                                                  {
                                                                      //Year = Convert.ToInt32(n["Year"]),
                                                                     // Month = Convert.ToInt32(n["Month"]),
                                                                      SparePartsId = Convert.ToInt32(n["SparePartsId"]),
                                                                      PartNo = Convert.ToString(n["PartNo"]),
                                                                      PartDescription = Convert.ToString(n["PartDescription"]),
                                                                      CurrentQuantity = Convert.ToDecimal(n["Quantity"]),
                                                                      Cost = Convert.ToDecimal(n["Cost"]),
                                                                      PurchaseCost = Convert.ToDecimal(n["PurchaseCost"]),
                                                                      InvoiceNo = Convert.ToString(n["InvoiceNo"]),
                                                                      VendorName = Convert.ToString(n["VendorName"]),

                                                                      //TotalRecords = Convert.ToInt32(n["TotalRecords"]),
                                                                      //TotalPages = Convert.ToInt32(n["TotalPageCalc"]),

                                                                  }).ToList();

                    //MonthlyStock.MonthlyStockRegisterModalData.ForEach((x) =>
                    //{

                    //    x.PageIndex = MonthlyStock.PageIndex;
                    //    x.FirstRecord = ((MonthlyStock.PageIndex - 1) * MonthlyStock.PageSize) + 1;
                    //    x.LastRecord = ((MonthlyStock.PageIndex - 1) * MonthlyStock.PageSize) + MonthlyStock.PageSize;
                    //    x.Remarks = x.Remarks == null ? string.Empty : x.Remarks;
                    //});

                }
                Log4NetLogger.LogExit(_FileName, nameof(GetModal), Level.Info.ToString());
                return MonthlyStock;

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

        public GridFilterResult GetAll(SortPaginateFilter pageFilter)
        {
            throw new NotImplementedException();
        }

        public bool IsMonthlyStockRegisterCodeDuplicate(MonthlyStockRegisterModel MonthlyStock)
        {
            throw new NotImplementedException();
        }

        public bool IsRecordModified(MonthlyStockRegisterModel MonthlyStock)
        {
            throw new NotImplementedException();
        }

        public MonthlyStockRegisterModel Save(MonthlyStockRegisterModel MonthlyStock)
        {
            throw new NotImplementedException();
        }
        public bool Delete(int Id)
        {
            throw new NotImplementedException();
        }
    }
}
