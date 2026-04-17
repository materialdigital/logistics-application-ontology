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

# foaf import: BOT extraction removing external equivalencies that cause OWL DL violations
# schema:Person == foaf:Person and contact:Person == foaf:Person cause inferred equivalence errors
$(IMPORTDIR)/foaf_import.owl: $(MIRRORDIR)/foaf.owl $(IMPORTDIR)/foaf_terms.txt \
			      $(IMPORTSEED) | all_robot_plugins
	$(ROBOT) annotate --input $< --remove-annotations \
		 odk:normalize --add-source true \
		 extract --term-file $(IMPORTDIR)/foaf_terms.txt $(T_IMPORTSEED) \
		         --force true --copy-ontology-annotations true \
		         --individuals include \
		         --method BOT \
		 remove $(foreach p, $(ANNOTATION_PROPERTIES), --term $(p)) \
		        --term-file $(IMPORTDIR)/foaf_terms.txt $(T_IMPORTSEED) \
		        --select complement --select annotation-properties \
		 remove --term http://schema.org/Person \
		        --term http://www.w3.org/2000/10/swap/pim/contact#Person \
		        --term http://www.w3.org/2003/01/geo/wgs84_pos#SpatialThing \
		        --axioms all \
		 odk:normalize --base-iri https://w3id.org/pmd \
		               --subset-decls true --synonym-decls true \
		 repair --merge-axiom-annotations true \
		 $(ANNOTATE_CONVERT_FILE)

update-ontology-annotations:
	$(ROBOT) annotate --input ../../log.owl $(ALL_ANNOTATIONS) --output ../../log.owl && \
	$(ROBOT) annotate --input ../../log.ttl $(ALL_ANNOTATIONS) --output ../../log.ttl && \
	$(ROBOT) annotate --input ../../log-simple.owl $(ALL_ANNOTATIONS) --output ../../log-simple.owl && \
	$(ROBOT) annotate --input ../../log-simple.ttl $(ALL_ANNOTATIONS) --output ../../log-simple.ttl && \
	$(ROBOT) annotate --input ../../log-full.owl $(ALL_ANNOTATIONS) --output ../../log-full.owl && \
	$(ROBOT) annotate --input ../../log-full.ttl $(ALL_ANNOTATIONS) --output ../../log-full.ttl && \
	$(ROBOT) annotate --input ../../log-base.owl $(ALL_ANNOTATIONS) --output ../../log-base.owl && \
	$(ROBOT) annotate --input ../../log-base.ttl $(ALL_ANNOTATIONS) --output ../../log-base.ttl 


