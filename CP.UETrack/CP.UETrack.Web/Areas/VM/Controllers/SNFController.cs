using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace UETrack.Application.Web.Areas.VM.Controllers
{
    public class SNFController : Controller
    {
        // GET: VM/SNF
        public ActionResult Index()
        {
            return View("List");
        }
        public ActionResult Add()
        {
            ViewBag.Id = 0;
            ViewBag.Mode = "ADD";
            return View("Details");
        }
        public ActionResult Edit(int id)
        {
            ViewBag.Id = id;
            ViewBag.Mode = "EDIT";
            return View("Details");
        }
        public ActionResult View(int id)
        {
            ViewBag.Id = id;
            ViewBag.Mode = "VIEW";
            return View("Details");
        }
        public ActionResult Verify(int id)
        {
            ViewBag.Id = id;
            ViewBag.Mode = "VERIFY";
            return View("Details");
        }
        public ActionResult Approved(int id)
        {
            ViewBag.Id = id;
            ViewBag.Mode = "APPROVE";
            return View("Details");
        }
        public ActionResult Reject(int id)
        {
            ViewBag.Id = id;
            ViewBag.Mode = "REJECT";
            return View("Details");
        }
    }
}