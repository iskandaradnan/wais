using CP.Framework.Common.ExceptionHandler.ExceptionWrappers;
using CP.Framework.Common.Logging;
using CP.UETrack.DAL.DataAccess.Contracts.BER;
using CP.UETrack.Model;
using CP.UETrack.Model.BER;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using UETrack.DAL;

namespace CP.UETrack.DAL.DataAccess.Implementations.BER
{
    public class BERDashboardDAL : IBERDashboardDAL
    {
        private readonly string _FileName = nameof(BERDashboardDAL);
        readonly UserDetailsModel _UserSession = new SessionHelper().UserSession();

        public BERDashboardDAL()
        {

        }

        public BERDashboard Load()
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
            try
            {
                var dbAccessDAL = new DBAccessDAL();
                BERDashboard entity = new BERDashboard();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pFacilityId", Convert.ToString(_UserSession.FacilityId));

                DataSet dt = dbAccessDAL.GetDataSet("uspFM_BER_DashBoard", parameters, DataSetparameters);
                if (dt != null && dt.Tables[0].Rows.Count != 0)
                {
                    entity.FacilityManager = Convert.ToString(dt.Tables[0].Rows[0]["Facility Manager"]);
                    entity.FacilityManagerSts = Convert.ToString(dt.Tables[0].Rows[0]["BERStatus"]);
                    entity.FacMAnCount = Convert.ToInt32(dt.Tables[0].Rows[0]["Count"]);
                    //entity.BERDAshboardPendingData = (from n in dt.Tables[0].AsEnumerable()
                    //                               select new BERDAshboardPending
                    //                               {
                    //                                   BerStatus = Convert.ToString(n["BERStatusName"]),
                    //                                   Count = Convert.ToInt16(n["TotCount"])
                    //                               }).ToList();
                }

                if (dt != null && dt.Tables[1].Rows.Count != 0)
                {
                    entity.HospDir = Convert.ToString(dt.Tables[1].Rows[0]["Hospital Director"]);
                    entity.HospDirSts = Convert.ToString(dt.Tables[1].Rows[0]["BERStatus"]);
                    entity.HosDirCount = Convert.ToInt32(dt.Tables[1].Rows[0]["Count"]);
                }

                if (dt != null && dt.Tables[2].Rows.Count != 0)
                {
                    entity.LiasonOff = Convert.ToString(dt.Tables[2].Rows[0]["Liaison Officer"]);
                    entity.LiasonOffSts = Convert.ToString(dt.Tables[2].Rows[0]["BERStatus"]);
                    entity.LiaOffCount = Convert.ToInt32(dt.Tables[2].Rows[0]["Count"]);
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

        public BERDashboard LoadGrid(int pagesize, int pageindex)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
            try
            {
                var dbAccessDAL = new DBAccessDAL();
                BERDashboard entity = new BERDashboard();
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pFacilityId", Convert.ToString(_UserSession.FacilityId));
                parameters.Add("@pPageIndex", pageindex.ToString());
                parameters.Add("@pPageSize", pagesize.ToString());

                DataSet dt = dbAccessDAL.GetDataSet("uspFM_BERRenewal_DashBoard", parameters, DataSetparameters);
                if (dt != null && dt.Tables[0].Rows.Count > 0)
                {
                    entity.BERDashboardGridData = (from n in dt.Tables[0].AsEnumerable()
                                                      select new BERDashboardGrid
                                                      {
                                                          BerNo = Convert.ToString(n["BERno"]),
                                                          BerStatus = Convert.ToString(n["BERStatusName"]),
                                                          RenewalDate = Convert.ToDateTime(n["RenewalDate"]),
                                                          TotalRecords = Convert.ToInt32(n["TotalRecords"]),
                                                          TotalPages = Convert.ToInt32(n["TotalPageCalc"]),
                                                      }).ToList();

                    entity.BERDashboardGridData.ForEach((x) =>
                    {                       
                        x.PageIndex = pageindex;
                        x.FirstRecord = ((pageindex - 1) * pagesize) + 1;
                        x.LastRecord = ((pageindex - 1) * pagesize) + pagesize;

                        //x.CategorySystemId = Id;
                    });
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
