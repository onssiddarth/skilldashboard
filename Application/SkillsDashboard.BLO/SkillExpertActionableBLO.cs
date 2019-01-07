using SkillsDashboard.BusinessEntities;
using SkillsDashboard.DAL;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;

namespace SkillsDashboard.BLO
{
    public class SkillExpertActionableBLO
    {
        /// <summary>
        /// Used to get list of pending approvals for skill expert
        /// </summary>
        /// <param name="argLoggedInUser">Logged in User ID</param>
        /// <param name="argType">Request Type</param>
        /// <returns></returns>
        public PendingSkillExpertApprovalBECollection GetPendingSkillExpertApprovals(int argLoggedInUser, string argType)
        {
            #region Declarations
            PendingSkillExpertApprovalBECollection l_requestCollection = new PendingSkillExpertApprovalBECollection();
            SkillsDBManager l_SkillsDBManager = new SkillsDBManager("SkillsDBConnection");
            List<IDbDataParameter> l_Parameters = new List<IDbDataParameter>();
            DataTable l_SkillDataTable = new DataTable();
            PendingSkillExpertApprovalBE l_RequestBE;
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

                l_SkillDataTable = l_SkillsDBManager.GetDataTable(StoredProcedures.GET_ALLPENDINGSKILLEXPERTAPPROVALS, CommandType.StoredProcedure, l_Parameters.ToArray());

                if (l_SkillDataTable != null && l_SkillDataTable.Rows.Count > 0)
                {
                    l_SkillCount = l_SkillDataTable.Rows.Count;
                    for (int i = 0; i < l_SkillCount; i++)
                    {
                        l_RequestBE = new PendingSkillExpertApprovalBE();

                        DataRow l_Row = l_SkillDataTable.Rows[i];

                        l_RequestBE.RequestType = l_Row["Request type"] == DBNull.Value ? string.Empty : Convert.ToString(l_Row["Request type"]);
                        l_RequestBE.Status = l_Row["Status"] == DBNull.Value ? string.Empty : Convert.ToString(l_Row["Status"]);
                        l_RequestBE.ManagerComments = l_Row["ManagerComments"] == DBNull.Value ? string.Empty : Convert.ToString(l_Row["ManagerComments"]);
                        l_RequestBE.SkillExpertComments = l_Row["SkillExpertComments"] == DBNull.Value ? string.Empty : Convert.ToString(l_Row["SkillExpertComments"]);
                        l_RequestBE.UserComments = l_Row["UserComments"] == DBNull.Value ? string.Empty : Convert.ToString(l_Row["UserComments"]);
                        l_RequestBE.RequestedDate = l_Row["Request date"] == DBNull.Value ? DateTime.Now : Convert.ToDateTime(l_Row["Request date"]);
                        l_RequestBE.SkillName = l_Row["SkillName"] == DBNull.Value ? string.Empty : Convert.ToString(l_Row["SkillName"]);
                        l_RequestBE.SubSkillName = l_Row["SubskillName"] == DBNull.Value ? string.Empty : Convert.ToString(l_Row["SubskillName"]);
                        l_RequestBE.SkillPoints = l_Row["SkillPoints"] == DBNull.Value ? 0 : Convert.ToInt32(l_Row["SkillPoints"]);
                        l_RequestBE.UniqueID = l_Row["UniqueID"] == DBNull.Value ? 0 : Convert.ToInt32(l_Row["UniqueID"]);
                        l_RequestBE.SubSkillName = l_Row["SubskillName"] == DBNull.Value ? string.Empty : Convert.ToString(l_Row["SubskillName"]);
                        l_RequestBE.FileName = l_Row["FileName"] == DBNull.Value ? string.Empty : Convert.ToString(l_Row["FileName"]);
                        l_RequestBE.FileGUID = l_Row["FileGUID"] == DBNull.Value ? string.Empty : Convert.ToString(l_Row["FileGUID"]);
                        l_RequestBE.RequestedBy = l_Row["UserName"] == DBNull.Value ? string.Empty : Convert.ToString(l_Row["UserName"]);
                        l_RequestBE.Room = l_Row["Room"] == DBNull.Value ? string.Empty : Convert.ToString(l_Row["Room"]);
                        l_RequestBE.DemoSchedule = l_Row["DemoSchedule"] == DBNull.Value ? (DateTime?)null : Convert.ToDateTime(l_Row["DemoSchedule"]);
                        l_RequestBE.RequestCode = l_Row["RequestCode"] == DBNull.Value ? string.Empty : Convert.ToString(l_Row["RequestCode"]);

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
        /// Used to save skill expert action (APPROVE/REJECT)
        /// </summary>
        /// <param name="argLoggedInUser">Logged in user ID</param>
        /// <param name="argSkillExpertApprovalBE">Skill expert approval details</param>
        /// <returns></returns>
        public void SaveSkillExpertApprovals(int argLoggedInUser, SkillExpertApprovalBE argSkillExpertApprovalBE)
        {
            #region Declarations
            SkillsDBManager l_SkillsDBManager = new SkillsDBManager("SkillsDBConnection");
            List<IDbDataParameter> l_Parameters = new List<IDbDataParameter>();
            #endregion
            try
            {
                if (argSkillExpertApprovalBE != null)
                {
                    //Create Parameters
                    l_Parameters.Add(l_SkillsDBManager.CreateParameter(ProcedureParams.LOGGEDINUSERID, argLoggedInUser, DbType.Int32));
                    l_Parameters.Add(l_SkillsDBManager.CreateParameter(ProcedureParams.TYPE, argSkillExpertApprovalBE.Type, DbType.String));
                    l_Parameters.Add(l_SkillsDBManager.CreateParameter(ProcedureParams.UNIQUEID, argSkillExpertApprovalBE.UniqueID, DbType.Int32));
                    l_Parameters.Add(l_SkillsDBManager.CreateParameter(ProcedureParams.COMMENTS, argSkillExpertApprovalBE.Comments, DbType.String));
                    l_Parameters.Add(l_SkillsDBManager.CreateParameter(ProcedureParams.STATUS, argSkillExpertApprovalBE.Status, DbType.String));

                    //Call stored procedure
                    l_SkillsDBManager.Update(StoredProcedures.SAVE_SKILLEXPERTACTION, CommandType.StoredProcedure, l_Parameters.ToArray());
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        /// <summary>
        /// Used to save Schedule Demo by skill expert
        /// </summary>
        /// <param name="argLoggedInUser">Logged in user ID</param>
        /// <param name="argScheduleDemoBE">Demo details</param>
        /// <returns></returns>
        public void ScheduleDemo(int argLoggedInUser, ScheduleDemoBE argScheduleDemoBE)
        {
            #region Declarations
            SkillsDBManager l_SkillsDBManager = new SkillsDBManager("SkillsDBConnection");
            List<IDbDataParameter> l_Parameters = new List<IDbDataParameter>();
            #endregion
            try
            {
                if (argScheduleDemoBE != null)
                {
                    //Create Parameters
                    l_Parameters.Add(l_SkillsDBManager.CreateParameter(ProcedureParams.LOGGEDINUSERID, argLoggedInUser, DbType.Int32));
                    l_Parameters.Add(l_SkillsDBManager.CreateParameter(ProcedureParams.DEMOSCHEDULE, argScheduleDemoBE.DemoSchedule, DbType.DateTime));
                    l_Parameters.Add(l_SkillsDBManager.CreateParameter(ProcedureParams.UNIQUEID, argScheduleDemoBE.UniqueID, DbType.Int32));
                    l_Parameters.Add(l_SkillsDBManager.CreateParameter(ProcedureParams.COMMENTS, argScheduleDemoBE.Comments, DbType.String));
                    l_Parameters.Add(l_SkillsDBManager.CreateParameter(ProcedureParams.ROOM, argScheduleDemoBE.Room, DbType.String));

                    //Call stored procedure
                    l_SkillsDBManager.Update(StoredProcedures.SAVE_SCHEDULEDEMO, CommandType.StoredProcedure, l_Parameters.ToArray());
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
    }
}