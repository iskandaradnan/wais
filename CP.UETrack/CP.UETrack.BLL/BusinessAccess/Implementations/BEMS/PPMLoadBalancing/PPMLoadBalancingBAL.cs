
using CP.UETrack.BLL.BusinessAccess.Interface;
using CP.UETrack.DAL.DataAccess;
using CP.UETrack.Model;
using System;
using CP.Framework.Common.Logging;
using CP.Framework.Common.ExceptionHandler.ExceptionWrappers;
using System.Collections.Generic;

namespace CP.UETrack.BLL.BusinessAccess
{
    public class PPMLoadBalancingBAL : IPPMLoadBalancingBAL
    {
        private string _FileName = nameof(PPMLoadBalancingBAL);
        IPPMLoadBalancingDAL _PPMLoadBalancingDAL;

        public PPMLoadBalancingBAL(IPPMLoadBalancingDAL pPMLoadBalancingDAL)
        {
            _PPMLoadBalancingDAL = pPMLoadBalancingDAL;
        }
        public PPMLoadBalancingLovs Load()
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
                var result = _PPMLoadBalancingDAL.Load();
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
        public PPMLoadBalancing GetWorkOrderDetails(PPMLoadBalancingFetch loadBalancingFetch)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(GetWorkOrderDetails), Level.Info.ToString());
                var result = _PPMLoadBalancingDAL.GetWorkOrderDetails(loadBalancingFetch);
                Log4NetLogger.LogExit(_FileName, nameof(GetWorkOrderDetails), Level.Info.ToString());
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
        public List<PPMLoadBalancingWorkOrder> GetWorkOrders(PPMLoadBalancingWorkOrder loadBalancingWorkOrder)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(GetWorkOrderDetails), Level.Info.ToString());
                var result = _PPMLoadBalancingDAL.GetWorkOrders(loadBalancingWorkOrder);
                Log4NetLogger.LogExit(_FileName, nameof(GetWorkOrderDetails), Level.Info.ToString());
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
        public PPMLoadBalancingWorkOrders Save(PPMLoadBalancingWorkOrders pPMLoadBalancing, out string ErrorMessage)
        {
            try
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());

                ErrorMessage = string.Empty;
                PPMLoadBalancingWorkOrders result = null;

                if (IsValid(pPMLoadBalancing, out ErrorMessage))
                {
                    result = _PPMLoadBalancingDAL.Save(pPMLoadBalancing, out ErrorMessage);
                }

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
        private bool IsValid(PPMLoadBalancingWorkOrders PPMLoadBalancingWorkOrders, out string ErrorMessage)
        {
            ErrorMessage = string.Empty;
            var isValid = true;
            var currentDate = DateTime.Now.Date;

            foreach (var item in PPMLoadBalancingWorkOrders.WorkOrders)
            {
                if (item.TargetDateTime != null && ((DateTime)item.TargetDateTime).Date < currentDate)
                {
                   
                    ErrorMessage = "Proposed Date should be greater than or equal to current date";
                    break;
                }
            }
            if (ErrorMessage != string.Empty)
            {
                isValid = false;
            }
            return isValid;
        }
    }
}
