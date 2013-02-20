using System.Collections.Generic;
using System.Linq;
using System.Windows;
using System.Windows.Automation;
using System.Windows.Automation.Provider;
using System.Windows.Forms;

namespace WindowsForms.AutomationHelpers
{
    public abstract class AutomationProvider : IRawElementProviderFragmentRoot
    {
        private readonly Control _control;
        private readonly Dictionary<int, object> _properties;

        protected AutomationProvider(Control control)
        {
            _control = control;
            _properties = new Dictionary<int, object>
                              {
                                  {AutomationElementIdentifiers.ControlTypeProperty.Id, ControlType.Custom.Id}, 
                                  {AutomationElementIdentifiers.LocalizedControlTypeProperty.Id, _control.GetType().FullName}, 
                                  {AutomationElementIdentifiers.AutomationIdProperty.Id, _control.Name}, 
                                  {AutomationElementIdentifiers.IsKeyboardFocusableProperty.Id, true}, 
                              };
        }

        protected abstract List<int> SupportedPatterns { get; }

        protected const int ProviderUseComThreading = 0x20;
        public ProviderOptions ProviderOptions
        {
            get
            {
                return (ProviderOptions)((int)ProviderOptions.ServerSideProvider | ProviderUseComThreading);
            }
        }

        public IRawElementProviderSimple HostRawElementProvider
        {
            get { return AutomationInteropProvider.HostProviderFromHandle(_control.Handle); }
        }

        public Rect BoundingRectangle { get; private set; }

        public IRawElementProviderFragmentRoot FragmentRoot
        {
            get { return this; }
        }

        public object GetPropertyValue(int propertyId)
        {
            return _properties.Where(x => x.Key.Equals(propertyId))
                              .Select(x => x.Value)
                              .FirstOrDefault();
        }

        public object GetPatternProvider(int patternId)
        {
            return SupportedPatterns.Contains(patternId) ? this : null;
        }

        public IRawElementProviderSimple[] GetEmbeddedFragmentRoots()
        {
            return null;
        }

        public int[] GetRuntimeId()
        {
            return new[] { _control.GetHashCode() };
        }

        public void SetFocus()
        {
        }

        public IRawElementProviderFragment Navigate(NavigateDirection direction)
        {
            return null;
        }

        public IRawElementProviderFragment ElementProviderFromPoint(double x, double y)
        {
            return null;
        }

        public IRawElementProviderFragment GetFocus()
        {
            return null;
        }
    }
}