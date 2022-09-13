using CP.UETrack.Model;
using CP.UETrack.Model.BER;

namespace CP.UETrack.BLL.BusinessAccess.Contracts.BER
{
    public interface IBER1ApplicationBAL
    {
        BERApplicationTxnLovs Load();
        void Delete(int Id, out string ErrorMessage);
        BERApplicationTxn Get(int Id);

        BERApplicationTxn Get(string Id);

        BERApplicationTxn ArpGet(int Id);
        BERApplicationTxn Save(BERApplicationTxn model, out string ErrorMessage);
        BERApplicationTxn GetAttachmentDetails(int id);
     //   BERApplicationTxn AddAttachment(BERApplicationTxn model, out string errorMessage);
        BERApplicationTxn GetApplicationHistiry(int id);
        BERApplicationTxn GetMaintainanceHistory(int id);
        BERApplicationTxn GetBerCurrentValueHistory(int id);
        BERApplicationTxn SaveDocument(BERApplicationTxn document, out string errorMessage);


        BerAdditionalFields GetAdditionalInfoForBer(int ApplicationId);
        BerAdditionalFields SaveAdditionalInfoForBer(BerAdditionalFields AdditionalInfo, out string ErrorMessage);


       
    }

}


