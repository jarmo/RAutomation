using System.Collections.Generic;
using System.Linq;
using System.Windows.Automation;
using RAutomation.UIA.Extensions;
using RAutomation.UIA.Properties;

namespace RAutomation.UIA.Controls
{
    public class SelectList
    {
        private readonly AutomationElement _element;

        public SelectList(AutomationElement element)
        {
            _element = element;
        }

        public string[] Options
        {
            get { return SelectionItems.Names().ToArray(); }
        }

        public int Count
        {
            get { return SelectionItems.Count(); }
        }

        public int SelectedIndex
        {
            get { return SelectionItems.IndexOf(IsSelected); }
            set { Select(SelectionItems.ElementAt(value)); }
        }

        public string At(int index)
        {
            return SelectionItems.ElementAt(index).Current.Name;
        }

        public string Selection
        {
            get
            {
                var selection = SelectionItems.FirstOrDefault(IsSelected);
                return null == selection ? "" : selection.Current.Name;
            }
            set
            {
                Select(SelectionItems.First(x => x.Current.Name == value));
            }
        }

        public string[] Selections
        {
            get { return SelectionPattern.GetSelection().Select(x => x.Current.Name).ToArray(); }
        }

        public void Remove(int index)
        {
            SelectionItems.ElementAt(index).AsSelectionItem().RemoveFromSelection();
        }

        public void Remove(string value)
        {
            SelectionNamed(value).RemoveFromSelection();
        }

        private void Select(AutomationElement element)
        {
            if (SelectionPattern.CanSelectMultiple)
                MultipleSelect(element);
            else
                SingleSelect(element);
        }

        private static void MultipleSelect(AutomationElement element)
        {
            element.AsSelectionItem().AddToSelection();
        }

        private static void SingleSelect(AutomationElement element)
        {
            var selectionItem = element.AsSelectionItem();

            try
            {
                Clicker.MouseClick(element);
            }
            catch { }

            if (!selectionItem.Current.IsSelected)
                selectionItem.Select();
        }

        private SelectionPattern.SelectionPatternInformation SelectionPattern
        {
            get { return _element.As<SelectionPattern>(System.Windows.Automation.SelectionPattern.Pattern).Current; }
        }

        private SelectionItemPattern SelectionNamed(string value)
        {
            return SelectionItems.First(x => x.Current.Name == value).AsSelectionItem();
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
