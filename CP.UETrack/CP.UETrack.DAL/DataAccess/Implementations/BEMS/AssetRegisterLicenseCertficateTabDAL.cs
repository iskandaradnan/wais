using CP.UETrack.DAL.DataAccess.Contracts.BEMS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using CP.UETrack.Model.BEMS;
using CP.Framework.Common.Logging;
using CP.UETrack.Model;
using System.Data;
using UETrack.DAL;
using System.Data.SqlClient;
using CP.Framework.Common.ExceptionHandler.ExceptionWrappers;

namespace CP.UETrack.DAL.DataAccess.Implementations.BEMS
{
    public class AssetRegisterLicenseCertficateTabDAL : IAssetRegisterLicenseCertTabDAL
    {
        private readonly string _FileName = nameof(AssetRegisterLicenseCertficateTabDAL);
        readonly UserDetailsModel _UserSession = new SessionHelper().UserSession();
        public List<AssetRegisterLnCTab> Get(int Id)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
                var LicenseCert = new List<AssetRegisterLnCTab>();

                var ds = new DataSet();
                var dbAccessDAL = new DBAccessDAL();
                using (SqlConnection con = new SqlConnection(dbAccessDAL.ConnectionString))
                {
                    using (SqlCommand cmd = new SqlCommand())
                    {
                        cmd.Connection = con;
                        cmd.CommandType = CommandType.StoredProcedure;
                        cmd.CommandText = "UspBEMS_EngAssetRegisterLicenseCertificate_Get";
                        cmd.Parameters.AddWithValue("Id", Id);
                        var da = new SqlDataAdapter();
                        da.SelectCommand = cmd;
                        da.Fill(ds);
                    }
                }
                if (ds.Tables.Count != 0)
                {
                    LicenseCert = (from n in ds.Tables[0].AsEnumerable()
                                   select new AssetRegisterLnCTab
                                   {
                                       LicenseId = Convert.ToInt32(n["LicenseId"]),
                                       FacilityName = Convert.ToString(n["FacilityName"]),
                                       LicenseNo = Convert.ToString(n["LicenseNo"]),
                                       NotificationForInspection = n.Field<DateTime?>("NotificationForInspection"),
                                       InspectionConductedOn = n.Field<DateTime?>("InspectionConductedOn"),
                                       NextInspectionDate = n.Field<DateTime?>("NextInspectionDate"),
                                       ExpireDate = Convert.ToDateTime(n["ExpireDate"]),
                                       IssuingBody = Convert.ToInt32(n["IssuingBody"]),
                                       IssuingBodyName = Convert.ToString(n["IssuingBodyName"]),
                                       IssuingDate = Convert.ToDateTime(n["IssuingDate"]),
                                       Remarks = Convert.ToString(n["Remarks"])
                                   }).ToList();
                }

                Log4NetLogger.LogExit(_FileName, nameof(Get), Level.Info.ToString());
                return LicenseCert;
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
