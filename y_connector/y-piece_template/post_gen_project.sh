#!/usr/bin/env bash


cp \
    stl_meshes/y-piece_r{{cookiecutter.radius_mm}}_o{{cookiecutter.outlet_len_cm}}_bg{{cookiecutter.bg_len_cm}}_p{{cookiecutter.inlet_len_cm}}{{f"_{cookiecutter.variant}" if cookiecutter.variant != "" else ""}}/* \
    {{cookiecutter.dirname}}/constant/triSurface/
