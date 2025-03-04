import subprocess
import yaml 


# Invokes a given command and returns the stdout
def invoke(command):
    try:
        output = subprocess.check_output(command, shell=True,
                                         universal_newlines=True)
    except Exception:
        print("Failed to run %s" % (command))
    return output

def should_use_block(value):
    for c in u"\u000a\u000d\u001c\u001d\u001e\u0085\u2028\u2029":
        if c in value:
            return True
    return False

def my_represent_scalar(self, tag, value, style=None):
    if style is None:
        if should_use_block(value):
             style='|'
        else:
            style = self.default_style

    node = yaml.representer.ScalarNode(tag, value, style=style)
    if self.alias_key is not None:
        self.represented_objects[self.alias_key] = node
    return node

def update_aos_version(cur_num, wanted_num, fileName):
    # append to file
    with open(fileName, "r") as f:
        yaml_file = yaml.safe_load(f)
        print("yaml file " + str(yaml_file))
        current_loc = yaml_file['install']['flexy']['VARIABLES_LOCATION']
        new_loc = current_loc.replace(cur_num,wanted_num)
        yaml_file['install']['flexy']['VARIABLES_LOCATION'] = new_loc
        print("new yaml file " + str(yaml_file))
    with open(fileName, "w+") as f:
        str_file = yaml.dump(yaml_file)
        print('type ' + str(type(str_file)))
        f.write(str_file)

def update_jenkins_label_version(cur_num,wanted_num, fileName):
    # append to file
    with open(fileName, "r") as f:
        yaml_file = yaml.safe_load(f)
        current_label = yaml_file['install']['flexy']['JENKINS_AGENT_LABEL']
        new_label = current_label.replace(cur_num,wanted_num)
        yaml_file['install']['flexy']['JENKINS_AGENT_LABEL'] = new_label
    with open(fileName, "w+") as f:
        str_file = yaml.dump(yaml_file)
        f.write(str_file)

def update_var(cur_var,wanted_var, fileName):
    # append to file
    with open(fileName, "r") as f:
        yaml_file = yaml.safe_load(f)
        print("yaml file " + str(yaml_file))
        current_var = yaml_file['install']['flexy']['EXTRA_LAUNCHER_VARS']
        new_var = current_var.replace(cur_var,wanted_var)
        yaml_file['install']['flexy']['VARIABLES_LOCATION'] = new_var
        print("new yaml file " + str(yaml_file))
        for scale_prof, scale_vals in yaml_file['scale'].items():
            current_vars = yaml_file['scale'][scale_prof]['EXTRA_LAUNCHER_VARS']
            new_var = current_vars.replace(cur_var,wanted_var)
            yaml_file['scale'][scale_prof]['VARIABLES_LOCATION'] = new_var

    with open(fileName, "w+") as f:
        str_file = yaml.dump(yaml_file)
        print('type ' + str(type(str_file)))
        f.write(str_file)

current_num="18"
wanted_num="19"
folder_path="/Users/prubenda/Github/ci-profiles/scale-ci/4.19"


yaml.representer.BaseRepresenter.represent_scalar = my_represent_scalar
file_names = invoke("ls " + folder_path)

p = 0
for file_name in file_names.split():
    if file_name in ["P1","P2"]:

        sub_file_names = invoke("ls " + folder_path + "/" + file_name)
        for sub_file_name in sub_file_names.split():
            sub_full_file_name = folder_path + "/" + file_name + '/' + sub_file_name
            update_jenkins_label_version(current_num,wanted_num, sub_full_file_name)
            update_aos_version(current_num,wanted_num, sub_full_file_name)
        continue
    if not file_name or file_name is None: 
        continue
    full_file_name = folder_path + "/" + file_name
    update_jenkins_label_version(current_num,wanted_num, full_file_name)
    update_aos_version(current_num,wanted_num, full_file_name)
    p += 1
    # if p > 3: 
    #     break


