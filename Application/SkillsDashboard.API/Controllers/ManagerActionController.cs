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
    public class ManagerActionController : ApiController
    {
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
