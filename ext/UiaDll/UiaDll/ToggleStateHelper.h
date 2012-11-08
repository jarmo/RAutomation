#pragma once
class ToggleStateHelper
{
public:
	ToggleStateHelper(void);
	~ToggleStateHelper(void);

	BOOL IsSet(IUIAutomationElement* automationElement);
};

