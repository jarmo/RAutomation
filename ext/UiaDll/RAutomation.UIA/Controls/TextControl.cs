using System.Runtime.Remoting.Services;
using System.Windows.Automation;
using System.Windows.Forms;
using RAutomation.UIA.Extensions;

namespace RAutomation.UIA.Controls
{
    public class TextControl
    {
        private readonly AutomationElement _element;

        public TextControl(AutomationElement element)
        {
            _element = element;
        }

        public string Value
        {
            get { return _element.IsValuePattern() ? TextValue : DocumentText; }
            set
            {
                if (_element.IsValuePattern())
                    TextValue = value;
                else
                    DocumentText = value;
            }
        }

        private string DocumentText
        {
            get { return _element.AsTextPattern().DocumentRange.GetText(-1); }
            set
            {
                _element.SetFocus();
                Enter("^{HOME}", "^+{END}", "{DEL}", value);
            }
        }

        private static void Enter(params string[] keys)
        {
            keys.ForEach(SendKeys.SendWait);
        }

        private string TextValue
        {
            get { return _element.AsValuePattern().Current.Value; }
            set { _element.AsValuePattern().SetValue(value);  }
        }
    }
}
