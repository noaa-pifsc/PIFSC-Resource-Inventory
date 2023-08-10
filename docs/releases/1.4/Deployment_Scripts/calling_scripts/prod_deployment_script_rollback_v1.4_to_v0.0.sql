c:

cd [working copy root]\SQL

sqlplus /nolog

@"../docs/releases/1.4/Deployment_Scripts/automated_deployments/deploy_prod_rollback_to_0.0.sql"

sqlplus /nolog

@"../docs/releases/1.4/Deployment_Scripts/automated_deployments/deploy_GIM_prod_rollback_to_0.0.sql"

sqlplus /nolog

@"../docs/releases/1.4/Deployment_Scripts/automated_deployments/deploy_RIA_prod_rollback_to_0.0.sql"

EXIT
