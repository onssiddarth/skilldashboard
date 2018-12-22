using SkillsDashboard.BusinessEntities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Text;
using System.Threading.Tasks;

namespace SkillsDashboard.Interfaces
{
    interface ISkill
    {
        Task<SkillsBECollection> GetAllSkills();

        Task<SubSkillBECollection> GetSubskillsForSkill(int argSkillID);
    }
}
