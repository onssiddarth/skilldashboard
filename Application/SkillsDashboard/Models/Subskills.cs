using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace SkillsDashboard.Models
{
    public class Subskills
    {
        public int SubSkillID { get; set; }

        public int SkillID { get; set; }

        public string SubSkillName { get; set; }

        public int SkillPoints { get; set; }

        public bool IsSelected { get; set; }

        public bool IsActive { get; set; }

        public string SubSkillType { get; set; }

        public string SkillName { get; set; }
    }

    public class SubSkillCollection : List<Subskills>
    {

    }
}