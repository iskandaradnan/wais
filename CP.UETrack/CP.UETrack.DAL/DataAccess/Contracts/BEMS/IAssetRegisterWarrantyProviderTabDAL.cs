using CP.UETrack.Model;
using CP.UETrack.Model.BEMS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CP.UETrack.DAL.DataAccess.Contracts.BEMS
{
    public interface IAssetRegisterWarrantyProviderTabDAL
    {
        WarrantyProviderCategoryLov Load();
        AssetRegisterWarrantyProvider Save(AssetRegisterWarrantyProvider WarrantyProvider);
        //GridFilterResult GetAll(SortPaginateFilter pageFilter);
        AssetRegisterWarrantyProvider Get(int Id);
        bool IsRoleDuplicate(AssetRegisterWarrantyProvider WarrantyProvider);
        bool IsRecordModified(AssetRegisterWarrantyProvider WarrantyProvider);
        void Delete(string Id);

    }
}
