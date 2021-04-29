FROM ubuntu:16.10

RUN apt-get update -y && apt-get full-upgrade -y
RUN apt-get install -y bash-completion zsh curl cowsay git vim bsdmainutils

ADD celman-api-cli.sh /usr/bin/celman-api-cli.sh
ADD _celman-api-cli.sh /usr/local/share/zsh/site-functions/_celman-api-cli.sh
ADD celman-api-cli.sh.bash-completion /etc/bash-completion.d/celman-api-cli.sh
RUN chmod 755 /usr/bin/celman-api-cli.sh

#
# Install oh-my-zsh
#
RUN sh -c "$(curl -fsSL https://raw.githubusercontent.com/robbyrussell/oh-my-zsh/master/tools/install.sh)" || true

#
# Enable bash completion
#
RUN echo '\n\
. /etc/bash_completion\n\
source /etc/bash-completion.d/celman-api-cli.sh\n\
' >> ~/.bashrc

#
# Setup prompt
#
RUN echo 'export PS1="[sms-client] \$ "' >> ~/.bashrc
RUN echo 'export PROMPT="[sms-client] \$ "' >> ~/.zshrc

#
# Setup a welcome message with basic instruction
#
RUN echo 'cat << EOF\n\
\n\
This Docker provides preconfigured environment for running the command\n\
line REST client for $(tput setaf 6)sms-client$(tput sgr0).\n\
\n\
For convenience, you can export the following environment variables:\n\
\n\
$(tput setaf 3)CELMAN_CLIENT_HOST$(tput sgr0) - server URL, e.g. https://example.com:8080\n\
$(tput setaf 3)CELMAN_CLIENT_AUTH$(tput sgr0) - access token, e.g. "ASDASHJDG63456asdASSD"\n\
\n\
$(tput setaf 7)Basic usage:$(tput sgr0)\n\
\n\
$(tput setaf 3)Print the list of operations available on the service$(tput sgr0)\n\
$ celman-api-cli.sh -h\n\
\n\
$(tput setaf 3)Print the service description$(tput sgr0)\n\
$ celman-api-cli.sh --about\n\
\n\
$(tput setaf 3)Print detailed information about specific operation$(tput sgr0)\n\
$ celman-api-cli.sh <operationId> -h\n\
\n\
By default you are logged into Zsh with full autocompletion for your REST API,\n\
but you can switch to Bash, where basic autocompletion is also supported.\n\
\n\
EOF\n\
' | tee -a ~/.bashrc ~/.zshrc

ENTRYPOINT ["zsh"]
