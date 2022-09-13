﻿using CP.Framework.Common.Audit;
using CP.Framework.Common.Logging;
using CP.UETrack.Application.Web.API;
using CP.UETrack.Model.CLS;
using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Reflection;
using System.Threading.Tasks;
using System.Web;
using System.Web.Http;
using UETrack.Application.Web.Helpers;

namespace UETrack.Application.Web.Controllers
{
    [RoutePrefix("api/DailyCleaningActivity")]
    [WebApiAudit]
    public class DailyCleaningActivityApiController : BaseApiController
    {
        private readonly string _FileName = nameof(DailyCleaningActivityApiController);

        public DailyCleaningActivityApiController()
        {
        }
        [HttpGet(nameof(Load))]
        public async Task<HttpResponseMessage> Load()
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
            var result = await RestHelper.ApiGet("DailyCleaningActivity/Load");
            Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
            return result;
        }
        [HttpGet(nameof(AutoGeneratedCode))]
        public async Task<HttpResponseMessage> AutoGeneratedCode()
        {
            Log4NetLogger.LogEntry(_FileName, nameof(AutoGeneratedCode), Level.Info.ToString());
            var filterData = GetQueryFiltersForGetAll();
            var result = await RestHelper.ApiGet(string.Format("DailyCleaningActivity/AutoGeneratedCode?{0}", filterData));
            Log4NetLogger.LogEntry(_FileName, nameof(AutoGeneratedCode), Level.Info.ToString());
            return result;
        }
        [HttpPost(nameof(DocFetch))]
        public Task<HttpResponseMessage> DocFetch(DailyCleaningActivity AD)
        {
            Log4NetLogger.LogEntry(GetType().Name, nameof(DocFetch), Level.Info.ToString());
            var result = RestHelper.ApiPost("DailyCleaningActivity/DocFetch", AD);
            Log4NetLogger.LogExit(GetType().Name, nameof(DocFetch), Level.Info.ToString());
            return result;
        }
        [HttpPost(nameof(Save))]
        public async Task<HttpResponseMessage> Save(HttpRequestMessage request, [FromBody] DailyCleaningActivity dailyCleaningActivity)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());
            var result = await RestHelper.ApiPost("DailyCleaningActivity/Save", dailyCleaningActivity);
            Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());
            return result;
        }

        [HttpGet(nameof(GetAll))]
        public async Task<HttpResponseMessage> GetAll()
        {
            Log4NetLogger.LogEntry(_FileName, nameof(GetAll), Level.Info.ToString());
            var filterData = GetQueryFiltersForGetAll();
            var result = await RestHelper.ApiGet(string.Format("DailyCleaningActivity/GetAll?{0}", filterData));
            Log4NetLogger.LogEntry(_FileName, nameof(GetAll), Level.Info.ToString());
            return result;
        }

        [HttpGet("Get/{Id}")]
        public async Task<HttpResponseMessage> Get(int Id)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
            var result = await RestHelper.ApiGet(string.Format("DailyCleaningActivity/Get/{0}", Id));
            Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
            return result;
        }       
    }
}