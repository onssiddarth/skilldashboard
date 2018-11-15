using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace SkillsDashboard.BusinessEntities
{
    public class TestUser:BaseBusinessEntity
    {
        public int ID { get; set; }

        public string Name { get; set; }

        public int Age { get; set; }

        public string Address { get; set; }
    }

    public class TestUserBECollection: List<TestUser>
    {

    }
}