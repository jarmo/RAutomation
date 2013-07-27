using System;
using System.Runtime.InteropServices;
using System.Windows.Automation;
using System.Windows.Forms;

namespace RAutomation.UIA.Controls
{
    internal class Clicker
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

        public static void MouseClick(AutomationElement element)
        {
            element.SetFocus();
            var clickablePoint = element.GetClickablePoint();
            Cursor.Position = new System.Drawing.Point((int) clickablePoint.X, (int) clickablePoint.Y);
            mouse_event(MOUSEEVENTLF_LEFTDOWN, 0, 0, 0, 0);
            mouse_event(MOUSEEVENTLF_LEFTUP, 0, 0, 0, 0);
        }
    }
}