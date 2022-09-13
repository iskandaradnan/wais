using CP.Framework.Common.ExceptionHandler.ExceptionWrappers;
using CP.Framework.Common.Logging;
using CP.UETrack.BLL.BusinessAccess.Contracts.VM;
using CP.UETrack.DAL.DataAccess.Contracts.VM;
using CP.UETrack.Model;
using CP.UETrack.Model.VM;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CP.UETrack.BLL.BusinessAccess.Implementations.VM
{
   public class VMMonthClosingBAL: IVMMonthClosingBAL
    {
        private readonly IVMMonthClosingDAL _IVMMonthClosingDAL;
        private readonly static string fileName = nameof(StockUpdateRegisterBAL);
        public VMMonthClosingBAL(IVMMonthClosingDAL IVMMonthClosingDAL)
        {
            _IVMMonthClosingDAL = IVMMonthClosingDAL;

        }
        public MCLovEntity Load()
        {
            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(Load), Level.Info.ToString());

                Log4NetLogger.LogExit(fileName, nameof(Load), Level.Info.ToString());
                return _IVMMonthClosingDAL.Load();
            }
            catch (BALException balException)
            {
                throw new BALException(balException);
            }
            catch (Exception)
            {
                throw;
            }
        }
        public FetchMonthClosingDetails Get(FetchMonthClosingDetails entity)
        {
            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(Load), Level.Info.ToString());

                Log4NetLogger.LogExit(fileName, nameof(Load), Level.Info.ToString());
                return _IVMMonthClosingDAL.Get( entity);
            }
            catch (BALException balException)
            {
                throw new BALException(balException);
            }
            catch (Exception)
            {
                throw;
            }
        }
        public VMMonthClosingEntity MonthClose(VMMonthClosingEntity Entity)
        {
            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(Load), Level.Info.ToString());

                Log4NetLogger.LogExit(fileName, nameof(Load), Level.Info.ToString());
                return _IVMMonthClosingDAL.MonthClose(Entity);
            }
            catch (BALException balException)
            {
                throw new BALException(balException);
            }
            catch (Exception)
            {
                throw;
            }
        }
        public GridFilterResult Getall(GetallEntity pageFilter)
        {
            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(Getall), Level.Info.ToString());

                Log4NetLogger.LogExit(fileName, nameof(Getall), Level.Info.ToString());
                return _IVMMonthClosingDAL.Getall(pageFilter);
            }
            catch (BALException balException)
            {
                throw new BALException(balException);
            }
            catch (Exception)
            {
                throw;
            }
        }
    }
}
