# EasyNewOS

对新系统（Win、macOS、Linux）进行配置，包含通用软件、脚本和配置文件。

## Win

### 1. 激活 Windows 和 Office

在 [这个网站](https://massgrave.dev/) 可以最简单地激活 Windows 和 Office，这个方法经证实确实有效（当前为2025年10月3日），可以直接激活数字许可证，根据网页和终端中的指示做即可。

在这个网站还可以下载各种版本的 Windows 镜像和各个版本的 Office（包括 Microsoft 365）。

### 2. VSCode(Win、macOS、Linux 通用)

VSCode 配置编译运行 C 和 CPP 的运行任务，主要包括 `tasks.json`、`launch.json` 两个文件

配置 **运行生成任务** 的快捷键（`F6`）

配置 **删除行** 的快捷键（`CTRL + D`）

### 3. VSCode 插件

不过 VSCode 可以通过云同步将配置和插件一键同步到新设备。

- [Chinese Language Pack](https://marketplace.visualstudio.com/items?itemName=MS-CEINTL.vscode-language-pack-zh-hans)

- [Remote SSH](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-ssh)

- [C/C++](https://marketplace.visualstudio.com/items?itemName=ms-vscode.cpptools)

- [CodeLLDB](https://marketplace.visualstudio.com/items?itemName=vadimcn.vscode-lldb)

- [VSCode Great Icons](https://marketplace.visualstudio.com/items?itemName=emmanuelbeziat.vscode-great-icons)

- [filesize](https://marketplace.visualstudio.com/items?itemName=mkxml.vscode-filesize)

- [Reload](https://marketplace.visualstudio.com/items?itemName=natqe.reload)

### 4. GCC

[GCC Install](https://www.gnu.org/software/gcc/)

推荐使用 [MSY2S](https://www.msys2.org/)，可以安装最新版本的 GCC，同时可以安装最新版本的 gdb。不推荐使用 MinGW 来安装 GCC，MinGW 是编译生成 32 位的程序，同时 gdb 版本也只有 7.6.1，低版本的 gdb 在 vscode 中进行调试时很难直观看到容器中的具体值，添加 watch 很多也都不支持，新版本 gdb 则没有这个问题。可以使用 MinGW-w64.

### 5. WSL

首选推荐使用 [WSL2](https://learn.microsoft.com/zh-cn/windows/wsl/install)，通过[这篇文章](https://www.cnblogs.com/charescape/p/18867702)可以将 WSL2 的虚拟硬盘从默认的 C 盘迁移到任意地方。

在安装 WSL2 之前首先要将 **适用于 Linux 的 Windows 子系统** 的功能打开，详见[这篇文章](https://zhuanlan.zhihu.com/p/675310334)。

[Windows11 安装 WSL2 详细过程](https://www.cnblogs.com/xiao987334176/p/18864140#autoid-1-1-0)

附：当宿主机配置了代理的时候，运行 WSL 终端会出现 `wsl: 检测到 localhost 代理配置，但未镜像到 WSL。NAT 模式下的 WSL 不支持 localhost 代理` 的提示，[这篇文章](https://www.cnblogs.com/hg479/p/17869109.html) 和 [WSL 的 github issue](https://github.com/microsoft/WSL/issues/10753) 可以解决这个问题。

### 6. 字体

- [苹方](https://github.com/ACT-02/PingFang-for-Windows)

- [思源宋体](https://github.com/adobe-fonts/source-han-serif)

- [Fira Code](https://github.com/tonsky/FiraCode)

- [Cascadia Code](https://github.com/microsoft/cascadia-code)

- [Melon](https://github.com/ueaner/fonts)

- [Monaco](https://github.com/Karmenzind/monaco-nerd-fonts)

## Linux

以下以 Ubuntu 24.04 的配置为例。

### 1. 换源

将默认的 Ubuntu 源更换清华源。

### 2. root 免密登录

如果是自己的虚拟机或者是 WSL，系统中没有很重要的东西，可以配置 sudo 免密操作，这样比较方便，不用每次 sudo 都输入密码了。

这个操作需要编辑 `/etc/sudoers` 文件，执行脚本为 `modify_sudoers.sh`

### 3. SSH 及 秘钥登录

一些系统中只有 `SSH 客户端`而没有 `SSH 服务器`，因此要手动安装并配置 SSH Server。

先安装 ssh-server 包：

```shell
sudo apt install openssh-server
```

可以编辑 sshd_config 文件，修改开放的端口号和一些权限设置（允许 root 密码认证登录，）

秘钥登录方式：A（SSH Client） 连接 B（SSH Server），A 需要将公钥（.pub）文件发送给 B。

如果要连接我们安装的 Ubuntu（SSH Server），要在宿主机上生成公钥。

```shell
ssh-keygen
```

参数说明：

- t：不加参数就是默认使用 ed25519 算法（比 RSA 更安全高效）

- C：添加注释（通常用邮箱标识密钥）

- f：指定密钥文件名（默认为 id_ed25519）

然后将公钥复制到服务器的 `~/.ssh/authorized_keys` 文件中

```shell
# 方法1：使用 ssh-copy-id（最简单）
ssh-copy-id -i ~/.ssh/my_server_key.pub username@server_ip -p 22

# 方法2：手动复制（当 ssh-copy-id 不可用时）
cat ~/.ssh/my_server_key.pub | ssh username@server_ip "mkdir -p ~/.ssh && chmod 700 ~/.ssh && cat >> ~/.ssh/authorized_keys && chmod 600 ~/.ssh/authorized_keys"
```

最后再重启 sshd 服务：

```shell
sudo service sshd restart
```

### 3. 常用包的安装

- net-tools：查看和配置网络
    >当然现在高版本的 Ubuntu 默认使用 iproute2 工具，通过 ip 命令实现所有功能（例如 `ip addr show` 替代 `ifconfig` 命令）

- curl：用于从服务器传输数据或向服务器传输数据的工具（支持多种协议）

- wget：非交互式的网络文件下载工具

- vim：文本编辑器

- openssh-server：ssh 服务器

- htop：交互式的进程查看器，比 top 更强大

- tree：以树状图列出目录的内容

- git：版本控制

- tmux：终端复用器，允许在单个终端窗口中运行多个终端会话

- rsync​：高效文件同步工具

- ufw​：简易防火墙配置工具

- 

### 4. oh-my-zsh 安装与配置

参考[zsh和oh-my-zsh安装方法](https://blog.csdn.net/qimowei/article/details/119517167)进行安装，文章讲的是在 Centos 7 下，但其实这个安装方法和系统没太大关系，Debian 系（Debian、Ubuntu 等）将 `yum` 换成 `dnf`，Red Hat 8 之前（Centos，Fedora）改成 `yum` 就行。

>不推荐使用 Centos 7 及更老的 Linux，Centos 系列官方已经停止维护，相关的源基本已经关闭，内置软件较老且基本没有办法通过网络更新，推荐使用 Centos Stream 系列。

一键安装脚本见文件夹中的 `install_zsh.sh`。
