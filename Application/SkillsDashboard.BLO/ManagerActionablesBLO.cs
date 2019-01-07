using SkillsDashboard.BusinessEntities;
using SkillsDashboard.DAL;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;

namespace SkillsDashboard.BLO
{
    public class ManagerActionablesBLO
    {
        /// <summary>
        /// Get the list of pending manager approvals
        /// </summary>
        /// <param name="argLoggedInUser">Logged in user ID</param>
        /// <param name="argType">Request Type</param>
        /// <returns></returns>
        public PendingManagerApprovalsBECollection GetPendingManagerApprovals(int argLoggedInUser, string argType)
        {
            #region Declarations
            PendingManagerApprovalsBECollection l_requestCollection = new PendingManagerApprovalsBECollection();
            SkillsDBManager l_SkillsDBManager = new SkillsDBManager("SkillsDBConnection");
            List<IDbDataParameter> l_Parameters = new List<IDbDataParameter>();
            DataTable l_SkillDataTable = new DataTable();
            PendingManagerApprovalsBE l_RequestBE;
            int l_SkillCount = 0;
            #endregion
            try
            {
                l_Parameters.Add(l_SkillsDBManager.CreateParameter(ProcedureParams.LOGGEDINUSERID, argLoggedInUser, DbType.Int32));

                if (string.IsNullOrEmpty(argType))
                {
                    l_Parameters.Add(l_SkillsDBManager.CreateParameter(ProcedureParams.TYPE, DBNull.Value, DbType.String));
                }
                else
                {
                    l_Parameters.Add(l_SkillsDBManager.CreateParameter(ProcedureParams.TYPE, argType, DbType.String));
                }


                l_SkillDataTable = l_SkillsDBManager.GetDataTable(StoredProcedures.GET_ALLPENDINGMANAGERAPPROVALS, CommandType.StoredProcedure, l_Parameters.ToArray());

                if (l_SkillDataTable != null && l_SkillDataTable.Rows.Count > 0)
                {
                    l_SkillCount = l_SkillDataTable.Rows.Count;
                    for (int i = 0; i < l_SkillCount; i++)
                    {
                        l_RequestBE = new PendingManagerApprovalsBE();

                        DataRow l_Row = l_SkillDataTable.Rows[i];

                        l_RequestBE.RequestType = l_Row["Request type"] == DBNull.Value ? string.Empty : Convert.ToString(l_Row["Request type"]);
                        l_RequestBE.Status = l_Row["Status"] == DBNull.Value ? string.Empty : Convert.ToString(l_Row["Status"]);
                        l_RequestBE.Comments = l_Row["Comments"] == DBNull.Value ? string.Empty : Convert.ToString(l_Row["Comments"]);
                        l_RequestBE.RequestedDate = l_Row["Request date"] == DBNull.Value ? DateTime.Now : Convert.ToDateTime(l_Row["Request date"]);
                        l_RequestBE.SkillName = l_Row["SkillName"] == DBNull.Value ? string.Empty : Convert.ToString(l_Row["SkillName"]);
                        l_RequestBE.SubSkillName = l_Row["SubskillName"] == DBNull.Value ? string.Empty : Convert.ToString(l_Row["SubskillName"]);
                        l_RequestBE.SkillPoints = l_Row["SkillPoints"] == DBNull.Value ? 0 : Convert.ToInt32(l_Row["SkillPoints"]);
                        l_RequestBE.UniqueID = l_Row["UniqueID"] == DBNull.Value ? 0 : Convert.ToInt32(l_Row["UniqueID"]);
                        l_RequestBE.SubSkillName = l_Row["SubskillName"] == DBNull.Value ? string.Empty : Convert.ToString(l_Row["SubskillName"]);
                        l_RequestBE.FileName = l_Row["FileName"] == DBNull.Value ? string.Empty : Convert.ToString(l_Row["FileName"]);
                        l_RequestBE.FileGUID = l_Row["FileGUID"] == DBNull.Value ? string.Empty : Convert.ToString(l_Row["FileGUID"]);
                        l_RequestBE.RequestedBy = l_Row["UserName"] == DBNull.Value ? string.Empty : Convert.ToString(l_Row["UserName"]);
                        l_RequestBE.RequestCode = l_Row["RequestCode"] == DBNull.Value ? string.Empty : Convert.ToString(l_Row["RequestCode"]);

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

        /// <summary>
        /// Used to save manager action (APPROVE/REJECT)
        /// </summary>
        /// <param name="argLoggedInUser">Logged in user ID</param>
        /// <param name="argManagerApprovalBE">Manager approval details</param>
        /// <returns></returns>
        public void SaveManagerApprovals(int argLoggedInUser, ManagerApprovalBE argManagerApproval)
        {
            #region Declarations
            SkillsDBManager l_SkillsDBManager = new SkillsDBManager("SkillsDBConnection");
            List<IDbDataParameter> l_Parameters = new List<IDbDataParameter>();
            #endregion
            try
            {
                if (argManagerApproval != null)
                {
                    //Create Parameters
                    l_Parameters.Add(l_SkillsDBManager.CreateParameter(ProcedureParams.LOGGEDINUSERID, argLoggedInUser, DbType.Int32));
                    l_Parameters.Add(l_SkillsDBManager.CreateParameter(ProcedureParams.TYPE, argManagerApproval.Type, DbType.String));
                    l_Parameters.Add(l_SkillsDBManager.CreateParameter(ProcedureParams.UNIQUEID, argManagerApproval.UniqueID, DbType.Int32));
                    l_Parameters.Add(l_SkillsDBManager.CreateParameter(ProcedureParams.COMMENTS, argManagerApproval.Comments, DbType.String));
                    l_Parameters.Add(l_SkillsDBManager.CreateParameter(ProcedureParams.STATUS, argManagerApproval.Status, DbType.String));

                    //Call stored procedure
                    l_SkillsDBManager.Update(StoredProcedures.SAVE_MANAGERACTION, CommandType.StoredProcedure, l_Parameters.ToArray());
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
    }

}