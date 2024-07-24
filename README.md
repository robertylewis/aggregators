# Aggregators

Currently aggregators are WIP. The new ones are in `cpp/bin`. They are automatically built during `setup_pash.sh` and the unit tests in `cpp/tests` are run during `run_tests.sh`. The interface is like the following:

```sh
aggregator inputFile1 inputFile2 args
```

Where `args` are the arguments that were passed to the command that produced the input files. The aggregator outputs to `stdout`.

## Adding new aggregators

Let's assume that the aggregator being implemented is for a command called `cmd`.

1. Create a folder named `cmd` inside `cpp/aggregators`

2. For each `OS` supported by PaSh:

   2.1 Create a file named `OS-agg.h` inside that folder

   2.2. Implement the aggregator inside that file using the instructions provided in `cpp/common/main.h` or use a different aggregator as an example. Remember about the include guard.

   2.3 You may create additional files in the aggregator directory. This can be used to share code between aggregator implementations for different `OS`es. When `#include`ing, assume that the aggregator directory is in the include path.

3. Add unit tests for the created aggregator in `cpp/tests/test-OS.sh` for each `OS`. Consult the instructions in that file. Remember to test all options and flags of the aggregator.

Note: after completing these steps the aggregator will automatically be built by the `Makefile` with no changes to it required.

# Aggregators in ./py-2

## Overview

- After running terminal commands on file inputs using parallelization with PaSh, we must find a way to combine those parallel outputs correctly so the parallel execution of command produced matches the sequential execution
- This directory contains:
  - several aggregators in python and bash scripts that reads parallel ouput results and combines them
  - util functions to assist with
    - reading + writing from/to files
    - parsing read input into string arrays for the aggregator functions
    - (for combining results of commands applied to multiple input files) matching command ran on split files in output by parsing out original full file name to ensure final combined result utilizes the original file name
  - benchmarks to test correctness, performance, and identify implemented/not implemented aggregators 

## Single File Argument Aggregators

### Overview

- Aggregates parallel results when commands are applied to single file input.
- Single input to a command looks like: `wc hi.txt`
- directly takes input argument from system argument; for example `./s_wc.py [parallel output file 1] [parallel output file 2]`

| Script          | Additional info. needed | Description                                                                                                                                                                   | Notes                        |
| --------------- | ----------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------- | ---------------------------- |
| `./s_wc.py`     | No                      | <li>Combines count results by adding relative values and add paddings to match result format </li><li>Supports flags `-l, -c, -w, -m`</li>                                    |                              |
| `./s_grep.sh`   | No                      | <li> Combines `grep` results (directly concat) <li>`.sh` for more accurate result compared to going through utilities file                                              |
| `./s_grep_c.py` | No                      | <li> Combines `grep -c` results from adding found line count</li>                                                                                                             |
| `./s_grep_n.py` | Yes                     | <li> Combines `grep -n` results by first making line corrections and then concat results</li> <li>Requires info on entire file before splitting to for line number correction | Needs to be refactored still |
| `./s_head.py` | No                     | <li> Combines `head` results by always returning former split document when given multiple split documents </li> | Test working on files with ~10 lines |
| `./s_tail.py` | No                     | <li> Combines `tail` results by always returning later split document when given multiple split documents </li> | Test working on files with ~10 lines |
| `./s_uniq.py` | No                     | <li> Combines `uniq` , merge same lines at end of files/beginning of files </li> | |
| `./s_uniq_c.py` | No                     | <li> Combines `uniq -c`, merge count </li> | |


### Benchmarks 

- `./inputs.sh`: retrieve all required inputs 
- `./run.sh` : run benchmark scripts with `bash` and `agg`
- `./verify.sh --generate`: generate hashes for all outputs to verify correctness 
- `./cleanup.sh`: removes all output + intermediate files generated by current run 

| Directory          | Description | Notes  
| --------------- | ----------------------- | ----------------------------------------------------------------------------------------------------------------------------------------------------------------------------- |
| unix50      | Collection of oneline scripts to run on input `txt` files |  use `--reg` flag for current available inputs retrieved by input script |                                    
| oneliners   | Collection of oneline scripts to run on input `txt` files  | some scripts involving `mkfifo` cannot be tested currently due to current parsing simplicity | 
| covid-mts   | Script to process data on covid mass-transports     |      |

#### Aggregators in benchmarks: 
- `./agg_run.sh [script] [input]` : applies available `agg` on scripts with `cmd` separated by `|` 
   -  `CMDMAP`: includes all current available `agg` for cmds + flags  
   - parse script into `CMDLIST`, running below with each cmd: 
      - if current cmd has implemented `agg`, split file into `SIZE=2` and apply `./test-par-driver.sh` to run each split file with cmd and apply `agg` 
      - if current cmd doesn't have implemented `agg`, run script through this command sequentially with `./test-seq-driver.sh`
      - output becomes the new input to next iteration 
   - records script + input ran and whether each cmd has a `agg` to `log.txt`
- `./find-missing.sh [log.txt]`: outputs only cmd that doesn't have a `agg` implemented
   - `py-2/missing-agg`: contains comprehensive list of cmds from benchmarks scripts above that doens't have a `agg` yet

## Multiple File Argument Aggregators

- Commands when ran on single file input vs. multiple file input often produce different results as file name often gets appended to the result
- Multiple inputs to a command looks like: `wc hi.txt bye.txt` and would produce outputs that looks like

```
     559    4281   25733 inputs/hi.txt
     354    2387   14041 inputs/bye.txt
     913    6668   39774 total
```

- directly takes input argument from system argument; for example, enter in your terminal
  `python m_wc.py [parallel output file 1] [parallel output file 2]`

| File To Run   | Additional info. needed                                                                                 | Description                                                                                                                                             | Notes                                                                                                              |
| ------------- | ------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------------------------------------------- | ------------------------------------------------------------------------------------------------------------------ |
| `m_wc.py`     | N/A                                                                                                     | <li>Combines count results, appends source file name to end, includes total count</li><li>Supports flags `-l, -c, -w, -m`</li>                          | Discripancy with combining byte size (might be due to manually splitting file to create parallel input in testing) |
| `m_grep.py`   | after parallel output args: `full [path to original file 1] [path to original file 2] <more if needed>` | <li> Combines `grep` results, sort output based on source file </li>                                                                                    |
| `m_grep_c.py` | N/A                                                                                                     | <li> Combines `grep -c`, apprend prefix source file name, includes total count</li>                                                                     |
| `m_grep_n.py` | Yes                                                                                                     | <li> Combines `grep -n`, makes line correction accordingly to file</li> <li>Requires info on entire file before splitting to for line number correction | Needs to be refactored still                                                                                       |

<i>Note: all multiple argument combiners requires a [file_list] argument that is a list of all the full files utilized in the call</i>

### Testing

- testing scripts produce all relevant files directed to `/outputs` when given files in `/inputs` to produce sequential / parallel results on
- Run `./test-mult.sh` in `test-old` directory:
  1. manually split files (multiple) into 2 -- put in `/input `
  2. apply command to entire file for sequential output (expected)
  3. apply command to file-1 > output/output-1
     apply command to file-2 > output/output-2
  4. apply aggregators to combine output/output-1 output/output-2 for parallel outpus (requires path of the full files for functions such as line correction in `grep -n`)
  5. eye check that parallel outputs = sequential output
     NOTE: use `m_combine` from the [cmd].py file as aggregators
