# Primeiros passos

Ao criar o control-node, criar o usuário `ansadmin`

```bash
sudo echo "ansible-control-node" >> /etc/hostname && \
sudo useradd ansadmin && \
sudo passwd ansadmin 
```

Adicionamos o novo usuário ao arquivo de sudoers

(logado como root)
```bash
visudo
```