﻿using CP.Framework.Common.ExceptionHandler.ExceptionWrappers;
using CP.Framework.Common.Logging;
using CP.UETrack.BLL.BusinessAccess.Contracts.HWMS;
using CP.UETrack.BLL.BusinessAccess.Interface;
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
   public class CSWRecordSheetBAL: ICSWRecordSheetBAL
    {

        private string _FileName = nameof(BlockBAL);
        ICSWRecordSheetDAL _cswrecordsheetDAL;

        public CSWRecordSheetBAL(ICSWRecordSheetDAL cswrecordsheetDAL)
        {
            _cswrecordsheetDAL = cswrecordsheetDAL;
        }
        public CSWRecordSheetDropdown Load()
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
                var result = _cswrecordsheetDAL.Load();
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
        public CSWRecordSheet AutoGeneratedCode()
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(AutoGeneratedCode), Level.Info.ToString());
                var result = _cswrecordsheetDAL.AutoGeneratedCode();
                Log4NetLogger.LogExit(_FileName, nameof(AutoGeneratedCode), Level.Info.ToString());
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
        public CSWRecordSheet Save(CSWRecordSheet model, out string ErrorMessage)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());

                ErrorMessage = string.Empty;
                CSWRecordSheet result = null;


                result = _cswrecordsheetDAL.Save(model, out ErrorMessage);


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
                var result = _cswrecordsheetDAL.GetAll(pageFilter);
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
        public CSWRecordSheet Get(int Id)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
                var result = _cswrecordsheetDAL.Get(Id);
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
        public List<CSWRecordSheet> AutoDisplaying()
        {

            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(AutoDisplaying), Level.Info.ToString());
                var result = _cswrecordsheetDAL.AutoDisplaying();
                Log4NetLogger.LogExit(_FileName, nameof(AutoDisplaying), Level.Info.ToString());
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
        public CSWRecordSheet WasteCodeGet(string WasteType)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(WasteCodeGet), Level.Info.ToString());
                var result = _cswrecordsheetDAL.WasteCodeGet(WasteType);
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
    }
}
