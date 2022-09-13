using CP.UETrack.Model;
using CP.UETrack.Model.BEMS.CRMWorkOrder;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CP.UETrack.DAL.DataAccess.Contracts.BEMS
{
    public interface ICRMWorkorderDAL
    {
        CRMWorkorderDropdownValues Load();
        CRMWorkorder Save(CRMWorkorder crmwork, out string ErrorMessage);
        GridFilterResult GetAll(SortPaginateFilter pageFilter);
        CRMWorkorder Get(int Id);
        bool Delete(int Id);
        CRMWorkorderAssessment SaveAssessment(CRMWorkorderAssessment crmworkAss, out string ErrorMessage);
        CRMWorkorderAssessment GetAssessment(int Id);
        CRMWorkorderCompInfo SaveCompInfo(CRMWorkorderCompInfo crmworkComp, out string ErrorMessage);
        CRMWorkorderCompInfo GetCompInfo(int Id);
        CRMWorkorderProcessStatus GetProcessStatus(int Id);
    }
}
