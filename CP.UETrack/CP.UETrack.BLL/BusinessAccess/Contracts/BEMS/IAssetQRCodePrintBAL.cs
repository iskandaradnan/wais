using CP.UETrack.Model;
using CP.UETrack.Model.BEMS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CP.UETrack.BLL.BusinessAccess.Contracts.BEMS
{
    public interface IAssetQRCodePrintBAL
    {
        AssetQRCodePrintModel Load();    
        AssetQRCodePrintModel Get(AssetQRCodePrintModel AssetQR);
        AssetQRCodePrintModel GetModal(AssetQRCodePrintModel AssetQR);
        bool Delete(int Id);
        AssetQRCodePrintModel Save(AssetQRCodePrintModel AssetQR);
        GridFilterResult GetAll(SortPaginateFilter pageFilter);
    }
}
