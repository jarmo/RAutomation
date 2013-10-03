using System;
using System.Runtime.InteropServices;
using System.Threading;
using System.Windows;
using System.Windows.Automation;
using System.Windows.Forms;
using RAutomation.UIA.Extensions;

namespace RAutomation.UIA.Controls
{
    public class Clicker
    {
        [DllImport("user32.dll")]
        static extern void mouse_event(uint flags, uint x, uint y, uint data, int extraInfo);

        [Flags]
        public enum MouseEvent
        {
            Leftdown = 0x00000002,
            Leftup = 0x00000004,
        }

        private const uint MOUSEEVENTLF_LEFTDOWN = 0x2;
        private const uint MOUSEEVENTLF_LEFTUP = 0x4;

        public static bool Click(AutomationElement element)
        {
            try
            {
                if (AutomationElement.IsInvokePatternAvailableProperty.In(element))
                {
                    element.As<InvokePattern>(InvokePattern.Pattern).Invoke();
                }
                else if (AutomationElement.IsTogglePatternAvailableProperty.In(element))
                {
                    element.AsTogglePattern().Toggle();
                }
                else if (AutomationElement.IsSelectionItemPatternAvailableProperty.In(element))
                {
                    element.AsSelectionItem().Select();
                }

                return true;
            }
            catch (Exception e)
            {
                Console.WriteLine(e);
                return false;
            }
        }

        public static void MouseClick(AutomationElement element)
        {
            element.ScrollToIfPossible();
            element.SetFocus();

            var clickablePoint = element.GetClickablePoint();
            Cursor.Position = new System.Drawing.Point((int)clickablePoint.X, (int)clickablePoint.Y);
            mouse_event(MOUSEEVENTLF_LEFTDOWN, 0, 0, 0, 0);
            mouse_event(MOUSEEVENTLF_LEFTUP, 0, 0, 0, 0);
        }
    }
}