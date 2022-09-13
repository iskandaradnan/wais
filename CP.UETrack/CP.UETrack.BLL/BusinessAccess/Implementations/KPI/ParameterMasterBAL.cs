using CP.UETrack.BLL.BusinessAccess.Contracts.KPI;
using CP.UETrack.DAL.DataAccess.Contracts.KPI;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using CP.UETrack.Model;
using CP.UETrack.Model.KPI;
using CP.Framework.Common.ExceptionHandler.ExceptionWrappers;
using CP.Framework.Common.Logging;

namespace CP.UETrack.BLL.BusinessAccess.Implementations.KPI
{
    public class ParameterMasterBAL: IParameterMasterBAL
    {
        private string _FileName = nameof(ParameterMasterBAL);
        IParameterMasterDAL _ParameterMasterDAL;

        public ParameterMasterBAL(IParameterMasterDAL ParameterMasterDAL)
        {
            _ParameterMasterDAL = ParameterMasterDAL;
        }

        public ParameterTypeDropdown Load()
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
                var result = _ParameterMasterDAL.Load();
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
                var result = _ParameterMasterDAL.GetAll(pageFilter);
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
        public bool Delete(int Id)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
                var result = _ParameterMasterDAL.Delete(Id);
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

        public ParameterMasterModel Save(ParameterMasterModel Parameter)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());

                var ErrorMessage = string.Empty;
                ParameterMasterModel result = null;

                //if (IsValid(block, out ErrorMessage))
                //{
                result = _ParameterMasterDAL.Save(Parameter);
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

        public ParameterMasterModel Get(int Id)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
                var result = _ParameterMasterDAL.Get(Id);
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
        

        public ParameterMasterModel GetParameterList(int parameterservice, int parameterindicator)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
                var result = _ParameterMasterDAL.GetParameterList(parameterservice, parameterindicator);
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
    }
}
