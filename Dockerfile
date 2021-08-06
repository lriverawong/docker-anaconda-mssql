FROM continuumio/anaconda3:2020.11


LABEL MAINTAINER "Luis Rivera-Wong"

# Setup Microsoft ODBC driver for SQL Server
# https://docs.microsoft.com/en-us/sql/connect/odbc/linux-mac/installing-the-microsoft-odbc-driver-for-sql-server?view=sql-server-ver15#debian17
RUN set -x && \
    apt-get update --fix-missing && \
    apt-get install -y gnupg iputils-ping telnet && \
    curl https://packages.microsoft.com/keys/microsoft.asc | apt-key add - && \
    DEBIAN_VER_ID="$(awk -F'=' '/VERSION_ID/ {print $2}' /etc/os-release | sed -e 's/\"//g')" && \
    curl https://packages.microsoft.com/config/debian/$DEBIAN_VER_ID/prod.list > /etc/apt/sources.list.d/mssql-release.list && \
    apt-get update --fix-missing && \
    ACCEPT_EULA=Y apt-get install -y \
        msodbcsql17 \
        mssql-tools \
        unixodbc-dev \
        libgssapi-krb5-2 \
    && apt-get clean \
    && rm -rf /var/lib/apt/lists/* && \
    /opt/conda/bin/conda clean -afy && \
    echo 'export PATH="$PATH:/opt/mssql-tools/bin"' >> ~/.bashrc

# Create main workspace
RUN ["mkdir", "/app"]

WORKDIR /app

# Create the environment:
COPY environment.yml .
RUN conda env create -f environment.yml

# Make RUN commands use the new environment:
RUN echo "conda activate ths-km-report" >> ~/.bashrc
SHELL ["/bin/bash", "--login", "-c"]

# Jupyter ports
EXPOSE 8888

# Final execution of jupyter
CMD ["/opt/conda/bin/jupyter", "notebook", "--notebook-dir=/app", "--allow-root", "--ip=0.0.0.0", "--port=8888", "--no-browser", "--NotebookApp.token=''", "--NotebookApp.password=''"]