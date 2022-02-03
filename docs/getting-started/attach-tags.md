# Attach Tags

## Introduction

Tags are free-form text labels attached to one or more systems in your account. Tags allow administrators to group systems together which share similar characteristics (i.e. business unit, security level or function). Tags can be manually added to an enrolled system, or an Enrolment Key can be configured to apply an initial set of Tags to enrolling systems.

The following graphic illustrates how Tags could be applied to enrolled systems. Each enrolled system, the workstation `desktop-d983gw` and the server `gitlab` are members of Tags specific to their function; both systems are also members of the ==org.any== Tag.

> When using tags in the portal, they have a particular style, so ==org.any== is a tag, ==dev.internal== is a tag, and so on. Where we reference tags in our docs we'll use the same format.

![Illustration of how tags are applied to systems](/images/quick-start/tags.png)

> **Production use:** This guide suggests example Tags. You can (and should) create Tags which reflect the structure of your organisation for use in production. Visit the [Tags](/management/tags#naming) section of the handbook to learn more about creating, naming and managing Tags.

## Add Tags

In the Portal, navigate to the `Systems` page and confirm at least two systems are enrolled and showing as connected.
![Illustration of how tags are applied to systems](/images/quick-start/system-details-pane.png)

### Tag your first system

1. Select the **first** system you've enrolled to open its details pane.
2. Use the pencil icon (top-right of the pane) to enter edit mode. 
3. Give this first system a recognisable description (_e.g. Jane's Laptop_).
4. Add the Tags ==org.workstations== and ==org.any== to this first system and click Save.


### Tag your second system

1. Open the details pane for the **second** system you've enrolled. 
2. Use the pencil icon to enter edit mode.
3. Give the second system a recognisable description (_e.g. Web Server_).
4. Add the Tags ==org.servers== and ==org.any== to this second system and click Save.

### Summary

The Portal should indicate that you've assigned two Tags to each system:

| System                         | Description          | Tags                              |
| ------------------------------ | -------------------- | --------------------------------- |
| The first system you enrolled  | _e.g. Jane's Laptop_ | ==org.workstations==<br />==org.any== |
| The second system you enrolled | _e.g. Web Server_    | ==org.servers==<br />==org.any==      |

Great! You've successfully tagged your first systems. Next [define a policy](/getting-started/define-policy) to establish connectivity between them.
