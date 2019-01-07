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
    /// Dashboard related API's
    /// </summary>
    public class DashboardController : ApiController
    {
        /// <summary>
        /// This API is used to get dashboard data for user
        /// </summary>
        /// <param name="argLoggedInUser">Logged in user ID</param>
        /// <param name="argUserID">User for whom dashboard details should be loaded</param>
        /// <returns></returns>
        [Route("GetDashboardData")]
        public IHttpActionResult GetDashboardData(int argLoggedInUser, int argUserID)
        {
            #region Declarations
            DashboardBLO l_DashboardBLO = new DashboardBLO();
            DashboardBE l_DashboardBE = new DashboardBE();
            #endregion
            try
            {
                l_DashboardBE = l_DashboardBLO.GetDashboardDetails(argLoggedInUser, argUserID);

                if (l_DashboardBE == null )
                {
                    return NotFound();
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }

            return Ok(l_DashboardBE);
        }
    }
}
