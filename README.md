# Workflow Status action 

This action returns the workflow status (Success, Cancelled, Failure), in case of failure it also returns the failed job name and the failed job step name.

## Inputs

- ``workflow_name`` - (**required**) - The name of the workflow we are curently running. 
   Default: `"<placeholder-workflow-name>"`.
- `github_run_id` - (**required**) - A unique number for each run within a repository. This number does not change if you re-run the workflow run. 
   Default: `"<placeholder-github_run_id>"`.
- `github_repository` - (**required**) - The owner and repository name. e.g, pixellot/Hello-World.\n 
   Default: `"<placeholder-github-repository>"`.

## Outputs

- `workflow_result` - The result of the current workflow run (Success, Cancelled, Failure).

- `failed_job` - The name of the job that was failed (only if workflow conclusion is Failure).

- `failed_step` - The name of the step that was failed (only if workflow conclusion is Failure).

- `notification_color` - The color for A slack notification (Green, Yelllow, Red).

## Example usage
```yaml
- name: Workflow Status 
  id: workflow-status
  uses: pixellot/workflow-status
  with:
    workflow_name:  ${{ github.workflow }}
    github_run_id: ${{ github.run_id }}
    github_repository: ${{ github.repository }}
```
