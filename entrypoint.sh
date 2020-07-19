#!/bin/sh -l


get_data(){
   
         curl -sL -H 'Cache-Control: no-cache'  -H 'Accept: application/vnd.github.v3+json'  $1  
}


WORKFLOW_JOBS_URL="https://api.github.com/repos/hroyg/slack-notify-workflow/actions/runs/$3/jobs" 
workflow_success=true
workflow_failure=false

workflow_jobs=$(get_data ${WORKFLOW_JOBS_URL} | jq '.jobs[] | [select(.status == "completed") | {name,conclusion,id,run_id,started_at}] |sort_by(.started_at)')
#########DEBUG########
echo $workflow_jobs |jq '.[]
echo $workflow_jobs |jq '.[] | .conclusion'
#########DEBUG#########
echo $workflow_jobs |jq '.[] | .conclusion' |  \
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
      echo "^^^^^^^^^^^^^^^^^^^^^^^^^^SUCCESS^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^^"
  done
