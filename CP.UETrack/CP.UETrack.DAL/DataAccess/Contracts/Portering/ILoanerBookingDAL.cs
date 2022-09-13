using CP.UETrack.Model.Portering;

namespace CP.UETrack.DAL.DataAccess.Contracts.Portering
{
    public  interface ILoanerBookingDAL
    {
        PorteringLovs Load();
        void Delete(int Id, out string ErrorMessage);
        LoanerBooking Get(int Id);
        LoanerBooking GetBookingDates(int Id);
        LoanerBooking Save(LoanerBooking model, out string ErrorMessage);
    }
}

