using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;

namespace CP.Framework.Common.StateManagement
{
    public interface ISessionProvider
    {
        void Clear(string key);

        object Get(string key);

        void Set(string key, object value);
    }
}
