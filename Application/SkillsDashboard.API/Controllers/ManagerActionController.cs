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
    /// API's for Pending Manager Approvals screen
    /// </summary>
    public class ManagerActionController : ApiController
    {
        /// <summary>
        /// This API is used to get the list of pending manager approvals
        /// </summary>
        /// <param name="argLoggedInUser">Logged in user ID</param>
        /// <param name="argType">Request Type</param>
        /// <returns></returns>
        [Route("GetManagerApprovals")]
        public IHttpActionResult GetManagerApprovals(int argLoggedInUser, string argType)
        {
            #region Declarations
            ManagerActionablesBLO l_ManagerActionablesBLO = new ManagerActionablesBLO();
            PendingManagerApprovalsBECollection l_PendingManagerApprovalsBECollection = new PendingManagerApprovalsBECollection();
            #endregion
            try
            {
                l_PendingManagerApprovalsBECollection = l_ManagerActionablesBLO.GetPendingManagerApprovals(argLoggedInUser, argType);

                if (l_PendingManagerApprovalsBECollection == null || l_PendingManagerApprovalsBECollection.Count == 0)
                {
                    return NotFound();
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }

            return Ok(l_PendingManagerApprovalsBECollection);
        }

        /// <summary>
        /// This API is used to save manager action (APPROVE/REJECT)
        /// </summary>
        /// <param name="argLoggedInUser">Logged in user ID</param>
        /// <param name="argManagerApprovalBE">Manager approval details</param>
        /// <returns></returns>
        [Route("SaveManagerActionable")]
        public IHttpActionResult SaveManagerActionable(int argLoggedInUser,[FromBody]ManagerApprovalBE argManagerApprovalBE)
        {
            #region Declarations
            ManagerActionablesBLO l_ManagerActionablesBLO = new ManagerActionablesBLO();
            #endregion
            try
            {
                l_ManagerActionablesBLO.SaveManagerApprovals(argLoggedInUser, argManagerApprovalBE);
            }
            catch (Exception ex)
            {
                throw ex;
            }

            return Ok();
        }
    }
}
