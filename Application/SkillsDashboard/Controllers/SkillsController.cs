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
    public class SkillsController : SkillsDashboardBaseController
    {
        #region Page level declarations
        HttpClient client;
        string apiBaseURL = ConfigurationManager.AppSettings["APIBaseURL"];
        #endregion

        public SkillsController()
        {
            client = new HttpClient();
            client.BaseAddress = new Uri(apiBaseURL);
            client.DefaultRequestHeaders.Accept.Clear();
            client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
        }

        public async Task<ActionResult> Index()
        {
            #region Declarations
            UserInitialSkillRequest l_UserInitialSkillRequest = new UserInitialSkillRequest();
            SkillsBECollection l_SkillsBECollection = new SkillsBECollection();
            #endregion

            var l_Skills = await GetAllSkills();
            ViewBag.SkillList = new SelectList(l_Skills, "SkillID", "SkillName");

            return View(l_UserInitialSkillRequest);
        }

        /// <summary>
        /// Post method to save initial request skill data
        /// </summary>
        /// <param name="argSkillRequest"></param>
        /// <returns></returns>
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<ActionResult> SaveIntialSkillRequest(UserInitialSkillRequest argSkillRequest)
        {
            HttpResponseMessage l_Message = new HttpResponseMessage();
            if(ModelState.IsValid)
            {
                if(argSkillRequest!=null && argSkillRequest.SubskillCollection!=null && argSkillRequest.SubskillCollection.Count > 0 && argSkillRequest.SubskillCollection.Exists(x=>x.IsSelected == true))
                {
                    //Remove all subskills which are not selected
                    argSkillRequest.SubskillCollection.RemoveAll(x => x.IsSelected == false);

                    l_Message = await SaveInitialSkills(argSkillRequest);

                    if (l_Message.IsSuccessStatusCode)
                    {
                        TempData[SkillConstants.C_INTITIAL_REQUEST_SUCCESS_CONST] = SkillConstants.C_SUCCESS_CONST;
                        return RedirectToAction("Index", "Dashboard");
                    }
                }
                else
                {
                    ViewBag.SkillErrorMessage = "Please select altleast one subskill to proceed";
                }
               
            }
            //Set skill details in viewbag
            var l_Skills = await GetAllSkills();
            ViewBag.SkillList = new SelectList(l_Skills, "SkillID", "SkillName");
            return View("Index", argSkillRequest);
        }

        /// <summary>
        /// Save Initial skill requests to DB
        /// </summary>
        /// <param name="argSkillRequest"></param>
        /// <returns></returns>
        private async Task<HttpResponseMessage> SaveInitialSkills(UserInitialSkillRequest argSkillRequest)
        {
            #region Declarations
            HttpResponseMessage l_Response = new HttpResponseMessage();
            UserInitialSkillRequestBE l_RequestBE = new UserInitialSkillRequestBE();
            string l_SaveSkillURL = apiBaseURL + "/CreateInitialSkillRequest?argLoggedInUser=" + GetLoggedInUserID();
            #endregion

            try
            {
                l_RequestBE = ConvertSkillRequestToBusinessEntity(argSkillRequest);
                if(l_RequestBE!=null)
                {
                    l_Response = await client.PostAsJsonAsync(l_SaveSkillURL, l_RequestBE);
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }

            return l_Response;
        }

        /// <summary>
        /// This method is used to convert Intial Request to business entity
        /// </summary>
        /// <param name="argSkillRequest"></param>
        /// <returns></returns>
        private UserInitialSkillRequestBE ConvertSkillRequestToBusinessEntity(UserInitialSkillRequest argSkillRequest)
        {
            #region Declarations
            UserInitialSkillRequestBE l_UserInitialSkillRequestBE = new UserInitialSkillRequestBE();
            SubSkillBECollection l_SubskillsBECollection = new SubSkillBECollection();
            SubskillsBE l_Subskills;
            #endregion
            try
            {
                if(argSkillRequest!=null)
                {
                    //Comments
                    l_UserInitialSkillRequestBE.Comments = argSkillRequest.Comments;

                    //Subskills
                    if(argSkillRequest.SubskillCollection!=null && argSkillRequest.SubskillCollection.Count > 0)
                    {
                        foreach (var subskills in argSkillRequest.SubskillCollection)
                        {
                            l_Subskills = new SubskillsBE();
                            l_Subskills.SubSkillID = subskills.SubSkillID;
                            l_Subskills.SkillID = subskills.SkillID;
                            l_SubskillsBECollection.Add(l_Subskills);
                        }
                        l_UserInitialSkillRequestBE.UserSubskills = l_SubskillsBECollection;
                    }
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }

            return l_UserInitialSkillRequestBE;
        }

        /// <summary>
        /// Get all subskills on the basis of skill selected
        /// </summary>
        /// <param name="argSkillID"></param>
        /// <returns></returns>
        [HttpPost]
        public async Task<ActionResult> GetSubskills(int argSkillID)
        {
            #region Declarations
            UserInitialSkillRequest l_UserInitialSkillRequest = new UserInitialSkillRequest();
            SubSkillBECollection l_SubSkills = new SubSkillBECollection();
            SubSkillCollection l_SubskillCollection = new SubSkillCollection();
            #endregion

            l_SubSkills = await GetSubskillsForSkill(argSkillID);

            if(l_SubSkills!=null && l_SubSkills.Count > 0)
            {
                l_SubskillCollection = ConvertSubskillCollectionToModel(l_SubSkills);
                l_UserInitialSkillRequest.SubskillCollection = l_SubskillCollection;
            }


            return PartialView("_partialSubskills", l_UserInitialSkillRequest);
        }

       
    }
}