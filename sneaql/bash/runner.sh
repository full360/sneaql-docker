#!/bin/bash

# support for biscuit secrets management
# provide http path to secrets.yml file via SNEAQL_BISCUIT env var
# all secrets in the file will be decrypted into env vars

if [ -n "$SNEAQL_BISCUIT" ]
then
  echo "pulling secrets file $SNEAQL_BISCUIT"
  # pull it down using various methods
  if [[ $SNEAQL_BISCUIT =~ ^http.* ]]; then wget -O secrets.yml $SNEAQL_BISCUIT; fi
  if [[ $SNEAQL_BISCUIT =~ ^s3.* ]]; then aws s3 cp $SNEAQL_BISCUIT secrets.yml; fi

  # create a source compatible shell script
  biscuit export -f secrets.yml | while read line
  do
      colon_offset=`awk -v a="$line" -v b=':' 'BEGIN{print index(a,b)-1}'`
      value_offset=`expr $colon_offset + 2`
      env_var_name=${line:0:$colon_offset}
      env_var_value=${line:$value_offset:1000}
      echo "export $env_var_name=$env_var_value" >> secrets.sh
  done

  # source the vars then remove the file
  source secrets.sh
  rm -f secrets.sh
fi

# support for sourcing your sneaql repo from a remote zip file.
# provide http/https/s3 url formatted location as SNEAQL_REPOSITORY_ARCHIVE
# s3 will require AWS credentials via env vars provided to container or IAM role.
#if [ -n "$SNEAQL_REPOSITORY_ARCHIVE" ]
#then
#  echo "pulling sneaql repository $SNEAQL_REPOSITORY_ARCHIVE"
#  # pull from remote location using method specified by url
#  if [[ $SNEAQL_REPOSITORY_ARCHIVE =~ ^http.* ]]; then wget -O /tmp/repo.archive $SNEAQL_REPOSITORY_ARCHIVE; fi
#  if [[ $SNEAQL_REPOSITORY_ARCHIVE =~ ^s3.* ]]; then aws s3 cp $SNEAQL_REPOSITORY_ARCHIVE /tmp/repo.archive; fi
#  
#  mkdir /repo
#  
#  # decompress zip file
#  if [[ $SNEAQL_REPOSITORY_ARCHIVE =~ ^.*zip$ ]]
#  then 
#    mv /tmp/repo.archive /tmp/repo.zip
#    unzip /tmp/repo.zip -d /repo
#  fi
#  
#  # here is where support for other archive formats will go
#fi

# configure env vars for redshift JDBC driver
# note that in this version only redshift driver is supported
if [ -n "$SNEAQL_DATABASE" ]
then
  if [ $SNEAQL_DATABASE == 'redshift' ]
  then
    echo "by using this software you agree to Amazon Redshift JDBC Driver License Agreement https://s3.amazonaws.com/redshift-downloads/drivers/Amazon+Redshift+JDBC+Driver+License+Agreement.pdf"
    export SNEAQL_JDBC_DRIVER_JAR=/jars/RedshiftJDBC4-1.1.6.1006.jar
    export SNEAQL_JDBC_DRIVER_CLASS=com.amazon.redshift.jdbc4.Driver
  fi
fi

# https user/pass authenticated git repos are supported
# only the specified branch is cloned
if [ -n "$SNEAQL_GIT_REPO" ]
then
  echo "pulling git repo $SNEAQL_GIT_REPO branch $SNEAQL_GIT_REPO_BRANCH"

  # a QD ruby script creates the fully authenticated https url
  git_path=${SNEAQL_GIT_REPO/https\:\/\//}
  GIT_HTTPS_URL_WITH_AUTH="https://$SNEAQL_GIT_USER:$SNEAQL_GIT_PASSWORD@$git_path"

  # repo is cloned with --quiet to obscure the credentials
  cd /
  git clone $GIT_HTTPS_URL_WITH_AUTH --branch $SNEAQL_GIT_REPO_BRANCH --single-branch --quiet /repo
fi

# /repo is the preferred location for your sneaql code
# and is where the git based repos will be placed
# if this folder exists switch to it now
if [ -n "/repo" ]
then
  cd /repo
fi

# checks to see if parameters were passed to the container
if [ -n "$*" ]
then
  # if parameters were passed, forward them to sneaql
  sneaql "$@"
else
  # otherwise execute the transform in the current dir
  # (most likely /repo)
  sneaql exec .
fi
