using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace SkillsDashboard.BusinessEntities
{
    public class BadgeBE
    {
        public int BadgeID { get; set; }

        public string BadgeName { get; set; }

        public string BadgeURL { get; set; }
    }

    public class BadgeBECollection:List<BadgeBE>
    {

    }
}