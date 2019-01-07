using SkillsDashboard.BusinessEntities;
using SkillsDashboard.DAL;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;

namespace SkillsDashboard.BLO
{
    public class QueryBLO
    {
        /// <summary>
        /// Used to get list of experts with required skills and subskills
        /// </summary>
        /// <param name="argLoggedInUser">Logged in User ID</param>
        /// <param name="argSkillID">Skill ID</param>
        /// <param name="argSubSkillID">SubSkill ID</param>
        /// <returns></returns>
        public QueryBECollection GetEmployeesBasedOnSkillAndSubskill(int argLoggedInUser, int argSkillID, int argSubSkillID)
        {
            #region Declarations
            QueryBECollection l_QueryBECollection = new QueryBECollection();
            SkillsDBManager l_SkillsDBManager = new SkillsDBManager("SkillsDBConnection");
            List<IDbDataParameter> l_Parameters = new List<IDbDataParameter>();
            DataTable l_QueryDataTable = new DataTable();
            QueryBE l_Query;
            int l_QueryResultCount = 0;
            #endregion
            try
            {
                l_Parameters.Add(l_SkillsDBManager.CreateParameter(ProcedureParams.LOGGEDINUSERID, argLoggedInUser, DbType.Int32));
                l_Parameters.Add(l_SkillsDBManager.CreateParameter(ProcedureParams.SKILLID, argSkillID, DbType.Int32));
                l_Parameters.Add(l_SkillsDBManager.CreateParameter(ProcedureParams.SUBSKILLID, argSubSkillID, DbType.Int32));

                l_QueryDataTable = l_SkillsDBManager.GetDataTable(StoredProcedures.GET_EMPLOYEESFORASKILLSUBSKILL, CommandType.StoredProcedure, l_Parameters.ToArray());

                if (l_QueryDataTable != null && l_QueryDataTable.Rows.Count > 0)
                {
                    l_QueryResultCount = l_QueryDataTable.Rows.Count;
                    for (int i = 0; i < l_QueryResultCount; i++)
                    {
                        l_Query = new QueryBE();

                        DataRow l_Row = l_QueryDataTable.Rows[i];

                        l_Query.Name = l_Row["Employee Name"] == DBNull.Value ? string.Empty : Convert.ToString(l_Row["Employee Name"]);
                        l_Query.Email = l_Row["Email"] == DBNull.Value ? string.Empty : Convert.ToString(l_Row["Email"]);
                        l_Query.ContactNumber = l_Row["Contact Number"] == DBNull.Value ? string.Empty : Convert.ToString(l_Row["Contact Number"]);
                        l_Query.SkillPoints = l_Row["Skill Points"] == DBNull.Value ? 0 : Convert.ToInt32(l_Row["Skill Points"]);

                        l_QueryBECollection.Add(l_Query);

                    }
                }
            }
            catch (Exception ex)
            {
                throw;
            }
            return l_QueryBECollection;
        }
    }
}