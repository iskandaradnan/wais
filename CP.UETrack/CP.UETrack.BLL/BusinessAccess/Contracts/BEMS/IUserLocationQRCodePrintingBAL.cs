using CP.UETrack.Model;
using CP.UETrack.Model.BEMS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CP.UETrack.BLL.BusinessAccess.Contracts.BEMS
{
    public interface IUserLocationQRCodePrintingBAL
    {
        UserLocationQRCodePrintingModel Load();
        UserLocationQRCodePrintingModel Get(UserLocationQRCodePrintingModel LocationQR);
        UserLocationQRCodePrintingModel GetModal(UserLocationQRCodePrintingModel LocationQR);
        UserLocationQRCodePrintingModel Save(UserLocationQRCodePrintingModel LocationQR);
        GridFilterResult GetAll(SortPaginateFilter pageFilter);
    }
}
