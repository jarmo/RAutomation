using System.Windows;
using System.Windows.Automation;

namespace RAutomation.UIA.Extensions
{
    public static class Element
    {
        public static SelectionItemPattern AsSelectionItem(this AutomationElement automationElement)
        {
            return (SelectionItemPattern)automationElement.GetCurrentPattern(SelectionItemPattern.Pattern);
        }

        public static bool Exists(this AutomationElement automationElement)
        {
            return null != automationElement;
        }

        public static string Name(this AutomationElement automationElement)
        {
            return automationElement.Current.Name;
        }

        public static string ClassName(this AutomationElement automationElement)
        {
            return automationElement.Current.ClassName;
        }

        public static bool IsEnabled(this AutomationElement automationElement)
        {
            return automationElement.Current.IsEnabled;
        }

        public static bool IsFocused(this AutomationElement automationElement)
        {
            return automationElement.Current.HasKeyboardFocus;
        }

        public static int NativeWindowHandle(this AutomationElement automationElement)
        {
            return automationElement.Exists() ? automationElement.Current.NativeWindowHandle : 0;
        }

        public static Rect BoundingRectangle(this AutomationElement automationElement)
        {
            return automationElement.Current.BoundingRectangle;
        }

        public static ControlType ControlType(this AutomationElement automationElement)
        {
            return automationElement.Current.ControlType;
        }

        public static int ProcessId(this AutomationElement automationElement)
        {
            return automationElement.Current.ProcessId;
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

        public static bool IsValuePattern(this AutomationElement automationElement)
        {
            return (bool) automationElement.GetCurrentPropertyValue(AutomationElement.IsValuePatternAvailableProperty);
        }

        public static ValuePattern AsValuePattern(this AutomationElement automationElement)
        {
            return (ValuePattern) automationElement.GetCurrentPattern(ValuePattern.Pattern);
        }

        public static TextPattern AsTextPattern(this AutomationElement automationElement)
        {
            return (TextPattern) automationElement.GetCurrentPattern(TextPattern.Pattern);
        }

        public static T As<T>(this AutomationElement automationElement, AutomationPattern pattern)
        {
            return (T) automationElement.GetCurrentPattern(pattern);
        }
    }
}