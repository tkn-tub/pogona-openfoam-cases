# Pogona OpenFOAM Cases

Do not commit simulation results here!

## Install OpenFOAM and Other Dependencies

  1. Install [Singularity](https://sylabs.io/docs/#singularity)
  2. ~~Run `./singularity_build.sh`~~
  3. ~~Open a shell inside the assembled image by running `./cases.simg`.~~

There is now no more need to build the image yourself.
You can find instructions on how to download and use a pre-built image on [Github](https://github.com/lumpiluk/pogona-container).

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

