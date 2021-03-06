ARG BASE
FROM ${BASE:-perl}
RUN cpanm App::cpanminus::reporter

ARG PREREQ
RUN if [ "x${PREREQ}" != "x" ]; then cpanm -v ${PREREQ}; fi

ENV PERL_CPAN_REPORTER_DIR /etc/cpanm-reporter
VOLUME /etc/cpanm-reporter

COPY ./entrypoint.pl /root/entrypoint.pl
WORKDIR /root
ENTRYPOINT [ "perl", "entrypoint.pl" ]
