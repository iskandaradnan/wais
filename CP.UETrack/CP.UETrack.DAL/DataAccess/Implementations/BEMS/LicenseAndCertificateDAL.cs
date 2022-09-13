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
    public class LicenseAndCertificateDAL : ILicenseAndCertificateDAL
    {

        private readonly string _FileName = nameof(LicenseAndCertificateDAL);
        readonly UserDetailsModel _UserSession = new SessionHelper().UserSession();

        public LCDropdownentity Load()
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
                var Dropdownentityval = new LCDropdownentity();

                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_Dropdown";
                        cmd.Parameters.AddWithValue("@pLovKey", "LCCategoryValue,LCPersonnelTypeValue,LCAssetTypeValue,StatusValue");
                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);

                        if (ds.Tables.Count != 0)
                        {
                            Dropdownentityval.LCCategoryValueList = dbAccessDAL.GetLovRecords(ds.Tables[0], "LCCategoryValue");
                            Dropdownentityval.LCPersonnelTypeValueList = dbAccessDAL.GetLovRecords(ds.Tables[0], "LCPersonnelTypeValue");
                            Dropdownentityval.LCAssetTypeValueList = dbAccessDAL.GetLovRecords(ds.Tables[0], "LCAssetTypeValue");
                            Dropdownentityval.StatusValueList = dbAccessDAL.GetLovRecords(ds.Tables[0], "StatusValue");
                        }

                        ds.Clear();
                        cmd.CommandText = "uspFM_Dropdown_Others";
                        cmd.Parameters.Clear();
                        cmd.Parameters.AddWithValue("@pLovKey", null);
                        cmd.Parameters.AddWithValue("@pTableName", "EngLicenseandCertificateTxn");
                        da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);

                        if (ds.Tables.Count != 0)
                        {
                            Dropdownentityval.ServiceList = dbAccessDAL.GetLovRecords(ds.Tables[0]);
                            Dropdownentityval.IssuingBodyList = dbAccessDAL.GetLovRecords(ds.Tables[1]);
                            Dropdownentityval.Designations = dbAccessDAL.GetLovRecords(ds.Tables[2]);
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
        public void save(ref LicenseAndCertificateEntity model)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(save), Level.Info.ToString());
                model.CustomerId = _UserSession.CustomerId;
                int userid = model.CreatedBy = _UserSession.UserId;
                model.FacilityId = _UserSession.FacilityId;
                model.CreatedDate = DateTime.Now;
                var dbAccessDAL = new DBAccessDAL();                
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pUserId", Convert.ToString(userid));
                parameters.Add("@pLicenseId", Convert.ToString(model.LicenseId));
                parameters.Add("@pCustomerId", Convert.ToString(model.CustomerId));
                parameters.Add("@pFacilityId", Convert.ToString(model.FacilityId));
                parameters.Add("@pServiceId", Convert.ToString(model.ServiceId));
                parameters.Add("@pLicenseNo", Convert.ToString(model.LicenseNo));
                parameters.Add("@pLicenseDescription", Convert.ToString(model.LicenseDescription));
                parameters.Add("@pStatus", model.Status.ToString());
                parameters.Add("@pCategory", Convert.ToString(model.Category));
                parameters.Add("@pIfOthersSpecify", Convert.ToString(model.IfOthersSpecify));
                parameters.Add("@pType", Convert.ToString(model.Type));
                parameters.Add("@pAssetTypeCodeId", Convert.ToString(model.AssetTypeCodeId));
                parameters.Add("@pClassGrade", Convert.ToString(model.ClassGrade));
                parameters.Add("@pContactPersonStaffId", Convert.ToString(model.ContactPersonStaffId));
                parameters.Add("@pIssuingBody", Convert.ToString(model.IssuingBody));
                parameters.Add("@pIssuingDate", model.IssuingDate.ToString("yyyy-MM-dd h:mm tt"));
                parameters.Add("@pIssuingDateUTC", model.IssuingDate.ToString("yyyy-MM-dd h:mm tt"));
                parameters.Add("@pNotificationForInspection", model.NotificationForInspection == null ? default(DateTime?).ToString() : model.NotificationForInspection.Value.ToString("yyyy-MM-dd h:mm tt"));
                parameters.Add("@pNotificationForInspectionUTC", model.NotificationForInspectionUTC == null ? default(DateTime?).ToString() : model.NotificationForInspectionUTC.Value.ToString("yyyy-MM-dd h:mm tt"));
                parameters.Add("@pInspectionConductedOn", model.InspectionConductedOn == null ? default(DateTime?).ToString() : model.InspectionConductedOn.Value.ToString("yyyy-MM-dd h:mm tt"));
                parameters.Add("@pInspectionConductedOnUTC", model.InspectionConductedOnUTC == null ? default(DateTime?).ToString() : model.InspectionConductedOnUTC.Value.ToString("yyyy-MM-dd h:mm tt"));
                parameters.Add("@pNextInspectionDate", model.NextInspectionDate == null ? default(DateTime?).ToString() : model.NextInspectionDate.Value.ToString("yyyy-MM-dd h:mm tt"));
                parameters.Add("@pNextInspectionDateUTC", model.NextInspectionDateUTC == null ? default(DateTime?).ToString() : model.NextInspectionDateUTC.Value.ToString("yyyy-MM-dd h:mm tt"));
                parameters.Add("@pExpireDate", model.ExpireDate == null ? default(DateTime?).ToString() : Convert.ToString(model.ExpireDate.Value.ToString("yyyy-MM-dd h:mm tt")));
                parameters.Add("@pExpireDateUTC", model.ExpireDateUTC == null ? default(DateTime?).ToString() : Convert.ToString(model.ExpireDateUTC.Value.ToString("yyyy-MM-dd h:mm tt")));
                parameters.Add("@pPreviousExpiryDate", model.PreviousExpiryDate == null ? default(DateTime?).ToString() : Convert.ToString(model.PreviousExpiryDate.Value.ToString("yyyy-MM-dd h:mm tt")));
                parameters.Add("@pPreviousExpiryDateUTC", model.PreviousExpiryDateUTC == null ? default(DateTime?).ToString() : Convert.ToString(model.PreviousExpiryDateUTC.Value.ToString("yyyy-MM-dd h:mm tt")));
                parameters.Add("@pRegistrationNo", model.RegistrationNo == null ? string.Empty : Convert.ToString(model.RegistrationNo.ToString()));
                var DataSetparameters = new Dictionary<string, DataTable>();
                DataTable dt = new DataTable();
                dt.Columns.Add("LicenseDetId", typeof(int));
                dt.Columns.Add("CustomerId", typeof(int));
                dt.Columns.Add("FacilityId", typeof(int));
                dt.Columns.Add("ServiceId", typeof(int));
                dt.Columns.Add("AssetId", typeof(int));
                dt.Columns.Add("StaffId", typeof(int));
                dt.Columns.Add("Remarks", typeof(string));
                dt.Columns.Add("StaffName", typeof(string));
                dt.Columns.Add("Designation", typeof(string));
                dt.Columns.Add("AssetTypeCode", typeof(string));

                var listval = model.EngLicenseandCertificateTxnDetList != null ? model.EngLicenseandCertificateTxnDetList.Where(x => !x.IsDeleted).ToList() : null;
                if (model.Category == 145)
                    listval = null;
                if (listval != null && listval.Count() > 0)
                {
                    foreach (var item in listval.Where(y => !y.IsDeleted))
                    {
                        dt.Rows.Add(item.LicenseDetId, model.CustomerId, model.FacilityId, model.ServiceId, item.AssetId, item.StaffId, item.Remarks, item.StaffName, item.Designation);
                    }
                    DataSetparameters.Add("@EngLicenseandCertificateTxnDet", dt);
                }

                DataTable ds = dbAccessDAL.GetDataTable("uspFM_EngLicenseandCertificateTxn_Save", parameters, DataSetparameters);
                if (ds != null)
                {
                    foreach (DataRow row in ds.Rows)
                    {
                        model.LicenseId = Convert.ToInt32(row["LicenseId"]);
                        model.Timestamp = ((row["Timestamp"]).ToString());
                        model.ErrorMsg = ((row["ErrorMessage"]).ToString());
                    }
                    model.HiddenId = Convert.ToString(ds.Rows[0]["GuId"]);
                }
                if (string.IsNullOrEmpty(model.ErrorMsg))
                {
                    model = Get(model.LicenseId, 5, 1);

                }
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
        public void update(ref LicenseAndCertificateEntity model)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(update), Level.Info.ToString());
                model.CustomerId = _UserSession.CustomerId;
                int userid = model.CreatedBy = _UserSession.UserId;
                model.FacilityId = _UserSession.FacilityId;
                model.CreatedDate = DateTime.Now;
                var dbAccessDAL = new DBAccessDAL();                
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pUserId", Convert.ToString(userid));
                parameters.Add("@pLicenseId", Convert.ToString(model.LicenseId));
                parameters.Add("@pCustomerId", Convert.ToString(model.CustomerId));
                parameters.Add("@pFacilityId", Convert.ToString(model.FacilityId));
                parameters.Add("@pServiceId", Convert.ToString(model.ServiceId));
                parameters.Add("@pLicenseNo", Convert.ToString(model.LicenseNo));
                parameters.Add("@pLicenseDescription", Convert.ToString(model.LicenseDescription));
                parameters.Add("@pStatus", model.Status.ToString());
                parameters.Add("@pCategory", Convert.ToString(model.Category));
                parameters.Add("@pIfOthersSpecify", Convert.ToString(model.IfOthersSpecify));
                parameters.Add("@pAssetTypeCodeId", Convert.ToString(model.AssetTypeCodeId));
                parameters.Add("@pType", Convert.ToString(model.Type));
                parameters.Add("@pClassGrade", Convert.ToString(model.ClassGrade));
                parameters.Add("@pContactPersonStaffId", Convert.ToString(model.ContactPersonStaffId));
                parameters.Add("@pIssuingBody", Convert.ToString(model.IssuingBody));
                parameters.Add("@pIssuingDate", model.IssuingDate.ToString("yyyy-MM-dd h:mm tt"));
                parameters.Add("@pIssuingDateUTC", model.IssuingDate.ToString("yyyy-MM-dd h:mm tt"));
                parameters.Add("@pNotificationForInspection", model.NotificationForInspection == null ? default(DateTime?).ToString() : model.NotificationForInspection.Value.ToString("yyyy-MM-dd h:mm tt"));
                parameters.Add("@pNotificationForInspectionUTC", model.NotificationForInspectionUTC == null ? default(DateTime?).ToString() : model.NotificationForInspectionUTC.Value.ToString("yyyy-MM-dd h:mm tt"));
                parameters.Add("@pInspectionConductedOn", model.InspectionConductedOn == null ? default(DateTime?).ToString() : model.InspectionConductedOn.Value.ToString("yyyy-MM-dd h:mm tt"));
                parameters.Add("@pInspectionConductedOnUTC", model.InspectionConductedOnUTC == null ? default(DateTime?).ToString() : model.InspectionConductedOnUTC.Value.ToString("yyyy-MM-dd h:mm tt"));
                parameters.Add("@pNextInspectionDate", model.NextInspectionDate == null ? default(DateTime?).ToString() : model.NextInspectionDate.Value.ToString("yyyy-MM-dd h:mm tt"));
                parameters.Add("@pNextInspectionDateUTC", model.NextInspectionDateUTC == null ? default(DateTime?).ToString() : model.NextInspectionDateUTC.Value.ToString("yyyy-MM-dd h:mm tt"));
                parameters.Add("@pExpireDate", model.ExpireDate == null ? default(DateTime?).ToString() : Convert.ToString(model.ExpireDate.Value.ToString("yyyy-MM-dd h:mm tt")));
                parameters.Add("@pExpireDateUTC", model.ExpireDateUTC == null ? default(DateTime?).ToString() : Convert.ToString(model.ExpireDateUTC.Value.ToString("yyyy-MM-dd h:mm tt")));
                parameters.Add("@pPreviousExpiryDate", model.PreviousExpiryDate == null ? default(DateTime?).ToString() : Convert.ToString(model.PreviousExpiryDate.Value.ToString("yyyy-MM-dd h:mm tt")));
                parameters.Add("@pPreviousExpiryDateUTC", model.PreviousExpiryDateUTC == null ? default(DateTime?).ToString() : Convert.ToString(model.PreviousExpiryDateUTC.Value.ToString("yyyy-MM-dd h:mm tt")));
                parameters.Add("@pRegistrationNo", model.RegistrationNo == null ? string.Empty : Convert.ToString(model.RegistrationNo.ToString()));
                parameters.Add("@pTimestamp", model.Timestamp);
                var DataSetparameters = new Dictionary<string, DataTable>();
                DataTable dt = new DataTable();
                dt.Columns.Add("LicenseDetId", typeof(int));
                dt.Columns.Add("CustomerId", typeof(int));
                dt.Columns.Add("FacilityId", typeof(int));
                dt.Columns.Add("ServiceId", typeof(int));
                dt.Columns.Add("AssetId", typeof(int));
                dt.Columns.Add("StaffId", typeof(int));
                dt.Columns.Add("Remarks", typeof(string));
                dt.Columns.Add("StaffName", typeof(string));
                dt.Columns.Add("Designation", typeof(string));
                dt.Columns.Add("AssetTypeCode", typeof(string));
                var listval = model.EngLicenseandCertificateTxnDetList;
                if (model.Category == 145)
                {
                    listval = null;
                }               
                    if (listval != null && listval.Count() > 0)
                    {
                        foreach (var item in listval.Where(y => !y.IsDeleted))
                        {
                            dt.Rows.Add(item.LicenseDetId, model.CustomerId, model.FacilityId, model.ServiceId, item.AssetId, item.StaffId, item.Remarks, item.StaffName, item.Designation);
                        }
                        DataSetparameters.Add("@EngLicenseandCertificateTxnDet", dt);
                    }

                    DataTable ds = dbAccessDAL.GetDataTable("uspFM_EngLicenseandCertificateTxn_Save", parameters, DataSetparameters);
                    if (ds != null)
                    {
                        foreach (DataRow row in ds.Rows)
                        {
                            model.LicenseId = Convert.ToInt32(row["LicenseId"]);
                            model.Timestamp = (row["Timestamp"]).ToString();
                            model.ErrorMsg = ((row["ErrorMessage"]).ToString());
                      
                    }
                    model.HiddenId = Convert.ToString(ds.Rows[0]["GuId"]);
                }
               
                if (string.IsNullOrEmpty(model.ErrorMsg))
                { model = Get(model.LicenseId, 5, 1); }
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
        public LicenseAndCertificateEntity Get(int id, int pagesize, int pageindex)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
                LicenseAndCertificateEntity LicenseAndCertificateEntity = null;

                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "UspFM_EngLicenseandCertificateTxn_GetById";
                        cmd.Parameters.AddWithValue("@pLicenseId", id);
                        //cmd.Parameters.AddWithValue("@pPageIndex", Convert.ToString(pageindex));
                        //cmd.Parameters.AddWithValue("@pPageSize", Convert.ToString(pagesize));
                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }
                if (ds.Tables.Count != 0 && ds.Tables[0].Rows.Count > 0 /*&& ds.Tables[1].Rows.Count > 0
                   && ds.Tables[2].Rows.Count > 0 && ds.Tables[3].Rows.Count > 0*/)
                {
                    LicenseAndCertificateEntity = (from n in ds.Tables[0].AsEnumerable()
                                                   select new LicenseAndCertificateEntity
                                                   {
                                                       LicenseId = Convert.ToInt32(n["LicenseId"]),
                                                       CustomerId = Convert.ToInt32(n["CustomerId"]),
                                                       LicenseNo = (n["LicenseNo"]).ToString(),
                                                       LicenseDescription = (n["LicenseDescription"]).ToString(),
                                                       ServiceId = Convert.ToInt32(n["ServiceId"]),
                                                       Status = Convert.ToInt32(n["Status"]),
                                                       Category = Convert.ToInt32(n["Category"]),
                                                       IfOthersSpecify = n.Field<string>("IfOthersSpecify"),
                                                       AssetTypeCodeId = Convert.ToInt32(n["AssetTypeCodeId"]),
                                                       AssetTypeCode = Convert.ToString(n["AssetTypeCode"]),
                                                       AssetTypeDescription = Convert.ToString(n["AssetTypeDescription"]),
                                                       ClassGrade = n.Field<string>("ClassGrade"),
                                                       ContactPersonStaffId = n.Field<int?>("ContactPersonStaffId"),
                                                       ContactPerson = n.Field<string>("ContactPersonName"),
                                                       IssuingBody = n.Field<int>("IssuingBody"),
                                                       IssuingDate = n.Field<DateTime>("IssuingDate"),
                                                       IssuingDateUTC = n.Field<DateTime>("IssuingDateUTC"),
                                                       NotificationForInspection = Convert.ToDateTime(n["NotificationForInspection"] == DBNull.Value ? default(DateTime?) : n.Field<DateTime>("NotificationForInspection")),
                                                       NotificationForInspectionUTC = Convert.ToDateTime(n["NotificationForInspectionUTC"] == DBNull.Value ? default(DateTime?) : n.Field<DateTime>("NotificationForInspectionUTC")),
                                                       InspectionConductedOn = Convert.ToDateTime(n["InspectionConductedOn"] == DBNull.Value ? default(DateTime?) : n.Field<DateTime>("InspectionConductedOn")),
                                                       InspectionConductedOnUTC = Convert.ToDateTime(n["InspectionConductedOnUTC"] == DBNull.Value ? default(DateTime?) : n.Field<DateTime>("InspectionConductedOnUTC")),
                                                       NextInspectionDate = Convert.ToDateTime(n["NextInspectionDate"] == DBNull.Value ? default(DateTime?) : n.Field<DateTime>("NextInspectionDate")),
                                                       NextInspectionDateUTC = Convert.ToDateTime(n["NextInspectionDateUTC"] == DBNull.Value ? default(DateTime?) : n.Field<DateTime>("NextInspectionDateUTC")),
                                                       ExpireDate = Convert.ToDateTime(n["ExpireDate"] == DBNull.Value ? default(DateTime?) : n.Field<DateTime>("ExpireDate")),
                                                       ExpireDateUTC = Convert.ToDateTime(n["ExpireDateUTC"] == DBNull.Value ? default(DateTime?) : n.Field<DateTime>("ExpireDateUTC")),
                                                       PreviousExpiryDate = Convert.ToDateTime(n["PreviousExpiryDate"] == DBNull.Value ? default(DateTime?) : n.Field<DateTime>("PreviousExpiryDate")),
                                                       PreviousExpiryDateUTC = Convert.ToDateTime(n["PreviousExpiryDateUTC"] == DBNull.Value ? default(DateTime?) : n.Field<DateTime>("PreviousExpiryDateUTC")),
                                                       RegistrationNo = n.Field<string>("RegistrationNo"),
                                                       Timestamp = Convert.ToBase64String((byte[])(n["Timestamp"])),
                                                        HiddenId = Convert.ToString((n["GuId"])),
                                                       LicenseNohistory = n.Field<string>("LicenseNohistory")
                                                   }).FirstOrDefault();
                    if (LicenseAndCertificateEntity.Category == 144)
                    {
                        LicenseAndCertificateEntity.EngLicenseandCertificateTxnDetList = (from n in ds.Tables[1].AsEnumerable()
                                                                                          select new EngLicenseandCertificateTxnDet
                                                                                          {
                                                                                              LicenseDetId = Convert.ToInt32(n["LicenseDetId"]),
                                                                                              LicenseId = n.Field<int>("LicenseId"),
                                                                                              AssetId = n.Field<int?>("AssetId"),
                                                                                              AssetNo = n.Field<string>("Asset"),
                                                                                              AssetDescription = n.Field<string>("AssetDescription"),
                                                                                              Remarks = n.Field<string>("Remarks"),
                                                                                              //AssetTypeCode = n.Field<string>("AssetTypeCode"),
                                                                                              //TotalRecords = Convert.ToInt32(n["TotalRecords"]),
                                                                                              //TotalPages = Convert.ToInt32(n["TotalPageCalc"]),
                                                                                          }).ToList();
                    }
                    if (LicenseAndCertificateEntity.Category == 146)
                    {
                        LicenseAndCertificateEntity.EngLicenseandCertificateTxnDetList = (from n in ds.Tables[1].AsEnumerable()
                                                                                          select new EngLicenseandCertificateTxnDet
                                                                                          {
                                                                                              LicenseDetId = Convert.ToInt32(n["LicenseDetId"]),
                                                                                              LicenseId = n.Field<int>("LicenseId"),
                                                                                              StaffName = n.Field<string>("StaffName"),
                                                                                              AssetTypeCode = n.Field<string>("AssetTypeCode"),
                                                                                              Designation = n.Field<string>("Designation"),
                                                                                              Remarks = n.Field<string>("Remarks"),
                                                                                              StaffId = n.Field<int>("UserId"),
                                                                                              //TotalRecords = Convert.ToInt32(n["TotalRecords"]),
                                                                                              //TotalPages = Convert.ToInt32(n["TotalPageCalc"]),
                                                                                          }).ToList();
                    }
                    if (ds.Tables.Count != 0 && ds.Tables[2].Rows.Count > 0)
                    {

                        LicenseAndCertificateEntity.EngLicenseandCertificateTxnHistoryList = (from n in ds.Tables[2].AsEnumerable()
                                                                                          select new EngLicenseandCertificateTxnHistory
                                                                                          {
                                                                                              LicenseNo = (n["LicenseNo"]).ToString(),
                                                                                              IssuingDate = n.Field<DateTime>("IssuingDate"),
                                                                                              ExpireDate = Convert.ToDateTime(n["ExpireDate"] == DBNull.Value ? default(DateTime?) : n.Field<DateTime>("ExpireDate")),
                                                                                          }).ToList();
                    }
                    //LicenseAndCertificateEntity.EngLicenseandCertificateTxnDetList.ForEach((x) => {
                    //    // entity.TotalCost = x.TotalCost;
                    //    x.PageIndex = pageindex;
                    //    x.FirstRecord = ((pageindex - 1) * pagesize) + 1;
                    //    x.LastRecord = ((pageindex - 1) * pagesize) + pagesize;
                    //});

                }
                Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
                return LicenseAndCertificateEntity;
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
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "UspFM_EngLicenseandCertificateTxn_Delete";
                        cmd.Parameters.AddWithValue("@pLicenseId", id);

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
                var multipleOrderBy = pageFilter.SortColumn.Split(',');
                var strOrderBy = string.Empty;
                var strOrdery1 = new StringBuilder();
                foreach (var order in multipleOrderBy)
                {
                    strOrdery1.Append(order);
                    strOrdery1.Append(" ");
                    strOrdery1.Append(pageFilter.SortOrder);
                    strOrdery1.Append(",");
                }
                strOrderBy = strOrdery1.ToString();

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
                    strCondition = QueryCondition + "AND FacilityId = " + _UserSession.FacilityId.ToString();
                }

                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_EngLicenseandCertificateTxn_GetAll";

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
                Log4NetLogger.LogExit(_FileName, nameof(Getall), Level.Info.ToString());
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
                        cmd.CommandText = "UspFM_EngLicenseandCertificateTxnDet_Delete";
                        cmd.Parameters.AddWithValue("@pLicenseDetId", id);
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
    }
}
