using CP.UETrack.Model.Portering;

namespace CP.UETrack.DAL.DataAccess.Contracts.Portering
{
    public interface IPorteringDAL
    {
        PorteringLovs Load();
        void Delete(int Id, out string ErrorMessage);
        PorteringModel Get(int Id);
        PorteringModel Save(PorteringModel model, out string ErrorMessage);
        PorteringModel GetPorteringHistory(int Id);
        PorteringLovs GetLocationList(PorteringLovs lov);
        PorteringLovs GetVendorInfo(int SupplierCategoryid, int AssetId);
        PorteringModel GetLoanerBookingRecord(int id);
       // bool ValidateBookingEndDate(PorteringModel model);
       
    }
}
