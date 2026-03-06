# application-ontology-template

template repository for starting a PMDCo application ontology. iT comes preconfigured with github workflows using [ontology development kit](https://github.com/INCATools/ontology-development-kit).

## How to use

1. Click use as Template Repository
2. Documentation of the application ontology is created via widoco and GitHub Pages when the docs workflow runs.

   To enable the documentation, you have to activate GitHub Pages in the repository settings. Set it to GitHub Actions instead of branch; the doc action will upload      the artifacts needed after each push to the repository.
3. You need to give GitHub Actions the permissions to read write and create pull requests (checkbox) in the repository settings at actions -> general
4. Run the seed workflow under GitHub Actions, and set the id and uribase_suffix. It will override the default values in [seed-template.yaml](./seed-template.yaml)
   
    Id and uribase_suffix are usually set to the same lowercase acronym that will be used with this ontology; examples are pmdco, tto, hto ...
    Github org and repo name will be set automatically by the seed workflow. To run the workflow, switch to GitHub Actions, select the seed workflow, and dispatch the  job manually.
5. Check the pull request created! If everything is fine, merge into main.
6. Put your ontology work into the \*-edit.owl file in the src folder; after pushing changes to the repository, the build will run and integrate your changes into the release types defined.
