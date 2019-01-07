using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace SkillsDashboard.Models
{
    public class Skills
    {
        public Skills()
        {
            this.SubSkillCollection = new SubSkillCollection();
        }

        [Required(ErrorMessage = "Please select a skill")]
        public int SkillID { get; set; }

        public string SkillName { get; set; }

        public string SkillType { get; set; }

        public int SkillPoints { get; set; }

        public SubSkillCollection SubSkillCollection { get; set; }
    }

    public class SkillCollection:List<Skills>
    {

    }
}