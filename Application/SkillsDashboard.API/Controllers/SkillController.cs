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
    [Route("api/Skills")]
    public class SkillController : ApiController
    {
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