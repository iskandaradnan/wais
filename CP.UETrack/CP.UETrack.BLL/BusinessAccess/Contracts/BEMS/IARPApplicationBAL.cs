using CP.UETrack.Model;
using CP.UETrack.Model.BEMS;
using CP.UETrack.Model.BEMS.AssetRegister;

namespace CP.UETrack.BLL.BusinessAccess.Interface
{
    public interface IARPApplicationBAL
    {
        ARPApplicationTxnLovs Load();
        void Delete(int Id, out string ErrorMessage);
        Arp Get(int Id);
        //GridFilterResult GetAll(SortPaginateFilter pageFilter);
        Arp Save(Arp model, out string ErrorMessage);
        Arp ProposalSave(Arp model, out string ErrorMessage);
        Arp Submit(Arp model, out string ErrorMessage);
        Arp ArpGet(int Id);
        Arp GetAttachmentDetails(int id);
        AssetRegisterModel GetBERNoDetails(string Id);
        GridFilterResult GetAll(SortPaginateFilter pageFilter);

    }

}


