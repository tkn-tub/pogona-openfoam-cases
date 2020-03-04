#!/usr/bin/env python3 

import glob
import shutil
import os


radius_mm = float({{cookiecutter.radius_mm}})
outlet_len_cm = float({{cookiecutter.outlet_len_cm}})
bg_len_cm = float({{cookiecutter.bg_len_cm}})
inlet_len_cm = float({{cookiecutter.inlet_len_cm}})
variant = "{{cookiecutter.variant}}"
dirname = "{{cookiecutter.dirname}}"
if (not dirname.endswith('cm') and not dirname.endswith('cm/')
        and variant == ''):
    raise ValueError(
        f"dirname = \"{dirname}\" seems to end with a variant "
        f"string, but variant = \"{variant}\" is not given."
    )
mesh_dirname = (
    f"../meshes/y-piece_r{round(radius_mm, 2):g}mm"
    f"_o{round(outlet_len_cm, 1):g}cm"
    f"_bg{round(bg_len_cm, 1):g}cm"
    f"_p{round(inlet_len_cm, 1):g}cm"
    f"{f'_{variant}' if variant != '' else ''}"
)
stl_files = glob.glob(f"{mesh_dirname}/stl/*", recursive=False)
system_files = glob.glob(f"{mesh_dirname}/system/*", recursive=False)
if len(stl_files) == 0:
    raise FileNotFoundError(
        "No STL files found. "
        f"Is \"{os.path.abspath(mesh_dirname)}/stl/\" the correct path?"
    )
if len(system_files) == 0:
    raise FileNotFoundError(
        "No system files found. There should be a blockMeshDict, "
        "snappyHexMeshDict, and meshQualityDict here. "
        f"Is \"{os.path.abspath(mesh_dirname)}/system/\" the correct path?"
    )

# Copy STL files:
dst = "constant/triSurface/"
os.makedirs(dst)
for stl_file in stl_files:
    try:
        shutil.copy(stl_file, dst)
    except IsADirectoryError as e:
        raise IsADirectoryError(
            f"Tried to copy \"{stl_file}\" to \"dst\". "
            "The source file shouldn't be a directory. "
            "If the complaint is that the destination "
            "is a directory, the problem is more likely "
            "to be that the folder doesn't exist. "
            f"Original message: {e}"
        )
        # https://bugs.python.org/issue35216
# Copy system files:
# TODO: not having many copies of system files was the reason to have
#  templating in the first place!
#  On the other hand, the number of meshes should be much less than
#  the number of simulation cases.
dst = "system/"
os.makedirs(dst)
for system_file in system_files:
    shutil.copy(system_file, dst)
