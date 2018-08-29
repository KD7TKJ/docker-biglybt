# docker-biglybt

docker-vuze
All the prereqs to run BiglyBT in a container accessed via a VNC client. 

The container creates a user called plex as UID 972; This allows the application to work alongside the plex plugins on FreeNAS.
On any UNIX system, create a matching user on your host system and give it access to your biglybt / downloads directory:

useradd -u 972 -U -m -s /bin/false -d /dev/null plex
mkdir -p plex/.biglybt # config directory
chown -R plex plex
chown -R plex downloads

or enable ACLs and:

setfacl -R -m u:plex:rwx

# Run

Mount your config directory in from the host using -v to keep all the configuration outside the container, this also means the installation is portable and upgradable without rebuilding the container.

You may also want to mount other directories for downloads from elsewhere on the file system:

docker run -d --name biglybt \
-e "passwd=moomoo" \
-v /home/jim/plex:/plex/plex \
-v /home/jim/plex/.biglybt:/plex/.biglybt \
-v /incoming/downloads:/plex/downloads \
-v /incoming/partial:/plex/partial \
-v /incoming/torrents:/plex/torrents \
-p 5900:5900 \
jamesyale/docker-biglybt

Image based on jamesyale/docker-vuze, but with the following changes:
  Dockerfile:
    Changed the user that is created to 'plex' with UID 972; Changed home directory, '/plex'
    Changed the user the container and commands are run as to 'plex'
    Changed the order of the commands, such that the User is Plex before copying the entrypoint
  Entrypoint.sh
    USER environment variable changed to 'plex'
    HOME environment variable added, value set to '/plex,'
    Directories changed to biglybt.
    
Note about the underlying file systems: 
  The config directory must be on a underlying file system that supports file locking; NFS and CIFS are known to not support the required locks in most cases. 
  In the developer's use case, the problem was solved using iSCSI volumes mounted on the host, and passed in to the containers. 
  In many "Normal" use cases, it may be appropriate to just use a local folder.
