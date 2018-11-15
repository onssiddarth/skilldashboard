using SkillsDashboard.BusinessEntities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using SkillsDashboard.DAL;
using System.Data;

namespace SkillsDashboard.BLO
{
    public class TestUserBLO
    {
        /// <summary>
        /// This function is used to fetch all test users
        /// </summary>
        /// <param name="argLoggedInUser"></param>
        /// <returns></returns>
        public TestUserBECollection GetAllTestUsers(string argLoggedInUser)
        {
            #region Declarations
            TestUserBECollection l_TestUserBECollection = new TestUserBECollection();
            SkillsDBManager l_SkillsDBManager = new SkillsDBManager("SkillsDBConnection");
            List<IDbDataParameter> l_Parameters = new List<IDbDataParameter>();
            DataTable l_UserDataTable = new DataTable();
            TestUser l_TestUser;
            int l_UserCount = 0;
            #endregion
            try
            {
                l_Parameters.Add(l_SkillsDBManager.CreateParameter(ProcedureParams.LOGGEDINUSER, argLoggedInUser, DbType.String));

                l_UserDataTable = l_SkillsDBManager.GetDataTable(StoredProcedures.GET_TESTUSERS, CommandType.StoredProcedure, l_Parameters.ToArray());

                if(l_UserDataTable != null && l_UserDataTable.Rows.Count > 0)
                {
                    l_UserCount = l_UserDataTable.Rows.Count;
                    for (int i = 0; i < l_UserCount; i++)
                    {
                        l_TestUser = new TestUser();

                        DataRow l_Row = l_UserDataTable.Rows[i];

                        l_TestUser.ID = l_Row["ID"] == DBNull.Value ? 0 : Convert.ToInt32(l_Row["ID"]);
                        l_TestUser.Name = l_Row["Name"] == DBNull.Value ? string.Empty : Convert.ToString(l_Row["Name"]);
                        l_TestUser.Age = l_Row["Age"] == DBNull.Value ? 0 : Convert.ToInt32(l_Row["Age"]);
                        l_TestUser.Address = l_Row["Address"] == DBNull.Value ? string.Empty : Convert.ToString(l_Row["Address"]);
                        l_TestUser.AddedBy = l_Row["AddedBy"] == DBNull.Value ? string.Empty : Convert.ToString(l_Row["AddedBy"]);
                        l_TestUser.ModifiedBy = l_Row["ModifiedBy"] == DBNull.Value ? string.Empty : Convert.ToString(l_Row["ModifiedBy"]);
                        l_TestUser.DateCreated = l_Row["AddedDate"] == DBNull.Value ? DateTime.UtcNow: Convert.ToDateTime(l_Row["AddedDate"]);
                        l_TestUser.DateModified = l_Row["ModifiedDate"] == DBNull.Value ? DateTime.UtcNow : Convert.ToDateTime(l_Row["ModifiedDate"]);

                        l_TestUserBECollection.Add(l_TestUser);

                    }
                }
            }
            catch (Exception ex)
            {
                throw;
            }
            return l_TestUserBECollection;
        }

        /// <summary>
        /// Function to save a single user
        /// </summary>
        /// <param name="argUser"></param>
        /// <param name="argLoggedInUser"></param>
        /// <returns></returns>
        public void InsertUser(TestUser argUser, string argLoggedInUser)
        {
            #region Declarations
            SkillsDBManager l_SkillsDBManager = new SkillsDBManager("SkillsDBConnection");
            List<IDbDataParameter> l_Parameters = new List<IDbDataParameter>();
            DataTable l_UserDataTable = new DataTable();
            int l_LastID = 0;
            #endregion
            try
            {
                if(argUser!= null)
                {
                    l_Parameters.Add(l_SkillsDBManager.CreateParameter(ProcedureParams.LOGGEDINUSER, argLoggedInUser, DbType.String));
                    l_Parameters.Add(l_SkillsDBManager.CreateParameter(ProcedureParams.USERAGE, argUser.Age, DbType.Int32));
                    l_Parameters.Add(l_SkillsDBManager.CreateParameter(ProcedureParams.USERADDRESS, argUser.Address, DbType.String));
                    l_Parameters.Add(l_SkillsDBManager.CreateParameter(ProcedureParams.USERNAME, argUser.Name, DbType.String));

                    l_SkillsDBManager.Insert(StoredProcedures.INSERT_TESTUSERS, CommandType.StoredProcedure, l_Parameters.ToArray(), out l_LastID);
                }
            }
            catch (Exception)
            {

                throw;
            }
        }
    }
}