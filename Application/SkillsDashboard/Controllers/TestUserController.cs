using Newtonsoft.Json;
using System;
using System.Collections.Generic;
using System.Configuration;
using System.Linq;
using System.Net.Http;
using System.Net.Http.Headers;
using System.Threading.Tasks;
using System.Web;
using System.Web.Mvc;
using SkillsDashboard.BusinessEntities;
using SkillsDashboard.Models;


namespace SkillsDashboard.Controllers
{
    public class TestUserController : SkillsDashboardBaseController
    {
        #region Page level declarations
        HttpClient client;
        string apiBaseURL = ConfigurationManager.AppSettings["APIBaseURL"];
        #endregion

        public TestUserController()
        {
            client = new HttpClient();
            client.BaseAddress = new Uri(apiBaseURL);
            client.DefaultRequestHeaders.Accept.Clear();
            client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
        }

        /// <summary>
        /// HTTP Get call to get a list of users
        /// </summary>
        /// <returns></returns>
        public async Task<ActionResult> Index()
        {
            #region Declarations
            string l_LoggedInUser = "AO1234";
            string l_TestUserURL = apiBaseURL + "/TestUser?argLoggedInUser=" + l_LoggedInUser;
            TestUserBECollection l_TestUserBECollection = new TestUserBECollection();
            TestUserViewModelCollection l_TestUserViewModelCollection = new TestUserViewModelCollection();
            HttpResponseMessage l_TestUserData = await client.GetAsync(l_TestUserURL);
            #endregion

            if (l_TestUserData != null && l_TestUserData.IsSuccessStatusCode)
            {
                var l_TestDataResponse = l_TestUserData.Content.ReadAsStringAsync().Result;
                l_TestUserBECollection = JsonConvert.DeserializeObject<TestUserBECollection>(l_TestDataResponse);

                if (l_TestUserBECollection != null && l_TestUserBECollection.Count > 0)
                {
                    l_TestUserViewModelCollection = ConvertToViewModel(l_TestUserBECollection);
                }

            }

            //Uncomment these 2 lines for HTTTP POST
            //TestUserViewModel l_TestUserViewModel = new TestUserViewModel { Name="Siddarth",Age = 29, Address = "Kalyan" };
            //Create(l_TestUserViewModel);

            return View(l_TestUserViewModelCollection);
        }

        /// <summary>
        /// Convert to view model class
        /// </summary>
        /// <param name="argTestUserBECollection"></param>
        /// <returns></returns>
        private TestUserViewModelCollection ConvertToViewModel(TestUserBECollection argTestUserBECollection)
        {
            #region Declarations
            TestUserViewModelCollection l_TestUserViewModelCollection = new TestUserViewModelCollection();
            TestUserViewModel l_TestUserViewModel;
            #endregion
            try
            {
                if(argTestUserBECollection !=null && argTestUserBECollection.Count > 0)
                {
                    foreach (TestUser user in argTestUserBECollection)
                    {
                        l_TestUserViewModel = new TestUserViewModel();

                        l_TestUserViewModel.ID = user.ID;
                        l_TestUserViewModel.Name = user.Name;
                        l_TestUserViewModel.Age = user.Age;
                        l_TestUserViewModel.Address = user.Address;

                        l_TestUserViewModelCollection.Add(l_TestUserViewModel);
                    }
                }
            }
            catch (Exception)
            {

                throw;
            }

            return l_TestUserViewModelCollection;
        }

        [HttpPost]
        public async Task<ActionResult> Create(TestUserViewModel argTestUserViewModel)
        {
            string l_LoggedInUser = "AO1234";
            string l_TestUserURL = apiBaseURL + "TestUser?argLoggedInUser=" + l_LoggedInUser;
            TestUser l_TestUserBE = new TestUser();

            l_TestUserBE = ConvertToBusinessEntity(argTestUserViewModel);

            if (argTestUserViewModel!=null)
            {
                HttpResponseMessage responseMessage = await client.PostAsJsonAsync(l_TestUserURL, l_TestUserBE);
                if (responseMessage.IsSuccessStatusCode)
                {
                    return RedirectToAction("Index");
                }
            }

            return RedirectToAction("Error"); //Add a new view for error

        }

        private TestUser ConvertToBusinessEntity(TestUserViewModel argTestUserViewModel)
        {
            TestUser l_TestUser = new TestUser();
            try
            {
                if(argTestUserViewModel!=null)
                {
                    l_TestUser.Name = argTestUserViewModel.Name;
                    l_TestUser.Address = argTestUserViewModel.Address;
                    l_TestUser.Age = argTestUserViewModel.Age;
                }
            }
            catch (Exception ex)
            {
                throw ex;
            }

            return l_TestUser;
        }
    }
}