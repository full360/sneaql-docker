#### SneaQL Docker

This repo contains the objects used to create the standard SneaQL docker image.

Please note that you do not need to build your own image unless you want to customize it. You can simply use the `full360/sneaql` image which is publicly available on Dockerhub.

For more information on SneaQL please visit [https://github.com/full360/sneaql](https://github.com/full360/sneaql).

##### Usage

The base container currently has the following limitations:

1. Currenly only Redshift is supported (other RDBMS in the works)
2. SneaQL transform repo must be provided by a user/pass authenticated HTTPS git repository (such as AWS CodeCommit)

##### Environment variables

The following is a sample of the minimum set of environment variables that must be provided to the image at the runtime.

The git based values communicate the location and credentials of the repository containing your SneaQL transform code.

The other values are used to establish a connection to your database.

```
SNEAQL_GIT_REPO=https://git-codecommit.us-west-1.amazonaws.com/v1/repos/your-repo
SNEAQL_GIT_USER=codecommit-user-at-123456789098
SNEAQL_GIT_PASSWORD=CNAod7d320faoweD8eaea/+313aDr=
SNEAQL_GIT_REPO_BRANCH=master

SNEAQL_JDBC_URL=jdbc:redshift://serverhostname:5439/sneaql
SNEAQL_DB_USER=dbusername
SNEAQL_DB_PASS=dbpassword
SNEAQL_DATABASE=redshift
```

##### Redshift JDBC Driver

The Redshift JDBC driver jar file is provided as a part of this container to make for easier integration. 

By using this code repository or the resulting docker image, you are agreeing to the AWS terms outlined here: 

[https://s3.amazonaws.com/redshift-downloads/drivers/Amazon+Redshift+JDBC+Driver+License+Agreement.pdf](https://s3.amazonaws.com/redshift-downloads/drivers/Amazon+Redshift+JDBC+Driver+License+Agreement.pdf)

##### MIT License

This software is released under the MIT license which has been included in the base of the repo.