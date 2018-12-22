using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace SkillsDashboard.Utilities
{
    public class SkillConstants
    {
        //Add all constants and enum here

        #region constants
        public const string C_TEST_CONST = "TestConstant";
        public const string C_INTITIAL_REQUEST_SUCCESS_CONST = "INITIALREQUESTSUCCESSMESSAGE";
        public const string C_GIVEBADGESUCCESS_CONST = "GIVEBADGESUCCESSMESSAGE";

        public const string C_SUCCESS_CONST = "SUCCESS";

        public const string C_BADGETYPE_EXPERT = "EXPERTBADGE";
        public const string C_BADGETYPE_USER = "USERBADGE";

        public const string C_SAVEBADGETYPE_EXPERT = "EXPERT";
        public const string C_SAVEBADGETYPE_USER = "USER";

        #endregion

        #region Enumerations
        public enum Status
        {
            Success,
            Error,
        }


        public enum ImproveSkillsMode
        {
            DEMO,
            CERTIFICATE
        }

        public enum RequestType
        {
            INIT,
            DEMO,
            CERT
        }

        public enum RequestTypeBadge
        {
            INIT,
            DEMO,
            CERT,
            BADGE
        }

        #endregion
    }
}