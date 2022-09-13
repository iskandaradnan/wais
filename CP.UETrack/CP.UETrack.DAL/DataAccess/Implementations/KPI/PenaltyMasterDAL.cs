using CP.UETrack.DAL.DataAccess.Contracts.KPI;
using CP.UETrack.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using CP.UETrack.Model.KPI;
using CP.Framework.Common.Logging;
using System.Data;
using UETrack.DAL;
using System.Data.SqlClient;
using CP.Framework.Common.ExceptionHandler.ExceptionWrappers;

namespace CP.UETrack.DAL.DataAccess.Implementations.KPI
{
    public class PenaltyMasterDAL : IPenaltyMasterDAL
    {
        private readonly string _FileName = nameof(PenaltyMasterDAL);
        readonly UserDetailsModel _UserSession = new SessionHelper().UserSession();


        public PenaltyTypeDropdown Load()
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
                PenaltyTypeDropdown PenaltyTypeDropdown = null;

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
                            PenaltyTypeDropdown = new PenaltyTypeDropdown();
                            PenaltyTypeDropdown.PenaltyServiceTypeData = dbAccessDAL.GetLovRecords(ds.Tables[0]);
                        }

                        ds.Clear();
                        cmd.CommandText = "uspFM_Dropdown_Others";
                        cmd.Parameters.Clear();
                        cmd.Parameters.AddWithValue("@pTablename", "MstDedPenalty");
                        da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);

                        if (ds.Tables.Count != 0)
                        {
                            PenaltyTypeDropdown.PenaltyCriteriaTypeData = dbAccessDAL.GetLovRecords(ds.Tables[0]);
                        }

                        ds.Clear();
                        cmd.CommandText = "uspFM_Dropdown";
                        cmd.Parameters.Clear();
                        cmd.Parameters.AddWithValue("@pLovKey", "StatusValue");
                        da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);

                        if (ds.Tables.Count != 0)
                        {
                            PenaltyTypeDropdown.PenaltyStatusTypeData = dbAccessDAL.GetLovRecords(ds.Tables[0]);
                        }

                    }
                }

                Log4NetLogger.LogExit(_FileName, nameof(Load), Level.Info.ToString());
                return PenaltyTypeDropdown;
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


        public PenaltyMasterModel Save(PenaltyMasterModel Penalty)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());  
               
                var dbAccessDAL = new DBAccessDAL();
                var parameters = new Dictionary<string, string>();

                parameters.Add("@pUserId", Convert.ToString(_UserSession.UserId));
                parameters.Add("@pPenaltyId", Convert.ToString(Penalty.PenaltyId));
                parameters.Add("@PenaltyDescription", Convert.ToString(Penalty.PenaltyDescription));            
                
                var DataSetparameters = new Dictionary<string, DataTable>();
                DataTable dt = new DataTable();
                dt.Columns.Add("PenaltyDetId", typeof(int));
                dt.Columns.Add("ServiceId", typeof(int));
                dt.Columns.Add("PenaltyId", typeof(int));
                dt.Columns.Add("CriteriaId", typeof(int));
                dt.Columns.Add("Status", typeof(int));
                
                //dt.Columns.Add("UserId", typeof(int));

                foreach (var i in Penalty.PenaltyListData)
                {
                    dt.Rows.Add(i.PenaltyDetId, i.ServiceId, i.PenaltyId, i.CriteriaId, i.Status);

                    //dt.Rows.Add(i.PenaltyDetId,2, i.PenaltyId, 3, 1);

                }

                DataSetparameters.Add("@MstDedPenaltyDet", dt);
                DataTable dt1 = dbAccessDAL.GetDataTable("uspFM_MstDedPenalty_Save", parameters, DataSetparameters);
                if (dt1 != null)
                {
                    foreach (DataRow row in dt1.Rows)
                    {
                        foreach (var val in Penalty.PenaltyListData)

                        {
                            val.PenaltyId = Convert.ToInt32(row["PenaltyId"]);
                            Penalty.PenaltyId = Convert.ToInt32(row["PenaltyId"]);
                            Penalty.Timestamp = Convert.ToBase64String((byte[])(row["Timestamp"]));
                        }
                    }
                }

                Log4NetLogger.LogExit(_FileName, nameof(Save), Level.Info.ToString());
                return Penalty;
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
        


        public PenaltyMasterModel GetPenaltyList(int penaltyservice, int penaltycriteria)
        {

            Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
            try
            {
                var dbAccessDAL = new DBAccessDAL();               
                var entity = new PenaltyMasterModel();

                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pUserId", Convert.ToString(_UserSession.UserId));
                parameters.Add("@pServiceId", Convert.ToString(penaltyservice));
                parameters.Add("@pCriteriaId", Convert.ToString(penaltycriteria));
                parameters.Add("@pPageIndex", Convert.ToString(1));
                parameters.Add("@pPageSize", Convert.ToString(10));

                DataSet dt = dbAccessDAL.GetDataSet("UspFM_MstDedPenalty_GetById", parameters, DataSetparameters);
                if (dt != null && dt.Tables.Count > 0)
                {
                    entity.PenaltyListData = (from n in dt.Tables[0].AsEnumerable()
                                                     select new ItemPenaltyMasterList
                                                     {
                                                         PenaltyId = Convert.ToInt32(n["PenaltyId"]),                    
                                                         PenaltyDescription = Convert.ToString(n["PenaltyDescription"]),
                                                         Status = Convert.ToInt32(n["Status"]),
                                                         PenaltyDetId = Convert.ToInt32(n["PenaltyDetId"])
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
            catch (Exception)
            {
                throw;
            }

        }



        public PenaltyMasterModel Get(int Id)
        {
            throw new NotImplementedException();

        }
        public GridFilterResult GetAll(SortPaginateFilter pageFilter)
        {
            throw new NotImplementedException();
        }

        public bool Delete(int Id)
        {
            throw new NotImplementedException();
        }
        public bool IsRecordModified(PenaltyMasterModel Penalty)
        {
            throw new NotImplementedException();
        }

        public bool IsPenaltyMasterCodeDuplicate(PenaltyMasterModel Penalty)
        {
            throw new NotImplementedException();
        }

        
    }
}
