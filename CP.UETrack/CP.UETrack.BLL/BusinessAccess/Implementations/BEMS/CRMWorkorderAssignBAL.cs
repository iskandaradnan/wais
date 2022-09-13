using CP.Framework.Common.ExceptionHandler.ExceptionWrappers;
using CP.Framework.Common.Logging;
using CP.UETrack.BLL.BusinessAccess.Contracts.BEMS;
using CP.UETrack.DAL.DataAccess.Contracts.BEMS;
using CP.UETrack.Model;
using CP.UETrack.Model.BEMS;
using CP.UETrack.Model.BEMS.CRMWorkOrder;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CP.UETrack.BLL.BusinessAccess.Implementations.BEMS
{
    public class CRMWorkorderAssignBAL : ICRMWorkorderAssignBAL
    {
        private string _FileName = nameof(CRMWorkorderAssignBAL);
        ICRMWorkorderAssignDAL _CRMWorkorderAssignDAL;

        public CRMWorkorderAssignBAL(ICRMWorkorderAssignDAL CRMWorkorderAssignDAL)
        {
            _CRMWorkorderAssignDAL = CRMWorkorderAssignDAL;
        }

        public CRMWorkorderDropdownValues Load()
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
                var result = _CRMWorkorderAssignDAL.Load();
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
        public CRMWorkorderAssign Save(CRMWorkorderAssign workorder, out string ErrorMessage)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());

                ErrorMessage = string.Empty;
                CRMWorkorderAssign result = null;

                //if (IsValid(EODParamMapping, out ErrorMessage))
                //{
                result = _CRMWorkorderAssignDAL.Save(workorder, out ErrorMessage);
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

        public GridFilterResult GetAll(SortPaginateFilter pageFilter)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(GetAll), Level.Info.ToString());
                var result = _CRMWorkorderAssignDAL.GetAll(pageFilter);
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

        public CRMWorkorderAssign Get(int Id)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
                var result = _CRMWorkorderAssignDAL.Get(Id);
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

        public CRMWorkorderAssign FetchWorkorder(CRMWorkorderAssign EODCaptur)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(FetchWorkorder), Level.Info.ToString());
                CRMWorkorderAssign result = null;

                result = _CRMWorkorderAssignDAL.FetchWorkorder(EODCaptur);

                Log4NetLogger.LogExit(_FileName, nameof(FetchWorkorder), Level.Info.ToString());
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
