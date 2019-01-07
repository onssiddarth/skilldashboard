using SkillsDashboard.BusinessEntities;
using SkillsDashboard.DAL;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;

namespace SkillsDashboard.BLO
{
    public class SyncUserSkillsBLO
    {
        /// <summary>
        /// Used to sync user required points
        /// </summary>
        /// <returns></returns>
        public void SyncUserRequiredPoints(int argLoggedInUser)
        {
            #region Declarations
            SkillsDBManager l_SkillsDBManager = new SkillsDBManager("SkillsDBConnection");
            List<IDbDataParameter> l_Parameters = new List<IDbDataParameter>();
            #endregion
            try
            {
                //Create Parameters
                l_Parameters.Add(l_SkillsDBManager.CreateParameter(ProcedureParams.LOGGEDINUSERID, argLoggedInUser, DbType.Int32));

                //Call stored procedure
                l_SkillsDBManager.Insert(StoredProcedures.SAV_SYNCUSERREQUIREDPOINTS, CommandType.StoredProcedure, l_Parameters.ToArray());
                
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
    }
}