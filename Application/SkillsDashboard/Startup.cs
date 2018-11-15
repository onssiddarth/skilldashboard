using Microsoft.AspNet.Identity;
using Microsoft.AspNet.Identity.EntityFramework;
using Microsoft.Owin;
using Owin;
using SkillsDashboard.Models;

[assembly: OwinStartupAttribute(typeof(SkillsDashboard.Startup))]
namespace SkillsDashboard
{
    public partial class Startup
    {
        public void Configuration(IAppBuilder app)
        {
            ConfigureAuth(app);
            CreateRoles();
        }

        /// <summary>
        /// This function is used to create the roles required in system namely EMPLOYEE, MANAGER and SKILLEXPERT
        /// </summary>
        private void CreateRoles()
        {
            #region Declarations
            ApplicationDbContext context = new ApplicationDbContext();
            var l_roleManager = new RoleManager<Role, int>(new RoleStore(context));
            #endregion

            if (!l_roleManager.RoleExists("EMPLOYEE"))
            {
                var adminRole = new Role
                {
                    Name = "EMPLOYEE",
                };
                l_roleManager.Create(adminRole);
            }

            if (!l_roleManager.RoleExists("MANAGER"))
            {
                var adminRole = new Role
                {
                    Name = "MANAGER",
                };
                l_roleManager.Create(adminRole);
            }

            if (!l_roleManager.RoleExists("SKILLEXPERT"))
            {
                var adminRole = new Role
                {
                    Name = "SKILLEXPERT",
                };
                l_roleManager.Create(adminRole);
            }
        }
    }
}
