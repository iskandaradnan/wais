using CP.UETrack.Model;
using CP.UETrack.Model.BEMS;
using CP.UETrack.Model.BEMS.AssetRegister;

namespace CP.UETrack.DAL.DataAccess.Contracts.BEMS
{
    public interface IARPApplicationDAL
    {
        void Delete(int id, out string errorMessage);
        Arp Get(int Id);
        Arp ArpGet(int Id);
        ARPApplicationTxnLovs Load();
        Arp Save(Arp model, out string errorMessage);
        Arp ProposalSave(Arp model, out string errorMessage);
        Arp Submit(Arp model, out string errorMessage);
        //GridFilterResult GetAll(SortPaginateFilter pageFilter);
        Arp GetAttachmentDetails(int id);
        AssetRegisterModel GetBERNoDetails(string Id);

        GridFilterResult GetAll(SortPaginateFilter pageFilter);

    }
}
