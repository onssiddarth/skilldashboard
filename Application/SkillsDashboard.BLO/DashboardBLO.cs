using SkillsDashboard.BusinessEntities;
using SkillsDashboard.DAL;
using System;
using System.Collections.Generic;
using System.Data;
using System.Linq;
using System.Web;
using System.Xml.Linq;

namespace SkillsDashboard.BLO
{
    public class DashboardBLO
    {
        /// <summary>
        /// Get dashboard data for user
        /// </summary>
        /// <param name="argLoggedInUser">Logged in user ID</param>
        /// <param name="argUserID">User for whom dashboard details should be loaded</param>
        /// <returns></returns>
        public DashboardBE GetDashboardDetails(int argLoggedInUser, int argUserID)
        {
            #region Declarations
            DashboardBE l_DashboardBE = new DashboardBE();
            SkillsDBManager l_SkillsDBManager = new SkillsDBManager("SkillsDBConnection");
            List<IDbDataParameter> l_Parameters = new List<IDbDataParameter>();
            DataSet l_DashboardDataset = new DataSet();
            DataTable l_SkillTable = new DataTable();
            DataTable l_SubSkillTable = new DataTable();
            DataTable l_DemoDetailsTable = new DataTable();
            DataTable l_BadgeDetailsTable = new DataTable();
            DataTable l_UserDetailsTable = new DataTable();
            SkillsBECollection l_skillsBECollection = new SkillsBECollection();
            ScheduleDemoBECollection l_ScheduleDemoBECollection = new ScheduleDemoBECollection();
            ScheduleDemoBE l_ScheduleDemoBE;
            BadgeBECollection l_BadgeBECollection = new BadgeBECollection();
            BadgeBE l_BadgeBE;
            SkillsBE l_SkillsBE;
            #endregion
            try
            {
                l_Parameters.Add(l_SkillsDBManager.CreateParameter(ProcedureParams.LOGGEDINUSERID, argLoggedInUser, DbType.Int32));
                l_Parameters.Add(l_SkillsDBManager.CreateParameter(ProcedureParams.USERID, argUserID, DbType.Int32));

                l_DashboardDataset = l_SkillsDBManager.GetDataSet(StoredProcedures.GET_DASHBOARDDETAILS, CommandType.StoredProcedure, l_Parameters.ToArray());

                if(l_DashboardDataset!=null && l_DashboardDataset.Tables.Count > 0)
                {
                    l_UserDetailsTable = l_DashboardDataset.Tables[0];
                    l_SkillTable = l_DashboardDataset.Tables[1];
                    l_SubSkillTable = l_DashboardDataset.Tables[2];

                    //Get UserDetails
                    if(l_UserDetailsTable!=null && l_UserDetailsTable.Rows.Count > 0)
                    {
                        l_DashboardBE.UserID = l_UserDetailsTable.Rows[0]["UserID"] == DBNull.Value ? 0 : Convert.ToInt32(l_UserDetailsTable.Rows[0]["UserID"]);
                        l_DashboardBE.UserName = l_UserDetailsTable.Rows[0]["UserName"] == DBNull.Value ? string.Empty : Convert.ToString(l_UserDetailsTable.Rows[0]["UserName"]);
                        l_DashboardBE.EmailID = l_UserDetailsTable.Rows[0]["EmailID"] == DBNull.Value ? string.Empty : Convert.ToString(l_UserDetailsTable.Rows[0]["EmailID"]);
                        l_DashboardBE.InitialSkillExists = l_UserDetailsTable.Rows[0]["InitialSkillExists"] == DBNull.Value ? false : Convert.ToBoolean(l_UserDetailsTable.Rows[0]["InitialSkillExists"]);
                    }

                    //Get skill and subskill
                        if (l_SkillTable!=null && l_SkillTable.Rows.Count > 0)
                    {
                        for(int i=0; i<l_SkillTable.Rows.Count;i++)
                        {
                            l_SkillsBE = new SkillsBE();
                            DataRow l_Row = l_SkillTable.Rows[i];
                            l_SkillsBE.SkillID = l_Row["SkillID"] == DBNull.Value ? 0 : Convert.ToInt32(l_Row["SkillID"]);
                            l_SkillsBE.SkillName = l_Row["SkillName"] == DBNull.Value ? string.Empty : Convert.ToString(l_Row["SkillName"]);
                            l_SkillsBE.SkillPoints = l_Row["SkillPoints"] == DBNull.Value ? 0 : Convert.ToInt32(l_Row["SkillPoints"]);
                            l_SkillsBE.SkillType = l_Row["SkillType"] == DBNull.Value ? string.Empty : Convert.ToString(l_Row["SkillType"]);
                            l_SkillsBE.SubSkillBECollection = GetSubSkillData(l_SkillsBE.SkillID, l_SubSkillTable, l_SkillsBE.SkillType);
                            l_skillsBECollection.Add(l_SkillsBE);
                        }

                        l_DashboardBE.SkillsBECollection = l_skillsBECollection;
                    }

                    //Get badge data
                    l_BadgeDetailsTable = l_DashboardDataset.Tables[3];
                    if(l_BadgeDetailsTable != null && l_BadgeDetailsTable.Rows.Count > 0)
                    {
                        for (int i = 0; i < l_BadgeDetailsTable.Rows.Count; i++)
                        {
                            DataRow l_Row = l_BadgeDetailsTable.Rows[i];
                            l_BadgeBE = new BadgeBE();

                            l_BadgeBE.BadgeID = l_Row["BadgeID"] == DBNull.Value ? 0 : Convert.ToInt32(l_Row["BadgeID"]);
                            l_BadgeBE.BadgeName = l_Row["BadgeName"] == DBNull.Value ? string.Empty : Convert.ToString(l_Row["BadgeName"]);
                            l_BadgeBE.BadgeURL = l_Row["BadgeImageURL"] == DBNull.Value ? string.Empty : Convert.ToString(l_Row["BadgeImageURL"]);
                            l_BadgeBE.BadgeCount = l_Row["BadgeCount"] == DBNull.Value ? 0 : Convert.ToInt32(l_Row["BadgeCount"]);

                            l_BadgeBECollection.Add(l_BadgeBE);
                        }

                        l_DashboardBE.BadgeBECollection = l_BadgeBECollection;
                    }

                    //Get demo details
                    l_DemoDetailsTable = l_DashboardDataset.Tables[4];
                    if(l_DemoDetailsTable!=null && l_DemoDetailsTable.Rows.Count > 0)
                    {
                        for (int i = 0; i < l_DemoDetailsTable.Rows.Count; i++)
                        {
                            DataRow l_Row = l_DemoDetailsTable.Rows[i];
                            l_ScheduleDemoBE = new ScheduleDemoBE();

                            l_ScheduleDemoBE.UniqueID = l_Row["UDID"] == DBNull.Value ? 0 : Convert.ToInt32(l_Row["UDID"]);
                            l_ScheduleDemoBE.UserID = l_Row["UserID"] == DBNull.Value ? 0 : Convert.ToInt32(l_Row["UserID"]);
                            l_ScheduleDemoBE.SkillID = l_Row["SkillID"] == DBNull.Value ? 0 : Convert.ToInt32(l_Row["SkillID"]);
                            l_ScheduleDemoBE.SubSkillID = l_Row["SubskillID"] == DBNull.Value ? 0 : Convert.ToInt32(l_Row["SubskillID"]);
                            l_ScheduleDemoBE.SkillName = l_Row["SkillName"] == DBNull.Value ? string.Empty : Convert.ToString(l_Row["SkillName"]);
                            l_ScheduleDemoBE.SubSkillName = l_Row["SubskillName"] == DBNull.Value ? string.Empty : Convert.ToString(l_Row["SubskillName"]);
                            l_ScheduleDemoBE.Room = l_Row["Room"] == DBNull.Value ? string.Empty : Convert.ToString(l_Row["Room"]);
                            l_ScheduleDemoBE.EventConductedBy = l_Row["EventConductedBy"] == DBNull.Value ? string.Empty : Convert.ToString(l_Row["EventConductedBy"]);
                            l_ScheduleDemoBE.DemoSchedule = l_Row["DateAndTime"] == DBNull.Value ? DateTime.Now : Convert.ToDateTime(l_Row["DateAndTime"]);

                            l_ScheduleDemoBECollection.Add(l_ScheduleDemoBE);

                        }

                        l_DashboardBE.ScheduleDemoBECollection = l_ScheduleDemoBECollection;
                    }
                }
            }
            catch (Exception)
            {
                throw;
            }

            return l_DashboardBE;
        }

        /// <summary>
        /// Method to fetch subskill data on the basis of skill ID and skill type
        /// </summary>
        /// <param name="argSkillID">Skill ID</param>
        /// <param name="argSubSkillTable">DataTable with subskill details</param>
        /// <param name="argSkillType">Skill Type (Required/Acquired)</param>
        /// <returns></returns>
        private SubSkillBECollection GetSubSkillData(int argSkillID, DataTable argSubSkillTable, string argSkillType)
        {
            SubSkillBECollection l_SubSkillBECollection = new SubSkillBECollection();
            SubskillsBE l_SubskillsBE;
            try
            {
                if(argSubSkillTable!=null && argSubSkillTable.Rows.Count > 0)
                {
                    var requiredSubSkills = argSubSkillTable.AsEnumerable().Where(r => (int)r["RequiredSkillID"] == argSkillID && r["SubSkillType"].ToString().ToUpper() == argSkillType.ToUpper());

                    foreach (var item in requiredSubSkills)
                    {
                        l_SubskillsBE = new SubskillsBE();
                        l_SubskillsBE.SkillID = item["RequiredSkillID"] == DBNull.Value ? 0 : Convert.ToInt32(item["RequiredSkillID"]);
                        l_SubskillsBE.SubSkillID = item["RequiredSubskillID"] == DBNull.Value ? 0 : Convert.ToInt32(item["RequiredSubskillID"]);
                        l_SubskillsBE.SkillName = item["SkillName"] == DBNull.Value ? string.Empty : Convert.ToString(item["SkillName"]);
                        l_SubskillsBE.SubSkillName = item["SubskillName"] == DBNull.Value ? string.Empty : Convert.ToString(item["SubskillName"]);
                        l_SubskillsBE.SubSkillType = item["SubSkillType"] == DBNull.Value ? string.Empty : Convert.ToString(item["SubSkillType"]);
                        l_SubskillsBE.SkillPoints = item["SkillPoints"] == DBNull.Value ? 0 : Convert.ToInt32(item["SkillPoints"]);

                        l_SubSkillBECollection.Add(l_SubskillsBE);
                    }
                }
            }
            catch (Exception)
            {

                throw;
            }
            return l_SubSkillBECollection;
        }
    }
}