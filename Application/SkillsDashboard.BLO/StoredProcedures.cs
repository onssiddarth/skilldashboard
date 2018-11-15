using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace SkillsDashboard.BLO
{
    public class StoredProcedures
    {
        public const string GET_TESTUSERS = "usp_getTestUsers";
        public const string INSERT_TESTUSERS = "usp_testAddUser";
        public const string GET_ALLSKILLS_AVAILABLE = "usp_getAllSkillsAvailable";
        public const string GET_ALLSUBSKILLS_FORASKILL = "usp_getAllSubSkillsForASkill";
    }
}