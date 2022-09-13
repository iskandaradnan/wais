using CP.UETrack.DAL.DataAccess.Contracts.KPI;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using CP.UETrack.Model;
using CP.UETrack.Model.KPI;
using CP.Framework.Common.Logging;
using System.Data;
using UETrack.DAL;
using System.Data.SqlClient;
using CP.Framework.Common.ExceptionHandler.ExceptionWrappers;
using CP.UETrack.DAL.DataAccess.Implementation;

namespace CP.UETrack.DAL.DataAccess.Implementations.KPI
{
   public class IndicatorMasterDAL : IIndicatorMasterDAL
    {
        private readonly string _FileName = nameof(IndicatorMasterDAL);
        readonly UserDetailsModel _UserSession = new SessionHelper().UserSession();

        public IndicatorTypeDropdown Load()
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
                IndicatorTypeDropdown IndicatorTypeDropdown = null;
                IndicatorMasterModel entity = new IndicatorMasterModel();
                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_Dropdown_Others";
                        cmd.Parameters.AddWithValue("@pTablename", "Service");
                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);

                        if (ds.Tables.Count != 0)
                        {
                            IndicatorTypeDropdown = new IndicatorTypeDropdown();
                            IndicatorTypeDropdown.IndicatorServiceTypeData = dbAccessDAL.GetLovRecords(ds.Tables[0]);                                                        
                        }

                        ds.Clear();
                        cmd.CommandText = "uspFM_Dropdown";
                        cmd.Parameters.Clear();
                        cmd.Parameters.AddWithValue("@pLovKey", "GroupValue");
                        da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);

                        if (ds.Tables.Count != 0)
                        {
                            IndicatorTypeDropdown.IndicatorGroupTypeData = dbAccessDAL.GetLovRecords(ds.Tables[0]);
                        }

                        ds.Clear();
                        cmd.Parameters.Clear();
                        cmd.Parameters.AddWithValue("@pLovKey", "IndicatorFrequencyValue");
                        da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);

                        if (ds.Tables.Count != 0)
                        {
                            IndicatorTypeDropdown.IndicatorFrequencyTypeData = dbAccessDAL.GetLovRecords(ds.Tables[0]);
                        }
                        ds.Clear();
                        cmd.CommandText = "UspFM_MstDedIndicator_GetById";
                        cmd.Parameters.Clear();
                        cmd.Parameters.AddWithValue("@pServiceId", 2);
                        cmd.Parameters.AddWithValue("@pUserId", _UserSession.UserId);                    
                        cmd.Parameters.AddWithValue("@pPageIndex", 1);
                        cmd.Parameters.AddWithValue("@pPageSize", 10);
                        da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);

                        if (ds.Tables.Count != 0)
                        {
                            entity.IndicatorListData = (from n in ds.Tables[0].AsEnumerable()
                                                        select new ItemIndicatorMasterList
                                                        {
                                                            ServiceId = Convert.ToInt32(n["ServiceId"]),
                                                            IndicatorId = Convert.ToInt32(n["IndicatorId"]),
                                                            IndicatorDetId = Convert.ToInt32(n["IndicatorDetId"]),
                                                            //ServiceId= Convert.ToInt32(n["ServiceId"]),
                                                            IndicatorNo = Convert.ToString(n["IndicatorNo"]),
                                                            IndicatorName = Convert.ToString(n["IndicatorName"]),
                                                            IndicatorDesc = Convert.ToString(n["IndicatorDesc"]),
                                                            Frequency = Convert.ToInt32(n["Frequency"])


                                                            //Timestamp = Convert.ToBase64String((byte[])(n["Timestamp"]))
                                                        }).ToList();
                        }
                        if (entity.IndicatorListData.Count > 0)
                        {
                            IndicatorTypeDropdown.ItemData = entity.IndicatorListData;
                        }
                    }
                }

                Log4NetLogger.LogExit(_FileName, nameof(Load), Level.Info.ToString());
                return IndicatorTypeDropdown;
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

                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_MstDedIndicator_GetAll";

                        cmd.Parameters.AddWithValue("@PageIndex", pageFilter.PageIndex);
                        cmd.Parameters.AddWithValue("@PageSize", pageFilter.PageSize);
                        cmd.Parameters.AddWithValue("@strCondition", pageFilter.QueryWhereCondition);
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
            catch (Exception)
            {
                throw;
            }
        } 

       

        public IndicatorMasterModel Save(IndicatorMasterModel Indicator)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());              
                
                var dbAccessDAL = new DBAccessDAL();
                var parameters = new Dictionary<string, string>();                
                parameters.Add("@pUserId", Convert.ToString(_UserSession.UserId));
                parameters.Add("@pIndicatorId", Convert.ToString(Indicator.IndicatorId));
                parameters.Add("@ServiceId", Convert.ToString(Indicator.ServiceId));
                parameters.Add("@Group", Convert.ToString(Indicator.Group));               

                var DataSetparameters = new Dictionary<string, DataTable>();
                DataTable dt = new DataTable();
                dt.Columns.Add("IndicatorDetId", typeof(int));
                dt.Columns.Add("IndicatorId", typeof(int));
                dt.Columns.Add("IndicatorNo", typeof(string));
                dt.Columns.Add("IndicatorName", typeof(string));
                dt.Columns.Add("IndicatorDesc", typeof(string));
                dt.Columns.Add("IndicatorType", typeof(int));
                dt.Columns.Add("Weightage", typeof(decimal));
                dt.Columns.Add("Frequency", typeof(int));                
                //dt.Columns.Add("UserId", typeof(int));

                foreach (var i in Indicator.IndicatorListData)
                {
                    dt.Rows.Add(i.IndicatorDetId, i.IndicatorId, i.IndicatorNo, i.IndicatorName, i.IndicatorDesc, i.IndicatorType, i.Weightage, i.Frequency);

                    //dt.Rows.Add(i.IndicatorDetId, i.IndicatorId, "kk", "kkk", "kkkkk", 10, 22.2, 91);
                       
                }
                DataSetparameters.Add("@MstDedIndicatorDet", dt);
                DataTable dt1 = dbAccessDAL.GetDataTable("uspFM_MstDedIndicator_Save", parameters, DataSetparameters);
                if (dt1 != null)
                {
                    foreach (DataRow row in dt1.Rows)
                    {
                        foreach (var val in Indicator.IndicatorListData)
                        {
                            val.IndicatorId = Convert.ToInt32(row["IndicatorId"]);
                            Indicator.IndicatorId = Convert.ToInt32(row["IndicatorId"]);
                            Indicator.Timestamp = Convert.ToBase64String((byte[])(row["Timestamp"]));
                        }
                    }
                }
                Log4NetLogger.LogExit(_FileName, nameof(Save), Level.Info.ToString());
                return Indicator;
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

        

        public IndicatorMasterModel Get(int Id)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
            try
            {
                IndicatorMasterModel entity = new IndicatorMasterModel();

                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "UspFM_MstDedIndicator_GetById";
                        cmd.Parameters.AddWithValue("@pUserId", _UserSession.UserId);
                        cmd.Parameters.AddWithValue("@pServiceId", Id);                       
                        cmd.Parameters.AddWithValue("@pPageIndex", 1);
                        cmd.Parameters.AddWithValue("@pPageSize", 10);
                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }
                if (ds.Tables.Count != 0)
                {
                    entity.IndicatorListData = (from n in ds.Tables[0].AsEnumerable()
                                              select new ItemIndicatorMasterList
                                              {
                                                  ServiceId = Convert.ToInt32(n["ServiceId"]),
                                                  IndicatorId = Convert.ToInt32(n["IndicatorId"]),
                                                  IndicatorDetId = Convert.ToInt32(n["IndicatorDetId"]),
                                                  //ServiceId= Convert.ToInt32(n["ServiceId"]),
                                                  IndicatorNo = Convert.ToString(n["IndicatorNo"]),
                                                  IndicatorName = Convert.ToString(n["IndicatorName"]),
                                                  IndicatorDesc = Convert.ToString(n["IndicatorDesc"]),                                               
                                                  Frequency= Convert.ToInt32(n["Frequency"])


                                                  //Timestamp = Convert.ToBase64String((byte[])(n["Timestamp"]))
                                              }).ToList();
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

        public bool Delete(int Id)
        {
            throw new NotImplementedException();
           
        }
        public bool IsRecordModified(IndicatorMasterModel Indicator)
        {
            try
            {

                Log4NetLogger.LogEntry(_FileName, nameof(IsRecordModified), Level.Info.ToString());
                var dbAccessDAL = new DBAccessDAL();
                var recordModifed = false;

                if (Indicator.IndicatorId != 0)
                {

                    var DataSetparameters = new Dictionary<string, DataTable>();
                    var parameters = new Dictionary<string, string>();
                    parameters.Add("@RescheduleWOId", Indicator.IndicatorId.ToString());
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

        public bool IsIndicatorMasterCodeDuplicate(IndicatorMasterModel Indicator)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(IsIndicatorMasterCodeDuplicate), Level.Info.ToString());

                var IsDuplicate = true;
                var dbAccessDAL = new DBAccessDAL();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@RescheduleWOId", Indicator.IndicatorId.ToString());
                //parameters.Add("@RescheduleWOCode", RescheduleWO.WorkOrderNo.ToString());
                DataTable dt = dbAccessDAL.GetDataTable("UspFM_RescheduleWO_ValCode", parameters, DataSetparameters); //change sp name
                if (dt != null && dt.Rows.Count > 0)
                {
                    IsDuplicate = Convert.ToBoolean(dt.Rows[0]["IsDuplicate"]);
                }
                return IsDuplicate;
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
