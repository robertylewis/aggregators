#!/usr/bin/env python3

import utils, argparse, functools 

parser = argparse.ArgumentParser(description="Check which flags we use for grep")
parser.add_argument('-c', action='store_true', help="grep count")
parser.add_argument('file', type=argparse.FileType('r'), nargs="*", help="input files to sort agg")
args, unknown = parser.parse_known_args()

def grep(a, b): 
    return a + b

def grep_c(a,b):
    '''
    Combiner for grep with -c count flag 

    Returns: 
         a string result of all grep -c results after adding together and separated by newline 
    '''
    if len(a) == 0: 
        return b
    elif len(b) == 0: 
        return a
    else: 
        parallel_res = [str(a),str(b)]
        num1 = int(parallel_res[0].strip("[]'\\n"))  
        num2 = int(parallel_res[1].strip("[]'\\n"))  
        return str(num1 + num2)
    
def agg(a, b): 
    if args.c:
        return grep_c(a,b)
    else: 
        return grep(a, b)

res = functools.reduce(agg, utils.read_all(), [])
utils.out("".join(res)) 