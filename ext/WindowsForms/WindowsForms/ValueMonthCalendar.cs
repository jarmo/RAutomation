using System;
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
            get { return _monthCalendar.SelectionStart.ToShortDateString(); }
            set { _monthCalendar.SetDate(DateTime.Parse(value)); }
        }
    }
}