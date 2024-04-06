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

## Aggregators in ./py-2 
### Overview + Running 

#### Single File Aggregators:
* Aggregates parallel results when commands are applied to single file input.
* Single input to a command looks like: `wc hi.txt` 

| File | Aggregator    | Description | Notes   
| ---- | ------------- | ----------- | -----  
| `wc.py` | `s_wc` | <li>Combines each count for </li><li>Supports flags `-l, -c, -w, -m`</li> |   | Discripancy with combining byte size, might be due to file being split manually during  
 

#### Multiple File Aggregators:  
* Commands when ran on single file input vs. multiple file input often produce different results as file name often gets appended to the result
* Multiple inputs to a command looks like: `wc hi.txt bye.txt`  

| File | Aggregator    | Description | Sample Input + Output | Performance | Notes   
| ---- | ------------- | ----------- | --------------------- | ----------- | -----  
| `wc.py` | `m_wc` |  | ``` ``` 

### Performance 
