using Microsoft.AspNet.Identity;
using Newtonsoft.Json;
using SkillsDashboard.BusinessEntities;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Linq.Expressions;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Threading.Tasks;
using System.Web.Mvc;
using System.Web.Security;
using SkillsDashboard.Interfaces;
using SkillsDashboard.Utilities;
using SkillsDashboard.Models;
using static SkillsDashboard.Utilities.SkillConstants;

namespace SkillsDashboard.Controllers
{
    public class SkillsDashboardBaseController : Controller,ISkill
    {

        HttpClient client;
        string apiBaseURL = ConfigurationManager.AppSettings["APIBaseURL"];

        #region Private variables
        private const string C_QUERYABLE_PARAM = "i";
        private const string C_SORT_ORDER_DESC = "DESC";
        #endregion

        
        protected IList<T> Sort<T>(IList<T> argData, string argFieldName, string argSortOrder)
        {
            return this.Sort(argData.AsQueryable<T>(), argFieldName, argSortOrder).ToList<T>();
        }

        protected IQueryable<T> Sort<T>(IQueryable<T> argData, string argFieldName, string argSortOrder)
        {
            if (string.IsNullOrEmpty(argFieldName) || string.IsNullOrEmpty(argSortOrder))
                return argData;
            var l_Param = Expression.Parameter(typeof(T), C_QUERYABLE_PARAM);
            Expression l_Conversion = Expression.Convert(Expression.Property(l_Param, argFieldName), typeof(object));

            var l_SortExpression = Expression.Lambda<Func<T, object>>(l_Conversion, l_Param);

            return argSortOrder == C_SORT_ORDER_DESC ? argData.OrderByDescending(l_SortExpression) : argData.OrderBy(l_SortExpression);

        }

        /// <summary>
        /// This method is used to initialize HTTP Client
        /// </summary>
        private void InitializeClient()
        {
            client = new HttpClient();
            client.BaseAddress = new Uri(apiBaseURL);
            client.DefaultRequestHeaders.Accept.Clear();
            client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
        }



        /// <summary>
        /// This method is used to get logged in user ID
        /// </summary>
        /// <returns></returns>
        protected int GetLoggedInUserID()
        {
            int l_LoggedInUserID = 0;
            try
            {
                l_LoggedInUserID = Convert.ToInt32(User.Identity.GetUserId());
            }
            catch (Exception)
            {

                throw;
            }
            return l_LoggedInUserID;
        }

        /// <summary>
        /// This method is used to get all skills
        /// </summary>
        /// <returns></returns>
        public async Task<SkillsBECollection> GetAllSkills()
        {
            #region Declarations
            SkillsBECollection l_SkillsBECollection = new SkillsBECollection();
            int l_LoggedInUser = 0;
            string l_skillsURL = string.Empty;
            #endregion

            try
            {
                InitializeClient();
                l_LoggedInUser = GetLoggedInUserID();
                l_skillsURL = apiBaseURL + "/GetAllSkills?argLoggedInUser=" + l_LoggedInUser;
                HttpResponseMessage l_SkillsData = await client.GetAsync(l_skillsURL);

                if (l_SkillsData != null && l_SkillsData.IsSuccessStatusCode)
                {
                    var l_SkillResponse = l_SkillsData.Content.ReadAsStringAsync().Result;
                    l_SkillsBECollection = JsonConvert.DeserializeObject<SkillsBECollection>(l_SkillResponse);
                }

            }
            catch (Exception ex)
            {
                throw ex;
            }
            return l_SkillsBECollection;
        }

        public async Task<SubSkillBECollection> GetSubskillsForSkill(int argSkillID)
        {
            #region Declarations
            SubSkillBECollection l_SubskillBECollection = new SubSkillBECollection();
            int l_LoggedInUser = 0;
            string l_skillsURL = string.Empty;
            #endregion

            try
            {
                InitializeClient();
                l_LoggedInUser = GetLoggedInUserID();
                l_skillsURL = apiBaseURL + "/GetAllSubSkills?argLoggedInUser="+l_LoggedInUser+"&argSkillID="+argSkillID+"";
                HttpResponseMessage l_SkillsData = await client.GetAsync(l_skillsURL);

                if (l_SkillsData != null && l_SkillsData.IsSuccessStatusCode)
                {
                    var l_SkillResponse = l_SkillsData.Content.ReadAsStringAsync().Result;
                    l_SubskillBECollection = JsonConvert.DeserializeObject<SubSkillBECollection>(l_SkillResponse);
                }

            }
            catch (Exception ex)
            {
                throw ex;
            }
            return l_SubskillBECollection;
        }

        /// <summary>
        /// Convert subskill collection to view model
        /// </summary>
        /// <param name="argSubskillsBE"></param>
        /// <returns></returns>
        protected SubSkillCollection ConvertSubskillCollectionToModel(SubSkillBECollection argSubskillsBE)
        {
            SubSkillCollection l_SubskillCollection = new SubSkillCollection();
            Subskills l_Subskills;
            try
            {
                if (argSubskillsBE != null && argSubskillsBE.Count > 0)
                {
                    foreach (var subskills in argSubskillsBE)
                    {
                        l_Subskills = new Subskills();
                        l_Subskills.SubSkillID = subskills.SubSkillID;
                        l_Subskills.SubSkillName = subskills.SubSkillName;
                        l_Subskills.SkillID = subskills.SkillID;
                        l_SubskillCollection.Add(l_Subskills);
                    }
                }
            }
            catch (Exception)
            {

                throw;
            }

            return l_SubskillCollection;
        }

        protected IEnumerable<object> GetRequestTypes(bool argIncludeBadge = false)
        {
            IEnumerable<object> l_result = null;
            try
            {
                if(argIncludeBadge)
                {
                    l_result = from RequestTypeBadge mode in Enum.GetValues(typeof(RequestTypeBadge))
                               select new { ID = mode, Name = GetNameForRequestType(mode.ToString()) };
                }
                else
                {
                    l_result = from RequestType mode in Enum.GetValues(typeof(RequestType))
                               select new { ID = mode, Name = GetNameForRequestType(mode.ToString()) };
                }
                
            }
            catch (Exception ex)
            {

                throw ex;
            }

            return l_result;
        }

        private string GetNameForRequestType(string argRequestType)
        {
            string l_RequestName = string.Empty;
            try
            {
                switch (argRequestType.ToUpper())
                {
                    case "INIT":
                        l_RequestName = "Initial request";
                        break;
                    case "DEMO":
                        l_RequestName = "Demonstration";
                        break;
                    case "CERT":
                        l_RequestName = "Certification";
                        break;
                    case "BADGE":
                        l_RequestName = "Badge Request";
                        break;
                    default:
                        break;
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }

            return l_RequestName;
        }
    }
}