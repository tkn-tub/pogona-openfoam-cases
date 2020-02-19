from cookiecutter.main import cookiecutter


configfile: "snakemake_config.yaml"

ypiece_case_names = list(config['cases']['y-piece'].keys())


def ypiece_conf(key: str, default=None):
    return lambda wildcards: config['cases']['y-piece'][
        wildcards.dirname].get(key, default)


rule all:
    input:
        expand("y_connector/cookiecutter-test/{dirname}", dirname=ypiece_case_names),


rule ypiece:
    input:
        cookiecutter_json="y_connector/template_y-piece/cookiecutter.json",
        template="y_connector/template_y-piece",
    output:
        out_dir=directory("y_connector/cookiecutter-test/{dirname}"),
    params:
        radius_mm=ypiece_conf('radius_mm'),
        bg_flow_mlpmin=ypiece_conf('bg_flow_mlpmin'),
        inlet_flow_mlpmin=ypiece_conf('inlet_flow_mlpmin'),
        outlet_len_cm=ypiece_conf('outlet_len_cm'),
        bg_len_cm=ypiece_conf('bg_len_cm'),
        inlet_len_cm=ypiece_conf('inlet_len_cm'),
        variant=ypiece_conf('variant', ''),
    run:
        # TODO: check which files' contents change!!!
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
            ),
            output_dir="y_connector/cookiecutter-test",
        )
