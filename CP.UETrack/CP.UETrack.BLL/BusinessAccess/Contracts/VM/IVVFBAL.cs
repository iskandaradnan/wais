using CP.UETrack.Model.VM;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CP.UETrack.BLL.BusinessAccess.Contracts.VM
{
   public interface IVVFBAL
    {
        VVFDetails Get(VVFDetails entity);
        LoadEntity Load();
        VVFEntity Update(VVFEntity model);
    }
}
