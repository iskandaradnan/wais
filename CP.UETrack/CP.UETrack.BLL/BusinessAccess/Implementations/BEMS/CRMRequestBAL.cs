using CP.Framework.Common.ExceptionHandler.ExceptionWrappers;
using CP.Framework.Common.Logging;
using CP.UETrack.BLL.BusinessAccess.Contracts.BEMS;
using CP.UETrack.DAL.DataAccess.Contracts.BEMS;
using CP.UETrack.Model;
using CP.UETrack.Model.BEMS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CP.UETrack.BLL.BusinessAccess.Implementations.BEMS
{
   public class CRMRequestBAL: ICRMRequestBAL
    {

        private readonly ICRMRequestDAL _ICRMRequestDAL;
        private readonly static string fileName = nameof(StockUpdateRegisterBAL);
        public CRMRequestBAL(ICRMRequestDAL ICRMRequestDAL)
        {
            _ICRMRequestDAL = ICRMRequestDAL;

        }

        public void save(ref CRMRequestEntity model)
        {
            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(save), Level.Info.ToString());
                _ICRMRequestDAL.save(ref model);
                Log4NetLogger.LogExit(fileName, nameof(save), Level.Info.ToString());
                // return result;
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
        public void update(ref CRMRequestEntity entity)
        {
            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(update), Level.Info.ToString());
                _ICRMRequestDAL.update(ref entity);
                Log4NetLogger.LogExit(fileName, nameof(update), Level.Info.ToString());
                // return result;
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
        public CRMRequestEntity Get(int id, int pagesize, int pageindex)
        {
            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(Get), Level.Info.ToString());

                Log4NetLogger.LogExit(fileName, nameof(Get), Level.Info.ToString());
                return _ICRMRequestDAL.Get(id, pagesize, pageindex);
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
        public CRMRequestEntity get_Indicator_by_Serviceid(int id)
        {
            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(get_Indicator_by_Serviceid), Level.Info.ToString());

                Log4NetLogger.LogExit(fileName, nameof(get_Indicator_by_Serviceid), Level.Info.ToString());
                return _ICRMRequestDAL.get_Indicator_by_Serviceid(id);
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

        public CORMDropdownList get_TypeofRequset_by_Serviceid(int id)
        {
            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(get_TypeofRequset_by_Serviceid), Level.Info.ToString());

                Log4NetLogger.LogExit(fileName, nameof(get_TypeofRequset_by_Serviceid), Level.Info.ToString());
                return _ICRMRequestDAL.get_TypeofRequset_by_Serviceid(id);
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
        public bool Cancel(int id,String Remarks)
        {
            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(Cancel), Level.Info.ToString());

                Log4NetLogger.LogExit(fileName, nameof(Cancel), Level.Info.ToString());
                return _ICRMRequestDAL.Cancel(id, Remarks);
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
        public GridFilterResult Getall(int id,SortPaginateFilter pageFilter)
        {
            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(Getall), Level.Info.ToString());

                Log4NetLogger.LogExit(fileName, nameof(Getall), Level.Info.ToString());
                return _ICRMRequestDAL.Getall(id,pageFilter);
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
        public GridFilterResult Getall(SortPaginateFilter pageFilter)
        {
            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(Getall), Level.Info.ToString());

                Log4NetLogger.LogExit(fileName, nameof(Getall), Level.Info.ToString());
                return _ICRMRequestDAL.Getall(pageFilter);
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
        public GridFilterResult GetallService(int id, SortPaginateFilter pageFilter)
        {
            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(GetallService), Level.Info.ToString());

                Log4NetLogger.LogExit(fileName, nameof(GetallService), Level.Info.ToString());
                return _ICRMRequestDAL.GetallService(id,pageFilter);
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
        public CORMDropdownList Load()
        {
            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(Load), Level.Info.ToString());

                Log4NetLogger.LogExit(fileName, nameof(Load), Level.Info.ToString());
                return _ICRMRequestDAL.Load();
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

        public CRMRequestEntity ConvertWO(CRMRequestEntity workorder)
        {
            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(ConvertWO), Level.Info.ToString());

                CRMRequestEntity result = null;

                result = _ICRMRequestDAL.ConvertWO(workorder);

                Log4NetLogger.LogExit(fileName, nameof(ConvertWO), Level.Info.ToString());
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

        public CRMRequestEntity ApplyingProcess(CRMRequestEntity workorder)
        {
            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(ApplyingProcess), Level.Info.ToString());

                CRMRequestEntity result = null;

                result = _ICRMRequestDAL.ApplyingProcess(workorder);

                Log4NetLogger.LogExit(fileName, nameof(ApplyingProcess), Level.Info.ToString());
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

        public CRMRequestEntity GetObsAsset(CRMRequestEntity crm)
        {
            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(GetObsAsset), Level.Info.ToString());
                CRMRequestEntity result = null;

                //if (IsValid(EODParamMapping, out ErrorMessage))
                //{
                result = _ICRMRequestDAL.GetObsAsset(crm);
                //}

                Log4NetLogger.LogExit(fileName, nameof(GetObsAsset), Level.Info.ToString());
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

        public CRMRequestEntity GetObsAssetM(int ManId, int ModId, int pagesize, int pageindex)
        {
            try
            {
                Log4NetLogger.LogEntry(fileName, nameof(GetObsAssetM), Level.Info.ToString());

                Log4NetLogger.LogExit(fileName, nameof(GetObsAssetM), Level.Info.ToString());
                var result = _ICRMRequestDAL.GetObsAssetM(ManId, ModId, pagesize, pageindex);
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

        //public GridFilterResult BemsCRMGetall(int id, SortPaginateFilter pageFilter, int TypeOfRequest, int ServiceId)
        //{
        //    try
        //    {
        //        Log4NetLogger.LogEntry(fileName, nameof(BemsCRMGetall), Level.Info.ToString());

        //        Log4NetLogger.LogExit(fileName, nameof(BemsCRMGetall), Level.Info.ToString());
        //        var result = _ICRMRequestDAL.BemsCRMGetall( id, pageFilter, TypeOfRequest, ServiceId);
        //        return result;
        //    }
        //    catch (BALException balException)
        //    {
        //        throw new BALException(balException);
        //    }
        //    catch (Exception)
        //    {
        //        throw;
        //    }
        //}
    }
}
