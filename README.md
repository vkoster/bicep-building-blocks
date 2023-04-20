# Welcome to my Reusable Bicep Modules pages!
This project is an effort to create reusable Bicep modules.
Focus lies on researching reuse, not on actually creating a library.

The documentation to this project is published on a [GitHub Pages Site](https://vkoster.github.io/reusable-bicep-modules/).

## Disclaimer
Things to notice:
- I am by no means a Bicep-professional (experience comes from 2 years of Bicep in a large, real-life project)
- My company [MT-itsolutions](https://www.mt-itsolutions.com/) favors Terraform over Bicep for reasons I will not discuss here
  - That's one reason why I'm posting this in a personal repo
- My company [MT-itsolutions](https://www.mt-itsolutions.com/) is not to blame for my follies
  - I take full responsibility for any nonsense and all errors published on this site
- You are using this repo at your own risk
  - I take no responsibility for any damage caused by code published here

## Background and Motivation
Bicep is a big improvement compared to directly deploying ARM templates.
Apart from being much more readable, it wants us to reuse stuff by introducing modules.
But as it turned out during the last 2 years, real reuse still is quite hard to achieve.

It is my personal opinion that reusability cannot be achieved by specifying all parameters as primitive values.

Why is this not a good idea:
- there will be too many of them
- they are out of context
- adding one, changes the module's signature and is a breaking change

The last point is the most important one as it is the death of reuse.

The solution described here exposes template fragments as parameters. Maybe this is also not ideal for other reasons.
Nevertheless I gave this try and share the results here.

Currently, the NIC assembler is the most complex one as it assembles a lot of resources and solves the
problem of optionally assigning resources. It also lets you choose between assigning existing or
newly created resources.

## Currently Available Modules
Here's a list of the currently available modules and their reuse by parent-modules:
- public IP address (pip)
- network security group (nsg)
  - child: security rules (nsgsr)
- network interface card (nic)
  - reference: virtual network (vnet)
  - reference: subnet (snet)
  - reference: public IP address (pip)
  - reference: network security group (nsg)
- virtual network (vnet)
  - child: subnet (snet)
- virtual network peering (vnet-peer)
- virtual machine (vm)
  - reference: network interface card (nic)
- storage account (st)
  - child: blob services/containers

## Utility commands
````
// What is my current tenant:
az account show

// list all my accouts
az account list
// attach a default subscription to an account
az account set --subscription <my subscription>
````

The documentation to this project is published on a [GitHub Pages Site](https://vkoster.github.io/reusable-bicep-modules/).