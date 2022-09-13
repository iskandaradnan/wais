using CP.UETrack.Model.Portering;

namespace CP.UETrack.BLL.BusinessAccess.Contracts.Portering
{
    public interface IPorteringBAL
    {
        PorteringLovs Load();
        void Delete(int Id, out string ErrorMessage);
        PorteringModel Get(int Id);
        PorteringModel Save(PorteringModel model, out string ErrorMessage);
        //PorteringModel SaveMovement(PorteringModel model, out string ErrorMessage);
       // PorteringModel SaveReceipt(PorteringModel model, out string ErrorMessage);
        PorteringModel GetPorteringHistory(int Id);
        //PorteringModel GetReceipt(int Id);
        PorteringLovs GetLocationList(PorteringLovs lov);
        PorteringLovs GetVendorInfo(int SupplierCategoryid, int AssetId);
        PorteringModel GetLoanerBookingRecord(int id);


    }
}
