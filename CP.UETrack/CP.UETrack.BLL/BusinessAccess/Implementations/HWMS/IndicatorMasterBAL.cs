using FluentValidation;
using FluentValidation.Internal;
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
   public class IndicatorMasterBAL : IIndicatorMasterBAL
    {
        private string _FileName = nameof(BlockBAL);
        IIndicatorMasterDAL _indicatorMasterDAL;
        public IndicatorMasterBAL(IIndicatorMasterDAL indicatorMasterDAL)
        {
            _indicatorMasterDAL = indicatorMasterDAL;
        }
        public GridFilterResult GetAll(SortPaginateFilter pageFilter)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(GetAll), Level.Info.ToString());
                var result = _indicatorMasterDAL.GetAll(pageFilter);
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
        public IndicatorMaster Get(int Id)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
                var result = _indicatorMasterDAL.Get(Id);
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
        public IndicatorMaster Save(IndicatorMaster block, out string ErrorMessage)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());

                ErrorMessage = string.Empty;
                IndicatorMaster result = null;


                result = _indicatorMasterDAL.Save(block, out ErrorMessage);


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

    }
}
