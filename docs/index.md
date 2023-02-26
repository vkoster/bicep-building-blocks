---
permalink: /
title: Reusable Bicep Modules
tags: [Bicep, Azure, IaC, infrastructure-as-code, reusable, modules]
---
# Welcome to my Reusable Bicep Modules pages!
This project is an effort to create reusable Bicep modules.
Focus lies on researching reuse, not on actually creating a library.

{% for link in site.data.navigation %}
  - [{{ link.name }}]({{ link.file }})
{% endfor %}

## Abstract
This is a collection of ideas on how to create reusable Bicep modules.
Currently, these are the basic concepts:
- use two layers: assemblers and core modules
- expose template fragments as parameters instead of single values
- during assembly of a resource:
  - use Bicep's ``union()`` function to inject references to other resources
  - use Bicep's ternary operator ``?`` to deal with optional assignments of other resources
- use the Azure resource types and namespace hierarchy to shape the modules

## Background and Motivation
Bicep is a big improvement compared to directly deploying ARM templates.
Apart from being much more readable, it wants us to reuse stuff by introducing modules.
But as it turned out during the last 2 years, real reuse still is quite hard to achieve.

I think that reusability cannot be achieved by specifying parameters as primitive values.

Why is this not a good idea:
- there will be too many of them
- they are out of context
- adding one, changes the module's signature and causes breaking changes

The last point is the most important one as it is the death of reuse.

The solution described here exposes template fragments as parameters. Maybe this is also not ideal for other reasons.
Nevertheless, I gave this a try and share the results here.

The repository on which this site is based, contains the current state of the implementation.

- [design decisions](design-decisions.md) describes the approach
- [deployment](deployment.md) describes how the deployment to Azure works
- [implementations](implementations.md) goes into implementation details of selected modules

Currently, the NIC assembler is the most complex one as it assembles a lot of resources and solves the 
problem of optionally assigning resources. It also lets you choose between assigning existing or 
newly created resources for assignment. A detailed description of its code is [here](implementations.md).
Other assemblers still habe to be leveled up.

## Valuable Links
A small collection of links on Bicep that I found very helpful:
- [Alex Chzhen's blog posts on IaC](https://ochzhen.com/tags/#infrastructure-as-code-1)
  - if he explains a topic, you will be hard pressed to find better explanations elsewhere
- [Eduard Keilholz's post on creating a bicep library](https://hexmaster.nl/posts/centralize-bicep-templates-in-acr/)
  - this post triggert me into thinking more about reusing Bicep
- [Getting Started with Azure Bicep (Step-by-Step)](https://adamtheautomator.com/azure-bicep/)
  - "Adam the Author" - I love this site
- [John Savill - Understanding and Using Project Bicep](https://www.youtube.com/watch?v=_yvb6NVx61Y&ab_channel=JohnSavill%27sTechnicalTraining)
  - John Savill's introduction to the Bicep project on YouTube

This is only a small and very personal selection. The Microsoft documentation is very good and there are a number of 
great books on Bicep available by now.

## Utility commands
````
// What is my current tenant:
az account show

// list all my accouts
az account list
// attach a default subscription to an account
az account set --subscription <my subscription>
````

## Disclaimer
Things to notice:
- I am by no means a Bicep-professional (experience comes from 2 years of Bicep in a large, real-life project)
- My company [MT-itsolutions](https://www.mt-itsolutions.com/) favors Terraform over Bicep for reasons I will not discuss here
  - That's one reason why I'm posting this in a personal repo
- My company [MT-itsolutions](https://www.mt-itsolutions.com/) is not to blame for my follies
  - I am to blame for any nonsense and all errors published on this site
- You are using this repo at your own risk
  - I take no responsibility for any damage caused by code published here
- This is my first take on GitHub Pages, and I'm not a frontend guy - have mercy

|[home](index.md) | [design decisions](design-decisions.md)| [deployment](deployment.md)| [implementations](implementations.md) |

