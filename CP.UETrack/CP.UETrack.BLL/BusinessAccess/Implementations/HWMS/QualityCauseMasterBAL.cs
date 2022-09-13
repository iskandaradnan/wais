using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using CP.UETrack.Model;
using CP.UETrack.Model.HWMS;
using CP.UETrack.BLL.BusinessAccess.Contracts.HWMS;
using CP.UETrack.DAL.DataAccess.Contracts.HWMS;
using CP.Framework.Common.Logging;
using CP.Framework.Common.ExceptionHandler.ExceptionWrappers;


namespace CP.UETrack.BLL.BusinessAccess.Implementations.HWMS
{
   public class QualityCauseMasterBAL: IQualityCauseMasterBAL
    {
       
            private string _FileName = nameof(QualityCauseMasterBAL);
            IQualityCauseMasterDAL _qualityCauseMasterDAL;

            public QualityCauseMasterBAL(IQualityCauseMasterDAL qualityCauseMasterDAL)
            {
                _qualityCauseMasterDAL = qualityCauseMasterDAL;
            }

            public QualityCauseMasterDropdown Load()
            {
                try
                {
                    Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
                    var result = _qualityCauseMasterDAL.Load();
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

            public QualityCauseMaster Save(QualityCauseMaster block, out string ErrorMessage)
            {
                try
                {
                    Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());

                    ErrorMessage = string.Empty;
                    QualityCauseMaster result = null;


                    result = _qualityCauseMasterDAL.Save(block, out ErrorMessage);


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
                var result = _qualityCauseMasterDAL.GetAll(pageFilter);
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

        public QualityCauseMaster Get(int Id)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
                var result = _qualityCauseMasterDAL.Get(Id);
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
