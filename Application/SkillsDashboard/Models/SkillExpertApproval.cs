using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace SkillsDashboard.Models
{
    public class SkillExpertApproval
    {
        public int UniqueID { get; set; }

        public string Comments { get; set; }

        public string Status { get; set; }

        public string Type { get; set; }
    }
}