using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using CP.UETrack.Model;

namespace CP.UETrack.BLL.BusinessAccess.Contracts.CLS
{
    public interface ICLSFetchBAL
    {
        List<UserLocationCodeSearch> LocationCodeFetch(UserLocationCodeSearch SearchObject);
    }
}
