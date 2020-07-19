#!/bin/sh -l


get_data(){
#debug
   echo "curl -sL -H 'Cache-Control: no-cache' -H 'Accept: application/vnd.github.v3+json'  $3 "
        curl -sL -H 'Cache-Control: no-cache' -H 'Accept: application/vnd.github.v3+json'  $3      # check if authentication is needed 
}


WORFLOW_JOBS_URL="https://api.github.com/repos/hroyg/slack-notify-workflow/actions/runs/${INPUT_GITHUB_RUN_ID /jobs" # change job id to dyanmic var 
echo "WORFLOW_JOBS_URL: is parsed as -  ${WORFLOW_JOBS_URL}"

workflow_success=true
workflow_failure=false

workflow_jobs=$(get_data $WORFLOW_JOBS_URL jq '.jobs[] |[select(.status == "completed") |{name,status,conclusion,id,run_id,started_at}]|sort_by(.started_at)')
echo $workflow_jobs |jq .


echo $workflow_jobs  |jq  -c -r '.[]| .conclusion'| \
        while read job_conclusion ;do\

                if [[ $job_conclusion == "cancelled" ]] ; then
                        workflow_success=false
                        echo "cancel"
                        break
                fi

                if [[ $job_conclusion == "failure"  ]] ; then
                        workflow_failure=true
                        echo  "faild"
                        break
                fi
                echo "^^^^^^^^^^^^^^^^^^^^^^^^^^SUCCESS^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^6"
        done

