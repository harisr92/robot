# Robot
![test](https://github.com/harisr92/robot/actions/workflows/spec.yml/badge.svg)
A robot which is moving on top of a table

## Execute commands from command line

``` shell
./bin/robot execute -c "\
PLACE 0,0,NORTH
MOVE
REPORT
RIGHT
MOVE
REPORT
LEFT
"
```

## Execute commands from file

A command should be placed in a line
``` shell
./bin/robot execute -f /path/to/file
```
[example file](spec/templates/commands.txt)

## Place the robote on table
```shell
./bin/robot PLACE 0,0,NORTH
```

## Move robot one unit
```shell
./bin/robot MOVE
```

## Change direction to left
```shell
./bin/robot left
```

## Change direction to right
```shell
./bin/robot right
```

## Get position of robot
```shell
./bin/robot position

Output: 0,0,NORTH
```
