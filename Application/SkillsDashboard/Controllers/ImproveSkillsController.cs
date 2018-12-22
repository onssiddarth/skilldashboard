using SkillsDashboard.BusinessEntities;
using SkillsDashboard.Models;
using SkillsDashboard.Utilities;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.IO;
using System.Linq;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Threading.Tasks;
using System.Web;
using System.Web.Mvc;
using static SkillsDashboard.Utilities.SkillConstants;

namespace SkillsDashboard.Controllers
{
    public class ImproveSkillsController : SkillsDashboardBaseController
    {
        #region Page level declarations
        HttpClient client;
        string apiBaseURL = ConfigurationManager.AppSettings["APIBaseURL"];
        #endregion

        public ImproveSkillsController()
        {
            client = new HttpClient();
            client.BaseAddress = new Uri(apiBaseURL);
            client.DefaultRequestHeaders.Accept.Clear();
            client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
        }
        /// <summary>
        /// Load view for Improve Skills page
        /// </summary>
        /// <returns></returns>
        public async Task<ActionResult> Index()
        {
            ImproveSkills l_ImproveSkills = new ImproveSkills();
            await PopulateDropdownValues();
            return View(l_ImproveSkills);
        }

        /// <summary>
        /// Set values for skill and mode dropdown in Improve skills page
        /// </summary>
        private async Task<bool> PopulateDropdownValues()
        {
            bool l_Executed = false;
            try
            {
                //Populate request mode
                var RequestMode = from ImproveSkillsMode mode in Enum.GetValues(typeof(ImproveSkillsMode))
                                  select new { ID = mode, Name = GetNameForRequestMode(mode.ToString()) };
                ViewBag.RequestModeList = new SelectList(RequestMode, "ID", "Name");

                //Get skills
                var l_Skills = await GetAllSkills();
                ViewBag.SkillList = new SelectList(l_Skills, "SkillID", "SkillName");

                l_Executed = true;
            }
            catch (Exception ex)
            {
                throw ex;
            }

            return l_Executed;
        }

        /// <summary>
        /// This function is used to get the name to be populated in dropdown
        /// </summary>
        /// <param name="argName"></param>
        /// <returns></returns>
        private string GetNameForRequestMode(string argName)
        {
            string l_Name = string.Empty;
            try
            {
                switch(argName.ToUpper())
                {
                    case "DEMO":
                        l_Name = "Request a Demo";
                        break;

                   case "CERTIFICATE":
                        l_Name = "Upload Certificate";
                        break;
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }

            return l_Name;
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
            ImproveSkills l_ImproveSkills = new ImproveSkills();
            SubSkillBECollection l_SubSkills = new SubSkillBECollection();
            SubSkillCollection l_SubskillCollection = new SubSkillCollection();
            #endregion

            l_SubSkills = await GetSubskillsForSkill(argSkillID);

            if (l_SubSkills != null && l_SubSkills.Count > 0)
            {
                l_SubskillCollection = ConvertSubskillCollectionToModel(l_SubSkills);
                l_ImproveSkills.SubskillCollection = l_SubskillCollection;
            }


            return PartialView("_partialImproveSubskills", l_ImproveSkills);
        }

        [HttpPost]
        public async Task<ActionResult> SendForApproval(ImproveSkills argImproveSkills)
        {
            HttpResponseMessage l_Message = new HttpResponseMessage();
            string l_GUID = string.Empty;
            if (ModelState.IsValid)
            {
                if (argImproveSkills != null && argImproveSkills.SubskillCollection != null && argImproveSkills.SubskillCollection.Count > 0 && argImproveSkills.SubskillCollection.Exists(x => x.IsSelected == true))
                {
                    //Remove all subskills which are not selected
                    argImproveSkills.SubskillCollection.RemoveAll(x => x.IsSelected == false);

                    //Upload file
                    if (argImproveSkills.File!=null)
                    {
                        l_GUID = UploadFile(argImproveSkills);
                    }

                    l_Message = await ImproveSkillRequest(argImproveSkills, l_GUID);

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
            //If there is any model error, show the subskills for selected skills
            ViewBag.ShowSubskills = true;

            await PopulateDropdownValues();

            return View("Index", argImproveSkills);
        }

        /// <summary>
        /// This function is used to save file to Uploads path
        /// </summary>
        /// <param name="argImproveSkills"></param>
        /// <returns></returns>
        private string UploadFile(ImproveSkills argImproveSkills)
        {
            string l_GUID = string.Empty;
            try
            {
                l_GUID = Guid.NewGuid().ToString();

                //get File Name
                var l_fileName = Path.GetFileName(argImproveSkills.File.FileName);

                //Get extension of file
                var l_extension = argImproveSkills.File.FileName.Substring(argImproveSkills.File.FileName.LastIndexOf('.'));

                //Set Path with file name set to GUID
                var l_path = Path.Combine(Server.MapPath("~/Uploads"), string.Concat(l_GUID, l_extension));

                //Save File
                argImproveSkills.File.SaveAs(l_path);
            }
            catch (Exception ex)
            {
                throw ex;
            }

            return l_GUID;
        }

        /// <summary>
        /// Save Initial skill requests to DB
        /// </summary>
        /// <param name="argSkillRequest"></param>
        /// <returns></returns>
        private async Task<HttpResponseMessage> ImproveSkillRequest(ImproveSkills argImproveSkills, string argGUID)
        {
            #region Declarations
            HttpResponseMessage l_Response = new HttpResponseMessage();
            ImproveSkillsBE l_ImproveSkillsBE = new ImproveSkillsBE();
            string l_SaveSkillURL = apiBaseURL + "/ImproveSkills?argLoggedInUser=" + GetLoggedInUserID();
            #endregion

            try
            {
                l_ImproveSkillsBE = ConvertImproveSkillRequestToBusinessEntity(argImproveSkills, argGUID);
                if (l_ImproveSkillsBE != null)
                {
                    l_Response = await client.PostAsJsonAsync(l_SaveSkillURL, l_ImproveSkillsBE);
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }

            return l_Response;
        }

        /// <summary>
        /// This function is used to convert model to Business Entity
        /// </summary>
        /// <param name="argImproveSkills"></param>
        /// <param name="argGUID"></param>
        /// <returns></returns>
        private ImproveSkillsBE ConvertImproveSkillRequestToBusinessEntity(ImproveSkills argImproveSkills, string argGUID)
        {
            #region Declarations
            ImproveSkillsBE l_ImproveSkillsBE = new ImproveSkillsBE();
            SubSkillBECollection l_SubskillsBECollection = new SubSkillBECollection();
            SubskillsBE l_Subskills;
            #endregion
            try
            {
                if (argImproveSkills != null)
                {
                    //Comments
                    l_ImproveSkillsBE.Comments = argImproveSkills.Comments;

                    //File details
                    if(argImproveSkills.File!=null)
                    {
                        l_ImproveSkillsBE.FileUploadName = argImproveSkills.File.FileName;
                        l_ImproveSkillsBE.FileUploadGUID = argGUID;
                    }

                    //Mode
                    l_ImproveSkillsBE.Mode = argImproveSkills.Mode;

                    //Subskills
                    if (argImproveSkills.SubskillCollection != null && argImproveSkills.SubskillCollection.Count > 0)
                    {
                        foreach (var subskills in argImproveSkills.SubskillCollection)
                        {
                            l_Subskills = new SubskillsBE();
                            l_Subskills.SubSkillID = subskills.SubSkillID;
                            l_Subskills.SkillID = subskills.SkillID;
                            l_SubskillsBECollection.Add(l_Subskills);
                        }
                        l_ImproveSkillsBE.UserSubskills = l_SubskillsBECollection;
                    }
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }

            return l_ImproveSkillsBE;
        }
    }
}