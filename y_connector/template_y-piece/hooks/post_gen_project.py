#!/usr/bin/env python3 

import glob
import shutil


radius_mm = float({{cookiecutter.radius_mm}})
outlet_len_cm = float({{cookiecutter.outlet_len_cm}})
bg_len_cm = float({{cookiecutter.bg_len_cm}})
inlet_len_cm = float({{cookiecutter.inlet_len_cm}})
variant = "{{cookiecutter.variant if 'variant' in cookiecutter}}"
dirname = "{{cookiecutter.dirname}}"
# TODO: remove '../'
stl_dirname = (
    f"../stl_meshes/y-piece_r{round(radius_mm, 2):g}mm"
    f"_o{round(outlet_len_cm, 1):g}cm"
    f"_bg{round(bg_len_cm, 1):g}cm"
    f"_p{round(inlet_len_cm, 1):g}cm"
    f"{f'_{variant}' if variant != '' else ''}"
)
stl_files = glob.glob(f"{stl_dirname}/*", recursive=False)
for stl_file in stl_files:
    shutil.copy(stl_file, f"{dirname}/constant/triSurface")
