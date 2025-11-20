## Customize Makefile settings for log
## 
## If you need to customize your Makefile, make
## changes here rather than in the main Makefile



CITATION="'Platform Material Digital Application Ontology for Logistics and Supplychain (log) $(VERSION), https://w3id.org/pmd/log/'"


ALL_ANNOTATIONS=--ontology-iri https://w3id.org/pmd/log/ -V https://w3id.org/pmd/log/$(VERSION) \
	--annotation http://purl.org/dc/terms/created "$(TODAY)" \
	--annotation owl:versionInfo "$(VERSION)" \
	--annotation http://purl.org/dc/terms/bibliographicCitation "$(CITATION)"  \
#	--link-annotation owl:priorVersion https://w3id.org/pmd/log/$(PRIOR_VERSION) \

update-ontology-annotations: 
	$(ROBOT) annotate --input ../../log.owl $(ALL_ANNOTATIONS) --output ../../log.owl && \
	$(ROBOT) annotate --input ../../log.ttl $(ALL_ANNOTATIONS) --output ../../log.ttl && \
	$(ROBOT) annotate --input ../../log-simple.owl $(ALL_ANNOTATIONS) --output ../../log-simple.owl && \
	$(ROBOT) annotate --input ../../log-simple.ttl $(ALL_ANNOTATIONS) --output ../../log-simple.ttl && \
	$(ROBOT) annotate --input ../../log-full.owl $(ALL_ANNOTATIONS) --output ../../log-full.owl && \
	$(ROBOT) annotate --input ../../log-full.ttl $(ALL_ANNOTATIONS) --output ../../log-full.ttl && \
	$(ROBOT) annotate --input ../../log-base.owl $(ALL_ANNOTATIONS) --output ../../log-base.owl && \
	$(ROBOT) annotate --input ../../log-base.ttl $(ALL_ANNOTATIONS) --output ../../log-base.ttl 


