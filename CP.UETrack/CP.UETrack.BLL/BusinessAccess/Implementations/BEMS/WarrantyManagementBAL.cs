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
    public class WarrantyManagementBAL : IWarrantyManagementBAL
    {
        private string _FileName = nameof(WarrantyManagementBAL);
        IWarrantyManagementDAL _WarrantyManagementDAL;

        public WarrantyManagementBAL(IWarrantyManagementDAL WarrantyManagementDAL)
        {
            _WarrantyManagementDAL = WarrantyManagementDAL;
        }

        public ServiceLov Load()
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
                var result = _WarrantyManagementDAL.Load();
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

        public WarrantyManagement Save(WarrantyManagement warranty, out string ErrorMessage)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());
                ErrorMessage = string.Empty;
                WarrantyManagement result = null;

                //if (IsValid(warranty, out ErrorMessage))
                //{
                    result = _WarrantyManagementDAL.Save(warranty);
               // }

                Log4NetLogger.LogExit(_FileName, nameof(Save), Level.Info.ToString());
                return result;
            }
            catch (BALException balException)
            {
                throw new BALException(balException);
            }

            catch (Exception ex)
            {
                throw new BALException(ex);
            }
        }

        private bool IsValid(WarrantyManagement warranty, out string ErrorMessage)
        {
            ErrorMessage = string.Empty;
            var isValid = false;

            return isValid;
        }

        public WarrantyManagement Get(int Id)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
                var result = _WarrantyManagementDAL.Get(Id);
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

        public bool Delete(int Id)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Delete), Level.Info.ToString());
                var result = _WarrantyManagementDAL.Delete(Id);
                Log4NetLogger.LogExit(_FileName, nameof(Delete), Level.Info.ToString());
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

                Log4NetLogger.LogExit(_FileName, nameof(GetAll), Level.Info.ToString());
                return _WarrantyManagementDAL.GetAll(pageFilter);
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

        public WarrantyManagement GetDD(int Id, int pagesize, int pageindex)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(GetDD), Level.Info.ToString());
                var result = _WarrantyManagementDAL.GetDD(Id, pagesize, pageindex);
                Log4NetLogger.LogExit(_FileName, nameof(GetDD), Level.Info.ToString());
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

        public WarrantyManagement GetWO(int Id, int pagesize, int pageindex)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(GetWO), Level.Info.ToString());
                var result = _WarrantyManagementDAL.GetWO(Id, pagesize, pageindex);
                Log4NetLogger.LogExit(_FileName, nameof(GetWO), Level.Info.ToString());
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
