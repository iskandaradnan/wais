using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Web.Http.ModelBinding;

namespace UETrack.Application.Web.App_Start
{
    public class CustomModelBinderProvider : ModelBinderProvider
    {
        public override IModelBinder GetBinder(System.Web.Http.HttpConfiguration configuration, Type modelType)
        {
            return new ModelBinder();
        }
    }
}
