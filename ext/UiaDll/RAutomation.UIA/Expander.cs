using System.Collections.Generic;
using System.Linq;
using System.Windows.Automation;
using RAutomation.UIA.Extensions;

namespace RAutomation.UIA
{
    public class ExpandibleCollapsibleContainer
    {
        protected readonly AutomationElement _element;

        protected ExpandibleCollapsibleContainer(AutomationElement element)
        {
            _element = element;
        }

        protected IEnumerable<ExpandCollapsePattern> ExpandCollapsItems
        {
            get { return Elements.Select(x => x.As<ExpandCollapsePattern>(ExpandCollapsePattern.Pattern)); }
        }

        protected IEnumerable<AutomationElement> Elements
        {
            get { return _element.Find(AutomationElement.IsExpandCollapsePatternAvailableProperty.TrueCondition()); }
        }
    }

    public class Expander : ExpandibleCollapsibleContainer
    {
        public Expander(AutomationElement element) : base(element)
        {}

        public void Expand(int index)
        {
            ExpandCollapsItems.ElementAt(index).Expand();
        }

        public void Expand(string value)
        {
            Elements.FirstOrDefault(x => x.Current.Name == value).As<ExpandCollapsePattern>(ExpandCollapsePattern.Pattern).Expand();
        }
    }

    public class Collapser : ExpandibleCollapsibleContainer
    {
        public Collapser(AutomationElement element) : base(element)
        {}

        public void Collapse(int index)
        {
            ExpandCollapsItems.ElementAt(index).Collapse();
        }

        public void Collapse(string value)
        {
            Elements.FirstOrDefault(x => x.Current.Name == value).As<ExpandCollapsePattern>(ExpandCollapsePattern.Pattern).Collapse();
        }
    }
}
