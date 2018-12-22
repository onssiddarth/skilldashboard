using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace SkillsDashboard.Models
{
    public class PendingSkillExpertApprovals
    {
        public string RequestType { get; set; }

        public string Status { get; set; }

        public string ManagerComments { get; set; }

        public DateTime RequestedDate { get; set; }

        public string SkillName { get; set; }

        public string SubSkillName { get; set; }

        public string FileGUID { get; set; }

        public string FileName { get; set; }

        public int UniqueID { get; set; }

        public int SkillPoints { get; set; }

        public string RequestedBy { get; set; }

        public string UserComments { get; set; }

        public string SkillExpertComments { get; set; }

        public string Room { get; set; }

        public DateTime? DemoSchedule { get; set; }

        public string RequestCode { get; set; }
    }

    public class PendingSkillExpertApprovalsCollection: List<PendingSkillExpertApprovals>
    {

    }
}