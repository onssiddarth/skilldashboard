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
    /// Badge related API's
    /// </summary>
    public class BadgeController : ApiController
    {
        /// <summary>
        /// This API is used to get list of employees on the basis of the name prefix
        /// </summary>
        /// <param name="argLoggedInUser">Logged in user ID</param>
        /// <param name="argNamePrefix">Letters to search employee name</param>
        /// <returns></returns>
        [Route("GetUsersByName")]
        public IHttpActionResult GetUsersByName(int argLoggedInUser, string argNamePrefix)
        {
            #region Declarations
            BadgeBLO l_BadgeBLO = new BadgeBLO();
            UserDetailsBECollection l_UserDetailsBECollection = new UserDetailsBECollection();
            #endregion
            try
            {
                l_UserDetailsBECollection = l_BadgeBLO.GetUsersByName(argLoggedInUser, argNamePrefix);

                if (l_UserDetailsBECollection == null || l_UserDetailsBECollection.Count == 0)
                {
                    return NotFound();
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }

            return Ok(l_UserDetailsBECollection);
        }

        /// <summary>
        /// This API is used to fetch list of badges being usd in system (e.g. Query badges)
        /// </summary>
        /// <param name="argLoggedInUser">Logged in user ID</param>
        /// <param name="argBadgeType">Badge Type(EXPERTBADGE/USERBADGE)</param>
        /// <returns></returns>
        [Route("GetBadges")]
        public IHttpActionResult GetBadges(int argLoggedInUser, string argBadgeType)
        {
            #region Declarations
            BadgeBLO l_BadgeBLO = new BadgeBLO();
            BadgeBECollection l_BadgeBECollection = new BadgeBECollection();
            #endregion
            try
            {
                l_BadgeBECollection = l_BadgeBLO.GetBadges(argLoggedInUser, argBadgeType);

                if (l_BadgeBECollection == null || l_BadgeBECollection.Count == 0)
                {
                    return NotFound();
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }

            return Ok(l_BadgeBECollection);
        }

        /// <summary>
        /// This API is used to save badge given by user
        /// </summary>
        /// <param name="argLoggedInUser">Logged in user ID</param>
        /// <param name="argSaveBadgeBE">Badge Details to save</param>
        /// <returns></returns>
        [Route("SaveBadgeForUser")]
        public IHttpActionResult SaveBadgeForUser(int argLoggedInUser, [FromBody]SaveBadgeBE argSaveBadgeBE)
        {
            #region Declarations
            BadgeBLO l_BadgeBLO = new BadgeBLO();
            #endregion
            try
            {
                l_BadgeBLO.SaveBadgeForUser(argLoggedInUser, argSaveBadgeBE);
            }
            catch (Exception ex)
            {
                throw ex;
            }

            return Ok();
        }

        /// <summary>
        /// This API is used to modify the badge status by manager
        /// </summary>
        /// <param name="argLoggedInUser">Logged in user ID</param>
        /// <param name="argSaveBadgeBE">Badge Details</param>
        /// <returns></returns>
        [Route("ApproveBadge")]
        public IHttpActionResult ApproveBadge(int argLoggedInUser, [FromBody]SaveBadgeBE argSaveBadgeBE)
        {
            #region Declarations
            BadgeBLO l_BadgeBLO = new BadgeBLO();
            #endregion
            try
            {
                l_BadgeBLO.ApproveBadge(argLoggedInUser, argSaveBadgeBE);
            }
            catch (Exception ex)
            {
                throw ex;
            }

            return Ok();
        }
    }
}
