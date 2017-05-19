# Puppet Control Repository

## Overview

This Git repository contains a [Puppet Control repository](https://docs.puppet.com/pe/latest/cmgmt_control_repo.html) and holds references to all:
* Environments
* Puppet modules
* Roles and Profiles
* Hiera data
* Hiera configuration (hierarchy)

Used at this site.

## Environments
Each [Git branch](https://git-scm.com/book/en/v2/Git-Branching-Basic-Branching-and-Merging) in this control repository represents an environment in Puppet Enterprise.  An environment is the combination of a group of machines and a particular directory of Puppet code and usually also Hiera data, inside the `/etc/puppetlabs/code/environments/` directory.  On code deployment, Environments will be created automatically with names corresponding to git branches.  With the default puppet git branch being `production`, not `master` as is customary for Git projects.

Due to this being a fresh Puppet Enterprise deployment, all work was carried out directly in the `production` branch.  For real-world development, it's recommended to carry out development work in [feature branches](https://www.atlassian.com/git/tutorials/comparing-workflows#feature-branch-workflow) to build [pull requests](https://www.atlassian.com/git/tutorials/making-a-pull-request) for testing against a limited number of test nodes in a non-production environment.

## Modules

### Puppetfile
The [Puppetfile](https://docs.puppet.com/pe/latest/cmgmt_puppetfile.html#about-puppetfiles) describes all of the modules in use for a given environment.

Since environments in Puppet Enterprise are represented by branches, a different branch (environment) is able to have a different `Puppetfile` and thus may have a completely different set of modules to its neighbors.

Each [`mod` directive](https://github.com/puppetlabs/r10k/blob/master/doc/puppetfile.mkd#module-types) of the `Puppetfile` represents a different module to be installed.  For repeatable deployments, its vital that the exact version of every module used is specified, otherwise inadvertent upgrades (or non upgrades...) may occur.

Released versions of modules only get created automatically on the [Puppet Forge](https://forge.puppet.com/).  For modules that are only ever accessed though git, its vital that [Git tags](https://git-scm.com/book/en/v2/Git-Basics-Tagging) are created to represent each released module version and are referenced in the `Puppetfile` using the `:tag` attribute to prevent unintended code deployment.

### Roles and Profiles
Roles and Profiles are simply regular puppet modules that are used to abstract complexity away, to the point that each node normally has a single associated `role` class that loads all associated functionality using a single name.

Roles and Profiles for this Puppet Control Repository are stored as separate modules within the `/site` directory.

#### Roles
* A node is associated with a single role (eg `role::application_server`) and describes the business role of a node
* Roles only include profiles

#### Profiles
* A profile assembles functionality provided by modules and sometimes basic Puppet resources into a (hopefully) reusable body of code to perform a discreet task such as setup a web server or set the timezone.
* Explicit Hiera lookups should only take place at the profile level for reasons of simplicity and portability
* Ready-made profiles can be provided from other modules, such as [r_profile](https://forge.puppet.com/geoffwilliams/r_profile)


## Hiera

### Configuring the hierarchy
* The complete hiera hierarchy is described in the **production** branch of the control repository in the [`hierarchy.txt`](hieradata/hierarchy.txt) file.
* The file will be read verbatim and imported into [`hiera.yaml`](https://docs.puppet.com/hiera/3.2/configuring.html) as an array to populate the `:hierarchy:` key
* If the hierarchy needs to be altered, adjust `hierarchy.txt `as required and make sure changes are saved to the git repository.  Changes will become active the next the puppet agent runs on the master after redeploying the code.

### Hints and tips
Hiera can become a system thats deceptively simple to setup but almost impossibly complex to administer if users fall into some of the common 'traps' that initially look like great ways to manage complexity:
* Try to avoid using [`hiera_array()`](https://docs.puppet.com/puppet/latest/function.html#hieraarray), [`hiera_hash()`](https://docs.puppet.com/puppet/latest/function.html#hierahash) and friends.  They perform aggregate lookups across the entire hierarchy which while initially convenient can lead to conditions where the ripple effect of making a change in a 'base' hiera file is not realised until unintended change has happened
* Keep hierarchies as _simple_ as possible.  The duplication of producing hierarchies that mirror tables by interpolating multiple variables per hierarchy level gives data files that are both _much_ simpler to comprehend and that can be directly related back to tabular specification documents.  This is a worthwhile tradeoff vs insisting on de-duplicated data and also gives flexibility to adjust _rows_ of data in isolation in the future if required.
* Make sure your hieradata is valid before committing back to Git.  See testing section for details of how
* Copy and paste hiera key names from the relevant profiles and guards to avoid typos
* Ensure that the record separator `---` is only present _once_ at the very beginning of the file **including in comments!**.  Any additional separators will cause hiera data to mysteriously _vanish_ when you come to look it up.  Validating your `.yaml` files won't detect this either since this is technically valid syntax
* Learn about [yaml syntax](https://learn.getgrav.org/advanced/yaml)
* Learn about [hiera debugging techniques](https://puppet.com/blog/debugging-hiera-redux) available to you
* If you need to store passwords or sensitive data, consider encrypting using [hiera-eyaml](https://github.com/voxpupuli/hiera-eyaml)
* Alternatively, consider some of the newer systems that have appeared recently, such as [HashiCorp Vault](https://www.vaultproject.io/)

## Deploying code to Puppet Masters
Deployment of code to the Puppet Masters is coordinated from the Master of Masters node which when updated will distribute all changes to any compile masters in use.

To manually trigger deployment, SSH into the Puppet Master of Masters and become root, then run the command:

```shell
puppet code deploy --all --wait
```

### Warning
Never be tempted to deploy code to the Puppet Master by copying files directly the `/etc/puppetlabs/code` or `/etc/puppetlabs/code-staging` directories.  Despite being placed under `/etc` these folders are not intended to be user-modifiable _if using code manager and file sysnc_ are in use.  Indeed writing to these folder is usually enough to take down Puppet Enterprise completely. If this does occur, the solution is usually to remove all code in these directories and then use the `puppet code deploy` command to redeploy a fresh copy of all code.

## Reference
* [role](site/role/doc/index.html)
* [profile](site/profile/doc/index.html)

The documentation is no substitute for reading and understanding the module source code, and all users should ensure they are familiar and comfortable with the operations these module perform before using them.

## Limitations

* Not supported by Puppet, Inc.
* Requires in-depth testing prior to deployment

## Development

No further external development planned.  It is expected that:
* Additional environments will be branched from `production` in order to allow new developments without risking unintended changes reaching production infrastructure
* Development will take place in feature branches change will be controlled by configuring Bitbucket server to require pull requests, disallowing work to take place on the main branch
* This notice and the rest of the documentation will be actively updated to aid those working on the project in the future

## Testing
This module supports testing using [Onceover](https://github.com/dylanratcliffe/onceover).

To run [rspec-puppet](http://rspec-puppet.com/) tests and generate documentation:

```shell
bundle install
make
```

If modules are not updated correctly, you may need to first clear out the onceover cache:

```shell
rm -rf .onceover
```

Before running the `make` command again.

### Testing new role classes
To ensure a new role class is tested with onceover, it must be added to the classes array in `spec/onceover.yaml`

### Further information
See the main onceover github repository for nore details of how onceover works

### Internet access
Note that onceover (and bundle) expect free and easy internet access.  If you are behind a proxy server you will likely have problems, although exporting the relevant proxies using combinations of:
* `http_proxy`
* `https_proxy`
* `no_proxy`
May allow these tools to work.

If you are 'protected' by a corporate firewall, you may find that your best course of action is to temporarily join a less restrictive network in order to run the tests.

Alternatively, you may need to adjust the onceover command inside the `Makefile` to have it use your main `Puppetfile` for access to the corporate bitbucket server instead of using publicly hosted modules.
