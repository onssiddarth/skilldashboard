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
    public class UserRequestsController : ApiController
    {

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
