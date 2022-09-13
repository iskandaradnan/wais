using CP.UETrack.Model.BEMS;

namespace CP.UETrack.BLL.BusinessAccess.Contracts.BEMS
{
    public interface ISparepartRegisterBAL
    {
        EngSparePartsLovs Load();
        void Delete(int Id, out string ErrorMessage);
        EngSpareParts Get(int Id);
        EngSpareParts Save(EngSpareParts model, out string ErrorMessage);
        ImageVideoUploadModel SPImageVideoSave(ImageVideoUploadModel ImageVideo);
        ImageVideoUploadModel SPGetUploadDetails(string Id);
        bool SPFileDelete(int Id);
    }
}
