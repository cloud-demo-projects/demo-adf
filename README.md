# Sample Azure Data Factory Implementation
This is a sample project to demonstrate-
- Azure Data Factory IaC
- Azure Data Factory CICD
- Azure Data Factory Services such as linkedservice, dataset, dataflow, triggers and pipelines.
- Settingup a Self hosted Integration Runtime

# Tools & Technologies
- IaC: Bicep
- Scripting: Powershell & Python
- Pipelines: YML
- Unit Test: Python
- Linting: YAML & JSON

# Usecases
- Spin-up ADF with managed virtual network and managed provate endpoints for SQL, DBX, SAC secure connectivity
- Consider Azure IR for high compute requirements for scaling up
- Consider Self-hosted integration runtime for on-premises connectivty
- ADF data pipeline -> dataflow -> Read Storage data source parquet/csv file, transform , insert into Azure SQL
- ADF data pipeline -> dataflow -> Getmetada activity to get SAC conatiners -> DBX notebook invocation & execution in new DBX job cluster to process SAC containers metadata
- Explicitely invoke ADF data pipeline from the functionapp and pass parameters to data pipeline
- Time trigger ADF data pipeline execution

