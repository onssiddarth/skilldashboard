using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace SkillsDashboard.BusinessEntities
{
    public class SkillsBE : BaseBusinessEntity
    {
        public SkillsBE()
        {
            this.SubSkillBECollection = new SubSkillBECollection();
        }
        public int SkillID { get; set; }

        public string SkillName { get; set; }

        public string SkillType { get; set; }

        public int SkillPoints { get; set; }

        public SubSkillBECollection SubSkillBECollection { get; set; }
    }

    public class SkillsBECollection: List<SkillsBE>
    {

    }
}