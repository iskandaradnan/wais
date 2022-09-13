using UETrack.Application.Web.API.Core;
using AutoMapper;
using CP.UETrack.CodeLib.Helpers;
using System;
using System.Web.Http;
using System.Web.Mvc;
using System.Configuration;

namespace UETrack.Application.Web.API
{
    public class WebApiApplication : System.Web.HttpApplication
    {
        protected void Application_Start()
        {
            WebApiConfig.Register(GlobalConfiguration.Configuration);
            FilterConfig.RegisterGlobalFilters(GlobalFilters.Filters);
            Mapper.Initialize(x =>
            {
                x.AddProfile(new CP.UETrack.DAL.AutoMapperConfiguration().MappingProfile);
            });
            GlobalConfiguration.Configuration.EnsureInitialized();
            GlobalConfiguration.Configuration.MessageHandlers.Add(new ApiLogHandler());
            //Application["SearchPopupPageSize"] = ConfigurationManager.AppSettings["SearchPopupPageSize"];
            UETrackLogger.Log("Global.Asax", "AppStart");
        }


        protected void Application_End(object sender, EventArgs e)
        {
            UETrackLogger.Log("Global.Asax", "AppEnd");
        }

    }
}
