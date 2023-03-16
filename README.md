# Setup inicial dos nodes

**Atenção:** Isso deve ser rodado em **todos** os nodes, control ou managed.

Ao criar o control-node, criar o usuário `ansadmin`

```bash
sudo useradd ansadmin && \
sudo passwd ansadmin 
```

**Importante:** Em algumas distros, o useradd **não criará uma pasta no /home/**. Para tais casos, devemos também criar uma pasta para o usuário **ansadmin** e conceder-lhe ownership:

```bash
sudo mkdir /home/ansadmin -p && sudo chown ansadmin:ansadmin
```

Adicionamos o novo usuário ao arquivo de sudoers (no Ubuntu o primeiro **ALL** será um pouco diferente, mas não tem problema. O real importante é o **NOPASSWD: ALL**)

(logado como root)
```bash
visudo
```

![image](https://user-images.githubusercontent.com/80921933/225700329-b0eb62fe-c8da-4fa2-85ae-2652aab6eedd.png)

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

**Atenção:** O módulo **package** pode ser uma melhor opção, já que algumas distros usam yum, apt, pacman, etc... Com o módulo **package**, o Ansible consegue decidir qual gerenciador de pacotes ele usará.

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

# Módulo file

Usado para manipular (criar, deletar, etc) arquivos e/ou diretórios:

```yaml
---
- hosts: all
  become: true
  tasks:
    - name: create file named CREATE.txt
      file:
        path: /home/ansadmin/CREATE.txt # Caminho do arquivo a ser criado
        state: touch # Pode ser alterado para performar diferentes ações no arquivo referenciado
```

# Módulo copy

Usado para copiar arquivos e/ou diretórios:

```yaml
**---
- hosts: all
  become: true
  tasks:
    - name: copying file /tmp/MECOPIA.txt to /home/ansadmin/MECOPIA.txt
      copy:
        src: /tmp/MECOPIA.txt
        dest: /home/ansadmin/MECOPIA.txt
        mode: 0777 # Precisa do 0!
        owner: john
```

# Módulo service

Usado para gerenciar services, como startar, stoppar, etc

```yaml
---
- hosts: all
  become: true
  tasks:
    - name: Start Nginx
      service:
        name: nginx
        state: started
```

# Ansible Inventory

**Ansible Inventory** são os servidores nos quais executaremos nossos comandos.

![image](https://user-images.githubusercontent.com/80921933/225504260-863363d1-60f1-4073-9a92-f2c9fc043306.png)

Dentro do arquivo de inventory (hosts), podemos especificar grupos, como:

vim /etc/ansible/hosts
```
[rhel]
192.121.131.131
[centos]
200.131.131.131
```

Depois disso, também podemos especificar em quais grupos queremos executar nossos comandos:

```bash
ansible <GROUP> -m ping
```

# Ansible configuration file

Ansible tem um arquivo padrão **ansible.cfg**, que é criado em `/etc/ansible/ansible.cfg`.

Podemos alterar vários comportamentos padrões do Ansible nele.

Além disso, podemos criar nosso próprio arquivo **ansible.cfg**. O Ansible procurará o arquivo **ansible.cfg** na seguinte ordem:

```
ANSIBLE_CONFIG (environment variable if set)
ansible.cfg (in the current directory)
~/.ansible.cfg (in the home directory)
/etc/ansible/ansible.cfg
```

# Ansible Playbooks

Playbooks são uma forma de executarmos múltiplos comandos sequencialmente:

vim createUser.yaml
```yaml
---
- name: Playbook to create an user # Name of the playbook
  hosts: all
  become: true
  tasks:
    - name: Creating the user jhon... # Name of the task
      user: 
        name=jhon # Argument of the module "user"
```

Basta alterarmos o playbook da mesma forma que executamos os comandos na CLI, exemplo:
- No lugar de **all**, poderíamos especificar um grupo
- No lugar de **user**, poderíamos especificar outro módulo, assim como os argumentos do módulo depois do **:**

Para executar o playbook, executamos:

```bash
ansible-playbook createUser.yaml
```

# Notify e Handlers

Notify e Handlers servem para somente rodarmos uma task quando formos notificados de que outra já foi finalizada:

```
---
- hosts: all
  become: true
  tasks:
    - name: Install nginx
      package:
        name: nginx
        state: present
      notify: Start Nginx #######
                                # Match!
  handlers:                     # O notify "notifica" uma task pelo NOME!
    - name: Start Nginx #########
      service:
        name: nginx
        state: started
```
