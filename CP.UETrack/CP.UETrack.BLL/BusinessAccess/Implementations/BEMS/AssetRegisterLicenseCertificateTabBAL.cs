using CP.Framework.Common.ExceptionHandler.ExceptionWrappers;
using CP.Framework.Common.Logging;
using CP.UETrack.BLL.BusinessAccess.Contracts.BEMS;
using CP.UETrack.DAL.DataAccess;
using CP.UETrack.DAL.DataAccess.Contracts.BEMS;
using CP.UETrack.Model.BEMS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CP.UETrack.BLL.BusinessAccess.Implementations.BEMS
{
    public class AssetRegisterLicenseCertificateTabBAL : IAssetRegisterLicenseCertificateTabBAL
    {
        private string _FileName = nameof(BEMS.AssetRegisterLicenseCertificateTabBAL);
        IAssetRegisterLicenseCertTabDAL _IAssetRegisterLicenseCertTabDAL;
        public AssetRegisterLicenseCertificateTabBAL(IAssetRegisterLicenseCertTabDAL AssetRegisterLicenseCertTabDAL)
        {
            _IAssetRegisterLicenseCertTabDAL = AssetRegisterLicenseCertTabDAL;
        }
        public List<AssetRegisterLnCTab> Get(int Id)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
                var result = _IAssetRegisterLicenseCertTabDAL.Get(Id);
                Log4NetLogger.LogExit(_FileName, nameof(Get), Level.Info.ToString());
                return result;
            }
            catch (BALException balException)
            {
                throw new BALException(balException);
            }
            catch (Exception)
            {
                throw;
            }
        }
        
    }
}
