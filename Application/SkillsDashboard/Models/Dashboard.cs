using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace SkillsDashboard.Models
{
    public class Dashboard
    {
        public Dashboard()
        {
            this.ScheduleDemoCollection = new ScheduleDemoCollection();
            this.BadgeCollection = new BadgeCollection();
            this.SkillsCollection = new SkillCollection();
        }

        public int UserID { get; set; }

        public string UserName { get; set; }

        public string EmailID { get; set; }

        public bool InitialSkillExists { get; set; }

        public bool DisplayActionItems { get; set; }

        public SkillCollection SkillsCollection { get; set; }

        public BadgeCollection BadgeCollection { get; set; }

        public ScheduleDemoCollection ScheduleDemoCollection { get; set; }

        public string SkillData { get; set; }
    }
}