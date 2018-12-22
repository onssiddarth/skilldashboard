using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace SkillsDashboard.Models
{
    public class UserInitialSkillRequest
    {
        public UserInitialSkillRequest()
        {
            this.UserSkill = new Skills();
            this.SubskillCollection = new SubSkillCollection();
        }

        public Skills UserSkill { get; set; }

        public SubSkillCollection SubskillCollection { get; set; }

        [Required(ErrorMessage = "Please enter comments")]
        [StringLength(250,ErrorMessage = "Comments cannot be more than 250 characters")]
        public string Comments { get; set; }
    }
}