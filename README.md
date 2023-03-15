# Setup inicial no control node

Ao criar o control-node, criar o usuário `ansadmin`

```bash
sudo useradd ansadmin && \
sudo passwd ansadmin 
```

Adicionamos o novo usuário ao arquivo de sudoers

(logado como root)
```bash
visudo
```

![image](https://user-images.githubusercontent.com/80921933/225225690-8a4c497b-c463-4d8f-862a-54fc8b1eb525.png)

Agora, deixar o arquivo `/etc/ssh/sshd_config` na seguinte configuração:

![image](https://user-images.githubusercontent.com/80921933/225207451-9b59c8a4-3201-4feb-a250-90b24e4a5178.png)

Depois, reestartar o serviço de SSH

```
sudo service sshd restart
```

# Instalando o Ansible

```bash
sudo yum install python
sudo yum install python-pip
pip install ansible
```
