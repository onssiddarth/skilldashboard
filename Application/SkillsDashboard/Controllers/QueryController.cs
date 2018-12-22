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

namespace SkillsDashboard.Controllers
{
    public class QueryController : SkillsDashboardBaseController
    {
        #region Page level declarations
        HttpClient client;
        string apiBaseURL = ConfigurationManager.AppSettings["APIBaseURL"];
        #endregion

        public QueryController()
        {
            client = new HttpClient();
            client.BaseAddress = new Uri(apiBaseURL);
            client.DefaultRequestHeaders.Accept.Clear();
            client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
        }

        public async Task<ActionResult> Index()
        {
            #region Declarations
            Query l_Query = new Query();
            #endregion

            var l_Skills = await GetAllSkills();
            ViewBag.SkillList = new SelectList(l_Skills, "SkillID", "SkillName");

            return View("Query", l_Query);
        }

        [HttpPost]
        public async Task<JsonResult> GetSubskills(int argSkillID)
        {
            #region Declarations
            SubSkillBECollection l_SubSkills = new SubSkillBECollection();
            SubSkillCollection l_SubskillCollection = new SubSkillCollection();
            #endregion

            l_SubSkills = await GetSubskillsForSkill(argSkillID);

            if (l_SubSkills != null && l_SubSkills.Count > 0)
            {
                l_SubskillCollection = ConvertSubskillCollectionToModel(l_SubSkills);
            }

            return Json(l_SubskillCollection, JsonRequestBehavior.AllowGet);
        }

        [HttpPost]
        public async Task<ActionResult> GetQueryResults(int argSkillID, int argSubSkillID)
        {
            #region Declarations
            Query l_Query = new Query();
            QueryCollection l_QueryCollection = new QueryCollection();
            QueryBECollection l_QueryBECollection = new QueryBECollection();
            string l_QueryURL = string.Empty;
            #endregion


            l_QueryURL = apiBaseURL + "/GetQueryResults?argLoggedInUser=" + GetLoggedInUserID() + "&argSkillID=" + argSkillID + "&argSubSkillID=" + argSubSkillID;
            HttpResponseMessage l_QueryData = await client.GetAsync(l_QueryURL);

            if (l_QueryData != null && l_QueryData.IsSuccessStatusCode)
            {
                var l_QueryResponse = l_QueryData.Content.ReadAsStringAsync().Result;
                l_QueryBECollection = JsonConvert.DeserializeObject<QueryBECollection>(l_QueryResponse);
            }

            l_QueryCollection = ConvertUserRequestsToModel(l_QueryBECollection);
            return PartialView("_partialGetQueryResults", l_QueryCollection);
        }

        private QueryCollection ConvertUserRequestsToModel(QueryBECollection argQueryBECollection)
        {
            QueryCollection l_QueryCollection = new QueryCollection();
            Query l_Query;
            try
            {
                if (argQueryBECollection != null && argQueryBECollection.Count > 0)
                {
                    foreach (var item in argQueryBECollection)
                    {
                        l_Query = new Query();
                        l_Query.Name = item.Name;
                        l_Query.Email = item.Email;
                        l_Query.ContactNumber = item.ContactNumber;
                        l_Query.SkillPoints = item.SkillPoints;

                        l_QueryCollection.Add(l_Query);
                    }
                }
            }
            catch (Exception ex)
            {

                throw ex;
            }

            return l_QueryCollection;
        }
    }
}