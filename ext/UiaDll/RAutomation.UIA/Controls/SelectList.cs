using System.Collections.Generic;
using System.Linq;
using System.Windows.Automation;

namespace RAutomation.UIA.Controls
{
    public class AutomationProperties
    {
        public static Condition IsSelectionItem
        {
            get { return new PropertyCondition(AutomationElement.IsSelectionItemPatternAvailableProperty, true); }
        }
    }

    public class SelectList
    {
        private readonly AutomationElement _element;

        public SelectList(AutomationElement element)
        {
            _element = element;
        }

        public string[] Options
        {
            get { return SelectionItems.Names().ToArray();  }
        }

        public int SelectedIndex
        {
            get { return SelectionItems.IndexOf(IsSelected); }
        }

        private static bool IsSelected(AutomationElement element)
        {
            return element.AsSelectionItem().Current.IsSelected;
        }

        private IEnumerable<AutomationElement> SelectionItems
        {
            get { return _element.Find(AutomationProperties.IsSelectionItem); }
        }
    }
}
