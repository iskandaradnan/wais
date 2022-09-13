using CP.UETrack.DAL.DataAccess.Contracts.KPI;
using CP.UETrack.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using CP.UETrack.Model.KPI;
using CP.Framework.Common.Logging;
using System.Data.SqlClient;
using System.Data;
using UETrack.DAL;
using CP.Framework.Common.ExceptionHandler.ExceptionWrappers;

namespace CP.UETrack.DAL.DataAccess.Implementations.KPI
{
    public class ParameterMasterDAL: IParameterMasterDAL
    {
        private readonly string _FileName = nameof(ParameterMasterDAL);
        readonly UserDetailsModel _UserSession = new SessionHelper().UserSession();


        public ParameterTypeDropdown Load()
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
                ParameterTypeDropdown ParameterTypeDropdown = null;

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
                            ParameterTypeDropdown = new ParameterTypeDropdown();
                            ParameterTypeDropdown.ParameterServiceTypeData = dbAccessDAL.GetLovRecords(ds.Tables[0]);
                        }

                        ds.Clear();
                        cmd.CommandText = "uspFM_Dropdown_Others";
                        cmd.Parameters.Clear();
                        cmd.Parameters.AddWithValue("@pTablename", "MstDedSubParameter");
                        da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);

                        if (ds.Tables.Count != 0)
                        {
                            ParameterTypeDropdown.ParameterIndicatorNoTypeData = dbAccessDAL.GetLovRecords(ds.Tables[1]);

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
                            ParameterTypeDropdown.ParameterGroupTypeData = dbAccessDAL.GetLovRecords(ds.Tables[0]);
                        }

                    }
                }

                Log4NetLogger.LogExit(_FileName, nameof(Load), Level.Info.ToString());
                return ParameterTypeDropdown;
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


        public ParameterMasterModel GetParameterList(int parameterservice, int parameterindicator)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
            try
            {
                var dbAccessDAL = new DBAccessDAL();
                var entity = new ParameterMasterModel();

                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pUserId", Convert.ToString(_UserSession.UserId));
                parameters.Add("@pServiceId", Convert.ToString(parameterservice));
                parameters.Add("@pIndicatorDetId", Convert.ToString(parameterindicator));
                parameters.Add("@pPageIndex", Convert.ToString(1));
                parameters.Add("@pPageSize", Convert.ToString(10));               

                DataTable dt1 = dbAccessDAL.GetDataTable("UspFM_MstDedSubParameter_GetById", parameters, DataSetparameters);
                if (dt1 != null && dt1.Rows.Count > 0)
                {
                    entity.IndicatorDesc = dt1.Rows[0]["IndicatorDesc"].ToString();
                    entity.IndicatorDetId= Convert.ToInt16(dt1.Rows[0]["IndicatorDetId"]);
                }
                if (entity.IndicatorDetId == 6)
                {
                    DataSet dt = dbAccessDAL.GetDataSet("UspFM_MstDedSubParameter_GetById", parameters, DataSetparameters);
                    if (dt != null && dt.Tables.Count > 0)
                    {
                        entity.ParameterListData = (from n in dt.Tables[0].AsEnumerable()
                                                    select new ItemParameterMasterList
                                                    {
                                                        SubParameterId = Convert.ToInt32(n["SubParameterId"]),
                                                        SubParameter = Convert.ToString(n["SubParameter"]),
                                                        SubParameterDetId = Convert.ToInt32(n["SubParameterDetId"])
                                                        //Timestamp = Convert.ToBase64String((byte[])(n["Timestamp"]))
                                                    }).ToList();

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

        public bool Delete(int Id)
        {
            throw new NotImplementedException();
        }

        public ParameterMasterModel Get(int Id)
        {
            throw new NotImplementedException();
        }

        public GridFilterResult GetAll(SortPaginateFilter pageFilter)
        {
            throw new NotImplementedException();
        }        

        public bool IsParameterMasterCodeDuplicate(ParameterMasterModel Parameter)
        {
            throw new NotImplementedException();
        }

        public bool IsRecordModified(ParameterMasterModel Parameter)
        {
            throw new NotImplementedException();
        }        

        public ParameterMasterModel Save(ParameterMasterModel Parameter)
        {
            throw new NotImplementedException();
        }
    }
}
