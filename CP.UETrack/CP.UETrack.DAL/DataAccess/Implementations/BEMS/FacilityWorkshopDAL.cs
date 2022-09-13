using CP.Framework.Common.ExceptionHandler.ExceptionWrappers;
using CP.Framework.Common.Logging;
using CP.UETrack.DAL.DataAccess.Contracts.BEMS;
using CP.UETrack.DAL.DataAccess.Implementation;
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
    public class FacilityWorkshopDAL : IFacilityWorkshopDAL
    {
        private readonly string _FileName = nameof(FacilityWorkshopDAL);
        readonly UserDetailsModel _UserSession = new SessionHelper().UserSession();
        public FacilityWorkshopDropdown Load()
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
                FacilityWorkshopDropdown FacilityWorkshopDropdownvalues = null;

                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();

                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_Dropdown_Others";
                        cmd.Parameters.AddWithValue("@pTablename", "EngFacilitiesWorkshopTxn");
                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);

                        if (ds.Tables.Count != 0)
                        {
                            FacilityWorkshopDropdownvalues = new FacilityWorkshopDropdown();
                            FacilityWorkshopDropdownvalues.ServiceLovs = dbAccessDAL.GetLovRecords(ds.Tables[0]);
                            FacilityWorkshopDropdownvalues.YearLovs = dbAccessDAL.GetLovRecords(ds.Tables[1]);
                            FacilityWorkshopDropdownvalues.FacilityTypeLovs = dbAccessDAL.GetLovRecords(ds.Tables[2]);
                            FacilityWorkshopDropdownvalues.CategoryLovs = dbAccessDAL.GetLovRecords(ds.Tables[3]);
                            FacilityWorkshopDropdownvalues.LocationLovs = dbAccessDAL.GetLovRecords(ds.Tables[4]);
                        }

                        //ds.Clear();
                        //cmd.CommandText = "uspFM_Dropdown_Others";
                        //cmd.Parameters.Clear();
                        //cmd.Parameters.AddWithValue("@pTablename", "EngFacilitiesWorkshopTxn");
                        //da = new SqlDataAdapter();
                        //da.SelectCommand = cmd;
                        //da.Fill(ds);

                        //if (ds.Tables.Count != 0)
                        //{
                        //    FacilityWorkshopDropdownvalues.YearLovs = dbAccessDAL.GetLovRecords(ds.Tables[1]);
                        //}

                        //ds.Clear();
                        //cmd.CommandText = "uspFM_Dropdown_Others";
                        //cmd.Parameters.Clear();
                        //cmd.Parameters.AddWithValue("@pTablename", "EngFacilitiesWorkshopTxn");
                        //da = new SqlDataAdapter();
                        //da.SelectCommand = cmd;
                        //da.Fill(ds);

                        //if (ds.Tables.Count != 0)
                        //{
                        //    FacilityWorkshopDropdownvalues.FacilityTypeLovs = dbAccessDAL.GetLovRecords(ds.Tables[2]);
                        //}

                        //ds.Clear();
                        //cmd.CommandText = "uspFM_Dropdown_Others";
                        //cmd.Parameters.Clear();
                        //cmd.Parameters.AddWithValue("@pTablename", "EngFacilitiesWorkshopTxn");
                        //da = new SqlDataAdapter();
                        //da.SelectCommand = cmd;
                        //da.Fill(ds);

                        //if (ds.Tables.Count != 0)
                        //{
                        //    FacilityWorkshopDropdownvalues.CategoryLovs = dbAccessDAL.GetLovRecords(ds.Tables[3]);
                        //}

                        //ds.Clear();
                        //cmd.CommandText = "uspFM_Dropdown_Others";
                        //cmd.Parameters.Clear();
                        //cmd.Parameters.AddWithValue("@pTablename", "EngFacilitiesWorkshopTxn");
                        //da = new SqlDataAdapter();
                        //da.SelectCommand = cmd;
                        //da.Fill(ds);

                        //if (ds.Tables.Count != 0)
                        //{
                        //    FacilityWorkshopDropdownvalues.LocationLovs = dbAccessDAL.GetLovRecords(ds.Tables[4]);
                        //}
                    }
                }

                Log4NetLogger.LogExit(_FileName, nameof(Load), Level.Info.ToString());
                return FacilityWorkshopDropdownvalues;
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

        public FacilityWorkshop Save(FacilityWorkshop Facility, out string ErrorMessage)
        {
            try
            {
                ErrorMessage = string.Empty;
                Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());

                var dbAccessDAL = new DBAccessDAL();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pFacilitiesWorkshopId", Convert.ToString(Facility.FacilityWorkshopId));
                parameters.Add("@pUserId", Convert.ToString(_UserSession.UserId));
                parameters.Add("@CustomerId", Convert.ToString(_UserSession.CustomerId));
                parameters.Add("@FacilityId", Convert.ToString(_UserSession.FacilityId));
                parameters.Add("@ServiceId", Convert.ToString(2));
                parameters.Add("@Year", Convert.ToString(Facility.Year));
                parameters.Add("@FacilityType", Convert.ToString(Facility.FacilityTypeId));
                parameters.Add("@Category", Convert.ToString(Facility.CategoryId));
                

                var DataSetparameters = new Dictionary<string, DataTable>();
                DataTable dt = new DataTable();
                dt.Columns.Add("FacilitiesWorkshopDetId", typeof(int));
                dt.Columns.Add("FacilitiesWorkshopId", typeof(int));
                dt.Columns.Add("CustomerId", typeof(int));
                dt.Columns.Add("FacilityId", typeof(int));
                dt.Columns.Add("AssetId", typeof(int));
                dt.Columns.Add("Description", typeof(string));
                dt.Columns.Add("Manufacturer", typeof(string));
                dt.Columns.Add("Model", typeof(string));
                dt.Columns.Add("SerialNo", typeof(string));
                dt.Columns.Add("CalibrationDueDate", typeof(DateTime));
                dt.Columns.Add("CalibrationDueDateUTC", typeof(DateTime));
                dt.Columns.Add("Location", typeof(int));
                dt.Columns.Add("Quantity", typeof(int));
                dt.Columns.Add("SizeArea", typeof(decimal));
                dt.Columns.Add("UserId", typeof(int));

                // Delete grid
                var deletedId = Facility.FacilityWorkshopGridData.Where(y => y.IsDeleted).Select(x => x.FacilityWorkshopDetId).ToList();
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

                foreach (var i in Facility.FacilityWorkshopGridData.Where( y => !y.IsDeleted))
                {
                    string CalibrationDueDate = null;
                    if (i.CalibrationDueDate != null)
                    {
                        CalibrationDueDate = i.CalibrationDueDate.Value.ToString("yyyy-MM-dd");
                    }


                    dt.Rows.Add(i.FacilityWorkshopDetId, i.FacilityWorkshopId, _UserSession.CustomerId, _UserSession.FacilityId,  i.AssetId, i.Description, i.Manufacturer, i.Model,
                        i.SerialNo, CalibrationDueDate, CalibrationDueDate, i.LocationId,  i.Quantity, i.SizeArea, _UserSession.UserId);
                }

                DataSetparameters.Add("@EngFacilitiesWorkshopTxnDet", dt);
                DataTable dt1 = dbAccessDAL.GetDataTable("uspFM_EngFacilitiesWorkshopTxn_Save", parameters, DataSetparameters);
                if (dt1 != null)
                {
                    foreach (DataRow row in dt1.Rows)
                    {                     
                        Facility.FacilityWorkshopId = Convert.ToInt32(row["FacilitiesWorkshopId"]);
                        Facility.Timestamp = Convert.ToBase64String((byte[])(row["Timestamp"]));
                        ErrorMessage = Convert.ToString(row["Display"]);
                    }
                }

                Log4NetLogger.LogExit(_FileName, nameof(Save), Level.Info.ToString());
                return Facility;
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
                        cmd.CommandText = "uspFM_EngFacilitiesWorkshopTxn_GetAll";

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
                //return userRoles;
                return filterResult;
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

        public FacilityWorkshop Get(int Id, int pagesize, int pageindex)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
            try
            {

                var dbAccessDAL = new DBAccessDAL();
                var obj = new FacilityWorkshop();

                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pUserId", _UserSession.UserId.ToString());
                parameters.Add("@pFacilitiesWorkshopId", Id.ToString());
                parameters.Add("@pPageIndex", pageindex.ToString());
                parameters.Add("@pPageSize", pagesize.ToString());
                DataSet ds = dbAccessDAL.GetDataSet("UspFM_EngFacilitiesWorkshopTxn_GetById", parameters, DataSetparameters);
                if (ds != null)
                {
                    if (ds.Tables[0] != null && ds.Tables[0].Rows.Count > 0)
                    {
                        obj.FacilityWorkshopId = Convert.ToInt16(ds.Tables[0].Rows[0]["FacilitiesWorkshopId"]);
                        obj.CustomerId = Convert.ToInt16(ds.Tables[0].Rows[0]["CustomerId"]);
                        obj.FacilityId = Convert.ToInt32(ds.Tables[0].Rows[0]["FacilityId"]);
                        obj.ServiceId = Convert.ToInt32(ds.Tables[0].Rows[0]["ServiceId"]);
                        obj.Service = Convert.ToString(ds.Tables[0].Rows[0]["ServiceKey"]);
                        obj.Year = Convert.ToInt16(ds.Tables[0].Rows[0]["Year"]);
                        obj.FacilityTypeId = Convert.ToInt32(ds.Tables[0].Rows[0]["FacilityType"]);
                        obj.FacilityType = Convert.ToString(ds.Tables[0].Rows[0]["FacilityTypeName"]);
                        //obj.CategoryId = Convert.ToInt32(ds.Tables[0].Rows[0]["Category"] == System.DBNull.Value ? 0 : ds.Tables[0].Rows[0]["Category"]);
                        obj.CategoryId = (ds.Tables[0].Rows[0].Field<int?>("Category"));
                        obj.Category = Convert.ToString(ds.Tables[0].Rows[0]["CategoryName"]);
                    }

                    var griddata = (from n in ds.Tables[0].AsEnumerable()
                                          select new FacilityWorkshopGrid
                                          {
                                              FacilityWorkshopDetId = Convert.ToInt32(n["FacilitiesWorkshopDetId"]),
                                              AssetId = Convert.ToInt32(n["AssetId"] == System.DBNull.Value ? 0 : n["AssetId"]),
                                              //AssetId = Convert.ToInt32(n["AssetId"]),
                                              AssetNo = Convert.ToString(n["AssetNo"] == System.DBNull.Value ? "" : n["AssetNo"]),
                                              Description = Convert.ToString(n["Description"] == System.DBNull.Value ? "" : n["Description"]),
                                              Manufacturer = Convert.ToString(n["Manufacturer"] == System.DBNull.Value ? "" : n["Manufacturer"]),
                                              Model = Convert.ToString(n["Model"] == System.DBNull.Value ? "" : n["Model"]),

                                              SerialNo = Convert.ToString(n["SerialNo"] == System.DBNull.Value ? "" : n["SerialNo"]),
                                              //CalibrationDueDate = Convert.ToDateTime(n["CalibrationDueDate"] != DBNull.Value ? (Convert.ToDateTime(n["CalibrationDueDate"])) : (DateTime?)null),

                                              CalibrationDueDate = n.Field<DateTime?>("CalibrationDueDate"),

                                              LocationId = n.Field<int?>("Location"),
                                              Location = Convert.ToString(n["LocationName"] == System.DBNull.Value ? "" : n["LocationName"]),
                                              //Quantity = Convert.ToInt32(n["Quantity"]),
                                              Quantity = n.Field<int?>("Quantity"),
                                             
                                              SizeArea = Convert.ToDecimal(n["SizeArea"] == System.DBNull.Value ? null : n["SizeArea"]) ,
                                              TotalRecords = Convert.ToInt32(n["TotalRecords"]),
                                              TotalPages = Convert.ToInt32(n["TotalPageCalc"]),
                                          }).ToList();

                    


                    if (griddata != null && griddata.Count > 0)
                    {
                        obj.FacilityWorkshopGridData = griddata;
                    }

                    obj.FacilityWorkshopGridData.ForEach((x) =>
                    {
                        x.IsCalibrationDueDateNull = (x.CalibrationDueDate == default(DateTime));
                        x.PageIndex = pageindex;
                        x.FirstRecord = ((pageindex - 1) * pagesize) + 1;
                        x.LastRecord = ((pageindex - 1) * pagesize) + pagesize;
                    });
                }
                Log4NetLogger.LogExit(_FileName, nameof(Get), Level.Info.ToString());
                return obj;

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


        public bool IsRecordModified(FacilityWorkshop WarrantyProvider)
        {
            try
            {

                Log4NetLogger.LogEntry(_FileName, nameof(IsRecordModified), Level.Info.ToString());
                var dbAccessDAL = new DBAccessDAL();
                var recordModifed = false;

                if (WarrantyProvider.FacilityWorkshopId != 0)
                {

                    var DataSetparameters = new Dictionary<string, DataTable>();
                    var parameters = new Dictionary<string, string>();
                    parameters.Add("@RescheduleWOId", WarrantyProvider.FacilityWorkshopId.ToString());
                    parameters.Add("@Operation", "GetTimestamp");
                    DataTable dt = dbAccessDAL.GetDataTable("UspFM_RescheduleWO_Get", parameters, DataSetparameters);//change sp name

                    if (dt != null && dt.Rows.Count > 0)
                    {
                        var timestamp = Convert.ToBase64String((byte[])(dt.Rows[0]["Timestamp"]));
                        //if (timestamp != RescheduleWO.Timestamp)
                        //{
                        recordModifed = true;
                        //}
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

        public bool Delete(int Id)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Delete), Level.Info.ToString());
            try
            {
                var dbAccessDAL = new DBAccessDAL();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pFacilitiesWorkshopId", Id.ToString());
                DataTable dt = dbAccessDAL.GetDataTable("UspFM_EngFacilitiesWorkshopTxn_Delete", parameters, DataSetparameters);
                if (dt != null && dt.Rows.Count > 0)
                {
                    string Message = Convert.ToString(dt.Rows[0]["Message"]);
                }

                Log4NetLogger.LogExit(_FileName, nameof(Delete), Level.Info.ToString());
                return true;
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
                        cmd.CommandText = "uspFM_EngFacilitiesWorkshopTxnDet_Delete";
                        cmd.Parameters.AddWithValue("@pFacilitiesWorkshopDetId", id);

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
            catch (Exception)
            {
                throw;
            }
        }
    }
}
