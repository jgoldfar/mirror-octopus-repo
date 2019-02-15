originRepo:=https://git.code.sf.net/p/maxima/code
downstreamRepo:=git@github.com:jgoldfar/maxima-clone.git
destDir:=./maxima

cloneOrigin: ${destDir}/.git

${destDir}/.git:
	git clone --progress --verbose ${originRepo} $(dir $@)

addDownstream: ${destDir}/.git
	cd $(dir $<) && git remote add downstream ${downstreamRepo}

pushDownstream: ${destDir}/.git
	cd $(dir $<) && git push --porcelain --progress --force-with-lease --recurse-submodules=on-demand downstream refs/remotes/origin/*:refs/heads/*

mirror: cloneOrigin addDownstream pushDownstream

# Ths Openssl keys referenced below are only available in the Travis environment.
# If you have push access to the clone, the installation step is unnecessary.
install-ssh-key:
	mkdir -p ${HOME}/.ssh
	chmod 0700 ${HOME}/.ssh
	ssh-keyscan github.com > ${HOME}/.ssh/known_hosts
	openssl aes-256-cbc -K ${encrypted_75a6d6907a36_key} -iv ${encrypted_75a6d6907a36_iv} -in id_rsa.enc -out ${HOME}/.ssh/id_rsa -d
	chmod 0600 ${HOME}/.ssh/id_rsa


install-ssh-config:
	touch ${HOME}/.ssh/config
	echo "Host github.com" >> ${HOME}/.ssh/config
	echo "  HostName github.com" >> ${HOME}/.ssh/config
	echo "  User git" >> ${HOME}/.ssh/config
	echo "  IdentityFile ${HOME}/.ssh/id_rsa" >> ${HOME}/.ssh/config

install-ssh: install-ssh-key install-ssh-config
