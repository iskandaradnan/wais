using CP.UETrack.Model.BEMS;
using System.Collections.Generic;

namespace CP.UETrack.BLL.BusinessAccess.Contracts.BEMS
{
    public interface ITypeCodeDetailsBAL
    {
        EngAssetTypeCodeLovs Load();
        void Delete(int Id, out string ErrorMessage);
        EngAssetTypeCode Get(int Id);
        EngAssetTypeCode Save(EngAssetTypeCode model, out string ErrorMessage);
        List<EngAssetTypeCodeAddSpecification> GetAssetTypeCodeAddSpecifications(int Id);
    }
}
