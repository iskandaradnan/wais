using CP.UETrack.BLL.BusinessAccess.Contracts.BEMS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using CP.UETrack.Model.BEMS;
using CP.UETrack.DAL.DataAccess.Contracts.BEMS;
using CP.Framework.Common.Logging;
using CP.Framework.Common.ExceptionHandler.ExceptionWrappers;
using CP.UETrack.Model;

namespace CP.UETrack.BLL.BusinessAccess.Implementations.BEMS
{
    public class StockAdjustmentBAL : IStockAdjustmentBAL
    {
        private string _FileName = nameof(StockAdjustmentBAL);
        IStockAdjustmentDAL _StockAdjustmentDAL;

        public StockAdjustmentBAL(IStockAdjustmentDAL StockAdjustmentDAL)
        {
            _StockAdjustmentDAL = StockAdjustmentDAL;
        }


        public StockAdjustmentModel Save(StockAdjustmentModel Adjustment, out string ErrorMessage)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());

                ErrorMessage = string.Empty;
                StockAdjustmentModel result = null;

                //if (IsValid(block, out ErrorMessage))
                //{
                result = _StockAdjustmentDAL.Save(Adjustment,out ErrorMessage);
                //}

                Log4NetLogger.LogExit(_FileName, nameof(Save), Level.Info.ToString());
                return result;
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
        public StockAdjustmentModel Get(int Id, int pagesize, int pageindex)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
                var result = _StockAdjustmentDAL.Get(Id, pagesize, pageindex);
                Log4NetLogger.LogExit(_FileName, nameof(Get), Level.Info.ToString());
                return result;
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

        public bool Delete(int Id)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Delete), Level.Info.ToString());
                var result = _StockAdjustmentDAL.Delete(Id);
                Log4NetLogger.LogExit(_FileName, nameof(Delete), Level.Info.ToString());
                return result;
            }
            catch (BALException bx)
            {
                throw new BALException(bx);
            }
            catch (Exception ex)
            {
                throw new BALException(ex);
            }
        }

        public GridFilterResult GetAll(SortPaginateFilter pageFilter)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(GetAll), Level.Info.ToString());
                var result = _StockAdjustmentDAL.GetAll(pageFilter);
                Log4NetLogger.LogExit(_FileName, nameof(GetAll), Level.Info.ToString());
                return result;
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
