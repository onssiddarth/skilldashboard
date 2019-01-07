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
    /// API used in "Track Requests" page
    /// </summary>
    public class UserRequestsController : ApiController
    {
        /// <summary>
        /// This API is used to get the list of requests made by user along with their status
        /// </summary>
        /// <param name="argLoggedInUser">Logged in User ID</param>
        /// <param name="argType">Request Type</param>
        /// <returns></returns>
        [Route("GetUserRequests")]
        public IHttpActionResult GetUserRequests(int argLoggedInUser,string argType)
        {
            #region Declarations
            UserRequestsBLO l_RequestBLO = new UserRequestsBLO();
            UserRequestsBECollection l_UserRequestsBECollection = new UserRequestsBECollection();
            #endregion
            try
            {
                l_UserRequestsBECollection = l_RequestBLO.GetUserSkillRequests(argLoggedInUser, argType);

                if (l_UserRequestsBECollection == null || l_UserRequestsBECollection.Count == 0)
                {
                    return NotFound();
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }

            return Ok(l_UserRequestsBECollection);
        }
    }
}
