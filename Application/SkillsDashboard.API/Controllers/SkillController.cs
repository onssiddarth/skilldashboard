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
    public class SkillController : ApiController
    {
        // GET: Skill
        //public ActionResult Index()
        //{
        //    return View();
        //}

        public IHttpActionResult GetAllSkills(int argLoggedInUser)
        {
            #region Declarations
            SkillsBLO l_SkillsBLO = new SkillsBLO();
            SkillCollection l_SkillCollection = new SkillCollection();
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
                throw;
            }

            return Ok(l_SkillCollection);
        }

        public IHttpActionResult GetAllSubSkills(int argLoggedInUser, int argSkillID)
        {
            #region Declarations
            SkillsBLO l_SkillsBLO = new SkillsBLO();
            SubSkillCollection l_SubSkillCollection = new SubSkillCollection();
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
                throw;
            }

            return Ok(l_SubSkillCollection);
        }
    }
}