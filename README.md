# EasyNewOS

对新系统（Win、macOS、Linux）进行配置，包含通用软件、脚本和配置文件。

[toc]

## Win

### 1. VSCode(Win、macOS、Linux 通用)

VSCode 配置编译运行 C 和 CPP 的运行任务，主要包括 `tasks.json`、`launch.json` 两个文件

配置 **运行生成任务** 的快捷键（`F6`）

配置 **删除行** 的快捷键（`CTRL + D`）

### 2. VSCode 插件

不过 VSCode 可以通过云同步将配置和插件一键同步到新设备。

- [Chinese Language Pack](https://marketplace.visualstudio.com/items?itemName=MS-CEINTL.vscode-language-pack-zh-hans)

- [Remote SSH](https://marketplace.visualstudio.com/items?itemName=ms-vscode-remote.remote-ssh)

- [C/C++](https://marketplace.visualstudio.com/items?itemName=ms-vscode.cpptools)

- [CodeLLDB](https://marketplace.visualstudio.com/items?itemName=vadimcn.vscode-lldb)

- [VSCode Great Icons](https://marketplace.visualstudio.com/items?itemName=emmanuelbeziat.vscode-great-icons)

- [filesize](https://marketplace.visualstudio.com/items?itemName=mkxml.vscode-filesize)

- [Reload](https://marketplace.visualstudio.com/items?itemName=natqe.reload)

### 3. GCC

[GCC Install](https://www.gnu.org/software/gcc/)

推荐使用 [MSY2S](https://www.msys2.org/)，可以安装最新版本的 GCC，同时可以安装最新版本的 gdb。不推荐使用 MinGW 来安装 GCC，MinGW 是编译生成 32 位的程序，同时 gdb 版本也只有 7.6.1，低版本的 gdb 在 vscode 中进行调试时很难直观看到容器中的具体值，添加 watch 很多也都不支持，新版本 gdb 则没有这个问题。可以使用 MinGW-w64.

### 4. WSL

首选推荐使用 [WSL2](https://learn.microsoft.com/zh-cn/windows/wsl/install)，通过[这篇文章](https://www.cnblogs.com/charescape/p/18867702)可以将 WSL2 的虚拟硬盘从默认的 C 盘迁移到任意地方。

在安装 WSL2 之前首先要将 **适用于 Linux 的 Windows 子系统** 的功能打开，详见[这篇文章](https://zhuanlan.zhihu.com/p/675310334)。

[Windows11 安装 WSL2 详细过程](https://www.cnblogs.com/xiao987334176/p/18864140#autoid-1-1-0)
