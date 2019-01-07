using Newtonsoft.Json;
using SkillsDashboard.BusinessEntities;
using SkillsDashboard.Models;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Threading.Tasks;
using System.Web;
using System.Web.Mvc;
using static SkillsDashboard.Utilities.SkillConstants;

namespace SkillsDashboard.Controllers
{
    [Authorize]
    public class UserRequestsController : SkillsDashboardBaseController
    {
        #region Page level declarations
        HttpClient client;
        string apiBaseURL = ConfigurationManager.AppSettings["APIBaseURL"];
        #endregion

        public UserRequestsController()
        {
            client = new HttpClient();
            client.BaseAddress = new Uri(apiBaseURL);
            client.DefaultRequestHeaders.Accept.Clear();
            client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
        }

        /// <summary>
        /// Main view to load Track Requests page
        /// </summary>
        /// <returns></returns>
        public ActionResult Index()
        {
            PopulateDropdownValues();
            return View();
        }

        /// <summary>
        /// This method is used to populate dropdown values for request Type
        /// </summary>
        private void PopulateDropdownValues()
        {
            try
            {
                //Populate request mode
                var RequestMode = GetRequestTypes(true);
                ViewBag.RequestModeList = new SelectList(RequestMode, "ID", "Name");
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        /// <summary>
        /// API call to get user requests
        /// </summary>
        /// <param name="argRequestType">Request Type</param>
        /// <returns></returns>
        [HttpPost]
        public async Task<ActionResult> GetUserRequests(string argRequestType)
        {
            #region Declarations
            UserRequests l_UserRequests = new UserRequests();
            UserRequestsBECollection l_UserRequestsBECollection = new UserRequestsBECollection();
            UserRequestsCollection l_UserRequestsCollection = new UserRequestsCollection();
            string l_skillsURL = string.Empty;
            #endregion

            l_skillsURL = apiBaseURL + "/GetUserRequests?argLoggedInUser=" + GetLoggedInUserID() + "&argType=" + argRequestType + "";
            HttpResponseMessage l_SkillsData = await client.GetAsync(l_skillsURL);

            if (l_SkillsData != null && l_SkillsData.IsSuccessStatusCode)
            {
                var l_SkillResponse = l_SkillsData.Content.ReadAsStringAsync().Result;
                l_UserRequestsBECollection = JsonConvert.DeserializeObject<UserRequestsBECollection>(l_SkillResponse);
            }

            l_UserRequestsCollection = ConvertUserRequestsToModel(l_UserRequestsBECollection);
            return PartialView("_partialGetUserRequests", l_UserRequestsCollection);
        }

        /// <summary>
        /// Method to convert UserRequests business entity to Model
        /// </summary>
        /// <param name="argUserRequestsBECollection">UserRequests Business Entity</param>
        /// <returns></returns>
        private UserRequestsCollection ConvertUserRequestsToModel(UserRequestsBECollection argUserRequestsBECollection)
        {
            UserRequestsCollection l_UserRequestsCollection = new UserRequestsCollection();
            UserRequests l_Requests;
            try
            {
                if(argUserRequestsBECollection!=null && argUserRequestsBECollection.Count > 0)
                {
                    foreach (var item in argUserRequestsBECollection)
                    {
                        l_Requests = new UserRequests();
                        l_Requests.Comments = item.Comments;
                        l_Requests.Status = item.Status;
                        l_Requests.RequestedDate = item.RequestedDate;
                        l_Requests.RequestType = item.RequestType;
                        l_Requests.Skill = item.Skill;
                        l_Requests.SubSkill = item.SubSkill;

                        l_Requests.BadgeID = item.BadgeID;
                        l_Requests.BadgeGivenFor = item.BadgeGivenFor;

                        l_UserRequestsCollection.Add(l_Requests);
                    }
                }
            }
            catch (Exception ex)
            {

                throw ex;
            }

            return l_UserRequestsCollection;
        }
    }
}