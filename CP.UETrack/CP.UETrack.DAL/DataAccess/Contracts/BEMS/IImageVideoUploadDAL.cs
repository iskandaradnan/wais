using CP.UETrack.Model.BEMS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CP.UETrack.DAL.DataAccess.Contracts.BEMS
{
    public interface IImageVideoUploadDAL
    {
        ImageVideoUploadModel Load();
        ImageVideoUploadModel Save(ImageVideoUploadModel ImageVideo);
        ImageVideoUploadModel GetUploadDetails(string Id);
        bool Delete(int Id);
    }
}
