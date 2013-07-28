using System.Linq;
using System.Windows.Automation;
using RAutomation.UIA.Extensions;

namespace RAutomation.UIA.Controls
{
    public class TableControl
    {
        private readonly AutomationElement _element;

        public TableControl(AutomationElement element)
        {
            _element = element;
        }

        public string[] Headers
        {
            get { return _element.Find(ControlType.HeaderItem.Condition()).Select(x => x.Current.Name).ToArray(); }
        }
    }
}
