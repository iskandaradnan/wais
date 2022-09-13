using System;
using System.Threading.Tasks;
using System.Collections.ObjectModel;

namespace CP.UETrack.Application.Web.ViewModel
{

    public class TaskInstance
    {
       

        public int Id
        {
            get;
            set;
        }
        public string LastComment
        {
            get;
            set;
        }

        public int AllowedActions
        {
            get;
            set;
        }

        public int TaskTypeId
        {
            get;
            set;
        }


        public int WorkflowTypeId
        {
            get;
            set;
        }

        public string FilterCondition
        {
            get;
            set;
        }
        public int UserId
        {
            get;
            set;
        }

        public string UserName
        {
            get;
            set;
        }
        public string Name
        {
            get;
            set;
        }

        public string Description
        {
            get;
            set;
        }

        public string ErrorMessage
        {
            get;
            set;
        }

        public DateTime StartDate
        {
            get;
            set;
        }

        public DateTime EndDate
        {
            get;
            set;
        }

        public TaskStatus Status
        {
            get;
            set;
        }

        public string StatusDesc
        {
            get;
            set;
        }

        public int EscalationLevel
        {
            get;
            set;
        }

        public int AgedDays
        {
            get;
            set;
        }

        public string Age
        {
            get;
            set;
        }

        public DateTime CompletionDate
        {
            get;
            set;
        }

        public string StaffName
        {
            get;
            set;
        }

        public DateTime AssignedOn
        {
            get;
            set;
        }

        public DateTime AssignedToUser
        {
            get;
            set;
        }

        public string BaseURL
        {
            get;
            set;
        }

        public string ParsedURL
        {
            get;
            set;
        }

        public Collection<TaskParameter> Parameters
        {
            get;
            set;
        }

        public bool OpenInModalDialog
        {
            get;
            set;
        }
        public bool OpenInNewWindow
        {
            get;
            set;
        }
        public bool IsAssignedToRole
        {
            get;
            set;
        }

        public void UpdateOtherDetails()
        {
            string queryStrings = string.Empty;
            BaseURL = BaseURL.ToLower();
            FilterCondition = FilterCondition.ToLower();
            BaseURL = BaseURL.Replace("[taskinstanceid]", Id.ToString());
            try
            {
                BaseURL = BaseURL.Replace("{user_id}", System.Web.HttpContext.Current.Session["UserNTId"].ToString());
            }
            catch { }

            foreach (TaskParameter param in Parameters)
            {
                BaseURL = BaseURL.Replace("[" + param.ParamName.ToLower() + "]", param.ParamValue);

                FilterCondition = FilterCondition.Replace("[" + param.ParamName.ToLower() + "]", param.ParamValue);

                if (param.ParamName.ToLower() == "claimant_surname" && param.ParamValue.Trim() == string.Empty)
                    Description = Description.Replace("[" + param.ParamName.ToLower() + "]", "$$$");
                else
                    Description = Description.Replace("[" + param.ParamName.ToLower() + "]", param.ParamValue);
            }

            Description = Description.Replace("vs $$$", "");
            Description = Description.Replace("$$$", "");
            ParsedURL = BaseURL;
        }

        public bool IsInstanceParameterExist(string ParmName)
        {

            return true;
            //Collection<TaskParameter> additionalParams = ThirdPartyApplicationUtility.GetAdditionalParameters(this.Id);
            //TaskParameter param = additionalParams.Where(x => x.ParamName.Equals(ParmName)).FirstOrDefault();
            //return param != null;
        }
    }
}
