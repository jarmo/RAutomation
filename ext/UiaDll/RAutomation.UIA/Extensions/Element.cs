using System.Windows.Automation;

namespace RAutomation.UIA.Extensions
{
    public static class Element
    {
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

    }
}