# Setup inicial dos nodes

**Atenção:** Isso deve ser rodado em **todos** os nodes, control ou managed.

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

Seguir o tutorial: https://ianodad.medium.com/how-to-install-ansible-2-on-aws-linux-2-ec2-ba0ffde42792

O Ansible só deve ser instalado no control-node.

# Adicionando nodes que serão gerenciados pelo Ansible

No **control-node**, adicionamos o IP privado (ou público, porém, o público sempre se altera ao reiniciar a instância EC2) ao arquivo `/etc/ansible/hosts`

Depois, rodamos `ssh-copy-id \<IP_MANAGED_NODE>` (considerando que já criamos a chave id_rsa no control-node com o ssh-keygen).

Pronto! Agora, já podemos dar **ssh \<IP_MANAGED_NODE>** e se conectar a um managed-node normalmente.

# Módulos e executando os primeiros comandos

![image](https://user-images.githubusercontent.com/80921933/225442369-8f9837e4-f2a2-4f52-81dd-1cb5beaf068a.png)

Podemos executar comandos especificando o módulo. Os módulos abordados no curso estão listados acima.

# Módulo Ping

Para executar um comando simples de ping, executamos:

```bash
ansible all -m ping
```

- O **all** significa todos as máquinas presentes no arquivo `/etc/ansible/hosts`
- O **-m** especifica o módulo a ser usado

![image](https://user-images.githubusercontent.com/80921933/225442517-71ffc4bb-1ee5-40ae-aaa6-389caf220596.png)

# Módulo Command

Serve para executarmos comandos nas máquinas presentes no arquivo `/etc/ansible/hosts`

O comando abaixo rodará o comando "uptime" em todas as máquinas gerenciadas pelo Ansible 

```bash
ansible all -m command -a "uptime"
```

- A flag **-a** se refere aos argumentos do módulo.

# Módulo Stat

Verifica se um arquivo existe em um caminho nas máquinas

```bash
ansible all -m stat -a "path=<PATH_HERE>"
```

# Módulo Yum

Serve para instalar pacotes nas máquinas gerenciadas.

Como geralmente esse comando necessita de privilégios root, adicionamos a flag **-b**, que significa "become" root.

```bash
ansible all -m yum -a "name=<PACKAGE_HERE_LIKE_git>" -b
```

# Módulo User

Usado para criar um usuário.

```bash
ansible all -m user -a "name=<NAME>" -b
```

# Ansible Inventory

**Ansible Inventory** are the servers we'll run our commands into.

![image](https://user-images.githubusercontent.com/80921933/225504260-863363d1-60f1-4073-9a92-f2c9fc043306.png)

Inside of the inventory file, we can specify groups, as such:

vim /etc/ansible/hosts
```
[rhel]
192.121.131.131
[centos]
200.131.131.131
```

After that, we can also specify in which groups we want to run our ansible commands:

```bash
ansible <GROUP> -m ping
```

# The Ansible configuration file

Ansible has a default **ansible.cfg** file, that is created in `/etc/ansible/ansible.cfg`.

We can change a bunch of Ansible's default behaviour on it.

Also, we can create our own **ansible.cfg** file. Ansible will look for the **ansible.cfg** file in the following order:

```
ANSIBLE_CONFIG (environment variable if set)
ansible.cfg (in the current directory)
~/.ansible.cfg (in the home directory)
/etc/ansible/ansible.cfg
```
