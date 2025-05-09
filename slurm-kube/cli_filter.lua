function slurm_cli_pre_submit(options, pack_offset)
  slurm.log_info("in pre_submit")
  return slurm.SUCCESS
end

function slurm_cli_setup_defaults(options, early_pass)
  slurm.log_info("in setup_defaults (early_pass: %s)", tostring(early_pass))
  return slurm.SUCCESS
end

function slurm_cli_post_submit(offset, job_id, step_id)
  slurm.log_info("in post_submit")
  return slurm.SUCCESS
end
