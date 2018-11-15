using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace SkillsDashboard.BusinessEntities
{
    public class Skill: BaseBusinessEntity
    {
        public int SkillID { get; set; }
        public string SkillName { get; set; }
    }

    public class SkillCollection: List<Skill>
    {

    }
}