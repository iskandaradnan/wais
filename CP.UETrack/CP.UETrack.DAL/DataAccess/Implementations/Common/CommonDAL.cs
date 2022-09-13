using CP.Framework.Common.ExceptionHandler.ExceptionWrappers;
using CP.Framework.Common.Logging;
using CP.UETrack.DAL.DataAccess.Contracts;
using CP.UETrack.Model;
using CP.UETrack.Model.BEMS;
using CP.UETrack.Model.BEMS.AssetRegister;
using CP.UETrack.Model.GM;
using CP.UETrack.Model.VM;
using QRCoder;
//using QRCoder;
using System;
using System.CodeDom.Compiler;
using System.Collections.Generic;
using System.Configuration;
using System.Data;
using System.Data.SqlClient;
using System.Drawing;
using System.Drawing.Imaging;
using System.Dynamic;
using System.IO;
using System.Linq;
using UETrack.DAL;

namespace CP.UETrack.DAL.DataAccess.Implementation
{
    public class CommonDAL : ICommonDAL
    {
        private readonly string _FileName = nameof(CommonDAL);

        readonly UserDetailsModel _UserSession = new SessionHelper().UserSession();
        public CommonDAL()
        {

        }
        public List<dynamic> ToDynamicList(DataTable dt)
        {
            try
            {
                var dns = new List<dynamic>();

                foreach (var item in dt.AsEnumerable())
                {
                    // Expando objects are IDictionary<string, object>
                    IDictionary<string, object> dn = new ExpandoObject();

                    foreach (var column in dt.Columns.Cast<DataColumn>())
                    {
                        dn[column.ColumnName] = item[column];
                    }

                    dns.Add(dn);
                }
                return dns;
            }
            catch (Exception ex)
            {
                throw;
            }
        }
        public SortPaginateFilter GetProperPaginationFilter(SortPaginateFilter paginationFilter)
        {
            if (paginationFilter.SortOrder.Contains("²"))
            {
                var processString = paginationFilter.SortOrder;
                paginationFilter.SortOrder = processString.Split('²')[0];
                processString = processString.Replace(paginationFilter.SortOrder + "²", "");
                if (processString.Contains("φ"))
                {
                    var condition = processString.Split('φ');
                    if (paginationFilter.WhereCondition == string.Empty || paginationFilter.WhereCondition == null)
                        paginationFilter.WhereCondition = condition[0] + "=" + condition[1] + " and " + condition[2] + "=" + condition[3];
                    else
                        paginationFilter.WhereCondition = paginationFilter.WhereCondition + " and " + condition[0] + "=" + condition[1] + " and " + condition[2] + "=" + condition[3];
                }
            }
            return paginationFilter;
        }
        public GridFilterResult GetAll(SortPaginateFilter pageFilter, string modelName)
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

                string procedureName = getProcedurename(modelName);


                strOrderBy = string.IsNullOrEmpty(strOrderBy) ? pageFilter.SortColumn + " " + pageFilter.SortOrder : strOrderBy;
                var QueryCondition = pageFilter.QueryWhereCondition;
                var strCondition = string.Empty;
                var spsToExclude = new List<string> { "uspFM_EngLoanerTestEquipmentBookingTxn_GetAll", "uspFM_PorteringTransaction_GetAll", "uspFM_EngAssetTypeCode_GetAll", "uspFM_EngSpareParts_GetAll", "UspBEMS_MstContractorandVendor_GetAll", "UspBEMS_MstContractorandVendor_GetAll", "uspFM_EngSpareParts_GetAll", "uspFM_EngAssetPPMCheckList_GetAll", "uspFM_FmsCustomerFeedbackSurveyTxn_GetAll", "uspFMS_FmsAuditPlanningMst_GetAll", "uspFM_WpmCriticalEventTxn_GetAll", "uspFM_EngDefectDetailsTxn_GetAll" };

                var _serviceDBGellAllSP = new List<string> { "uspFM_BERApplicationTxn_GetAll", "uspFM_BERApplicationTxnBER2_GetAll" };


                // spsToExclude.Add();
                //  spsToExclude.Add("UspBEMS_MstContractorandVendor_GetAll");
                if (!spsToExclude.Contains(procedureName))
                {

                    if (string.IsNullOrEmpty(QueryCondition))
                    {
                        strCondition = "FacilityId = " + _UserSession.FacilityId.ToString();
                    }
                    else
                    {
                        strCondition = QueryCondition + " AND FacilityId = " + _UserSession.FacilityId.ToString();
                    }
                }
                else
                {
                    strCondition = QueryCondition;
                }
                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();

                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@PageIndex", pageFilter.PageIndex.ToString());
                parameters.Add("@PageSize", pageFilter.PageSize.ToString());
                parameters.Add("@strCondition", strCondition);

                if (procedureName == "uspFM_EngMaintenanceWorkOrderTxn_GetAll" || procedureName == "uspFM_EngMaintenanceWorkOrderTxn_UnScheduled_GetAll")
                {
                    parameters.Add("@pUserId", Convert.ToString(_UserSession.UserId));
                    parameters.Add("@pAccessLevel", Convert.ToString(_UserSession.AccessLevel));
                    strOrderBy = strOrderBy == "Test desc" ? "WorkOrderStatusId asc, CountingDays desc" : strOrderBy;
                }
                parameters.Add("@strSorting", strOrderBy);

                DataTable dt = new DataTable();
                if ((_serviceDBGellAllSP.Contains(procedureName)))


                {
                    var _service = 0;
                    switch (_UserSession.ModuleId)
                    {
                        case 3:
                            {
                                _service = 2;
                                break;
                            }

                        case 13:
                            {
                                _service = 1;
                                break;
                            }
                        case 19:
                            {
                                _service = 6;
                                break;
                            }
                    }
                    dt = dbAccessDAL.GetDataTableUsingServiceId(procedureName, parameters, DataSetparameters, _service);
                }
                else
                {
                    dt = dbAccessDAL.GetDataTable(procedureName, parameters, DataSetparameters);
                }


                if (dt != null && dt.Rows.Count > 0)
                {
                    var totalRecords = Convert.ToInt32(dt.Rows[0]["TotalRecords"]);
                    var totalPages = (int)Math.Ceiling((float)totalRecords / (float)pageFilter.Rows);

                    var commonDAL = new CommonDAL();
                    var currentPageList = commonDAL.ToDynamicList(dt);
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

        public GridFilterResult MasterGetAll(SortPaginateFilter pageFilter, string modelName)
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

                string procedureName = getProcedurename(modelName);


                strOrderBy = string.IsNullOrEmpty(strOrderBy) ? pageFilter.SortColumn + " " + pageFilter.SortOrder : strOrderBy;
                var QueryCondition = pageFilter.QueryWhereCondition;
                var strCondition = string.Empty;
                var spsToExclude = new List<string> { "uspFM_EngLoanerTestEquipmentBookingTxn_GetAll", "uspFM_PorteringTransaction_GetAll", "uspFM_EngAssetTypeCode_GetAll", "uspFM_EngSpareParts_GetAll", "UspBEMS_MstContractorandVendor_GetAll", "UspBEMS_MstContractorandVendor_GetAll", "uspFM_EngSpareParts_GetAll", "uspFM_EngAssetPPMCheckList_GetAll" };
                // spsToExclude.Add();
                //  spsToExclude.Add("UspBEMS_MstContractorandVendor_GetAll");
                if (!spsToExclude.Contains(procedureName))
                {

                    if (string.IsNullOrEmpty(QueryCondition))
                    {
                        strCondition = "FacilityId = " + _UserSession.FacilityId.ToString();
                    }
                    else
                    {
                        strCondition = QueryCondition + " AND FacilityId = " + _UserSession.FacilityId.ToString();
                    }
                }
                else
                {
                    strCondition = QueryCondition;
                }
                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();

                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@PageIndex", pageFilter.PageIndex.ToString());
                parameters.Add("@PageSize", pageFilter.PageSize.ToString());
                parameters.Add("@strCondition", strCondition);

                if (procedureName == "uspFM_EngMaintenanceWorkOrderTxn_GetAll" || procedureName == "uspFM_EngMaintenanceWorkOrderTxn_UnScheduled_GetAll")
                {
                    parameters.Add("@pUserId", Convert.ToString(_UserSession.UserId));
                    parameters.Add("@pAccessLevel", Convert.ToString(_UserSession.AccessLevel));
                    strOrderBy = strOrderBy == "Test desc" ? "WorkOrderStatusId asc, CountingDays desc" : strOrderBy;
                }
                parameters.Add("@strSorting", strOrderBy);
                DataTable dt = dbAccessDAL.GetDataTable(procedureName, parameters, DataSetparameters);

                if (dt != null && dt.Rows.Count > 0)
                {
                    var totalRecords = Convert.ToInt32(dt.Rows[0]["TotalRecords"]);
                    var totalPages = (int)Math.Ceiling((float)totalRecords / (float)pageFilter.Rows);

                    var commonDAL = new CommonDAL();
                    var currentPageList = commonDAL.ToDynamicList(dt);
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
        public GridFilterResult FEMSGetAll(SortPaginateFilter pageFilter, string modelName)
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

                string procedureName = getProcedurename(modelName);


                strOrderBy = string.IsNullOrEmpty(strOrderBy) ? pageFilter.SortColumn + " " + pageFilter.SortOrder : strOrderBy;
                var QueryCondition = pageFilter.QueryWhereCondition;
                var strCondition = string.Empty;
                var spsToExclude = new List<string> { "uspFM_EngLoanerTestEquipmentBookingTxn_GetAll", "uspFM_PorteringTransaction_GetAll", "uspFM_EngAssetTypeCode_GetAll", "uspFM_EngSpareParts_GetAll", "UspBEMS_MstContractorandVendor_GetAll", "UspBEMS_MstContractorandVendor_GetAll", "uspFM_EngSpareParts_GetAll", "uspFM_EngAssetPPMCheckList_GetAll" };
                // spsToExclude.Add();
                //  spsToExclude.Add("UspBEMS_MstContractorandVendor_GetAll");
                if (!spsToExclude.Contains(procedureName))
                {

                    if (string.IsNullOrEmpty(QueryCondition))
                    {
                        strCondition = "FacilityId = " + _UserSession.FacilityId.ToString();
                    }
                    else
                    {
                        strCondition = QueryCondition + " AND FacilityId = " + _UserSession.FacilityId.ToString();
                    }
                }
                else
                {
                    strCondition = QueryCondition;
                }
                var ds = new DataSet();
                var dbAccessDAL = new FEMSDBAccessDAL();

                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@PageIndex", pageFilter.PageIndex.ToString());
                parameters.Add("@PageSize", pageFilter.PageSize.ToString());
                parameters.Add("@strCondition", strCondition);

                if (procedureName == "uspFM_EngMaintenanceWorkOrderTxn_GetAll" || procedureName == "uspFM_EngMaintenanceWorkOrderTxn_UnScheduled_GetAll")
                {
                    parameters.Add("@pUserId", Convert.ToString(_UserSession.UserId));
                    parameters.Add("@pAccessLevel", Convert.ToString(_UserSession.AccessLevel));
                    strOrderBy = strOrderBy == "Test desc" ? "WorkOrderStatusId asc, CountingDays desc" : strOrderBy;
                }
                parameters.Add("@strSorting", strOrderBy);
                DataTable dt = dbAccessDAL.FEMSGetDataTable(procedureName, parameters, DataSetparameters);

                if (dt != null && dt.Rows.Count > 0)
                {
                    var totalRecords = Convert.ToInt32(dt.Rows[0]["TotalRecords"]);
                    var totalPages = (int)Math.Ceiling((float)totalRecords / (float)pageFilter.Rows);

                    var commonDAL = new CommonDAL();
                    var currentPageList = commonDAL.ToDynamicList(dt);
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
        public GridFilterResult BEMSGetAll(SortPaginateFilter pageFilter, string modelName)
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

                string procedureName = getProcedurename(modelName);


                strOrderBy = string.IsNullOrEmpty(strOrderBy) ? pageFilter.SortColumn + " " + pageFilter.SortOrder : strOrderBy;
                var QueryCondition = pageFilter.QueryWhereCondition;
                var strCondition = string.Empty;
                var spsToExclude = new List<string> { "uspFM_EngLoanerTestEquipmentBookingTxn_GetAll", "uspFM_PorteringTransaction_GetAll", "uspFM_EngAssetTypeCode_GetAll", "uspFM_EngSpareParts_GetAll", "UspBEMS_MstContractorandVendor_GetAll", "UspBEMS_MstContractorandVendor_GetAll", "uspFM_EngSpareParts_GetAll", "uspFM_EngAssetPPMCheckList_GetAll" };
                // spsToExclude.Add();
                //  spsToExclude.Add("UspBEMS_MstContractorandVendor_GetAll");
                if (!spsToExclude.Contains(procedureName))
                {

                    if (string.IsNullOrEmpty(QueryCondition))
                    {
                        strCondition = "FacilityId = " + _UserSession.FacilityId.ToString();
                    }
                    else
                    {
                        strCondition = QueryCondition + " AND FacilityId = " + _UserSession.FacilityId.ToString();
                    }
                }
                else
                {
                    strCondition = QueryCondition;
                }
                var ds = new DataSet();
                var dbAccessDAL = new BEMSDBAccessDAL();

                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@PageIndex", pageFilter.PageIndex.ToString());
                parameters.Add("@PageSize", pageFilter.PageSize.ToString());
                parameters.Add("@strCondition", strCondition);

                if (procedureName == "uspFM_EngMaintenanceWorkOrderTxn_GetAll" || procedureName == "uspFM_EngMaintenanceWorkOrderTxn_UnScheduled_GetAll")
                {
                    parameters.Add("@pUserId", Convert.ToString(_UserSession.UserId));
                    parameters.Add("@pAccessLevel", Convert.ToString(_UserSession.AccessLevel));
                    strOrderBy = strOrderBy == "Test desc" ? "WorkOrderStatusId asc, CountingDays desc" : strOrderBy;
                }
                parameters.Add("@strSorting", strOrderBy);
                DataTable dt = dbAccessDAL.BEMSGetDataTable(procedureName, parameters, DataSetparameters);

                if (dt != null && dt.Rows.Count > 0)
                {
                    var totalRecords = Convert.ToInt32(dt.Rows[0]["TotalRecords"]);
                    var totalPages = (int)Math.Ceiling((float)totalRecords / (float)pageFilter.Rows);

                    var commonDAL = new CommonDAL();
                    var currentPageList = commonDAL.ToDynamicList(dt);
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

        private string getProcedurename(string modelName)
        {
            var procedureName = string.Empty;
            switch (modelName)
            {
                case "EngPPMRegisterMst":
                    procedureName = "uspFM_EngPPMRegisterMst_GetAll";
                    break;
                case "EngPlannerTxn":
                    procedureName = "uspFM_EngPlannerTxn_GetAll";
                    break;
                case "EngPlannerRITxn":
                    procedureName = "uspFM_EngPlannerTxn_RI_GetAll";
                    break;
                case "EngPlannerOtherTxn":
                    procedureName = "uspFM_EngPlannerTxn_Other_GetAll";
                    break;
                case "RescheduleWOFetchModel":
                    procedureName = "uspFM_EngMwoReschedulingTxn_GetAll";
                    break;
                case "EODTypeCodeMappingViewModel":
                    procedureName = "uspFM_EngEODTypeCodeMapping_GetAll";
                    break;
                case "EODCategorySystemViewModel":
                    procedureName = "uspFM_EngEODCategorySystem_GetAll";
                    break;
                case "AssetInformationViewModel":
                    procedureName = "AssetInfo_GetAll";
                    break;
                case "LevelMstViewModel":
                    procedureName = "uspFM_MstLocationLevel_GetAll";
                    break;
                case "BlockMstViewModel":
                    procedureName = "uspFM_MstLocationBlock_GetAll";
                    break;
                case "StaffMstViewModel":
                    procedureName = "uspFM_MstStaff_Facility_GetAll";
                    break;
                case "EngAssetTypeCode":
                    procedureName = "uspFM_EngAssetTypeCode_GetAll";
                    break;
                case "EngSpareParts":
                    procedureName = "uspFM_EngSpareParts_GetAll";
                    break;
                case "BERApplicationTxn":
                    procedureName = "uspFM_BERApplicationTxn_GetAll";
                    break;
                case "ScheduledWorkOrderModel":
                    procedureName = "uspFM_EngMaintenanceWorkOrderTxn_GetAll";
                    break;
                case "Ber2":
                    procedureName = "uspFM_BERApplicationTxnBER2_GetAll";
                    break;
                case "PorteringModel":
                    procedureName = "uspFM_PorteringTransaction_GetAll";
                    break;
                case "UnScheduledWorkOrderModel":
                    procedureName = "uspFM_EngMaintenanceWorkOrderTxn_UnScheduled_GetAll";
                    break;
                case "MstContractorandVendorViewModel":
                    procedureName = "UspBEMS_MstContractorandVendor_GetAll";
                    break;
                case "PPMCheckListModel":
                    procedureName = "uspFM_EngAssetPPMCheckList_GetAll";
                    break;
                case "LoanerBooking":
                    procedureName = "uspFM_EngLoanerTestEquipmentBookingTxn_GetAll";
                    break;
                case "ManualassignViewModel":
                    procedureName = "uspFM_GetNotAssignedWorkOrder_GetAll ";
                    break;

                    //default:
                    //    procedureName = "uspFM_EngPPMRegisterMst_GetAll";
                    //    break; 

            }

            return procedureName;
        }
        public DataTable Export(SortPaginateFilter pageFilter, string SPName)//EODExport
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Export), Level.Info.ToString());
                DataTable result = null;

                var strOrderBy = string.Empty;
                if (pageFilter.SortColumn != string.Empty && pageFilter.SortOrder != string.Empty)
                {
                    strOrderBy = pageFilter.SortColumn + " " + pageFilter.SortOrder;
                }

                var spsToExclude = new List<string> { "uspFM_UMUserRole_Export","uspFM_EngLoanerTestEquipmentBookingTxn_Export", "uspFM_EngAssetStandardization_Export","uspFM_MstContractorandVendor_Export",

                    "uspFM_MstCustomer_Export", "uspFM_EngAssetTypeCode_Export", "uspFM_MstLocationFacility_Export", "uspFM_EngSpareParts_Export" ,
                    "uspFM_MstQAPQualityCause_Export","uspFM_MstQAPIndicator_Export","uspFM_EngAssetClassification_Export","uspFM_EngAssetStandardizationInformation_Export",
                    "uspFM_EngEODCategorySystemDet_Export","uspFM_EngAssetPPMCheckList_Export","uspFM_EngEODCategorySystem_Export", "uspFM_FMLovMst_Export",
                    "uspFM_DedGenerationTxn_A", "uspFM_EngAssetMaintenanceHistory_Export",
                    "uspFM_NotificationTemplate_Export", "uspFM_UMUserRegistration_Export","uspFM_PorteringTransaction_Export" };
                var strCondition = pageFilter.WhereCondition;
                if (!spsToExclude.Contains(SPName))
                {
                    //var QueryCondition = pageFilter.QueryWhereCondition;
                    if (string.IsNullOrEmpty(strCondition))
                    {
                        strCondition = " FacilityId = " + _UserSession.FacilityId.ToString();
                    }
                    else
                    {
                        strCondition += " AND FacilityId = " + _UserSession.FacilityId.ToString();
                    }
                }

                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = SPName;
                        cmd.Parameters.AddWithValue("@strCondition", strCondition ?? "");
                        
                        if (SPName == "uspFM_EngAsset_Export" || SPName == "uspFM_EngMaintenanceWorkOrderTxn_UnSchedule_Export" || SPName == "uspFM_EngMaintenanceWorkOrderTxn_Export")
                        {
                            cmd.Parameters.AddWithValue("@pUserId", Convert.ToString(_UserSession.UserId));
                            cmd.Parameters.AddWithValue("@pAccessLevel", Convert.ToString(_UserSession.AccessLevel));
                            strOrderBy = strOrderBy == "Test desc" ? "WorkOrderStatusId asc, CountingDays desc" : strOrderBy;
                        }
                        cmd.Parameters.AddWithValue("@strSorting", strOrderBy ?? "");
                        if (SPName == "uspFM_UMUserRegistration_Export")
                        {
                            cmd.Parameters.AddWithValue("@UserId", _UserSession.UserId);
                        }
                        if (SPName == "uspFM_VMRollOverFeeReport_Export")
                        {
                            cmd.Parameters.AddWithValue("@FacilityId", _UserSession.FacilityId);
                        }
                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }
                if (ds.Tables.Count != 0 && ds.Tables[0].Rows.Count > 0)
                {
                    result = ds.Tables[0];
                }

                Log4NetLogger.LogExit(_FileName, nameof(Export), Level.Info.ToString());
                return result;

            }
            catch (DALException dalException)
            {
                throw new DALException(dalException);
            }
            catch (Exception ex)
            {
                throw new DALException(ex);
            }
        }

        public DataTable KPIExport(string SPName, KPIGenerationFetch KpiGenerationFetch)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Export), Level.Info.ToString());
                DataTable result = null;

                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = SPName;

                        cmd.Parameters.AddWithValue("@pYear", KpiGenerationFetch.Year);
                        cmd.Parameters.AddWithValue("@pMonth", KpiGenerationFetch.Month);
                        cmd.Parameters.AddWithValue("@pServiceId", KpiGenerationFetch.ServiceId);
                        cmd.Parameters.AddWithValue("@pFacilityId", _UserSession.FacilityId);
                        if (SPName != "uspFM_DedGenerationTxn_A")
                        {
                            cmd.Parameters.AddWithValue("@pIndicatorNo", KpiGenerationFetch.IndicatorNo);
                        }

                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }
                if (ds.Tables.Count != 0 && ds.Tables[0].Rows.Count > 0)
                {
                    if (SPName != "uspFM_DedGenerationTxn_A")
                    {
                        result = ds.Tables[0];
                    }
                    else
                    {
                        var table = new DataTable();
                        table.Columns.Add(new DataColumn("IndicatorNo", typeof(string)));
                        table.Columns.Add(new DataColumn("IndicatorDescription", typeof(string)));
                        table.Columns.Add(new DataColumn("DemeritPoints", typeof(string)));
                        table.Columns.Add(new DataColumn("KPIValue(RM)", typeof(string)));
                        table.Columns.Add(new DataColumn("KPI %", typeof(string)));
                        foreach (DataRow row in ds.Tables[0].Rows)
                        {
                            table.Rows.Add(row["IndicatorNo"], row["IndicatorName"], row["TotalDemeritPoints"], row["DeductionValue"], row["DeductionPer"]);
                        }
                        result = table;
                    }
                }

                Log4NetLogger.LogExit(_FileName, nameof(Export), Level.Info.ToString());
                return result;

            }
            catch (DALException dalException)
            {
                throw new DALException(dalException);
            }
            catch (Exception ex)
            {
                throw new DALException(ex);
            }
        }
        public DataTable WarrantyHistory(string SPName, string AssetId)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Export), Level.Info.ToString());
                DataTable result = null;

                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = SPName;

                        cmd.Parameters.AddWithValue("@pAssetId", AssetId);
                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }
                if (ds.Tables.Count != 0 && ds.Tables[0].Rows.Count > 0)
                {
                    result = ds.Tables[0];
                }

                Log4NetLogger.LogExit(_FileName, nameof(Export), Level.Info.ToString());
                return result;

            }
            catch (DALException dalException)
            {
                throw new DALException(dalException);
            }
            catch (Exception ex)
            {
                throw new DALException(ex);
            }
        }
        public FileUploadDetModel DownloadAttachments(int dcoumentId)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(DownloadAttachments), Level.Info.ToString());
                var obj = new FileUploadDetModel();
                var dbAccessDAL = new DBAccessDAL();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pDcoumentId", Convert.ToString(dcoumentId));
                var pathLocation = ConfigurationManager.AppSettings["FileUploadUETRACK"];
                DataTable dt = dbAccessDAL.GetDataTable("uspFM_FMDocument_Download", parameters, DataSetparameters);
                if (dt != null && dt.Rows.Count > 0)
                {
                    obj.DocumentId = Convert.ToInt16(dt.Rows[0]["DocumentId"]);
                    obj.FileName = Convert.ToString(dt.Rows[0]["FileName"]);
                    obj.DocumentTitle = Convert.ToString(dt.Rows[0]["FileName"]);

                }
                var localFilePath = System.IO.Path.Combine(pathLocation, obj.FileName);
                if (File.Exists(localFilePath))
                {
                    obj.FilePath = localFilePath;
                    return obj;
                }
                Log4NetLogger.LogExit(_FileName, nameof(DownloadAttachments), Level.Info.ToString());
                return null;
            }
            catch (DALException dx)
            {
                throw new DALException(dx);
            }
            catch (Exception ex)
            {
                throw new DALException(ex);
            }
        }
        //public byte[] GenerateQRCode(string Code)
        //{
        //    using (MemoryStream ms = new MemoryStream())
        //    {
        //        QRCodeGenerator qrGenerator = new QRCodeGenerator();
        //        QRCodeGenerator.qrCode = qrGenerator.CreateQrCode(Code, QRCodeGenerator.ECCLevel.Q);
        //        using (Bitmap bitMap = qrCode.GetGraphic(20))
        //        {
        //            bitMap.Save(ms, ImageFormat.Png);
        //            return ms.ToArray();
        //        }
        //    }
        //}
        public DataTable MonthlyStockRegisterExport(string SPName, ItemMonthlyStockRegisterList monthlystkRegmodel)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(MonthlyStockRegisterExport), Level.Info.ToString());
                DataTable result = null;

                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = SPName;

                        cmd.Parameters.AddWithValue("@pYear", monthlystkRegmodel.Year);
                        cmd.Parameters.AddWithValue("@pMonth", monthlystkRegmodel.Month);
                        cmd.Parameters.AddWithValue("@pPartNo", monthlystkRegmodel.PartNo);
                        cmd.Parameters.AddWithValue("@pPartDescription", monthlystkRegmodel.PartDescription);
                        cmd.Parameters.AddWithValue("@pItemCode", monthlystkRegmodel.ItemCode);
                        cmd.Parameters.AddWithValue("@pItemDescription", monthlystkRegmodel.ItemDescription);
                        cmd.Parameters.AddWithValue("@pSparePartType", monthlystkRegmodel.SparePartTypeName);
                        cmd.Parameters.AddWithValue("@pCustomerId", _UserSession.CustomerId);
                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }
                if (ds.Tables.Count != 0 && ds.Tables[0].Rows.Count > 0)
                {
                    result = ds.Tables[0];
                }
                Log4NetLogger.LogExit(_FileName, nameof(MonthlyStockRegisterExport), Level.Info.ToString());
                return result;

            }
            catch (DALException dalException)
            {
                throw new DALException(dalException);
            }
            catch (Exception ex)
            {
                throw new DALException(ex);
            }
        }
        public DataTable VerificationOfVariationExport(string SPName, VVFEntity vvfExport)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(MonthlyStockRegisterExport), Level.Info.ToString());
                DataTable result = null;

                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = SPName;

                        cmd.Parameters.AddWithValue("@pYear", vvfExport.Year);
                        cmd.Parameters.AddWithValue("@pMonth", vvfExport.Month);
                        cmd.Parameters.AddWithValue("@pVariationStatus", vvfExport.VariationStatusValue);
                        cmd.Parameters.AddWithValue("@pFacilityId", vvfExport.FacilityId);
                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }
                if (ds.Tables.Count != 0 && ds.Tables[0].Rows.Count > 0)
                {
                    result = ds.Tables[0];
                }
                Log4NetLogger.LogExit(_FileName, nameof(MonthlyStockRegisterExport), Level.Info.ToString());
                return result;

            }
            catch (DALException dalException)
            {
                throw new DALException(dalException);
            }
            catch (Exception ex)
            {
                throw new DALException(ex);
            }
        }
        public LovMasterViewModel GetHelpDescription(string ScreenUrl)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(GetHelpDescription), Level.Info.ToString());
                var dbAccessDAL = new DBAccessDAL();
                LovMasterViewModel entity = new LovMasterViewModel();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();

                parameters.Add("@pScreenURL", ScreenUrl);
                var Description = new List<LovMasterGrid>();
                DataSet ds = dbAccessDAL.GetDataSet("uspFM_UmScreenHelp_GetById", parameters, DataSetparameters);
                if (ds != null)
                {

                    Description = (from n in ds.Tables[0].AsEnumerable()
                                   select new LovMasterGrid
                                   {

                                       HelpDescription = Convert.ToString(n["HelpDescription"] == DBNull.Value ? "" : (Convert.ToString(n["HelpDescription"]))),

                                   }).ToList();
                    entity.LovMasterGridData = Description;
                }


                Log4NetLogger.LogExit(_FileName, nameof(GetHelpDescription), Level.Info.ToString());
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

        public List<HistoryViewModel> History(string GuId, int PageIndex, int PageSize)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(History), Level.Info.ToString());
                var dbAccessDAL = new DBAccessDAL();
                var result = new List<HistoryViewModel>();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();

                parameters.Add("@pTableGuid", GuId);
                parameters.Add("@pPageIndex", PageIndex.ToString());
                parameters.Add("@pPageSize", PageSize.ToString());
                DataTable dt = dbAccessDAL.GetDataTable("UspFM_FmHistory_GetById", parameters, DataSetparameters);

                if (dt != null)
                {
                    var totalRecords = Convert.ToInt32(dt.Rows[0]["TotalRecords"]);
                    var firstRecord = (PageIndex - 1) * PageSize + 1;
                    var lastRecord = (PageIndex - 1) * PageSize + dt.Rows.Count;
                    var lastPageIndex = totalRecords % PageSize == 0 ? totalRecords / PageSize : (totalRecords / PageSize) + 1;
                   
                    foreach (DataRow row in dt.Rows)
                    {
                        var data = new HistoryViewModel
                        {
                            TableRowData = Convert.ToString(row["TableRowData"]),
                            PageIndex = PageIndex,
                            PageSize = PageSize,
                            TotalRecords = totalRecords,
                            FirstRecord = firstRecord,
                            LastRecord = lastRecord,
                            LastPageIndex = lastPageIndex,
                        };
                        result.Add(data);
                        if (result.Count > 0)
                        {
                            result.Reverse();
                        }
                    }
                }
                //if (dt.Rows.Count != 0 && dt.Rows.Count > 0)
                //{
                //    var totalRecords = Convert.ToInt32(dt.Rows[0]["TotalRecords"]);
                //    var firstRecord = (PageIndex - 1) * PageSize + 1;
                //    var lastRecord = (PageIndex - 1) * PageSize + dt.Rows.Count;
                //    var lastPageIndex = totalRecords % PageSize == 0 ? totalRecords / PageSize : (totalRecords / PageSize) + 1;
                //    result = (from n in dt.Rows //dt.AsEnumerable()
                //              select new HistoryViewModel
                //              {
                //                  TableRowData = n.Field<string>("TableRowData"),
                //                  PageIndex = PageIndex,
                //                  PageSize = PageSize,
                //                  TotalRecords = totalRecords,
                //                  FirstRecord = firstRecord,
                //                  LastRecord = lastRecord,
                //                  LastPageIndex = lastPageIndex
                //              }).ToList();
                //}



                Log4NetLogger.LogExit(_FileName, nameof(History), Level.Info.ToString());
                return result;
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


        public AssetRegisterImport GetAssetData(string AssetId)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(GetAssetData), Level.Info.ToString());
                AssetRegisterImport assetRegister = null;

                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "uspFM_EngAsset_TemplateExport";
                        cmd.Parameters.AddWithValue("@pAssetId", AssetId);
                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }
                if (ds.Tables.Count != 0 && ds.Tables[0].Rows.Count > 0)
                {
                    assetRegister = (from n in ds.Tables[0].AsEnumerable()
                                     select new AssetRegisterImport
                                     {
                                         //AssetId = Id,
                                         Hospital= Convert.ToString((n["FacilityName"])),
                                         //CustomerId = Convert.ToInt32((n["CustomerId"])),
                                         //FacilityId = Convert.ToInt32((n["FacilityId"])),
                                         Service = Convert.ToString((n["ServiceName"])),
                                         TypeCode = Convert.ToString((n["AssetTypeCode"])),
                                         AssetNo = Convert.ToString((n["AssetNo"])),
                                         AssetDescription = Convert.ToString((n["AssetTypeDescription"])),
                                         ClassificationCode = Convert.ToString((n["AssetClassificationCode"])),
                                         UserDepartment = n.Field<string>("UserAreaCode"),
                                         DepartmentName = n.Field<string>("UserAreaName"),
                                         //UserAreaId = n.Field<int>("UserAreaId"),
                                         //UserLocationId = Convert.ToInt32((n["UserLocationId"])),
                                         LocationNo = Convert.ToString(n["UserLocationCode"]),
                                         LocationName = n.Field<string>("UserLocationName"),
                                         ContractTypeName = n.Field<string>("ContractTypeValue"),
                                         AssetPreRegistrationNo = n.Field<string>("AssetPreRegistrationNo"),
                                         //Modelid = Convert.ToInt32((n["Model"])),
                                         Model = Convert.ToString(n["ModelName"]),
                                         SerialNo = Convert.ToString((n["SerialNo"])),
                                         //ManufacturerId = Convert.ToInt32((n["Manufacturer"])),
                                         Manufacturer = Convert.ToString(n["ManufacturerName"]),                                         
                                         PurchaseCost = n.Field<decimal?>("PurchaseCostRM"),
                                         PurchaseDate = Convert.ToString(n["PurchaseDate"]),
                                         WarrantyStartDate = Convert.ToString(n["WarrantyStartDate"]),
                                         //WarrantyEndDate = Convert.ToString(n["WarrantyEndDate"]),
                                         CommissioningDate = Convert.ToString(n["CommissioningDate"]),
                                         AssetAge = n.Field<decimal?>("AssetAge"),
                                         CumulativePartsCost = n.Field<decimal?>("CumulativePartCost"),                                         
                                         //UnderWarranty = Convert.ToString((n["UnderWarranty"])),
                                         ServiceStatrtDate = Convert.ToString((n["ServiceStartDate"])),
                                         PurchaseOrderNo = Convert.ToString((n["PurchaseOrderNo"])),
                                         WarrantyDuration = Convert.ToString((n["WarrantyDuration"])),
                                         TnCDate = Convert.ToString((n["TnCDate"])),
                                         TnCCompletedDate = Convert.ToString((n["TnCCompletedDate"])),
                                         HandOverDate = Convert.ToString((n["HandOverDate"])),
                                         WarrantyRemarks = Convert.ToString((n["WarrantyRemarks"])),
                                         CompanyRepresentative = Convert.ToString((n["CompanyRepresentative"])),
                                         FacilityRepresentative = Convert.ToString((n["FacilityRepresentative"])),
                                         VariationStatus = Convert.ToString((n["Variationstatus"])),
                                         TargetDate = Convert.ToString((n["TargetDate"])),


                                         RequesterName = Convert.ToString((n["RequesterName"])),
                                         
                                         RequestDescription = Convert.ToString((n["RequestDescription"])),
                                         Remarks = Convert.ToString((n["Remarks"])),
                                         Assignee = Convert.ToString((n["Assignee"])),
                                        
     
                                }).FirstOrDefault();
                  

                    if (ds != null && ds.Tables[1] != null && ds.Tables[1].Rows.Count > 0)
                    {
                        assetRegister.Vendor = Convert.ToString(ds.Tables[1].Rows[0]["ContractorName"]);
                        assetRegister.TelephoneNo = Convert.ToString(ds.Tables[1].Rows[0]["TelephoneNo"]);
                        assetRegister.FaxNo = Convert.ToString(ds.Tables[1].Rows[0]["FaxNo"]);
                        assetRegister.Email = Convert.ToString(ds.Tables[1].Rows[0]["Email"]);
                      
                    }


                    //}
                }

                Log4NetLogger.LogExit(_FileName, nameof(GetAssetData), Level.Info.ToString());
                return assetRegister;
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

        public static DateTime? checkDate(object field)
        {
            if (field == DBNull.Value)
            {
                return null;
            }
            else
            {
                return Convert.ToDateTime(field);
            }
        }

    }
}
