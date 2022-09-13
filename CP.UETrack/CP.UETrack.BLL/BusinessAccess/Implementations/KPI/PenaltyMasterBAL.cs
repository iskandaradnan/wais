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
    public class PenaltyMasterBAL : IPenaltyMasterBAL
    {
        private string _FileName = nameof(PenaltyMasterBAL);
        IPenaltyMasterDAL _PenaltyMasterDAL;

        public PenaltyMasterBAL(IPenaltyMasterDAL PenaltyMasterDAL)
        {
            _PenaltyMasterDAL = PenaltyMasterDAL;
        }

        public PenaltyTypeDropdown Load()
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
                var result = _PenaltyMasterDAL.Load();
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
                var result = _PenaltyMasterDAL.GetAll(pageFilter);
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
                var result = _PenaltyMasterDAL.Delete(Id);
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


        public PenaltyMasterModel Save(PenaltyMasterModel Penalty)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());

                var ErrorMessage = string.Empty;
                PenaltyMasterModel result = null;

                //if (IsValid(block, out ErrorMessage))
                //{
                result = _PenaltyMasterDAL.Save(Penalty);
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

        public PenaltyMasterModel Get(int Id)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
                var result = _PenaltyMasterDAL.Get(Id);
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
        public PenaltyMasterModel GetPenaltyList(int penaltyservice, int penaltycriteria)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
                var result = _PenaltyMasterDAL.GetPenaltyList(penaltyservice, penaltycriteria);
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
