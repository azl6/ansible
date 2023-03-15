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

Para executar um comando simples de ping, executamos:

```bash
ansible all -m ping
```

- O **all** significa todos as máquinas presentes no arquivo `/etc/ansible/hosts`
- O **-m** especifica o módulo a ser usado

![image](https://user-images.githubusercontent.com/80921933/225442517-71ffc4bb-1ee5-40ae-aaa6-389caf220596.png)
