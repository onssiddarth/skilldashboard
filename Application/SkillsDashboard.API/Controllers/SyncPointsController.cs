using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using SkillsDashboard.BLO;

namespace SkillsDashboard.API.Controllers
{
    /// <summary>
    /// API to sycn user required points
    /// </summary>
    public class SyncPointsController : ApiController
    {
        /// <summary>
        /// This API is used to sync user required points
        /// </summary>
        /// <returns></returns>
        [Route("SyncUserRequiredPoints")]
        public IHttpActionResult SaveSkillExpertActionable()
        {
            #region Declarations
            SyncUserSkillsBLO l_SyncUserSkillsBLO = new SyncUserSkillsBLO();
            int l_UserIDAdmin = 1;
            #endregion
            try
            {
                l_SyncUserSkillsBLO.SyncUserRequiredPoints(l_UserIDAdmin);
            }
            catch (Exception ex)
            {
                throw ex;
            }

            return Ok();
        }
    }
}
