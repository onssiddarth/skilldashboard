using System;
using System.Linq;
using System.Threading.Tasks;
using System.Web;
using System.Web.Mvc;
using Microsoft.AspNet.Identity;
using Microsoft.AspNet.Identity.Owin;
using Microsoft.Owin.Security;
using SkillsDashboard.Models;

namespace SkillsDashboard.Controllers
{
    [Authorize]
    public class ManageController : Controller
    {
        private ApplicationSignInManager _signInManager;
        private ApplicationUserManager _userManager;

        public ManageController()
        {
        }

        public ManageController(ApplicationUserManager userManager, ApplicationSignInManager signInManager)
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

        public async Task<ActionResult> Index(ManageMessageId? argMessage)
        {
            ViewBag.StatusMessage =
                argMessage == ManageMessageId.ChangePasswordSuccess ? "Your password has been changed."
                : argMessage == ManageMessageId.SetPasswordSuccess ? "Your password has been set."
                : argMessage == ManageMessageId.SetTwoFactorSuccess ? "Your two-factor authentication provider has been set."
                : argMessage == ManageMessageId.Error ? "An error has occurred."
                : argMessage == ManageMessageId.AddPhoneSuccess ? "Your phone number was added."
                : argMessage == ManageMessageId.RemovePhoneSuccess ? "Your phone number was removed."
                : "";

            var l_UserId = User.Identity.GetUserId();
            var model = new IndexViewModel
            {
                HasPassword = HasPassword(),
                PhoneNumber = await UserManager.GetPhoneNumberAsync(Convert.ToInt32(l_UserId)),
                TwoFactor = await UserManager.GetTwoFactorEnabledAsync(Convert.ToInt32(l_UserId)),
                Logins = await UserManager.GetLoginsAsync(Convert.ToInt32(l_UserId)),
                BrowserRemembered = await AuthenticationManager.TwoFactorBrowserRememberedAsync(l_UserId)
            };
            return View(model);
        }

        
        public ActionResult ChangePassword()
        {
            return View();
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<ActionResult> ChangePassword(ChangePasswordViewModel argModel)
        {
            if (!ModelState.IsValid)
            {
                return View(argModel);
            }
            var l_Result = await UserManager.ChangePasswordAsync(Convert.ToInt32(User.Identity.GetUserId()), argModel.OldPassword, argModel.NewPassword);
            if (l_Result.Succeeded)
            {
                var user = await UserManager.FindByIdAsync(Convert.ToInt32(User.Identity.GetUserId()));
                if (user != null)
                {
                    await SignInManager.SignInAsync(user, isPersistent: false, rememberBrowser: false);
                }
                return RedirectToAction("Index", new { Message = ManageMessageId.ChangePasswordSuccess });
            }
            AddErrors(l_Result);
            return View(argModel);
        }

       
        public ActionResult SetPassword()
        {
            return View();
        }

        [HttpPost]
        [ValidateAntiForgeryToken]
        public async Task<ActionResult> SetPassword(SetPasswordViewModel argModel)
        {
            if (ModelState.IsValid)
            {
                var l_Result = await UserManager.AddPasswordAsync(Convert.ToInt32(User.Identity.GetUserId()), argModel.NewPassword);
                if (l_Result.Succeeded)
                {
                    var user = await UserManager.FindByIdAsync(Convert.ToInt32(User.Identity.GetUserId()));
                    if (user != null)
                    {
                        await SignInManager.SignInAsync(user, isPersistent: false, rememberBrowser: false);
                    }
                    return RedirectToAction("Index", new { Message = ManageMessageId.SetPasswordSuccess });
                }
                AddErrors(l_Result);
            }

            // If we got this far, something failed, redisplay form
            return View(argModel);
        }
        

        protected override void Dispose(bool disposing)
        {
            if (disposing && _userManager != null)
            {
                _userManager.Dispose();
                _userManager = null;
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

        private bool HasPassword()
        {
            var user = UserManager.FindById(Convert.ToInt32(User.Identity.GetUserId()));
            if (user != null)
            {
                return user.PasswordHash != null;
            }
            return false;
        }


        public enum ManageMessageId
        {
            AddPhoneSuccess,
            ChangePasswordSuccess,
            SetTwoFactorSuccess,
            SetPasswordSuccess,
            RemoveLoginSuccess,
            RemovePhoneSuccess,
            Error
        }

        #endregion
    }
}