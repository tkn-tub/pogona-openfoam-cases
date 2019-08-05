# Y-Connector

## Workflow with Blender and SnappyHexMesh

[0] SnappyHexMesh [YouTube tutorial](https://youtu.be/ObsFQUiVi1U)

WARNING: Keep in mind that Blender and OpenFOAM use different coordinate systems! This is especially important when defining the blockMeshDict or the snappyHexMeshDict.
Addendum: Didn't seem to matter with the settings chosen below. However, it might become important when also simulating gravity.

Many of the following steps are now automated in the `ConstructMesh` and `RunSimulation` scripts.

- Model your fluid volume in Blender
    - Note: You may or may not wish to split your volume into different parts (e.g., tube, inlet, outlet; inlet and outlet would probably just be a single polygon or circle). In the coming steps, simply save these to different .stl files, then follow the step below to rename the stored stl `solid`, then merge all files into one using `cat tube.stl inlet.stl outlet.stl > merged.stl`.
    - In the Scene properties, optionally set the Unit Scale to 0.001 so you can comfortably work with millimeter accuracy. (blockMesh might crash with a segfault if you're working with very small numbers instead of setting the scale appropriately!)
    - Export your model as Stl: File -> Export -> Stl
        - Filename: clear this field if you don't want a prefix to all batch-processed output files
        - Selection Only: check (is usually a good choice)
        - Scale: 1.0
        - Scene Unit: check!
        - Ascii: check
        - Apply Modifiers: check (e.g., if you used a boolean modifier to merge different objects and if you didn't apply the modifiers)
        - Batch mode: Object (will create one .stl for every object as `<object name>.stl`
        - Foward: Y Forward (seems to work at least)
        - Up: Z Up (seems to work at least)
- Open the .stl file with some text editor and edit the first and the last line to give the object ("patch") a recognizable name: `solid <your object name>\n…endsolid <your object name>`
- With the .stl file still open, check that the coordinates are roughly in the expected order of magnitude!
- (In the OpenFOAM tutorials directory, have a look at `mesh/snappyHexMesh/motorBike/system/snappyHexMeshDict` as a starting point; the files linked in the YouTube tutorial above may also be helpful for comparison)
- Create your `system/snappyHexMeshDict`. (In [0]: 24:30)
    - For the y-connector, it turned out that setting an appropriately fine cell density in blockMeshDict and disabling all refinement in snappyHexMeshDict was a good way to make the solution converge.
- If you already have a folder `your-openfoam-scenario/0`, rename it to `0.org`, for example.
    - This is now handled automatically in the `ConstructMesh` and `RunSimulation` scripts!
- `blockMesh`: For generating the block mesh surrounding your custom mesh.
    - Before you can run `blockMesh`, the file `system/controlDict` is required.
    - Create a valid `system/blockMeshDict`. This should describe a block that completely encloses your model defined in the .stl file and the aspect ratio of each cell should approximately be 1. (In [0]: 19:00 (old version of OpenFOAM -> `constant/polyMesh/blockMeshDict`); or in the [user guide](https://cfd.direct/openfoam/user-guide/v6-snappyhexmesh/#x26-1950005.4.2))
    - Run `blockMesh` to create the block as defined in `system/blockMeshDict` that will be surrounding the custom mesh.
    - Open paraFoam. You should now be able to see your generated block. Click File, Open…, and open your original .stl file to verify that the block does indeed enclose your mesh.
- `surfaceFeatureExtract`: According to [0], this is suppoes to be one of two methods for improving the handling of sharp edges of snappyHexMesh.
    - Create `system/surfaceFeatureExtractDict`.
    - Run `surfaceFeatureExtract` "so the mesher knows where to snap to" ([0]). -> Should result in a new folder `constant/extendedFeatureEdgeMesh` as well as one `constant/triSurface/<file>.eMesh` for every `constant/triSurface/<file>.stl` configured in the surfaceFeatureExtractDict.
- `decomposePar`: Divide the mesh into one part for each CPU core.
    - Create `system/decomposeParDict`.
    - Run `decomposePar` -> Should result in one folder `processor<i>` for each CPU i. (Remove these folders after the mesh is finished and before solving b/c we'll need to decompose again. (Now also handled in the scripts.))
- `snappyHexMesh`
    - Run `mpirun -np <P> snappyHexMesh -overwrite -parallel`, where P is the number of decomposed parts you generated with `decomposePar`. This may take <10:58 — > and several GB of RAM (y connector with short tubes: ~6 GB).
    - Ideally, all numbers in the final block of the console output (listing error cells) should be 0. (cp. `meshQualityControls` in `snappyHexMeshDict`, and also `meshQualityDict` if `#include`d in `snappyHexMeshDict`.
- Run `reconstructParMesh -constant` to put the decomposed mesh back together.
- You may now open paraFoam to check on your generated mesh!
- Run `rm -rf processor*` to remove the subdirectories generated in the `decomposePar` step.
- Delete the dummy folder `0`, then, if you had a `0` folder in the beginning that you renamed to `0.org`, run `mv 0.org 0`.
- If your `constant/polyMesh/boundary` file includes the patch names of your mesh-surrounding block sides (defined in `system/blockMeshDict`) in addition to the patches of your custom mesh, remove all references to the former. Don't forget to adjust the counter at the top of the list!
