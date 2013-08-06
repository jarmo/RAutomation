using System.Windows.Automation;
using RAutomation.UIA.Extensions;

namespace RAutomation.UIA.Properties
{
    public class AutomationProperties
    {
        public static Condition IsSelectionItem
        {
            get { return new PropertyCondition(AutomationElement.IsSelectionItemPatternAvailableProperty, true); }
        }

        public static Condition IsDataItem
        {
            get { return ControlType.DataItem.Condition(); }
        }
    }
}