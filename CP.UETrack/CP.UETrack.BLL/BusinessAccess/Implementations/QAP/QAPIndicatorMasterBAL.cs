using CP.UETrack.BLL.BusinessAccess.Contracts.QAP;
using CP.UETrack.DAL.DataAccess.Contracts.QAP;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using CP.UETrack.Model;
using CP.UETrack.Model.QAP;
using CP.Framework.Common.Logging;
using CP.Framework.Common.ExceptionHandler.ExceptionWrappers;

namespace CP.UETrack.BLL.BusinessAccess.Implementations.QAP
{
    public class QAPIndicatorMasterBAL : IQAPIndicatorMasterBAL
    {
        private string _FileName = nameof(QAPIndicatorMasterBAL);
        IQAPIndicatorMasterDAL _QAPIndicatorMasterDAL;

        public QAPIndicatorMasterBAL(IQAPIndicatorMasterDAL QAPIndicatorMasterDAL)
        {
            _QAPIndicatorMasterDAL = QAPIndicatorMasterDAL;
        }

        public QAPIndicatorTypeDropdown Load()
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
                var result = _QAPIndicatorMasterDAL.Load();
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

        public GridFilterResult GetAll(SortPaginateFilter pageFilter)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(GetAll), Level.Info.ToString());
                var result = _QAPIndicatorMasterDAL.GetAll(pageFilter);
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


        public QAPIndicatorMasterModel Get(int Id)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
                var result = _QAPIndicatorMasterDAL.Get(Id);
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

        public bool Delete(int Id)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
                var result = _QAPIndicatorMasterDAL.Delete(Id);
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



        public QAPIndicatorMasterModel Save(QAPIndicatorMasterModel QAPIndicator)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());

                var ErrorMessage = string.Empty;
                QAPIndicatorMasterModel result = null;

                //if (IsValid(block, out ErrorMessage))
                //{
                result = _QAPIndicatorMasterDAL.Save(QAPIndicator);
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
    }
}
