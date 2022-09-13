using CP.Framework.Common.ExceptionHandler.ExceptionWrappers;
using CP.Framework.Common.Logging;
using CP.UETrack.DAL.DataAccess.Contracts.BEMS;
using CP.UETrack.DAL.DataAccess.Implementation;
using CP.UETrack.DAL.DataAccess.Implementations.Common;
using CP.UETrack.Model;
using CP.UETrack.Model.BEMS;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using UETrack.DAL;

namespace CP.UETrack.DAL.DataAccess.Implementations.BEMS
{
    public class EODCaptureDAL : IEODCaptureDAL
    {
        private readonly string _FileName = nameof(EODCaptureDAL);
        readonly UserDetailsModel _UserSession = new SessionHelper().UserSession();

        public EODCaptureDAL()
        {

        }

        public EODCaptureDropdownValues Load()
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
                EODCaptureDropdownValues EODCapDropdown = null;

                var ds = new DataSet();
                var ds1 = new DataSet();
                var ds2 = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_Dropdown_Others";
                        cmd.Parameters.AddWithValue("@pTableName", "EngEODCaptureTxn");
                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }

                EODCapDropdown = new EODCaptureDropdownValues();
                if (ds.Tables.Count != 0)
                {
                    EODCapDropdown.ServiceLovs = dbAccessDAL.GetLovRecords(ds.Tables[0]);
                    EODCapDropdown.CategorySystem = dbAccessDAL.GetLovRecords(ds.Tables[1]);
                }


                Log4NetLogger.LogExit(_FileName, nameof(Load), Level.Info.ToString());
                return EODCapDropdown;
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
        public EODCapture Save(EODCapture EODCaptur, out string ErrorMessage)
        {
            try
            {
                var reqid = EODCaptur.CaptureId;

                ErrorMessage = string.Empty;
                Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());
                EODCapture griddata = new EODCapture();
                var dbAccessDAL = new DBAccessDAL();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pCaptureId", Convert.ToString(EODCaptur.CaptureId));
                parameters.Add("@pCustomerId", Convert.ToString(_UserSession.CustomerId));
                parameters.Add("@pFacilityId", Convert.ToString(_UserSession.FacilityId));
                parameters.Add("@pServiceId", Convert.ToString(2));
                parameters.Add("@pCaptureDocumentNo", Convert.ToString(EODCaptur.CaptureDocumentNo));
                //parameters.Add("@pRecordDate", Convert.ToString(EODCaptur.RecordDate));
                parameters.Add("@pRecordDate", Convert.ToString(EODCaptur.RecordDate == null || EODCaptur.RecordDate == DateTime.MinValue ? null : EODCaptur.RecordDate.ToString("MM-dd-yyy HH:mm")));
                parameters.Add("@pAssetClassificationId", Convert.ToString(EODCaptur.AssetClassificationId));
                parameters.Add("@pAssetTypeCodeId", Convert.ToString(EODCaptur.TypeCodeID));
                //parameters.Add("@pCategorySystemDetId", Convert.ToString(EODCaptur.CategorySystemDetId));
                parameters.Add("@pCaptureStatusLovId", Convert.ToString(EODCaptur.CaptureStatusId));
                parameters.Add("@pAssetId", Convert.ToString(EODCaptur.AssetId));
                parameters.Add("@pUserAreaId", Convert.ToString(EODCaptur.UserAreaId));
                parameters.Add("@pUserLocationId", Convert.ToString(EODCaptur.UserLocationId));
                parameters.Add("@pUserId", Convert.ToString(_UserSession.UserId));
                parameters.Add("@pTimestamp", Convert.ToString(EODCaptur.Timestamp));
                parameters.Add("@pNextCaptureDate", Convert.ToString(EODCaptur.NextCapdate));


                var DataSetparameters = new Dictionary<string, DataTable>();
                DataTable dt = new DataTable();
                dt.Columns.Add("CaptureDetId", typeof(int));
                dt.Columns.Add("CustomerId", typeof(int));
                dt.Columns.Add("FacilityId", typeof(int));
                dt.Columns.Add("ServiceId", typeof(int));
                dt.Columns.Add("CaptureId", typeof(int));
                //dt.Columns.Add("AssetTypeCodeId", typeof(int));
                dt.Columns.Add("ParameterMappingDetId", typeof(int));
                dt.Columns.Add("ParamterValue", typeof(string));
                dt.Columns.Add("Standard", typeof(string));               
                dt.Columns.Add("Minimum", typeof(decimal));
                dt.Columns.Add("Maximum", typeof(decimal));
                dt.Columns.Add("ActualValue", typeof(string));
                dt.Columns.Add("Status", typeof(int));
                dt.Columns.Add("UOMId", typeof(int));

                //EODCaptur.EODCaptureGridData = new List<EODCaptureGrid>();
                foreach (var i in EODCaptur.EODCaptureGridData)
                {
                    dt.Rows.Add(i.CaptureDetId, _UserSession.CustomerId, _UserSession.FacilityId, 2, i.CaptureId,
                        i.ParameterMappingDetId, i.ParamterValue, i.Standard,  i.Minimum, i.Maximum, i.ActualValue, i.Status, i.UOMId);
                }

                DataSetparameters.Add("@EngEODCaptureTxnDet", dt);
                DataTable dt1 = dbAccessDAL.GetDataTable("uspFM_EngEODCaptureTxn_Save", parameters, DataSetparameters);
                if (dt1 != null)
                {
                    foreach (DataRow row in dt1.Rows)
                    {
                        EODCaptur.CaptureId = Convert.ToInt32(row["CaptureId"]);
                        EODCaptur.Timestamp = Convert.ToBase64String((byte[])(row["Timestamp"]));
                        ErrorMessage = Convert.ToString(row["ErrorMessage"]);
                    }
                    EODCaptur.HiddenId = Convert.ToString(dt1.Rows[0]["GuId"]);
                }

                EODCaptur = Get(EODCaptur.CaptureId);
                if (reqid == 0)
                {
                    SendMailNextCapture(EODCaptur);
                }

                Log4NetLogger.LogExit(_FileName, nameof(Save), Level.Info.ToString());
                return EODCaptur;
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
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_EngEODCaptureTxn_GetAll";

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
                Log4NetLogger.LogExit(_FileName, nameof(GetAll), Level.Info.ToString());
                //return EODTypeCodeMappings;
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
        public EODCapture Get(int Id)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
            try
            {
                var dbAccessDAL = new DBAccessDAL();
                EODCapture entity = new EODCapture();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pCaptureId", Id.ToString());
                DataSet ds = dbAccessDAL.GetDataSet("uspFM_EngEODCaptureTxn_GetById", parameters, DataSetparameters);
                if (ds != null)
                {
                    if (ds.Tables[0] != null && ds.Tables[0].Rows.Count > 0)
                    {
                        entity.CaptureId = Convert.ToInt16(ds.Tables[0].Rows[0]["CaptureId"]);
                        entity.CaptureDocumentNo = Convert.ToString(ds.Tables[0].Rows[0]["CaptureDocumentNo"]);
                        //entity.CustomerId = Convert.ToInt16(ds.Tables[0].Rows[0]["CustomerId"]);
                        //entity.FacilityId = Convert.ToInt32(ds.Tables[0].Rows[0]["FacilityId"]);
                        entity.ServiceId = Convert.ToInt32(ds.Tables[0].Rows[0]["ServiceId"]);
                        entity.ServiceName = Convert.ToString(ds.Tables[0].Rows[0]["ServiceKey"]);
                        entity.RecordDate = Convert.ToDateTime(ds.Tables[0].Rows[0]["RecordDate"]);
                        entity.AssetClassificationId = Convert.ToInt32(ds.Tables[0].Rows[0]["AssetClassificationId"]);
                        entity.AssetClassification = Convert.ToString(ds.Tables[0].Rows[0]["AssetClassification"]);
                        entity.AssetId = Convert.ToInt32(ds.Tables[0].Rows[0]["AssetId"]);
                        entity.AssetNo = Convert.ToString(ds.Tables[0].Rows[0]["AssetNo"]);
                        entity.AssetDesc = Convert.ToString(ds.Tables[0].Rows[0]["AssetDescription"]);
                        entity.UserAreaId = Convert.ToInt32(ds.Tables[0].Rows[0]["UserAreaId"]);
                        entity.UserAreaCode = Convert.ToString(ds.Tables[0].Rows[0]["UserAreaCode"]);
                        entity.UserAreaName = Convert.ToString(ds.Tables[0].Rows[0]["UserAreaName"]);
                        entity.UserLocationId = Convert.ToInt32(ds.Tables[0].Rows[0]["UserLocationId"]);
                        entity.UserLocationCode = Convert.ToString(ds.Tables[0].Rows[0]["UserLocationCode"]);
                        entity.UserLocationName = Convert.ToString(ds.Tables[0].Rows[0]["UserLocationName"]);
                        entity.TypeCodeID = Convert.ToInt32(ds.Tables[0].Rows[0]["AssetTypeCodeId"]);
                        entity.TypeCode = Convert.ToString(ds.Tables[0].Rows[0]["AssetTypeCode"]);
                        entity.NextCapdate = ds.Tables[0].Rows[0].Field<DateTime?>("NextCaptureDate");
                        entity.NextCapdateExpiry = ds.Tables[0].Rows[0].Field<int?>("IsExpiry");
                        entity.Email = Convert.ToString(ds.Tables[0].Rows[0]["EmailId"]);
                        entity.FrequencyVal = Convert.ToString(ds.Tables[0].Rows[0]["Frequency"]);
                        

                        entity.Timestamp = Convert.ToBase64String((byte[])(ds.Tables[0].Rows[0]["Timestamp"]));
                        entity.HiddenId = Convert.ToString(ds.Tables[0].Rows[0]["GuId"]);
                    }

                    var griddata = (from n in ds.Tables[1].AsEnumerable()
                                    select new EODCaptureGrid
                                    {
                                        CaptureDetId = Convert.ToInt32(n["CaptureDetId"]),
                                        CaptureId = Convert.ToInt32(n["CaptureId"]),
                                        ParameterMappingDetId = Convert.ToInt32(n["ParameterMappingDetId"]),
                                        ParamterValue = Convert.ToString(n["ParamterValue"]),
                                        Standard = Convert.ToString(n["Standard"]),
                                        UOMId = n.Field<int?>("UOMId"),
                                        UOM = Convert.ToString(n["UnitOfMeasurement"] == DBNull.Value ? "" : (Convert.ToString(n["UnitOfMeasurement"]))),
                                        //Minimum = Convert.ToDecimal(n["Minimum"] == DBNull.Value ? 0 : (Convert.ToDecimal(n["Minimum"]))),
                                        Minimum = n.Field<decimal?>("Minimum"),
                                        //Maximum = Convert.ToDecimal(n["Maximum"]),
                                        Maximum = n.Field<decimal?>("Maximum"),
                                        DataTypeId = Convert.ToInt32(n["DataTypeLovId"]),
                                        DataTypeValue = Convert.ToString(n["DataType"]),

                                        ActualValue = Convert.ToString(n["ActualValue"]),
                                        dataValueDropdown = Convert.ToString(n["DataValue"]),

                                        Status = Convert.ToInt32(n["Status"])
                                    }).ToList();




                    if (griddata != null && griddata.Count > 0)
                    {
                        entity.EODCaptureGridData = griddata;
                    }
                }
                Log4NetLogger.LogExit(_FileName, nameof(Get), Level.Info.ToString());
                return entity;
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

        //public EODCapture BindDetGrid(int serviceId, int CatSysId, DateTime RecDate)
        //{
        //    Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
        //    try
        //    {
        //        var dbAccessDAL = new DBAccessDAL();
        //        EODCapture entity = new EODCapture();
        //        var DataSetparameters = new Dictionary<string, DataTable>();
        //        var parameters = new Dictionary<string, string>();
        //        parameters.Add("@pServiceId", serviceId.ToString());
        //        parameters.Add("@pCategorySystemId", CatSysId.ToString());
        //        parameters.Add("@pRecordDate", RecDate.ToString());

        //        DataSet dt = dbAccessDAL.GetDataSet("uspFM_EngEODParameterMappingDet_GetByCategorySystemId", parameters, DataSetparameters);
        //        if (dt != null && dt.Tables.Count > 0)
        //        {

        //            entity.EODCaptureGridData = (from n in dt.Tables[0].AsEnumerable()
        //                                         select new EODCaptureGrid
        //                                         {
        //                                             ParameterMappingDetId = Convert.ToInt32(n["ParameterMappingDetId"]),
        //                                             ParamterValue = Convert.ToString(n["Parameter"]),
        //                                             Standard = Convert.ToString(n["Standard"]),
        //                                             DataTypeId = Convert.ToInt32(n["DataTypeLovId"]),
        //                                             DataTypeValue = Convert.ToString(n["DataType"]),
        //                                             AlphaNumDataval = Convert.ToString(n["DataValue"]),
        //                                             Minimum = Convert.ToDecimal(n["Minimum"] == DBNull.Value ? 0 : (Convert.ToDecimal(n["Minimum"]))),
        //                                             Maximum = Convert.ToDecimal(n["Maximum"] == DBNull.Value ? 0 : (Convert.ToDecimal(n["Maximum"]))),
        //                                         }).ToList();

        //        }
        //        return entity;

        //    }
        //    catch (DALException dalex)
        //    {
        //        throw new DALException(dalex);
        //    }
        //    catch (Exception ex)
        //    {
        //        throw ex;
        //    }
        //}

        public EODCapture BindDetGrid(EODCapture EODCaptur)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(BindDetGrid), Level.Info.ToString());
            try
            {
                var dbAccessDAL = new DBAccessDAL();
                EODCapture entity = new EODCapture();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                //parameters.Add("@pServiceId", Convert.ToString(EODCaptur.ServiceId));
                //parameters.Add("@pCategorySystemId", Convert.ToString(EODCaptur.CategorySystemId));
                //parameters.Add("@pRecordDate", Convert.ToString(EODCaptur.RecordDate));
                parameters.Add("@pRecordDate", Convert.ToString(EODCaptur.RecordDate == null || EODCaptur.RecordDate == DateTime.MinValue ? null : EODCaptur.RecordDate.ToString("MM-dd-yyy HH:mm")));
                parameters.Add("@pAssetTypeCodeId", Convert.ToString(EODCaptur.TypeCodeID));
                parameters.Add("@pAssetClassificationId", Convert.ToString(EODCaptur.AssetClassificationId));
                parameters.Add("@pUserRegistrationId", Convert.ToString(_UserSession.UserId));
                parameters.Add("@pAssetId", Convert.ToString(EODCaptur.AssetId));
                DataSet dt = dbAccessDAL.GetDataSet("uspFM_EngEODParameterMappingDet_GetByCategorySystemId", parameters, DataSetparameters);
                if (dt != null && dt.Tables.Count > 0)
                {

                    entity.EODCaptureGridData = (from n in dt.Tables[0].AsEnumerable()
                                                 select new EODCaptureGrid
                                                 {
                                                     ParameterMappingDetId = Convert.ToInt32(n["ParameterMappingDetId"]),
                                                     ParamterValue = Convert.ToString(n["Parameter"]),
                                                     Standard = Convert.ToString(n["Standard"]),
                                                     UOMId = n.Field<int?>("UOMId"),
                                                     UOM = Convert.ToString(n["UnitOfMeasurement"] == DBNull.Value ? "" : (Convert.ToString(n["UnitOfMeasurement"]))),
                                                     DataTypeId = Convert.ToInt32(n["DataTypeLovId"]),
                                                     DataTypeValue = Convert.ToString(n["DataType"]),
                                                     AlphaNumDataval = Convert.ToString(n["DataValue"]),
                                                     //Minimum = Convert.ToDecimal(n["Minimum"] == DBNull.Value ? 0 : (Convert.ToDecimal(n["Minimum"]))),
                                                     // Maximum = Convert.ToDecimal(n["Maximum"] == DBNull.Value ? 0 : (Convert.ToDecimal(n["Maximum"]))),
                                                     Minimum = n.Field<decimal?>("Minimum"),
                                                     Maximum = n.Field<decimal?>("Maximum"),
                                                     Email = Convert.ToString(n["Email"] == DBNull.Value ? "" : (Convert.ToString(n["Email"]))),
                                                     Frequency = Convert.ToString(n["Frequency"] == DBNull.Value ? "" : (Convert.ToString(n["Frequency"]))),
                                                 }).ToList();

                }
                return entity;

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
        public bool IsRoleDuplicate(EODCapture EODCaptur)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(IsRoleDuplicate), Level.Info.ToString());

                var isDuplicate = true;
                string constring = ConfigurationManager.ConnectionStrings["UETrackConnectionString"].ConnectionString;
                using (SqlConnection con = new SqlConnection(constring))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "IsRoleDuplicate";
                        cmd.Parameters.AddWithValue("@Id", EODCaptur.CategorySystemId);
                        cmd.Parameters.AddWithValue("@Name", EODCaptur.CategorySystemName);
                        cmd.Parameters.Add("@IsDuplicate", SqlDbType.Bit);
                        cmd.Parameters["@IsDuplicate"].Direction = ParameterDirection.Output;

                        con.Open();
                        cmd.ExecuteNonQuery();
                        con.Close();
                        bool.TryParse(cmd.Parameters["@IsDuplicate"].Value.ToString(), out isDuplicate);
                    }
                }

                Log4NetLogger.LogExit(_FileName, nameof(IsRoleDuplicate), Level.Info.ToString());
                return isDuplicate;
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
        public bool IsRecordModified(EODCapture EODCaptur)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(IsRecordModified), Level.Info.ToString());

                var recordModifed = false;

                if (EODCaptur.CategorySystemId != 0)
                {
                    var ds = new DataSet();
                    string constring = ConfigurationManager.ConnectionStrings["UETrackConnectionString"].ConnectionString;
                    using (SqlConnection con = new SqlConnection(constring))
                    {
                        using (SqlCommand cmd = new SqlCommand())
                        {
                            cmd.Connection = con;
                            cmd.CommandType = CommandType.StoredProcedure;
                            cmd.CommandText = "GetEODTypeCodeMappingTimestamp";
                            cmd.Parameters.AddWithValue("Id", EODCaptur.CategorySystemId);
                            var da = new SqlDataAdapter();
                            da.SelectCommand = cmd;
                            da.Fill(ds);
                        }
                    }
                    if (ds.Tables.Count != 0 && ds.Tables[0].Rows.Count > 0)
                    {
                        var timestamp = Convert.ToBase64String((byte[])(ds.Tables[0].Rows[0]["Timestamp"]));
                        if (timestamp != EODCaptur.Timestamp)
                        {
                            recordModifed = true;
                        }
                    }
                }

                Log4NetLogger.LogExit(_FileName, nameof(IsRecordModified), Level.Info.ToString());
                return recordModifed;
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
        public void Delete(int Id)
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
                        cmd.CommandText = "uspFM_EngEODCaptureTxn_Delete";
                        cmd.Parameters.AddWithValue("@pCaptureId", Id);

                        con.Open();
                        cmd.ExecuteNonQuery();
                        con.Close();
                    }
                }
                Log4NetLogger.LogExit(_FileName, nameof(Delete), Level.Info.ToString());
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

        private void SendMailNextCapture(EODCapture model)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(SendMailNextCapture), Level.Info.ToString());
            try
            {
                string emailTemplateId = string.Empty;
                string subject = string.Empty;
                string subjectVars = string.Empty;
                string templateVars = string.Empty;
                string email = string.Empty;
                email = model.Email;
               //  email = "sairajgill@gmail.com";

                emailTemplateId = "23";
                var nxtcapdt = model.NextCapdate.Value.ToString("dd-MMM-yyyy");
                templateVars = string.Join(",", model.AssetNo, model.CaptureDocumentNo, nxtcapdt);

                var tempid = Convert.ToInt32(emailTemplateId);
                model.TemplateId = tempid;

                var DataSetparameters = new Dictionary<string, DataTable>();
                DataTable TypecodeDt = new DataTable();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pEmailTemplateId", Convert.ToString(emailTemplateId));
                parameters.Add("@pToEmailIds", email);
                parameters.Add("@pSubject", Convert.ToString(subject));
                parameters.Add("@pPriority", Convert.ToString(1));
                parameters.Add("@pSendAsHtml", Convert.ToString(1));
                parameters.Add("@pSubjectVars", Convert.ToString(subjectVars));
                parameters.Add("@pTemplateVars", Convert.ToString(templateVars));


                var dbAccessDAL = new DBAccessDAL();
                DataTable dt = dbAccessDAL.GetDataTable("uspFM_EmailNotify_Save", parameters, DataSetparameters);
                if (dt != null)
                {
                    foreach (DataRow rows in dt.Rows)
                    {


                    }
                }
                NotificationNextCapture(model);
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

        public EODCapture NotificationNextCapture(EODCapture ent)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(NotificationNextCapture), Level.Info.ToString());
            EODCapture griddata = new EODCapture();
            var dbAccessDAL = new DBAccessDAL();
            var parameters = new Dictionary<string, string>();
            var DataSetparameters = new Dictionary<string, DataTable>();
            var nxtcapdt = ent.NextCapdate.Value.ToString("dd-MMM-yyyy");
            var notalert = "Next Capture Due Date for" +" "+ent.AssetNo +" is "+ nxtcapdt;
            var hyplink = "/bems/eodcapture?id=" + ent.CaptureId;

            parameters.Add("@pNotificationId", Convert.ToString(ent.NotificationId));
            parameters.Add("@pCustomerId", Convert.ToString(_UserSession.CustomerId));
            parameters.Add("@pFacilityId", Convert.ToString(_UserSession.FacilityId));
            parameters.Add("@pUserId", Convert.ToString(_UserSession.UserId));
            parameters.Add("@pNotificationAlerts", Convert.ToString(notalert));
            parameters.Add("@pRemarks", Convert.ToString(""));
            parameters.Add("@pHyperLink", Convert.ToString(hyplink));
            parameters.Add("@pIsNew", Convert.ToString(1));
            parameters.Add("@pNotificationDateTime", Convert.ToString(null));
            parameters.Add("@pEmailTempId", Convert.ToString(ent.TemplateId));

            parameters.Add("@pmScreenName", Convert.ToString("ERCapture"));
            parameters.Add("@pMGuid", Convert.ToString(ent.HiddenId));



            DataTable ds = dbAccessDAL.GetDataTable("uspFM_WebNotificationSingle_Save", parameters, DataSetparameters);
            if (ds != null)
            {
                foreach (DataRow row in ds.Rows)
                {
                    //model.CRMRequestId = Convert.ToInt32(row["CRMRequestId"]);
                    //model.Timestamp = Convert.ToBase64String((byte[])(row["Timestamp"]));
                    //// model.err = Convert.ToBase64String((byte[])(row["Timestamp"]));
                    //model.HiddenId = Convert.ToString(row["GuId"]);
                }
            }

            return ent;
        }
    }
}
