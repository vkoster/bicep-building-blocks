---
permalink: /home/
title: Reusable Bicep Building Blocks
---
# Welcome to the Bicep-building-blocks pages!
This project is an effort to create reusable Bicep building-blocks.
Focus lies on researching reuse, not on actually creating a library.

## Disclaimer
Things to notice:
- I am by no means a Bicep-professional (experience comes from 2 years of Bicep in a large, real-life project)
- My company [MT-itsolutions](https://www.mt-itsolutions.com/) favors Terraform over Bicep for reasons I will not discuss here
  - That's why I'm posting this in a personal repo

## Background and Motivation
Bicep is a big improvement compared to directly deploying ARM templates.
Apart from being much more readable, it wants us to reuse stuff by introducing modules.
But as it turned out during the last 2 years, real reuse still is quite hard to achieve.

The approach described here, tries to address the challenges we encountered.
Some decisions taken here are quite obvious, whereas other are admittedly not in alignment with how Bicep seems to want things to be.
So please be careful and take what you see here with a grain of salt.
On the other hand, I can take a beating and embrace other opinions that I will be listening to with great interest.  

## Utility commands
````
// What is my current tenant:
az account show

// list all my accouts
az account list
// attach a default subscription to an account
az account set --subscription <my subscription>
````



