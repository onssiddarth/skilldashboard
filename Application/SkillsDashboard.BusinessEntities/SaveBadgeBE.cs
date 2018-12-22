using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace SkillsDashboard.BusinessEntities
{
    public class SaveBadgeBE
    {
        public string Type { get; set; }

        public string Comments { get; set; }

        public int BadgeGivenTo { get; set; }

        public int BadgeID { get; set; }

        public int UserBadgeID { get; set; }

        public string Status { get; set; }
    }
}