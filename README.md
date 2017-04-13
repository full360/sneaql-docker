#### SneaQL Docker

This repo contains the objects used to create the standard SneaQL docker image.

Please note that you do not need to build your own image unless you want to customize it. You can simply use the `full360/sneaql:latest` image which is publicly available on Dockerhub.

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

##### Secure Secrets Management with Biscuit

When using the SneaQL container in AWS, you will want to use some mechanism to protect your secrets. We have integrated biscuit [https://github.com/dcoker/biscuit](https://github.com/dcoker/biscuit) as an option for secrets management.

SneaQL biscuit integration works as follows:

1. Install biscuit and initialize your KMS environment as per the instructions on the biscuit github site.
2. Create your secrets.yml file, storing the secrets with names that match the environment variables that SneaQL is looking for.  For example ```$ biscuit put -f secrets.yml SNEAQL_DB_PASSWORD PaZZwurd```
3. Place your secrets.yml file in a http data store accessible by your instances.  Note that you can use an S3 bucket configured as a public website for this, as the secrets.yml file is meaningless without access to the KMS keys.
4. When running your container... do not pass ENV vars for your secrets, instead pass the http path of your secrets file as ```SNEAQL_BISCUIT=http://http://secrets-files.example.com.s3-website-us-west-2.amazonaws.com/secrets.yml```

If the SNEAQL_BISCUIT variable is set, the secrets.yml file will be pulled into the container at startup, at which point *all* of the secrets in the file will be decrypted and sourced as environment variables.

You will need to enable your instances (or ECS task roles) the appropriate IAM permissions to use the decryption keys.

While we tried to make this as simple as possible, you should always do your own legwork when creating a secure infrastructure. We find biscuit to be a great option in AWS because of it's serverless design.

##### Redshift JDBC Driver

The Redshift JDBC driver jar file is provided as a part of this container to make for easier integration. 

By using this code repository or the resulting docker image, you are agreeing to the AWS terms outlined here: 

[https://s3.amazonaws.com/redshift-downloads/drivers/Amazon+Redshift+JDBC+Driver+License+Agreement.pdf](https://s3.amazonaws.com/redshift-downloads/drivers/Amazon+Redshift+JDBC+Driver+License+Agreement.pdf)

##### MIT License

This software is released under the MIT license which has been included in the base of the repo.