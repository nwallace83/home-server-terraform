local_ip = "192.168.0.10"

docker_provider_host = "unix:///var/run/docker.sock"

pihole_dns_origins = "192.168.0.5"
nginx_config_file = "/Users/nate/Google Drive/My Drive/Projects/home-server-terraform/pihole_nginx/nginx.conf"

plex_volumes = [
  {
    container_path = "/tv"
    host_path = "/tmp/docker/plex/tv"
  },
  {
    container_path = "/movies"
    host_path = "/tmp/docker/plex/movies"
  },
  {
    container_path = "/config"
    host_path = "/tmp/docker/plex/config"
  },
  {
    container_path = "/transcode"
    host_path = "/tmp/docker/plex/transcode"
  }
]