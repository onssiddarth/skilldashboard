using SkillsDashboard.BLO;
using SkillsDashboard.BusinessEntities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;

namespace SkillsDashboard.API.Controllers
{
    /// <summary>
    /// API's for skill expert approval page
    /// </summary>
    public class SkillExpertActionController : ApiController
    {
        /// <summary>
        /// This API is used to get list of pending approvals for skill expert
        /// </summary>
        /// <param name="argLoggedInUser">Logged in User ID</param>
        /// <param name="argType">Request Type</param>
        /// <returns></returns>
        [Route("GetSkillExpertApprovals")]
        public IHttpActionResult GetSkillExpertApprovals(int argLoggedInUser, string argType)
        {
            #region Declarations
            SkillExpertActionableBLO l_SkillExpertActionableBLO = new SkillExpertActionableBLO();
            PendingSkillExpertApprovalBECollection l_PendingSkillExpertApprovalBECollection = new PendingSkillExpertApprovalBECollection();
            #endregion
            try
            {
                l_PendingSkillExpertApprovalBECollection = l_SkillExpertActionableBLO.GetPendingSkillExpertApprovals(argLoggedInUser, argType);

                if (l_PendingSkillExpertApprovalBECollection == null || l_PendingSkillExpertApprovalBECollection.Count == 0)
                {
                    return NotFound();
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }

            return Ok(l_PendingSkillExpertApprovalBECollection);
        }

        /// <summary>
        /// This API is used to save skill expert action (APPROVE/REJECT)
        /// </summary>
        /// <param name="argLoggedInUser">Logged in user ID</param>
        /// <param name="argSkillExpertApprovalBE">Skill expert approval details</param>
        /// <returns></returns>
        [Route("SaveSkillExpertActionable")]
        public IHttpActionResult SaveSkillExpertActionable(int argLoggedInUser, [FromBody]SkillExpertApprovalBE argSkillExpertApprovalBE)
        {
            #region Declarations
            SkillExpertActionableBLO l_SkillExpertActionableBLO = new SkillExpertActionableBLO();
            #endregion
            try
            {
                l_SkillExpertActionableBLO.SaveSkillExpertApprovals(argLoggedInUser, argSkillExpertApprovalBE);
            }
            catch (Exception ex)
            {
                throw ex;
            }

            return Ok();
        }

        /// <summary>
        /// This API is used to save Schedule Demo by skill expert
        /// </summary>
        /// <param name="argLoggedInUser">Logged in user ID</param>
        /// <param name="argScheduleDemoBE">Demo details</param>
        /// <returns></returns>
        [Route("ScheduleDemo")]
        public IHttpActionResult ScheduleDemo(int argLoggedInUser, [FromBody]ScheduleDemoBE argScheduleDemoBE)
        {
            #region Declarations
            SkillExpertActionableBLO l_SkillExpertActionableBLO = new SkillExpertActionableBLO();
            #endregion
            try
            {
                l_SkillExpertActionableBLO.ScheduleDemo(argLoggedInUser, argScheduleDemoBE);
            }
            catch (Exception ex)
            {
                throw ex;
            }

            return Ok();
        }
    }
}
