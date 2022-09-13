using CP.Framework.Common.ExceptionHandler.ExceptionWrappers;
using CP.Framework.Common.Logging;
using CP.UETrack.BLL.BusinessAccess.Contracts.HWMS;
using CP.UETrack.DAL.DataAccess.Contracts.HWMS;
using CP.UETrack.Model;
using CP.UETrack.Model.HWMS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CP.UETrack.BLL.BusinessAccess.Implementations.HWMS
{
    public class RecordsofRecyclableWasteBAL : IRecordsofRecyclableWasteBAL
    {
        private string _FileName = nameof(BlockBAL);
        IRecordsofRecyclableWasteDAL _recordsofRecyclableWasteDAL;
        public RecordsofRecyclableWasteBAL(IRecordsofRecyclableWasteDAL records)
        {
            _recordsofRecyclableWasteDAL = records;
        }

        public RecordsDropdowns Load()
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
                var result = _recordsofRecyclableWasteDAL.Load();
                Log4NetLogger.LogExit(_FileName, nameof(Load), Level.Info.ToString());
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
        public RecordsofRecyclableWaste WasteCodeGet(string WasteType)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(WasteCodeGet), Level.Info.ToString());
                var result = _recordsofRecyclableWasteDAL.WasteCodeGet(WasteType);
                Log4NetLogger.LogExit(_FileName, nameof(WasteCodeGet), Level.Info.ToString());
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
        public RecordsofRecyclableWaste CSWRSFetch(RecordsofRecyclableWaste block, out string ErrorMessage)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(CSWRSFetch), Level.Info.ToString());

                ErrorMessage = string.Empty;
                RecordsofRecyclableWaste result = null;


                result = _recordsofRecyclableWasteDAL.CSWRSFetch(block, out ErrorMessage);


                Log4NetLogger.LogExit(_FileName, nameof(CSWRSFetch), Level.Info.ToString());
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


        public RecordsofRecyclableWaste Save(RecordsofRecyclableWaste block, out string ErrorMessage)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());

                ErrorMessage = string.Empty;
                RecordsofRecyclableWaste result = null;


                result = _recordsofRecyclableWasteDAL.Save(block, out ErrorMessage);


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
        public GridFilterResult GetAll(SortPaginateFilter pageFilter)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(GetAll), Level.Info.ToString());
                var result = _recordsofRecyclableWasteDAL.GetAll(pageFilter);
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
        public RecordsofRecyclableWaste Get(int Id)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
                var result = _recordsofRecyclableWasteDAL.Get(Id);
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
    }
}
