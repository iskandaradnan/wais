using CP.UETrack.BLL.BusinessAccess.Contracts.QAP;
using CP.UETrack.DAL.DataAccess.Contracts.QAP;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using CP.UETrack.Model;
using CP.UETrack.Model.QAP;
using CP.Framework.Common.ExceptionHandler.ExceptionWrappers;
using CP.Framework.Common.Logging;

namespace CP.UETrack.BLL.BusinessAccess.Implementations.QAP
{
    public class QualityCauseMasterBAL: IQualityCauseMasterBAL
    {
        private string _FileName = nameof(QualityCauseMasterBAL);
        IQualityCauseMasterDAL _QualityCauseMasterDAL;

        public QualityCauseMasterBAL(IQualityCauseMasterDAL QualityCauseMasterDAL)
        {
            _QualityCauseMasterDAL = QualityCauseMasterDAL;
        }

        public bool Delete(int Id)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
                var result = _QualityCauseMasterDAL.Delete(Id);
                Log4NetLogger.LogExit(_FileName, nameof(Get), Level.Info.ToString());
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

        public QualityCauseMasterModel Get(int Id,int pagesize,int pageindex)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
                var result = _QualityCauseMasterDAL.Get(Id, pagesize, pageindex);
                Log4NetLogger.LogExit(_FileName, nameof(Get), Level.Info.ToString());
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
                var result = _QualityCauseMasterDAL.GetAll(pageFilter);
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

        public QualityCauseTypeDropdown Load()
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
                var result = _QualityCauseMasterDAL.Load();
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

        public QualityCauseMasterModel Save(QualityCauseMasterModel Quality, out string ErrorMessage)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());

                ErrorMessage = string.Empty;
                QualityCauseMasterModel result = null;

                //if (IsValid(Quality, out ErrorMessage))
               // {
                    result = _QualityCauseMasterDAL.Save(Quality,out ErrorMessage);
               // }

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
