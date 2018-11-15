using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace SkillsDashboard.BusinessEntities
{
    public class BadgeMasterBE: BaseBusinessEntity
    {
        public int BadgeID { get; set; }

        public string BadgeName { get; set; }

        public string BadgeImageURL { get; set; }
    }
}