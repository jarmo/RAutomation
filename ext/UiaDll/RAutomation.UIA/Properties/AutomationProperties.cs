using System.Windows.Automation;

namespace RAutomation.UIA.Properties
{
    public class AutomationProperties
    {
        public static Condition IsSelectionItem
        {
            get { return new PropertyCondition(AutomationElement.IsSelectionItemPatternAvailableProperty, true); }
        }
    }
}