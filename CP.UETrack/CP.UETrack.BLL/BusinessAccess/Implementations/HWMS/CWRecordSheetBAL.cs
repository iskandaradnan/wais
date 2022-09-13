using FluentValidation;
using FluentValidation.Internal;
using CP.UETrack.CLS.BusinessAccess.Interface;
using CP.UETrack.DAL.DataAccess.Contracts.HWMS;
using CP.UETrack.Model.HWMS;
using CP.UETrack.Model;
using System;
using CP.Framework.Common.Logging;
using CP.Framework.Common.ExceptionHandler.ExceptionWrappers;
using CP.UETrack.Models;
using System.Collections.Generic;
using CP.UETrack.BLL.BusinessAccess.Contracts.HWMS;

namespace CP.UETrack.BLL.BusinessAccess.Implementations.HWMS
{
    public class CWRecordSheetBAL : ICWRecordSheetBAL
    {
        private string _FileName = nameof(CWRecordSheetBAL);
        ICWRecordSheetDAL _ICWRecordSheetDAL;
        public CWRecordSheetBAL(ICWRecordSheetDAL ICWRecordSheetDAL)
        {
            _ICWRecordSheetDAL = ICWRecordSheetDAL;
        }
        public CWRecordSheetCollectionDetailsDropdown Load()
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
                var result = _ICWRecordSheetDAL.Load();
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
        
        public CWRecordSheet CollectionDetailsFetch(int Id)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(CollectionDetailsFetch), Level.Info.ToString());
                var result = _ICWRecordSheetDAL.CollectionDetailsFetch(Id);
                Log4NetLogger.LogExit(_FileName, nameof(CollectionDetailsFetch), Level.Info.ToString());
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
        public CWRecordSheet Save(CWRecordSheet block, out string ErrorMessage)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());

                ErrorMessage = string.Empty;
                CWRecordSheet result = null;


                result = _ICWRecordSheetDAL.Save(block, out ErrorMessage);


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
                var result = _ICWRecordSheetDAL.GetAll(pageFilter);
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
        public CWRecordSheet Get(int Id)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
                var result = _ICWRecordSheetDAL.Get(Id);
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
        public CWRecordSheetCollectionDetails CollectionTimeDetails(CWRecordSheetCollectionDetails block, out string ErrorMessage)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(CollectionTimeDetails), Level.Info.ToString());

                ErrorMessage = string.Empty;
                CWRecordSheetCollectionDetails result = null;


                result = _ICWRecordSheetDAL.CollectionTimeDetails(block, out ErrorMessage);


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
        //public CWRecordSheetCollectionDetails CollectionTimeDetails()
        //{
        //    try
        //    {
        //        Log4NetLogger.LogEntry(_FileName, nameof(CollectionTimeDetails), Level.Info.ToString());

        //        var result = _ICWRecordSheetDAL.CollectionTimeDetails();
        //        Log4NetLogger.LogExit(_FileName, nameof(CollectionTimeDetails), Level.Info.ToString());
        //        return result;
        //    }
        //    catch (BALException balException)
        //    {
        //        throw new BALException(balException);
        //    }
        //    catch (Exception)
        //    {
        //        throw;
        //    }
        //}

    }

}
