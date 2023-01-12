---
permalink: /home/design-decisions/
---
# Two-Tier Structure
This approach distributes Bicep code over two tiers:
- assembler-tier
- core-tier

In most cases Azure resources are complex, i.e structured objects.
A complex resource may be composed of an arbitrary number of embedded child or referenced resources (s.b.).

Just take a look at a network interface card (NIC) as an example:
<img src="images\Network-Interface-Card.png">

So the job is to deploy complex resources composed of other resources, referenced or embedded.
Therefore, we create assembler- and core-modules.
An assembler knows how to create a complex resource and pulls everything together by consuming the necessary core-modules.

# Dealing with embedded children and references

- embedded (child) resources
- referenced resources

Child resources are bound to their respective parent. 
They cannot exists without this parent. 

References are resources with a lifecycle independent of any parent.
If a complex resource needs to reference another resource, it can either create and than referenced or
it simply already exists and gets referenced. But in any case, if the complex resource gets deleted, the 
referenced resource regularly continues to exist.
You can see this in the Azure portal when you delete complex objects like a Virtual Machine for example.
You have to decide whether attached (referenced) resources like the NIC shall be deleted along the line.

# Complex Parameters
Using complex, i.e. structured or object parameters is probably the most controversial decision because it seems to
be against how Bicep wants to be used.
Let me first describe the concept before going into the reasoning behind this decision.
## Using Complex Parameters
todo
## Why Complex Parameters
todo
