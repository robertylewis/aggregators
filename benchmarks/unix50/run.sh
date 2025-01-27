#!/bin/bash

export SUITE_DIR=$(realpath $(dirname "$0"))
export TIMEFORMAT=%R
cd $SUITE_DIR

if [[ "$@" == *"--small"* ]]; then
    scripts_inputs=(
        "1;1_1M"
        "2;1_1M"
        "3;1_1M"
        "4;1_1M"
        "5;2_1M"
        "6;3_1M"
        "7;4_1M"
        "8;4_1M"
        "9;4_1M"
        "10;4_1M"
        "11;4_1M"
        "12;4_1M"
        "13;5_1M"
        "14;6_1M"
        "15;7_1M"
        "16;7_1M"
        "17;7_1M"
        "18;8_1M"
        "19;8_1M"
        "20;8_1M"
        "21;8_1M"
        "22;8_1M"
        "23;9.1_1M"
        "24;9.2_1M"
        "25;9.3_1M"
        "26;9.4_1M"
        "27;9.5_1M"
        "28;9.6_1M"
        "29;9.7_1M"
        "30;9.8_1M"
        "31;9.9_1M"
        "32;10_1M"
        "33;10_1M"
        "34;10_1M"
        "35;11_1M"
        "36;11_1M"
    )
elif [[ "$@" == *"--reg"* ]]; then
    scripts_inputs=(
        "1;1"
        "2;1"
        "3;1"
        "4;1"
        "5;2"
        "6;3"
        "7;4"
        "8;4"
        "9;4"
        "10;4"
        "11;4"
        "12;4"
        "13;5"
        "14;6"
        "15;7"
        "16;7"
        "17;7"
        "18;8"
        "19;8"
        "20;8"
        "21;8"
        # "22;8_1M"
        "23;9.1"
        "24;9.2"
        "25;9.3"
        "26;9.4"
        # "27;9.5_1M"
        "28;9.6"
        "29;9.7"
        "30;9.8"
        "31;9.9"
        "32;10"
        "33;10"
        "34;10"
        "35;11"
        "36;11"
    )
elif [[ "$@" == *"--single"* ]]; then
    scripts_inputs=(
        "4;1"
    ) # for debugging
else
    scripts_inputs=(
        "1;1_3G"
        "2;1_3G"
        "3;1_3G"
        "4;1_3G"
        "5;2_3G"
        "6;3_3G"
        "7;4_3G"
        "8;4_3G"
        "9;4_3G"
        "10;4_3G"
        "11;4_3G"
        "12;4_3G"
        "13;5_3G"
        "14;6_3G"
        "15;7_3G"
        "16;7_3G"
        "17;7_3G"
        "18;8_3G"
        "19;8_3G"
        "20;8_3G"
        "21;8_3G"
        # "22;8_3G"
        "23;9.1_3G"
        "24;9.2_3G"
        "25;9.3_3G"
        "26;9.4_3G"
        # "27;9.5_3G"
        "28;9.6_3G"
        "29;9.7_3G"
        "30;9.8_3G"
        "31;9.9_3G"
        "32;10_3G"
        "33;10_3G"
        "34;10_3G"
        "35;11_3G"
        "36;11_3G"
    )
fi

mkdir -p "outputs"
all_res_file="./outputs/unix50.res"

# time_file stores the time taken for each script
# mode_res_file stores the time taken and the script name for every script in a mode (e.g. bash, pash, dish, fish)
# all_res_file stores the time taken for each script for every script run, making it easy to copy and paste into the spreadsheet
unix50_bash() {
    mkdir -p "outputs/bash"
    mode_res_file="./outputs/bash/unix50.res"

    echo executing unix50 bash "$(date)" | tee -a $mode_res_file $all_res_file

    for script_input in "${scripts_inputs[@]}"; do
        IFS=";" read -r -a parsed <<<"${script_input}"
        script_file="./scripts/${parsed[0]}.sh"
        input_file="./inputs/${parsed[1]}.txt"
        output_file="./outputs/bash/${parsed[0]}.out"
        time_file="./outputs/bash/${parsed[0]}.time"
        log_file="./outputs/bash/${parsed[0]}.log"

        { time $script_file "$input_file" >"$output_file"; } 2>"$time_file"

        cat "${time_file}" >>$all_res_file
        echo "$script_file $(cat "$time_file")" | tee -a $mode_res_file
    done
}

ID=1 # track agg run

# run the unix50 suite using aggregators
unix50_agg() {
    AGG_FILE="../agg_run.sh"
    chmod +x $AGG_FILE
    mkdir -p "outputs/agg"
    mkdir -p "agg-steps"
    # mode_res_file="./outputs/agg/oneliners.res"
    # > $mode_res_file
    cmd_instance_counter="cmd_instance_counter.txt"

    echo executing oneliners agg $(date) | tee -a $mode_res_file $all_res_file
    for script_input in "${scripts_inputs[@]}"; do
        IFS=";" read -r -a parsed <<<"${script_input}" # for every item in scripts_input; 0 = script and 1 = input files
        script_file="./scripts/${parsed[0]}.sh"
        input_file="./inputs/${parsed[1]}.txt"
        output_file="./outputs/agg/${parsed[0]}.out"
        time_file="./outputs/agg/${parsed[0]}.time"
        log_file="./outputs/agg/${parsed[0]}.log"
        agg_exec_file="./agg-steps/agg-${parsed[0]}.sh"
        { time ../agg_run.sh "$script_file" "$input_file" $ID "$log_file" "$agg_exec_file" "$cmd_instance_counter" >"$output_file"; } 2>"$time_file" #run file with input and direct to output

        cat "${time_file}" >>$all_res_file
        echo "$script_file $(cat "$time_file")" | tee -a $mode_res_file
        ((ID++))
    done
}

unix50_bash
unix50_agg
