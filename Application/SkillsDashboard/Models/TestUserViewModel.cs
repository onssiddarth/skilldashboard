using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace SkillsDashboard.Models
{
    public class TestUserViewModel
    {
        public int ID { get; set; }

        public string Name { get; set; }

        public int Age { get; set; }

        public string Address { get; set; }
    }

    public class TestUserViewModelCollection:List<TestUserViewModel>
    {

    }
}