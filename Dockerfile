# Compile an image with all asciidoctor tools together with giblish and
# kramdoc

ARG ASCIIDOCTOR_VERSION=1.73
FROM asciidoctor/docker-asciidoctor:${ASCIIDOCTOR_VERSION} as asciidoctor-build

ENV C4_PLANTUML_VERSION v2.8.0
ENV C4_PLANTUML_URL https://raw.githubusercontent.com/plantuml-stdlib/C4-PlantUML/${C4_PLANTUML_VERSION}

WORKDIR /root

# make the C4 extensions available to plantuml
RUN mkdir plantuml-stdlib
RUN wget -q ${C4_PLANTUML_URL}/C4.puml -O plantuml-stdlib/C4.puml
RUN wget -q ${C4_PLANTUML_URL}/C4_Component.puml -O plantuml-stdlib/C4_Component.puml
RUN wget -q ${C4_PLANTUML_URL}/C4_Container.puml -O plantuml-stdlib/C4_Container.puml
RUN wget -q ${C4_PLANTUML_URL}/C4_Context.puml -O plantuml-stdlib/C4_Context.puml
RUN wget -q ${C4_PLANTUML_URL}/C4_Deployment.puml -O plantuml-stdlib/C4_Deployment.puml
RUN wget -q ${C4_PLANTUML_URL}/C4_Dynamic.puml -O plantuml-stdlib/C4_Dynamic.puml

# create an image stage to be able to copy the C4 stuff into the relevant dir
FROM asciidoctor-build as stage1
COPY --from=asciidoctor-build /root/plantuml-stdlib /usr/plantuml-stdlib

# install giblish and kramdoc
RUN gem install --no-document kramdown-asciidoc && \
    gem install --no-document giblish


# create a font-cache to prevent "Fontconfig error: No writable cache directories"
RUN fc-cache -s

# Root will own volume mounts even though the container is run as another user,
# so create these folders and give 'others' write access. The mounts are made
# when the container is run to enable mounting of named volumes.
ARG IMAGECACHE="/tmp/asciidoctor"
RUN mkdir $IMAGECACHE && chmod a+rwx $IMAGECACHE
ARG WORKSPACE="/workspace"
RUN mkdir $WORKSPACE && chmod a+rwx $WORKSPACE

# provide the standard dir for asciidoctor diagram to cache images
RUN ln -s $IMAGECACHE "${WORKSPACE}/.asciidoctor"

WORKDIR ${WORKSPACE}
COPY run.sh ${WORKSPACE}/.

# CMD ["/bin/bash"]
CMD ["./run.sh"]
