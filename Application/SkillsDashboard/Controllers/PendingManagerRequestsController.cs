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

namespace SkillsDashboard.Controllers
{
    [Authorize(Roles = "MANAGER")]
    public class PendingManagerRequestsController : SkillsDashboardBaseController
    {
        #region Page level declarations
        HttpClient client;
        string apiBaseURL = ConfigurationManager.AppSettings["APIBaseURL"];
        #endregion

        public PendingManagerRequestsController()
        {
            client = new HttpClient();
            client.BaseAddress = new Uri(apiBaseURL);
            client.DefaultRequestHeaders.Accept.Clear();
            client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
        }

        /// <summary>
        /// Action Result method to load main view for Manager approvals page
        /// </summary>
        /// <returns></returns>
        public ActionResult Index()
        {
            PopulateDropdownValues();
            return View();
        }

        /// <summary>
        /// Method to populate request type dropdown
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
        /// API call to fetch pending manager approvals 
        /// </summary>
        /// <param name="argRequestType">Request Type</param>
        /// <returns></returns>
        [HttpPost]
        public async Task<ActionResult> GetPendingManagerApprovals(string argRequestType)
        {
            #region Declarations
            PendingManagerApprovals l_Requests = new PendingManagerApprovals();
            PendingManagerApprovalsBECollection l_ApprovalBECollection = new PendingManagerApprovalsBECollection();
            PendingManagerApprovalCollection l_ApprovalCollection = new PendingManagerApprovalCollection();
            string l_skillsURL = string.Empty;
            #endregion


            l_skillsURL = apiBaseURL + "/GetManagerApprovals?argLoggedInUser=" + GetLoggedInUserID() + "&argType=" + argRequestType + "";
            HttpResponseMessage l_SkillsData = await client.GetAsync(l_skillsURL);

            if (l_SkillsData != null && l_SkillsData.IsSuccessStatusCode)
            {
                var l_SkillResponse = l_SkillsData.Content.ReadAsStringAsync().Result;
                l_ApprovalBECollection = JsonConvert.DeserializeObject<PendingManagerApprovalsBECollection>(l_SkillResponse);
            }

            l_ApprovalCollection = ConverMendingManagerApprovalsToModel(l_ApprovalBECollection);
            return PartialView("_partialPendingManagerApprovals", l_ApprovalCollection);
        }

        /// <summary>
        /// Method to convert ManagerApproval business entity to model
        /// </summary>
        /// <param name="argApprovalsBECollection"></param>
        /// <returns></returns>
        private PendingManagerApprovalCollection ConverMendingManagerApprovalsToModel(PendingManagerApprovalsBECollection argApprovalsBECollection)
        {
            #region Declarations
            PendingManagerApprovalCollection l_PendingApprovalsCollection = new PendingManagerApprovalCollection();
            PendingManagerApprovals l_Approvals;
            #endregion
            try
            {
                if (argApprovalsBECollection != null && argApprovalsBECollection.Count > 0)
                {
                    foreach (var item in argApprovalsBECollection)
                    {
                        l_Approvals = new PendingManagerApprovals();
                        l_Approvals.Comments = item.Comments;
                        l_Approvals.Status = item.Status;
                        l_Approvals.RequestedDate = item.RequestedDate;
                        l_Approvals.RequestType = item.RequestType;
                        l_Approvals.SkillName = item.SkillName;
                        l_Approvals.SkillPoints = item.SkillPoints;
                        l_Approvals.SubSkillName = item.SubSkillName;
                        l_Approvals.RequestedBy = item.RequestedBy;
                        l_Approvals.UniqueID = item.UniqueID;
                        l_Approvals.FileGUID = item.FileGUID;
                        l_Approvals.FileName = item.FileName;
                        l_Approvals.RequestCode = item.RequestCode;

                        l_Approvals.BadgeGivenFor = item.BadgeGivenFor;
                        l_Approvals.BadgeID = item.BadgeID;
                        l_Approvals.BadgeName = item.BadgeName;
                        l_Approvals.BadgeImageURL = item.BadgeImageURL;

                        l_PendingApprovalsCollection.Add(l_Approvals);
                    }
                }
            }
            catch (Exception ex)
            {

                throw ex;
            }

            return l_PendingApprovalsCollection;
        }

        /// <summary>
        /// Ajax post request to get manager approval data
        /// </summary>
        /// <param name="argManagerApproval"></param>
        /// <returns></returns>
        [HttpPost]
        public async Task<JsonResult> SaveManagerApproval(ManagerApproval argManagerApproval)
        {
            #region Declarations
            bool IsSuccess = false;
            HttpResponseMessage l_Message = new HttpResponseMessage();
            #endregion
            if(argManagerApproval!=null)
            {
                l_Message = await SaveManagerResponseToDatabase(argManagerApproval);
                if(l_Message.IsSuccessStatusCode)
                {
                    IsSuccess = true;
                }
            }

            return Json(IsSuccess, JsonRequestBehavior.AllowGet);
        }

        /// <summary>
        /// This method is used to cal WebAPI to save manager approval
        /// </summary>
        /// <param name="argManagerApproval"></param>
        /// <returns></returns>
        private async Task<HttpResponseMessage> SaveManagerResponseToDatabase(ManagerApproval argManagerApproval)
        {
            #region Declarations
            HttpResponseMessage l_Response = new HttpResponseMessage();
            ManagerApprovalBE l_ManagerApprovalBE = new ManagerApprovalBE();
            string l_ManagerResponseURL = apiBaseURL + "/SaveManagerActionable?argLoggedInUser=" + GetLoggedInUserID();
            #endregion

            try
            {
                l_ManagerApprovalBE = ConvertManagerApprovalToBE(argManagerApproval);

                if(l_ManagerApprovalBE!=null)
                {
                    l_Response = await client.PostAsJsonAsync(l_ManagerResponseURL, l_ManagerApprovalBE);
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }

            return l_Response;
        }

        /// <summary>
        /// This method is used to convert ManagerApproval modal to business entity
        /// </summary>
        /// <param name="argManagerApproval"></param>
        /// <returns></returns>
        private ManagerApprovalBE ConvertManagerApprovalToBE(ManagerApproval argManagerApproval)
        {
            ManagerApprovalBE l_ManagerApprovalBE = new ManagerApprovalBE();
            try
            {
                if (argManagerApproval != null)
                {
                    l_ManagerApprovalBE.Status = argManagerApproval.Status;
                    l_ManagerApprovalBE.Comments = argManagerApproval.Comments;
                    l_ManagerApprovalBE.Type = argManagerApproval.Type;
                    l_ManagerApprovalBE.UniqueID = argManagerApproval.UniqueID;

                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return l_ManagerApprovalBE;
        }

        /// <summary>
        /// HTTP POST method to save manager action (approve/reject) for badge
        /// </summary>
        /// <param name="argSaveBadge"></param>
        /// <returns></returns>
        [HttpPost]
        public async Task<JsonResult> SaveManagerApprovalForBadge(SaveBadge argSaveBadge)
        {
            #region Declarations
            bool IsSuccess = false;
            HttpResponseMessage l_Message = new HttpResponseMessage();
            #endregion
            if (argSaveBadge != null)
            {
                l_Message = await SaveBadgeResponseToDatabase(argSaveBadge);
                if (l_Message.IsSuccessStatusCode)
                {
                    IsSuccess = true;
                }
            }

            return Json(IsSuccess, JsonRequestBehavior.AllowGet);
        }

        /// <summary>
        /// API call to save badge details
        /// </summary>
        /// <param name="argSaveBadge">Badge Model</param>
        /// <returns></returns>
        private async Task<HttpResponseMessage> SaveBadgeResponseToDatabase(SaveBadge argSaveBadge)
        {
            #region Declarations
            HttpResponseMessage l_Response = new HttpResponseMessage();
            SaveBadgeBE l_SaveBadgeBE = new SaveBadgeBE();
            string l_ManagerBadgeResponseURL = apiBaseURL + "/ApproveBadge?argLoggedInUser=" + GetLoggedInUserID();
            #endregion

            try
            {
                l_SaveBadgeBE = ConvertManagerApprovalBadgeToBE(argSaveBadge);

                if (l_SaveBadgeBE != null)
                {
                    l_Response = await client.PostAsJsonAsync(l_ManagerBadgeResponseURL, l_SaveBadgeBE);
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }

            return l_Response;
        }

        /// <summary>
        /// Method to convert badge details model to business entity
        /// </summary>
        /// <param name="argSaveBadge"></param>
        /// <returns></returns>
        private SaveBadgeBE ConvertManagerApprovalBadgeToBE(SaveBadge argSaveBadge)
        {
            SaveBadgeBE l_SaveBadgeBE = new SaveBadgeBE();
            if (argSaveBadge!=null)
            {
                l_SaveBadgeBE.UserBadgeID = argSaveBadge.UserBadgeID;
                l_SaveBadgeBE.Comments = argSaveBadge.Comments;
                l_SaveBadgeBE.Status = argSaveBadge.Status;

            }

            return l_SaveBadgeBE;
        }
    }

}