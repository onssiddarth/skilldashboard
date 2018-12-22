using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace SkillsDashboard.BusinessEntities
{
    public class QueryBE
    {
        public string Skill { get; set; }
        public string Subskill { get; set; }
        public string Name { get; set; }
        public string Email { get; set; }
        public string ContactNumber { get; set; }
        public int SkillPoints { get; set; }
    }

    public class QueryBECollection : List<QueryBE>
    {

    }
}