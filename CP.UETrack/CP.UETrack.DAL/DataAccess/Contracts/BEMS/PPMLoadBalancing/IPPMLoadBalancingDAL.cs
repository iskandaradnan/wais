using CP.UETrack.Model;
using System.Collections.Generic;

namespace CP.UETrack.DAL.DataAccess
{
    public interface IPPMLoadBalancingDAL
    {
        PPMLoadBalancingLovs Load();
        PPMLoadBalancing GetWorkOrderDetails(PPMLoadBalancingFetch loadBalancingFetch);
        List<PPMLoadBalancingWorkOrder> GetWorkOrders(PPMLoadBalancingWorkOrder SearchObject);
        PPMLoadBalancingWorkOrders Save(PPMLoadBalancingWorkOrders pPMLoadBalancing, out string ErrorMessage);
       
    }
}