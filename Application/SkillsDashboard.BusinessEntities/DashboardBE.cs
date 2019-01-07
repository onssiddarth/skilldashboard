using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace SkillsDashboard.BusinessEntities
{
    public class DashboardBE: BaseBusinessEntity
    {
        public DashboardBE()
        {
            this.ScheduleDemoBECollection = new ScheduleDemoBECollection();
            this.BadgeBECollection = new BadgeBECollection();
            this.SkillsBECollection = new SkillsBECollection();
        }

        public int UserID { get; set; }

        public string UserName { get; set; }

        public string EmailID { get; set; }

        public bool InitialSkillExists { get; set; }

        public SkillsBECollection SkillsBECollection { get; set; }

        public BadgeBECollection BadgeBECollection { get; set; }

        public ScheduleDemoBECollection ScheduleDemoBECollection { get; set; }
    }
}