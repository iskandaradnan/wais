using CP.Framework.Common.ExceptionHandler.ExceptionWrappers;
using CP.Framework.Common.Logging;
using CP.UETrack.BLL.BusinessAccess.Contracts.FEMS;
using CP.UETrack.DAL.DataAccess.Contracts.FEMS;
using CP.UETrack.Model;
using CP.UETrack.Model.BEMS;
using System;
using System.Collections.Generic;
using System.Data;
using System.IO;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CP.UETrack.BLL.BusinessAccess.Implementations
{
   public class FemsStockUpdateRegisterBAL : IFemsStockUpdateRegisterBAL
    {


        private readonly  IFemsStockUpdateRegisterDAL _IStockUpdateRegisterDAL;
        private readonly static string fileName = nameof(FemsStockUpdateRegisterBAL);
        public FemsStockUpdateRegisterBAL(IFemsStockUpdateRegisterDAL IStockUpdateRegisterDAL)
        {
            _IStockUpdateRegisterDAL = IStockUpdateRegisterDAL;

        }

       public void save(ref StockUpdateRegister entity)
        {
            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(save), Level.Info.ToString());
                 _IStockUpdateRegisterDAL.save(ref entity);
                Log4NetLogger.LogExit(fileName, nameof(save), Level.Info.ToString());
               // return result;
            }
            catch (BALException balException)
            {
                throw new BALException(balException);
            }
            catch (Exception)
            {
                throw;
            }
        }
        public void update(ref StockUpdateRegister entity)
        {
            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(update), Level.Info.ToString());
                _IStockUpdateRegisterDAL.update(ref entity);
                Log4NetLogger.LogExit(fileName, nameof(update), Level.Info.ToString());
                // return result;
            }
            catch (BALException balException)
            {
                throw new BALException(balException);
            }
            catch (Exception)
            {
                throw;
            }
        }
        public  StockUpdateRegister Get(int id, int pagesize, int pageindex)
        {
            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(Get), Level.Info.ToString());
                
                Log4NetLogger.LogExit(fileName, nameof(Get), Level.Info.ToString());
                return _IStockUpdateRegisterDAL.Get(id,pagesize,pageindex);
            }
            catch (BALException balException)
            {
                throw new BALException(balException);
            }
            catch (Exception)
            {
                throw;
            }
        }
        public bool Delete(int id)
        {
            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(Delete), Level.Info.ToString());
               
                Log4NetLogger.LogExit(fileName, nameof(Delete), Level.Info.ToString());
                return _IStockUpdateRegisterDAL.Delete(id);
            }
            catch (BALException balException)
            {
                throw new BALException(balException);
            }
            catch (Exception)
            {
                throw;
            }
        }
        public GridFilterResult Getall(SortPaginateFilter pageFilter)
        {
            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(Getall), Level.Info.ToString());

                Log4NetLogger.LogExit(fileName, nameof(Getall), Level.Info.ToString());
                return _IStockUpdateRegisterDAL.Getall( pageFilter);
            }
            catch (BALException balException)
            {
                throw new BALException(balException);
            }
            catch (Exception)
            {
                throw;
            }
        }
        public Dropdownentity Load()
        {
            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(Load), Level.Info.ToString());

                Log4NetLogger.LogExit(fileName, nameof(Load), Level.Info.ToString());
                return _IStockUpdateRegisterDAL.Load();
            }
            catch (BALException balException)
            {
                throw new BALException(balException);
            }
            catch (Exception)
            {
                throw;
            }
        }

        public StockUpdateRegister Upload(ref Upload FileModel, out string ErrorMessage)
        {
            try
            {
                ErrorMessage = string.Empty;
                Log4NetLogger.LogEntry(fileName, nameof(Upload), Level.Info.ToString());
                var filePath = System.IO.Path.Combine(AppDomain.CurrentDomain.BaseDirectory + "App_Data\\Temp\\FileUploads");
                var fullFilePath = System.IO.Path.Combine(filePath, FileModel.fileResponseName);
                if (File.Exists(fullFilePath))
                {
                    File.Delete(fullFilePath);
                }
                var bytes = Convert.FromBase64String(FileModel.contentAsBase64String);
                using (FileStream file = File.Create(fullFilePath))
                {
                    file.Write(bytes, 0, bytes.Length);
                    file.Close();
                }
                var FileData = ConvertCSVtoDataTable(fullFilePath);
                var LinenResultModel = new StockUpdateRegister();
                var partList = new List<ItemMstFetchEntity>();
                foreach (DataRow row in FileData.Rows)
                {
                    var StockUpdate = new StockUpdateRegister
                    {
                    //    //StockUpdateNo = Convert.ToString(row["Stock Update No."].ToString()),
                    //  //  DateUpload = row["Date"] == DBNull.Value ? null : (DateTime?)Convert.ToDateTime(row["Date"].ToString()),
                    //   // TotalCost = Convert.ToInt32(row["Total Spare Part Cost (Currency)"].ToString()),
                    //  //  FacilityCode = Convert.ToString(row["Facility Code"].ToString()),
                    // //   FacilityName = Convert.ToString(row["Facility Name"].ToString()),
                    };
                    var a = new ItemMstFetchEntity
                    {
                        Partno = Convert.ToString(row["Part No."].ToString()),
                        PartDescription = Convert.ToString(row["Part Description"].ToString()),
                        SparePartTypeName = Convert.ToString(row["Spare Part Type"].ToString()),
                        Location= Convert.ToString(row["Location"].ToString()),
                        ItemCode = Convert.ToString(row["Item Code"].ToString()),
                        ItemDescription = Convert.ToString(row["Item Description"].ToString()),
                        PartSource = Convert.ToString(row["Part Source"].ToString()),
                        EstimatedLifeSpanType = Convert.ToString(row["LifeSpan Options"].ToString()),
                        EstimatedLifeSpan = Math.Round(Convert.ToDecimal(row["Estimated Life Span"].ToString().Replace("'", "")), 2),                        
                        StockExpDate = row["Expiry Date"] == DBNull.Value || row["Expiry Date"] == string.Empty ? null : (DateTime?)Convert.ToDateTime(row["Expiry Date"]),
                        Quantity = Math.Round(Convert.ToDecimal(row["Quantity"].ToString().Replace("'", "")), 2),
                        Cost = Math.Round(Convert.ToDecimal(row["ERP Purchase Cost / Pcs (Currency)"].ToString().Replace("'", "")), 2),
                        PurchaseCost = Math.Round(Convert.ToDecimal(row["Cost / Pcs (Currency)"].ToString().Replace("'", "")), 2),
                        InvoiceNo = Convert.ToString(row["Invoice No."].ToString()),
                        VendorName = Convert.ToString(row["Vendor Name"].ToString()),
                        BinNo = Convert.ToString(row["Bin No."].ToString()),
                        Remarks = Convert.ToString(row["Remarks"].ToString()),
                    };
                    partList.Add(a);
                    StockUpdate.ItemMstFetchEntityList = partList;
                    foreach (var item in StockUpdate.ItemMstFetchEntityList)
                    {
                        if(item.Location== "Centralized")
                        {
                            item.LocationId = 41;
                        }
                        else
                        {
                            item.LocationId = 42;
                        }
                        if(item.SparePartTypeName== "Inventory")

                        {
                            item.SparePartType = 37;
                        }
                        else
                        {
                            item.SparePartType = 38;
                        }
                    }
                    foreach (var data in StockUpdate.ItemMstFetchEntityList)
                    {
                        if (data.EstimatedLifeSpanType != "" || data.EstimatedLifeSpanType != string.Empty)
                        {
                            if (data.EstimatedLifeSpanType == "Hour")
                            {
                                data.EstimatedLifeSpanId = 353;
                            }
                            else if (data.EstimatedLifeSpanType == "Day")
                            {
                                data.EstimatedLifeSpanId = 354;
                            }
                            else if (data.EstimatedLifeSpanType == "Month")
                            {
                                data.EstimatedLifeSpanId = 355;
                            }
                            else if (data.EstimatedLifeSpanType == "Year")
                            {
                                data.EstimatedLifeSpanId = 356;
                            }
                            else if (data.EstimatedLifeSpanType == "Expiry Date")
                            {
                                data.EstimatedLifeSpanId = 357;
                            }
                            else if (data.EstimatedLifeSpanType == "Not Applicable")
                            {
                                data.EstimatedLifeSpanId = 358;
                            }
                        }
                    }
                    //if (StockUpdate.DateUpload == null)
                    //{
                    //    ErrorMessage = "Stock Update Date is required.";
                    //}
                    //else
                    //{
                    //    StockUpdate.Date = (DateTime)StockUpdate.DateUpload;
                    //    StockUpdate.DateUTC = StockUpdate.Date;


                    var importOut = _IStockUpdateRegisterDAL.ImportValidation(StockUpdate);
                        if (importOut.ErrorMessage != null)
                        {
                            ErrorMessage = importOut.ErrorMessage.Split(',')[0];
                        }
                        else
                        {
                            //if(FileModel.StockUpdateId==null || FileModel.StockUpdateId == 0)
                            //{
                            //    StockUpdate.StockUpdateNo = "";
                            //}
                                if (StockUpdate.StockUpdateNo == null || StockUpdate.StockUpdateNo == "")
                            {
                                StockUpdate.FacilityId = importOut.FacilityId;
                                StockUpdate.ItemMstFetchEntityList[0].SparePartsId = (int)importOut.SparePartsId;
                                StockUpdate.ItemMstFetchEntityList[0].ItemId = (int)importOut.ItemId;

                               // save(ref StockUpdate);
                            }
                            else
                            {
                                StockUpdate.StockUpdateId = importOut.StockUpdateId;
                                StockUpdate.FacilityId = importOut.FacilityId;
                                StockUpdate.ItemMstFetchEntityList[0].StockUpdateId = importOut.StockUpdateId;
                                StockUpdate.ItemMstFetchEntityList[0].SparePartsId = (int)importOut.SparePartsId;
                                StockUpdate.ItemMstFetchEntityList[0].ItemId = (int)importOut.ItemId;

                              //  update(ref StockUpdate);
                            }
                            FileModel.StockUpdateId = StockUpdate.StockUpdateId;
                            LinenResultModel.ItemMstFetchEntityList = StockUpdate.ItemMstFetchEntityList;
                            if (StockUpdate.ErrorMessage == "" || StockUpdate.ErrorMessage==null) {
                                ErrorMessage = string.Empty;
                               }
                            else
                            {
                                ErrorMessage=StockUpdate.ErrorMessage;
                            }
                        }
                    
                }
                if (LinenResultModel.ItemMstFetchEntityList.Count > 0)
                {
                    FileModel.ItemMstFetchEntityList = LinenResultModel.ItemMstFetchEntityList;
                }
                return LinenResultModel;
            }
            catch (BALException balException)
            {
                throw new BALException(balException);
            }
            catch (Exception ex)
            {
                //throw new Exception("Invalid CSV file has been selected");
                throw new Exception(ex.Message.Replace(".", "") + " or Invalid CSV File has been uploaded");
            }
        }

        public static DataTable ConvertCSVtoDataTable(string strFilePath)
        {
            using (var sr = new StreamReader(strFilePath))
            {
                var t = "";
                var headers = sr.ReadLine().Split(',');
                var dt = new DataTable();
                foreach (string header in headers)
                {
                    if (header.Contains('"'))
                    {
                        t = header.Substring(1, header.Length - 2);
                    }
                    else
                    {
                        t = header;
                    }
                    dt.Columns.Add(t);
                }
                while (!sr.EndOfStream)
                {
                    var rows = sr.ReadLine().Split(',');
                    var dr = dt.NewRow();
                    try
                    {
                        for (int i = 0; i < headers.Length; i++)
                        {
                            if (rows[i].Contains('"'))
                            {
                                t = rows[i].Substring(1, rows[i].Length - 2);
                            }
                            else
                            {
                                t = rows[i];
                            }
                            if (t.ToString().Trim() != "")
                            {
                                dr[i] = t;
                            }
                        }
                    }
                    catch (IndexOutOfRangeException ex)
                    {
                        throw new BALException(ex);
                    }
                    dt.Rows.Add(dr);
                }
                return dt;
            }
        }
    }
}
