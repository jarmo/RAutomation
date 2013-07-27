using System;
using System.Collections.Generic;
using System.Linq;
using System.Windows.Automation;

namespace RAutomation.UIA.Extensions
{
    public static class AutomationExtensions
    {
        public static IEnumerable<AutomationElement> Find(this AutomationElement automationElement, Condition condition)
        {
            return automationElement.Find(Condition.TrueCondition, condition);
        }

        public static IEnumerable<AutomationElement> Find(this AutomationElement automationElement, params Condition[] conditions)
        {
            return automationElement.FindAll(TreeScope.Subtree, new AndCondition(conditions)).AsEnumerable();
        }

        public static IEnumerable<string> Names(this IEnumerable<AutomationElement> automationElements)
        {
            return automationElements.Select(x => x.Current.Name);
        }

        public static IEnumerable<SelectionItemPattern> AsSelectionItems(this IEnumerable<AutomationElement> automationElements)
        {
            return automationElements.Select(AsSelectionItem);
        }

        public static SelectionItemPattern AsSelectionItem(this AutomationElement automationElement)
        {
            return (SelectionItemPattern)automationElement.GetCurrentPattern(SelectionItemPattern.Pattern);
        }

        public static bool IsSelected(this AutomationElement automationElement)
        {
            return automationElement.AsSelectionItem().Current.IsSelected;
        }

        public static TogglePattern AsTogglePattern(this AutomationElement automationElement)
        {
            return (TogglePattern)automationElement.GetCurrentPattern(TogglePattern.Pattern);
        }

        public static bool IsToggled(this AutomationElement automationElement)
        {
            return automationElement.AsTogglePattern().Current.ToggleState == ToggleState.On;
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

        public static IEnumerable<AutomationElement> AsEnumerable(this AutomationElementCollection automationElements)
        {
            return automationElements.Cast<AutomationElement>();
        }
    }
}