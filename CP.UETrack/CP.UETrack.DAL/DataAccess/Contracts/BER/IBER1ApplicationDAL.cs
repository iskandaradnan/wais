using CP.UETrack.Model;
using CP.UETrack.Model.BER;

namespace CP.UETrack.DAL.DataAccess.Contracts.BER
{
    public interface IBER1ApplicationDAL
    {
        void Delete(int id, out string errorMessage);
        BERApplicationTxn Get(int id);
        BERApplicationTxn Get(string Id);
        BERApplicationTxn ArpGet(int Id);
        BERApplicationTxnLovs Load();
        BERApplicationTxn Save(BERApplicationTxn model, out string errorMessage);
        BERApplicationTxn GetAttachmentDetails(int id);
      //  BERApplicationTxn AddAttachment(BERApplicationTxn model, out string errorMessage);
        BERApplicationTxn GetApplicationHistiry(int id);
        BERApplicationTxn GetBerCurrentValueHistory(int id);
        BERApplicationTxn GetMaintainanceHistory(int id);
        BERApplicationTxn SaveDocument(BERApplicationTxn document, out string errorMessage);
        BerAdditionalFields GetAdditionalInfoForBer(int ApplicationId);
        BerAdditionalFields SaveAdditionalInfoForBer(BerAdditionalFields AdditionalInfo, out string ErrorMessage);
    }
}
