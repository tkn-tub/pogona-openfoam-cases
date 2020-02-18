from cookiecutter.main import cookiecutter


configfile: snakemake_config.yaml


rule ypiece:
    input:
        cookiecutter_json="y_connector/y-piece_template/cookiecutter.json",
        template="y_connector/y-piece_template",
    output:
        allrun="y_connector/{dirname}/Allrun",
    params:
        radius_mm=lambda wildcards: config[wildcards.dirname]['radius_mm'],
        bg_flow_mlpmin=lambda wildcards: config[wildcards.dirname]['bg_flow_mlpmin'],
        inlet_flow_mlpmin=lambda wildcards: config[wildcards.dirname]['inlet_flow_mlpmin'],
        outlet_len_cm=lambda wildcards: config[wildcards.dirname]['outlet_len_cm'],
        bg_len_cm=lambda wildcards: config[wildcards.dirname]['bg_len_cm'],
        inlet_len_cm=lambda wildcards: config[wildcards.dirname]['inlet_len_cm'],
        variant=lambda wildcards: config[wildcards.dirname].get('variant', ''),
    run:
        # TODO: copy the correct STL files; write a hooks/post_gen_project.sh
        cookiecutter.cookiecutter(
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
            output_dir="y_connector",
        )
