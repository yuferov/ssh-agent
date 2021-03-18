# ssh-agent
Repo with only Dockerfile of ssh-agent made for studying purposes.
Launched agent with the following command:
docker run -v /var/run/docker.sock:/var/run/docker.sock -dit --rm --network jenkins-network --hostname jenkins-slave -p 2222:22 ssh-agent:1.7.
