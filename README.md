# Docker - Datascience Workspace

A containerized setup for working with `MSSQL` and `Anaconda` (v. 2020.11).

The anaconda workspace is named `ds-workspace`. This workspace provides a reproducible datascience workspace along with all necessary drivers needed to connect to a `MSSQL` database.

You can choose one of two methods to work with this repo.

* Complete containerization
  * `Anaconda` container
  * `MSSQL` container
* Partial containerization
  * Local installation of [Anaconda](https://docs.anaconda.com/anaconda/install/index.html)
  * `MSSQL` container

The only benefit of partial containerization is the ability to have access to `Jupyter` variables if using tools such as [Pycharm](https://www.jetbrains.com/pycharm/).

## Installation & Setup

Requirements:

* [Docker](https://docs.docker.com/get-docker/) as per your OS.

* Optional
  * [Pycharm](https://www.jetbrains.com/pycharm/)
  * [Anaconda](https://docs.anaconda.com/anaconda/install/index.html)
  * [Microsoft ODBC Driver for SQL Server (macOS)](https://docs.microsoft.com/en-us/sql/connect/odbc/linux-mac/install-microsoft-odbc-driver-sql-server-macos?view=sql-server-ver15)

### Local-based Configuration

Setup `anaconda` environment from `environment.yml` file

```sh
conda env create -f macos.environment.yml
```

Ensure non-automatic conda `base` environment activation

```sh
# must be run after `conda init $SHELL`
conda config --set auto_activate_base False
```

Activate conda environment

```sh
conda env list
conda activate local-ds-workspace
conda deactivate
```

#### Database Connection from macOS

Install DB drivers

```sh
brew tap microsoft/mssql-release https://github.com/Microsoft/homebrew-mssql-release
brew update
HOMEBREW_NO_ENV_FILTERING=1 ACCEPT_EULA=Y brew install msodbcsql17 mssql-tools
```

Test connection

```sh
sqlcmd -S 127.0.0.1 -U sa -P your_password -Q "SELECT @@VERSION"
sqlcmd -S 127.0.0.1 -U sa -P Pass@word -Q "SELECT name FROM master.dbo.sysdatabases"
```

### Docker-based Configuration

Start `db` and `anaconda` containers

```sh
docker compose up --build -d
# OR
make up
```

Start only `db` container

```sh
docker-compose up -d db
# OR
make up-db
```

Enter anaconda container

```sh
docker exec -ti anaconda /bin/bash
# OR
make exec-anaconda
```

Stop the dev-env

```sh
docker compose down
# OR
make down
```

Enter anaconda container and test DB connection

```sh
docker exec -ti anaconda /bin/bash
sqlcmd -S sql-server -U SA -P Pass@word -Q "SELECT name FROM master.dbo.sysdatabases"
```

Summary of make commands

```sh
❯ make
help                           This help.
up                             Start the containers
down                           Stop the containers
up-db                          Start
exec-anaconda                  Enter anaconda container - bash
```