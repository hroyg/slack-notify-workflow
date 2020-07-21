#!/bin/sh -l

get_data(){
   
         curl -sL -H 'Cache-Control: no-cache'  -H 'Accept: application/vnd.github.v3+json'  $1  
}

WORKFLOW_JOBS_URL="https://api.github.com/repos/$3/actions/runs/$2/jobs" 
workflow_success=true
workflow_failure=false
workflow_jobs=$(get_data ${WORKFLOW_JOBS_URL} | jq '[.jobs[] | select(.status == "completed") | {name,conclusion,id,run_id,started_at,steps}] |sort_by(.started_at)')
jobs_conclusion=$(echo $workflow_jobs |jq -r -c '.[] | .conclusion')

for conclusion in $jobs_conclusion ; do
      if [[ $conclusion == "cancelled" ]] ; then
        workflow_success=false
        break
      fi

      if [[ $conclusion == "failure"  ]] ; then
        workflow_failure=true
        failed_job=$(echo $workflow_jobs |jq -r '.[] | select(.conclusion == "failure") | .name')
        failed_job_step=$(echo $workflow_jobs |jq -r '.[]|select(.conclusion == "failure") | .steps[] | select(.conclusion == "failure") | .name')
        break
      fi
done


case "${workflow_success},${workflow_failure}" in                                                        
                                                                                                                                                                                                                 
  false,false)   echo "::set-output name=workflow_result::cancelled"    
                 echo "::set-output name=notification_color::#FCD84F"  ;;
  
                                                                                                         
  true,true  )   echo "::set-output name=workflow_result::failure"                                
                 echo "::set-output name=failed_job::; Job:$failed_job"  
                 echo "::set-output name=failed_step::; Step:$failed_job_step"
                 echo "::set-output name=notification_color::#F72407"  ;;                                                                                                                        
                                                                                                         
  *          )   echo "::set-output name=workflow_result::success"
                 echo "::set-output name=notification_color::#63DE0E";;                            

esac
