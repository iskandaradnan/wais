using CP.Framework.Common.ExceptionHandler.ExceptionWrappers;
using CP.Framework.Common.Logging;
using CP.UETrack.DAL.DataAccess.Contracts.HWMS;
using CP.UETrack.DAL.DataAccess.Implementation;
using CP.UETrack.Model;
using CP.UETrack.Model.HWMS;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using UETrack.DAL;

namespace CP.UETrack.DAL.DataAccess.Implementations.HWMS
{
    public class RecordsofRecyclableWasteDAL : IRecordsofRecyclableWasteDAL
    {
        private readonly string _FileName = nameof(BlockDAL);

        readonly UserDetailsModel _UserSession = new SessionHelper().UserSession();

        public RecordsDropdowns Load()
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                RecordsDropdowns recordsDropdowns = new RecordsDropdowns();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        var da = new SqlDataAdapter();
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "Sp_HWMS_RecordsofRecyclableWaste_Load";
                        cmd.Parameters.Clear();
                        cmd.Parameters.AddWithValue("@pScreenName", "RecordsofRecyclableWaste");
                        da.SelectCommand = cmd;
                        da.Fill(ds);

                        if (ds.Tables[0] != null)
                        {
                            recordsDropdowns.MethodofDisposalValue = dbAccessDAL.GetLovRecords(ds.Tables[0]);
                        }
                        if (ds.Tables[1] != null)
                        {
                            recordsDropdowns.RecyclableWasteTypeValue = dbAccessDAL.GetLovRecords(ds.Tables[1]);
                        }
                        if (ds.Tables[2] != null)
                        {
                            recordsDropdowns.TransportationCategoryValue = dbAccessDAL.GetLovRecords(ds.Tables[2]);
                        }
                    }
                }
                Log4NetLogger.LogExit(_FileName, nameof(Load), Level.Info.ToString());
                return recordsDropdowns;
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

        public RecordsofRecyclableWaste WasteCodeGet(string WasteType)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(WasteCodeGet), Level.Info.ToString());
                RecordsofRecyclableWaste _RecordsofRecyclableWaste = new RecordsofRecyclableWaste();

                var ds = new DataSet();

                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "Sp_HWMS_WasteCodeGet";
                        cmd.Parameters.AddWithValue("@WasteType", WasteType);
                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }
               
                List<RecordsofRecyclableWaste> _RecyclableWaste = new List<RecordsofRecyclableWaste>();

                foreach (DataRow dr in ds.Tables[0].Rows)
                {
                    RecordsofRecyclableWaste Waste = new RecordsofRecyclableWaste();

                    Waste.WasteCode = dr["WasteCode"].ToString();


                    _RecyclableWaste.Add(Waste);
                }
                _RecordsofRecyclableWaste.RecyclableWaste = _RecyclableWaste;


                Log4NetLogger.LogExit(_FileName, nameof(WasteCodeGet), Level.Info.ToString());
                return _RecordsofRecyclableWaste;
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

        public RecordsofRecyclableWaste CSWRSFetch(RecordsofRecyclableWaste model, out string ErrorMessage)
        {
            try
            {               
                Log4NetLogger.LogEntry(_FileName, nameof(CSWRSFetch), Level.Info.ToString());
                var spName = string.Empty;
                ErrorMessage = string.Empty;


                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "Sp_HWMS_RecordsofRecyclableWaste_Fetch";
                        cmd.Parameters.AddWithValue("@RecyclableId", model.RecyclableId);
                        cmd.Parameters.AddWithValue("@StartDate", model.StartDate);
                        cmd.Parameters.AddWithValue("@EndDate", model.EndDate);

                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);

                        if (ds.Tables[0] != null)
                        {
                            if (ds.Tables[0].Rows.Count > 0)
                            {
                                List<RecyclableRecords> RecyclableRecordsList = new List<RecyclableRecords>();
                                foreach (DataRow dr in ds.Tables[0].Rows)
                                {
                                    RecyclableRecords Records = new RecyclableRecords();

                                    Records.UserAreaCode = dr["UserAreaCode"].ToString();
                                    Records.UserAreaName = dr["UserAreaName"].ToString();                                   
                                    Records.CSWRSNo = dr["DocumentNo"].ToString();
                                  
                                    RecyclableRecordsList.Add(Records);
                                }
                                model.CSWRSDetailsFetchList = RecyclableRecordsList;
                            }
                        }
                    }
                }

                Log4NetLogger.LogExit(_FileName, nameof(CSWRSFetch), Level.Info.ToString());
                return model;
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

        public RecordsofRecyclableWaste Save(RecordsofRecyclableWaste model, out string ErrorMessage)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());
                ErrorMessage = string.Empty;
                var spName = string.Empty;
                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "Sp_HWMS_RecordsofRecyclableWaste_Save";

                        cmd.Parameters.AddWithValue("@RecyclableId", model.RecyclableId);
                        cmd.Parameters.AddWithValue("@CustomerId", model.CustomerId);
                        cmd.Parameters.AddWithValue("@FacilityId", model.FacilityId);
                        cmd.Parameters.AddWithValue("@RRWNo", model.RRWNo);
                        cmd.Parameters.AddWithValue("@DateTime", model.DateTime);
                        cmd.Parameters.AddWithValue("@TotalWeight", model.TotalWeight);
                        cmd.Parameters.AddWithValue("@MethodofDisposal", model.MethodofDisposal);
                        cmd.Parameters.AddWithValue("@CSWRepresentative", model.CSWRepresentative);
                        cmd.Parameters.AddWithValue("@CSWRepresentativeDesignation", model.CSWRepresentativeDesignation);
                        cmd.Parameters.AddWithValue("@HospitalRepresentative", model.HospitalRepresentative);
                        cmd.Parameters.AddWithValue("@HospitalRepresentativeDesignation", model.HospitalRepresentativeDesignation);
                        cmd.Parameters.AddWithValue("@VendorCode", model.VendorCode);
                        cmd.Parameters.AddWithValue("@VendorName", model.VendorName);
                        cmd.Parameters.AddWithValue("@UnitRate", model.UnitRate);
                        cmd.Parameters.AddWithValue("@ReturnValue", model.ReturnValue);
                        cmd.Parameters.AddWithValue("@TotalAmount", model.TotalAmount);
                        cmd.Parameters.AddWithValue("@InvoiceNoReceiptNo", model.InvoiceNoReceiptNo);
                        cmd.Parameters.AddWithValue("@WasteType", model.WasteType);
                        cmd.Parameters.AddWithValue("@WasteCode", model.WasteCode);
                        cmd.Parameters.AddWithValue("@TransportationCategory", model.TransportationCategory);
                        cmd.Parameters.AddWithValue("@Remarks", model.Remarks);
                        cmd.Parameters.AddWithValue("@StartDate", model.StartDate);
                        cmd.Parameters.AddWithValue("@EndDate", model.EndDate);

                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);

                        if (ds.Tables.Count != 0)
                        {
                            if (ds.Tables[0].Rows[0][0].ToString() == "-1")
                            {                              
                                ErrorMessage = "RRWNo already exists/InvoiceNoReceiptNo already exists";
                            }
                            
                            else
                            {
                                cmd.Parameters.Clear();
                                model.RecyclableId = Convert.ToInt32(ds.Tables[0].Rows[0]["RecyclableId"]);
                                var ds1 = new DataSet();
                                cmd.CommandText = "Sp_HWMS_RecordsofRecyclableWaste_CSWRSDetails_Save";
                                foreach (var Records in model.RecordsofRecyclableWasteList)
                                {
                                    cmd.Parameters.AddWithValue("@CSWRSId", Records.CSWRSId);
                                    cmd.Parameters.AddWithValue("@UserAreaCode", Records.UserAreaCode);
                                    cmd.Parameters.AddWithValue("@UserAreaName", Records.UserAreaName);
                                    cmd.Parameters.AddWithValue("@CSWRSNo", Records.CSWRSNo);
                                    cmd.Parameters.AddWithValue("@RecyclableId", model.RecyclableId);
                                    cmd.Parameters.AddWithValue("@isDeleted", Records.isDeleted);

                                    da.SelectCommand = cmd;
                                    da.Fill(ds1);
                                    cmd.Parameters.Clear();
                                }
                                model = Get(model.RecyclableId);
                            }
                        }
                    }
                }
                Log4NetLogger.LogExit(_FileName, nameof(Save), Level.Info.ToString());
                return model;
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

        public GridFilterResult GetAll(SortPaginateFilter pageFilter)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(GetAll), Level.Info.ToString());
                GridFilterResult filterResult = null;

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
                var strCondition = string.Empty;
                var QueryCondition = pageFilter.QueryWhereCondition;
                if (string.IsNullOrEmpty(QueryCondition))
                {
                    strCondition = "FacilityId = " + _UserSession.FacilityId.ToString();
                }
                else
                {
                    strCondition = QueryCondition + " AND FacilityId = " + _UserSession.FacilityId.ToString();
                }
                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "Sp_HWMS_RecordsofRecyclableWaste_GetAll";

                        cmd.Parameters.AddWithValue("@PageIndex", pageFilter.PageIndex);
                        cmd.Parameters.AddWithValue("@PageSize", pageFilter.PageSize);
                        cmd.Parameters.AddWithValue("@StrCondition", strCondition);
                        cmd.Parameters.AddWithValue("@StrSorting", strOrderBy);

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
                Log4NetLogger.LogExit(_FileName, nameof(GetAll), Level.Info.ToString());
                //return Blocks;
                return filterResult;
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

        public RecordsofRecyclableWaste Get(int Id)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());


                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "Sp_HWMS_RecordsofRecyclableWaste_Get";
                        cmd.Parameters.AddWithValue("Id", Id);
                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }
                RecordsofRecyclableWaste _RecordsofRecyclableWaste = new RecordsofRecyclableWaste();

                if (ds.Tables[0].Rows.Count > 0)
                {
                    DataRow dr = ds.Tables[0].Rows[0];

                    _RecordsofRecyclableWaste.RecyclableId =Convert.ToInt32( dr["RecyclableId"].ToString());
                    _RecordsofRecyclableWaste.RRWNo = dr["RRWNo"].ToString();
                    _RecordsofRecyclableWaste.DateTime = Convert.ToDateTime(dr["DateTime"].ToString());
                    _RecordsofRecyclableWaste.TotalWeight = Convert.ToInt64(dr["TotalWeight"].ToString());
                    _RecordsofRecyclableWaste.MethodofDisposal = dr["MethodofDisposal"].ToString();
                    _RecordsofRecyclableWaste.CSWRepresentative = dr["CSWRepresentative"].ToString();
                    _RecordsofRecyclableWaste.CSWRepresentativeDesignation =dr["CSWRepresentativeDesignation"].ToString();
                    _RecordsofRecyclableWaste.HospitalRepresentative = dr["HospitalRepresentative"].ToString();
                    _RecordsofRecyclableWaste.HospitalRepresentativeDesignation = dr["HospitalRepresentativeDesignation"].ToString();
                    _RecordsofRecyclableWaste.VendorCode = dr["VendorCode"].ToString();
                    _RecordsofRecyclableWaste.VendorName = dr["VendorName"].ToString();
                    _RecordsofRecyclableWaste.UnitRate = Convert.ToInt64(dr["UnitRate"].ToString());
                    _RecordsofRecyclableWaste.ReturnValue = Convert.ToInt64(dr["ReturnValue"].ToString());
                    _RecordsofRecyclableWaste.TotalAmount = Convert.ToInt64(dr["TotalAmount"].ToString());
                    _RecordsofRecyclableWaste.InvoiceNoReceiptNo = dr["InvoiceNoReceiptNo"].ToString();
                    _RecordsofRecyclableWaste.WasteType = dr["WasteType"].ToString();
                    _RecordsofRecyclableWaste.WasteCode = dr["WasteCode"].ToString();
                    _RecordsofRecyclableWaste.TransportationCategory = dr["TransportationCategory"].ToString();
                    _RecordsofRecyclableWaste.Remarks = dr["Remarks"].ToString();
                    _RecordsofRecyclableWaste.StartDate = Convert.ToDateTime(dr["StartDate"].ToString());
                    _RecordsofRecyclableWaste.EndDate = Convert.ToDateTime(dr["EndDate"].ToString());

                }
                if (ds.Tables[1] != null)
                {
                    if (ds.Tables[1].Rows.Count > 0)
                    {
                        List<RecyclableRecords> _RecyclableRecords = new List<RecyclableRecords>();
                        foreach (DataRow dr in ds.Tables[1].Rows)
                        {
                            RecyclableRecords Records = new RecyclableRecords();

                            Records.CSWRSId =Convert.ToInt32( dr["CSWRSId"].ToString());
                            Records.UserAreaCode = dr["UserAreaCode"].ToString();
                            Records.UserAreaName = dr["UserAreaName"].ToString();
                            Records.CSWRSNo = dr["CSWRSNo"].ToString();

                            _RecyclableRecords.Add(Records);
                        }
                        _RecordsofRecyclableWaste.CSWRSDetailsFetchList = _RecyclableRecords;
                    }
                }


                Log4NetLogger.LogExit(_FileName, nameof(Get), Level.Info.ToString());

                return _RecordsofRecyclableWaste;
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
