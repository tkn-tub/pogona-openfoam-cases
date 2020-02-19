# Pogona OpenFOAM Cases

Do not commit simulation results here!

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

