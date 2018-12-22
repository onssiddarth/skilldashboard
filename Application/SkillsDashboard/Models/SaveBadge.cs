using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace SkillsDashboard.Models
{
    public class SaveBadge
    {
        public string Type { get; set; }

        [Required(ErrorMessage = "Please enter comments")]
        public string Comments { get; set; }

        public int BadgeGivenTo { get; set; }

        public int BadgeID { get; set; }

        public int UserBadgeID { get; set; }

        [Required(ErrorMessage = "Please select an employee")]
        public string BadgeGivenToName { get; set; }

        public string BadgeName { get; set; }

        public string BadgeImageURL { get; set; }

        public string Status { get; set; }
    }
}