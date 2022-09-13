using FluentValidation;
using FluentValidation.Internal;
using CP.UETrack.CLS.BusinessAccess.Interface;
using CP.UETrack.DAL.DataAccess.Contracts.CLS;
using CP.UETrack.Model.CLS;
using CP.UETrack.Model;
using System;
using CP.Framework.Common.Logging;
using CP.Framework.Common.ExceptionHandler.ExceptionWrappers;
using CP.UETrack.Models;
using System.Collections.Generic;
using CP.UETrack.BLL.BusinessAccess.Contracts.CLS;

namespace CP.UETrack.BLL.BusinessAccess.Implementation.CLS
{
    public class ApprovedChemicalListBAL: IApprovedChemicalListBAL
    {
        private string _FileName = nameof(BlockBAL);
        IApprovedChemicalListDAL _approvedChemicalListDAL;
        public ApprovedChemicalListBAL(IApprovedChemicalListDAL approvedChemicalList)
        {
            _approvedChemicalListDAL = approvedChemicalList;
        }
        public ApprovedChemicalListDropdown Load()
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
                var result = _approvedChemicalListDAL.Load();
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

        public ApprovedChemicalList Save(ApprovedChemicalList block, out string ErrorMessage)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());

                ErrorMessage = string.Empty;
                ApprovedChemicalList result = null;


                result = _approvedChemicalListDAL.Save(block, out ErrorMessage);


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
                var result = _approvedChemicalListDAL.GetAll(pageFilter);
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
        public ApprovedChemicalList Get(int Id)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
                var result = _approvedChemicalListDAL.Get(Id);
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
