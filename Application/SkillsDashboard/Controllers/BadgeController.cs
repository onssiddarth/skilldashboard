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
    [Authorize]
    public class BadgeController : SkillsDashboardBaseController
    {
        #region Page level declarations
        HttpClient client;
        string apiBaseURL = ConfigurationManager.AppSettings["APIBaseURL"];
        #endregion

        public BadgeController()
        {
            client = new HttpClient();
            client.BaseAddress = new Uri(apiBaseURL);
            client.DefaultRequestHeaders.Accept.Clear();
            client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
        }

        /// <summary>
        /// Give badge by expert Action Result method
        /// </summary>
        /// <returns></returns>
        [Authorize(Roles = "SKILLEXPERT")]
        public async Task<ActionResult> GiveBadgeByExpert()
        {
            SaveBadge l_SaveBadge = new SaveBadge();
            var l_BadgeDetails = await GetBadgeDetails(SkillConstants.C_BADGETYPE_EXPERT);
            if(l_BadgeDetails!=null)
            {
                l_SaveBadge.BadgeID = l_BadgeDetails.BadgeID;
                l_SaveBadge.BadgeName = l_BadgeDetails.BadgeName;
                l_SaveBadge.BadgeImageURL = l_BadgeDetails.BadgeURL;
                l_SaveBadge.Type = SkillConstants.C_SAVEBADGETYPE_EXPERT;
            }
            if(TempData[SkillConstants.C_GIVEBADGESUCCESS_CONST]!=null)
            {
                ViewBag.SuccessMessage = "Badge given successfully!!";
            }
            return View(l_SaveBadge);
        }

        /// <summary>
        /// Action Result method to display request badge view
        /// </summary>
        /// <returns></returns>
        public async Task<ActionResult> RequestBadge()
        {
            SaveBadge l_SaveBadge = new SaveBadge();
            var l_BadgeDetails = await GetBadgeDetails(SkillConstants.C_BADGETYPE_USER);
            if (l_BadgeDetails != null)
            {
                l_SaveBadge.BadgeID = l_BadgeDetails.BadgeID;
                l_SaveBadge.BadgeName = l_BadgeDetails.BadgeName;
                l_SaveBadge.BadgeImageURL = l_BadgeDetails.BadgeURL;
                l_SaveBadge.Type = SkillConstants.C_SAVEBADGETYPE_USER;
            }
            if (TempData[SkillConstants.C_GIVEBADGESUCCESS_CONST] != null)
            {
                ViewBag.SuccessMessage = "Badge requested successfully!!";
            }
            return View(l_SaveBadge);
        }

        /// <summary>
        /// Method to get badge details from API
        /// </summary>
        /// <param name="argType">Badge Type</param>
        /// <returns></returns>
        public async Task<BadgeBE> GetBadgeDetails(string argType)
        {
            #region Declarations
            BadgeBECollection l_BadgeBECollection = new BadgeBECollection();
            BadgeBE l_BadgeBE = new BadgeBE();
            int l_LoggedInUser = 0;
            string l_BadgeURL = string.Empty;
            #endregion
            try
            {
                l_LoggedInUser = GetLoggedInUserID();
                l_BadgeURL = apiBaseURL + "/GetBadges?argLoggedInUser=" + l_LoggedInUser + "&argBadgeType="+ argType;
                HttpResponseMessage l_BadgeData = await client.GetAsync(l_BadgeURL);

                if (l_BadgeData != null && l_BadgeData.IsSuccessStatusCode)
                {
                    var l_BadgeResponse = l_BadgeData.Content.ReadAsStringAsync().Result;
                    l_BadgeBECollection = JsonConvert.DeserializeObject<BadgeBECollection>(l_BadgeResponse);

                    l_BadgeBE = l_BadgeBECollection.Where(x => x.BadgeName == argType).FirstOrDefault();
                }

            }
            catch (Exception ex)
            {
                throw ex;
            }
            return l_BadgeBE;
        }

        /// <summary>
        /// HTTP POST method to save badge details
        /// </summary>
        /// <param name="argSaveBadge">Badge Details</param>
        /// <param name="argRequestType">Request Type</param>
        /// <returns></returns>
        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<ActionResult> SaveUserBadge(SaveBadge argSaveBadge, string argRequestType)
        {
            HttpResponseMessage l_Message = new HttpResponseMessage();
            if (ModelState.IsValid)
            {
                if (argSaveBadge != null)
                {
                    l_Message = await SaveBadge(argSaveBadge);

                    if (l_Message.IsSuccessStatusCode)
                    {
                        TempData[SkillConstants.C_GIVEBADGESUCCESS_CONST] = SkillConstants.C_SUCCESS_CONST;

                        if(argRequestType == "EXPERT")
                        {
                            return RedirectToAction("GiveBadgeByExpert", "Badge");
                        }
                        else
                        {
                            return RedirectToAction("RequestBadge", "Badge");
                        }
                        
                    }
                }
                

            }

            if (argRequestType == "EXPERT")
            {
                return RedirectToAction("GiveBadgeByExpert", "Badge");
            }
            else
            {
                return RedirectToAction("RequestBadge", "Badge");
            }
        }

        /// <summary>
        /// API call to save badge given for user
        /// </summary>
        /// <param name="argSaveBadge">Badge Details</param>
        /// <returns></returns>
        private async Task<HttpResponseMessage> SaveBadge(SaveBadge argSaveBadge)
        {
            #region Declarations
            HttpResponseMessage l_Response = new HttpResponseMessage();
            SaveBadgeBE l_SaveBadgeBE = new SaveBadgeBE();
            string l_SaveSkillURL = apiBaseURL + "/SaveBadgeForUser?argLoggedInUser=" + GetLoggedInUserID();
            #endregion

            try
            {
                l_SaveBadgeBE = ConvertBadgeRequestToBE(argSaveBadge);
                if (l_SaveBadgeBE != null)
                {
                    l_Response = await client.PostAsJsonAsync(l_SaveSkillURL, l_SaveBadgeBE);
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }

            return l_Response;
        }

        /// <summary>
        /// Method to convert Badge model to business entity
        /// </summary>
        /// <param name="argSaveBadge">Badge Model</param>
        /// <returns></returns>
        private SaveBadgeBE ConvertBadgeRequestToBE(SaveBadge argSaveBadge)
        {
            SaveBadgeBE l_SaveBadgeBE = new SaveBadgeBE();
            try
            {
                if(argSaveBadge!=null)
                {
                    l_SaveBadgeBE.Type = argSaveBadge.Type;
                    l_SaveBadgeBE.Comments = argSaveBadge.Comments;
                    l_SaveBadgeBE.BadgeGivenTo = argSaveBadge.BadgeGivenTo;
                    l_SaveBadgeBE.BadgeID = argSaveBadge.BadgeID;
                }
            }
            catch (Exception)
            {
                throw;
            }
            return l_SaveBadgeBE;
        }

        /// <summary>
        /// Method to get user details on the basis of name Prefix
        /// </summary>
        /// <param name="argNamePrefix"></param>
        /// <returns></returns>
        [HttpPost]
        public async Task<JsonResult> GetEmployeesByName(string argNamePrefix)
        {
            var l_EmployeeData = await GetEmployeeDetailsFromDatabase(argNamePrefix);
            return Json(l_EmployeeData, JsonRequestBehavior.AllowGet);
        }

        /// <summary>
        /// API call to get employee details on the basis if name prefix
        /// </summary>
        /// <param name="argName">Name prefix</param>
        /// <returns></returns>
        public async Task<UserDetailsBECollection> GetEmployeeDetailsFromDatabase(string argName)
        {
            #region Declarations
            UserDetailsBECollection l_UserDetailsBECollection = new UserDetailsBECollection();
            int l_LoggedInUser = 0;
            string l_FindEmployeeURL = string.Empty;
            #endregion
            try
            {
                l_LoggedInUser = GetLoggedInUserID();
                l_FindEmployeeURL = apiBaseURL + "/GetUsersByName?argLoggedInUser=" + l_LoggedInUser + "&argNamePrefix=" + argName;
                HttpResponseMessage l_EmployeeData = await client.GetAsync(l_FindEmployeeURL);

                if (l_EmployeeData != null && l_EmployeeData.IsSuccessStatusCode)
                {
                    var l_EmployeeDataResponse = l_EmployeeData.Content.ReadAsStringAsync().Result;
                    l_UserDetailsBECollection = JsonConvert.DeserializeObject<UserDetailsBECollection>(l_EmployeeDataResponse);
                }

            }
            catch (Exception ex)
            {
                throw ex;
            }
            return l_UserDetailsBECollection;
        }
    }
}