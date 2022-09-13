namespace CP.Framework.Common.ExceptionHandler.ExceptionWrappers
{
    public enum ExceptionTypes
    {
        NoType = 0,
        DalException = 1,
        BalException = 2,
        HTTPException = 3,
        ServiceException = 4,
        GeneralException = 5,
        TransactionException = 6,
        ConcurrencyException = 7
    }
}
