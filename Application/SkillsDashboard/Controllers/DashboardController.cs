using SkillsDashboard.BusinessEntities;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Web;
using System.Web.Mvc;
using SkillsDashboard.Models;
using System.Threading.Tasks;
using Newtonsoft.Json;
using SkillsDashboard.Utilities;
using System.Text;

namespace SkillsDashboard.Controllers
{
    [Authorize]
    public class DashboardController : SkillsDashboardBaseController
    {
        #region Page level declarations
        HttpClient client;
        string apiBaseURL = ConfigurationManager.AppSettings["APIBaseURL"];
        #endregion

        public DashboardController()
        {
            client = new HttpClient();
            client.BaseAddress = new Uri(apiBaseURL);
            client.DefaultRequestHeaders.Accept.Clear();
            client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
        }

        /// <summary>
        /// Action Result method to view dashboard details
        /// </summary>
        /// <param name="argUserID">UserID</param>
        /// <returns></returns>
        public ActionResult Index(int? argUserID)
        {
            int l_UserID = 0;
            try
            {
                if (TempData[SkillConstants.C_INTITIAL_REQUEST_SUCCESS_CONST] != null)
                {
                    ViewBag.SuccessMessage = TempData[SkillConstants.C_INTITIAL_REQUEST_SUCCESS_CONST];
                }

                if (!argUserID.HasValue)
                {
                    l_UserID = GetLoggedInUserID();
                }
                ViewBag.UserID = l_UserID;
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return View();
        }

        /// <summary>
        /// ActionResult method to load dashboard details for a user
        /// </summary>
        /// <param name="argUserID">User ID for whom dashboard details should be loaded</param>
        /// <returns></returns>
        public async Task<ActionResult> GetDashboardDetailsForUser(int argUserID)
        {
            Dashboard l_Dashboard = new Dashboard();
            try
            {
                l_Dashboard = await GetDashboardDetails(argUserID);
            }
            catch (Exception)
            {
                throw;
            }
            return PartialView("_partialDashboardDetails", l_Dashboard);
        }

        /// <summary>
        /// API call to get dashboard details
        /// </summary>
        /// <param name="argUserID">User ID for loading dashboard details</param>
        /// <returns></returns>
        private async Task<Dashboard> GetDashboardDetails(int argUserID)
        {
            #region Declarations
            DashboardBE l_DashboardBE = new DashboardBE();
            Dashboard l_Dashboard = new Dashboard();
            int l_LoggedInUser = 0;
            string l_DashboardURL = string.Empty;
            #endregion

            try
            {
                l_LoggedInUser = GetLoggedInUserID();
                l_DashboardURL = apiBaseURL + "/GetDashboardData?argLoggedInUser=" + l_LoggedInUser+ "&argUserID="+ argUserID;
                HttpResponseMessage l_DashboardData = await client.GetAsync(l_DashboardURL);

                if (l_DashboardData != null && l_DashboardData.IsSuccessStatusCode)
                {
                    var l_DashboardResponse = l_DashboardData.Content.ReadAsStringAsync().Result;
                    l_DashboardBE = JsonConvert.DeserializeObject<DashboardBE>(l_DashboardResponse);
                    l_Dashboard = ConvertDashboardBEDataToModel(l_DashboardBE);
                }

            }
            catch (Exception ex)
            {
                throw ex;
            }
            return l_Dashboard;
        }

        /// <summary>
        /// Convert dashboard business entity to Model
        /// </summary>
        /// <param name="argDashboardBE">Dashboard business Entity</param>
        /// <returns></returns>
        private Dashboard ConvertDashboardBEDataToModel(DashboardBE argDashboardBE)
        {
            #region Declarations
            Dashboard l_Dashboard = new Dashboard();
            SkillCollection l_SkillCollection = new SkillCollection();
            BadgeCollection l_BadgeCollection = new BadgeCollection();
            ScheduleDemoCollection l_ScheduleDemoCollection = new ScheduleDemoCollection();
            Badge l_Badge;
            Skills l_Skills;
            ScheduleDemo l_ScheduleDemo;
            #endregion
            try
            {
                if (argDashboardBE != null)
                {
                    //Get User Details
                    l_Dashboard.UserID = argDashboardBE.UserID;
                    l_Dashboard.UserName = argDashboardBE.UserName;
                    l_Dashboard.EmailID = argDashboardBE.EmailID;
                    l_Dashboard.InitialSkillExists = argDashboardBE.InitialSkillExists;
                    l_Dashboard.DisplayActionItems = argDashboardBE.UserID == GetLoggedInUserID() ? true : false;
                    

                    //Convert Skill and subskill set
                    if (argDashboardBE.SkillsBECollection != null && argDashboardBE.SkillsBECollection.Count > 0)
                    {
                        foreach (var skill in argDashboardBE.SkillsBECollection)
                        {
                            l_Skills = new Skills();
                            l_Skills.SkillID = skill.SkillID;
                            l_Skills.SkillName = skill.SkillName;
                            l_Skills.SkillType = skill.SkillType;
                            l_Skills.SkillPoints = skill.SkillPoints;
                            l_Skills.SubSkillCollection = GetSubskillcollection(skill.SubSkillBECollection);

                            l_SkillCollection.Add(l_Skills);
                        }

                        l_Dashboard.SkillsCollection = l_SkillCollection;

                        
                        l_Dashboard.SkillData = JsonConvert.SerializeObject(l_SkillCollection);
                    }

                    //Convert Badge
                    if (argDashboardBE.BadgeBECollection != null && argDashboardBE.BadgeBECollection.Count > 0)
                    {
                        foreach (var badgeBE in argDashboardBE.BadgeBECollection)
                        {
                            l_Badge = new Badge();
                            l_Badge.BadgeID = badgeBE.BadgeID;
                            l_Badge.BadgeName = badgeBE.BadgeName;
                            l_Badge.BadgeURL = badgeBE.BadgeURL;
                            l_Badge.BadgeCount = badgeBE.BadgeCount;

                            l_BadgeCollection.Add(l_Badge);

                        }

                        l_Dashboard.BadgeCollection = l_BadgeCollection;

                    }

                    //Convert Demo Details
                    if (argDashboardBE.ScheduleDemoBECollection != null && argDashboardBE.ScheduleDemoBECollection.Count > 0)
                    {
                        foreach (var demoBE in argDashboardBE.ScheduleDemoBECollection)
                        {
                            l_ScheduleDemo = new ScheduleDemo();
                            l_ScheduleDemo.DemoSchedule = demoBE.DemoSchedule;
                            l_ScheduleDemo.Comments = demoBE.Comments;
                            l_ScheduleDemo.UniqueID = demoBE.UniqueID;
                            l_ScheduleDemo.Room = demoBE.Room;
                            l_ScheduleDemo.SkillID = demoBE.SkillID;
                            l_ScheduleDemo.SkillName = demoBE.SkillName;
                            l_ScheduleDemo.SubSkillName = demoBE.SubSkillName;
                            l_ScheduleDemo.UserID = demoBE.UserID;
                            l_ScheduleDemo.EventConductedBy = demoBE.EventConductedBy;

                            l_ScheduleDemoCollection.Add(l_ScheduleDemo);
                        }

                        l_Dashboard.ScheduleDemoCollection = l_ScheduleDemoCollection;
                    }
                }
            }
            catch (Exception)
            {
                throw;
            }

            return l_Dashboard;
        }

        /// <summary>
        /// Method to convert subskill model collection from Business Entity
        /// </summary>
        /// <param name="argsubSkillBECollection">Subskill business entity</param>
        /// <returns></returns>
        private SubSkillCollection GetSubskillcollection(SubSkillBECollection argsubSkillBECollection)
        {
            #region Declarations
            SubSkillCollection l_SubSkillCollection = new SubSkillCollection();
            Subskills l_SubSkills;
            #endregion
            try
            {
                if(argsubSkillBECollection!=null && argsubSkillBECollection.Count > 0)
                {
                    foreach (var subskillBE in argsubSkillBECollection)
                    {
                        l_SubSkills = new Subskills();
                        l_SubSkills.SubSkillID = subskillBE.SubSkillID;
                        l_SubSkills.SubSkillName = subskillBE.SubSkillName;
                        l_SubSkills.SkillID = subskillBE.SkillID;
                        l_SubSkills.SkillPoints = subskillBE.SkillPoints;
                        l_SubSkills.SubSkillType = subskillBE.SubSkillType;
                        l_SubSkills.SkillName = subskillBE.SkillName;

                        l_SubSkillCollection.Add(l_SubSkills);
                    }
                    
                }
            }
            catch (Exception)
            {

                throw;
            }

            return l_SubSkillCollection;
        }
    }
}