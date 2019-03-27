# VERSION 1.10.2
# AUTHOR: Naveenkumar R
# DESCRIPTION: Docker image to run Airflow on Kubernetes which is capable of creating Kubernetes jobs
# SOURCE: https://github.com/witwickey/kube-airflow

FROM    witwickey/kube-airflow:v2

COPY    script/entrypoint.sh ${AIRFLOW_HOME}/entrypoint.sh
COPY    config/airflow.cfg ${AIRFLOW_HOME}/airflow.cfg
COPY    script/git-sync ${AIRFLOW_HOME}/git-sync
COPY    ${EMBEDDED_DAGS_LOCATION} ${AIRFLOW_HOME}/dags
COPY    script/git-sync ${AIRFLOW_HOME}/git-sync
COPY    ${EMBEDDED_DAGS_LOCATION} ${AIRFLOW_HOME}/dags
COPY    requirements/requirements.txt /requirements/requirements.txt

RUN     pip install -r /requirements/requirements.txt \
		&&  apt-get install -y iputils-ping \
        &&  apt-get remove --purge -yqq $buildDeps libpq-dev \
        &&  apt-get clean \
        &&  rm -rf \
                /var/lib/apt/lists/* \
                /tmp/* \
                /var/tmp/* \
                /usr/share/man \
                /usr/share/doc \
                /usr/share/doc-base \
		&&  chown -R airflow: ${AIRFLOW_HOME} \
        &&  chmod +x ${AIRFLOW_HOME}/entrypoint.sh \
        &&  chmod +x ${AIRFLOW_HOME}/git-sync \
		&&  chmod +x /usr/local/bin/kubectl

EXPOSE  8080 5555 8793

USER        airflow
WORKDIR     ${AIRFLOW_HOME}
ENTRYPOINT  ["./entrypoint.sh"]
