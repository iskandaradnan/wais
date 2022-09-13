using System;
using System.Collections.Generic;
using System.Globalization;
using System.Linq;
using System.Text;
using System.Threading;
using System.Threading.Tasks;
using System.Web.Http.Controllers;
using System.Web.Http.ModelBinding;

namespace UETrack.Application.Web
{
    public class ModelBinder : IModelBinder
    {
        public bool BindModel(HttpActionContext actionContext, ModelBindingContext bindingContext)
        {
           // ValidateBindingContext(bindingContext);

            if (!bindingContext.ValueProvider.ContainsPrefix(bindingContext.ModelName))
            {
                return false;
            }

            bindingContext.Model = bindingContext.ValueProvider
                .GetValue(bindingContext.ModelName)
                .ConvertTo(bindingContext.ModelType, Thread.CurrentThread.CurrentCulture);

            bindingContext.ValidationNode.ValidateAllProperties = true;

            return true;
        }
    }
}
