using CP.UETrack.Model.BEMS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CP.UETrack.BLL.BusinessAccess.Contracts.BEMS
{
    public interface IAssetRegisterAttachmentBAL
    {    
        FileTypeDropdown Load();        
        AssetRegisterAttachment Save(AssetRegisterAttachment Document, out string ErrorMessage);
        AssetRegisterAttachment GetAttachmentDetails(string id);
        AssetRegisterAttachment Get(int Id);
        bool Delete(int Id);
                
    }
}
