using CP.Framework.Common.Audit;
using CP.UETrack.Application.Web.API;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace UETrack.Application.Web.API.API.VM
{
    [RoutePrefix("api/SummaryReports")]
    [WebApiAudit]
    public class SummaryReportonVariationsAPIController : BaseApiController
    {
    }
}
