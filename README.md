# Example default repository

## Structure

Initial repo structure planed

_build_ - holds make files to build a site from `example_profile`
_example_profile_ - folder with all code base
- _modules_ - custom modules that ship features and default content
- _themes_ - custom themes for project

_scripts_ - devops related scripts


## Local development usage

Use `cd scripts && ./up.sh` to run docker containers and install site.

## Staging and Live deployment

Copy **trusted.conf.dist** to **trusted.conf** and add trusted domain patterns.

TBD
