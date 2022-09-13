using System.Web.Mvc;

namespace UETrack.Application.Web
{
    public class FilterConfig
    {
        public static void RegisterGlobalFilters(GlobalFilterCollection filters)
        {
            //filters.Add(new HandleErrorAttribute());
            filters.Add(new AuthorizeAttribute());
            filters.Add(new Helpers.ErrorHelper());
            //filters.Add(new ValidateAntiForgeryTokenOnAllPosts());
        }
    }
}
