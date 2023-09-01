local_ip = "192.168.0.5"
timezone = "America/Denver"

docker_provider_host = "ssh://nate@server:22"
docker_provider_ssh_opts = [ "-o", "StrictHostKeyChecking=no", "-o", "UserKnownHostsFile=/dev/null" ]

pihole_dns_origins = [ "192.168.0.5" ]
nginx_config_file = "/mnt/docker/nginx_pihole.conf"

pihole_volumes = [
  {
    container_path = "/etc/pihole/"
    host_prefix = "/mnt/docker"
    host_suffix = "etc-pihole/"  
  },
  {
    container_path = "/etc/dnsmasq.d/"
    host_prefix = "/mnt/docker"
    host_suffix = "etc-dnsmasq.d/"  
  }
]

plex_volumes = [
    {
      container_path = "/tv"
      host_path = "/shared/TV_Shows"
    },
    {
      container_path = "/movies"
      host_path = "/shared/Movies"
    },
    {
      container_path = "/config"
      host_path = "/mnt/docker/plex/config"
    },
    {
      container_path = "/transcode"
      host_path = "/mnt/docker/plex/transcode"
    }
]