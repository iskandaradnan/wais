using CP.UETrack.BLL.BusinessAccess.Contracts.UM;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using CP.UETrack.Model;
using CP.UETrack.Model.UM;
using CP.Framework.Common.Logging;
using CP.Framework.Common.ExceptionHandler.ExceptionWrappers;
using CP.UETrack.DAL.DataAccess.Contracts.UM;

namespace CP.UETrack.BLL.BusinessAccess.Implementations.UM
{
    public class NotificationDeliveryConfigurationBAL : INotificationDeliveryConfigurationBAL
    {
        private string _FileName = nameof(NotificationDeliveryConfigurationBAL);
        INotificationDeliveryConfigurationDAL _NotificationDeliveryConfigurationDAL;

        public NotificationDeliveryConfigurationBAL(INotificationDeliveryConfigurationDAL NotificationDeliveryConfigurationDAL)
        {
            _NotificationDeliveryConfigurationDAL = NotificationDeliveryConfigurationDAL;
        }

        public bool Delete(string Id)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Delete), Level.Info.ToString());
                var result = _NotificationDeliveryConfigurationDAL.Delete(Id);
                Log4NetLogger.LogExit(_FileName, nameof(Delete), Level.Info.ToString());
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

        public NotificationDeliveryConfigurationModel Get(int Id)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
                var result = _NotificationDeliveryConfigurationDAL.Get(Id);
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

        public NotificationTypedropdown GetRole(int Id)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(GetRole), Level.Info.ToString());
                var result = _NotificationDeliveryConfigurationDAL.GetRole(Id);
                Log4NetLogger.LogExit(_FileName, nameof(GetRole), Level.Info.ToString());
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

        public NotificationTypedropdown GetCompany(int Id)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(GetCompany), Level.Info.ToString());
                var result = _NotificationDeliveryConfigurationDAL.GetCompany(Id);
                Log4NetLogger.LogExit(_FileName, nameof(GetCompany), Level.Info.ToString());
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

        public NotificationTypedropdown GetLocation(int Id)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(GetLocation), Level.Info.ToString());
                var result = _NotificationDeliveryConfigurationDAL.GetLocation(Id);
                Log4NetLogger.LogExit(_FileName, nameof(GetLocation), Level.Info.ToString());
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
                var result = _NotificationDeliveryConfigurationDAL.GetAll(pageFilter);
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

        public NotificationTypedropdown Load()
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
                var result = _NotificationDeliveryConfigurationDAL.Load();
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

        public NotificationDeliveryConfigurationModel Save(NotificationDeliveryConfigurationModel Notification, out string ErrorMessage)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());

                ErrorMessage = string.Empty;
                NotificationDeliveryConfigurationModel result = null;

                //if (IsValid(block, out ErrorMessage))
                //{
                result = _NotificationDeliveryConfigurationDAL.Save(Notification, out ErrorMessage);
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
