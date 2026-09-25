resource "aws_instance" "test-ec2" {
  ami                    = var.ami_id
  instance_type          = var.instance_type
  subnet_id              = aws_subnet.public.id
  vpc_security_group_ids = [aws_security_group.web.id]

  root_block_device {
    encrypted = false
    tags      = {}
    tags_all  = {}

    volume_size           = 8
    volume_type           = "gp3"
    iops                  = 3000
    throughput            = 125
    delete_on_termination = true
  }

  tags = {
    Name = "${var.environment}-web-server"
  }

  associate_public_ip_address          = true
  disable_api_stop                     = false
  disable_api_termination              = false
  ebs_optimized                        = true
  get_password_data                    = false
  hibernation                          = false
  instance_initiated_shutdown_behavior = "stop"
  key_name                             = "my-key"
  monitoring                           = false
  placement_partition_number           = 0
  private_ip                           = "10.0.1.10"
  secondary_private_ips                = []
  security_groups                      = []
  source_dest_check                    = true

  tenancy                     = "default"
  user_data_replace_on_change = true
  volume_tags                 = null

  user_data = <<-EOF
    #!/bin/bash
    set -eux

    dnf update -y
    dnf install -y git docker

    systemctl enable --now docker
    usermod -aG docker ec2-user

    # ソケットのグループ権限を明示
    if [ -S /var/run/docker.sock ]; then
      chgrp docker /var/run/docker.sock
      chmod 660 /var/run/docker.sock
    fi

    # Docker Compose plugin
    ARCH=$(uname -m)
    case "$ARCH" in
      aarch64) COMPOSE_ARCH=aarch64 ;;
      *) COMPOSE_ARCH=x86_64 ;;
    esac
    mkdir -p /usr/local/lib/docker/cli-plugins
    curl -fsSL "https://github.com/docker/compose/releases/download/v2.29.7/docker-compose-linux-$${COMPOSE_ARCH}" \
      -o /usr/local/lib/docker/cli-plugins/docker-compose
    chmod +x /usr/local/lib/docker/cli-plugins/docker-compose

    # Node.js 20 + pm2（任意の補助用）
    curl -fsSL https://rpm.nodesource.com/setup_20.x | bash -
    dnf install -y nodejs
    npm install -g pm2

    mkdir -p /var/www/nuxt
    chown -R ec2-user:ec2-user /var/www/nuxt
  EOF

  capacity_reservation_specification {
    capacity_reservation_preference = "open"
  }
  cpu_options {
    core_count       = 1
    threads_per_core = 2
  }
  credit_specification {
    cpu_credits = "unlimited"
  }
  enclave_options {
    enabled = false
  }
  maintenance_options {
    auto_recovery = "default"
  }
  metadata_options {
    http_endpoint               = "enabled"
    http_protocol_ipv6          = "disabled"
    http_put_response_hop_limit = 2
    http_tokens                 = "required"
    instance_metadata_tags      = "disabled"
  }
  private_dns_name_options {
    enable_resource_name_dns_a_record    = false
    enable_resource_name_dns_aaaa_record = false
    hostname_type                        = "ip-name"
  }
}
