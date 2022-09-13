using CP.UETrack.DAL.DataAccess.Contracts.Common;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using CP.UETrack.Model.BER;
using CP.UETrack.Model;
using CP.Framework.Common.Logging;
using UETrack.DAL;
using System.Data;
using CP.Framework.Common.ExceptionHandler.ExceptionWrappers;

namespace CP.UETrack.DAL.DataAccess.Implementations.Common
{
    public class ReportLoadLovDAL : IReportLoadLovDAL
    {
        private readonly string _FileName = nameof(ReportLoadLovDAL);
        readonly UserDetailsModel _UserSession = new SessionHelper().UserSession();
        
        public ReportLoadLovModel Load(string screenName)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
                ReportLoadLovModel Lovs = new ReportLoadLovModel();
                var dbAccessDAL = new DBAccessDAL();
                string lovs = string.Empty; 
                if (screenName == "Asset Registration")
                {
                    lovs = "TCTypeValue,StatusValue";

                }
                var DataSetparameters = new Dictionary<string, DataTable>();
                var parameters = new Dictionary<string, string>();
                parameters.Add("@pLovKey", lovs);

                DataSet ds = dbAccessDAL.GetDataSet("uspFM_Dropdown", parameters, DataSetparameters);
                if (ds.Tables.Count != 0 && ds.Tables[0].Rows.Count > 0)
                {
                    Lovs.List1 = dbAccessDAL.GetLovRecords(ds.Tables[0], "TCTypeValue");
                    Lovs.List2 = dbAccessDAL.GetLovRecords(ds.Tables[0], "StatusValue");
                    
                }
               

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

    }
}
