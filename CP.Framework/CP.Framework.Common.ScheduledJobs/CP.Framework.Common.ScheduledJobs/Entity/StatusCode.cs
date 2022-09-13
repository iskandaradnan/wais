namespace CP.Framework.Common.ScheduledJobs
{
    public enum StatusCode
    {
        Success = 0,
        FailedUnknownReason = 1,
        InsufficientPermission = 2,
        JobDisabled = 3,
        JobClassUnknown = 4,
        MetaDataInvalid = 5,
        DbException = 6
    }

}
