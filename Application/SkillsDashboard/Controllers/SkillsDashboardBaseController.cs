using System;
using System.Collections.Generic;
using System.Linq;
using System.Linq.Expressions;
using System.Web;
using System.Web.Mvc;

namespace SkillsDashboard.Controllers
{
    public class SkillsDashboardBaseController : Controller
    {
        #region Private variables
        private const string C_QUERYABLE_PARAM = "i";
        private const string C_SORT_ORDER_DESC = "DESC";
        #endregion

        
        protected IList<T> Sort<T>(IList<T> argData, string argFieldName, string argSortOrder)
        {
            return this.Sort(argData.AsQueryable<T>(), argFieldName, argSortOrder).ToList<T>();
        }

        protected IQueryable<T> Sort<T>(IQueryable<T> argData, string argFieldName, string argSortOrder)
        {
            if (string.IsNullOrEmpty(argFieldName) || string.IsNullOrEmpty(argSortOrder))
                return argData;
            var l_Param = Expression.Parameter(typeof(T), C_QUERYABLE_PARAM);
            Expression l_Conversion = Expression.Convert(Expression.Property(l_Param, argFieldName), typeof(object));

            var l_SortExpression = Expression.Lambda<Func<T, object>>(l_Conversion, l_Param);

            return argSortOrder == C_SORT_ORDER_DESC ? argData.OrderByDescending(l_SortExpression) : argData.OrderBy(l_SortExpression);

        }
    }
}