using CP.UETrack.Model.BEMS;
using System.Collections.Generic;

namespace CP.UETrack.DAL.DataAccess.Contracts.BEMS
{
    public interface ITypeCodeDetailsDAL
    {
       
        EngAssetTypeCodeLovs Load();
        void Delete(int Id, out string ErrorMessage);
        EngAssetTypeCode Get(int Id);
        EngAssetTypeCode Save(EngAssetTypeCode model, out string ErrorMessage);
        List<EngAssetTypeCodeAddSpecification> GetAssetTypeCodeAddSpecifications(int id);
    }
}
