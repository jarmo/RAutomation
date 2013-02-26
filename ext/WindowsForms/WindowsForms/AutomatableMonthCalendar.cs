using System;
using System.Collections.Generic;
using System.Globalization;
using System.Windows.Automation;
using System.Windows.Automation.Provider;
using System.Windows.Forms;
using WindowsForms.AutomationHelpers;

namespace WindowsForms
{
    public class AutomatableMonthCalendar : MonthCalendar
    {
        private MonthCalendarAutomationProvider _automationProvider;

        private IRawElementProviderSimple RawElementProviderSimple
        {
            get { return _automationProvider ?? (_automationProvider = new MonthCalendarAutomationProvider(this)); }
        }

        protected override void WndProc(ref Message m)
        {
            if (m.Msg == 0x3D /* WM_GETOBJECT */)
            {
                m.Result = AutomationInteropProvider.ReturnRawElementProvider(m.HWnd, m.WParam, m.LParam, RawElementProviderSimple);
                return;
            }

            base.WndProc(ref m);
        }
    }

    internal class MonthCalendarAutomationProvider : AutomationProvider, IValueProvider
    {
        private readonly MonthCalendar _control;

        public MonthCalendarAutomationProvider(MonthCalendar control)
            : base(control)
        {
            _control = control;
        }

        protected override List<int> SupportedPatterns
        {
            get { return new List<int> { ValuePatternIdentifiers.Pattern.Id }; }
        }

        public void SetValue(string value)
        {
            _control.SetDate(DateTime.Parse(value, new CultureInfo("en-US")));
        }

        public string Value
        {
            get { return _control.SelectionStart.ToString(new CultureInfo("en-US")); }
        }

        public bool IsReadOnly { get; private set; }
    }
}
