# application-ontology-template

template repository for starting a PMDCo application ontology. iT comes preconfigured with github workflows using [ontology development kit](https://github.com/INCATools/ontology-development-kit).

## how to use

1. Fork this repository
2. Run the seed workflow under github actions, set the id and uribase_suffix. It will override the default values in seed-template.yaml

```yaml
id: <change here>
title: <ontology title>
github_org: materialdigital
git_main_branch: main
repo: <repo name>
uribase: https://w3id.org/pmd/ao
uribase_suffix: xxx
```

3. Check the pul request create! If everything is fine merge to main
4. Put ur ontology work into the \*-edit.owl file in src folder, after pushing changes to the repository the build_with imports workflow will run and integrate your changes into the release types defined
5. Documentation of the application ontology is created via widoco and github pages, when the docs workflow runs