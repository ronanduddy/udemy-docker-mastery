# create your custom drupal image here, based of official drupal

# - First you need to build a custom Dockerfile in this directory,
#  `FROM drupal:8.6` NOTE: if it fails to build, try the lastest 8 branch version with `FROM drupal:8`
FROM drupal:8.6

# - Then RUN apt package manager command to install git: `apt-get update && apt-get install -y git`
# - Remember to cleanup after your apt install with `rm -rf /var/lib/apt/lists/*`
#  and use `\` and `&&` properly. You can find examples of them in drupal official
#  image. More on this below under Compose file.
RUN apt-get update \
  && apt-get install -y git \
  && rm -rf /var/lib/apt/lists/*

# - Then change `WORKDIR /var/www/html/themes`
WORKDIR /var/www/html/themes

# - Then use git to clone the theme with:
#  `RUN git clone --branch 8.x-3.x --single-branch --depth 1 https://git.drupal.org/project/bootstrap.git`
# - Combine that line with this line, as we need to change permissions on files
#  and don't want to use another image layer to do that (it creates size bloat).
#  This drupal container runs as www-data user but the build actually runs as root,
#  so often we have to do things like `chown` to change file owners to the proper user:
#  `chown -R www-data:www-data bootstrap`. Remember the first line needs a `\` at
#  end to signify the next line is included in the command, and at start of next
#  line you should have `&&` to signify "if first command succeeds then also run this command"
RUN git clone --branch 8.x-3.x --single-branch --depth 1 https://git.drupal.org/project/bootstrap.git \
  && chown -R www-data:www-data bootstrap

# - Then, just to be safe, change the working directory back to its default
#  (from drupal image) at `/var/www/html`
WORKDIR /var/www/html
