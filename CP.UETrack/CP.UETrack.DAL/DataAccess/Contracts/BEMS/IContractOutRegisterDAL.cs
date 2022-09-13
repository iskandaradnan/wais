using CP.UETrack.Model;
using CP.UETrack.Model.BEMS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CP.UETrack.DAL.DataAccess.Contracts.BEMS
{
   public interface IContractOutRegisterDAL
    {
        CORDropdownList Load();
        GridFilterResult Getall(SortPaginateFilter pageFilter);
        ContractOutRegisterEntity Get(int id, int pagesize, int pageindex);
        void update(ref ContractOutRegisterEntity model, out string ErrorMessage);
        void save(ref ContractOutRegisterEntity model, out string ErrorMessage);
        bool Delete(int id);
        ContractOutRegisterEntity GetPopupDetails(int primaryId, int ContractHisId);
    }
}
