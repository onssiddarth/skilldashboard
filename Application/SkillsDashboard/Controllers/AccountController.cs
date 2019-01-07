using System;
using System.Globalization;
using System.Linq;
using System.Security.Claims;
using System.Threading.Tasks;
using System.Web;
using System.Web.Mvc;
using Microsoft.AspNet.Identity;
using Microsoft.AspNet.Identity.Owin;
using Microsoft.Owin.Security;
using SkillsDashboard.Models;
using System.Net.Http;
using System.Configuration;
using System.Net.Http.Headers;

namespace SkillsDashboard.Controllers
{
    [Authorize]
    public class AccountController : Controller
    {
        #region Page level declarations
        HttpClient client;
        string apiBaseURL = ConfigurationManager.AppSettings["APIBaseURL"];
        private ApplicationSignInManager _signInManager;
        private ApplicationUserManager _userManager;
        ApplicationDbContext context;
        #endregion

        public AccountController()
        {
            context = new ApplicationDbContext();
            client = new HttpClient();
            client.BaseAddress = new Uri(apiBaseURL);
            client.DefaultRequestHeaders.Accept.Clear();
            client.DefaultRequestHeaders.Accept.Add(new MediaTypeWithQualityHeaderValue("application/json"));
        }

        public AccountController(ApplicationUserManager userManager, ApplicationSignInManager signInManager)
        {
            UserManager = userManager;
            SignInManager = signInManager;
        }

        public ApplicationSignInManager SignInManager
        {
            get
            {
                return _signInManager ?? HttpContext.GetOwinContext().Get<ApplicationSignInManager>();
            }
            private set
            {
                _signInManager = value;
            }
        }

        public ApplicationUserManager UserManager
        {
            get
            {
                return _userManager ?? HttpContext.GetOwinContext().GetUserManager<ApplicationUserManager>();
            }
            private set
            {
                _userManager = value;
            }
        }

        [AllowAnonymous]
        public ActionResult Login(string argReturnUrl)
        {
            ViewBag.ReturnUrl = argReturnUrl;
            return View();
        }

        [HttpPost]
        [AllowAnonymous]
        [ValidateAntiForgeryToken]
        public async Task<ActionResult> Login(LoginViewModel argModel, string argReturnUrl)
        {
            if (!ModelState.IsValid)
            {
                return View(argModel);
            }

            var l_result = await SignInManager.PasswordSignInAsync(argModel.UserName, argModel.Password, argModel.RememberMe, shouldLockout: false);
            switch (l_result)
            {
                case SignInStatus.Success:
                    return RedirectToAction("Index", "Dashboard");
                case SignInStatus.LockedOut:
                    return View("Lockout");
                case SignInStatus.RequiresVerification:
                    return RedirectToAction("SendCode", new { ReturnUrl = argReturnUrl, RememberMe = argModel.RememberMe });
                case SignInStatus.Failure:
                default:
                    ModelState.AddModelError("", "Invalid login attempt.");
                    return View(argModel);
            }
        }

        
        [AllowAnonymous]
        public ActionResult Register()
        {
            ViewBag.Roles = new SelectList(context.Roles.ToList(), "Name", "Name");
            return View();
        }

        [HttpPost]
        [AllowAnonymous]
        [ValidateAntiForgeryToken]
        public async Task<ActionResult> Register(RegisterViewModel argModel)
        {
            if (ModelState.IsValid)
            {
                var l_user = new ApplicationUser { UserName = argModel.UserName, Email = argModel.Email,FirstName = argModel.FirstName,LastName=argModel.LastName, MiddleName = argModel.MiddleName,PhoneNumber = argModel.PhoneNumber, Address = argModel.Address };
                var l_result = await UserManager.CreateAsync(l_user, argModel.Password);
                if (l_result.Succeeded)
                {
                    await SignInManager.SignInAsync(l_user, isPersistent: false, rememberBrowser: false);

                    await this.UserManager.AddToRoleAsync(l_user.Id, argModel.UserRole);

                    //Sync User Points before redirection to Dashboard
                    var response = await SyncUserRequiredPoints();
                    
                    return RedirectToAction("Index", "Dashboard");
                }

                ViewBag.Roles = new SelectList(context.Roles.ToList(), "Name", "Name");
                AddErrors(l_result);
            }

            ViewBag.Roles = new SelectList(context.Roles.ToList(), "Name", "Name");
            // If we got this far, something failed, redisplay form
            return View(argModel);
        }

        private async Task<HttpResponseMessage> SyncUserRequiredPoints()
        {
            #region Declarations
            HttpResponseMessage l_Response = new HttpResponseMessage();
            string l_SyncPointsURL = apiBaseURL + "/SyncUserRequiredPoints";
            #endregion

            try
            {
               l_Response = await client.PostAsync(l_SyncPointsURL,null); 
            }
            catch (Exception ex)
            {
                throw ex;
            }

            return l_Response;
        }


        [AllowAnonymous]
        public ActionResult ResetPassword(string code)
        {
            return code == null ? View("Error") : View();
        }

        [HttpPost]
        [AllowAnonymous]
        [ValidateAntiForgeryToken]
        public async Task<ActionResult> ResetPassword(ResetPasswordViewModel argModel)
        {
            if (!ModelState.IsValid)
            {
                return View(argModel);
            }
            var user = await UserManager.FindByNameAsync(argModel.Email);
            if (user == null)
            {
                // Don't reveal that the user does not exist
                return RedirectToAction("ResetPasswordConfirmation", "Account");
            }
            var result = await UserManager.ResetPasswordAsync(user.Id, argModel.Code, argModel.Password);
            if (result.Succeeded)
            {
                return RedirectToAction("ResetPasswordConfirmation", "Account");
            }
            AddErrors(result);
            return View();
        }

        [AllowAnonymous]
        public ActionResult ResetPasswordConfirmation()
        {
            return View();
        }

        
        [AllowAnonymous]
        public async Task<ActionResult> SendCode(string argReturnUrl, bool argRememberMe)
        {
            var l_UserId = await SignInManager.GetVerifiedUserIdAsync();
            if (l_UserId == 0)
            {
                return View("Error");
            }
            var userFactors = await UserManager.GetValidTwoFactorProvidersAsync(l_UserId);
            var factorOptions = userFactors.Select(purpose => new SelectListItem { Text = purpose, Value = purpose }).ToList();
            return View(new SendCodeViewModel { Providers = factorOptions, ReturnUrl = argReturnUrl, RememberMe = argRememberMe });
        }

        [HttpPost]
        [AllowAnonymous]
        [ValidateAntiForgeryToken]
        public async Task<ActionResult> SendCode(SendCodeViewModel argModel)
        {
            if (!ModelState.IsValid)
            {
                return View();
            }

            // Generate the token and send it
            if (!await SignInManager.SendTwoFactorCodeAsync(argModel.SelectedProvider))
            {
                return View("Error");
            }
            return RedirectToAction("VerifyCode", new { Provider = argModel.SelectedProvider, ReturnUrl = argModel.ReturnUrl, RememberMe = argModel.RememberMe });
        }

        
        [HttpPost]
        [ValidateAntiForgeryToken]
        [Authorize]
        public ActionResult LogOff()
        {
            AuthenticationManager.SignOut(DefaultAuthenticationTypes.ApplicationCookie);
            return RedirectToAction("Login", "Account");
        }

        

        protected override void Dispose(bool disposing)
        {
            if (disposing)
            {
                if (_userManager != null)
                {
                    _userManager.Dispose();
                    _userManager = null;
                }

                if (_signInManager != null)
                {
                    _signInManager.Dispose();
                    _signInManager = null;
                }
            }

            base.Dispose(disposing);
        }

        #region Helpers
        // Used for XSRF protection when adding external logins
        private const string XsrfKey = "XsrfId";

        private IAuthenticationManager AuthenticationManager
        {
            get
            {
                return HttpContext.GetOwinContext().Authentication;
            }
        }

        private void AddErrors(IdentityResult result)
        {
            foreach (var error in result.Errors)
            {
                ModelState.AddModelError("", error);
            }
        }

        private ActionResult RedirectToLocal(string returnUrl)
        {
            if (Url.IsLocalUrl(returnUrl))
            {
                return Redirect(returnUrl);
            }
            return RedirectToAction("Index", "Home");
        }

        internal class ChallengeResult : HttpUnauthorizedResult
        {
            public ChallengeResult(string provider, string redirectUri)
                : this(provider, redirectUri, null)
            {
            }

            public ChallengeResult(string provider, string redirectUri, string userId)
            {
                LoginProvider = provider;
                RedirectUri = redirectUri;
                UserId = userId;
            }

            public string LoginProvider { get; set; }
            public string RedirectUri { get; set; }
            public string UserId { get; set; }

            public override void ExecuteResult(ControllerContext context)
            {
                var properties = new AuthenticationProperties { RedirectUri = RedirectUri };
                if (UserId != null)
                {
                    properties.Dictionary[XsrfKey] = UserId;
                }
                context.HttpContext.GetOwinContext().Authentication.Challenge(properties, LoginProvider);
            }
        }
        #endregion
    }
}