using CP.UETrack.Model;
using System.Collections.Generic;

namespace CP.UETrack.BLL.BusinessAccess.Interface
{
    public interface IPPMLoadBalancingBAL
    {
        PPMLoadBalancingLovs Load();
        PPMLoadBalancing GetWorkOrderDetails(PPMLoadBalancingFetch loadBalancingFetch);
        List<PPMLoadBalancingWorkOrder> GetWorkOrders(PPMLoadBalancingWorkOrder loadBalancingWorkOrder);
        PPMLoadBalancingWorkOrders Save(PPMLoadBalancingWorkOrders pPMLoadBalancing, out string ErrorMessage);
    }
}
