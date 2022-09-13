using System;
using System.Collections.Generic;
using System.Data.Entity.Core.Metadata.Edm;
using System.Data.Entity.Core.Objects;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CP.Framework.Common.TransactionManagement
{
    public static class ObjectContextExtensions
    {
        public static EntitySet GetEntitySet(this ObjectContext objectContext, object x)
        {
            //Get the approperiate overload of CreateObjectSet method
            var methodInfo = typeof(ObjectContext).GetMethods()
                             .First(m => m.Name == "CreateObjectSet");

            //Supply the generic type of the method
            var genericMethodInfo = methodInfo.MakeGenericMethod(x.GetType());

            //Invoke the method and get the ObjectSet<?> as an object          


            var set = genericMethodInfo.Invoke(objectContext, new object[] { });

            //Retrieve EntitySet of the set
            var prop = set.GetType().GetProperty("EntitySet");
            var entitySet = (EntitySet)prop.GetValue(set);
            return entitySet;
        }
    }
}
