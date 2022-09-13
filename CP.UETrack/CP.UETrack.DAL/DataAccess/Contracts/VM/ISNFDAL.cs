using CP.UETrack.Model;
using CP.UETrack.Model.VM;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CP.UETrack.DAL.DataAccess.Contracts.VM
{
    public interface ISNFDAL
    {

        LovEntity Load();
        SNFEntity Save(SNFEntity testingAndCommissioning, out string ErrorMessage);
        GridFilterResult GetAll(SortPaginateFilter pageFilter);
        SNFEntity Get(int Id);
        void Delete(int Id, out string ErrorMessage);
    }
}
