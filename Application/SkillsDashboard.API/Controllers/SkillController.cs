using System;
using System.Collections.Generic;
using System.Linq;
using System.Net;
using System.Net.Http;
using System.Web.Http;
using SkillsDashboard.BusinessEntities;
using SkillsDashboard.BLO;

namespace SkillsDashboard.API.Controllers
{
    /// <summary>
    /// API's for primary skills and improve skills screen
    /// </summary>
    public class SkillController : ApiController
    {
        /// <summary>
        /// This API is used to fetch all skills in system
        /// </summary>
        /// <param name="argLoggedInUser">Logged in User ID</param>
        /// <returns></returns>
        [Route("GetAllSkills")]
        public IHttpActionResult GetAllSkills(int argLoggedInUser)
        {
            #region Declarations
            SkillBLO l_SkillsBLO = new SkillBLO();
            SkillsBECollection l_SkillCollection = new SkillsBECollection();
            #endregion
            try
            {
                l_SkillCollection = l_SkillsBLO.GetAllSkills(argLoggedInUser);

                if (l_SkillCollection == null || l_SkillCollection.Count == 0)
                {
                    return NotFound();
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }

            return Ok(l_SkillCollection);
        }

        /// <summary>
        /// This API is used to fetch all subskills for a skill
        /// </summary>
        /// <param name="argLoggedInUser">Logged in UserID</param>
        /// <param name="argSkillID">SkillID</param>
        /// <returns></returns>
        [Route("GetAllSubSkills")]
        public IHttpActionResult GetAllSubSkills(int argLoggedInUser, int argSkillID)
        {
            #region Declarations
            SkillBLO l_SkillsBLO = new SkillBLO();
            SubSkillBECollection l_SubSkillCollection = new SubSkillBECollection();
            #endregion
            try
            {
                l_SubSkillCollection = l_SkillsBLO.GetAllSubSkills(argLoggedInUser,argSkillID);

                if (l_SubSkillCollection == null || l_SubSkillCollection.Count == 0)
                {
                    return NotFound();
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }

            return Ok(l_SubSkillCollection);
        }

        /// <summary>
        /// This API is used to save the initial skill request (primary skills)
        /// </summary>
        /// <param name="argLoggedInUser">Logged in User ID</param>
        /// <param name="argInitialRequest">Request Details</param>
        /// <returns></returns>
        [Route("CreateInitialSkillRequest")]
        [HttpPost]
        public IHttpActionResult CreateInitialSkillRequest(string argLoggedInUser, [FromBody]UserInitialSkillRequestBE argInitialRequest)
        {
            #region Declarations
            SkillBLO l_SkillBLO = new SkillBLO();
            #endregion
            try
            {
                l_SkillBLO.CreateInitialRequest(argInitialRequest, argLoggedInUser);
            }
            catch (Exception ex)
            {
                throw ex;
            }

            return Ok();
        }

        /// <summary>
        /// This API is used to save skills & subskills created using Improve Skills option
        /// </summary>
        /// <param name="argLoggedInUser">Logged in user</param>
        /// <param name="argImproveSkills">Skill and Subskill details</param>
        /// <returns></returns>
        [Route("ImproveSkills")]
        [HttpPost]
        public IHttpActionResult ImproveSkills(string argLoggedInUser, [FromBody]ImproveSkillsBE argImproveSkills)
        {
            #region Declarations
            SkillBLO l_SkillBLO = new SkillBLO();
            #endregion
            try
            {
                l_SkillBLO.ImproveSkills(argImproveSkills, argLoggedInUser);
            }
            catch (Exception ex)
            {
                throw ex;
            }

            return Ok();
        }
    }
}