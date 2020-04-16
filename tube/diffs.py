#!/usr/bin/env python3

"""
Check to what extent the contents of subfolders of
"./cookiecutter-test/" match equally named folders
in the current directory.
Useful for validating templates.
"""

import os
import glob
import subprocess


out_dirs = glob.glob("cookiecutter-test/*")
for out_dir in out_dirs:
    out_dir_base = os.path.basename(out_dir)
    print('O.o ' * 20)
    print('O.o ' * 20)

    try:
        output = subprocess.check_output([
            'diff',
            '-r',
            out_dir_base,
            out_dir,
        ], stderr=subprocess.STDOUT)
    except subprocess.CalledProcessError as e:
        print(f"Return code: {e.returncode}")
        print(e.output.decode())

