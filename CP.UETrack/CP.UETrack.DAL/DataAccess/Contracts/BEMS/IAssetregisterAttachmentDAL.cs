using CP.UETrack.Model;
using CP.UETrack.Model.BEMS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CP.UETrack.DAL.DataAccess.Contracts.BEMS
{
    public interface IAssetregisterAttachmentDAL
    {
        FileTypeDropdown Load();       
        AssetRegisterAttachment Save(AssetRegisterAttachment Document, out string ErrorMessage);
        AssetRegisterAttachment GetAttachmentDetails(string id);
        GridFilterResult GetAll(SortPaginateFilter pageFilter);
        AssetRegisterAttachment Get(int Id);
        bool Delete(int Id);       

    }
}
