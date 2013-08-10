using System;
using System.Globalization;
using System.Windows.Forms;
using UIA.Extensions.AutomationProviders.Interfaces;

namespace WindowsForms
{
    public class ValueMonthCalendar : ValueControl
    {
        private readonly MonthCalendar _monthCalendar;

        public ValueMonthCalendar(MonthCalendar monthCalendar) : base(monthCalendar)
        {
            _monthCalendar = monthCalendar;
        }

        public override string Value
        {
            get { return _monthCalendar.SelectionStart.ToString("d", EnglishCulture); }
            set { _monthCalendar.SetDate(DateTime.Parse(value, EnglishCulture)); }
        }

        private static CultureInfo EnglishCulture
        {
            get { return new CultureInfo("en-US"); }
        }
    }
}