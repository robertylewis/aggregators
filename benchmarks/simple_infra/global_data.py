from os import path, makedirs
import utils.find_agg_py as find_agg_py
import utils.find_agg_lean as find_agg_lean

# All None attributes should be set at runtime. 
# All other attributes should be pre-set before runtime. 

class GlobalData: 
    def __init__(self, input_: str, script_: str, split_: str, 
                    id_: int, agg_set_: str, inflate_: bool):
        if not path.exists(input_): 
            print(f'{input_} does not exist; check input to infra_run\n')
            exit(-1)
        if not path.exists(script_): 
            print(f'{script_} does not exist; check input to infra_run\n')
            exit(-1)
        
        self.input = input_ 
        self.input_name = path.splitext(path.basename(self.input))[0] 
        self.org_input_size=path.getsize(self.input)
        self.inf_input_size=path.getsize(self.input)
        self.script = script_
        self.script_name = path.splitext(path.basename(self.script))[0]
        self.split = split_
        self.id = id_
        self.agg_set=agg_set_ 
        self.inflate_input=inflate_
        self.size_to_inflate_to=path.getsize(self.input)

        self.simple_infra_path = "../simple_infra/"
        self.inter_dir_path = f'inputs-s-{str(self.id)}/' 
        self.output_dir_path = f"outputs-temp/agg-{str(self.id)}/"
        self.check_par_output_dir_path = f"outputs-temp/seq-check-{str(self.id)}/" 
        self.par_path =  self.simple_infra_path + "exec_scripts/test-par-driver.sh"
        self.seq_path = self.simple_infra_path + "exec_scripts/test-seq-driver.sh"
        self.py_agg_path = "../../py-2/"
        self.lean_agg_path = "../../lean4/.lake/build/bin/"
        self.debug_log_path = "infra_debug.log"
        self.debug_prefix = "" # f'{globals.script_name}: '  
        self.metrics_path = "infra_metrics.csv"
        self.d = "|"
        
        self.cmd = None
        self.metri_row = ""
        self.split_file_dir = None 
        
        self.setup_dir()
        self.create_agg_set()
        
    def change_input(self, new_input: str): 
        if not path.exists(new_input): 
            FileExistsError(f'{new_input} does not exist; check output of last produced run\n')
       
        self.input = new_input  
        self.input_name = path.splitext(path.basename(self.input))[0]
        self.org_input_size = path.getsize(self.input)
        if self.inflate_input: 
            self.inf_input_size = self.generate_inflated_input(self.input, self.size_to_inflate_to)
        else: 
            self.inf_input_size = self.org_input_size
        
    def generate_inflated_input(self, input:str, inflate_to_size: str) -> int: 
        current_size = path.getsize(input)
        bytes_still_needed = inflate_to_size - current_size
        if bytes_still_needed <= 0: 
            return current_size
        
        with open(input, 'r+') as file_to_inflate:
            original_content = file_to_inflate.read()

            while current_size < inflate_to_size:
                file_to_inflate.write(original_content)
                current_size = path.getsize(input)
        return current_size

    def set_script(self, new_script: str): 
        self.script = new_script 
        self.script_name = path.splitext(path.basename(self.script))[0]
        
    def set_cmd(self, new_cmd: str): 
        self.cmd = new_cmd
        self.split_file_dir = f'{self.inter_dir_path}{self.input_name}/'
    
    def metadata_to_header(self):
        # "script,input,input size,adj input size,cmd" 
        input_size = self.org_input_size
        adjusted_size = self.inf_input_size
        return f'{self.script_name}{self.d}{self.input}{self.d}{input_size}{self.d}{adjusted_size}{self.d}{self.cmd}'

    def setup_dir(self): 
        if not path.exists(self.output_dir_path): 
            makedirs(self.output_dir_path)
            
        if not path.exists(self.check_par_output_dir_path): 
            makedirs(self.check_par_output_dir_path)

        if not path.exists(self.inter_dir_path):
            makedirs(self.inter_dir_path)
            
    def create_agg_set(self): 
        if self.agg_set == "all": 
            agg_set = ["python", "lean"]
        elif self.agg_set == "lean": 
            agg_set = ["lean"]
        else: 
            agg_set = ["python"]
        
        self.agg_set = agg_set             
            
    def check_aggregator_exists(self) -> list[str]:
        agg_found = []
        for agg in self.agg_set: 
            if agg == "python": 
                py = find_agg_py.find(self.cmd, self.py_agg_path)
                agg_found.append(py)
            elif agg == "lean": 
                lean = find_agg_lean.find(self.cmd, self.lean_agg_path)
                agg_found.append(lean)
        if len(agg_found) == 0: agg_found.append(find_agg_py.find(self.g.cmd, self.g.py_agg_path))
        return agg_found
    

