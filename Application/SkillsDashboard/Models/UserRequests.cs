using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace SkillsDashboard.Models
{
    public class UserRequests
    {
        public string RequestType { get; set; }

        public string Status { get; set; }

        public string Comments { get; set; }

        public DateTime RequestedDate { get; set; }

        public string Skill { get; set; }

        public string SubSkill { get; set; }

        public int BadgeID { get; set; }

        public string BadgeName { get; set; }

        public string BadgeImageURL { get; set; }

        public string BadgeGivenFor { get; set; }
    }

    public class UserRequestsCollection : List<UserRequests>
    {

    }
}