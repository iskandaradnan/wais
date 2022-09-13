using CP.Framework.Common.ExceptionHandler.ExceptionWrappers;
using CP.Framework.Common.Logging;
using CP.UETrack.DAL.DataAccess.Contracts.FEMS;
using CP.UETrack.DAL.DataAccess.Implementation;
using CP.UETrack.DAL.DataAccess.Implementations.Common;
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

namespace CP.UETrack.DAL.DataAccess.Implementations.FEMS
{
  public  class FemsStockUpdateRegisterDAL : IFemsStockUpdateRegisterDAL
    {

        private readonly string _FileName = nameof(FemsStockUpdateRegisterDAL);
        readonly UserDetailsModel _UserSession = new SessionHelper().UserSession();
        public Dropdownentity Load()
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
                Dropdownentity Dropdownentityval = new Dropdownentity();
                var ds = new DataSet();
                var dbAccessDAL = new FEMSDBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_Dropdown";
                        cmd.Parameters.AddWithValue("@pLovKey", "StockTypeValue");
                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);

                        if (ds.Tables.Count != 0)
                        {                            
                            Dropdownentityval.SparepartTypeList = dbAccessDAL.GetLovRecords(ds.Tables[0]);                            
                        }
                        ds.Clear();
                        cmd.Parameters.Clear();
                        cmd.Parameters.AddWithValue("@pLovKey", "SparePartStockLocationValue");
                        da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);

                        if (ds.Tables.Count != 0)
                        {
                            Dropdownentityval.SparepartLocationList = dbAccessDAL.GetLovRecords(ds.Tables[0]);
                        }
                    }
                }
                Log4NetLogger.LogExit(_FileName, nameof(Load), Level.Info.ToString());
                return Dropdownentityval;
            }
            catch (DALException dalex)
            {
                throw new DALException(dalex);
            }
            catch (Exception e)
            {
                throw;
            }
        }
        public void save(ref StockUpdateRegister model)
        {
            try {
                Log4NetLogger.LogEntry(_FileName, nameof(save), Level.Info.ToString());       
               
                var formatkey = "[ModuleName][ScreenName][YearMonth]";
                var documentIdKeyFormat = new DocumentIdKeyFormat
                {                    
                    Year = DateTime.Now.Year,
                    Month = DateTime.Now.Month,
                    Formatkey = formatkey,
                    ScreenName = "Biomedical Engineering Maintenance Services",
                    ModuleName = "BEMS",
                    AutoGenarateProp = "StockUpdateNo"
                };
                var docnumber = AutoGenerateNumberDAL.AutoGenerate(model, documentIdKeyFormat);

                model.StockUpdateNo = (docnumber);
                model.ServiceId = 2;
                model.TotalCost = model.ItemMstFetchEntityList.Where(x => !x.IsDeleted).Sum(x => x.Cost*x.Quantity);
                model.CreatedDate = DateTime.Now;
                var dbAccessDAL = new FEMSDBAccessDAL();
                var obj = new EngAssetClassification();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pUserId", Convert.ToString(_UserSession.UserId));
                parameters.Add("@pStockUpdateId", Convert.ToString(model.StockUpdateId));
                parameters.Add("@CustomerId", Convert.ToString(_UserSession.CustomerId));
                parameters.Add("@FacilityId", Convert.ToString(_UserSession.FacilityId));
                parameters.Add("@ServiceId", Convert.ToString(model.ServiceId));
                parameters.Add("@StockUpdateNo", Convert.ToString(model.StockUpdateNo));
                parameters.Add("@Date", model.Date.ToString("yyyy-MM-dd h:mm tt"));
                parameters.Add("@DateUTC", model.DateUTC.ToString("yyyy-MM-dd h:mm tt"));
                parameters.Add("@TotalCost", Convert.ToString(model.TotalCost));
                //parameters.Add("@CreatedBy", Convert.ToString(model.CreatedBy));
                //parameters.Add("@CreatedDate", Convert.ToString(model.CreatedDate));

                var DataSetparameters = new Dictionary<string, DataTable>();
                DataTable dt = new DataTable();
                dt.Columns.Add("StockUpdateDetId", typeof(int));
                dt.Columns.Add("CustomerId", typeof(int));
                dt.Columns.Add("FacilityId", typeof(int));
                dt.Columns.Add("ServiceId", typeof(int));
                dt.Columns.Add("StockUpdateId", typeof(int));
                dt.Columns.Add("SparePartsId", typeof(int));
                dt.Columns.Add("StockExpiryDate", typeof(DateTime));
                dt.Columns.Add("StockExpiryDateUTC", typeof(DateTime));
                dt.Columns.Add("Quantity", typeof(decimal));
                dt.Columns.Add("Cost", typeof(decimal));
                dt.Columns.Add("PurchaseCost", typeof(decimal));
                dt.Columns.Add("InvoiceNo", typeof(string));
                dt.Columns.Add("Remarks", typeof(string));
                dt.Columns.Add("CreatedBy", typeof(int));
                dt.Columns.Add("CreatedDate", typeof(DateTime));
                dt.Columns.Add("CreatedDateUTC", typeof(DateTime));
                dt.Columns.Add("ModifiedBy", typeof(int));
                dt.Columns.Add("ModifiedDate", typeof(DateTime));
                dt.Columns.Add("ModifiedDateUTC", typeof(DateTime));
                dt.Columns.Add("PartNo", typeof(string));
                dt.Columns.Add("VendorName", typeof(string));
                dt.Columns.Add("EstimatedLifeSpan", typeof(decimal));
                dt.Columns.Add("EstimatedLifeSpanId", typeof(int));
                dt.Columns.Add("BinNo", typeof(string));
                dt.Columns.Add("SparePartType", typeof(int));
                dt.Columns.Add("LocationId", typeof(int));

                foreach (var item in model.ItemMstFetchEntityList.Where(x => !x.IsDeleted))
                {
                    item.CreatedDate = item.CreatedDateUTC = Convert.ToDateTime(DateTime.Now.ToString("yyyy-MM-dd h:mm tt"));
                    dt.Rows.Add(0, _UserSession.CustomerId, _UserSession.FacilityId, model.ServiceId, item.StockUpdateId, item.SparePartsId, 
                        item.StockExpDate, item.StockExpDate, item.Quantity, item.Cost, item.PurchaseCost, item.InvoiceNo, item.Remarks, _UserSession.UserId,
                        item.CreatedDate, item.CreatedDateUTC, _UserSession.UserId, item.ModifiedDateUTC,item.ModifiedDate, item.Partno,
                        item.VendorName, item.EstimatedLifeSpan,item.EstimatedLifeSpanId,item.BinNo,item.SparePartType,item.LocationId);
                }
                DataSetparameters.Add("@EngStockUpdateRegisterTxnDet", dt);

                DataTable ds = dbAccessDAL.GetDataTable("uspFM_EngStockUpdateRegisterTxn_Save", parameters, DataSetparameters);
                if (ds != null)
                {
                    foreach (DataRow row in ds.Rows)
                    {
                        model.StockUpdateId = Convert.ToInt32(row["StockUpdateId"]);
                        model.Timestamp = Convert.ToBase64String((byte[])(row["Timestamp"]));
                        model.ErrorMessage = Convert.ToString(row["ErrorMessage"]);
                    }
                }
                if (model.ErrorMessage == "" || model.ErrorMessage == null)
                {
                    model = Get(model.StockUpdateId, 5, 1);

                }
                Log4NetLogger.LogEntry(_FileName, nameof(save), Level.Info.ToString());

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

     
        public void update(ref StockUpdateRegister model)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(update), Level.Info.ToString());
              
                //if (model.StockUpdateId == 0)
                //    model.StockUpdateNo = "newdocumenttss";
                model.ServiceId = 2;
                model.TotalCost = model.ItemMstFetchEntityList.Where(x => !x.IsDeleted).Sum(x=>x.Cost * x.Quantity);
                model.CreatedDate = DateTime.Now;
                var dbAccessDAL = new FEMSDBAccessDAL();
                var obj = new EngAssetClassification();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pUserId", Convert.ToString(_UserSession.UserId));
                parameters.Add("@pStockUpdateId", Convert.ToString(model.StockUpdateId));
                parameters.Add("@CustomerId", Convert.ToString(_UserSession.CustomerId));
                parameters.Add("@FacilityId", Convert.ToString(_UserSession.FacilityId));
                parameters.Add("@ServiceId", Convert.ToString(model.ServiceId));
                parameters.Add("@StockUpdateNo", Convert.ToString(model.StockUpdateNo));
                parameters.Add("@Date",model.Date.ToString("yyyy-MM-dd h:mm tt"));
                parameters.Add("@DateUTC", model.DateUTC.ToString("yyyy-MM-dd h:mm tt"));
                parameters.Add("@TotalCost", Convert.ToString(model.TotalCost));
                //parameters.Add("@CreatedBy", Convert.ToString(model.CreatedBy));
                //parameters.Add("@CreatedDate", Convert.ToString(model.CreatedDate));

                var DataSetparameters = new Dictionary<string, DataTable>();
                DataTable dt = new DataTable();
                dt.Columns.Add("StockUpdateDetId", typeof(int));
                dt.Columns.Add("CustomerId", typeof(int));
                dt.Columns.Add("FacilityId", typeof(int));
                dt.Columns.Add("ServiceId", typeof(int));
                dt.Columns.Add("StockUpdateId", typeof(int));
                dt.Columns.Add("SparePartsId", typeof(int));
                dt.Columns.Add("StockExpiryDate", typeof(DateTime));
                dt.Columns.Add("StockExpiryDateUTC", typeof(DateTime));
                dt.Columns.Add("Quantity", typeof(decimal));
                dt.Columns.Add("Cost", typeof(decimal));
                dt.Columns.Add("PurchaseCost", typeof(decimal));
                dt.Columns.Add("InvoiceNo", typeof(string));
                dt.Columns.Add("Remarks", typeof(string));
                dt.Columns.Add("CreatedBy", typeof(int));
                dt.Columns.Add("CreatedDate", typeof(DateTime));
                dt.Columns.Add("CreatedDateUTC", typeof(DateTime));
                dt.Columns.Add("ModifiedBy", typeof(int));
                dt.Columns.Add("ModifiedDate", typeof(DateTime));
                dt.Columns.Add("ModifiedDateUTC", typeof(DateTime));
                dt.Columns.Add("PartNo", typeof(string));
                dt.Columns.Add("VendorName", typeof(string));
                dt.Columns.Add("EstimatedLifeSpan", typeof(decimal));
                dt.Columns.Add("EstimatedLifeSpanId", typeof(int));
                dt.Columns.Add("BinNo", typeof(string));
                dt.Columns.Add("SparePartType", typeof(int));
                dt.Columns.Add("LocationId", typeof(int));

                var deletedId = model.ItemMstFetchEntityList.Where(y => y.IsDeleted).Select(x => x.StockUpdateDetId).ToList();
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
                foreach (var item in model.ItemMstFetchEntityList.Where(x => !x.IsDeleted))
                {
                    item.CreatedDate = item.CreatedDateUTC =Convert.ToDateTime(DateTime.Now.ToString("yyyy-MM-dd h:mm tt"));
                    dt.Rows.Add(item.StockUpdateDetId, _UserSession.CustomerId, _UserSession.FacilityId, model.ServiceId, item.StockUpdateId, 
                        item.SparePartsId, item.StockExpDate, item.StockExpDate, item.Quantity, item.Cost, item.PurchaseCost, item.InvoiceNo,item.Remarks,
                        _UserSession.UserId, item.CreatedDate, item.CreatedDateUTC, _UserSession.UserId,item.ModifiedDateUTC,item.ModifiedDate,item.Partno,
                        item.VendorName,item.EstimatedLifeSpan,item.EstimatedLifeSpanId,item.BinNo,item.SparePartType,item.LocationId);

                }
                DataSetparameters.Add("@EngStockUpdateRegisterTxnDet", dt);
                DataTable ds = dbAccessDAL.GetDataTable("uspFM_EngStockUpdateRegisterTxn_Save", parameters, DataSetparameters);
                if (ds != null)
                {
                    foreach (DataRow row in ds.Rows)
                    {
                        model.StockUpdateId = Convert.ToInt32(row["StockUpdateId"]);
                        model.Timestamp = Convert.ToBase64String((byte[])(row["Timestamp"]));
                        model.ErrorMessage = Convert.ToString(row["ErrorMessage"]);
                    }
                }
                if (model.ErrorMessage == "")
                {
                    model = Get(model.StockUpdateId, 5, 1);

                }
                Log4NetLogger.LogEntry(_FileName, nameof(update), Level.Info.ToString());
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
        public StockUpdateRegister Get(int id,int pagesize,int pageindex)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
                StockUpdateRegister StockUpdateRegister = null;
                var ds = new DataSet();
                var dbAccessDAL = new FEMSDBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "UspFM_EngStockUpdateRegisterTxn_GetById";
                        cmd.Parameters.AddWithValue("@pStockUpdateId", id);
                        cmd.Parameters.AddWithValue("@pUserId", _UserSession.UserId);
                        cmd.Parameters.AddWithValue("@pPageIndex", pageindex);
                        cmd.Parameters.AddWithValue("@pPageSize", pagesize);
                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }
                if (ds.Tables.Count != 0 && ds.Tables[0].Rows.Count > 0 /*&& ds.Tables[1].Rows.Count > 0
                   && ds.Tables[2].Rows.Count > 0 && ds.Tables[3].Rows.Count > 0*/)
                {
                    StockUpdateRegister = (from n in ds.Tables[0].AsEnumerable()
                                           select new StockUpdateRegister
                                           {
                                               StockUpdateId = n.Field<int>("StockUpdateId"),
                                               CustomerId = n.Field<int>("CustomerId"),
                                               //FacilityId = n.Field<int>("FacilityCode"),
                                               FacilityCode = n.Field<string>("FacilityCode"),
                                               FacilityName = n.Field<string>("FacilityName"),
                                               ServiceId = n.Field<int>("ServiceId"),
                                               StockUpdateNo = n.Field<string>("StockUpdateNo"),
                                               Date = n.Field<DateTime>("Date"),
                                               DateUTC = n.Field<DateTime>("DateUTC"),
                                               //TotalCost = n.Field<decimal?>("TotalCost"),
                                               //SparePartsId = Convert.ToInt32(n["SparePartsId"]),
                                               //Timestamp = Convert.ToBase64String((byte[])(n["Timestamp"]))
                                           }).FirstOrDefault();

                    StockUpdateRegister.ItemMstFetchEntityList = (from n in ds.Tables[0].AsEnumerable()
                                                                  select new ItemMstFetchEntity
                                                                  {
                                                                      SparePartsId = Convert.ToInt32(n["SparePartsId"]),
                                                                      ItemId = 1,
                                                                      StockUpdateId = Convert.ToInt32(n["StockUpdateId"]),
                                                                      StockUpdateDetId = Convert.ToInt32(n["StockUpdateDetId"]),
                                                                      Partno = n.Field<string>("PartNo"),
                                                                      PartDescription = n.Field<string>("PartDescription"),
                                                                      SparePartType = n.Field<int>("SparePartType"),
                                                                      SparePartTypeName= n.Field<string>("SparePartTypeName") == null ? "" : n.Field<string>("SparePartTypeName"),
                                                                      LocationId = n.Field<int>("LocationId"),
                                                                      Location = n.Field<string>("Location") == null ? "" : n.Field<string>("Location"),
                                                                      ItemCode = n.Field<string>("ItemNo"),
                                                                      ItemDescription = n.Field<string>("ItemDescription"),
                                                                      EstimatedLifeSpanId = Convert.ToInt32(n["EstimatedLifeSpanId"]),
                                                                      EstimatedLifeSpanType = n.Field<string>("LifeSpanOptionValue"),
                                                                      EstimatedLifeSpan = n.Field<decimal?>("EstimatedLifeSpan"), //Convert.ToDecimal(n["EstimatedLifeSpan"] == System.DBNull.Value ? "" : n["EstimatedLifeSpan"]),
                                                                      PartSource = n.Field<string>("PartSource") == null ? "" : n.Field<string>("PartSource"),                                                                                                                                            
                                                                      StockExpDate = n.Field<DateTime?> ("StockExpiryDate"),    //== DBNull.Value ? default(DateTime?) : n.Field<DateTime>("StockExpiryDate")),//n.Field<DateTime?>("StockExpiryDate"),
                                                                      StockExpiryDateUTC = Convert.ToDateTime(n["StockExpiryDateUTC"] == DBNull.Value ? default(DateTime?) : n.Field<DateTime>("StockExpiryDateUTC")),
                                                                      //n.Field<DateTime>("StockExpiryDateUTC"),
                                                                      Quantity = n.Field<decimal>("Quantity"),
                                                                      Cost = n.Field<decimal>("Cost"),
                                                                      PurchaseCost = n.Field<decimal>("PurchaseCost"),
                                                                      InvoiceNo = n.Field<string>("InvoiceNo"),
                                                                      Remarks = n.Field<string>("Remarks"),
                                                                      CreatedBy = 1,
                                                                      CreatedDate = DateTime.Now,
                                                                      CreatedDateUTC = DateTime.Now,
                                                                      ModifiedBy = 1,
                                                                      ModifiedDate = DateTime.Now,
                                                                      ModifiedDateUTC = DateTime.Now,
                                                                      TotalRecords = Convert.ToInt32(n["TotalRecords"]),
                                                                      TotalPages = Convert.ToInt32(n["TotalPageCalc"]),
                                                                      TotalCost = n.Field<decimal?>("TotalCost"),
                                                                      VendorName= n.Field<string>("VendorName")==null?"": n.Field<string>("VendorName"),
                                                                      BinNo = n.Field<string>("BinNo") == null ? "" : n.Field<string>("BinNo"),
                                                                      // IsExpirydate = n.Field<bool>("IsExpirydate"),
                                                                      IsDeleteReference = n.Field<bool>("IsReferenced"),
                                                                  }).ToList();
                   
                    StockUpdateRegister.ItemMstFetchEntityList.ForEach((x) => {
                        StockUpdateRegister.TotalCost = x.TotalCost;
                        x.PageIndex = pageindex;
                        x.FirstRecord = ((pageindex-1) * pagesize)+1;
                        x.LastRecord = ((pageindex-1) * pagesize) + pagesize;
                        x.Remarks = x.Remarks == null ? string.Empty : x.Remarks;
                    });


                }
                Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
                return StockUpdateRegister;
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
        //public void GetAll()
        public bool Delete(int id)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Delete), Level.Info.ToString());
                var dbAccessDAL = new FEMSDBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "UspFM_EngStockUpdateRegisterTxn_Delete";
                        cmd.Parameters.AddWithValue("@pStockUpdateId", id);

                        con.Open();
                        cmd.ExecuteNonQuery();
                        con.Close();
                    }
                }
                Log4NetLogger.LogEntry(_FileName, nameof(Delete), Level.Info.ToString());
                return true;
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

        public GridFilterResult Getall(SortPaginateFilter pageFilter)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Getall), Level.Info.ToString());
                GridFilterResult filterResult = null;
              //  pageFilter.PageIndex= pageFilter.PageIndex == 0 ? 1 : pageFilter.PageIndex;
                var multipleOrderBy = pageFilter.SortColumn.Split(',');
                var strOrderBy = string.Empty;
                foreach (var order in multipleOrderBy)
                {
                    strOrderBy += order + " " + pageFilter.SortOrder + ",";
                }
                if (!string.IsNullOrEmpty(strOrderBy))
                {
                    strOrderBy = strOrderBy.TrimEnd(',');
                }
                strOrderBy = string.IsNullOrEmpty(strOrderBy) ? pageFilter.SortColumn + " " + pageFilter.SortOrder : strOrderBy;                                
                var QueryCondition = pageFilter.QueryWhereCondition;
                var strCondition = string.Empty;
                if (string.IsNullOrEmpty(QueryCondition))
                {
                    strCondition = "FacilityId = " + _UserSession.FacilityId.ToString();
                }
                else
                {
                    strCondition = QueryCondition + " AND FacilityId = " + _UserSession.FacilityId.ToString();
                }
                var ds = new DataSet();
                var dbAccessDAL = new FEMSDBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_EngStockUpdateRegisterTxn_GetAll";
                        cmd.Parameters.AddWithValue("@PageIndex", pageFilter.PageIndex);
                        cmd.Parameters.AddWithValue("@PageSize", pageFilter.PageSize);
                        cmd.Parameters.AddWithValue("@strCondition", strCondition);
                        cmd.Parameters.AddWithValue("@strSorting", strOrderBy);
                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }
                if (ds.Tables.Count != 0 && ds.Tables[0].Rows.Count > 0)
                {
                    var totalRecords = Convert.ToInt32(ds.Tables[0].Rows[0]["TotalRecords"]);
                    var totalPages = (int)Math.Ceiling((float)totalRecords / (float)pageFilter.Rows);

                    var commonDAL = new CommonDAL();
                    var currentPageList = commonDAL.ToDynamicList(ds.Tables[0]);
                    filterResult = new GridFilterResult
                    {
                        TotalRecords = totalRecords,
                        TotalPages = totalPages,
                        RecordsList = currentPageList,
                        CurrentPage = pageFilter.Page
                    };
                }
                Log4NetLogger.LogExit(_FileName, nameof(Getall), Level.Info.ToString());
                //return userRoles;
                return filterResult;
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
        public void deleteChildrecords(string id)
        {
            try
            {

                var ds = new DataSet();
                var dbAccessDAL = new FEMSDBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "UspFM_EngStockUpdateRegisterTxnDet_Delete";
                        cmd.Parameters.AddWithValue("@pStockUpdateDetId", id);
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
            catch (Exception ex)
            {
                throw;
            }
        }
        public StockUpdateRegister ImportValidation(StockUpdateRegister model)
        {
            try
            {
                var result = new StockUpdateRegister();
                var ds = new DataSet();
                var dbAccessDAL = new FEMSDBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_EngStockUpdateRegisterTxn_Import";

                        cmd.Parameters.AddWithValue("@pStockUpdateNo", model.StockUpdateNo);
                      //  cmd.Parameters.AddWithValue("@pDate", model.Date);
                        cmd.Parameters.AddWithValue("@pStockExpiryDate", model.ItemMstFetchEntityList[0].StockExpDate);
                        cmd.Parameters.AddWithValue("@pPartNo", model.ItemMstFetchEntityList[0].Partno);
                        cmd.Parameters.AddWithValue("@pPartDescription", model.ItemMstFetchEntityList[0].PartDescription);
                        cmd.Parameters.AddWithValue("@pLocation", model.ItemMstFetchEntityList[0].Location);
                        cmd.Parameters.AddWithValue("@pItemCode", model.ItemMstFetchEntityList[0].ItemCode);
                        cmd.Parameters.AddWithValue("@pItemDescription", model.ItemMstFetchEntityList[0].ItemDescription);
                        cmd.Parameters.AddWithValue("@pFacilityCode", model.FacilityCode);

                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }
                if (ds.Tables.Count != 0 && ds.Tables[0].Rows.Count > 0)
                {
                    result.StockUpdateId = ds.Tables[0].Rows[0]["StockUpdateId"] == DBNull.Value ? 0 : Convert.ToInt32(ds.Tables[0].Rows[0]["StockUpdateId"]);
                    result.SparePartsId = ds.Tables[0].Rows[0]["SparePartsId"] == DBNull.Value ? 0 : Convert.ToInt32(ds.Tables[0].Rows[0]["SparePartsId"]);
                    result.FacilityId = ds.Tables[0].Rows[0]["FacilityId"] == DBNull.Value ? 0 : Convert.ToInt32(ds.Tables[0].Rows[0]["FacilityId"]);
                    result.ItemId = ds.Tables[0].Rows[0]["ItemId"] == DBNull.Value ? 0 : Convert.ToInt32(ds.Tables[0].Rows[0]["ItemId"]);
                    result.ErrorMessage = ds.Tables[0].Rows[0]["ErrorMessage"] == DBNull.Value ? null : Convert.ToString(ds.Tables[0].Rows[0]["ErrorMessage"]);
                }

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
