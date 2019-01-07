using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace SkillsDashboard.Models
{
    public class ScheduleDemo
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

    public class ScheduleDemoCollection: List<ScheduleDemo>
    {

    }
}