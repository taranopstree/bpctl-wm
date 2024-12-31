function generateCIManifests() {
    echo ""
    echo "******************************"
    echo "Reading the source files for service env CI on-boarding"
    cat ${SOURCE_CSV}

    while IFS=, read -r application service application_env git_repo git_branch gitleaks_failure_action sam_failure_action aws_region account_id role_name instructions sam_dir_path ms_hook_url dns_url job_template environment_master registry_name
    do
        serviceCIDir=${TGT_FOLDER}/${service}/env/${environment_master}/${application_env}/ci
        mkdir -p ${serviceCIDir}
        export application
        export service
        export application_env
        export git_repo
        export git_branch
        export gitleaks_failure_action
        export sam_failure_action=$7
        export aws_region
        export account_id
        export role_name
        export instructions
        export sam_dir_path
        export ms_hook_url
        export dns_url
        envsubst < ${TEMPLATE_FOLDER}/ci.yaml > ${serviceCIDir}/bp.yaml

        if [ ${APPLY_MANIFEST} == "true" ]
        then
            echo "User requesting to apply manifest"
            bpctl apply -f ${serviceCIDir}/bp.yaml
        else
            cat ${serviceCIDir}/bp.yaml
            echo "We will only generate manifest"
        fi
    done < <(tail -n +2 ${SOURCE_CSV})
}

function generateServiceCDManifests() {
    echo ""
    echo "******************************"
    echo "Reading the source files for service env CD on-boarding"
    cat ${SOURCE_CSV}

    while IFS=, read -r service application environment_master application_env desired_replication requests_memory_quota requests_cpu_quota limits_cpu_quota limits_memory_quota
    do
        serviceCDDir=${TGT_FOLDER}/${service}/env/${environment_master}/${application_env}/cd
        mkdir -p ${serviceCDDir}
        export service 
        export application 
        export environment_master 
        export application_env 
        export desired_replication 
        export requests_memory_quota 
        export requests_cpu_quota 
        export limits_cpu_quota 
        export limits_memory_quota
        envsubst < ${TEMPLATE_FOLDER}/cd.yaml > ${serviceCDDir}/bp.yaml

        if [ ${APPLY_MANIFEST} == "true" ]
        then
            echo "User requesting to apply manifest"
            bpctl apply -f ${serviceCDDir}/bp.yaml
        else
            cat ${serviceCDDir}/bp.yaml
            echo "We will only generate manifest"
        fi
    done < <(tail -n +2 ${SOURCE_CSV})
    
}

function generateServiceManifests() {
    echo ""
    echo "******************************"
    echo "Reading the source files for service onboarding"
    cat ${SOURCE_CSV}

    while IFS=, read -r service application
    do
        serviceDir=${TGT_FOLDER}/${service}
        mkdir -p ${serviceDir}
        export service
        export application
        envsubst < ${TEMPLATE_FOLDER}/service.yaml > ${serviceDir}/bp.yaml

        if [ ${APPLY_MANIFEST} == "true" ]
        then
            echo "User requesting to apply manifest"
            bpctl apply -f ${serviceDir}/bp.yaml
        else
            echo "We will only generate manifest"
            cat ${serviceDir}/bp.yaml
        fi
    done < <(tail -n +2 ${SOURCE_CSV})
}

function generateServiceEnvManifests() {
    echo ""
    echo "******************************"
    echo "Reading the source files for service env onboarding"
    cat ${SOURCE_CSV}

    while IFS=, read -r service application application_env manual_build manual_deploy application_job_template dev_access qa_access devops_access environment_master
    
    do
        serviceEnvDir=${TGT_FOLDER}/${service}/env/${environment_master}/${application_env}
        mkdir -p ${serviceEnvDir}
        export service
        export application
        export application_env
        export manual_build
        export manual_deploy
        export application_job_template
        export dev_access
        export qa_access
        export devops_access
        export environment_master
        envsubst < ${TEMPLATE_FOLDER}/serviceEnv.yaml > ${serviceEnvDir}/bp.yaml

        if [ ${APPLY_MANIFEST} == "true" ]
        then
            echo "User requesting to apply manifest"
            bpctl apply -f ${serviceEnvDir}/bp.yaml
        else
            echo "We will only generate manifest"
            cat  ${serviceEnvDir}/bp.yaml
        fi
    done < <(tail -n +2 ${SOURCE_CSV})
}

function generateReposManifests() {
    echo ""
    echo "******************************"
    echo "Reading the source files for repos onboarding"
    cat ${SOURCE_CSV}

    while IFS=, read -r reponame git_provider url
    do
        reposDir=${TGT_FOLDER}/repos
        mkdir -p ${reposDir}
        export reponame
        export git_provider
        export url
        envsubst < ${TEMPLATE_FOLDER}/repos.yaml > ${reposDir}/bp.yaml

        if [ ${APPLY_MANIFEST} == "true" ]
        then
            echo "User requesting to apply manifest"
            bpctl apply -f ${reposDir}/bp.yaml
        else
            echo "We will only generate manifest"
            cat ${reposDir}/bp.yaml
        fi
    done < <(tail -n +2 ${SOURCE_CSV})
}

function pause() {
    echo "Press a key to continue"
    read
    clear
}