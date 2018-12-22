using System;
using System.Collections.Generic;
using System.ComponentModel.DataAnnotations;
using System.Linq;
using System.Web;

namespace SkillsDashboard.Models
{
    public class ImproveSkills
    {
        public ImproveSkills()
        {
            this.UserSkill = new Skills();
            this.SubskillCollection = new SubSkillCollection();
        }

        [Required]
        public string Mode { get; set; }

        [Required(ErrorMessage = "Please enter comments")]
        [StringLength(250, ErrorMessage = "Comments cannot be more than 250 characters")]
        public string Comments { get; set; }

        public Skills UserSkill { get; set; }

        public SubSkillCollection SubskillCollection { get; set; }

        [ValidateFile]
        public HttpPostedFileBase File { get; set; }
    }

    public class ValidateFileAttribute : ValidationAttribute
    {
        protected override ValidationResult IsValid(object value, ValidationContext validationContext)
        {
            //Max file size allowed is 3 MB
            int MaxSizeAllowed = 1024 * 1024 * 3;

            //Extensions allowed are "JPG,GIF,PNG and PDF"
            string[] AllowedExtensions = new string[] { ".jpg", ".gif", ".png", ".pdf" };

            //Get the file
            var file = value as HttpPostedFileBase;


            if (validationContext != null && validationContext.ObjectInstance != null)
            {
                //All model propertis are present in this object
                var l_SkillModel = (ImproveSkills)validationContext.ObjectInstance;

                //Apply required check only if mode selected is upload
                if (l_SkillModel != null && l_SkillModel.Mode != null && l_SkillModel.Mode.ToUpper() == "CERTIFICATE")
                {
                    if (file == null)
                        return new ValidationResult("Please upload a file");
                    else if (!AllowedExtensions.Contains(file.FileName.Substring(file.FileName.LastIndexOf('.'))))
                    {
                        ErrorMessage = "Please upload file of type: " + string.Join(", ", AllowedExtensions);
                        return new ValidationResult(ErrorMessage);
                    }
                    else if (file.ContentLength > MaxSizeAllowed)
                    {
                        ErrorMessage = "Max allowed size is : " + (MaxSizeAllowed / 1024).ToString() + "MB";
                        return new ValidationResult(ErrorMessage);
                    }
                    else
                        return ValidationResult.Success;
                }
            }
            return ValidationResult.Success;

        }
    }
}