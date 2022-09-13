using CP.Framework.Common.ExceptionHandler.ExceptionWrappers;
using CP.Framework.Common.Logging;
using CP.UETrack.DAL.DataAccess.Contracts.BEMS;
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
   public class AssertregisterAssetProcessingStatusDAL : IAssertregisterAssetProcessingStatusDAL
    {

        private readonly string _FileName = nameof(AssertregisterAssetProcessingStatusDAL);
        readonly UserDetailsModel _UserSession = new SessionHelper().UserSession();

        //public AssetClassificationDAL()
        //{

        //}
        public List<AssetProcessingStatus> AssetProcessingStatus(AssetProcessingStatus entity)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(AssetProcessingStatus), Level.Info.ToString());
                var obl = new List<AssetProcessingStatus>();


                //
                var dbAccessDAL = new DBAccessDAL();


                using (var con = new SqlConnection(dbAccessDAL.ConnectionString))
                {

                    var cmd = new SqlCommand();
                    using (SqlDataAdapter da = new SqlDataAdapter())
                    {
                        using (DataTable dt = new DataTable())
                        {
                            using (cmd = new SqlCommand("UspFM_EngAssetProcessStatus_GetByAssetId", con))
                            {
                                cmd.Parameters.Add(new SqlParameter("@pAssetId", entity.AssetId));
                                //cmd.Parameters.Add(new SqlParameter("@pFacilityId", _UserSession.fac));
                                cmd.Parameters.Add(new SqlParameter("@pPageIndex", null));
                                cmd.Parameters.Add(new SqlParameter("@pPageSize", null));
                                // cmd.Parameters.Add(new SqlParameter("@pageIndex", pageIndex));
                                cmd.CommandType = CommandType.StoredProcedure;
                                da.SelectCommand = cmd;
                                da.Fill(dt);

                                var myEnumerable = dt.AsEnumerable();
                                obl =
                                    (from item in myEnumerable
                                     select new AssetProcessingStatus
                                     {

                                         DocumentNo = item.Field<string>("BERDocumentNo"),
                                         ProcessName = item.Field<string>("ProcessName"),
                                         DoneDate = item.Field<Nullable<DateTime>>("DateDone"),
                                         ProcessStatus = item.Field<string>("ProcessStatusLovName"),
                                         }).ToList();

                            }
                        }
                    }
                    cmd.Dispose();
                    // return returnVal;
                }

                //for (var i = 0; i < 10; i++)
                //{
                //    obl.Add(new AssetProcessingStatus
                //    {
                //        DocumentNo = "DCo/No/1" + i,
                //        ProcessName = "BEMS",
                //        DoneDate=DateTime.Now.ToString(),
                //        ProcessStatus="Active"


                //    });
                //}

                Log4NetLogger.LogExit(_FileName, nameof(AssetProcessingStatus), Level.Info.ToString());
                return obl;
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
    }
}
