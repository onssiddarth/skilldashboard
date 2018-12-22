using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace SkillsDashboard.Models
{
    public class Skills
    {
        [Required(ErrorMessage = "Please select a skill")]
        public int SkillID { get; set; }

        public string SkillName { get; set; }
    }
}