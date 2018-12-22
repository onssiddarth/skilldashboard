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
    }
}