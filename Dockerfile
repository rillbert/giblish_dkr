# $ docker run -it --entrypoint="" pandoc/core:2.19.2 cat /etc/apk/repositories
# http://dl-cdn.alpinelinux.org/alpine/v3.16/main
# http://dl-cdn.alpinelinux.org/alpine/v3.16/community
#
ARG ASCIIDOCTOR_VERSION=1.37
FROM asciidoctor/docker-asciidoctor:${ASCIIDOCTOR_VERSION} as asciidoctor


RUN gem install --no-document giblish
COPY run.sh /
WORKDIR /
# VOLUME /src
# VOLUME /dst
# VOLUME /layout
# CMD ["/bin/bash"]
CMD ["./run.sh"]

# WORKDIR /root
# CMD ["/bin/sh"]

# RUN apk add --no-cache \
#     gcc \
#     g++ \
#     musl-dev \
#     wget \
#     make \
#     git \
#     freetype-dev \
#     texlive-dev

# # Build gnuplot
# ENV GNUPLOT_VERSION 5.2.7
# RUN wget -q https://sourceforge.net/projects/gnuplot/files/gnuplot/${GNUPLOT_VERSION}/gnuplot-${GNUPLOT_VERSION}.tar.gz/download -O gnuplot-${GNUPLOT_VERSION}.tar.gz && \
#     tar zxvf gnuplot-${GNUPLOT_VERSION}.tar.gz && \
#     mv gnuplot-${GNUPLOT_VERSION} gnuplot && \
#     cd gnuplot && \
#     ./configure --enable-history-file=no --with-readline=no && \
#     make -j8 && \
#     cd ..

# # Fetch plantuml. We do this in this container since we have wget here.
# RUN wget -q https://github.com/plantuml/plantuml/releases/download/v1.2022.12/plantuml-1.2022.12.jar -O plantuml.jar
# RUN wget -q -O- http://beta.plantuml.net/plantuml-jlatexmath.zip | unzip -

# # Build texcaller to get some control over latex invocations
# RUN git clone https://github.com/vog/texcaller.git && \
#     make -j8 -C texcaller/shell

# # Build dvisvgm
# ENV DVISVGM_VERSION 2.11.1
# RUN wget -q https://github.com/mgieseki/dvisvgm/releases/download/${DVISVGM_VERSION}/dvisvgm-${DVISVGM_VERSION}.tar.gz && \
#     tar -xvf dvisvgm-${DVISVGM_VERSION}.tar.gz && \
#     mv dvisvgm-${DVISVGM_VERSION} dvisvgm && \
#     cd dvisvgm && \
#     ./configure --enable-bundled-libs && \
#     make -j8

# # Pandoc, through Haskell stdlib, is using getAppUserDataDirectory which in
# # turn calls geteuid to get the user id. Since we run the container with the
# # calling user's UID:GID, it's not certain that she exist in the container. So,
# # using LD_PRELOAD, we fake the UID to 1000 and make sure that this user exist
# # in the container.
# RUN echo "int geteuid(){return 1000;}" | gcc -shared -fPIC -xc -o geteuid.so -

# RUN mkdir plantuml-stdlib
# ENV C4_PLANTUML_VERSION v2.4.0
# ENV C4_PLANTUML_URL https://raw.githubusercontent.com/plantuml-stdlib/C4-PlantUML/${C4_PLANTUML_VERSION}
# RUN wget -q ${C4_PLANTUML_URL}/C4.puml -O plantuml-stdlib/C4.puml
# RUN wget -q ${C4_PLANTUML_URL}/C4_Component.puml -O plantuml-stdlib/C4_Component.puml
# RUN wget -q ${C4_PLANTUML_URL}/C4_Container.puml -O plantuml-stdlib/C4_Container.puml
# RUN wget -q ${C4_PLANTUML_URL}/C4_Context.puml -O plantuml-stdlib/C4_Context.puml
# RUN wget -q ${C4_PLANTUML_URL}/C4_Deployment.puml -O plantuml-stdlib/C4_Deployment.puml
# RUN wget -q ${C4_PLANTUML_URL}/C4_Dynamic.puml -O plantuml-stdlib/C4_Dynamic.puml

# FROM python:3.11-alpine3.16

# # Install packages for pandoc
# RUN apk add --no-cache \
#     gmp \
#     libffi \
#     lua5.3 \
#     lua5.3-lpeg

# # Install packages for plantuml/graphviz
# RUN apk add --no-cache \
#     openjdk16-jre \
#     graphviz  \
#     ttf-droid \
#     ttf-droid-nonlatin

# # Git for access to git history in document builds
# RUN apk add --no-cache \
#     git

# # For latex and dvisvgm
# RUN apk add --no-cache \
#     texlive \
#     texmf-dist-latexextra \
#     imagemagick \
#     potrace

# # Prevent "Fontconfig error: No writable cache directories" from latex
# RUN fc-cache -v -s

# COPY --from=pandoc-build /usr/local/bin/pandoc* /usr/bin/
# COPY --from=pandoc-build /root/gnuplot/src/gnuplot /usr/bin/
# COPY --from=pandoc-build /root/texcaller/shell/texcaller /usr/bin/
# COPY --from=pandoc-build /root/dvisvgm/src/dvisvgm /usr/bin/
# COPY --from=pandoc-build /root/*.jar /usr/local/share/java/
# COPY --from=pandoc-build /root/geteuid.so /usr/lib/
# COPY --from=pandoc-build /root/plantuml-stdlib /usr/plantuml-stdlib/
# WORKDIR /tmp
# RUN pip install --no-cache \
#     scons==4.4.0 \
#     pandocfilters==1.5.0
# COPY scons_tools /usr/share/scons
# RUN find /usr/share/scons -type d -exec chmod 0755 {} \;

# # Pandoc requires a user to exist for the UID running the container, so add
# # UID 1000. See LD_PRELOAD below.
# RUN adduser --disabled-password --no-create-home --uid 1000 "u1000"

# # Hack to make shebangs work on Windows machines with CR-LF line-endings
# RUN ln -s /usr/local/bin/python $'/usr/local/bin/python\r'
# RUN ln -s /usr/local/bin/python3 $'/usr/local/bin/python3\r'

# # Root will own volume mounts even though the container is run as another user,
# # so create these folders and give 'others' write access. The mounts are made
# # when the container is run to enable mounting of named volumes.
# ARG WORKSPACE="/workspace"
# ARG PDIMAGECACHE="/tmp/pandoc-imagecache"
# ARG SCONSCACHE="/tmp/.sconscache"
# ARG GIT_DIR="/gitdir"
# RUN mkdir $WORKSPACE && chmod a+rwx $WORKSPACE
# RUN mkdir $PDIMAGECACHE && chmod a+rwx $PDIMAGECACHE
# RUN mkdir $SCONSCACHE && chmod a+rwx $SCONSCACHE
# RUN mkdir $GIT_DIR && chmod a+rwx $GIT_DIR
# ENV PDIMAGEDIR=$PDIMAGECACHE
# ENV SCONSCACHE=$SCONSCACHE
# ENV GIT_DIR=$GIT_DIR
# ENV GIT_WORK_TREE=$WORKSPACE
# ENV LD_PRELOAD=/usr/lib/geteuid.so
# WORKDIR $WORKSPACE
# CMD ["/bin/sh"]
