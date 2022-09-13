using CP.UETrack.Model;
using CP.UETrack.Model.BEMS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CP.UETrack.BLL.BusinessAccess.Contracts.BEMS
{
    public  interface IDepartmentQRCodePrintingBAL
    {
        DepartmentQRCodePrintingModel Load();
        DepartmentQRCodePrintingModel Get(DepartmentQRCodePrintingModel DepartmentQR);
        DepartmentQRCodePrintingModel GetModal(DepartmentQRCodePrintingModel DepartmentQR);
        DepartmentQRCodePrintingModel Save(DepartmentQRCodePrintingModel DepartmentQR);
        GridFilterResult GetAll(SortPaginateFilter pageFilter);
    }
}
