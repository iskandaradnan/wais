using CP.Framework.Common.ExceptionHandler.ExceptionWrappers;
using CP.Framework.Common.Logging;
using CP.UETrack.BLL.BusinessAccess.Contracts.HWMS;
using CP.UETrack.DAL.DataAccess.Contracts.HWMS;
using CP.UETrack.Model.HWMS;
using CP.UETrack.Model;
using System;
using System.Collections.Generic;
using FluentValidation;
using FluentValidation.Internal;
using CP.UETrack.CLS.BusinessAccess.Interface;
using CP.UETrack.Models;
using System.Data.SqlClient;
using UETrack.DAL;
using System.Data;
using System.Linq;

namespace CP.UETrack.BLL.BusinessAccess.Implementations.HWMS
{
    public class FacilitiesEquipmentBAL : IFacilitiesEquipmentBAL
    {
        private string _FileName = nameof(FacilitiesEquipmentBAL);
        IFacilitiesEquipmentDAL _fetCDAL;
        public FacilitiesEquipmentBAL(IFacilitiesEquipmentDAL fetC)
        {
            _fetCDAL = fetC;
        }
        public FacilitiesEquipmentDropdown Load()
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
                var result = _fetCDAL.Load();
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
        public FacilitiesEquipment Save(FacilitiesEquipment block, out string ErrorMessage)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());

                ErrorMessage = string.Empty;
                FacilitiesEquipment result = null;


                result = _fetCDAL.Save(block, out ErrorMessage);


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
                var result = _fetCDAL.GetAll(pageFilter);
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
        public FacilitiesEquipment Get(int Id)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
                var result = _fetCDAL.Get(Id);
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

        public FacilitiesEquipment AutoGenerateCode()
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(AutoGenerateCode), Level.Info.ToString());
                var result = _fetCDAL.AutoGenerateCode();
                Log4NetLogger.LogExit(_FileName, nameof(AutoGenerateCode), Level.Info.ToString());
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

