using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace CP.UETrack.Application.Web.ViewModel
{
    
    public class TaskParameter
    {
        public int TaskTypeId
        {
            get;
            set;
        }

        public string ParamName
        {
            get;
            set;
        }

        public string ParamValue
        {
            get;
            set;
        }

        public bool AddToQueryString
        {
            get;
            set;
        }

        public bool IsMandatory
        {
            get;
            set;
        }

        public bool IsSystemParameter
        {
            get;
            set;
        }

    }
}
