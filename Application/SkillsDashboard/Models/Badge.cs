using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace SkillsDashboard.Models
{
    public class Badge
    {
        public int BadgeID { get; set; }

        public string BadgeName { get; set; }

        public string BadgeURL { get; set; }

        public int BadgeCount { get; set; }
    }

    public class BadgeCollection: List<Badge>
    {

    }
}