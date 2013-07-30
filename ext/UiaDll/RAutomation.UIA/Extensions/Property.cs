using System.Windows.Automation;

namespace RAutomation.UIA.Extensions
{
    public static class Property
    {
        public static Condition Condition(this ControlType controlType)
        {
            return new PropertyCondition(AutomationElement.ControlTypeProperty, controlType);
        }

        public static Condition TrueCondition(this AutomationProperty property)
        {
            return new PropertyCondition(property, true);
        }

        public static Condition Is(this AutomationProperty property, object value)
        {
            return new PropertyCondition(property, value);
        }

        public static bool In(this AutomationProperty property, AutomationElement element)
        {
            return (bool) element.GetCurrentPropertyValue(property);
        }
    }
}