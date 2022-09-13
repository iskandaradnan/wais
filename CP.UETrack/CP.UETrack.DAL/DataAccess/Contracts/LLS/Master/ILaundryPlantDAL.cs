using CP.UETrack.Model;
using CP.UETrack.Model.LLS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CP.UETrack.DAL.DataAccess.Contracts.LLS
{
    public interface ILaundryPlantDAL
    {
        LaundryPlantModelLovs Load();
        LaundryPlantModel Save(LaundryPlantModel model, out string ErrorMessage);
        GridFilterResult GetAll(SortPaginateFilter pageFilter);
        LaundryPlantModel Get(int Id);
        void Delete(int Id, out string ErrorMessage);

        bool IsLaundryPlantDuplicate(LaundryPlantModel userRole);
    }
}
