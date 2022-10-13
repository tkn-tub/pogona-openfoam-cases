# Pogona OpenFOAM Cases

OpenFOAM simulation cases for the [Pogona](https://www2.tkn.tu-berlin.de/software/pogona/) simulator for macroscopic molecular communication.

## Install OpenFOAM and Other Dependencies

You can find instructions on how to use an [Apptainer](https://apptainer.org/) container image in our [pogona-container](https://github.com/lumpiluk/pogona-container) repository.

## Generate OpenFOAM Cases from Templates

Some of the cases have to be generated from templates first before they can be used with OpenFOAM.
Follow the following instructions to do so:

```bash
# First repo checkout:
pipenv install
# Enter Python virtualenv:
pipenv shell
# Generate cases:
snakemake
```

Afterwards, you can run each desired simulation by `cd`-ing into the respective subfolder and running `./Allrun`.
