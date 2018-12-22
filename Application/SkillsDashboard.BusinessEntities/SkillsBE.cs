using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace SkillsDashboard.BusinessEntities
{
    public class SkillsBE : BaseBusinessEntity
    {
        public int SkillID { get; set; }
        public string SkillName { get; set; }
    }

    public class SkillsBECollection: List<SkillsBE>
    {

    }
}