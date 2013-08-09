using System.Windows.Automation;
using RAutomation.UIA.Extensions;

namespace RAutomation.UIA.Controls
{
    public class Spinner
    {
        private readonly AutomationElement _element;

        public Spinner(AutomationElement element)
        {
            _element = element;
        }

        public double Value
        {
            get { return RangeValue.Current.Value; }
            set { RangeValue.SetValue(value); }
        }

        public double Minimum
        {
            get { return RangeValue.Current.Minimum; }
        }

        public double Maximum
        {
            get { return RangeValue.Current.Maximum; }
        }

        public double Increment()
        {
            return Value += RangeValue.Current.SmallChange;
        }

        public double Decrement()
        {
            return Value -= RangeValue.Current.SmallChange;
        }

        private RangeValuePattern RangeValue
        {
            get { return _element.As<RangeValuePattern>(RangeValuePattern.Pattern); }
        }
    }
}
