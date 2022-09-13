using CP.Framework.Common.ExceptionHandler.ExceptionWrappers;
using CP.Framework.Common.Logging;
using CP.UETrack.DAL.DataAccess.Contracts.BEMS;
using CP.UETrack.DAL.DataAccess.Implementation;
using CP.UETrack.Model;
using CP.UETrack.Model.BEMS;
using CP.UETrack.Model.BEMS.CRMWorkOrder;
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
    public class CRMWorkorderAssignDAL : ICRMWorkorderAssignDAL
    {

        private readonly string _FileName = nameof(CRMWorkorderDAL);
        readonly UserDetailsModel _UserSession = new SessionHelper().UserSession();

        public CRMWorkorderAssignDAL()
        {

        }
        public CRMWorkorderDropdownValues Load()
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
                CRMWorkorderDropdownValues CRMWorkorderdropdown = null;

                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_Dropdown";
                        cmd.Parameters.AddWithValue("@pLovKey", "CRMRequestTypeValue,CRMRequestStatusValue");
                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }

                CRMWorkorderdropdown = new CRMWorkorderDropdownValues();
                if (ds.Tables.Count != 0)
                {
                    CRMWorkorderdropdown.TypeofRequestLov = dbAccessDAL.GetLovRecords(ds.Tables[0], "CRMRequestTypeValue");
                }


                Log4NetLogger.LogExit(_FileName, nameof(Load), Level.Info.ToString());
                return CRMWorkorderdropdown;
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

        public CRMWorkorderAssign Save(CRMWorkorderAssign resch, out string ErrorMessage)
        {
            try
            {

                ErrorMessage = string.Empty;
                Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());
                CRMWorkorderAssign griddata = new CRMWorkorderAssign();
                var dbAccessDAL = new DBAccessDAL();
                var parameters = new Dictionary<string, string>();

                //parameters.Add("@pFacilityId", Convert.ToString(_UserSession.FacilityId));

                var DataSetparameters = new Dictionary<string, DataTable>();
                DataTable dt = new DataTable();
                dt.Columns.Add("CRMRequestWOId", typeof(int));
                dt.Columns.Add("AssignedUserId", typeof(int));

                foreach (var i in resch.CRMWorkorderAssignGridData.Where(y => y.IsDeleted))
                {
                    dt.Rows.Add(i.CRMRequestWOId, i.StaffId);
                }

                DataSetparameters.Add("@CRMRescheduling", dt);
                DataTable dt1 = dbAccessDAL.GetDataTable("uspFM_CRMRescheduling_Save", parameters, DataSetparameters);
                if (dt1 != null)
                {
                    foreach (DataRow row in dt1.Rows)
                    {
                        //EODCaptur.CaptureId = Convert.ToInt32(row["CaptureId"]);
                        //EODCaptur.Timestamp = Convert.ToBase64String((byte[])(row["Timestamp"]));
                        //ErrorMessage = Convert.ToString(row["ErrorMessage"]);
                    }
                }

                Log4NetLogger.LogExit(_FileName, nameof(Save), Level.Info.ToString());
                return resch;
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
                        cmd.CommandText = "uspFM_CRMReschedule_GetAll";

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
        public CRMWorkorderAssign Get(int Id)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
            try
            {
                var dbAccessDAL = new DBAccessDAL();
                CRMWorkorderAssign entity = new CRMWorkorderAssign();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pCRMRequestWOId", Id.ToString());
                DataSet ds = dbAccessDAL.GetDataSet("uspFM_WorkOrderAssign_GetById", parameters, DataSetparameters);
                if (ds != null)
                {
                    if (ds.Tables[0] != null && ds.Tables[0].Rows.Count > 0)
                    {
                       
                        entity.TypeOfRequestId = Convert.ToInt32(ds.Tables[0].Rows[0]["TypeOfRequest"]);
                        //entity.StaffMasterId = Convert.ToInt32(ds.Tables[0].Rows[0]["AssignedUserId"]);
                        //entity.StaffName = Convert.ToString(ds.Tables[0].Rows[0]["Assignee"]);
                       
                    }

                    var griddata = (from n in ds.Tables[1].AsEnumerable()
                                    select new CRMWorkorderAssignGrid
                                    {
                                        CRMRequestWOId = Convert.ToInt32(n["CRMRequestWOId"]),
                                        CRMRequestWONo = Convert.ToString(n["CRMWorkOrderNo"]),
                                        CRMWorkOrderDateTime = n.Field<DateTime?>("CRMWorkOrderDateTime"),
                                    }).ToList();

                    if (griddata != null && griddata.Count > 0)
                    {
                        entity.CRMWorkorderAssignGridData = griddata;
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

        public CRMWorkorderAssign FetchWorkorder(CRMWorkorderAssign crm)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(FetchWorkorder), Level.Info.ToString());
            try
            {
                var dbAccessDAL = new DBAccessDAL();
                CRMWorkorderAssign entity = new CRMWorkorderAssign();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pTypeOfRequest", Convert.ToString(crm.TypeOfRequestId));
                parameters.Add("@pFacilityId", Convert.ToString(_UserSession.FacilityId));
                //parameters.Add("@pPageIndex", Convert.ToString(EODCaptur.PageIndex));
                //parameters.Add("@pPageSize", Convert.ToString(EODCaptur.PageSize));
                DataSet dt = dbAccessDAL.GetDataSet("uspFM_CRMWorkOrderReschedule_Fetch", parameters, DataSetparameters);
                if (dt != null && dt.Tables.Count > 0)
                {

                    entity.CRMWorkorderAssignGridData = (from n in dt.Tables[0].AsEnumerable()
                               select new CRMWorkorderAssignGrid
                               {
                                   CRMRequestWOId = n.Field<int>("CRMRequestWOId"),
                                   CRMRequestWONo = Convert.ToString(n["CRMWorkOrderNo"] == DBNull.Value ? "" : (Convert.ToString(n["CRMWorkOrderNo"]))),                                  
                                   CRMWorkOrderDateTime = n.Field<DateTime?>("CRMWorkOrderDateTime"),

                                   //TotalRecords = Convert.ToInt32(n["TotalRecords"]),
                                   //TotalPages = Convert.ToInt32(n["TotalPageCalc"]),
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
    }
}
