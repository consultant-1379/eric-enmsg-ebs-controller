ARG ERIC_ENM_SLES_EAP7_IMAGE_NAME=eric-enm-sles-eap7
ARG ERIC_ENM_SLES_EAP7_IMAGE_REPO=armdocker.rnd.ericsson.se/proj-enm
ARG ERIC_ENM_SLES_EAP7_IMAGE_TAG=1.64.0-32

FROM ${ERIC_ENM_SLES_EAP7_IMAGE_REPO}/${ERIC_ENM_SLES_EAP7_IMAGE_NAME}:${ERIC_ENM_SLES_EAP7_IMAGE_TAG}

ARG BUILD_DATE=unspecified
ARG IMAGE_BUILD_VERSION=unspecified
ARG GIT_COMMIT=unspecified
ARG ISO_VERSION=unspecified
ARG RSTATE=unspecified
ARG SGUSER=150497

LABEL \
com.ericsson.product-number="CXC Placeholder" \
com.ericsson.product-revision=$RSTATE \
enm_iso_version=$ISO_VERSION \
org.label-schema.name="ENM EBS-Controller Service Group" \
org.label-schema.build-date=$BUILD_DATE \
org.label-schema.vcs-ref=$GIT_COMMIT \
org.label-schema.vendor="Ericsson" \
org.label-schema.version=$IMAGE_BUILD_VERSION \
org.label-schema.schema-version="1.0.0-rc1"

RUN /usr/sbin/useradd -m -d /home/postgres postgres > /dev/null 2>&1

RUN zypper download ERICenmsgebsmcontroller_CXP9032324 && \
    zypper install -y ERICebscontroller_CXP9032323 \
    ERICserviceframework4_CXP9037454 \
    ERICserviceframeworkmodule4_CXP9037453 \
    ERICmodelserviceapi_CXP9030594 \
    ERICmodelservice_CXP9030595 \
    ERICpostgresqljdbc_CXP9031176 \
    ERICpib2_CXP9037459 \
    postgresql15 \
    ERICpostgresutils_CXP9038493 \
    ERICwebpushmodule_CXP9042711 \
    ERICcountermanagementservice_CXP9037901 && \
    rpm -ivh /var/cache/zypp/packages/enm_iso_repo/ERICenmsgebsmcontroller_CXP9032324*.rpm --nodeps --noscripts && \
    # Technical debt ticket created - TORF-591812
    mkdir -p /usr/lib/postgresql10/ && \
    ln -s /usr/lib/postgresql15/bin /usr/lib/postgresql10/bin && \
    zypper clean -a && \
    rm -f /ericsson/3pp/jboss/bin/cli/common/configure_modcluster.cli &&\
    rm /ericsson/3pp/jboss/bin/post-start/update_management_credential_permissions.sh \
       /ericsson/3pp/jboss/bin/post-start/update_standalone_permissions.sh
RUN echo "$SGUSER:x:$SGUSER:$SGUSER:An Identity for ebscontroller:/nonexistent:/bin/false" >>/etc/passwd && \
    echo "$SGUSER:!::0:::::" >>/etc/shadow

ENV ENM_JBOSS_SDK_CLUSTER_ID="ebscontroller" \
    ENM_JBOSS_BIND_ADDRESS="0.0.0.0" \
    GLOBAL_CONFIG="/gp/global.properties" \
    CLOUD_DEPLOYMENT=TRUE

USER $SGUSER