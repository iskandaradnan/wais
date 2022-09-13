using CP.UETrack.Model.BEMS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CP.UETrack.BLL.BusinessAccess.Contracts.BEMS
{
    public interface IAssetRegisterLicenseCertificateTabBAL
    {
        List<AssetRegisterLnCTab> Get(int Id);
    }
}
