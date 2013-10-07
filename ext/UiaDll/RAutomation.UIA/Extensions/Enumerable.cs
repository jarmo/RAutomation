using System;
using System.Collections.Generic;
using System.Linq;
using System.Windows.Automation;

namespace RAutomation.UIA.Extensions
{
    public static class Enumerable
    {
        public static IEnumerable<AutomationElement> Find(this AutomationElement automationElement, Condition condition)
        {
            return automationElement.Find(Condition.TrueCondition, condition);
        }

        public static IEnumerable<AutomationElement> Find(this AutomationElement automationElement, params Condition[] conditions)
        {
            return automationElement.FindAll(TreeScope.Subtree, new AndCondition(conditions)).AsEnumerable();
        }

        public static IEnumerable<AutomationElement> FindAny(this AutomationElement automationElement, params Condition[] conditions)
        {
            return automationElement.FindAll(TreeScope.Subtree, new OrCondition(conditions)).AsEnumerable();
        }

        public static AutomationElement FindOne(this AutomationElement automationElement, params Condition[] conditions)
        {
            return automationElement.FindFirst(TreeScope.Subtree, new AndCondition(conditions));
        }

        public static IEnumerable<string> Names(this IEnumerable<AutomationElement> automationElements)
        {
            return automationElements.Select(x => x.Current.Name);
        }

        public static IEnumerable<SelectionItemPattern> AsSelectionItems(this IEnumerable<AutomationElement> automationElements)
        {
            return automationElements.Select(Element.AsSelectionItem);
        }

        public static int IndexOf<T>(this IEnumerable<T> items, Func<T, bool> trueCondition)
        {
            var foundIndex = 0;
            foreach (var item in items)
            {
                if (trueCondition(item)) return foundIndex;
                ++foundIndex;
            }

            return -1;
        }

        public static int[] IndexesOf<T>(this IEnumerable<T> items, Func<T, bool> trueCondition)
        {
            var indexes = new List<int>();
            var foundIndex = 0;
            foreach (var item in items)
            {
                if (trueCondition(item)) indexes.Add(foundIndex);
                ++foundIndex;
            }

            return indexes.ToArray();
        }

        public static void ForEach<T>(this IEnumerable<T> items, Action<T> doIt)
        {
            foreach (var item in items)
                doIt(item);
        }

        public static IEnumerable<AutomationElement> AsEnumerable(this AutomationElementCollection automationElements)
        {
            return automationElements.Cast<AutomationElement>();
        }
    }
}