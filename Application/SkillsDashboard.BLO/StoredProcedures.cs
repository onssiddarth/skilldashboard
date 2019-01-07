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
        public const string SAVE_INITIALSKILLREQUEST = "usp_sav_EmployeeInitialRequest";
        public const string SAVE_IMPROVESKILLS = "usp_sav_ImproveSkills";
        public const string GET_ALLSKILLREQUESTS = "usp_getEmployeeRequests";
        public const string GET_ALLPENDINGMANAGERAPPROVALS = "usp_getPendingManagerApprovals";
        public const string SAVE_MANAGERACTION = "usp_savManagerApprovals";
        public const string GET_ALLPENDINGSKILLEXPERTAPPROVALS = "usp_getPendingSkillExpertApprovals";
        public const string SAVE_SKILLEXPERTACTION = "usp_savSkillExpertApprovals";
        public const string SAVE_SCHEDULEDEMO = "usp_sav_DemoScheduleBySkillExpert"; 
        public const string GET_EMPLOYEESFORASKILLSUBSKILL = "usp_getEmployeesForASkillSubskill";
        public const string GET_ALLUSERSBYNAME = "usp_getAllUsersByName";
        public const string GET_ALLBADGES = "usp_getAllBadges";
        public const string SAVE_USERBADGE = "usp_savBadge";
        public const string SAVE_APPROVEBADGE = "usp_savApproveBadge";
        public const string GET_DASHBOARDDETAILS = "usp_getDashboardDetails";
        public const string SAV_SYNCUSERREQUIREDPOINTS = "usp_syncEmployeeRequiredPoints";
    }
}