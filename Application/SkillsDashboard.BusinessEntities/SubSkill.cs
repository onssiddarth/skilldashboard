using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace SkillsDashboard.BusinessEntities
{
    public class SubSkill : BaseBusinessEntity
    {
        public int SubSkillID { get; set; }
        public int SkillID { get; set; }
        public string SubSkillName { get; set; }
        public int SkillPoints { get; set; }
        public bool IsActive { get; set; }
    }

    public class SubSkillCollection : List<SubSkill>
    {

    }
}