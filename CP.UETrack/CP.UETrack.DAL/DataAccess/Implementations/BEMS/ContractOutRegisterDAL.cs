using CP.Framework.Common.ExceptionHandler.ExceptionWrappers;
using CP.Framework.Common.Logging;
using CP.UETrack.DAL.DataAccess.Contracts.BEMS;
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

namespace CP.UETrack.DAL.DataAccess.Implementations.BEMS
{
    public class ContractOutRegisterDAL : IContractOutRegisterDAL
    {

        private readonly string _FileName = nameof(StockUpdateRegisterDAL);
        readonly UserDetailsModel _UserSession = new SessionHelper().UserSession();



        public CORDropdownList Load()
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
                CORDropdownList Dropdownentityval = new CORDropdownList();

                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_Dropdown";
                        cmd.Parameters.AddWithValue("@pLovKey", "ContractTypeValue");
                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);

                        if (ds.Tables.Count != 0)
                        {

                            Dropdownentityval.ContractTypeValueList = dbAccessDAL.GetLovRecords(ds.Tables[0]);

                        }

                        ds.Clear();
                        cmd.Parameters.Clear();
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_Dropdown";
                        cmd.Parameters.AddWithValue("@pLovKey", "StatusValue");
                        var da1 = new SqlDataAdapter();
                        da1.SelectCommand = cmd;
                        da1.Fill(ds);

                        if (ds.Tables.Count != 0)
                        {

                            Dropdownentityval.StatusValueList = dbAccessDAL.GetLovRecords(ds.Tables[0]);

                        }

                        ds.Clear();


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





        public void save(ref ContractOutRegisterEntity model, out string ErrorMessage)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(save), Level.Info.ToString());
                ErrorMessage = string.Empty;
                model.CustomerId = 1;
                int userid = model.CreatedBy = _UserSession.UserId;
                model.FacilityId = 1;
                var formatkey = "[ModuleName][ScreenName][YearMonth]";
                var documentIdKeyFormat = new DocumentIdKeyFormat
                {
                    CompanyId = 1,

                    HospitalId = 2,
                    Year = DateTime.Now.Year,
                    Month = DateTime.Now.Month,

                    Formatkey = formatkey,

                    ScreenName = "Biomedical Engineering Maintenance Services",
                    ModuleName = "BEMS",
                    AutoGenarateProp = "StockUpdateNo"
                };

                //  var docnumber = AutoGenerateNumberDAL.AutoGenerate(model, documentIdKeyFormat);

               // model.ContractNo = "Test1" + DateTime.Now.Millisecond;
                model.ServiceId = 2;
                //model.TotalCost = model.ItemMstFetchEntityList.Where(x => !x.IsDeleted).Sum(x => x.Cost);
                model.CreatedDate = model.CreatedDateUTC = DateTime.Now;
                var dbAccessDAL = new DBAccessDAL();
                var obj = new EngAssetClassification();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pUserId", Convert.ToString(userid));
                parameters.Add("@pContractId", Convert.ToString(model.ContractId));
                parameters.Add("@CustomerId", Convert.ToString(_UserSession.CustomerId));
                parameters.Add("@FacilityId", Convert.ToString(_UserSession.FacilityId));
                parameters.Add("@ServiceId", Convert.ToString(model.ServiceId));
                parameters.Add("@ContractNo", Convert.ToString(model.ContractNo));
                parameters.Add("@ContractorId", model.ContractorId.ToString());
                parameters.Add("@ContractStartDate", model.startDate.ToString("yyyy-MM-dd h:mm tt"));
                parameters.Add("@ContractEndDate", model.endDate != null ? model.endDate.Value.ToString("yyyy-MM-dd h:mm tt") : null);
                //parameters.Add("@ResponsiblePersonId", Convert.ToString(model.CreatedBy));
                parameters.Add("@AResponsiblePerson", Convert.ToString(model.SecResponsiblePerson));
                parameters.Add("@APersonDesignation", Convert.ToString(model.SecDesignation));
                parameters.Add("@AContactNumber", Convert.ToString(model.SecTelephoneNo));
                parameters.Add("@AFaxNo", Convert.ToString(model.SecFaxNo));
                parameters.Add("@ScopeofWork", Convert.ToString(model.scopeOfWork));
                parameters.Add("@Remarks", Convert.ToString(model.remarks));
                parameters.Add("@Status", Convert.ToString(model.Status));
                parameters.Add("@pNotificationForInspection", model.NotificationForInspection == null ? default(DateTime?).ToString() : model.NotificationForInspection.Value.ToString("yyyy-MM-dd h:mm tt"));
                parameters.Add("@Renew", Convert.ToString(model.IsRenewed));

                var DataSetparameters = new Dictionary<string, DataTable>();
                DataTable dt = new DataTable();
                dt.Columns.Add("ContractDetId", typeof(int));
                dt.Columns.Add("CustomerId", typeof(int));
                dt.Columns.Add("FacilityId", typeof(int));
                dt.Columns.Add("ServiceId", typeof(int));
                dt.Columns.Add("ContractId", typeof(int));
                dt.Columns.Add("AssetId", typeof(int));

                dt.Columns.Add("ContractType", typeof(int));
                dt.Columns.Add("ContractValue", typeof(Decimal));


                foreach (var item in model.AssetList.Where(x => !x.IsDeleted))
                {

                    item.CreatedDate = item.CreatedDateUTC = Convert.ToDateTime(DateTime.Now.ToString("yyyy-MM-dd h:mm tt"));
                    dt.Rows.Add(item.ContractDetId, _UserSession.CustomerId, _UserSession.FacilityId, model.ServiceId, model.ContractId, item.AssetId, item.ContractType, item.ContractValue);

                }
                DataSetparameters.Add("@EngContractOutRegisterDet", dt);

                DataTable ds = dbAccessDAL.GetDataTable("uspFM_EngContractOutRegister_Save", parameters, DataSetparameters);
                if (ds != null)
                {
                    foreach (DataRow row in ds.Rows)
                    {
                        model.ContractId = Convert.ToInt32(row["ContractId"]);
                        model.Timestamp = Convert.ToBase64String((byte[])(row["Timestamp"]));
                        ErrorMessage = Convert.ToString(row["ErrorMessage"]);
                    }
                    model.HiddenId = Convert.ToString(ds.Rows[0]["GuId"]);
                }

                model = Get(model.ContractId, 5, 1);
                Log4NetLogger.LogEntry(_FileName, nameof(save), Level.Info.ToString());

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


        public void update(ref ContractOutRegisterEntity model, out string ErrorMessage)
        {
            try
            {

                Log4NetLogger.LogEntry(_FileName, nameof(update), Level.Info.ToString());
                ErrorMessage = string.Empty;
                model.CustomerId = 1;
                int userid = model.CreatedBy = _UserSession.UserId;
                model.FacilityId = 1;
                var formatkey = "[ModuleName][ScreenName][YearMonth]";
                var documentIdKeyFormat = new DocumentIdKeyFormat
                {
                    CompanyId = 1,

                    HospitalId = 2,
                    Year = DateTime.Now.Year,
                    Month = DateTime.Now.Month,

                    Formatkey = formatkey,

                    ScreenName = "Biomedical Engineering Maintenance Services",
                    ModuleName = "BEMS",
                    AutoGenarateProp = "StockUpdateNo"
                };

                //  var docnumber = AutoGenerateNumberDAL.AutoGenerate(model, documentIdKeyFormat);

                //model.ContractNo = "Test1" + DateTime.Now.Millisecond;
                model.ServiceId = 2;
                //model.TotalCost = model.ItemMstFetchEntityList.Where(x => !x.IsDeleted).Sum(x => x.Cost);
                model.CreatedDate = model.CreatedDateUTC = DateTime.Now;
                var dbAccessDAL = new DBAccessDAL();
                var obj = new EngAssetClassification();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pUserId", Convert.ToString(userid));
                parameters.Add("@pContractId", Convert.ToString(model.ContractId));
                parameters.Add("@CustomerId", Convert.ToString(_UserSession.CustomerId));
                parameters.Add("@FacilityId", Convert.ToString(_UserSession.FacilityId));
                parameters.Add("@ServiceId", Convert.ToString(model.ServiceId));
                parameters.Add("@ContractNo", Convert.ToString(model.ContractNo));
                parameters.Add("@ContractorId", model.ContractorId.ToString());
                parameters.Add("@ContractStartDate", model.startDate.ToString("yyyy-MM-dd h:mm tt"));
                parameters.Add("@ContractEndDate", model.endDate != null ? model.endDate.Value.ToString("yyyy-MM-dd h:mm tt") : null);
                //parameters.Add("@ResponsiblePersonId", Convert.ToString(model.CreatedBy));
                parameters.Add("@AResponsiblePerson", Convert.ToString(model.SecResponsiblePerson));
                parameters.Add("@APersonDesignation", Convert.ToString(model.SecDesignation));
                parameters.Add("@AContactNumber", Convert.ToString(model.SecTelephoneNo));
                parameters.Add("@AFaxNo", Convert.ToString(model.SecFaxNo));
                parameters.Add("@ScopeofWork", Convert.ToString(model.scopeOfWork));
                parameters.Add("@Remarks", Convert.ToString(model.remarks));
                parameters.Add("@Status", Convert.ToString(model.Status));
                parameters.Add("@pNotificationForInspection", model.NotificationForInspection == null ? default(DateTime?).ToString() : model.NotificationForInspection.Value.ToString("yyyy-MM-dd h:mm tt"));
                parameters.Add("@Renew", Convert.ToString(model.IsRenewed));


                var DataSetparameters = new Dictionary<string, DataTable>();
                DataTable dt = new DataTable();
                dt.Columns.Add("ContractDetId", typeof(int));
                dt.Columns.Add("CustomerId", typeof(int));
                dt.Columns.Add("FacilityId", typeof(int));
                dt.Columns.Add("ServiceId", typeof(int));
                dt.Columns.Add("ContractId", typeof(int));
                dt.Columns.Add("AssetId", typeof(int));

                dt.Columns.Add("ContractType", typeof(int));
                dt.Columns.Add("ContractValue", typeof(Decimal));


                var deletedId = model.AssetList.Where(y => y.IsDeleted).Select(x => x.ContractDetId).ToList();
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


                foreach (var item in model.AssetList.Where(x => !x.IsDeleted))
                {

                    item.CreatedDate = item.CreatedDateUTC = Convert.ToDateTime(DateTime.Now.ToString("yyyy-MM-dd h:mm tt"));
                    dt.Rows.Add(item.ContractDetId, model.CustomerId, model.FacilityId, model.ServiceId, model.ContractId, item.AssetId, item.ContractType, item.ContractValue);

                }
                DataSetparameters.Add("@EngContractOutRegisterDet", dt);

                DataTable ds = dbAccessDAL.GetDataTable("uspFM_EngContractOutRegister_Save", parameters, DataSetparameters);
                if (ds != null)
                {
                    foreach (DataRow row in ds.Rows)
                    {
                        model.ContractId = Convert.ToInt32(row["ContractId"]);
                        model.Timestamp = Convert.ToBase64String((byte[])(row["Timestamp"]));
                        ErrorMessage = Convert.ToString(row["ErrorMessage"]);
                        model.HiddenId = Convert.ToString(ds.Rows[0]["GuId"]);
                    }
                }
                var isrenewed = model.IsRenewed;

                if (model.ContractId != 0 && ErrorMessage == string.Empty)
                {

                    model = Get(model.ContractId, 5, 1);
                    model.IsRenewed = isrenewed;
                    if (model.IsRenewed)
                    {
                        model.startDate = model.endDate.Value.AddDays(1);

                    }
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
        public ContractOutRegisterEntity Get(int id, int pagesize, int pageindex)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
                ContractOutRegisterEntity ContractOutRegisterEntity = null;

                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "UspFM_EngContractOutRegister_GetById";
                        cmd.Parameters.AddWithValue("@pContractId", id);
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
                    ContractOutRegisterEntity = (from n in ds.Tables[0].AsEnumerable()
                                                 select new ContractOutRegisterEntity
                                                 {
                                                     ContractId = n.Field<int>("ContractId"),
                                                     CustomerId = n.Field<int>("CustomerId"),
                                                     FacilityId = n.Field<int>("FacilityId"),
                                                     ServiceId = n.Field<int>("ServiceId"),
                                                     ContractNo = n.Field<string>("ContractNo"),
                                                     ContractorId = n.Field<int>("ContractorId"),
                                                     contractCode = n.Field<string>("ContractorCode"),
                                                     ContractorName = n.Field<string>("ContractorName"),
                                                     ContractorType = n.Field<int>("ContractorType"),
                                                     ContactPerson = n.Field<string>("ContactPerson"),
                                                     Designation = n.Field<string>("Designation"),
                                                     //Timestamp = Convert.ToBase64String((byte[])(n["Timestamp"])),
                                                     ContactNo = n.Field<string>("ContactNo"),
                                                     FaxNo = n.Field<string>("FaxNo"),
                                                     Email = n.Field<string>("Email"),
                                                     startDate = n.Field<DateTime>("ContractStartDate"),
                                                     endDate = n.Field<DateTime>("ContractEndDate"),
                                                     SecResponsiblePerson = n.Field<string>("AResponsiblePerson"),
                                                     SecDesignation = n.Field<string>("APersonDesignation"),
                                                     SecTelephoneNo = n.Field<string>("AContactNumber"),
                                                     SecFaxNo = n.Field<string>("AFaxNo"),
                                                     scopeOfWork = n.Field<string>("ScopeofWork"),
                                                     remarks = n.Field<string>("Remarks"),
                                                     Status = n.Field<int>("Status"),
                                                     NotificationForInspection = Convert.ToDateTime(n["NotificationForInspection"] == DBNull.Value ? default(DateTime?) : n.Field<DateTime>("NotificationForInspection")),
                                                     ContractSum = n.Field<decimal>("ContractSumValue"),
                                                     ContractSumString = (n.Field<decimal>("ContractSumValue")).ToString(),
                                                     IsRenewed = n.Field<bool>("IsRenewedPreviously"),
                                                     HiddenId = Convert.ToString((n["GuId"]))

                                                 }).FirstOrDefault();

                    var diffdays = ((ContractOutRegisterEntity.endDate.Value.Date) - (DateTime.Now.Date)).TotalDays;
                    ContractOutRegisterEntity.AllowRenew = (diffdays <= 30 && diffdays >= 0);

                    ContractOutRegisterEntity.AssetList = (from n in ds.Tables[0].AsEnumerable()
                                                           select new AssetList
                                                           {
                                                               ContractDetId = Convert.ToInt32(n["ContractDetId"]),
                                                               CustomerId = Convert.ToInt32(n["CustomerId"]),
                                                               FacilityId = Convert.ToInt32(n["FacilityId"]),
                                                               ServiceId = n.Field<int>("ServiceId"),
                                                               AssetId = n.Field<int>("AssetId"),
                                                               AssetNo = n.Field<string>("AssetNo"),
                                                               AssetDescription = n.Field<string>("AssetDescription"),
                                                               ContractType = n.Field<int>("ContractType"),
                                                               ContractTypeName = n.Field<string>("ContractTypeName"),
                                                               ContractValue = n.Field<decimal>("ContractValue"),
                                                               ContractValueString = (n.Field<decimal>("ContractValue")).ToString(),
                                                               TotalRecords = n.Field<int>("TotalRecords"),
                                                               TotalPages = n.Field<int>("TotalPageCalc"),
                                                           }).ToList();

                    ds.Clear();
                    using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                    {
                        using (SqlCommand cmd = new SqlCommand())
                        {
                            cmd.Connection = con;
                            cmd.CommandType = CommandType.StoredProcedure;
                            cmd.CommandText = "UspFM_EngContractOutRegisterHistory_GetById";
                            cmd.Parameters.AddWithValue("@pContractId", id);
                            cmd.Parameters.AddWithValue("@pUserId", _UserSession.UserId);
                            cmd.Parameters.AddWithValue("@pPageIndex", pageindex);
                            cmd.Parameters.AddWithValue("@pPageSize", pagesize);

                            var da = new SqlDataAdapter();
                            da.SelectCommand = cmd;
                            da.Fill(ds);
                        }
                    }

                    ContractOutRegisterEntity.HistoryTab = (from n in ds.Tables[0].AsEnumerable()
                                                            select new HistoryTab
                                                            {                                                                
                                                                ContractId = Convert.ToInt32(n["ContractId"]),
                                                                ContractHistoryId = Convert.ToInt32(n["ContractHistoryId"]),
                                                                ContractNo = Convert.ToString(n["ContractNo"]),
                                                                ContractStartDate = Convert.ToDateTime(n["ContractStartDate"]),
                                                                ContractEndDate = Convert.ToDateTime(n["ContractEndDate"]),
                                                            }).ToList();


                    ContractOutRegisterEntity.AssetList.ForEach((x) =>
                    {
                        x.PageIndex = pageindex;
                        x.FirstRecord = ((pageindex - 1) * pagesize) + 1;
                        x.LastRecord = ((pageindex - 1) * pagesize) + pagesize;
                    });

                }
                Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
                return ContractOutRegisterEntity;
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
        //public void GetAll()
        public bool Delete(int id)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Delete), Level.Info.ToString());
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "UspFM_EngContractOutRegister_Delete";
                        cmd.Parameters.AddWithValue("@pContractId", id);

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
                pageFilter.PageIndex = pageFilter.PageIndex - 1;
                pageFilter.PageIndex = pageFilter.PageIndex < 0 ? 0 : pageFilter.PageIndex;
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

                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_EngContractOutRegister_GetAll";

                        cmd.Parameters.AddWithValue("@PageIndex", pageFilter.PageIndex);
                        cmd.Parameters.AddWithValue("@PageSize", pageFilter.PageSize);
                        cmd.Parameters.AddWithValue("@StrCondition", pageFilter.QueryWhereCondition ?? "");
                        cmd.Parameters.AddWithValue("@StrSorting", strOrderBy ?? "");
                        cmd.Parameters.AddWithValue("@FacilityId", _UserSession.FacilityId);

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
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "UspFM_EngContractOutRegisterDet_Delete";

                        cmd.Parameters.AddWithValue("@pContractDetId", id);


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


        public ContractOutRegisterEntity GetPopupDetails(int primaryId, int ContractHisId)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
            try
            {
                var dbAccessDAL = new DBAccessDAL();
                var obj = new ContractOutRegisterEntity();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pContractId", primaryId.ToString());
                parameters.Add("@pContractHistoryId", ContractHisId.ToString());
                parameters.Add("@pPageIndex","1");
                parameters.Add("@pPageSize", "5");
                DataSet ds = dbAccessDAL.GetDataSet("UspFM_EngContractOutRegisterAssetHistory_GetById", parameters, DataSetparameters);
                if (ds != null)
                {
                        if (ds.Tables[0] != null && ds.Tables[0].Rows.Count > 0)
                        {

                            var gridList = (from n in ds.Tables[0].AsEnumerable()
                                            select new HistoryTab
                                            {
                                                ContractHistoryId = Convert.ToInt32(n["ContractHistoryId"]),
                                                AssetNo = Convert.ToString(n["AssetNo"]),
                                                AssetDescription = Convert.ToString(n["AssetDescription"]),
                                               ContractValue = Convert.ToDecimal(n["ContractValue"]),
                                                ContractValueString = (n.Field<decimal>("ContractValue")).ToString(),
                                                ContractType = Convert.ToInt16(n["ContractType"]),
                                               ContractTypeName= Convert.ToString(n["ContractTypeName"]),
                                                // Active = Convert.ToBoolean(n["Active"])
                                            }).ToList();

                            if (gridList != null && gridList.Count > 0)
                            {
                                obj.HistoryTab = gridList;

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


    }
}
