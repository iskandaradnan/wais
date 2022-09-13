using CP.Framework.Common.ExceptionHandler.ExceptionWrappers;
using CP.Framework.Common.Logging;
using CP.UETrack.DAL.DataAccess.Contracts.SmartAssign;
using CP.UETrack.DAL.DataAccess.Implementation;
using CP.UETrack.Model;
using CP.UETrack.Model.Portering;
using System;
using System.Collections.Generic;
using System.Data;
using System.Data.SqlClient;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using UETrack.DAL;

namespace CP.UETrack.DAL.DataAccess.Implementations.SmartAssign
{
    public class ManualAssignPorteringDAL : IManualassignPorteringDAL
    {
        private readonly string _FileName = nameof(ManualAssignPorteringDAL);
        readonly UserDetailsModel _UserSession = new SessionHelper().UserSession();

        public ManualAssignPorteringDAL()
        {

        }

        public PorteringLovs Load()
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
                var Lovs = new PorteringLovs();
                string lovs = "PorterMovementCategoryValue,PorterRequestTypeValue,PorterWFStatusValue,PorteringStatusValue,PorterTrasportModeValue,WarrantyCategoryValue";
                var dbAccessDAL = new DBAccessDAL();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pLovKey", lovs);
                DataSet ds = dbAccessDAL.GetDataSet("uspFM_Dropdown", parameters, DataSetparameters);
                if (ds.Tables.Count != 0 && ds.Tables[0].Rows.Count > 0)
                {
                    Lovs.MovementCategoryLovs = dbAccessDAL.GetLovRecords(ds.Tables[0], "PorterMovementCategoryValue");
                    Lovs.RequestTypeLovs = dbAccessDAL.GetLovRecords(ds.Tables[0], "PorterRequestTypeValue");
                    Lovs.WorkFlowStatusLovs = dbAccessDAL.GetLovRecords(ds.Tables[0], "PorterWFStatusValue");
                    Lovs.PorteringStatusLovs = dbAccessDAL.GetLovRecords(ds.Tables[0], "PorteringStatusValue");
                    Lovs.WarrantyCategoryLovs = dbAccessDAL.GetLovRecords(ds.Tables[0], "WarrantyCategoryValue");
                    Lovs.ModeOfTransportLovs = dbAccessDAL.GetLovRecords(ds.Tables[0], "PorterTrasportModeValue");
                }
                var DataSetparameters1 = new Dictionary<string, DataTable>();
                var parameters1 = new Dictionary<string, string>();

                parameters1.Add("@pLovKey", "1");
                parameters1.Add("@pTableName", "PorteringTransaction");
                DataSet ds1 = dbAccessDAL.GetDataSet("uspFM_Dropdown_Others", parameters1, DataSetparameters1);

                if (ds1 != null && ds1.Tables[0] != null && ds1.Tables[0].Rows.Count > 0)
                {
                    Lovs.FromFacilityLovs = dbAccessDAL.GetLovRecords(ds1.Tables[0]);
                }
                var currentDate = DateTime.Now;
                Lovs.PorteringDate = currentDate.Date;
                Log4NetLogger.LogExit(_FileName, nameof(Load), Level.Info.ToString());
                return Lovs;
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

        public PorteringModel Save(PorteringModel model, out string ErrorMessage)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());
            try
            {
                ErrorMessage = string.Empty;
                var DataSetparameters = new Dictionary<string, DataTable>();
                DataTable TypecodeDt = new DataTable();
                var parameters = new Dictionary<string, string>();

                if (model.CurrentWorkFlowId == 247 && model.PorteringStatus == null)
                {
                    model.WFStatusApprovedDate = DateTime.Now;
                }


                parameters.Add("@pPorteringId", Convert.ToString(model.PorteringId));
                parameters.Add("@pAssignedUserId", Convert.ToString(model.MAPAssigneId));
                parameters.Add("@pAssigneeLovId", Convert.ToString(332));

                var dbAccessDAL = new DBAccessDAL();
                DataTable dt = dbAccessDAL.GetDataTable("uspFM_PorteringAssigne_Save", parameters, DataSetparameters);
                if (dt != null)
                {
                    foreach (DataRow row in dt.Rows)
                    {                        
                        //ErrorMessage = Convert.ToString(row["ErrorMessage"]);
                    }
                }
               // EODParamCodeMapping = Get(EODParamCodeMapping.ParameterMappingId, 5, 1);
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

        public PorteringModel Get(int Id)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
            try
            {
                var dbAccessDAL = new DBAccessDAL();
                var obj = new PorteringModel();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pPorteringId", Id.ToString());
                DataSet ds = dbAccessDAL.GetDataSet("uspFM_PorteringTransaction_GetById", parameters, DataSetparameters);
                if (ds != null)
                {
                    if (ds.Tables[0] != null && ds.Tables[0].Rows.Count > 0)
                    {
                        obj.AssetNo = Convert.ToString(ds.Tables[0].Rows[0]["AssetNo"]);
                        obj.WorkOrderNo = Convert.ToString(ds.Tables[0].Rows[0]["MaintenanceWorkNo"]);
                        obj.PorteringDate = Convert.ToDateTime(ds.Tables[0].Rows[0]["PorteringDate"]);
                        obj.PorteringNo = Convert.ToString(ds.Tables[0].Rows[0]["PorteringNo"]);
                        obj.PorteringId = Convert.ToInt16(ds.Tables[0].Rows[0]["PorteringId"]);
                        obj.FacilityName = Convert.ToString(ds.Tables[0].Rows[0]["FromFacilityName"]);
                        obj.BlockName = Convert.ToString(ds.Tables[0].Rows[0]["fromBlockName"]);
                        obj.LevelName = Convert.ToString(ds.Tables[0].Rows[0]["FromLevelName"]);
                        obj.UserAreaName = Convert.ToString(ds.Tables[0].Rows[0]["FromUserAreaName"]);
                        obj.UserLocationName = Convert.ToString(ds.Tables[0].Rows[0]["FromUserLocationName"]);
                       
                        
                    }
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
                        cmd.CommandText = "uspFM_GetNotAssignedPortering_GetAll";

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
            catch (Exception ex)
            {
                throw ex;

            }
        }

    }
}
