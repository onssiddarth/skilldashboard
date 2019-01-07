using SkillsDashboard.BusinessEntities;
using SkillsDashboard.DAL;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;

namespace SkillsDashboard.BLO
{
    public class BadgeBLO
    {
        /// <summary>
        /// Get list of users on the basis of name prefix
        /// </summary>
        /// <param name="argLoggedInUser">Logged in user ID</param>
        /// <param name="argNamePrefix">Name prefix for search</param>
        /// <returns></returns>
        public UserDetailsBECollection GetUsersByName(int argLoggedInUser, string argNamePrefix)
        {
            #region Declarations
            UserDetailsBECollection l_UserDetailsBECollection = new UserDetailsBECollection();
            SkillsDBManager l_SkillsDBManager = new SkillsDBManager("SkillsDBConnection");
            List<IDbDataParameter> l_Parameters = new List<IDbDataParameter>();
            DataTable l_UsersDataTable = new DataTable();
            UserDetailsBE l_UserDetailsBE;
            int l_UserCount = 0;
            #endregion
            try
            {
                l_Parameters.Add(l_SkillsDBManager.CreateParameter(ProcedureParams.LOGGEDINUSERID, argLoggedInUser, DbType.Int32));
                l_Parameters.Add(l_SkillsDBManager.CreateParameter(ProcedureParams.NAMEPREFIX, argNamePrefix, DbType.String));
                l_UsersDataTable = l_SkillsDBManager.GetDataTable(StoredProcedures.GET_ALLUSERSBYNAME, CommandType.StoredProcedure, l_Parameters.ToArray());

                if (l_UsersDataTable != null && l_UsersDataTable.Rows.Count > 0)
                {
                    l_UserCount = l_UsersDataTable.Rows.Count;
                    for (int i = 0; i < l_UserCount; i++)
                    {
                        l_UserDetailsBE = new UserDetailsBE();

                        DataRow l_Row = l_UsersDataTable.Rows[i];

                        l_UserDetailsBE.UserName = l_Row["UserName"] == DBNull.Value ? string.Empty : Convert.ToString(l_Row["UserName"]);
                        l_UserDetailsBE.UserID = l_Row["UserID"] == DBNull.Value ? 0 : Convert.ToInt32(l_Row["UserID"]);

                        l_UserDetailsBECollection.Add(l_UserDetailsBE);

                    }
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return l_UserDetailsBECollection;
        }

        /// <summary>
        /// Get badge details in system
        /// </summary>
        /// <param name="argLoggedInUser">Logged in user ID</param>
        /// <param name="argBadgeType">Badge Type</param>
        /// <returns></returns>
        public BadgeBECollection GetBadges(int argLoggedInUser, string argBadgeType)
        {
            #region Declarations
            BadgeBECollection l_BadgeBECollection = new BadgeBECollection();
            SkillsDBManager l_SkillsDBManager = new SkillsDBManager("SkillsDBConnection");
            List<IDbDataParameter> l_Parameters = new List<IDbDataParameter>();
            DataTable l_BadgeDataTable = new DataTable();
            BadgeBE l_BadgeBE;
            int l_BadgeCount = 0;
            #endregion
            try
            {
                l_Parameters.Add(l_SkillsDBManager.CreateParameter(ProcedureParams.LOGGEDINUSERID, argLoggedInUser, DbType.Int32));

                if(string.IsNullOrEmpty(argBadgeType))
                {
                    l_Parameters.Add(l_SkillsDBManager.CreateParameter(ProcedureParams.TYPE, DBNull.Value, DbType.String));
                }
                else
                {
                    l_Parameters.Add(l_SkillsDBManager.CreateParameter(ProcedureParams.TYPE, argBadgeType, DbType.String));
                }
                
                l_BadgeDataTable = l_SkillsDBManager.GetDataTable(StoredProcedures.GET_ALLBADGES, CommandType.StoredProcedure, l_Parameters.ToArray());

                if (l_BadgeDataTable != null && l_BadgeDataTable.Rows.Count > 0)
                {
                    l_BadgeCount = l_BadgeDataTable.Rows.Count;
                    for (int i = 0; i < l_BadgeCount; i++)
                    {
                        l_BadgeBE = new BadgeBE();

                        DataRow l_Row = l_BadgeDataTable.Rows[i];

                        l_BadgeBE.BadgeName = l_Row["BadgeName"] == DBNull.Value ? string.Empty : Convert.ToString(l_Row["BadgeName"]);
                        l_BadgeBE.BadgeID = l_Row["BadgeID"] == DBNull.Value ? 0 : Convert.ToInt32(l_Row["BadgeID"]);
                        l_BadgeBE.BadgeURL = l_Row["BadgeImageURL"] == DBNull.Value ? string.Empty : Convert.ToString(l_Row["BadgeImageURL"]);

                        l_BadgeBECollection.Add(l_BadgeBE);

                    }
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
            return l_BadgeBECollection;
        }

        /// <summary>
        /// Save badge given by user
        /// </summary>
        /// <param name="argLoggedInUser">Logged in user ID</param>
        /// <param name="argSaveBadgeBE">Badge Details to save</param>
        /// <returns></returns>
        public void SaveBadgeForUser(int argLoggedInUser, SaveBadgeBE argSaveBadgeBE)
        {
            #region Declarations
            SkillsDBManager l_SkillsDBManager = new SkillsDBManager("SkillsDBConnection");
            List<IDbDataParameter> l_Parameters = new List<IDbDataParameter>();
            int l_LastID = 0;
            #endregion
            try
            {
                if (argSaveBadgeBE != null)
                {
                    //Create Parameters
                    l_Parameters.Add(l_SkillsDBManager.CreateParameter(ProcedureParams.LOGGEDINUSERID, argLoggedInUser, DbType.Int32));
                    l_Parameters.Add(l_SkillsDBManager.CreateParameter(ProcedureParams.BADGEGIVENTO, argSaveBadgeBE.BadgeGivenTo, DbType.Int32));
                    l_Parameters.Add(l_SkillsDBManager.CreateParameter(ProcedureParams.BADGEID, argSaveBadgeBE.BadgeID, DbType.Int32));
                    l_Parameters.Add(l_SkillsDBManager.CreateParameter(ProcedureParams.COMMENTS, argSaveBadgeBE.Comments, DbType.String));
                    l_Parameters.Add(l_SkillsDBManager.CreateParameter(ProcedureParams.TYPE, argSaveBadgeBE.Type, DbType.String));

                    //Call stored procedure
                    l_SkillsDBManager.Insert(StoredProcedures.SAVE_USERBADGE, CommandType.StoredProcedure, l_Parameters.ToArray(), out l_LastID);
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        /// <summary>
        /// Modify the badge status by manager
        /// </summary>
        /// <param name="argLoggedInUser">Logged in user ID</param>
        /// <param name="argSaveBadgeBE">Badge Details</param>
        /// <returns></returns>
        public void ApproveBadge(int argLoggedInUser, SaveBadgeBE argSaveBadgeBE)
        {
            #region Declarations
            SkillsDBManager l_SkillsDBManager = new SkillsDBManager("SkillsDBConnection");
            List<IDbDataParameter> l_Parameters = new List<IDbDataParameter>();
            #endregion
            try
            {
                if (argSaveBadgeBE != null)
                {
                    //Create Parameters
                    l_Parameters.Add(l_SkillsDBManager.CreateParameter(ProcedureParams.LOGGEDINUSERID, argLoggedInUser, DbType.Int32));
                    l_Parameters.Add(l_SkillsDBManager.CreateParameter(ProcedureParams.USERBADGEID, argSaveBadgeBE.UserBadgeID, DbType.Int32));
                    l_Parameters.Add(l_SkillsDBManager.CreateParameter(ProcedureParams.COMMENTS, argSaveBadgeBE.Comments, DbType.String));
                    l_Parameters.Add(l_SkillsDBManager.CreateParameter(ProcedureParams.STATUS, argSaveBadgeBE.Status, DbType.String));


                    //Call stored procedure
                    l_SkillsDBManager.Update(StoredProcedures.SAVE_APPROVEBADGE, CommandType.StoredProcedure, l_Parameters.ToArray());
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
    }
}