using CP.Framework.Common.Audit;
using CP.Framework.Common.Logging;
using CP.UETrack.Application.Web.API;
using CP.UETrack.Model.BEMS;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net.Http;
using System.Threading.Tasks;
using System.Web;
using System.Web.Http;
using UETrack.Application.Web.Helpers;

namespace UETrack.Application.Web.API.BEMS
{    
        [RoutePrefix("api/MonthlyStockRegister")]
        [WebApiAudit]
        public class MonthlyStockRegisterAPIController : BaseApiController
        {
            private readonly string _FileName = nameof(MonthlyStockRegisterAPIController);

        [HttpGet(nameof(Load))]
        public async Task<HttpResponseMessage> Load()
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
            var result = await RestHelper.ApiGet("MonthlyStockRegister/Load");
            Log4NetLogger.LogEntry(_FileName, nameof(Load), Level.Info.ToString());
            return result;
        }

        [HttpPost(nameof(Get))]
        public async Task<HttpResponseMessage> Get(MonthlyStockRegisterModel MonthlyStock)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
            var result = await RestHelper.ApiPost("MonthlyStockRegister/Get", MonthlyStock);
            Log4NetLogger.LogEntry(_FileName, nameof(Get), Level.Info.ToString());
            return result;
        }

        [HttpPost(nameof(GetModal))]
        public async Task<HttpResponseMessage> GetModal(ItemMonthlyStockRegisterModal MonthlyReg)
        {
            Log4NetLogger.LogEntry(_FileName, nameof(GetModal), Level.Info.ToString());
            var result = await RestHelper.ApiPost("MonthlyStockRegister/GetModal", MonthlyReg);
            Log4NetLogger.LogEntry(_FileName, nameof(GetModal), Level.Info.ToString());
            return result;
        }

        [HttpPost(nameof(Save))]
        public async Task<HttpResponseMessage> Save(MonthlyStockRegisterModel MonthlyStock)
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());
                var result = await RestHelper.ApiPost("MonthlyStockRegister/Save", MonthlyStock);
                Log4NetLogger.LogEntry(_FileName, nameof(Save), Level.Info.ToString());
                return result;
            }

        [HttpGet(nameof(GetAll))]
        public async Task<HttpResponseMessage> GetAll()
            {
                Log4NetLogger.LogEntry(_FileName, nameof(GetAll), Level.Info.ToString());
                var filterData = GetQueryFiltersForGetAll();
                var result = await RestHelper.ApiGet(string.Format("MonthlyStockRegister/GetAll?{0}", filterData));
                Log4NetLogger.LogEntry(_FileName, nameof(GetAll), Level.Info.ToString());
                return result;
            }        

        [HttpGet("Delete/{Id}")]
        public async Task<HttpResponseMessage> Delete(int Id)
            {
                Log4NetLogger.LogEntry(_FileName, nameof(Delete), Level.Info.ToString());
                var result = await RestHelper.ApiGet(string.Format("MonthlyStockRegister/Delete/{0}", Id));
                Log4NetLogger.LogEntry(_FileName, nameof(Delete), Level.Info.ToString());
                return result;
            }

        }
    }
