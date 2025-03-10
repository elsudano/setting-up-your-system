SHELL = /bin/bash
INVENTORY = inventory.yml
PYTHON_VERSION = 3
VIRTUALENV = virtualenv
VAULT_ANSIBLE = vault
NUM = $(shell ls -A roles/ | wc -l)

.PHONY: help
help:
	@echo -e "\n\e[36mIf you want run the role in Debug Mode, you just use the command: \e[97mmake 02_ansible-run EXTRA=-vvv\e[0m\n"
	@grep -oE '^[a-zA-Z0-9_-]+:.*?## .*$$|\*\+[%0-9a-zA-Z_-]+:.*?## .*$$' $(MAKEFILE_LIST) \
	| awk 'BEGIN {FS = ":.*?## "}{printf "\033[36m%-30s\033[39m %s\n", $$1, $$2}' \
	| sort -u

$(VIRTUALENV):
	python$(PYTHON_VERSION) -m venv $(VIRTUALENV)
	$(call virtualenv, $(VIRTUALENV), pip install --no-cache-dir --upgrade 'ansible' 'pip' 'passlib')

ansible-check: $(VIRTUALENV) .requirements ## Perform an Ansible check
	$(call virtualenv, $(VIRTUALENV), ansible-playbook -i $(INVENTORY) site.yml --diff --check $(EXTRA))

ansible-run: $(VIRTUALENV) .requirements ## Perform an Ansible execution
	$(call virtualenv, $(VIRTUALENV), ansible-playbook -i $(INVENTORY) site.yml --diff $(EXTRA))

molecule-check: $(VIRTUALENV) ## You can check if the role is ok
	$(call virtualenv, $(VIRTUALENV), molecule check)

encrypt: ## Encrypt files for uploading to repository
	$(call virtualenv, $(VIRTUALENV), ansible-vault encrypt vault/*.yml > /dev/null)

decrypt: ## Decrypt files for working with them
	$(call virtualenv, $(VIRTUALENV), ansible-vault decrypt vault/*.yml > /dev/null)

.PHONY: 06_upload
upload: 04_encrypt .upload 05_decrypt ## Encrypt vault files and add, commit the files with message, for e.g. upload MESSAGE="Add files"

.PHONY: 07_download
download: .download 05_decrypt ## Downloading the files and decrypt vault files for editing ¡¡WARNING!! this operation push in stash your changes

.ONESHELL:
documentation: $(VIRTUALENV) ## Make the documentation of the role, you can change the role and run this target to create a new README.md
	@cd $(VIRTUALENV)

clean: ## Clean the environment
	@rm -Rf $(VIRTUALENV)/ *.retry
	@rm -Rf roles/*.*

#------------------------------------------------
#|               Private targets                |
#------------------------------------------------
define virtualenv
	(source $1/bin/activate && $2;)
endef

.check_vault_file: $(VAULT_ANSIBLE)/credentials.txt
	@bash -c 'if [ ! -s $(VAULT_ANSIBLE)/credentials.txt ]; then echo "Please create the $(VAULT_ANSIBLE)/credentials.txt file with the password inside"; fi;'

.virtualenv-package:
	@sudo apt-get update; sudo apt-get -y install python$(PYTHON_VERSION)-virtualenv

.upload:
ifeq ($(MESSAGE),)
	@echo "Error: MESSAGE is not set, please use the variable MESSAGE before to upload the code, like that: make 06_upload MESSAGE=Add new files"
else
	@git add .
	@git commit -m "$(MESSAGE)"
	@git push
endif

.download:
	@git stash push -a
	@git pull --rebase
	@git stash pop

.requirements: $(VIRTUALENV) requirements.yml
ifeq ($(NUM),0)
	$(call virtualenv, $(VIRTUALENV), ansible-galaxy install -r requirements.yml -p roles/ -f $(EXTRA))
endif

.PHONY: $(PHONY)
.DEFAULT_GOAL: help
