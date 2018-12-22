using SkillsDashboard.Utilities;
using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;
using System.Web.Mvc;

namespace SkillsDashboard.Controllers
{
    public class DashboardController : SkillsDashboardBaseController
    {
        
        public ActionResult Index()
        {
            if(TempData[SkillConstants.C_INTITIAL_REQUEST_SUCCESS_CONST]!=null)
            {
                ViewBag.SuccessMessage = TempData[SkillConstants.C_INTITIAL_REQUEST_SUCCESS_CONST];
            }
            return View();
        }
    }
}