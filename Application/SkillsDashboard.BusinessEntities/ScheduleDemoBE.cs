using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace SkillsDashboard.BusinessEntities
{
    public class ScheduleDemoBE: BaseBusinessEntity
    {
        public DateTime DemoSchedule { get; set; }

        public string Comments { get; set; }

        public int UniqueID { get; set; }

        public string Room { get; set; }

        public int SubSkillID { get; set; }

        public int SkillID { get; set; }

        public string SubSkillName { get; set; }

        public string SkillName { get; set; }

        public int UserID { get; set; }

        public string EventConductedBy { get; set; }
    }

    public class ScheduleDemoBECollection :List<ScheduleDemoBE>
    {

    }
}