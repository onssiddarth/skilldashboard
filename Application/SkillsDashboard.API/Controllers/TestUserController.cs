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
    public class TestUserController : ApiController
    {
        /// <summary>
        /// Get list of all test users
        /// </summary>
        /// <param name="argLoggedInUser"></param>
        /// <returns></returns>
        public IHttpActionResult GetAllUsers(string argLoggedInUser)
        {
            #region Declarations
            TestUserBLO l_TestUserBLO = new TestUserBLO();
            TestUserBECollection l_TestUserBECollection = new TestUserBECollection();
            #endregion
            try
            {
                l_TestUserBECollection = l_TestUserBLO.GetAllTestUsers(argLoggedInUser);

                if(l_TestUserBECollection == null || l_TestUserBECollection.Count == 0)
                {
                    return NotFound();
                }
            }
            catch (Exception ex)
            {
                throw;
            }

            return Ok(l_TestUserBECollection);
        }

        /// <summary>
        /// Insert new User
        /// </summary>
        /// <param name="argLoggedInUser"></param>
        /// <param name="argTestUser"></param>
        /// <returns></returns>
        [HttpPost]
        public IHttpActionResult SaveTestUser(string argLoggedInUser, [FromBody]TestUser argTestUser)
        {
            #region Declarations
            TestUserBLO l_TestUserBLO = new TestUserBLO();
            #endregion
            try
            {
                l_TestUserBLO.InsertUser(argTestUser, argLoggedInUser);
               
            }
            catch (Exception ex)
            {
                throw;
            }

            return Ok();
        }

    }
}
