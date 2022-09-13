using FluentValidation;
using FluentValidation.Internal;
using CP.UETrack.DAL.DataAccess.Contracts.HWMS;
using CP.UETrack.Model;
using System;
using CP.Framework.Common.Logging;
using CP.Framework.Common.ExceptionHandler.ExceptionWrappers;
using System.Collections.Generic;
using CP.UETrack.Model.HWMS;
using CP.UETrack.BLL.BusinessAccess.Contracts.HWMS;

namespace CP.UETrack.BLL.BusinessAccess.Implementations.HWMS
{
  public  class TransportationCategoryBAL : ITransportationCategoryBAL
    {
        private string _FileName = nameof(BlockBAL);
        ITransportationCategoryDAL _transportationCategoryDAL;
        public TransportationCategoryBAL(ITransportationCategoryDAL transportationCategoryDAL)
        {
            _transportationCategoryDAL = transportationCategoryDAL;
        }
        public TransportationCategoryDropDown Load()
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
                var result = _transportationCategoryDAL.Load();
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
        public TransportationCategory Save(TransportationCategory model, out string ErrorMessage)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());

                ErrorMessage = string.Empty;
                TransportationCategory result = null;


                result = _transportationCategoryDAL.Save(model, out ErrorMessage);


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
                var result = _transportationCategoryDAL.GetAll(pageFilter);
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
        public TransportationCategory Get(int Id)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
                var result = _transportationCategoryDAL.Get(Id);
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
        public List<TransportationCategoryTable> HospitalCodeFetch(TransportationCategoryTable SearchObject)
        {

            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(HospitalCodeFetch), Level.Info.ToString());
                var result = _transportationCategoryDAL.HospitalCodeFetch(SearchObject);
                Log4NetLogger.LogExit(_FileName, nameof(HospitalCodeFetch), Level.Info.ToString());
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

        public TransportationCategory HospitalNameData(string HospitalCode)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(HospitalNameData), Level.Info.ToString());
                var result = _transportationCategoryDAL.HospitalNameData(HospitalCode);
                Log4NetLogger.LogExit(_FileName, nameof(HospitalNameData), Level.Info.ToString());
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
