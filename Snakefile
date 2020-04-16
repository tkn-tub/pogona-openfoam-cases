from cookiecutter.main import cookiecutter


configfile: "snakemake_config.yaml"

ypiece_case_names = list(config['cases']['y-piece'].keys())
tube_case_names = list(config['cases']['tube'].keys())


def ypiece_conf(key: str, default=None):
    return lambda wildcards: config['cases']['y-piece'][
        wildcards.dirname].get(key, default)


def tube_conf(key: str, default=None):
    return lambda wildcards: config['cases']['tube'][
        wildcards.dirname].get(key, default)


rule all:
    input:
        expand("y_connector/{dirname}", dirname=ypiece_case_names),
        expand("tube/{dirname}", dirname=tube_case_names),


rule ypiece:
    input:
        cookiecutter_json="y_connector/template_y-piece/cookiecutter.json",
        template="y_connector/template_y-piece",
    output:
        out_dir=directory("y_connector/{dirname}"),
    params:
        radius_mm=ypiece_conf('radius_mm'),
        bg_flow_mlpmin=ypiece_conf('bg_flow_mlpmin'),
        inlet_flow_mlpmin=ypiece_conf('inlet_flow_mlpmin'),
        outlet_len_cm=ypiece_conf('outlet_len_cm'),
        bg_len_cm=ypiece_conf('bg_len_cm'),
        inlet_len_cm=ypiece_conf('inlet_len_cm'),
        variant=ypiece_conf('variant', ''),
        end_time_s=ypiece_conf('end_time_s'),
        delta_time_s=ypiece_conf('delta_time_s'),
        write_interval_steps=ypiece_conf('write_interval_steps'),
    run:
        cookiecutter(
            template=input.template,
            no_input=True,
            # Override cookiecutter.json:
            extra_context=dict(
                dirname=wildcards.dirname,
                radius_mm=params.radius_mm,
                bg_flow_mlpmin=params.bg_flow_mlpmin,
                inlet_flow_mlpmin=params.inlet_flow_mlpmin,
                outlet_len_cm=params.outlet_len_cm,
                bg_len_cm=params.bg_len_cm,
                inlet_len_cm=params.inlet_len_cm,
                variant=params.variant,
                end_time_s=params.end_time_s,
                delta_time_s=params.delta_time_s,
                write_interval_steps=params.write_interval_steps,
            ),
            output_dir="y_connector",
        )


rule tube:
    input:
        cookiecutter_json="tube/template_tube/cookiecutter.json",
        template="tube/template_tube",
    output:
        out_dir=directory("tube/{dirname}"),
    params:
        radius_mm=tube_conf('radius_mm'),
        flow_mlpmin=tube_conf('flow_mlpmin'),
        len_cm=tube_conf('len_cm'),
        variant=tube_conf('variant', ''),
        end_time_s=tube_conf('end_time_s'),
        delta_time_s=tube_conf('delta_time_s'),
        write_interval_steps=tube_conf('write_interval_steps'),
        cells=tube_conf('cells'),
    run:
        cookiecutter(
            template=input.template,
            no_input=True,
            # Override cookiecutter.json:
            extra_context=dict(
                dirname=wildcards.dirname,
                radius_mm=params.radius_mm,
                flow_mlpmin=params.flow_mlpmin,
                len_cm=params.len_cm,
                variant=params.variant,
                end_time_s=params.end_time_s,
                delta_time_s=params.delta_time_s,
                write_interval_steps=params.write_interval_steps,
                cells=params.cells,
            ),
            output_dir="tube",
        )
