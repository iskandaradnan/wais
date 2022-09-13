using CP.UETrack.Model;
using CP.UETrack.Model.LLS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CP.UETrack.DAL.DataAccess.Contracts.LLS
{
   public interface IWeighingScaleDAL
    {
        WeighingScaleEquipmentModelLovs Load();
        WeighingScaleEquipmentModel Save(WeighingScaleEquipmentModel model, out string ErrorMessage);
        GridFilterResult GetAll(SortPaginateFilter pageFilter);
        WeighingScaleEquipmentModel Get(int Id);
        bool IsWeighingCodeDuplicate(WeighingScaleEquipmentModel userRole);
        void Delete(int Id, out string ErrorMessage);
    }
}
