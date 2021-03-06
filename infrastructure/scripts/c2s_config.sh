#!/bin/bash -x
serverEnv=$1;
if [ "$#" -eq "0" ];
  then
    echo "No arguments supplied. It should be either oneServerConfig or twoServerAppConfig or twoServerDbConfig. "
    exit 1
fi
sudo su << SudoUser
    # Declare methods start

    function defaultConfig() {
        # C2S_PROPS Directories
        mkdir /usr/local/java/
        mkdir /usr/local/java/C2S_PROPS/
    }

    function defaultAppServerConfig() {
        defaultConfig
        # C2S_PROPS Directories
        mkdir /usr/local/java/C2S_PROPS/uaa
        mkdir /usr/local/java/keystore

        ## Fetch uaa.yml from bhits uaa repo and place it under uaa directory
        curl https://raw.githubusercontent.com/bhits/uaa/master/config-template/uaa.yml > /usr/local/java/C2S_PROPS/uaa/uaa.yml

        ## Clone the c2s configuration data rep to '/usr/local/java' sub folder.
        cd /usr/local/java/C2S_PROPS
        git clone https://github.com/bhits/c2s-config-data.git
     }
    function defaultDbServerConfig() {
        defaultConfig

        # C2S_PROPS Directories
        mkdir /usr/local/java/C2S_PROPS/pcm
        mkdir /usr/local/java/C2S_PROPS/pls
        mkdir /usr/local/java/C2S_PROPS/vss

        ## Copy the sample provider data sql file to pcm sub folder
        curl https://raw.githubusercontent.com/bhits/pcm/master/pcm-db-sample/insert_consent_attestation_term.sql > /usr/local/java/C2S_PROPS/pcm/insert_consent_attestation_term.sql
        curl https://raw.githubusercontent.com/bhits/pcm/master/pcm-db-sample/insert_consent_revocation_term.sql > /usr/local/java/C2S_PROPS/pcm/insert_consent_revocation_term.sql
        curl https://raw.githubusercontent.com/bhits/pcm/master/pcm-db-sample/insert_purposes.sql > /usr/local/java/C2S_PROPS/pcm/insert_purposes.sql

        ## Copy the sample provider data sql file to pls sub folder
        curl https://raw.githubusercontent.com/bhits/pls/master/pls-db-sample/pls_db_sample.sql > /usr/local/java/C2S_PROPS/pls/pls_db_sample.sql
        ## Copy the sample vss data sql file to vss sub folder
        curl https://raw.githubusercontent.com/bhits/vss/master/vss-db-sample/vss_db_sample.sql > /usr/local/java/C2S_PROPS/vss/vss_db_sample.sql
      }

    function defaultOneDbServerConfig() {
        # C2S_PROPS Directories
        mkdir /usr/local/java/C2S_PROPS/pcm
        mkdir /usr/local/java/C2S_PROPS/pls
        mkdir /usr/local/java/C2S_PROPS/vss

        ## Copy the sample provider data sql file to pcm sub folder
        curl https://raw.githubusercontent.com/bhits/pcm/master/pcm-db-sample/insert_consent_attestation_term.sql > /usr/local/java/C2S_PROPS/pcm/insert_consent_attestation_term.sql
        curl https://raw.githubusercontent.com/bhits/pcm/master/pcm-db-sample/insert_consent_revocation_term.sql > /usr/local/java/C2S_PROPS/pcm/insert_consent_revocation_term.sql
        curl https://raw.githubusercontent.com/bhits/pcm/master/pcm-db-sample/insert_purposes.sql > /usr/local/java/C2S_PROPS/pcm/insert_purposes.sql

        ## Copy the sample provider data sql file to pls sub folder
        curl https://raw.githubusercontent.com/FEISystems/pls/master/pls-db-sample/pls_db_sample.sql > /usr/local/java/C2S_PROPS/pls/pls_db_sample.sql
        ## Copy the sample vss data sql file to vss sub folder
        curl https://raw.githubusercontent.com/bhits/vss/master/vss-db-sample/vss_db_sample.sql > /usr/local/java/C2S_PROPS/vss/vss_db_sample.sql
     }

    function oneServerConfig() {
        defaultAppServerConfig
        defaultOneDbServerConfig

        ## Copy the docker compose file to ‘/usr/local/java’ sub folder
        curl https://raw.githubusercontent.com/bhits/consent2share/master/infrastructure/deployment/one-server/docker-compose.yml > /usr/local/java/docker-compose.yml

        ## Copy the environment variables file to ‘/etc/profile.d’ sub folder
        curl https://raw.githubusercontent.com/bhits/consent2share/master/infrastructure/scripts/c2s_one_server_env.sh > /etc/profile.d/c2s_env.sh
     }


    function twoServerAppConfig() {
        defaultAppServerConfig

        ## Copy the docker compose file to ‘/usr/local/java’ sub folder
        curl https://raw.githubusercontent.com/bhits/consent2share/master/infrastructure/deployment/two-servers/docker-compose-app-server.yml > /usr/local/java/docker-compose.yml

        ## Copy the environment variables file to ‘/etc/profile.d’ sub folder
        curl https://raw.githubusercontent.com/bhits/consent2share/master/infrastructure/scripts/c2s_two_servers_app_env.sh > /etc/profile.d/c2s_env.sh

     }

    function twoServerDbConfig() {

        defaultDbServerConfig

        ## Copy the docker compose db file to ‘/usr/local/java’ sub folder
        curl https://raw.githubusercontent.com/bhits/consent2share/master/infrastructure/deployment/two-servers/docker-compose-db-server.yml > /usr/local/java/docker-compose.yml

        ## Copy the environment variables file to ‘/etc/profile.d’ sub folder
        curl https://raw.githubusercontent.com/bhits/consent2share/master/infrastructure/scripts/c2s_two_servers_db_env.sh > /etc/profile.d/c2s_env.sh

     }
    # Declare methods end

    # Start running script
    echo "server env " : $serverEnv
    if [ $serverEnv == "oneServerConfig" ];
    then
       oneServerConfig
    elif [ $serverEnv == "twoServerAppConfig" ];
    then
        twoServerAppConfig
    elif [ $serverEnv == "twoServerDbConfig" ];
    then
        twoServerDbConfig
    fi
SudoUser
