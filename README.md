# Pogona OpenFOAM Cases

Do not commit simulation results here!

## Install OpenFOAM and Other Dependencies

You can find instructions on how to download and use a pre-built [Singularity](https://sylabs.io/docs/#singularity) image on [Github](https://github.com/lumpiluk/pogona-container).
Unlike the OpenFOAM base image (at the time of writing), this image has the advantage that it already includes a compatible Python version and Pipenv.

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
