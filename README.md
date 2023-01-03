# bahmni-metabase

## Table of Contents
* [Metabase Overview](#metabase-overview)
* [Admin user creation for Metabase](#admin-user-creation-for-metabase)
* [Configure Predefined Reports in Metabase](#configure-predefined-reports-in-metabase)
* [Starting Metabase from Bahmni Docker](#starting-metabase-from-bahmni-docker)


# Metabase Overview

Metabase is an open-source business intelligence tool. Metabase lets you ask questions about your data, and displays answers in formats that make sense, whether that’s a bar chart or a detailed table.

You can save your questions, and group questions into handsome dashboards. Metabase also makes it easy to share questions and dashboards with the rest of your team.

As a part of our initiative we have used [v0.44.6](https://hub.docker.com/layers/metabase/metabase/v0.44.6/images/sha256-527a30f88f79a90bba0951d352a9fcbdecbf5f1b011a41b30e7a074265549168?context=explore) version of Metabase image.

# Admin user creation for Metabase
The first user of metabase will be created as an Admin user and is pre-configured for [metabase profile](https://github.com/Bahmni/bahmni-docker/blob/master/bahmni-standard/docker-compose.yml) in the docker-compose.yml of bahmni-docker by adding the following [configurational data](https://bahmni.atlassian.net/wiki/spaces/BAH/pages/3117482143/Metabase+Configuration+docker) for admin.


# Configure Predefined Reports in Metabase

We will configure two predefined reports(Clinic Reports , Registered Patients ) as a part of the Bahmni Analytics collection for the user to give them an initial look and feel of the Metabase features when they start the Metabase application by configuring it with the OpenMRS database.

To create a new report follow two steps:

1. Create a new SQL file with query in [sql ](https://github.com/Bahmni/bahmni-metabase/tree/main/package/docker/scripts/reports/sql)folder.

2. Create a new request object in [report_inputs.json.](https://github.com/Bahmni/bahmni-metabase/blob/main/package/docker/scripts/reports/request/report_inputs.json)


    "name" -- the name of the report to be displayed
    "sql" -- the sql file to refer for the report generation
    "pivot_column" -- as per the [visualization settings](https://www.metabase.com/docs/latest/api/card#params-6) for the table
    "cell_column" -- as per the [visualization settings](https://www.metabase.com/docs/latest/api/card#params-6) for the table 
    "db_ref_name"-- this should be same as the DB_REF_NAME configured in the add_databases.sh file for the corresponding database 



# Starting Metabase from Bahmni Docker

Metabase will start with below details:

1. A pre-configured Admin user as given in the [environment variables](https://github.com/Bahmni/bahmni-docker/blob/master/bahmni-standard/docker-compose.yml#L213-L215) in Bahmni Docker.

2. OpenMRS DB.

3. Sample Reports.

To start Metabase in local follow the [mentioned commands](https://bahmni.atlassian.net/wiki/spaces/BAH/pages/3117482143/Metabase+Configuration+docker).