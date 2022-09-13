using CP.Framework.Common.ExceptionHandler.ExceptionWrappers;
using CP.Framework.Common.Logging;
using CP.UETrack.DAL.DataAccess.Contracts.HWMS;
using CP.UETrack.DAL.DataAccess.Implementation;
using CP.UETrack.Model;
using CP.UETrack.Model.Common;
using CP.UETrack.Model.HWMS;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using UETrack.DAL;

namespace CP.UETrack.DAL.DataAccess.Implementations.HWMS
{
    public class ConsignmentNoteOSWCNDAL : IConsignmentNoteOSWCNDAL
    {
        private readonly string _FileName = nameof(BlockDAL);
        readonly UserDetailsModel _UserSession = new SessionHelper().UserSession();
        public ConsignmentNoteOSWCNDAL()
        {
        }

        public ConsignmentOSWCNDropDown Load()
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
                var ds = new DataSet();
                var ds1 = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                ConsignmentOSWCNDropDown consignment = new ConsignmentOSWCNDropDown();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        var da = new SqlDataAdapter();
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "Sp_HWMS_ConsignNoteOSWCN_Dropdown";
                        cmd.Parameters.Clear();
                        cmd.Parameters.AddWithValue("@pScreenName", "ConsignmentNoteOSWCN");

                        da.SelectCommand = cmd;
                        da.Fill(ds);
                        if (ds.Tables[0] != null)
                        {
                            consignment.TransportationLov = dbAccessDAL.GetLovRecords(ds.Tables[0]);
                        }                       
                        if (ds.Tables[1] != null)
                        {
                            consignment.FileTypeLovs = dbAccessDAL.GetLovRecords(ds.Tables[1]);
                        }
                    }
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        var da = new SqlDataAdapter();
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "Sp_HWMS_WasteType_DropDown";
                        cmd.Parameters.Clear();
                        cmd.Parameters.AddWithValue("@pScreenName", "Waste Type");
                        da.SelectCommand = cmd;
                        da.Fill(ds1);

                        if (ds1.Tables[1] != null)
                        {
                            consignment.WasteTypeLov = dbAccessDAL.GetLovRecords(ds1.Tables[1]);
                        }
                    }
                }
                Log4NetLogger.LogExit(_FileName, nameof(Load), Level.Info.ToString());
                return consignment;
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
        public ConsignmentNoteOSWCN Save(ConsignmentNoteOSWCN model, out string ErrorMessage)
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
                        cmd.CommandText = "Sp_HWMS_ConsignmentNoteOSWCN_Save";
                        cmd.Parameters.AddWithValue("@ConsignmentOSWCNId", model.ConsignmentOSWCNId);
                        cmd.Parameters.AddWithValue("@CustomerId", model.CustomerId);
                        cmd.Parameters.AddWithValue("@FacilityId", model.FacilityId);
                        cmd.Parameters.AddWithValue("@ConsignmentNoteNo", model.ConsignmentNoteNo);
                        cmd.Parameters.AddWithValue("@DateTime", model.DateTime);
                        cmd.Parameters.AddWithValue("@TotalEst", model.TotalEst);
                        cmd.Parameters.AddWithValue("@TotalNoofPackaging", model.TotalNoofPackaging);
                        cmd.Parameters.AddWithValue("@OSWRepresentative", model.OSWRepresentative);
                        cmd.Parameters.AddWithValue("@OSWRepresentativeDesignation", model.OSWRepresentativeDesignation);
                        cmd.Parameters.AddWithValue("@HospitalRepresentative", model.HospitalRepresentative);
                        cmd.Parameters.AddWithValue("@HospitalRepresentativeDesignation", model.HospitalRepresentativeDesignation);
                        cmd.Parameters.AddWithValue("@TreatmentPlant", model.TreatmentPlant);
                        cmd.Parameters.AddWithValue("@Ownership", model.Ownership);
                        cmd.Parameters.AddWithValue("@VehicleNo", model.VehicleNo);
                        cmd.Parameters.AddWithValue("@DriverName", model.DriverName);
                        cmd.Parameters.AddWithValue("@Wastetype", model.Wastetype);
                        cmd.Parameters.AddWithValue("@WasteCode", model.WasteCode);
                        cmd.Parameters.AddWithValue("@ChargeRM", model.ChargeRM);
                        cmd.Parameters.AddWithValue("@ReturnValueRM", model.ReturnValueRM);
                        cmd.Parameters.AddWithValue("@TransportationCategory", model.TransportationCategory);
                        cmd.Parameters.AddWithValue("@TotalWeight", model.TotalWeight);                        
                        cmd.Parameters.AddWithValue("@Remarks", model.Remarks);
                        cmd.Parameters.AddWithValue("@StartDate", model.StartDate);
                        cmd.Parameters.AddWithValue("@EndDate", model.EndDate);

                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);

                        if (ds.Tables.Count != 0)
                        {
                            cmd.Parameters.Clear();
                            model.ConsignmentOSWCNId = Convert.ToInt32(ds.Tables[0].Rows[0]["ConsignmentOSWCNId"]);
                            if (model.ConsignmentOSWCNId == -1)
                            {                              
                                ErrorMessage = "Consignment Note No already exists";
                            }
                            else
                            {                               
                               
                                var ds1 = new DataSet();
                                cmd.CommandText = "Sp_HWMS_ConsignmentNoteOSWCN_SWRSNo_Save";
                                foreach (var Records in model.ConsignmentSWRSNoDetailsList)
                                {
                                    cmd.Parameters.AddWithValue("@SWRSNoId", Records.SWRSNoId);
                                    cmd.Parameters.AddWithValue("@ConsignmentOSWCNId", model.ConsignmentOSWCNId);
                                    cmd.Parameters.AddWithValue("@UserAreaCode", Records.UserAreaCode);
                                    cmd.Parameters.AddWithValue("@UserAreaName", Records.UserAreaName);
                                    cmd.Parameters.AddWithValue("@SWRSNo", Records.OSWRSNo);
                                    cmd.Parameters.AddWithValue("@isDeleted", Records.isDeleted);

                                    da.SelectCommand = cmd;
                                    da.Fill(ds1);
                                    cmd.Parameters.Clear();

                                }
                                model = Get(model.ConsignmentOSWCNId);
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
                        cmd.CommandText = "Sp_HWMS_ConsignmentNoteOSWCN_GetAll";

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
        public ConsignmentNoteOSWCN Get(int Id)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
                ConsignmentNoteOSWCN receptacles = new ConsignmentNoteOSWCN();
                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "Sp_HWMS_ConsignmentNoteOSWCN_Get";
                        cmd.Parameters.AddWithValue("Id", Id);
                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }
                ConsignmentNoteOSWCN _consignments = new ConsignmentNoteOSWCN();
                if (ds.Tables[0].Rows.Count > 0)
                { 
                    DataRow dr = ds.Tables[0].Rows[0];
                    _consignments.ConsignmentOSWCNId = Convert.ToInt32(dr["ConsignmentOSWCNId"].ToString());
                    _consignments.ConsignmentNoteNo = dr["ConsignmentNoteNo"].ToString();
                    _consignments.DateTime = Convert.ToDateTime(dr["DateTime"].ToString());
                    _consignments.TotalEst = Convert.ToInt32(dr["TotalEst"].ToString());
                    _consignments.TotalNoofPackaging = Convert.ToInt32(dr["TotalNoofPackaging"].ToString());
                    _consignments.OSWRepresentative = dr["OSWRepresentative"].ToString();
                    _consignments.OSWRepresentativeDesignation = dr["OSWRepresentativeDesignation"].ToString();
                    _consignments.HospitalRepresentative = dr["HospitalRepresentative"].ToString();
                    _consignments.HospitalRepresentativeDesignation = dr["HospitalRepresentativeDesignation"].ToString();
                    _consignments.TreatmentPlant = dr["TreatmentPlant"].ToString();
                    _consignments.Ownership = dr["Ownership"].ToString();
                    _consignments.VehicleNo = dr["VehicleNo"].ToString();
                    _consignments.DriverName = dr["DriverName"].ToString();
                    _consignments.Wastetype = dr["Wastetype"].ToString();
                    _consignments.WasteCode = dr["WasteCode"].ToString();
                    _consignments.ChargeRM = Convert.ToInt32(dr["ChargeRM"].ToString());
                    _consignments.ReturnValueRM = Convert.ToInt32(dr["ReturnValueRM"].ToString());
                    _consignments.TransportationCategory = dr["TransportationCategory"].ToString();
                    _consignments.TotalWeight = dr["TotalWeight"].ToString();
                    _consignments.Remarks = dr["Remarks"].ToString();
                    _consignments.StartDate = Convert.ToDateTime(dr["StartDate"].ToString());
                    _consignments.EndDate = Convert.ToDateTime(dr["EndDate"].ToString());
                }                
                if (ds.Tables[1].Rows.Count > 0)
                {
                    List<ConsignmentOSWCN_SWRSNo> _userNote = new List<ConsignmentOSWCN_SWRSNo>();
                    foreach (DataRow dr in ds.Tables[1].Rows)
                    {

                        ConsignmentOSWCN_SWRSNo Auto = new ConsignmentOSWCN_SWRSNo();
                        Auto.SWRSNoId = Convert.ToInt32(dr["SWRSNoId"].ToString());
                        Auto.UserAreaCode = dr["UserAreaCode"].ToString();
                        Auto.UserAreaName = dr["UserAreaName"].ToString();
                        Auto.OSWRSNo = dr["SWRSNo"].ToString();
                        _userNote.Add(Auto); 

                    }
                    _consignments.ConsignmentSWRSNoDetailsList = _userNote;
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
                    _consignments.AttachmentList = _attachmentList;
                }
                Log4NetLogger.LogExit(_FileName, nameof(Get), Level.Info.ToString());
                return _consignments;
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
                
        public ConsignmentNoteOSWCN WasteTypeData(string Wastetype)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(WasteTypeData), Level.Info.ToString());
                ConsignmentNoteOSWCN _consignmentNoteOSWCN = new ConsignmentNoteOSWCN();

                var ds1 = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "Sp_HWMS_WasteCodeData";
                        cmd.Parameters.AddWithValue("@pWastetype", Wastetype);
                        var da1 = new SqlDataAdapter();
                        da1.SelectCommand = cmd;
                        da1.Fill(ds1);
                    }
                }
                if (ds1.Tables.Count != 0)
                {
                    _consignmentNoteOSWCN.WasteDropDownList = (from n in ds1.Tables[0].AsEnumerable()
                                                                select new ConsignmentNoteOSWCN
                                                                {
                                                                    WasteCode = n["WasteCode"].ToString(),
                                                                }).ToList();
                }
                Log4NetLogger.LogExit(_FileName, nameof(WasteTypeData), Level.Info.ToString());
                return _consignmentNoteOSWCN;
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
        public ConsignmentNoteOSWCN FetchConsign(ConsignmentNoteOSWCN model, out string ErrorMessage)
        {            
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(FetchConsign), Level.Info.ToString());
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
                        cmd.CommandText = "SP_HWMS_ConsignmentnoteOSWCNFetch";
                        cmd.Parameters.AddWithValue("@pConsignmentOSWCNId", model.ConsignmentOSWCNId);
                        cmd.Parameters.AddWithValue("@pStartDate", model.StartDate);
                        cmd.Parameters.AddWithValue("@pEndDate", model.EndDate);
                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);

                        if (ds.Tables[0] != null)
                        {
                            if (ds.Tables[0].Rows.Count > 0)
                            {
                                List<ConsignmentOSWCN_SWRSNo> UserAreaNoteList = new List<ConsignmentOSWCN_SWRSNo>();
                                foreach (DataRow dr in ds.Tables[0].Rows)
                                {
                                    ConsignmentOSWCN_SWRSNo Records = new ConsignmentOSWCN_SWRSNo();
                                    Records.SWRSNoId = Convert.ToInt32(dr["SWRSNoId"]);
                                    Records.UserAreaCode = dr["UserAreaCode"].ToString();
                                    Records.UserAreaName = dr["UserAreaName"].ToString();
                                    Records.OSWRSNo = dr["OSWRSNo"].ToString();
                                    UserAreaNoteList.Add(Records);
                                }
                                model.ConsignmentSWRSNoDetailsList = UserAreaNoteList;
                            }
                        }
                    }
                }
                Log4NetLogger.LogExit(_FileName, nameof(FetchConsign), Level.Info.ToString());
                return model;
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
        
    }
}
