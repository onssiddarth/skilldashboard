using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace SkillsDashboard.BusinessEntities
{
    public class ImproveSkillsBE
    {
        public ImproveSkillsBE()
        {
            this.UserSkill = new SkillsBE();
            this.UserSubskills = new SubSkillBECollection();
        }

        public SkillsBE UserSkill { get; set; }

        public SubSkillBECollection UserSubskills { get; set; }

        public string Comments { get; set; }

        public string Mode { get; set; }

        public string FileUploadGUID { get; set; }

        public string FileUploadName { get; set; }
    }
}