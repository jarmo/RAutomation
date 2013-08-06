using System.Collections.Generic;
using System.Linq;
using System.Windows.Automation;
using RAutomation.UIA.Extensions;
using RAutomation.UIA.Properties;

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

        public int SelectedIndex
        {
            get { return SelectionItems.IndexOf(x => x.Current.IsSelected); }
            set { DataItems.ElementAt(value).AsSelectionItem().Select(); }
        }

        public string Value
        {
            set { SelectionElements.First(x => x.Current.Name == value).AsSelectionItem().Select(); }
        }

        public bool Exists(int row, int column)
        {
            return At(row, column).Exists();
        }

        public string ValueAt(int row, int column)
        {
            return At(row, column).Current.Name;
        }

        public AutomationElement At(int row, int column)
        {
            return _element.FindOne(IsTableItem, GridItemPattern.ColumnProperty.Is(column), GridItemPattern.RowProperty.Is(row));
        }

        public string[] Headers
        {
            get { return _element.Find(ControlType.HeaderItem.Condition()).Select(x => x.Current.Name).ToArray(); }
        }

        public string[] Values
        {
            get { return TableOrListItems.Select(x => x.Current.Name).ToArray(); }
        }

        private IEnumerable<SelectionItemPattern> SelectionItems
        {
            get { return SelectionElements.Select(x => x.As<SelectionItemPattern>(SelectionItemPattern.Pattern)); }
        }

        private IEnumerable<AutomationElement> DataItems
        {
            get
            {
                return _element.Find(AutomationProperties.IsDataItem);
            }
        }

        private IEnumerable<AutomationElement> SelectionElements
        {
            get { return _element.Find(AutomationProperties.IsSelectionItem); }
        }

        private IEnumerable<AutomationElement> TableOrListItems
        {
            get { return _element.FindAny(IsTableItem, ControlType.ListItem.Condition()); }
        }

        private static Condition IsTableItem
        {
            get { return AutomationElement.IsTableItemPatternAvailableProperty.TrueCondition(); }
        }
    }
}
