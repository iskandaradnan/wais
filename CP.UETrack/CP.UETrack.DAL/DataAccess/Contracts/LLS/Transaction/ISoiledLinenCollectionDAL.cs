using System;
using CP.UETrack.Model;
using CP.UETrack.Model.LLS;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;


namespace CP.UETrack.DAL.DataAccess.Contracts.LLS.Transaction
{
    public interface ISoiledLinenCollectionDAL
    {
        SoiledLinenCollectionModelLovs Load();
        soildLinencollectionsModel Save(soildLinencollectionsModel model, out string ErrorMessage);
        GridFilterResult GetAll(SortPaginateFilter pageFilter);
        soildLinencollectionsModel Get(int Id);

        //soildLinencollectionsModel GetBy(soildLinencollectionsModel model);
        //soildLinencollectionsModel GetBySchedule(soildLinencollectionsModel model, out string ErrorMessage);
        bool IsSoiledLinenCollectionCodeDuplicate(soildLinencollectionsModel model);
        bool IsRecordModified(soildLinencollectionsModel model);


        void Delete(int Id, out string ErrorMessage);
    }
}