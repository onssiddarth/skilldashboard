using SkillsDashboard.BusinessEntities;
using SkillsDashboard.DAL;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;

namespace SkillsDashboard.BLO
{
    public class UserRequestsBLO
    {
        /// <summary>
        /// Used to get the list of requests made by user along with their status
        /// </summary>
        /// <param name="argLoggedInUser">Logged in User ID</param>
        /// <param name="argType">Request Type</param>
        /// <returns></returns>
        public UserRequestsBECollection GetUserSkillRequests(int argLoggedInUser, string argType)
        {
            #region Declarations
            UserRequestsBECollection l_requestCollection = new UserRequestsBECollection();
            SkillsDBManager l_SkillsDBManager = new SkillsDBManager("SkillsDBConnection");
            List<IDbDataParameter> l_Parameters = new List<IDbDataParameter>();
            DataTable l_SkillDataTable = new DataTable();
            UserRequestsBE l_RequestBE;
            int l_SkillCount = 0;
            #endregion
            try
            {
                l_Parameters.Add(l_SkillsDBManager.CreateParameter(ProcedureParams.LOGGEDINUSERID, argLoggedInUser, DbType.Int32));

                if(string.IsNullOrEmpty(argType))
                {
                    l_Parameters.Add(l_SkillsDBManager.CreateParameter(ProcedureParams.TYPE, DBNull.Value, DbType.String));
                }
                else
                {
                    l_Parameters.Add(l_SkillsDBManager.CreateParameter(ProcedureParams.TYPE, argType, DbType.String));
                }
                

                l_SkillDataTable = l_SkillsDBManager.GetDataTable(StoredProcedures.GET_ALLSKILLREQUESTS, CommandType.StoredProcedure, l_Parameters.ToArray());

                if (l_SkillDataTable != null && l_SkillDataTable.Rows.Count > 0)
                {
                    l_SkillCount = l_SkillDataTable.Rows.Count;
                    for (int i = 0; i < l_SkillCount; i++)
                    {
                        l_RequestBE = new UserRequestsBE();

                        DataRow l_Row = l_SkillDataTable.Rows[i];

                        l_RequestBE.RequestType = l_Row["Request type"] == DBNull.Value ? string.Empty : Convert.ToString(l_Row["Request type"]);
                        l_RequestBE.Status = l_Row["Status"] == DBNull.Value ? string.Empty : Convert.ToString(l_Row["Status"]);
                        l_RequestBE.Comments = l_Row["Comments"] == DBNull.Value ? string.Empty : Convert.ToString(l_Row["Comments"]);
                        l_RequestBE.RequestedDate = l_Row["Request date"] == DBNull.Value ? DateTime.Now : Convert.ToDateTime(l_Row["Request date"]);
                        l_RequestBE.Skill = l_Row["Skill"] == DBNull.Value ? string.Empty : Convert.ToString(l_Row["Skill"]);
                        l_RequestBE.SubSkill = l_Row["Sub-skill"] == DBNull.Value ? string.Empty : Convert.ToString(l_Row["Sub-skill"]);

                        //Badge Details
                        l_RequestBE.BadgeGivenFor = l_Row["BadgeGivenFor"] == DBNull.Value ? string.Empty : Convert.ToString(l_Row["BadgeGivenFor"]);
                        l_RequestBE.BadgeName = l_Row["BadgeName"] == DBNull.Value ? string.Empty : Convert.ToString(l_Row["BadgeName"]);
                        l_RequestBE.BadgeImageURL = l_Row["BadgeImageURL"] == DBNull.Value ? string.Empty : Convert.ToString(l_Row["BadgeImageURL"]);
                        l_RequestBE.BadgeID = l_Row["BadgeID"] == DBNull.Value ? 0 : Convert.ToInt32(l_Row["BadgeID"]);

                        l_requestCollection.Add(l_RequestBE);

                    }
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return l_requestCollection;
        }
    }
}