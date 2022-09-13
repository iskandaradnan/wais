using CP.UETrack.Model.UM;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CP.UETrack.DAL.DataAccess.Contracts.UM
{
 public interface IManualassignDAL
    {
        ManualassignLovs Load();   
        ManualassignViewModel Get(int Id);
        ManualassignViewModel Save(ManualassignViewModel model);
        
    }
}
