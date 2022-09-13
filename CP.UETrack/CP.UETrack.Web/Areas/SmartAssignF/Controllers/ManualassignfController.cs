﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace UETrack.Application.Web.Areas.SmartAssignF.Controllers
{
    public class ManualassignfController : Controller
    {
        // GET: SmartAssign/Manualassign
        public ActionResult List()
        {
            return View();
        }
        public ActionResult Index()
        {
            // return View(nameof(List));
            ViewBag.CurrentID = 0;
            ViewBag.ActionType = nameof(Add);
            return View("Detail");
        }
        public ActionResult Add()
        {

            ViewBag.CurrentID = 0;
            ViewBag.ActionType = "ADD";
            return View("Detail");
        }
        public ActionResult Edit(int Id)
        {
            ViewBag.CurrentID = Id;
            ViewBag.ActionType = "EDIT";
            return View("Detail");
        }
        public ActionResult View(int Id)
        {
            ViewBag.CurrentID = Id;
            ViewBag.ActionType = "VIEW";
            return View("Detail");
        }
    }
}