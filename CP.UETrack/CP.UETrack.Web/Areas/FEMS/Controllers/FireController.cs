using CP.Framework.Common.Audit;
using System.Web.Mvc;
using CP.UETrack.Application.Web.Filter;
using UETrack.Application.Web.Helpers;
using System.Configuration;
using System.IO;
using System.Collections;
using System.Collections.Generic;
using Newtonsoft.Json;
using CP.UETrack.Model;
using System.Threading.Tasks;
using System.Linq;
using CP.UETrack.Model.Home;
using System;
using CP.Framework.Common.StateManagement;
using CP.UETrack.Model;


namespace UETrack.Application.Web.Areas.FEMS.Controllers
{
    [WebAudit]
    [AuthenicationAction]
    public class FireController : Controller
    {
        readonly ISessionProvider _sessionProvider = SessionProviderFactory.GetSessionProvider();

        public ActionResult Index()
        {
            var userDetail = ((UserDetailsModel)_sessionProvider.Get(nameof(UserDetailsModel)));
            userDetail.UserDB = 2;
            _sessionProvider.Set(nameof(UserDetailsModel), userDetail);
            //return View("~/Views/home/dashboard.cshtml");
            //var listdata = new List<permissionChart>();
            //var UserId = 0;
            //var FacilityId = 0;

            //var level = "Month to Date";

            //var Startmonth = System.DateTime.Now.Month;
            //var Startyear = System.DateTime.Now.Year;
            //var Endmonth = System.DateTime.Now.Month;
            //var EndYear = System.DateTime.Now.Year;
            //ViewBag.StartMonth = Startmonth;
            //ViewBag.Startyear = Startyear;
            //ViewBag.Endmonth = Endmonth;
            //ViewBag.EndYear = EndYear;
            //ViewBag.SelLevel = level;
            //listdata = Getdata(UserId, FacilityId).Result;
            //return View("~/Views/home/dashboard.cshtml", listdata);
            //return View("~/Views/home/index.cshtml");

            List<permissionChart> listdata = new List<permissionChart>();
            var UserId = 0;
            var FacilityId = 0;

            var level = "Month to Date";

            var Startmonth = System.DateTime.Now.Month;
            var Startyear = System.DateTime.Now.Year;
            var Endmonth = System.DateTime.Now.Month;
            var EndYear = System.DateTime.Now.Year;
            ViewBag.StartMonth = Startmonth;
            ViewBag.Startyear = Startyear;
            ViewBag.Endmonth = Endmonth;
            ViewBag.EndYear = EndYear;
            ViewBag.SelLevel = level;
            listdata = Getdata(UserId, FacilityId).Result;
            return View(listdata);
        }
        public List<permission> CompleteList;
        //public async Task<List<permission>> GetAllMenuItemsByUserAndService(int UserId, int FacilityId)
        //{
        //    var _result = new List<permission>();
        //    _result = null;

        //    if (_result == null)
        //    {
        //        var result = await RestHelper.ApiGet(string.Format("Dashboard/DashboardPermission/{0}/{1}", UserId, FacilityId));

        //        if (result.StatusCode == System.Net.HttpStatusCode.OK)
        //        {
        //            var jsonString = await result.Content.ReadAsStringAsync();
        //            _result = JsonConvert.DeserializeObject<List<permission>>(jsonString);
        //        }
        //    }
        //    if (_result != null)
        //    {
        //        CompleteList = _result.ToList();
        //        return CompleteList;
        //    }
        //    else return CompleteList;
        //}

        private static async Task<List<permissionChart>> Getdata(int UserId, int FacilityId)
        {
            //  List<permissionChart> listdata = new List<permissionChart>();  
            var result = await RestHelper.ApiGet(string.Format("Dashboard/DashboardPermission/{0}/{1}", UserId, FacilityId));
            var jsonString = await result.Content.ReadAsStringAsync();
            var data = JsonConvert.DeserializeObject<permission>(jsonString);
            return data.permissionChartData;
        }


        public ActionResult DashBoard()
        {
            List<permissionChart> listdata = new List<permissionChart>();
            var UserId = 0;
            var FacilityId = 0;

            var level = "Month to Date";

            var Startmonth = System.DateTime.Now.Month;
            var Startyear = System.DateTime.Now.Year;
            var Endmonth = System.DateTime.Now.Month;
            var EndYear = System.DateTime.Now.Year;
            ViewBag.StartMonth = Startmonth;
            ViewBag.Startyear = Startyear;
            ViewBag.Endmonth = Endmonth;
            ViewBag.EndYear = EndYear;
            ViewBag.SelLevel = level;
            listdata = Getdata(UserId, FacilityId).Result;
            return View(listdata);
        }

        public ActionResult DashBoardYtd()
        {
            var listdata = new List<permissionChart>();
            var UserId = 0;
            var FacilityId = 0;
            var level = "Year to Date";
            var Startmonth = 1;
            var Startyear = System.DateTime.Now.Year;
            var Endmonth = System.DateTime.Now.Month;
            var EndYear = System.DateTime.Now.Year;
            ViewBag.StartMonth = Startmonth;
            ViewBag.Startyear = Startyear;
            ViewBag.Endmonth = Endmonth;
            ViewBag.EndYear = EndYear;
            ViewBag.SelLevel = level;
            listdata = Getdata(UserId, FacilityId).Result;
            // return View(listdata);
            return View(nameof(DashBoard), listdata);
        }

        //public ActionResult DownloadManual(string FileName)
        //{
        //    var pathLocation = ConfigurationManager.AppSettings["ManualDownloadPath"];
        //    if (!Directory.Exists(pathLocation))
        //        Directory.CreateDirectory(pathLocation);
        //    var finalpath = Path.Combine(pathLocation, FileName);
        //    var st = "application/pdf";
        //    var fileex = new FileInfo(finalpath);
        //    var c = '\\';
        //    var fileSplit = FileName.Split(c);
        //    if (fileSplit.Length > 1)
        //    {
        //        FileName = fileSplit[1];
        //    }
        //    if (FileName.Contains("apk"))
        //    {
        //        st = "application/apk";
        //    }
        //    if (fileex.Exists)
        //    {
        //        return File(finalpath, st, FileName);
        //    }
        //    else
        //    {
        //        return Content("Invalid File....", "text/plain");
        //    }

        //}

        // [AllowAnonymous]
        //public ActionResult About()
        //{
        //    var aboutInfo = "<HTML><div class='container - main text - center'><div style='display:inline-block;margin:0 0 0 0;' class='page_title'> <h3><i class='fa fa-hospital-o'></i> About UETrack</h3></div><div class='text-center'>";
        //    aboutInfo += @"<div style='display: inline - block; margin: 30px auto 0;'><table class='table table-bordered table - responsive text - center' ><tr><td>Web Revision Info: </td><td>" + CP.UETrack.CodeLib.Helpers.HtmlHelper.GetSvnInfo() + "</td>";
        //    aboutInfo += "</tr>";
        //    aboutInfo += @"<tr><td>App Revision Info </td><td>" + RestHelper.GetApiSvnInfo().Result.Replace("\"", string.Empty) + "</td>";
        //    aboutInfo += "</tr>";
        //    aboutInfo += "<tr><td>Api Base </td><td>" + @RestHelper.ApiBaseUri.Replace("http://", string.Empty).Replace(".", "**").Replace(":", "#") + "</td>";
        //    aboutInfo += "</tr>";
        //    aboutInfo += "<tr><td>Web Base </td><td>" + @RestHelper.WebBaseUri.Replace("http://", string.Empty).Replace("https://", string.Empty).Replace(".", "**").Replace(":", "#") + "</td>";
        //    aboutInfo += "</tr>";
        //    aboutInfo += "<tr><td> Api Db </td><td> " + @RestHelper.GetDbInfo().Result + "</td>";
        //    aboutInfo += "</tr>";
        //    // aboutInfo += "<tr><td>Concurrent Count</td> <td style='text - align:center;'><div><a data-toggle='modal'  ng-click='LoggedConcurrentPopUp()' id='PopupButton' title='ConcurrentCount'> <label id='LblItem' ng-bind='LoggedConcurrentCount' name='Item' class='btn'></label></a> </div></td></tr>";    //data-target='#TicketPopup'                          
        //    // aboutInfo += "<tr><td>Visited Users Count</td> <td style='text - align:center;'><div><span data-ng-repeat='data in VistorHistory'><a data-toggle='modal'  ng-click='VisitorPopUp(data.Date)' id='PopupButton' title=''> [ {{data.Date}} ] {{data.DateViceCount}} </a> <br></span></div></td></tr>";//data-target='#TicketPopup'
        //    aboutInfo += "</table></div></div></div></HTML>";
        //    ////to pass raw HTML to an MVC helper method
        //    ViewBag.Message = MvcHtmlString.Create(aboutInfo);
        //    return View();
        //}

        //[AllowAnonymous]
        //public ActionResult Contact()
        //{
        //    ViewBag.Message = "Please contact the System Administrator through Email for any issues/queries/suggestions regarding the application!";

        //    return View();
        //}

        [AllowAnonymous]
        public ActionResult Report()
        {
            ViewBag.Message = "Your contact page.";

            return View();
        }
    }
}