﻿using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace SkillsDashboard.BusinessEntities
{
    public class UserDetailsBE
    {
        public int UserID { get; set; }

        public string UserName { get; set; }
    }

    public class UserDetailsBECollection: List<UserDetailsBE>
    {

    }
}