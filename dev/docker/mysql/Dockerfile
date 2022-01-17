FROM ubuntu/mysql:8.0-20.04_beta

ENV LANG=C.UTF-8 LC_ALL=C.UTF-8 BASE_DIR=/home/deploy
## Copy db init.sql
COPY db_init.sql /docker-entrypoint-initdb.d/
## Copy db init script
COPY db_init.sh entrypoint.sh $BASE_DIR/

RUN mkdir -p /work/logs  && \
    echo "max_allowed_packet=200M" >> /etc/mysql/my.cnf

ENTRYPOINT $BASE_DIR/entrypoint.sh