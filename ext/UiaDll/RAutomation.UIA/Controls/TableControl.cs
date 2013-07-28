using System.Collections.Generic;
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

        public int RowCount
        {
            get { return _element.As<TablePattern>(TablePattern.Pattern).Current.RowCount; }
        }

        public string[] Headers
        {
            get { return _element.Find(ControlType.HeaderItem.Condition()).Select(x => x.Current.Name).ToArray(); }
        }

        public string[] Values
        {
            get { return TableOrListItems.Select(x => x.Current.Name).ToArray(); }
        }

        private IEnumerable<AutomationElement> TableOrListItems
        {
            get { return _element.FindAny(AutomationElement.IsTableItemPatternAvailableProperty.TrueCondition(), ControlType.ListItem.Condition()); }
        }
    }
}
