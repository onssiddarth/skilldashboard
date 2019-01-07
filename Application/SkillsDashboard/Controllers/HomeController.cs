using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace SkillsDashboard.Controllers
{
    public class HomeController : SkillsDashboardBaseController
    {
        /// <summary>
        /// Default route which will redirect user to login page or dashboard on the basis of login status
        /// </summary>
        /// <returns></returns>
        public ActionResult Index()
        {
            //Get Logged in User ID
            int l_LoggedInUserID = GetLoggedInUserID();

            //If logged in user ID is not set redirect to login page else dashboard page
            if(l_LoggedInUserID == 0)
            {
                return RedirectToAction("Login", "Account");
            }
            else
            {
                return RedirectToAction("Index", "Dashboard");
            }
        }
    }
}