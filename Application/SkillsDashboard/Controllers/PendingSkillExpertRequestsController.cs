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
    [Authorize(Roles = "SKILLEXPERT")]
    public class PendingSkillExpertRequestsController : SkillsDashboardBaseController
    {
        #region Page level declarations
        HttpClient client;
        string apiBaseURL = ConfigurationManager.AppSettings["APIBaseURL"];
        #endregion

        public PendingSkillExpertRequestsController()
        {
            client = new HttpClient();
            client.BaseAddress = new Uri(apiBaseURL);
            client.DefaultRequestHeaders.Accept.Clear();
            client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
        }

        /// <summary>
        /// Action Result method to load main view for Skill Expert approvals page
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
                var RequestMode = GetRequestTypes();
                ViewBag.RequestModeList = new SelectList(RequestMode, "ID", "Name");
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        /// <summary>
        /// API call to get pending skill expert approvals
        /// </summary>
        /// <param name="argRequestType">Request Type</param>
        /// <returns></returns>
        [HttpPost]
        public async Task<ActionResult> GetPendingSkillExpertApprovals(string argRequestType)
        {
            #region Declarations
            PendingSkillExpertApprovals l_Requests = new PendingSkillExpertApprovals();
            PendingSkillExpertApprovalBECollection l_ApprovalBECollection = new PendingSkillExpertApprovalBECollection();
            PendingSkillExpertApprovalsCollection l_ApprovalCollection = new PendingSkillExpertApprovalsCollection();
            string l_skillsURL = string.Empty;
            #endregion


            l_skillsURL = apiBaseURL + "/GetSkillExpertApprovals?argLoggedInUser=" + GetLoggedInUserID() + "&argType=" + argRequestType + "";
            HttpResponseMessage l_SkillsData = await client.GetAsync(l_skillsURL);

            if (l_SkillsData != null && l_SkillsData.IsSuccessStatusCode)
            {
                var l_SkillResponse = l_SkillsData.Content.ReadAsStringAsync().Result;
                l_ApprovalBECollection = JsonConvert.DeserializeObject<PendingSkillExpertApprovalBECollection>(l_SkillResponse);
            }

            l_ApprovalCollection = ConverPendingSkillExpertApprovalsToModel(l_ApprovalBECollection);
            return PartialView("_partialPendingSkillExpertApprovals", l_ApprovalCollection);
        }

        /// <summary>
        /// Method to convert SkillExpertBECollection to Model
        /// </summary>
        /// <param name="argApprovalsBECollection">Business Entity collection for skill expert approval</param>
        /// <returns></returns>
        private PendingSkillExpertApprovalsCollection ConverPendingSkillExpertApprovalsToModel(PendingSkillExpertApprovalBECollection argApprovalsBECollection)
        {
            #region Declarations
            PendingSkillExpertApprovalsCollection l_PendingApprovalsCollection = new PendingSkillExpertApprovalsCollection();
            PendingSkillExpertApprovals l_Approvals;
            #endregion
            try
            {
                if (argApprovalsBECollection != null && argApprovalsBECollection.Count > 0)
                {
                    foreach (var item in argApprovalsBECollection)
                    {
                        l_Approvals = new PendingSkillExpertApprovals();
                        l_Approvals.ManagerComments = item.ManagerComments;
                        l_Approvals.UserComments = item.UserComments;
                        l_Approvals.SkillExpertComments = item.SkillExpertComments;
                        l_Approvals.DemoSchedule = item.DemoSchedule;
                        l_Approvals.Room = item.Room;
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
        /// HTTP POST method to schedule demo by skill expert
        /// </summary>
        /// <param name="argScheduleDemo">Demo Details</param>
        /// <returns></returns>
        [HttpPost]
        public async Task<JsonResult> ScheduleDemo(ScheduleDemo argScheduleDemo)
        {
            #region Declarations
            bool IsSuccess = false;
            HttpResponseMessage l_Message = new HttpResponseMessage();
            #endregion
            if (argScheduleDemo != null)
            {
                l_Message = await SaveDemoToDatabase(argScheduleDemo);
                if (l_Message.IsSuccessStatusCode)
                {
                    IsSuccess = true;
                }
            }

            return Json(IsSuccess, JsonRequestBehavior.AllowGet);
        }

        /// <summary>
        /// This method is used to cal WebAPI to save demo details
        /// </summary>
        /// <param name="argScheduleDemo">Demo details</param>
        /// <returns></returns>
        private async Task<HttpResponseMessage> SaveDemoToDatabase(ScheduleDemo argScheduleDemo)
        {
            #region Declarations
            HttpResponseMessage l_Response = new HttpResponseMessage();
            ScheduleDemoBE l_ScheduleDemoBE = new ScheduleDemoBE();
            string l_ManagerResponseURL = apiBaseURL + "/ScheduleDemo?argLoggedInUser=" + GetLoggedInUserID();
            #endregion

            try
            {
                l_ScheduleDemoBE = ConvertDemoScheduleToBE(argScheduleDemo);

                if (l_ScheduleDemoBE != null)
                {
                    l_Response = await client.PostAsJsonAsync(l_ManagerResponseURL, l_ScheduleDemoBE);
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }

            return l_Response;
        }

        /// <summary>
        /// This method is used to convert Demo Model to business Entity
        /// </summary>
        /// <param name="argScheduleDemo"></param>
        /// <returns></returns>
        private ScheduleDemoBE ConvertDemoScheduleToBE(ScheduleDemo argScheduleDemo)
        {
            ScheduleDemoBE l_ScheduleDemoBE = new ScheduleDemoBE();
            try
            {
                if (argScheduleDemo != null)
                {
                    l_ScheduleDemoBE.Room = argScheduleDemo.Room;
                    l_ScheduleDemoBE.Comments = argScheduleDemo.Comments;
                    l_ScheduleDemoBE.DemoSchedule = argScheduleDemo.DemoSchedule;
                    l_ScheduleDemoBE.UniqueID = argScheduleDemo.UniqueID;
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return l_ScheduleDemoBE;
        }

        /// <summary>
        /// HTTP POST method to save skill expert action (APPROVE/REJECT)
        /// </summary>
        /// <param name="argSkillExpertApproval">Skill Expert approval modal</param>
        /// <returns></returns>
        [HttpPost]
        public async Task<JsonResult> SaveSkillExpertApproval(SkillExpertApproval argSkillExpertApproval)
        {
            #region Declarations
            bool IsSuccess = false;
            HttpResponseMessage l_Message = new HttpResponseMessage();
            #endregion
            if (argSkillExpertApproval != null)
            {
                l_Message = await SaveSkillExpertResponseToDatabase(argSkillExpertApproval);
                if (l_Message.IsSuccessStatusCode)
                {
                    IsSuccess = true;
                }
            }

            return Json(IsSuccess, JsonRequestBehavior.AllowGet);
        }

        /// <summary>
        /// This method is used to cal WebAPI to skill expert approval
        /// </summary>
        /// <param name="argSkillExpertApproval">Skill Expert approval model</param>
        /// <returns></returns>
        private async Task<HttpResponseMessage> SaveSkillExpertResponseToDatabase(SkillExpertApproval argSkillExpertApproval)
        {
            #region Declarations
            HttpResponseMessage l_Response = new HttpResponseMessage();
            SkillExpertApprovalBE l_SkillExpertApprovalBE = new SkillExpertApprovalBE();
            string l_SkillExpertResponseURL = apiBaseURL + "/SaveSkillExpertActionable?argLoggedInUser=" + GetLoggedInUserID();
            #endregion

            try
            {
                l_SkillExpertApprovalBE = ConvertManagerApprovalToBE(argSkillExpertApproval);

                if (l_SkillExpertApprovalBE != null)
                {
                    l_Response = await client.PostAsJsonAsync(l_SkillExpertResponseURL, l_SkillExpertApprovalBE);
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }

            return l_Response;
        }

        /// <summary>
        /// This method is used to convert SkillExpertApproval modal to business entity
        /// </summary>
        /// <param name="argManagerApproval"></param>
        /// <returns></returns>
        private SkillExpertApprovalBE ConvertManagerApprovalToBE(SkillExpertApproval argSkillExpertApproval)
        {
            SkillExpertApprovalBE l_SkillExpertApprovalBE = new SkillExpertApprovalBE();
            try
            {
                if (argSkillExpertApproval != null)
                {
                    l_SkillExpertApprovalBE.Status = argSkillExpertApproval.Status;
                    l_SkillExpertApprovalBE.Comments = argSkillExpertApproval.Comments;
                    l_SkillExpertApprovalBE.Type = argSkillExpertApproval.Type;
                    l_SkillExpertApprovalBE.UniqueID = argSkillExpertApproval.UniqueID;

                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return l_SkillExpertApprovalBE;
        }
    }
}