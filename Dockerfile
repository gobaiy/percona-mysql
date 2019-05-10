FROM percona:5.6.24
LABEL creater="dazuimao1990"
ENV MYSQL_VERSION=5.6.24
ENV TZ=Asia/Shanghai
ADD docker-entrypoint.sh /run/docker-entrypoint.sh
ADD ./run/docker-entrypoint.sh /usr/local/bin/docker-entrypoint.sh
ADD ./run/mysqld.cnf /etc/mysql/percona-server.conf.d/mysqld.cnf
RUN  rm -rf /etc/apt/sources.list /etc/apt/sources.list.d/*
COPY sources-aliyun-0.list /etc/apt/sources.list

RUN	fetchDeps=' \
		ca-certificates \
		wget \
	'; \
	apt-get update; \
	apt-get install -y --no-install-recommends $fetchDeps; \
	rm -rf /var/lib/apt/lists/*; \
    wget -O /usr/local/bin/env2file -q https://github.com/barnettZQG/env2file/releases/download/v0.1/env2file-linux; \
	wget -O /usr/local/bin/gosu -q https://github.com/tianon/gosu/releases/download/1.11/gosu-arm64; \
    chmod +x /run/docker-entrypoint.sh  && chmod +x /usr/local/bin/env2file && chmod +x /usr/local/bin/gosu

EXPOSE 3306
VOLUME ["/var/lib/mysql", "/var/log/mysql"]
# init sql scripts
COPY sql/*.sql /docker-entrypoint-initdb.d/
# change ENTRYPOINT exec some custom command
ENTRYPOINT [ "/run/docker-entrypoint.sh" ]
CMD [ "mysqld" ]
