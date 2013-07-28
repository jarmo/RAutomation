using System.Windows.Automation;

namespace RAutomation.UIA.Extensions
{
    public static class ControlTypeExtensions
    {
        public static Condition Condition(this ControlType controlType)
        {
            return new PropertyCondition(AutomationElement.ControlTypeProperty, controlType);
        }
    }
}