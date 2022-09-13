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
using CP.UETrack.Model.HWMS;
using CP.UETrack.DAL.DataAccess.Contracts.HWMS;
using CP.UETrack.Model.Common;

namespace CP.UETrack.DAL.DataAccess.Implementations.HWMS
{
    public class ConsignmentNoteCWCNDAL : IConsignmentNoteCWCNDAL
    {
        private readonly string _FileName = nameof(ConsignmentNoteCWCNDAL);
        readonly UserDetailsModel _UserSession = new SessionHelper().UserSession();

        public ConsignmentCWCNDropDown Load()
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                ConsignmentCWCNDropDown consignmentdropdownvalues = new ConsignmentCWCNDropDown();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        var da = new SqlDataAdapter();
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "sp_HWMS_ConsignmentCWCN_DropDown";
                        cmd.Parameters.Clear();
                        cmd.Parameters.AddWithValue("@pScreenName", "ConsignmentNoteCWCN");
                        da.SelectCommand = cmd;
                        da.Fill(ds);

                        if (ds.Tables[0] != null)
                        {
                            consignmentdropdownvalues.QcLovs = dbAccessDAL.GetLovRecords(ds.Tables[0]);
                        }
                        if (ds.Tables[1] != null)
                        {
                            consignmentdropdownvalues.OnScheduleLovs = dbAccessDAL.GetLovRecords(ds.Tables[1]);
                        }
                        if (ds.Tables[2] != null)
                        {
                            consignmentdropdownvalues.FileTypeLovs = dbAccessDAL.GetLovRecords(ds.Tables[2]);
                        }
                    }
                }
                Log4NetLogger.LogExit(_FileName, nameof(Load), Level.Info.ToString());
                return consignmentdropdownvalues;
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
        public List<ConsignmentNoteCWCN> AutoDisplaying()
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(AutoDisplaying), Level.Info.ToString());          
                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "sp_HWMS_ConsignmentNote_TreatmentPlant";

                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }
                List<ConsignmentNoteCWCN> _consignmentAutoGenerateList = new List<ConsignmentNoteCWCN>();
                foreach (DataRow dr in ds.Tables[0].Rows)
                {
                    ConsignmentNoteCWCN Auto = new ConsignmentNoteCWCN();
                    Auto.TreatmentPlantName = dr["TreatmentPlantName"].ToString();
                    Auto.TreatmentPlantId = dr["TreatmentPlantId"].ToString();
                    _consignmentAutoGenerateList.Add(Auto);                   
                }            
                Log4NetLogger.LogExit(_FileName, nameof(AutoDisplaying), Level.Info.ToString());
                return _consignmentAutoGenerateList;
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
        public ConsignmentNoteCWCN Save(ConsignmentNoteCWCN model, out string ErrorMessage)
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
                        cmd.CommandText = "sp_HWMS_ConsignmentNoteCWCN_Save";

                        cmd.Parameters.AddWithValue("@ConsignmentId", model.ConsignmentId);
                        cmd.Parameters.AddWithValue("@CustomerId", model.CustomerId);
                        cmd.Parameters.AddWithValue("@FacilityId", model.FacilityId);
                        cmd.Parameters.AddWithValue("@ConsignmentNoteNo", model.ConsignmentNoteNo);
                        cmd.Parameters.AddWithValue("@DateTime", model.DateTime);
                        cmd.Parameters.AddWithValue("@OnSchedule", model.OnSchedule);
                        cmd.Parameters.AddWithValue("@QC", model.Qc);
                        cmd.Parameters.AddWithValue("@CWRepresentative", model.CwRepresentative);
                        cmd.Parameters.AddWithValue("@CWRepresentativeDesignation", model.CwRepresentativeDesignation);
                        cmd.Parameters.AddWithValue("@HospitalRepresentative", model.HospitalRepresentative);
                        cmd.Parameters.AddWithValue("@HospitalRepresentativeDesignation", model.HospitalRepresentativeDesignation);
                        cmd.Parameters.AddWithValue("@TreatmentPlantName", model.TreatmentPlantName);
                        cmd.Parameters.AddWithValue("@Ownership", model.Ownership);
                        cmd.Parameters.AddWithValue("@VehicleNo", model.VehicleNo);
                        cmd.Parameters.AddWithValue("@DriverCode", model.DriverCode);
                        cmd.Parameters.AddWithValue("@DriverName", model.DriverName);
                        cmd.Parameters.AddWithValue("@TotalNoOfBins", model.TotalNoOfBins);
                        cmd.Parameters.AddWithValue("@TotalEst", model.TotalEst);
                        cmd.Parameters.AddWithValue("@Remarks", model.Remarks);

                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
               
                        if (ds.Tables.Count != 0)
                        {
                            cmd.Parameters.Clear();
                            model.ConsignmentId = Convert.ToInt32(ds.Tables[0].Rows[0]["ConsignmentId"]);

                            if (model.ConsignmentId == -1)
                            {
                                ErrorMessage = "Entered Consignment No already exist";
                            }                                                      
                            else
                            {
                                var ds1 = new DataSet();                          
                                cmd.CommandText = "sp_HWMS_ConsignmentNoteCWCN_DWRNo_Save";

                                foreach (var use in model.ConsignmentNoteList)
                                {
                                    cmd.Parameters.Clear();
                                    cmd.Parameters.AddWithValue("@DWRNoId", use.DWRNoId);
                                    cmd.Parameters.AddWithValue("@ConsignmentId", model.ConsignmentId);
                                    cmd.Parameters.AddWithValue("@DWRDocId", use.DWRDocId);
                                    cmd.Parameters.AddWithValue("@BinNo", use.BinNo);
                                    cmd.Parameters.AddWithValue("@Weight", use.Weight);
                                    cmd.Parameters.AddWithValue("@Remarks_Bin", use.Remarks_Bin);
                                    cmd.Parameters.AddWithValue("@isDeleted", use.isDeleted);
                                    da.SelectCommand = cmd;
                                    da.Fill(ds);
                                }
                                model = Get(model.ConsignmentId);
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
                        cmd.CommandText = "sp_HWMS_ConsignmentNoteCWCN_GetAll";

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
        public ConsignmentNoteCWCN Get(int Id)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
                ConsignmentNoteCWCN consignment = new ConsignmentNoteCWCN();
                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "sp_HWMS_ConsignmentNoteCWCN_Get";
                        cmd.Parameters.AddWithValue("Id", Id);
                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }
                ConsignmentNoteCWCN _consignmentCWCN = new ConsignmentNoteCWCN();
                if (ds.Tables[0].Rows.Count > 0)
                {
                    DataRow dr = ds.Tables[0].Rows[0];
                    _consignmentCWCN.ConsignmentId = Convert.ToInt32(dr["ConsignmentId"]);
                    _consignmentCWCN.ConsignmentNoteNo = dr["ConsignmentNoteNo"].ToString();
                    _consignmentCWCN.DateTime =Convert.ToDateTime( dr["DateTime"].ToString());
                    _consignmentCWCN.OnSchedule = dr["OnSchedule"].ToString();
                    _consignmentCWCN.Qc = dr["Qc"].ToString();
                    _consignmentCWCN.CwRepresentative = dr["CwRepresentative"].ToString();
                    _consignmentCWCN.CwRepresentativeDesignation = dr["CwRepresentativeDesignation"].ToString();
                    _consignmentCWCN.HospitalRepresentative = dr["HospitalRepresentative"].ToString();
                    _consignmentCWCN.HospitalRepresentativeDesignation = dr["HospitalRepresentativeDesignation"].ToString();
                    _consignmentCWCN.TreatmentPlantName = dr["TreatmentPlantName"].ToString();
                    _consignmentCWCN.Ownership = dr["Ownership"].ToString();
                    _consignmentCWCN.VehicleNo = dr["VehicleNo"].ToString();
                    _consignmentCWCN.DriverCode = dr["DriverCode"].ToString();
                    _consignmentCWCN.DriverName = dr["DriverName"].ToString();
                    _consignmentCWCN.TotalNoOfBins = dr["TotalNoOfBins"].ToString();
                    _consignmentCWCN.TotalEst = dr["TotalEst"].ToString();
                    _consignmentCWCN.Remarks = dr["Remarks"].ToString();
                   
                }
                if (ds.Tables[1].Rows.Count > 0)
                {
                    List<ConsignmentNoteCWCN_BinDetails> _consignment = new List<ConsignmentNoteCWCN_BinDetails>();
                    foreach (DataRow dr in ds.Tables[1].Rows)
                    {                        
                        ConsignmentNoteCWCN_BinDetails Auto = new ConsignmentNoteCWCN_BinDetails();
                        Auto.DWRNoId = Convert.ToInt32(dr["DWRNoId"].ToString());
                        Auto.DWRDocId = Convert.ToInt32(dr["DWRDocId"]);
                        Auto.BinNo = dr["BinNo"].ToString();
                        Auto.Weight = Convert.ToSingle(dr["Weight"].ToString());
                        Auto.Remarks_Bin = dr["Remarks_Bin"].ToString();
                        _consignment.Add(Auto);                       
                    }
                    _consignmentCWCN.ConsignmentNoteList = _consignment;
                }
                if (ds.Tables[2].Rows.Count > 0)
                {
                    List<Attachment> _attachmentList = new List<Attachment>();

                    foreach (DataRow dr in ds.Tables[2].Rows)
                    {
                        Attachment obj = new Attachment();

                        obj.AttachmentId = Convert.ToInt32(dr["AttachmentId"]);
                        obj.FileType = dr["FileType"].ToString();
                        obj.FileName = dr["FileName"].ToString();
                        obj.AttachmentName = dr["AttachmentName"].ToString();
                        obj.FilePath = dr["FilePath"].ToString();
                        _attachmentList.Add(obj);

                    }
                    _consignmentCWCN.AttachmentList = _attachmentList;
                }
                Log4NetLogger.LogExit(_FileName, nameof(Get), Level.Info.ToString());
                return _consignmentCWCN;
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
       
        public List<VehicleDetails> VehicleNoFetch(VehicleDetails searchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(VehicleNoFetch), Level.Info.ToString());
                List<VehicleDetails> result = null;
                var pageIndex = searchObject.PageIndex;
                var pageSize = Convert.ToInt32(ConfigurationManager.AppSettings["FetchPopupPageSize"]);
                var dbAccessDAL = new DBAccessDAL();
                var obj = new VehicleDetails();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@VehicleNo", searchObject.VehicleNo ?? "");
                parameters.Add("@pPageIndex", Convert.ToString(pageIndex));
                parameters.Add("@pPageSize", Convert.ToString(pageSize));
                parameters.Add("@pFacilityId", _UserSession.FacilityId.ToString());
                DataTable dt = dbAccessDAL.GetDataTable("sp_HWMS_ConsignmentVehicleNoFetch", parameters, DataSetparameters);
                if (dt != null && dt.Rows.Count > 0)
                {
                    var totalRecords = Convert.ToInt32(dt.Rows[0]["TotalRecords"]);
                    var firstRecord = (pageIndex - 1) * pageSize + 1;
                    var lastRecord = (pageIndex - 1) * pageSize + dt.Rows.Count;
                    var lastPageIndex = totalRecords % pageSize == 0 ? totalRecords / pageSize : (totalRecords / pageSize) + 1;

                    result = (from n in dt.AsEnumerable()
                              select new VehicleDetails
                              {
                                  VehicleId = Convert.ToInt32(n["VehicleId"]),
                                  VehicleNo = Convert.ToString(n["VehicleNo"]),                                  
                                  TotalRecords = totalRecords,
                                  FirstRecord = firstRecord,
                                  LastRecord = lastRecord,
                                  LastPageIndex = lastPageIndex
                              }).ToList();
                }
                Log4NetLogger.LogExit(_FileName, nameof(VehicleNoFetch), Level.Info.ToString());
                return result;
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
        public List<DriverDetails> DriverCodeFetch(DriverDetails searchObject)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(DriverCodeFetch), Level.Info.ToString());
                List<DriverDetails> result = null;
                var pageIndex = searchObject.PageIndex;
                var pageSize = Convert.ToInt32(ConfigurationManager.AppSettings["FetchPopupPageSize"]);
                var dbAccessDAL = new DBAccessDAL();
                var obj = new DriverDetails();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@DriverCode", searchObject.DriverCode ?? "");
                parameters.Add("@pPageIndex", Convert.ToString(pageIndex));
                parameters.Add("@pPageSize", Convert.ToString(pageSize));
                parameters.Add("@pFacilityId", _UserSession.FacilityId.ToString());
                DataTable dt = dbAccessDAL.GetDataTable("sp_HWMS_ConsignmentDriverCodeFetch", parameters, DataSetparameters);
                if (dt != null && dt.Rows.Count > 0)
                {
                    var totalRecords = Convert.ToInt32(dt.Rows[0]["TotalRecords"]);
                    var firstRecord = (pageIndex - 1) * pageSize + 1;
                    var lastRecord = (pageIndex - 1) * pageSize + dt.Rows.Count;
                    var lastPageIndex = totalRecords % pageSize == 0 ? totalRecords / pageSize : (totalRecords / pageSize) + 1;

                    result = (from n in dt.AsEnumerable()
                              select new DriverDetails
                              {
                                  DriverId = Convert.ToInt32(n["DriverId"]),
                                  DriverCode = Convert.ToString(n["DriverCode"]),
                                  DriverName = Convert.ToString(n["DriverName"]),
                                  TotalRecords = totalRecords,
                                  FirstRecord = firstRecord,
                                  LastRecord = lastRecord,
                                  LastPageIndex = lastPageIndex
                              }).ToList();
                }
                Log4NetLogger.LogExit(_FileName, nameof(DriverCodeFetch), Level.Info.ToString());
                return result;
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
        public List<DailyWeighingRecord> AutoDisplayDWRSNO()
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(AutoDisplayDWRSNO), Level.Info.ToString());
                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();

                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "sp_HWMS_ConsignmentNote_DWRSNO";

                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }

                List<DailyWeighingRecord> _consignmentAutoGenerateList = new List<DailyWeighingRecord>();
                foreach (DataRow dr in ds.Tables[0].Rows)
                {
                    DailyWeighingRecord Auto = new DailyWeighingRecord();
                    Auto.DWRId = Convert.ToInt16(dr["DWRId"]);
                    Auto.DWRNo = dr["DWRNo"].ToString();

                    _consignmentAutoGenerateList.Add(Auto);
                }

                Log4NetLogger.LogExit(_FileName, nameof(AutoDisplayDWRSNO), Level.Info.ToString());
                return _consignmentAutoGenerateList;
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
        public ConsignmentNoteCWCN_BinDetails DWRSNOData(int DWRId)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(DWRSNOData), Level.Info.ToString());
                ConsignmentNoteCWCN_BinDetails _bin = new ConsignmentNoteCWCN_BinDetails();

                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "sp_HWMS_Consignment_DWRSNOData";
                        cmd.Parameters.AddWithValue("@DWRId", DWRId);
                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }
                if (ds.Tables.Count != 0)
                {
                    _bin = (from n in ds.Tables[0].AsEnumerable()
                                  select new ConsignmentNoteCWCN_BinDetails
                                  {
                                      BinNo = Convert.ToString(n["BinNo"]),
                                      Weight = Convert.ToSingle(n["Weight"]),
                                    
                                  }).FirstOrDefault();
                }
                Log4NetLogger.LogExit(_FileName, nameof(DWRSNOData), Level.Info.ToString());
                return _bin;
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
        public ConsignmentNoteCWCN TreatmentPlantData(string TreatmentPlantId)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(TreatmentPlantData), Level.Info.ToString());
                ConsignmentNoteCWCN _obj = new ConsignmentNoteCWCN();

                var ds = new DataSet();

                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "sp_HWMS_Consignment_TreatmentPlantData";
                        cmd.Parameters.AddWithValue("@TreatmentPlantId", TreatmentPlantId);
                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }
                if (ds.Tables.Count != 0)
                {
                    _obj = (from n in ds.Tables[0].AsEnumerable()
                                  select new ConsignmentNoteCWCN
                                  {
                                      Ownership = Convert.ToString(n["Ownership"]),
                                                                       
                                  }).FirstOrDefault();
                }

                Log4NetLogger.LogExit(_FileName, nameof(TreatmentPlantData), Level.Info.ToString());
                return _obj;
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
