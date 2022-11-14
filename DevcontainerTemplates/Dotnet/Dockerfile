#See https://aka.ms/containerfastmode to understand how Visual Studio uses this Dockerfile to build your images for faster debugging.

# This Dockerfile adds a non-root user with sudo access. Use the "remoteUser"
# property in devcontainer.json to use it. On Linux, the container user's GID/UIDs
# will be updated to match your local UID/GID (when using the dockerFile property).
# Create a non-root user to use if preferred - see https://aka.ms/vscode-remote/containers/non-root-user for details.

# Making Focal the base version again
# [Choice] .NET version: 6.0, 3.1, 6.0-bullseye, 3.1-bullseye, 6.0-focal, 3.1-focal
ARG VARIANT=6.0-focal
FROM mcr.microsoft.com/vscode/devcontainers/dotnet:0-${VARIANT}

# Uncomment to opt out of Func CLI telemetry gathering
FROM mcr.microsoft.com/azure-storage/azurite
# [Choice] Node.js version: none, lts/*, 18, 16, 14
ARG NODE_VERSION="none"
RUN if [ "${NODE_VERSION}" != "none" ]; then su vscode -c "umask 0002 && . /usr/local/share/nvm/nvm.sh && nvm install ${NODE_VERSION} 2>&1"; fi
# # [Option] Install zsh
# ARG INSTALL_ZSH="true"
# # [Option] Upgrade OS packages to their latest versions
# ARG UPGRADE_PACKAGES="true"

# # Install needed packages and setup non-root user. Use a separate RUN statement to add your own dependencies.
# COPY .devcontainer/library-scripts/*.sh /tmp/library-scripts/
# RUN bash /tmp/library-scripts/common-debian.sh "${INSTALL_ZSH}" "${USERNAME}" "${USER_UID}" "${USER_GID}" "${UPGRADE_PACKAGES}" "true" "true" \
#     # Install the Azure CLI
#     && bash /tmp/library-scripts/azcli-debian.sh \
#     # Clean up
#     && apt-get clean -y && rm -rf /var/lib/apt/lists/* /tmp/library-scripts
