using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;
using System.Web.Mvc;


namespace CP.UETrack.Model
{

    [Bind(Exclude = "ID")]
    public class UserRegisterModel
    {



        public int ID { get; set; }


        public string FirstName { get; set; }


        public string LastName { get; set; }


        public string Email { get; set; }

        public string Mobile { get; set; }

    }
}
