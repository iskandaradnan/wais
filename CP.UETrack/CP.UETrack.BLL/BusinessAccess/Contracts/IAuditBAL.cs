namespace CP.UETrack.BAL.BusinessAccess
{
    public interface IAuditBAL
    {
        bool Save<T>(T viewModel);
    }
}


