using SkillsDashboard.BusinessEntities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using SkillsDashboard.DAL;
using System.Data;

namespace SkillsDashboard.BLO
{
    public class SkillsBLO
    {
        public SkillCollection GetAllSkills(string argLoggedInUser)
        {
            #region Declarations
            SkillCollection l_skillCollection = new SkillCollection();
            SkillsDBManager l_SkillsDBManager = new SkillsDBManager("SkillsDBConnection");
            List<IDbDataParameter> l_Parameters = new List<IDbDataParameter>();
            DataTable l_SkillDataTable = new DataTable();
            Skill l_Skill;
            int l_SkillCount = 0;
            #endregion
            try
            {
                l_Parameters.Add(l_SkillsDBManager.CreateParameter(ProcedureParams.LOGGEDINUSERID, argLoggedInUser, DbType.String));

                l_SkillDataTable = l_SkillsDBManager.GetDataTable(StoredProcedures.GET_ALLSKILLS_AVAILABLE, CommandType.StoredProcedure, l_Parameters.ToArray());

                if (l_SkillDataTable != null && l_SkillDataTable.Rows.Count > 0)
                {
                    l_SkillCount = l_SkillDataTable.Rows.Count;
                    for (int i = 0; i < l_SkillCount; i++)
                    {
                        l_Skill = new Skill();

                        DataRow l_Row = l_SkillDataTable.Rows[i];

                        l_Skill.SkillID = l_Row["SkillID"] == DBNull.Value ? 0 : Convert.ToInt32(l_Row["SkillID"]);
                        l_Skill.SkillName = l_Row["SkillName"] == DBNull.Value ? string.Empty : Convert.ToString(l_Row["SkillName"]);

                        l_skillCollection.Add(l_Skill);

                    }
                }
            }
            catch (Exception ex)
            {
                throw;
            }
            return l_skillCollection;
        }

        public SubSkillCollection GetAllSubSkills(string argLoggedInUser, int argSkillID)
        {
            #region Declarations
            SubSkillCollection l_SubSkillCollection = new SubSkillCollection();
            SkillsDBManager l_SkillsDBManager = new SkillsDBManager("SkillsDBConnection");
            List<IDbDataParameter> l_Parameters = new List<IDbDataParameter>();
            DataTable l_SubSkillDataTable = new DataTable();
            SubSkill l_SubSkill;
            int l_SubSkillCount = 0;
            #endregion
            try
            {
                l_Parameters.Add(l_SkillsDBManager.CreateParameter(ProcedureParams.LOGGEDINUSERID, argLoggedInUser, DbType.String));
                l_Parameters.Add(l_SkillsDBManager.CreateParameter(ProcedureParams.SKILLID, argSkillID, DbType.Int32));

                l_SubSkillDataTable = l_SkillsDBManager.GetDataTable(StoredProcedures.GET_ALLSUBSKILLS_FORASKILL, CommandType.StoredProcedure, l_Parameters.ToArray());

                if (l_SubSkillDataTable != null && l_SubSkillDataTable.Rows.Count > 0)
                {
                    l_SubSkillCount = l_SubSkillDataTable.Rows.Count;
                    for (int i = 0; i < l_SubSkillCount; i++)
                    {
                        l_SubSkill = new SubSkill();

                        DataRow l_Row = l_SubSkillDataTable.Rows[i];

                        l_SubSkill.SkillID = l_Row["SkillID"] == DBNull.Value ? 0 : Convert.ToInt32(l_Row["SkillID"]);
                        l_SubSkill.SubSkillID = l_Row["SubskillID"] == DBNull.Value ? 0 : Convert.ToInt32(l_Row["SubskillID"]);
                        l_SubSkill.SubSkillName = l_Row["SubskillName"] == DBNull.Value ? string.Empty : Convert.ToString(l_Row["SubskillName"]);

                        l_SubSkillCollection.Add(l_SubSkill);

                    }
                }
            }
            catch (Exception ex)
            {
                throw;
            }
            return l_SubSkillCollection;
        }
    }
}