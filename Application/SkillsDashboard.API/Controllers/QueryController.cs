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
    [Route("api/Query")]
    public class QueryController : ApiController
    {
        // GET: Query
        [Route("GetQueryResults")]
        public IHttpActionResult GetQueryResults(int argLoggedInUser, int argSkillID, int argSubSkillID)
        {
            #region Declarations
            QueryBLO l_QueryBLO = new QueryBLO();
            QueryBECollection l_QueryBECollection = new QueryBECollection();
            #endregion
            try
            {
                l_QueryBECollection = l_QueryBLO.GetEmployeesBasedOnSkillAndSubskill(argLoggedInUser, argSkillID, argSubSkillID);

                if (l_QueryBECollection == null || l_QueryBECollection.Count == 0)
                {
                    return NotFound();
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }

            return Ok(l_QueryBECollection);
        }
    }
}