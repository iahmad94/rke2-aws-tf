data "template_cloudinit_config" "this" {
  gzip          = true
  base64_encode = true

  # Main cloud-init config file
  part {
    filename     = "cloud-config.yaml"
    content_type = "text/cloud-config"
    content = templatefile("${path.module}/files/cloud-config.yaml", {
      ssh_authorized_keys = var.ssh_authorized_keys
    })
  }

  part {
    filename     = "00_cfg.sh"
    content_type = "text/x-shellscript"
    content = templatefile("${path.module}/files/agent.sh", {
      token  = var.cluster_data.token
      server = var.cluster_data.server_url

      config = var.rke2_config
    })
  }

  part {
    filename     = "01_rke2.sh"
    content_type = "text/x-shellscript"
    content = templatefile("${path.module}/../../common/rke2.sh", {
      type = "agent"
    })
  }
}