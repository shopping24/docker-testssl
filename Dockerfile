FROM centos:7.4.1708
LABEL description="A collection of tools to check your TLS server setup" \
      maintainer="Torsten Koester <torsten.koester@s24.com>"

RUN rpm --rebuilddb && \
    yum update -y && \
    yum -y groupinstall development && \
    yum install -y yum-utils git libtool perl-core zlib-devel which bind-utils && \
    yum -y install https://centos7.iuscommunity.org/ius-release.rpm && \
    yum -y install python36u python36u-pip python36u-devel && \
    yum clean all

ENV testssl_version 2.9.5
ENV openssl_version 1.1.0g
ENV PATH /opt/testssl.sh:/opt/testssl-scripts:$PATH

WORKDIR /opt

# Install a proper openssl
RUN curl -fsSLO https://www.openssl.org/source/openssl-${openssl_version}.tar.gz && \
    tar -xzf openssl-${openssl_version}.tar.gz && \
    cd openssl-${openssl_version} && \
    ./config shared zlib && \
    make && \
    make install && \
    ln -s /usr/local/lib64/libssl.so.1.1 /usr/lib64/ && \
    ln -s /usr/local/lib64/libcrypto.so.1.1 /usr/lib64/ && \
    ln -s /usr/local/bin/openssl /usr/bin/openssl && \
    openssl version

# testssl.sh to do basic testing
RUN git clone --depth 1 --branch ${testssl_version} https://github.com/drwetter/testssl.sh.git && \
    curl -sfL -o /etc/mapping-rfc.txt https://testssl.sh/mapping-rfc.txt

# Add elasticsearch connector for testssl.sh
RUN git clone --depth 1 https://github.com/TKCERT/testssl.sh-masscan.git && \
    pip3.6 install elasticsearch_dsl tzlocal

RUN mkdir -p /docker-entrypoint-initdb.d /opt/testssl-scripts

COPY scripts /opt/testssl-scripts

ENTRYPOINT ["docker-entrypoint.sh"]
CMD ["testssl.sh"]