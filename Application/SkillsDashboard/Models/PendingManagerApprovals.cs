using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace SkillsDashboard.Models
{
    public class PendingManagerApprovals
    {
        public string RequestType { get; set; }

        public string Status { get; set; }

        public string Comments { get; set; }

        public DateTime RequestedDate { get; set; } 

        public string SkillName { get; set; }
            
        public string SubSkillName { get; set; }

        public string FileGUID { get; set; }

        public string FileName { get; set; }

        public int UniqueID { get; set; }

        public int SkillPoints { get; set; }

        public string RequestedBy { get; set; }

        public string RequestCode { get; set; }

        public string BadgeGivenFor { get; set; }

        public int BadgeID { get; set; }

        public string BadgeName { get; set; }

        public string BadgeImageURL { get; set; }
    }

    public class PendingManagerApprovalCollection: List<PendingManagerApprovals>
    {

    }
}