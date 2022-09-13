using CP.Framework.Common.ExceptionHandler.ExceptionWrappers;
using CP.Framework.Common.Logging;
using CP.UETrack.BLL.BusinessAccess.Contracts.HWMS;
using CP.UETrack.DAL.DataAccess.Contracts.CLS;
using CP.UETrack.DAL.DataAccess.Contracts.HWMS;
using CP.UETrack.Model.HWMS;
using CP.UETrack.Model;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CP.UETrack.BLL.BusinessAccess.Implementations.HWMS
{
    public class ConsignmentNoteOSWCNBAL : IConsignmentNoteOSWCNBAL
    {
        private string _FileName = nameof(BlockBAL);
        IConsignmentNoteOSWCNDAL _consignmentNoteOSWCNDAL;
        public ConsignmentNoteOSWCNBAL(IConsignmentNoteOSWCNDAL consignmentNoteOSWCN)
        {
            _consignmentNoteOSWCNDAL = consignmentNoteOSWCN;
        }
        public ConsignmentOSWCNDropDown Load()
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
                var result = _consignmentNoteOSWCNDAL.Load();
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
        public ConsignmentNoteOSWCN Save(ConsignmentNoteOSWCN block, out string ErrorMessage)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());

                ErrorMessage = string.Empty;
                ConsignmentNoteOSWCN result = null;


                result = _consignmentNoteOSWCNDAL.Save(block, out ErrorMessage);


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
                var result = _consignmentNoteOSWCNDAL.GetAll(pageFilter);
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
        public ConsignmentNoteOSWCN Get(int Id)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
                var result = _consignmentNoteOSWCNDAL.Get(Id);
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

        
        public ConsignmentNoteOSWCN WasteTypeData(string Wastetype)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(WasteTypeData), Level.Info.ToString());
                var result = _consignmentNoteOSWCNDAL.WasteTypeData(Wastetype);
                Log4NetLogger.LogExit(_FileName, nameof(WasteTypeData), Level.Info.ToString());
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

        public ConsignmentNoteOSWCN FetchConsign(ConsignmentNoteOSWCN block, out string ErrorMessage)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(FetchConsign), Level.Info.ToString());
                ErrorMessage = string.Empty;
                ConsignmentNoteOSWCN result = null;

                result = _consignmentNoteOSWCNDAL.FetchConsign(block, out ErrorMessage);
                Log4NetLogger.LogExit(_FileName, nameof(FetchConsign), Level.Info.ToString());
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
