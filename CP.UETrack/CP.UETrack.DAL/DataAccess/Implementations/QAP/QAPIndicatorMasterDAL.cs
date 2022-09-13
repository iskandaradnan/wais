using CP.UETrack.DAL.DataAccess.Contracts.QAP;
using CP.UETrack.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using CP.UETrack.Model.QAP;
using CP.Framework.Common.Logging;
using System.Data;
using System.Data.SqlClient;
using UETrack.DAL;
using CP.Framework.Common.ExceptionHandler.ExceptionWrappers;
using CP.UETrack.DAL.DataAccess.Implementation;

namespace CP.UETrack.DAL.DataAccess.Implementations.QAP
{
    public class QAPIndicatorMasterDAL : IQAPIndicatorMasterDAL
    {
        private readonly string _FileName = nameof(QAPIndicatorMasterDAL);
        readonly UserDetailsModel _UserSession = new SessionHelper().UserSession();

        public QAPIndicatorTypeDropdown Load()
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
                var QAPIndicatorTypeDropdown = new QAPIndicatorTypeDropdown();

                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;                        
                        cmd.CommandText = "uspFM_GetServices";
                        // below 2 lines commented due to QAP splitup CR
                        //cmd.CommandText = "uspFM_Dropdown_Others";
                        //cmd.Parameters.AddWithValue("@pTablename", "Service");
                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);

                        if (ds.Tables.Count != 0)
                        {
                            QAPIndicatorTypeDropdown = new QAPIndicatorTypeDropdown();
                            QAPIndicatorTypeDropdown.IndicatorServiceTypeData = dbAccessDAL.GetLovRecords(ds.Tables[0]);
                        }   
                    }
                }

                Log4NetLogger.LogExit(_FileName, nameof(Load), Level.Info.ToString());
                return QAPIndicatorTypeDropdown;
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

        

        public QAPIndicatorMasterModel Get(int Id)
        {            
            Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
            try
            {
                var dbAccessDAL = new DBAccessDAL();
                var QAPIndicatorObj = new QAPIndicatorMasterModel();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pQAPIndicatorId", Id.ToString());
                //parameters.Add("@Operation", "Get");
                DataTable dt = dbAccessDAL.GetDataTable("uspFM_MstQAPIndicator_GetById", parameters, DataSetparameters);
                if (dt != null && dt.Rows.Count > 0)
                {
                    QAPIndicatorObj.QAPIndicatorId = Convert.ToInt16(dt.Rows[0]["QAPIndicatorId"]);
                    QAPIndicatorObj.ServiceId = Convert.ToInt16(dt.Rows[0]["ServiceId"]);
                    QAPIndicatorObj.IndicatorCode = dt.Rows[0]["IndicatorCode"].ToString();
                    QAPIndicatorObj.IndicatorDescription = dt.Rows[0]["IndicatorDescription"].ToString();
                    QAPIndicatorObj.IndicatorStandard = Convert.ToDecimal(dt.Rows[0]["IndicatorStandard"]);
                    QAPIndicatorObj.Timestamp = Convert.ToBase64String((byte[])(dt.Rows[0]["Timestamp"]));
                }
                Log4NetLogger.LogExit(_FileName, nameof(Get), Level.Info.ToString());
                return QAPIndicatorObj;

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

                
        public QAPIndicatorMasterModel Save(QAPIndicatorMasterModel QAPIndicator)
        {   
            Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());
            try
            {                
                var dbAccessDAL = new DBAccessDAL();                
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pQAPIndicatorId", Convert.ToString(QAPIndicator.QAPIndicatorId));
                parameters.Add("@pServiceId", Convert.ToString(QAPIndicator.ServiceId));
                parameters.Add("@pIndicatorCode", Convert.ToString(QAPIndicator.IndicatorCode));
                parameters.Add("@pIndicatorDescription", Convert.ToString(QAPIndicator.IndicatorDescription));
                parameters.Add("@pIndicatorStandard", Convert.ToString(QAPIndicator.IndicatorStandard));
                parameters.Add("@pRemarks", Convert.ToString(QAPIndicator.Remarks));
                parameters.Add("@pUserId", Convert.ToString(_UserSession.UserId));
                parameters.Add("@pTimestamp", Convert.ToString(QAPIndicator.Timestamp));


                DataTable ds = dbAccessDAL.GetDataTable("uspFM_MstQAPIndicator_Save", parameters, DataSetparameters);
                if (ds != null)
                {
                    foreach (DataRow row in ds.Rows)
                    {
                        QAPIndicator.QAPIndicatorId = Convert.ToInt32(row["QAPIndicatorId"]);
                        QAPIndicator.Timestamp = Convert.ToBase64String((byte[])(row["Timestamp"]));
                    }
                }

                Log4NetLogger.LogExit(_FileName, nameof(Save), Level.Info.ToString());
                return QAPIndicator;
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

                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.DBAccessDALByServiceId()))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_MstQAPIndicator_GetAll";  //Change SP Name

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

        public bool Delete(int Id)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Delete), Level.Info.ToString());
            try
            {
                var dbAccessDAL = new DBAccessDAL();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pQAPIndicatorId", Id.ToString());
                DataTable dt = dbAccessDAL.GetDataTable("uspFM_MstQAPIndicator_Delete", parameters, DataSetparameters);//sp name change
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
            catch (Exception)
            {
                throw;
            }
        }
        public bool IsQAPIndicatorMasterCodeDuplicate(QAPIndicatorMasterModel QAPIndicator)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(IsQAPIndicatorMasterCodeDuplicate), Level.Info.ToString());

                var IsDuplicate = true;
                var dbAccessDAL = new DBAccessDAL();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@RescheduleWOId", QAPIndicator.QAPIndicatorId.ToString());
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

        public bool IsRecordModified(QAPIndicatorMasterModel QAPIndicator)
        {
            try
            {

                Log4NetLogger.LogEntry(_FileName, nameof(IsRecordModified), Level.Info.ToString());
                var dbAccessDAL = new DBAccessDAL();
                var recordModifed = false;

                if (QAPIndicator.QAPIndicatorId != 0)
                {

                    var DataSetparameters = new Dictionary<string, DataTable>();
                    var parameters = new Dictionary<string, string>();
                    parameters.Add("@RescheduleWOId", QAPIndicator.QAPIndicatorId.ToString());
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
    }
}
