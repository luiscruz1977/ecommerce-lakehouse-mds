from airflow import DAG
from airflow.operators.bash import BashOperator
from datetime import datetime

with DAG(
    dag_id="ecommerce_lakehouse_pipeline",
    description="Pipeline MDS: dbt run + test sobre o lakehouse Databricks",
    start_date=datetime(2026, 1, 1),
    schedule_interval="@daily",
    catchup=False,
    tags=["portfolio", "dbt", "databricks"],
) as dag:

    dbt_run = BashOperator(
        task_id="dbt_run",
        bash_command=(
            "dbt run --project-dir /opt/airflow/ecommerce_gold "
            "--profiles-dir /opt/airflow/ecommerce_gold"
        ),
    )

    dbt_test = BashOperator(
        task_id="dbt_test",
        bash_command=(
            "dbt test --project-dir /opt/airflow/ecommerce_gold "
            "--profiles-dir /opt/airflow/ecommerce_gold"
        ),
    )

    dbt_run >> dbt_test
