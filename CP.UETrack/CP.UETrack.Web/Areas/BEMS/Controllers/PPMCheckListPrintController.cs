using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace UETrack.Application.Web.Areas.BEMS.Controllers
{
    public class PPMCheckListPrintController : Controller
    {
        // GET: BEMS/PPMCheckListPrint
        public ActionResult Index(int primaryId, int checklistId)
        {
            ViewBag.WOId = primaryId;
            ViewBag.checklistId = checklistId;           
            return View("Detail");
        }
    }
}