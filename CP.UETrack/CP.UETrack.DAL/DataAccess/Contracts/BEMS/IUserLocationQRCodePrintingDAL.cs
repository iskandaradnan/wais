using CP.UETrack.Model;
using CP.UETrack.Model.BEMS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CP.UETrack.DAL.DataAccess.Contracts.BEMS
{
    public interface IUserLocationQRCodePrintingDAL
    {
        UserLocationQRCodePrintingModel Load();
        UserLocationQRCodePrintingModel Get(UserLocationQRCodePrintingModel LocationQR);
        UserLocationQRCodePrintingModel Save(UserLocationQRCodePrintingModel LocationQR);
        UserLocationQRCodePrintingModel GetModal(UserLocationQRCodePrintingModel LocationQR);
        GridFilterResult GetAll(SortPaginateFilter pageFilter);
        bool IsRecordModified(UserLocationQRCodePrintingModel LocationQR);
        bool IsUserLocationQRCodePrintingCodeDuplicate(UserLocationQRCodePrintingModel LocationQR);
    }
}
