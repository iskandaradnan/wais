using System.Web;
using System.Web.Optimization;

namespace UETrack.Application.Web
{
    public class BundleConfig
    {
        public static void RegisterBundles(BundleCollection bundles)
        {
            bundles.Add(new StyleBundle("~/Content/css").Include(
                      "~/Content/site.css",
                      "~/Content/bootstrap-datetimepicker.min.css",
                       "~/js/datetimepicker-master/jquery.datetimepicker.css",
                       "~/css/ui.jqgrid.css",
                      "~/Content/bootstrap-responsive.css"));
            

               bundles.Add(new ScriptBundle("~/all/jstop").Include(
                 "~/js/jquery-3.3.1.min.js",
                 "~/Scripts/moment.js",
                 "~/Scripts/angular.js",
                 "~/Scripts/i18n/grid.locale-en.js",
                 "~/Scripts/JQGrid/jquery.jqGrid.min.js",
                 "~/Scripts/jquery.globalize/globalize.js",
                 "~/Scripts/bootbox.min.js",
                 "~/Scripts/angular-sanitize.js",
                 "~/Scripts/modernizr-2.6.2.js",
                 "~/Scripts/linq.js",
                "~/Scripts/angular-messages.js",
                "~/Scripts/angular-animate.js",
                "~/Scripts/angular-aria.min.js",
                 "~/Scripts/angular-material.min.js",
                 "~/js/Search/Search.js",
                 "~/js/Fetch/Fetch.js",
                 "~/js/date.js"
                 ));

            bundles.Add(new ScriptBundle("~/all/jsbottom").Include(
                "~/js/bootstrap.js",
                "~/js/enscroll-0.6.0.min.js",
                "~/js/custom.js",
                "~/js/Common/common.js",
                "~/js/Common/TableHeaderPlugin.js",
                "~/js/Jquery-ui.js",
                "~/Scripts/jquery.jBreadCrumb.min.js",
                "~/Scripts/ng/common/page-message.js",
                "~/Scripts/ng/common/js.cookie.js",
               "~/js/Common/bootstrap-multiselect.js",
                "~/js/datetimepicker-master/jquery.datetimepicker.js",
                "~/Scripts/Highcharts/highcharts.js",
                "~/Scripts/Highcharts/variable-pie.js",
                "~/Scripts/Highcharts/no-data-to-display.js",
                "~/Scripts/Highcharts/exporting.js",
                "~/Scripts/Highcharts/offline-exporting.js",
                "~/Scripts/ng/app.js"
                ));
       
            BundleTable.EnableOptimizations = false;
        }
    }
}
