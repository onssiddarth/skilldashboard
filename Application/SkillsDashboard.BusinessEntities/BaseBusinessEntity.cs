using System;
using System.Collections.Generic;
using System.Linq;
using System.Web;

namespace SkillsDashboard.BusinessEntities
{
    public class BaseBusinessEntity
    {
        public string AddedBy { get; set; }

        public DateTime? DateCreated { get; set; }

        public string ModifiedBy { get; set; }

        public DateTime? DateModified { get; set; }
    }
}