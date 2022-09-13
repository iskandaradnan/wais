using CP.UETrack.Model.Portering;

namespace CP.UETrack.BLL.BusinessAccess.Contracts.Portering
{
    public interface ILoanerBookingBAL
    {
        PorteringLovs Load();
        void Delete(int Id, out string ErrorMessage);
        LoanerBooking Get(int Id);
        LoanerBooking GetBookingDates(int Id);
        LoanerBooking Save(LoanerBooking model, out string ErrorMessage);
    }
}
