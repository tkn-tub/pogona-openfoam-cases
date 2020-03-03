# Pogona OpenFOAM Cases

Do not commit simulation results here!

## Install OpenFOAM and Other Dependencies

  1. Install [Singularity](https://sylabs.io/docs/#singularity)
  2. Run `./singularity_build.sh`
  3. Open a shell inside the assembled image by running `./cases.simg`.

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

