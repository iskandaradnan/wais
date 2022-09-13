using CP.UETrack.Model;
using CP.UETrack.Model.BEMS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CP.UETrack.DAL.DataAccess.Contracts.BEMS
{
    public interface IDepartmentQRCodePrintingDAL
    {
        DepartmentQRCodePrintingModel Load();
        DepartmentQRCodePrintingModel Get(DepartmentQRCodePrintingModel DepartmentQR);
        DepartmentQRCodePrintingModel GetModal(DepartmentQRCodePrintingModel DepartmentQR);
        DepartmentQRCodePrintingModel Save(DepartmentQRCodePrintingModel DepartmentQR);
        GridFilterResult GetAll(SortPaginateFilter pageFilter);
        bool IsRecordModified(DepartmentQRCodePrintingModel DepartmentQR);
        bool IsDepartmentQRCodePrintingModelCodeDuplicate(DepartmentQRCodePrintingModel DepartmentQR);
    }
}
