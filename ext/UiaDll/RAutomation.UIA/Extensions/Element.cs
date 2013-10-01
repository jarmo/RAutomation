using System;
using System.Threading;
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

        public static string HelpText(this AutomationElement automationElement)
        {
            return automationElement.Current.HelpText;
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

        public static bool IsOffscreen(this AutomationElement automationElement)
        {
            return automationElement.Current.IsOffscreen;
        }

        public static TogglePattern AsTogglePattern(this AutomationElement automationElement)
        {
            return (TogglePattern)automationElement.GetCurrentPattern(TogglePattern.Pattern);
        }

        public static bool IsToggled(this AutomationElement automationElement)
        {
            return automationElement.AsTogglePattern().Current.ToggleState == ToggleState.On;
        }

        public static string Value(this AutomationElement automationElement)
        {
            return automationElement.AsValuePattern().Current.Value;
        }

        public static void SendKeys(this AutomationElement automationElement, string keysToSend)
        {
            automationElement.SetFocus();
            System.Windows.Forms.SendKeys.SendWait(keysToSend);
        }

        public static void SetValue(this AutomationElement automationElement, string value)
        {
            automationElement.AsValuePattern().SetValue(value);
        }

        public static bool IsValuePattern(this AutomationElement automationElement)
        {
            return (bool)automationElement.GetCurrentPropertyValue(AutomationElement.IsValuePatternAvailableProperty);
        }

        public static bool CanScrollTo(this AutomationElement automationElement)
        {
            return (bool)automationElement.GetCurrentPropertyValue(AutomationElement.IsScrollItemPatternAvailableProperty);
        }

        public static ScrollItemPattern AsScrollItem(this AutomationElement automationElement)
        {
            return automationElement.As<ScrollItemPattern>(ScrollItemPatternIdentifiers.Pattern);
        }

        public static bool HasClickablePoint(this AutomationElement automationElement)
        {
            Point point;
            return automationElement.TryGetClickablePoint(out point);
        }

        public static bool ScrollToIfPossible(this AutomationElement automationElement)
        {
            if (!automationElement.CanScrollTo())
            {
                return false;
            }

            if (!automationElement.HasClickablePoint())
            {
                automationElement.AsScrollItem().ScrollIntoView();
                automationElement.WaitUntilClickable(3);
            }

            return true;
        }

        public static void WaitUntilClickable(this AutomationElement automationElement, int howManySeconds)
        {
            var then = DateTime.Now;
            while (!automationElement.HasClickablePoint())
            {
                Thread.Sleep(1);
                if ((DateTime.Now - then).Seconds > howManySeconds)
                {
                    throw new Exception(string.Format("Waited for more than {0} seconds to be able to click this", howManySeconds));
                }
            }
        }

        public static ValuePattern AsValuePattern(this AutomationElement automationElement)
        {
            return (ValuePattern)automationElement.GetCurrentPattern(ValuePattern.Pattern);
        }

        public static TextPattern AsTextPattern(this AutomationElement automationElement)
        {
            return (TextPattern)automationElement.GetCurrentPattern(TextPattern.Pattern);
        }

        public static T As<T>(this AutomationElement automationElement, AutomationPattern pattern)
        {
            return (T)automationElement.GetCurrentPattern(pattern);
        }
    }
}