#!/bin/sh -l


get_data(){
   
         curl -sL -H 'Cache-Control: no-cache'  -H 'Accept: application/vnd.github.v3+json'  $1  
}


WORKFLOW_JOBS_URL="https://api.github.com/repos/hroyg/slack-notify-workflow/actions/runs/$3/jobs" 
workflow_success=true
workflow_failure=false

workflow_jobs=$(get_data ${WORKFLOW_JOBS_URL} | jq '[.jobs[] | select(.status == "completed") | {name,conclusion,id,run_id,started_at}] |sort_by(.started_at)')
#########DEBUG########
echo $workflow_jobs |jq '.[]'
echo $workflow_jobs |jq '.[] | .conclusion'
#########DEBUG#########
jobs_conclusion=$(echo $workflow_jobs |jq -r -c '.[] | .conclusion')
for conclusion in $jobs_conclusion ; do
      echo  $conclusion #DEBUG
      if [[ $job_conclusion == "cancelled" ]] ; then
        workflow_success=false
        echo  "------------------------CANCELLED------------------"
        break
      fi

      if [[ $job_conclusion == "failure"  ]] ; then
        workflow_failure=true
        echo  "------------------------FAILURE------------------"
        failed_job_step=$(echo $workflow_jobs |jq -r '.[]|select(.conclusion == "failure") \
        | .steps[] | select(.conclusion == "failure") | .name')
        break
      fi
      
      echo  "------------------------SUCCESS------------------"
done


case "${workflow_success},${workflow_failure}" in                                                        
                                                                                                         
                                                                                                         
       false,false)    echo "::set-output name=workflow_result::cancelled"  ;;                           
                                                                                                         
        true,true)      echo "::set-output name=workflow_result::failure"                                
                        echo "::set-output name=failed_step::$failed_job_step"                           
                        echo $failed_job_step;;                                                          
                                                                                                         
                *)      echo "::set-output name=workflow_result::success"  ;;                            
esac


