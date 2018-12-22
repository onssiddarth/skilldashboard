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
    public class SkillExpertActionController : ApiController
    {
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
