# Airflow Windows Docker Setup

## Introduction
Original apache airflow docker compose version is heavy but this project only uses postgres db, airflow scheduler and webserver so it's lightweight and advisable only for the local development purpose.

>This setup is tested locally not in production and only in windows not in any other os.

## Minimal Setup
After importing the repository following steps can be followed to setup the airflow:

1. Start airflow docker compose
```powershell
> docker-compose up
```
>Note: Airflow services start crash-looping immediately, complaining that various tables don't exist. Run below steps to fix this issue in separate shell window without closing this.

2. Run below command
```
> .\Invoke-Airflow.ps1 db init
```
> Note: 
> 1. This will fix db issue can be seen in docker compose window
> 2. This file can be used to execute airflow command **.\Invoke-Airflow.ps1 <args>** which is replcement of **airflow <args>** for this tutorial
> 3. To access db container use **Invoke-Psql.ps1**

3. Create a user with **username: admin, password: admin**
```powershell
> .\Invoke-Airflow.ps1 users create --role Admin --username admin --email admin --firstname admin --lastname admin --password admin
```

4. Dags can be created in **airflow/dags** directory

## Full Setup(Not required)
>Note: Optional steps are not required if this repo is directly used

1. (Optional) create a **data** and **airflow** folders in the current directory
```powershell
> mkdir ./data
> mkdir ./airflow
```

2. (Optional) create a file ./airflow/airflow.cfg with below content pointing to db connection string
```
[core]
sql_alchemy_conn = postgresql+psycopg2://airflow:airflow@metadb:5432/airflow
```

3. Start airflow docker compose
```powershell
> docker-compose up
```
>Note: Airflow services start crash-looping immediately, complaining that various tables don't exist. Run below steps to fix this issue in separate shell window without closing this.

4. (Optional) create a file called **Invoke-Airflow.ps1** with the following contents:
```
$Network = "{0}_airflow" -f @(Split-Path $PSScriptRoot -Leaf)

docker run --rm --network $Network --volume "${PSScriptRoot}\airflow:/opt/airflow" apache/airflow @Args
```

5. Run below command
```
> .\Invoke-Airflow.ps1 db init
```
> Note: 
> 1. This will fix db issue can be seen in docker compose window
> 2. This file can be used to execute airflow command **.\Invoke-Airflow.ps1 <args>** which is replcement of **airflow <args>** for this tutorial

6. (Optional) To access db container create a file called **Invoke-Psql.ps1** with the following contents:
```
$Network = "{0}_airflow" -f @(Split-Path $PSScriptRoot -Leaf)

docker run -it --rm --network $Network postgres psql -h metadb -U airflow --db airflow @Args
```

7. Create a user with **username: admin, password: admin**
```powershell
> .\Invoke-Airflow.ps1 users create --role Admin --username admin --email admin --firstname admin --lastname admin --password admin
```

8. Dags can be created in **airflow/dags** directory

## Reference:
- https://dev.to/jfhbrook/how-to-run-airflow-on-windows-with-docker-2d01
- https://towardsdatascience.com/setting-up-apache-airflow-2-with-docker-e5b974b37728
