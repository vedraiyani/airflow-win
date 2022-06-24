$Network = "{0}_airflow" -f @(Split-Path $PSScriptRoot -Leaf)

docker run -it --rm --network $Network postgres psql -h metadb -U airflow --db airflow @Args