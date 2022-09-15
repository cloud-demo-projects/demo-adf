## Required Resources
- Azure SQL Server :demo-adf-dbserver
- Azure SQL DB: demo-adf-db
  CREATE TABLE dbo.emp
  (
      ID int IDENTITY(1,1) NOT NULL,
      FirstName varchar(50),
      LastName varchar(50)
  )
  GO
  CREATE CLUSTERED INDEX IX_emp_ID ON dbo.emp (ID);

- Key Vault: demo-keyvault-adf
- Storage account : containerappstoragedemo (adf/output)
- ADLS Gen2 Storage Account : adlssac
