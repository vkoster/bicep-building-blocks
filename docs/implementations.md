---
permalink: /implementations/
title: Implementations
description: This page describes the implementation of some selected assemblers.
---
# Some Implementations in Detail
{% for link in site.data.navigation %}
- [{{ link.name }}]({{ link.file }})
{% endfor %}

## Implementation of a Network Interface Card (NIC)
A NIC can be a quite complex resource. The current implementation discussed here covers only a small subset
of what can be done.

Here the picture of what will be deployed:

<img src="{{site.baseurl}}/images/Network-Interface-Card.png">

The implementing covers the following list of requirements:

- we want to 
  - assign an existing virtual network's subnet 
  - optionally assign a public IP-address (PIP)
    - which is already existing 
    - which has to be created upfront
  - optionally assign a Network Security Group (NSG)
    - which is already existing
    - which has to be created upfront

There is one exception to mention here: according to the plan, IP Configuration resources should have been created by 
the core module, as IP Configurations are child resource to a NIC:

<img src="{{site.baseurl}}/images/nic-reference.png">

But according to the documentation, IP Configurations is a read-only resource type that can only used with the Bicep "existing"
keyword. Therefore, IP Configurations won't be a separate parameter but will be part of the NIC properties.

Speaking of parameters, lets have a look of how to configure a NIC.

### NIC Parameters
You will find the complete parameter file in the [Repository](https://github.com/vkoster/reusable-bicep-modules/blob/main/deploy/assembler/nic/de/az700/dev/instance01.json).
I will only point out parts of it here.

````
...
"parameters": {
  "vnetName": {
    "value": "vnet-az700-01"
  },
  "snetName": {
    "value": "subnet1"
  },
...
````

These are the names the virtual network and the subnet that the NIC shall reference.
This assumes the network as already existing. The NIC assembler will never itself create a network.
These parameters are used to find the vnet/snet the NIC will reference.

The next parameters describe the public IP address that is to be assigned to the NIC:
````
...
  "existingPip": {
    "value": false
  },
  "newPip": {
    "value": true
  },
  "pipName": {
    "value": "pip-az700-01"
  },
  "pipSku": {
    "value": {
        "name": "Basic"
    }
  },
  "pipProperties": {
      "value": {
          "publicIPAddressVersion": "IPv4",
          "publicIPAllocationMethod": "Dynamic"
      }
  },
...
````
``existingPip`` and ``newPip`` are boolean parameters that let us decide 
on whether we want to assign an exising PIP or one that is to be created by the
assembler itself.

Here are the rules:
- ``existingPip`` = true: assign an existing PIP
- ``existingPip`` = false: do not assign an existing PIP
- ``newPip`` = true: create and then assign new PIP
- ``newPip`` = false: do not create and do not assign a new PIP
- if both parameters are set to ``false`` no PIP will be assigned at all
- both parameters set to ``true`` is a configuration error (which the implementation does not catch as of now)

The next parameters describe the PIP itself:
````
"pipName": {
  "value": "pip-az700-01"
},
"pipSku": {
  "value": {
      "name": "Basic"
  }
},
"pipProperties": {
    "value": {
        "publicIPAddressVersion": "IPv4",
        "publicIPAllocationMethod": "Dynamic"
    }
},
...
````
Altogether, this allows us to fulfill all our PIP requirements.
We can configure, if we want to assign a Pip at all. If "yes" then
we can decide if we want a new one to be created or an existing one to be used.

Please note that in the real world you won't have to specify ``pipSKU`` and ``pipProperties`` if you want to 
assign an existing PIP, which would only require the name.
I included both options here in on parameter file just for demonstration purposes.


