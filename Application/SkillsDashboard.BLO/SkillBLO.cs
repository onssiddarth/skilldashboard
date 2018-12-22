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
    public class SkillBLO
    {
        public SkillsBECollection GetAllSkills(int argLoggedInUser)
        {
            #region Declarations
            SkillsBECollection l_skillCollection = new SkillsBECollection();
            SkillsDBManager l_SkillsDBManager = new SkillsDBManager("SkillsDBConnection");
            List<IDbDataParameter> l_Parameters = new List<IDbDataParameter>();
            DataTable l_SkillDataTable = new DataTable();
            SkillsBE l_Skill;
            int l_SkillCount = 0;
            #endregion
            try
            {
                l_Parameters.Add(l_SkillsDBManager.CreateParameter(ProcedureParams.LOGGEDINUSERID, argLoggedInUser, DbType.Int32));

                l_SkillDataTable = l_SkillsDBManager.GetDataTable(StoredProcedures.GET_ALLSKILLS_AVAILABLE, CommandType.StoredProcedure, l_Parameters.ToArray());

                if (l_SkillDataTable != null && l_SkillDataTable.Rows.Count > 0)
                {
                    l_SkillCount = l_SkillDataTable.Rows.Count;
                    for (int i = 0; i < l_SkillCount; i++)
                    {
                        l_Skill = new SkillsBE();

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

        public SubSkillBECollection GetAllSubSkills(int argLoggedInUser, int argSkillID)
        {
            #region Declarations
            SubSkillBECollection l_SubSkillCollection = new SubSkillBECollection();
            SkillsDBManager l_SkillsDBManager = new SkillsDBManager("SkillsDBConnection");
            List<IDbDataParameter> l_Parameters = new List<IDbDataParameter>();
            DataTable l_SubSkillDataTable = new DataTable();
            SubskillsBE l_SubSkill;
            int l_SubSkillCount = 0;
            #endregion
            try
            {
                l_Parameters.Add(l_SkillsDBManager.CreateParameter(ProcedureParams.LOGGEDINUSERID, argLoggedInUser, DbType.Int32));
                l_Parameters.Add(l_SkillsDBManager.CreateParameter(ProcedureParams.SKILLID, argSkillID, DbType.Int32));

                l_SubSkillDataTable = l_SkillsDBManager.GetDataTable(StoredProcedures.GET_ALLSUBSKILLS_FORASKILL, CommandType.StoredProcedure, l_Parameters.ToArray());

                if (l_SubSkillDataTable != null && l_SubSkillDataTable.Rows.Count > 0)
                {
                    l_SubSkillCount = l_SubSkillDataTable.Rows.Count;
                    for (int i = 0; i < l_SubSkillCount; i++)
                    {
                        l_SubSkill = new SubskillsBE();

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

        public void CreateInitialRequest(UserInitialSkillRequestBE argSkillRequest, string argLoggedInUser)
        {
            #region Declarations
            SkillsDBManager l_SkillsDBManager = new SkillsDBManager("SkillsDBConnection");
            List<IDbDataParameter> l_Parameters = new List<IDbDataParameter>();
            XElement l_skillXML = null;
            int l_LastID = 0;
            #endregion
            try
            {
                
                if (argLoggedInUser!= null && argSkillRequest!=null && argSkillRequest.UserSubskills!=null && argSkillRequest.UserSubskills.Count > 0)
                {
                    //Generate XML
                    l_skillXML = GenerateSkillXML(argSkillRequest.UserSubskills);

                    //Create Parameters
                    l_Parameters.Add(l_SkillsDBManager.CreateParameter(ProcedureParams.LOGGEDINUSERID, argLoggedInUser, DbType.String));
                    l_Parameters.Add(l_SkillsDBManager.CreateParameter(ProcedureParams.COMMENTS, argSkillRequest.Comments, DbType.String));
                    l_Parameters.Add(l_SkillsDBManager.CreateParameter(ProcedureParams.SKILLXML, l_skillXML.ToString(), DbType.Xml));

                    //Call stored procedure
                    l_SkillsDBManager.Insert(StoredProcedures.SAVE_INITIALSKILLREQUEST, CommandType.StoredProcedure, l_Parameters.ToArray(), out l_LastID);
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }

        /// <summary>
        /// This method is used to generate Skill XML
        /// </summary>
        /// <param name="argSubskills"></param>
        /// <returns></returns>
        private XElement GenerateSkillXML(SubSkillBECollection argSubskills)
        {
            XElement l_skillXML=null;
            try
            {
                l_skillXML = new XElement("SkillSet",
                    from skill in argSubskills
                    select new XElement("Skill",
                    new XElement("SkillID", skill.SkillID),
                    new XElement("SubskillID", skill.SubSkillID)
                    ));
            }
            catch (Exception ex)
            {
                throw ex;
            }

            return l_skillXML;
        }

        public void ImproveSkills(ImproveSkillsBE argImproveSkills, string argLoggedInUser)
        {
            #region Declarations
            SkillsDBManager l_SkillsDBManager = new SkillsDBManager("SkillsDBConnection");
            List<IDbDataParameter> l_Parameters = new List<IDbDataParameter>();
            XElement l_skillXML = null;
            int l_LastID = 0;
            #endregion
            try
            {

                if (argLoggedInUser != null && argImproveSkills != null && argImproveSkills.UserSubskills != null && argImproveSkills.UserSubskills.Count > 0)
                {
                    //Generate XML
                    l_skillXML = GenerateSkillXML(argImproveSkills.UserSubskills);

                    //Create Parameters
                    l_Parameters.Add(l_SkillsDBManager.CreateParameter(ProcedureParams.LOGGEDINUSERID, argLoggedInUser, DbType.String));
                    l_Parameters.Add(l_SkillsDBManager.CreateParameter(ProcedureParams.COMMENTS, argImproveSkills.Comments, DbType.String));
                    l_Parameters.Add(l_SkillsDBManager.CreateParameter(ProcedureParams.SKILLXML, l_skillXML.ToString(), DbType.Xml));
                    l_Parameters.Add(l_SkillsDBManager.CreateParameter(ProcedureParams.TYPE, argImproveSkills.Mode, DbType.String));

                    if(string.IsNullOrEmpty(argImproveSkills.FileUploadGUID))
                    {
                        l_Parameters.Add(l_SkillsDBManager.CreateParameter(ProcedureParams.FILEUPLOADGUID,  DBNull.Value, DbType.String));
                    }
                    else
                    {
                        l_Parameters.Add(l_SkillsDBManager.CreateParameter(ProcedureParams.FILEUPLOADGUID, argImproveSkills.FileUploadGUID, DbType.String));
                    }

                    if (string.IsNullOrEmpty(argImproveSkills.FileUploadName))
                    {
                        l_Parameters.Add(l_SkillsDBManager.CreateParameter(ProcedureParams.FILEUPLOADNAME, DBNull.Value, DbType.String));
                    }
                    else
                    {
                        l_Parameters.Add(l_SkillsDBManager.CreateParameter(ProcedureParams.FILEUPLOADNAME, argImproveSkills.FileUploadName, DbType.String));
                    }


                    //Call stored procedure
                    l_SkillsDBManager.Insert(StoredProcedures.SAVE_IMPROVESKILLS, CommandType.StoredProcedure, l_Parameters.ToArray(), out l_LastID);
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }
        }
    }
}