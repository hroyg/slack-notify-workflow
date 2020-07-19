#!/bin/sh -l
#echo "-------$2------------"
#echo "Hello $1"
#time=$(date)
#echo "::set-output name=time::$time"


#!/bin/bash


get_data(){
        curl -sL -H 'Cache-Control: no-cache' -H 'Accept: application/vnd.github.v3+json'  $1      # check if authentication is needed 
}


SLACK_WEBHOOK=i"https://hooks.slack.com/services/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"

WORFLOW_JOBS_URL="https://api.github.com/repos/hroyg/slack-notify-workflow/actions/runs/${{ github.run_id }}/jobs" # change job id to dyanmic var 



workflow_success=true
workflow_failure=false

workflow_jobs=$(get_data $WORFLOW_JOBS_URL $GITHUB_TOKEN|jq '.jobs[] |[select(.status == "completed") |{name,status,conclusion,id,run_id,started_at}]|sort_by(.started_at)')











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
        done
