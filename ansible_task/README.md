## Ansible task

**Structure of ansible role**

```
│   play.yml
│   hosts.yml
│
└───roles
     └───flask
          └───defaults
          │      main.yml
          └───files
          │      flaskapp.py
          └───handlers
          │      main.yml
          └───tasks
          │      main.yml
          └───templates
                 pyton_flask.service.j2
                 sshd_config.j2

```

To start ansible role need to launch playbook _play.yml_ with command `ansible-playbook play.yml -i hosts.yml`.

