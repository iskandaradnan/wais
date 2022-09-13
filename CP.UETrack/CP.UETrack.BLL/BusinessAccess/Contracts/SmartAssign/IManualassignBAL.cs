using CP.UETrack.Model.UM;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CP.UETrack.BLL.BusinessAccess.Contracts.UM
{
   public interface IManualassignBAL
    {
       ManualassignLovs Load();
        ManualassignViewModel Get(int Id);
        ManualassignViewModel Save(ManualassignViewModel model, out string ErrorMessage);
    }
}
