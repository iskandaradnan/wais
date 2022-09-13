using FluentValidation;
using FluentValidation.Internal;
using CP.UETrack.BLL.BusinessAccess.Interface;
using CP.UETrack.DAL.DataAccess;
using CP.UETrack.Model;
using System;
using CP.Framework.Common.Logging;
using CP.Framework.Common.ExceptionHandler.ExceptionWrappers;
using CP.UETrack.Models;
using System.Collections.Generic;
using CP.UETrack.Model.Layout;
using CP.UETrack.Model.BEMS.CRMWorkOrder;

namespace CP.UETrack.BLL.BusinessAccess
{
    public class LayoutBAL : ILayoutBAL
    {
        private string _FileName = nameof(UserRoleBAL);
        ILayoutDAL _LayoutDAL;
        public LayoutBAL(ILayoutDAL layoutDAL)
        {
            _LayoutDAL = layoutDAL;
        }
        public CustomerFacilityLovs GetCustomerAndFacilities()
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(GetCustomerAndFacilities), Level.Info.ToString());
                var result = _LayoutDAL.GetCustomerAndFacilities();
                Log4NetLogger.LogExit(_FileName, nameof(GetCustomerAndFacilities), Level.Info.ToString());
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
        public CustomerFacilityLovs GetFacilities(int CustomerId)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(GetFacilities), Level.Info.ToString());
                var result = _LayoutDAL.GetFacilities(CustomerId);
                Log4NetLogger.LogExit(_FileName, nameof(GetFacilities), Level.Info.ToString());
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


        public NotificationCount GetNotificationCount(int FacilityId, int UserId)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(GetNotificationCount), Level.Info.ToString());
                var result = _LayoutDAL.GetNotificationCount(FacilityId, UserId);
                Log4NetLogger.LogExit(_FileName, nameof(GetNotificationCount), Level.Info.ToString());
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
        public Notification GetNotification(int pagesize, int pageindex)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(GetNotification), Level.Info.ToString());
                var result = _LayoutDAL.GetNotification(pagesize, pageindex);
                Log4NetLogger.LogExit(_FileName, nameof(GetNotification), Level.Info.ToString());
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
        public Notification ReseteNotificationCount(Notification notify)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(ReseteNotificationCount), Level.Info.ToString());
                var result = _LayoutDAL.ReseteNotificationCount(notify);
                Log4NetLogger.LogExit(_FileName, nameof(ReseteNotificationCount), Level.Info.ToString());
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

        public Notification ClearNavigatedRec(Notification notify)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(ReseteNotificationCount), Level.Info.ToString());
                var result = _LayoutDAL.ClearNavigatedRec(notify);
                Log4NetLogger.LogExit(_FileName, nameof(ReseteNotificationCount), Level.Info.ToString());
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

        public CustomerFacilityLovs LoadCustomer()
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(LoadCustomer), Level.Info.ToString());
                var result = _LayoutDAL.LoadCustomer();
                Log4NetLogger.LogExit(_FileName, nameof(LoadCustomer), Level.Info.ToString());
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

        public CustomerFacilityLovs LoadFacility(int CusId)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(LoadFacility), Level.Info.ToString());
                var result = _LayoutDAL.LoadFacility(CusId);
                Log4NetLogger.LogExit(_FileName, nameof(LoadFacility), Level.Info.ToString());
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

        public CustomerFacilityLovs GetCustomerFacilityDet(int CusId, int FacId)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(GetCustomerFacilityDet), Level.Info.ToString());
                var result = _LayoutDAL.GetCustomerFacilityDet(CusId, FacId);
                Log4NetLogger.LogExit(_FileName, nameof(GetCustomerFacilityDet), Level.Info.ToString());
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
