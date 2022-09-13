using CP.UETrack.Model;
using CP.UETrack.Model.BEMS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CP.UETrack.BLL.BusinessAccess.Contracts.BEMS
{
   public interface ICRMRequestBAL
    {

        GridFilterResult Getall(int id, SortPaginateFilter pageFilter);
        GridFilterResult Getall(SortPaginateFilter pageFilter);
        GridFilterResult GetallService(int id,SortPaginateFilter pageFilter);
        bool Cancel(int id,string Remarks);
        CRMRequestEntity Get(int id, int pagesize, int pageindex);
        CRMRequestEntity get_Indicator_by_Serviceid( int id);

        CORMDropdownList get_TypeofRequset_by_Serviceid(int id);
        void update(ref CRMRequestEntity model);
        void save(ref CRMRequestEntity model);
        CORMDropdownList Load();
        CRMRequestEntity ConvertWO(CRMRequestEntity work);
        CRMRequestEntity ApplyingProcess(CRMRequestEntity work);
        CRMRequestEntity GetObsAsset(CRMRequestEntity work);

        CRMRequestEntity GetObsAssetM(int ManId, int ModId, int pagesize, int pageindex);
        //GridFilterResult BemsCRMGetall(int id, SortPaginateFilter pageFilter, int TypeOfRequest, int ServiceId);
    }
}
