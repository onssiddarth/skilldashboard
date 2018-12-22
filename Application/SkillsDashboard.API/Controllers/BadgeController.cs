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
    public class BadgeController : ApiController
    {
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
