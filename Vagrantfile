# -*- mode: ruby -*-
# vi: set ft=ruby :

# https://stackoverflow.com/questions/72151630/how-to-run-a-bash-script-on-wsl-with-powershell/72205311#72205311
# https://stackoverflow.com/questions/26811089/vagrant-how-to-have-host-platform-specific-provisioning-steps
if Vagrant::Util::Platform.windows?
    # is windows
    puts "Vagrant launched from windows."
    # TODO test on Windows PS
    DOCKER_GID = `wsl.exe stat -c '%g' //var/run/docker.sock | tr -d '\n'`
elsif Vagrant::Util::Platform.darwin?
    # is mac
    puts "Vagrant launched from mac."
elsif Vagrant::Util::Platform.linux?
    # is linux
    puts "Vagrant launched from linux."
    DOCKER_GID = `stat -c '%g' /var/run/docker.sock | tr -d '\n'`
    puts "host: /var/run/docker.sock is owned by GID #{DOCKER_GID}"
else
    # is some other OS
    puts "Vagrant launched from unknown platform."

end


Vagrant.configure(2) do |config|
  config.vm.define "vagrant.podman.systemd", autostart: true do |conf|
    conf.vm.hostname = "vagrant.podman.systemd"

    ############################################################
    # Provider for Docker on Intel or ARM (aarch64)
    ############################################################
    conf.vm.provider :docker do |docker, override|
      override.vm.box = nil
      docker.name = "vagrant.podman.systemd"
      #docker.image = ""
      docker.build_dir = "."
      docker.dockerfile = "Containerfile"
      docker.build_args = ["--build-arg", "DOCKER_GID=#{DOCKER_GID}"]
      docker.remains_running = true
      docker.has_ssh = true

      docker.privileged = true
      #docker.volumes = ["/sys/fs/cgroup:/sys/fs/cgroup:rw"]
      #docker.create_args = ["-t", "--cgroupns=host", "--security-opt", "seccomp=unconfined", "--tmpfs", "/tmp", "--tmpfs", "/run", "--tmpfs", "/run/lock", "--mount", "type=bind,source=//var/run/docker.sock,target=/var/run/docker.sock"]
        #"--mount", "type=bind,source=//var/run/docker.sock,target=/var/run/docker.sock",
        #"-v", "/sys/fs/cgroup:/sys/fs/cgroup:rw",

      # Uncomment to force arm64 for testing images on Intel
      # docker.create_args = ["--platform=linux/arm64", "--cgroupns=host"]
    end

    conf.vm.boot_timeout = 600
    conf.vm.synced_folder ".", "/vagrant_data"
    # Install Docker and pull an image
    # conf.vm.provision :docker do |d|
    #   d.pull_images "alpine:latest"
    # end
  end
end
