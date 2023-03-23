# flingthing

## Description
The complete scope of this project is not yet determined. But we'll be using the Sparkfun QuickLogic Thing Plus platform. We'll start with getting the board up and running and getting familiar with working on the platform. Eventually we'll work up to running a realtime OS on an optimized soft core processor for a streaming data application.

## Installation
git clone this repo.

## Usage
Build and load the FPGA/arm.

## Roadmap
If you have ideas for releases in the future, it is a good idea to list them in the README.

## Contributing
There are set of milestones for this project with issues attached to each. To contribute, create a new branch for a new or existing issue. Pull and check it out. Make local commits. Push local commits. Once the issue is resolved, submit a merge-request.
For algorithms and speciality hardware developed on this project, there should be accompanying testbenches that can be used to prove out or debug issues should the need arise (it will).
Handy git commands:
clone, pull, checkout, commit, push, stash, stash apply, stash list

## License
ZLIB maybe? eh...too soon.

## Project status
Just getting started.

## Environment Setup
Inside the qorc-sdk folder run the follwing

...
source envsetup.sh
...

## FAQ

Q: It says I need libncurses.so.5, how do I get that?

A: For Ubuntu, follow the instructions here: https://askubuntu.com/questions/1252062/how-to-install-libncurses-so-5-in-ubuntu-20-04?fbclid=IwAR2RaNvIVp9oU-ZcTWfNV5b5YPDBCLh8nVEkv-yaZcHqBHZqbe7Pt_uPvps 

## Using arm-none-eabi-gdb
```
> arm-none-eabi-gdb
...
(gdb) target extended-remote /dev/ttyACM0
...
(gdb) attach 1
...
(gdb)
...

