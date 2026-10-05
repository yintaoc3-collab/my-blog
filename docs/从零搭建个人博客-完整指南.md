# 从零搭建个人博客：Windows + VS Code 完整操作指南

整理日期：2026 年 10 月 5 日（2026 年 10 月 5 日按新版配置更新）。适用目标：展示嵌入式作品、发布开源方案、写技术笔记、分享工具和资源。

本教程统一采用 **Hugo + PaperMod + GitHub Pages**。在 Windows 电脑上用 VS Code 编辑，通过 VS Code 的 Git 界面提交、上传，由 GitHub 自动生成并发布网页。

你已有 GitHub 账号，电脑上也已有 VS Code 和 Git。本教程仍写出环境检查方法，方便你以后换电脑时重新操作。

你的博客源码放在 `D:\本地博客`，教程放在 `D:\本地博客\docs`。这个目录也是从原基础包复制来的保留副本：`C:\Users\42891\Documents\Codex\2026-10-05\n-n\outputs\my-blog`（未改动，作为最初版本保存）。

博客已按你的账号配置好站名、作者和网址，站名是“一只无辜的银”。原来附带的四篇 `example-*` 示例文章**已经删除**（删除前的文件保留在 `.backups\removed-examples-20261005.zip`），四个栏目现在都是空的，只保留各自的 `_index.md`。**目前只是本地文件，尚未创建你的 GitHub 仓库，也未公开发布。**

先完成本地阶段，确认内容和样式，再完成上线阶段。每完成一步，都看一下本步的“检查结果”，符合之后再继续。

本次交付依然是三个文件：本教程的 `.md` 原文、可双击用浏览器阅读的 `.html` 离线版，以及新版 `个人博客完整教程与基础包-已配置-yintaoc3-collab.zip`。ZIP 中包含 `my-blog/`（已配置好的博客源码）、`docs/`（两种教程、教程渲染脚本与新打包脚本，可随时重新生成）以及便携 Hugo。先全部解压，再打开博客目录；若你直接使用 `D:\本地博客` 这份现成文件夹，就无需再次解压。

**怎样阅读：** 第 0～15 步完成本地修改与验证，第 16～22 步完成 GitHub 上线，第 23～28 步用于日常更新与长期维护。附录是遇到特殊情况时使用的补充说明。命令只复制代码框内的内容，不要把解释文字或终端中的 `PS C:\...>` 提示符也复制进去。每条命令运行完再输入下一条；占位文字必须先换成自己的信息。

## 0. 先理解整个流程

```text
你在 VS Code 写 Markdown 文章和放图片
                ↓
Hugo 在本地生成网页，浏览器预览
                ↓
Git 给本次修改留下记录：Commit
                ↓
把记录上传到 GitHub：Push
                ↓
GitHub Actions 自动运行 Hugo
                ↓
GitHub Pages 对外提供网站
                ↓
别人访问 https://你的用户名.github.io/
```

| 名称 | 你可以怎样理解 | 本教程中的作用 |
| --- | --- | --- |
| VS Code | 编辑文件的工具 | 写文章、修改配置、使用 Git 界面 |
| Markdown | 用普通文字加少量符号表示排版 | 写标题、正文、图片、链接、代码 |
| Hugo | 把文字和主题生成网页的工具 | 本地预览、正式构建 |
| PaperMod | 博客外观与页面功能的主题 | 提供文章页、菜单、目录、搜索等 |
| Git | 给文件变化保存历史的工具 | 留下可检查的修改记录 |
| GitHub | 存放 Git 仓库的平台 | 保存源码、执行自动部署 |
| GitHub Actions | 服务器上的自动执行流程 | 自动构建网页并发布 |
| GitHub Pages | 提供静态网页访问的服务 | 让别人通过网址访问博客 |

**保存、提交、上传、上线是四件不同的事。** 按 `Ctrl+S` 只是保存电脑上的文件；Commit 是保存本地历史；Push 才把历史上传；Actions 成功后网站才更新。

## 1. 费用、稳定性与这套方案的边界

**目的：** 搭建之前先弄清楚免费包括什么，以及长期使用应保留什么。

**做法：**

1. 使用 GitHub Free 账号。
2. 将博客源码仓库设为 Public，也就是公开仓库。
3. 使用 GitHub 提供的 `你的用户名.github.io` 网址。
4. 本地保留源码，再额外保留一份备份。
5. 固定 Hugo 和主题版本，更新前先测试。

按目前官方政策，GitHub Pages 可在 GitHub Free 的公开仓库中使用；发布后的网站最大 1 GB，月流量软限制为 100 GB。免费平台政策可能改变，也不能保证一直无故障。因此，这里的“长期使用”依靠少依赖、保留源码与方便迁移，而不是承诺永久免费或永不宕机。

这套方案适合静态博客、作品说明和开源文档。第一版采用文件更新；登录后台、数据库、用户注册和在线交易等功能需要另行设计。

独立域名是后续可选项，需要购买并续费。使用默认网址就能先完成免费上线。

**检查结果：** 你接受源码公开，第一版使用默认网址和文件更新。

参考：[GitHub Pages 条件与限制](https://docs.github.com/en/pages/getting-started-with-github-pages/github-pages-limits)、[GitHub Pages 网址说明](https://docs.github.com/en/pages/getting-started-with-github-pages/what-is-github-pages)。

### 1.1 从 GitHub 能找到哪些建站工具

“建站工具”和“托管平台”是两回事：前者把内容生成网页，后者让网页被别人访问。下面的工具都可以生成静态站点，再搭配静态托管服务。

| 工具与项目链接 | 本地使用方式 | 对你的适用情况 |
| --- | --- | --- |
| [Hugo](https://github.com/gohugoio/hugo) + [PaperMod](https://github.com/adityatelange/hugo-PaperMod) | Hugo 可执行文件、Markdown、主题配置 | 本教程采用；在这个基础版本中无需安装 Node.js、npm 或 Ruby，方便保留工具与源码 |
| [Astro](https://github.com/withastro/astro) | JavaScript/TypeScript 项目，安装项目依赖并构建 | 适合希望进一步定制作品页面、交互和布局的人；以后可按需求评估 |
| [Hexo](https://github.com/hexojs/hexo) | Node.js 博客框架，Markdown 文章与主题 | 可用于传统博客；需要维护 Node.js 与相关项目依赖 |
| [Jekyll](https://github.com/jekyll/jekyll) | Ruby 静态博客工具，Markdown 与模板 | 也是可用方案；在 Windows 本地准备 Ruby 环境是额外步骤 |

这里选 Hugo 是结合你希望长期保留内容、在电脑上编辑、减少环境配置的判断，不意味着其他工具不能长期使用。固定版本、备份和能恢复的源码，比某个主题当前是否流行更有帮助。

### 1.2 免费托管方式怎样选

| 托管方式 | 免费使用条件与限制 | 这份教程的安排 |
| --- | --- | --- |
| [GitHub Pages](https://docs.github.com/en/pages/getting-started-with-github-pages/github-pages-limits) | GitHub Free 的公开仓库可用；发布网站最大 1 GB，月流量软限制 100 GB | 主方案；源码、修改历史与自动部署集中在你已有的 GitHub 账号 |
| [Cloudflare Pages](https://developers.cloudflare.com/pages/platform/limits/) | 当前 Free 计划每月 500 次构建，最多 20,000 个文件，单个文件最大 25 MiB | 可作为将来迁移的另一种选择；需要另有 Cloudflare 账号并配置项目 |
| 仅本机 Hugo 预览 | 不产生托管费用；只能用于本地编辑与查看 | 第 0～15 步就能完成，但尚未得到公开网站 |

Cloudflare 的 [Hugo 官方部署说明](https://developers.cloudflare.com/pages/framework-guides/deploy-a-hugo-site/) 可在迁移时使用。本教程先完整走通 GitHub Pages，避免第一次搭建时同时操作多个平台。上述免费限制按整理日期核对，实际使用时仍以官网为准。

## 2. 记下你的 GitHub 用户名

**目的：** 正确设置网站网址和仓库名称。

**做法：**

1. 打开 [GitHub](https://github.com/)，登录自己的账号。
2. 点击头像，进入个人主页 `Your profile`。
3. 查看浏览器地址。例如主页是 `https://github.com/zhangsan`，用户名就是 `zhangsan`。用户名只允许英文字母、数字和连字符。
4. 记下用户名。它与个人主页上可以填写中文的显示名称不一定相同。

教程示例统一使用 `zhangsan` 这个名字，仅用于演示；你自己的用户名在设置时替换即可：

| 项目 | 应填写的值 |
| --- | --- |
| 用户名 | `yintaoc3-collab` |
| 仓库名 | `yintaoc3-collab.github.io` |
| 网站地址 | `https://yintaoc3-collab.github.io/` |

本教程已按用户名 `yintaoc3-collab` 配置完成：仓库名 `yintaoc3-collab.github.io`，网站地址 `https://yintaoc3-collab.github.io/`。上面的对照表用于说明用户名与仓库名的关系。

如果 `你的用户名.github.io` 仓库已存在，先查看里面是什么，不要新建同名仓库或覆盖原网站。可在另一份本地副本中准备新博客，再评估怎样接入已有仓库。

**检查结果：** 你知道自己的公开主页网址、用户名和计划使用的仓库名。

## 3. 找到博客文件夹

**目的：** 后面的操作始终针对同一份博客源码，避免在不同文件夹里修改不同副本。

**做法：**

1. 打开 Windows 文件资源管理器。
2. 在地址栏粘贴：

```text
C:\Users\42891\Documents\Codex\2026-10-05\n-n\outputs\my-blog
```

3. 按回车。
4. 确认里面有 `hugo.yaml`、`content`、`themes`、`scripts`、`start-blog.cmd`。
5. 如果你拿到的是 ZIP，先右键“全部解压”，再进入解压后的 `my-blog` 文件夹。不要在压缩包预览里直接编辑或运行。

可以把整个 `my-blog` 文件夹复制到自己习惯的位置。移动后，下文给出的完整路径需要换成你实际的位置；目录内的相对结构保持不变。

**检查结果：** 你在真实文件夹中看见 `hugo.yaml`，而不是只看见外层 ZIP。

## 4. 用 VS Code 打开整个博客文件夹

**目的：** 让 VS Code 同时识别文章、配置、终端与 Git 仓库。

**做法：**

1. 启动 VS Code。
2. 选择“文件 → 打开文件夹”，英文界面是 `File → Open Folder`。
3. 选择上一步的 `my-blog` 文件夹。
4. 左侧资源管理器应列出全部博客文件。
5. 如果出现工作区信任提示，确认你正在打开本教程附带的博客目录，再按自己的判断选择信任。

不要只双击一个 `index.md` 后就开始后面的 Git 操作。需要打开文件夹，才能把博客作为一个完整项目管理。

**检查结果：** VS Code 左侧同时有 `hugo.yaml`、`content`、`themes` 和 `scripts`。

需要重新安装时：[VS Code 下载](https://code.visualstudio.com/Download)、[Windows 安装说明](https://code.visualstudio.com/docs/setup/windows)。

## 5. 打开终端，检查 Git 与当前目录

**目的：** 确认工具可用，也确认命令不会作用到其他工程。

**做法：**

1. 在 VS Code 选择“终端 → 新建终端”，英文是 `Terminal → New Terminal`。
2. 在底部的终端中，一条一条输入下面的命令；每条输入后按回车：

```powershell
Get-Location
```

```powershell
Test-Path .\hugo.yaml
```

```powershell
git --version
```

3. 第一条显示当前目录；应是你的 `my-blog` 目录。
4. 第二条应显示 `True`，说明当前目录有博客配置文件。
5. 第三条应显示 Git 版本。

你这台电脑已检查到 Git `2.54.0.windows.1`。VS Code 提供 Git 的界面，实际仍调用已安装的 Git 程序；基本上传功能不需要另装 GitHub 扩展。

如果目录不对，执行：

```powershell
Set-Location -LiteralPath 'C:\Users\42891\Documents\Codex\2026-10-05\n-n\outputs\my-blog'
```

**检查结果：** `Test-Path` 返回 `True`，`git --version` 返回版本号。

参考：[VS Code 的 Git 与 GitHub 支持](https://code.visualstudio.com/docs/sourcecontrol/github)、[Git for Windows](https://git-scm.com/downloads/win)。

## 6. 检查 Hugo，不需要全局安装

**目的：** 让本地与 GitHub 使用相同的构建工具版本。

本教程附带的博客已放入 Hugo `0.167.0`，位置是 `.tools/hugo/hugo.exe`。Hugo 没有加入系统 PATH，所以直接输入 `hugo` 可能无法识别，这是正常的；本教程使用明确的相对路径。

**做法：**

在博客目录的终端执行：

```powershell
.\.tools\hugo\hugo.exe version
```

应出现以 `hugo v0.167.0` 开头的版本信息。

如果 `.tools` 不存在，例如你以后从 GitHub 重新克隆了源码，双击 `start-blog.cmd` 即可由附带脚本下载固定版本并校验文件。首次下载需要网络。

手动恢复的做法：

1. 打开 [Hugo 0.167.0 官方发布页](https://github.com/gohugoio/hugo/releases/tag/v0.167.0)。
2. 下载 `hugo_0.167.0_windows-amd64.zip`。这对应本教程已经检查过的 Windows x64 电脑。
3. 解压到博客目录中的 `.tools/hugo/`，使该目录下直接有 `hugo.exe`。
4. 再执行上面的版本命令。

归档的 SHA-256 校验值记录在博客的 `VERSIONS.md` 中。若要核对下载的 ZIP，可执行：

```powershell
Get-FileHash -Algorithm SHA256 -LiteralPath '你下载的Hugo压缩包完整路径'
```

替换路径后再执行；只比较对应 ZIP 的校验值，不能拿 ZIP 的校验值去比较解压后的 EXE。

**检查结果：** 显示 Hugo `0.167.0`。

参考：[Hugo Windows 安装说明](https://gohugo.io/installation/windows/)。

## 7. 第一次启动本地博客

**目的：** 先在自己电脑上确认博客能运行。

**做法：**

1. 如果此前预览窗口还在运行，直接使用那个预览，不要再启动第二份。
2. 在文件资源管理器中双击 `start-blog.cmd`。
3. 或在 VS Code 的博客终端执行：

```powershell
.\start-blog.cmd
```

4. 等窗口显示 `Web Server is available`。
5. 在浏览器打开 [本地预览](http://127.0.0.1:1313/)。
6. 保持运行窗口打开。需要停止时，在该窗口按 `Ctrl+C`。

`127.0.0.1` 代表这台电脑本身。这个预览只绑定本机，其他人不能拿这个地址访问你的博客；公开地址要在后面的上线步骤获得。

运行时你可以保存文章，浏览器通常会自动刷新。若未刷新，手动按一下浏览器刷新按钮。

**检查结果：** 浏览器显示“一只无辜的银”首页，能进入各栏目。

## 8. 认识文件结构，只改需要的文件

**目的：** 以后能准确找到站名、文章、图片和部署配置。

```text
my-blog/
├─ hugo.yaml                       网站基本配置
├─ content/
│  ├─ projects/                    嵌入式作品
│  ├─ opensource/                  开源方案
│  ├─ notes/                       技术笔记
│  ├─ goodies/                     好物分享
│  ├─ about.md                     关于我
│  └─ search.md                    搜索页面
├─ themes/PaperMod/                已保留在本地的主题
├─ layouts/                       本站模板覆盖
├─ assets/css/extended/            本站附加样式
├─ static/                        网站公共资源
├─ scripts/                       启动、构建和备份脚本
├─ .github/workflows/hugo.yaml      GitHub 自动部署配置
├─ .tools/hugo/                    本机的 Hugo 工具
├─ public/                        自动生成的网页
├─ start-blog.cmd                  启动本地预览
├─ build-blog.cmd                  检查正式构建
└─ backup-blog.cmd                 备份源码
```

日常主要修改 `content/` 和 `hugo.yaml`。`public/` 是生成结果，下次构建会重新生成；直接改里面的 HTML，修改不会可靠地保留下来。

主题已经放在项目里，首次构建不必联网拉取 PaperMod。原作者许可证保留在 `themes/PaperMod/LICENSE`。

**检查结果：** 你知道正文放在哪里，也知道不要把生成目录当正文目录。

## 9. 修改站名、作者与网站网址

**目的：** 把通用基础版本改成自己的博客。

**做法：**

1. 在 VS Code 左侧点击 `hugo.yaml`。
2. 修改以下对应值，保留字段名称：

```yaml
baseURL: "https://yintaoc3-collab.github.io/"
title: "一只无辜的银"
```

3. 确认 `baseURL` 中的用户名是你的真实 GitHub 用户名。
4. 在 `params:` 下找到作者、简介和标识文本。例如：

```yaml
params:
  author: "一只无辜的银"
  description: "记录嵌入式作品、分享开源方案、整理技术笔记与实用资源。"
  label:
    text: "一只无辜的银"
```

5. 修改现有位置的值；不要把上面片段整段追加到文件末尾，也不要重复创建第二个 `params:`。
6. 需要改首页介绍时，修改现有 `homeInfoParams` 的 `Title` 和 `Content`。
7. 按 `Ctrl+S` 保存，查看本地预览。

YAML 用缩进表示所属关系。用空格保留原来的对齐，不要随意把子项挪到行首。文字使用普通英文双引号 `"`，不要把它替换成中文弯引号。

**检查结果：** 首页显示自己的站名和介绍；配置中的站名、作者与网址都是你自己的信息。

## 10. 修改“关于我”

**目的：** 让访问者知道你做什么，以及在哪里找到你的项目。

**做法：**

1. 打开 `content/about.md`。
2. 保留文件最前面的两条 `---` 与中间的配置。
3. 在第二条 `---` 后面修改正文。
4. 可以填写技术方向、常用平台、博客用途和公开 GitHub 主页。
5. 插入主页链接的写法：

```markdown
[我的 GitHub](https://github.com/yintaoc3-collab)
```

6. 确认链接指向自己的公开主页后保存。

无需在博客源码里放账号密码或访问令牌。公开仓库里的源码，包括草稿文件，都会被别人看见；公开联系方式应由你自己选择。

**检查结果：** 菜单中的“关于我”显示真实介绍，链接能打开你的公开主页。

## 11. 创建第一篇自己的作品介绍

**目的：** 学会创建文章，并把文章与图片放在一起。

**做法：**

1. 在 VS Code 左侧找到 `content/projects/`。
2. 在里面新建文件夹，例如 `my-first-project`。
3. 在这个文件夹中创建文件 `index.md`。
4. 复制下面的结构，替换成真实内容：

````markdown
---
title: "我的第一个嵌入式作品"
date: 2026-10-05T10:00:00+08:00
draft: true
description: "用一两句话介绍作品用途。"
summary: "这段文字会出现在文章列表中。"
tags: ["STM32", "项目记录"]
categories: ["嵌入式作品"]
---

## 作品解决什么问题

介绍使用场景、主要功能与设计目标。

## 实物与演示

放自己的图片或视频链接。

## 硬件组成

写明主控、模块、接口和供电方式。

## 软件结构

说明工具链、主要模块和关键逻辑。

```c
int main(void)
{
    board_init();
    for (;;) {
        app_update();
    }
}
```

## 复现步骤

1. 准备硬件。
2. 连接模块。
3. 下载工程。
4. 编译和烧录。
5. 检查运行效果。

## 源码与附件

[源码仓库](https://github.com/yintaoc3-collab/YOUR_REPOSITORY)

> 这里的 `YOUR_REPOSITORY` 是你将来实际发布项目的仓库名，不是博客仓库。
````

其中芯片标签只是例子，不符合你的实际项目时要修改。日期改成你实际写作或发布的日期；不要使用未来日期，Hugo 默认不会在正式构建中发布未来文章。

`index.md` 与项目图片在同一文件夹中，这种组织方式叫页面包，方便整体移动和备份。

**检查结果：** `content/projects/my-first-project/index.md` 存在，本地预览能看到该草稿。

参考：[Hugo 页面包](https://gohugo.io/content-management/page-bundles/)、[文章头部字段](https://gohugo.io/content-management/front-matter/)。

## 12. 搞清楚文章头部字段与草稿

**目的：** 控制文章标题、列表摘要、分类和正式发布状态。

| 字段 | 用途 | 你怎样填写 |
| --- | --- | --- |
| `title` | 页面标题 | 写真实文章名称 |
| `date` | 发布时间、排序依据 | 使用实际日期时间，`+08:00` 表示北京时间 |
| `draft` | 是否是草稿 | 未写完用 `true`，准备上线用 `false` |
| `description` | 页面简介 | 简短说明内容 |
| `summary` | 列表中的摘要 | 两三句话介绍文章 |
| `tags` | 关键词 | 例如 STM32、ESP32、OLED、调试 |
| `categories` | 内容分类 | 例如嵌入式作品、开源方案 |

本地启动器使用 `--buildDrafts`，因此草稿也能预览；正式构建和 GitHub 自动部署不会使用该参数，`draft: true` 的文章不会生成网页。

**草稿不生成网页，不等于草稿源码保密。** 如果你把草稿文件提交到公开 GitHub 仓库，别人仍能阅读那个文件。真正不准备公开的内容应保留在仓库外。

**做法：** 先用 `draft: true` 写作，确认内容后改为 `draft: false`，再保存、构建、提交、上传。

**检查结果：** 你清楚本地能看见草稿，而正式网页是否包含文章由草稿状态决定。

## 13. 添加图片、链接和代码

**目的：** 让嵌入式项目页面有实物效果和可复现信息。

### 13.1 添加实物图片

1. 把自己的照片复制到文章同一个目录。
2. 文件名建议采用英文小写，例如 `board-front.jpg`。
3. 在正文中写：

```markdown
![开发板正面实物](board-front.jpg)
```

4. 保存，在浏览器检查图片。

`![...]` 里面是图片描述，括号内是相对路径。不要写成 `C:\Users\...` 这样的本机路径，因为别人访问网站时没有你电脑上的那个文件。

### 13.2 给文章加封面

在文章头部添加以下字段，缩进保持两格：

```yaml
cover:
  image: "board-front.jpg"
  alt: "开发板正面实物"
  caption: "我的项目照片"
```

### 13.3 添加源码或演示视频链接

```markdown
[查看源码](https://github.com/yintaoc3-collab/YOUR_REPOSITORY)

[观看演示视频](这里换成实际视频页面网址)
```

### 13.4 添加代码

用三条反引号围住代码；第一行可以写语言名称，例如 `c`、`cpp`、`python`。

大视频和大型工程下载包建议放到视频平台或项目发布页，再在博客放链接。博客主要保留文字和经过整理的图片，方便控制体积。

**检查结果：** 图片正常显示，链接指向真实网址，代码块格式正常。

## 14. 添加其他栏目（示例文章已删除）

**目的：** 正确归类内容，同时确认示例模板不会当作真实作品公开。

**做法：**

1. 嵌入式作品放 `content/projects/`。
2. 开源方案放 `content/opensource/`。
3. 技术笔记放 `content/notes/`。
4. 工具、资源和好物放 `content/goodies/`。
5. 每篇仍采用“一个英文文件夹 + 一个 `index.md` + 本文图片”的结构。
6. 确认目录里已经没有 `example-*` 文件夹。

原来附带的四篇示例已经删除，删除前的原文保留在 `.backups\removed-examples-20261005.zip`，需要参考写法时可以打开查看。如果**你的目录里还看得到 `example-*`**，说明你用的是旧版本基础包，请对照上面的包名换用新版，或把那几篇删掉。

四个栏目现在没有文章是正常的：栏目页仍会显示，只是列表为空。写进第一篇真实文章后，栏目内容就会自动出现。

开源方案建议额外写明：支持的平台、依赖版本、安装步骤、已验证环境、源码链接和许可证。将仓库设为公开，只表示可以访问；你希望别人怎样使用代码，需要通过许可证表达。

**检查结果：** 每篇进入正确栏目；计划正式发布的内容真实、完整。

## 15. 检查正式构建

**目的：** 在上传前发现配置和文章格式问题。

**做法：**

1. 保存所有文件：`Ctrl+K` 后按 `S`，或用菜单“文件 → 全部保存”。
2. 打开博客目录里的 `build-blog.cmd`，或在 VS Code 新终端执行：

```powershell
.\build-blog.cmd
```

3. 等待显示 `Build succeeded`。
4. 检查是否有红色 `ERROR`；如果有，先修复报错。
5. `public/` 内会生成 HTML、样式文件和其他网页资源。

**删除或改名文章之后**，正式构建要额外清掉旧输出，否则 `public/` 里会残留已经删掉的文章网页：

```powershell
.\.tools\hugo\hugo.exe --gc --minify --cleanDestinationDir
```

`--cleanDestinationDir` 只清理生成目录，务必让它只作用在 `public/`（或专门的输出目录）上，不要指向博客根目录或 `docs`。

如果你想查看与正式发布一致、排除草稿的本地版本，先停止当前预览，再在终端执行：

```powershell
.\.tools\hugo\hugo.exe server --bind 127.0.0.1 --port 1313 --baseURL http://127.0.0.1:1313/
```

它没有 `--buildDrafts`，只显示正式文章。检查完后 `Ctrl+C` 停止，继续写作时可再用 `start-blog.cmd`。

**检查结果：** 构建成功，标题、菜单、文章、图片和链接都符合预期。

## 16. 初始化博客自己的 Git 仓库

**目的：** 让博客具备修改历史，并让 VS Code 把它识别成独立项目。

**做法：**

1. 在 VS Code 的新终端中确认仍处于博客目录：

```powershell
Test-Path .\hugo.yaml
```

2. 确认结果是 `True`。
3. 首次初始化时执行：

```powershell
git init -b main
```

4. 查看结果：

```powershell
git status
```

`git init` 建立本地历史目录，`-b main` 指定初始分支名是 `main`。附带自动部署只监听 `main`。

如果你以前已经在这个博客目录完成初始化，不必重复初始化。用 `git status` 查看实际分支即可；若当前博客分支叫 `master`，并且没有已有 `main` 分支或其他分支协作安排，可用 `git branch -m main` 改名。

**检查结果：** `git status` 显示在 `main` 分支；此时还没有上传任何东西。

## 17. 设置本仓库的提交署名

**目的：** 给你的提交标明作者，避免第一次提交时报“无法识别作者”。

**做法：**

1. 打开 [GitHub 邮箱设置](https://github.com/settings/emails)。
2. 如果希望隐藏私人邮箱，按 GitHub 设置中的提示找到该账号对应的 `noreply` 提交邮箱。
3. 回到 VS Code 博客终端，替换引号内的占位文字再执行：

```powershell
git config --local user.name "一只无辜的银"
```

```powershell
git config --local user.email "从GitHub邮箱设置复制的提交邮箱"
```

4. 查看结果：

```powershell
git config --local --get user.name
```

```powershell
git config --local --get user.email
```

这里用 `--local`，仅设置当前博客仓库，不更改其他工程的 Git 署名。姓名和邮箱用于提交记录，与 GitHub 登录密码无关。

**检查结果：** 显示你选择的提交署名和邮箱，不是教程里的占位文字。

参考：[设置提交邮箱](https://docs.github.com/en/account-and-profile/how-tos/email-preferences/setting-your-commit-email-address)。

## 18. 在 VS Code 查看、暂存与提交

**目的：** 为博客第一版建立一个可检查的本地版本。

**做法：**

1. 按 `Ctrl+Shift+G`，打开“源代码管理 / Source Control”。
2. 点击变化列表里的文件，查看它的内容。
3. 确认需要提交 `content/`、`hugo.yaml`、`themes/`、`layouts/`、`assets/`、`static/`、`scripts/` 和 `.github/` 等源码。
4. `.gitignore` 已排除 `public/`、`.tools/`、`.backups/` 等生成或本机文件；它们不应出现在待提交列表中。
5. 点击“更改 / Changes”旁边的 `+`，暂存所有准备好的源码；也可逐个点击文件旁边的 `+`。
6. 在提交消息框中输入 `初始化个人博客`。
7. 点击“提交 / Commit”。

暂存是选择本次要保存的内容，提交是把它存进本地历史。看到变化列表为空，不意味着网站已经上线，只表示当前修改已保存成提交。

**检查结果：** 能在源代码管理图或历史中看到这条提交，待提交列表清空。

参考：[VS Code 源代码管理入门](https://code.visualstudio.com/docs/sourcecontrol/quickstart)。

## 19. 从 VS Code 发布源码仓库到 GitHub

**目的：** 把博客源码存到自己的 GitHub 账号中。

**前提：** 第 2 步检查过 `你的用户名.github.io` 仓库还不存在。若已存在，要接入已有仓库，先用附录说明处理。

**做法：**

1. 按 `Ctrl+Shift+P`，打开 VS Code 命令面板。
2. 输入 `Publish to GitHub`，选择匹配的命令。
3. 如果要求登录，按 VS Code 的浏览器登录提示进入自己的 GitHub 账号，然后返回编辑器。
4. 仓库名称填写 `yintaoc3-collab.github.io`（格式为 `你的用户名.github.io`）。
5. 选择发布为 **Public / 公开仓库**。
6. 按界面提示完成上传。
7. 打开自己的仓库网页，检查源码是否出现。

为了使用 GitHub Free 的 Pages，本教程选择公开仓库。这里公开的是源码；之后还需要配置 Pages 才能得到网站。VS Code 基本 GitHub 登录和 Git 操作是内置的，不需要为这一流程安装 Pull Requests 扩展。

**检查结果：** GitHub 上出现你自己的公开仓库，里面能看到 `hugo.yaml`、`content/` 和 `.github/workflows/hugo.yaml`。

参考：[VS Code 使用 GitHub](https://code.visualstudio.com/docs/sourcecontrol/github)。

## 20. 配置 GitHub Pages 的发布来源

**目的：** 告诉 GitHub，网站由我们的自动构建流程发布。

**做法：**

1. 在浏览器打开博客的 GitHub 仓库。
2. 点击仓库的 `Settings`，不是账号头像里的全局设置。
3. 在左边菜单找到 `Pages`。
4. 在 `Build and deployment` 区域找到 `Source`。
5. 选择 `GitHub Actions`。

本教程附带 `.github/workflows/hugo.yaml`，里面已写好：读取源码 → 下载并校验 Hugo → 构建网站 → 上传生成网页 → 发布到 Pages。

不用另建 `gh-pages` 分支，也不用把 `public/` 手动拖到 GitHub。我们只提交源码，生成网页由 Actions 处理。

**检查结果：** Pages 的 Source 显示 `GitHub Actions`。

参考：[Hugo 官方 GitHub Pages 教程](https://gohugo.io/host-and-deploy/host-on-github-pages/)。

## 21. 运行首次部署并查看结果

**目的：** 得到公开可访问的网址，确认自动部署真的完成。

**做法：**

1. 在仓库顶部点击 `Actions`。
2. 左侧选择 `Build and deploy blog`。
3. 第一次上传时可能已经自动触发运行；若当时 Pages 尚未配置，可能会失败。
4. 配好第 20 步后，点击 `Run workflow`，选择 `main`，再确认运行；或对失败运行选择重新运行。
5. 点进最新运行，查看 `build` 与 `deploy` 两个任务。
6. 看到两个任务都成功后，回到 `Settings → Pages`，从该页面给出的地址进入网站。

预期地址是 `https://你的用户名.github.io/`。以 GitHub Pages 页面实际显示的地址为准。

这份工作流会用 Pages 给出的真实网址作为构建地址，从而减少用户配置错误造成的链接问题。`hugo.yaml` 中仍应填写正确 `baseURL`，用于本地正式构建和日后迁移。

**检查结果：** 自动部署成功，公开网址显示你准备发布的内容。可用手机或另一个浏览器打开确认。

本地构建成功与 GitHub 在线部署成功是两种验证。准备模板时已验证本地构建；你的在线部署需要上述账号与仓库步骤，不能仅凭本地预览判断已经上线。

## 22. 首次上线后的检查清单

**目的：** 确认网站对访问者可用。

**本地验收**（构建成功后在 `public/` 与本地预览上检查）：

- 正式构建没有红色 `ERROR`。
- 四篇 `example-*` 示例页面已消失。
- 首页站名、作者、网址都是自己的信息，没有旧站名「嵌入式工坊」和 `YOUR_GITHUB_USERNAME`。
- 搜索索引 `index.json` 能搜到现有文章。
- `sitemap.xml` 与 `robots.txt` 里的网址是 `https://yintaoc3-collab.github.io/`。
- 四个空栏目仍保留 `_index.md`，菜单、搜索、首页在暂时没有文章时也正常显示。

**上线验收**（GitHub Actions 跑完之后检查）：

- 首页站名、介绍是否正确。
- 五个栏目能否进入。
- 正式文章是否出现，草稿是否没有生成网页。
- 图片是否显示。
- GitHub 源码链接是否指向你的实际仓库。
- 手机窗口下文字、菜单和代码能否阅读。
- 公开网址使用 `https://`。
- 公开源码中是否仍有你不准备公开的内容。

如果 GitHub Pages 设置提供 `Enforce HTTPS`，确认 HTTPS 已启用；使用 GitHub 提供的默认域名时，按官方服务行为使用 HTTPS。

**检查结果：** 至少从一个独立浏览器成功打开首页与一篇作品页。

参考：[GitHub Pages 的 HTTPS](https://docs.github.com/en/pages/getting-started-with-github-pages/securing-your-github-pages-site-with-https)。

## 23. 以后每次更新文章的固定流程

**目的：** 让写作和发布成为可重复的小流程，而不是每次重新搭建。

1. **打开博客文件夹。** 用 VS Code 打开同一份 `my-blog`。
2. **拉取远端修改。** 如果在其他电脑或 GitHub 网页改过内容，先把本地修改提交，再在源代码管理菜单中执行 Pull。
3. **启动本地预览。** 运行 `start-blog.cmd`。
4. **写文章和放图片。** 在正确栏目中创建项目文件夹和 `index.md`。
5. **保存。** 按 `Ctrl+S` 或全部保存。
6. **检查页面。** 查看标题、正文、图片和代码。
7. **决定发布状态。** 准备公开的文章设置 `draft: false`。
8. **检查正式构建。** 运行 `build-blog.cmd`。
9. **暂存与提交。** 在 VS Code 暂存修改，填写 `新增：某某项目` 或 `更新：某某文章`，点击 Commit。
10. **上传。** 在源代码管理的 `...` 菜单中选择 Push。
11. **确认部署。** 到 GitHub Actions 查看最新运行是否成功。
12. **确认网页。** 重新打开公开网址，检查此次内容。

VS Code 的 `Sync Changes / 同步更改` 通常先拉取、再推送；`Push / 推送` 主要上传已有本地提交。刚开始用本教程时可明确选择 Push，操作目的更容易区分。

**检查结果：** 本地提交、GitHub 源码与已发布网页都能对应这次更新。

## 24. 修改或删除已经发布的文章

**目的：** 保持网站内容准确，知道删除或隐藏网页的影响。

**修改文章：** 打开原文章文件 → 修改 → 保存 → 预览 → 构建 → Commit → Push。

**暂时不显示：** 将文章设置为 `draft: true`，再构建、提交、上传。下一次成功部署后，不再生成该文章网页。但公开源码和 Git 历史仍可能保留文章内容。

**删除文章：** 确认要删除后，在 VS Code 删除对应文章文件夹，再检查源代码管理中的删除列表，提交并上传。旧网址可能失效；如果以前分享过，考虑保留一个说明页或配置跳转。

文章目录名是网址的一部分。随意把 `my-first-project` 改成另一个名字，通常也会改变访问地址；改正文和标题一般不会改变按目录生成的地址。

**检查结果：** 在线页面符合你的修改意图，旧链接的处理方式也明确。

## 25. 备份源码

**目的：** 除了 GitHub，再保留能恢复网站的独立副本。

**做法：**

1. 保存全部文件。
2. 双击 `backup-blog.cmd`，或执行：

```powershell
.\backup-blog.cmd
```

3. 运行结束后，到博客的 `.backups/` 文件夹找到 ZIP。
4. 文件名含时间，方便区分不同备份。
5. 把它复制到另一块磁盘或你自己使用的备份位置。
6. 打开 ZIP，检查里面包含 `hugo.yaml`、`content/`、`themes/`、`layouts/`、`scripts/`、`.github/` 和 `.gitignore`。

附带脚本备份的是源码，包括尚未提交的已保存文件；不包含 `.git` 历史、本地 Hugo 程序和生成的 `public/`。GitHub 上保存已经推送的提交历史。

需要额外完整备份 Git 历史时，可按官方方法进行镜像克隆：

```powershell
git clone --mirror https://github.com/yintaoc3-collab/yintaoc3-collab.github.io.git blog-history-backup.git
```

先把用户名换正确，在专门的备份目录中运行。镜像目录用于保管历史，不作为日常写文章的工作目录；它也不包含尚未提交的文件。

### 25.1 教程与打包能力一起在包里

基础包内除了博客源码，还带着 `docs` 文件夹，换电脑或换解压目录后仍能更新教程、重新打包，不依赖任何外部目录：

| 文件 | 作用 |
| --- | --- |
| `docs\从零搭建个人博客-完整指南.md` | 教程正文的**唯一来源** |
| `docs\从零搭建个人博客-完整指南.html` | 由上面的 Markdown 渲染，供浏览器阅读 |
| `docs\Build-Guide.ps1` | 渲染脚本：按自身位置找到博客目录，配合 `docs\guide-source` 生成 HTML |
| `docs\Package-Blog.ps1` | 打包脚本：来源固定为博客根目录，输出可用 `-OutputPath` 指定 |
| `docs\guide-source\` | 教程用的 Hugo 配置与页面模板（渲染 HTML 必需） |

用法（在 VS Code 终端执行，先进入博客目录）：

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\docs\Build-Guide.ps1
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\docs\Package-Blog.ps1
```

两个脚本都不会覆盖同级已有文件：打包脚本用“只新建”方式写文件，同名包已存在时会直接报错停止。脚本文件必须保存为 UTF-8 带 BOM，否则 Windows PowerShell 5.1 读中文会出错。

**检查结果：** 改完教程 Markdown 后你能自己重新生成 HTML，也能重新打出一个新基础包。

**两种包不要把用途弄混：**

| 包 | 里面有什么 | 不包含什么 | 用途 |
| --- | --- | --- | --- |
| 日常源码备份（`backup-blog.cmd`） | 源码、配置、主题、脚本、`.github/` | Hugo 程序、`.git` 历史、`public/` | 快速恢复平时写作的内容 |
| 交付基础包（新版 ZIP） | 源码 + `.tools/hugo/`（含 `LICENSE`）+ `docs/` 教程与脚本 | `.git` 历史 | 换电脑、重新交付、重建教程与打包 |

“基础包里有 Hugo”这句话的依据是打包脚本的收录规则和实际 ZIP 内容——`my-blog/.tools/hugo/hugo.exe` 与主题的 `LICENSE` 必须在包内。

**恢复测试（建议每次生成备份后做一次）：**

1. 把 ZIP 解压到一个测试目录，不要覆盖正在使用的博客目录。
2. 用包内的 Hugo 构建：`.\.tools\hugo\hugo.exe --gc --minify`。
3. 检查 `public/index.html` 是否生成、站名是否为“一只无辜的银”。
4. 在终端执行 `Test-Path .\docs\从零搭建个人博客-完整指南.md`，确认教程随包带走。

**检查结果：** 至少有一份源码 ZIP 位于另一个位置，能打开看到主要文件；恢复测试能构建成功。

参考：[GitHub 仓库备份说明](https://docs.github.com/en/repositories/archiving-a-github-repository/backing-up-a-repository)。

## 26. 换电脑或恢复博客

**目的：** 让网站不依赖当前电脑一直存在。

**从 GitHub 恢复：**

1. 新电脑安装 VS Code 和 Git。
2. 在 VS Code 命令面板运行 `Git: Clone`。
3. 输入自己博客仓库的 HTTPS 地址。
4. 选择本地保存位置，再打开克隆后的文件夹。
5. 运行 `start-blog.cmd`；它会在缺少 Hugo 时下载固定版本并校验。
6. 检查预览后继续编辑、提交和推送。

**从源码 ZIP 恢复：**

1. 解压到一个新的文件夹，不直接覆盖仍有未保存工作的旧目录。
2. 用 VS Code 打开新文件夹。
3. 运行启动器下载工具并预览。
4. 需要接回 GitHub 历史时，优先克隆远端仓库，再将备份中的源码复制到克隆目录，保留克隆产生的 `.git`。

**检查结果：** 恢复后的目录能构建与预览，账号中的仓库和历史仍可访问。

## 27. 长期维护与将来迁移

**目的：** 避免一次平台变化或升级让博客无法继续使用。

- 定期备份。内容更新较多时就增加备份频率。
- 不把主题当作文章目录修改；日常维护集中在自己的内容与配置。
- 框架、主题与部署 Actions 的固定版本记录在 `VERSIONS.md` 和工作流里。
- 定期检查官方维护与安全更新；升级前先备份，在一份副本中试运行，再更新正式版本。
- 本地 Hugo 与 GitHub 构建版本保持一致。升级 Hugo 时同时更新下载文件名、校验值和工作流配置。
- 如果以后换到其他静态托管平台，可以构建 `public/` 并上传生成网页；同时按新网址调整 `baseURL`。
- 如果以后购买独立域名，可以改绑到新平台，减少公开访问地址随平台迁移而改变的情况；域名要按时续费。

免费托管不需要你自己的电脑一直开机。GitHub Pages 提供的是已经生成的网页；本机预览只用于你编辑与检查。

## 27.1 想显示“最后更新”时怎么做

“根据完整 Git 历史自动取得更新时间”需要三件事**配套**使用，缺一不可：

1. 在 `hugo.yaml` 中把 `enableGitInfo` 设为 `true`；
2. 让构建时能拿到完整 Git 历史——本地仓库有完整历史即可，GitHub 上的 `.github/workflows/hugo.yaml` 需要 `actions/checkout` 带 `with: fetch-depth: 0`（本教程的工作流已经补上这一行）；
3. 在页面模板里显示 `.Lastmod`，例如 `themes/PaperMod/layouts/_partials/post_meta.html`。

页面应当**同时**保留两种时间：继续用 `.Date` 显示**发布时间**，另加 `.Lastmod` 显示**更新时间**。只开启 GitInfo 不会自动出现更新时间，因为当前模板显示的是 `.Date`。

如果不想依赖 Git，也可以在文章头部**手动填写**：

```yaml
lastmod: 2026-10-05T20:00:00+08:00
```

手动填写时不需要开启 GitInfo，也不需要完整历史。

**检查结果：** 你明确知道自动更新时间需要 GitInfo + 完整历史 + 模板三件套，手动填写则不需要。

**检查结果：** 你保有内容、主题、配置和备份，知道它们能在新电脑或新托管平台恢复。

## 28. 常见问题：按现象定位

| 现象 | 常见原因 | 具体检查与处理 |
| --- | --- | --- |
| `git` 无法识别 | Git 未安装或 VS Code 终端没刷新 | 安装官方 Git，关闭并重新打开 VS Code，再执行 `git --version` |
| 直接输入 `hugo` 无法识别 | 本教程没有加入全局 PATH | 用 `.\.tools\hugo\hugo.exe`，或直接运行附带 CMD |
| 本地网页打不开 | 预览未启动或已关闭 | 检查终端是否显示服务器地址，保持运行窗口打开 |
| `address already in use` | 1313 端口已有程序占用 | 若之前博客预览还在，直接使用；否则按下方备用端口方式启动 |
| 新文章本地有，线上没有 | 仍是草稿、未来日期、没 Push 或部署失败 | 检查 `draft`、`date`、GitHub 源码和 Actions 最新运行 |
| 保存后线上没变化 | 保存不是提交或上传 | 按第 23 步完成 Commit、Push 和部署确认 |
| YAML 报错 | 缩进、引号或重复字段有问题 | 查看错误指出的文件与行号，恢复原来对齐并改正 |
| 图片不显示 | 路径、文件名或大小写不同 | 图片放在文章同目录；正文引用与文件名逐字一致 |
| 首页仍显示旧站名 | 名称未替换或没有重新构建 | 检查 `hugo.yaml` 的 `title` 与 `label.text`，保存后重新构建 |
| 第一次 Commit 失败 | 未设置署名或邮箱 | 按第 17 步设置本仓库身份 |
| 发布命令提示仓库已存在 | 账号已有同名仓库 | 不重复创建；用附录接入原仓库的方法 |
| Push 被拒绝 | 远端有本地没有的提交或没有写权限 | 检查账号与仓库；先保留本地工作，再 Pull 处理冲突，不直接强推 |
| Pages 找不到或不能使用 | 仓库权限、可见性或账号计划不同 | 确认自己的个人公开仓库，并检查 Pages 官方条件 |
| Actions 首次失败 | Pages 尚未设置为 Actions | 完成第 20 步，再重新运行工作流 |
| Actions 其他步骤红色 | 下载、构建、权限或部署错误 | 点开失败任务，复制第一条具体错误信息再定位 |
| 网页 404 | 部署未完成、仓库命名或网址不对 | 查看 Pages 页面实际网址和 Actions 结果 |
| 网站有文字但没有样式 | 构建地址或路径配置不一致 | 核对 `baseURL`；本教程优先采用用户名根站点 |

备用端口启动命令，在博客目录执行：

```powershell
powershell.exe -NoProfile -ExecutionPolicy Bypass -File .\scripts\Start-Blog.ps1 -Port 1314
```

然后打开 `http://127.0.0.1:1314/`。不要为了启动第二份预览随意结束其他程序。

附带 CMD 只给当前 PowerShell 进程设置执行策略，不修改系统级策略。若电脑由组织管理且禁止脚本，可直接运行已校验的 Hugo 可执行文件进行预览和构建；不需要更改组织策略：

```powershell
.\.tools\hugo\hugo.exe server --bind 127.0.0.1 --port 1313 --baseURL http://127.0.0.1:1313/ --buildDrafts
```

```powershell
.\.tools\hugo\hugo.exe --gc --minify
```

## 附录 A：如果自己的博客仓库已经存在

此分支仅在第 2 步确认已有同名仓库时使用，不要与“Publish to GitHub 新建仓库”同时做。

1. 先备份原仓库与原网站。
2. 在 VS Code 使用 `Git: Clone`，克隆你自己的已有仓库到一个新目录。
3. 查看原来的文件、分支和部署配置，确认没有必须保留的内容。
4. 将新的博客源码按实际需要整合进去，保留克隆产生的 `.git`，不要把别的仓库的 `.git` 复制过去。
5. 处理原来的配置或同名文件后，再本地预览、构建、提交并 Push。
6. 按实际分支名调整工作流；若仍采用本教程，使用 `main`。

已有仓库的结构不同，接入过程可能需要个别调整。只提供公开仓库网址就足够我查看结构，不需要提供密码。

## 附录 B：如果想自己从空目录搭建

主流程使用已经准备好的基础版本。以下说明从空目录获取 Hugo 与主题的过程，用于理解与以后重建；不要把它再执行到现有博客目录里。

1. 新建一个空目录，例如 `fresh-blog`，在 VS Code 打开它。
2. 按第 6 步获取固定版本 Hugo，放到 `.tools/hugo/`。
3. 在该空目录里执行：

```powershell
.\.tools\hugo\hugo.exe new site .
```

4. 下载 [已固定的 PaperMod 主题 ZIP](https://github.com/adityatelange/hugo-PaperMod/archive/d3768854d00ad003b0a8dbdba254ce9224377a01.zip)。
5. 解压后，把包含 `theme.toml`、`layouts`、`assets` 的那个主题文件夹放到 `themes/PaperMod/`。确认直接存在 `themes/PaperMod/theme.toml`，不要多套一层目录。
6. 从基础包的 `my-blog/` 中复制以下文件与目录到 `fresh-blog/` 同名位置：`hugo.yaml`、`.gitignore`、`.gitattributes`、`VERSIONS.md`、`README.md`、`content/`、`layouts/`、`assets/`、`static/`、`archetypes/`、`scripts/`、`.github/`、`start-blog.cmd`、`build-blog.cmd`、`backup-blog.cmd`。这里使用基础包中已经验证的配置与模板；不是仅安装一个空主题就有完整本站。
7. 如果 `new site` 产生的是 `hugo.toml`，将那个默认文件移动到博客目录外；采用本教程的 `hugo.yaml`，避免同时保留两份配置。检查 `themes/PaperMod/theme.toml` 与 `.github/workflows/hugo.yaml` 均存在。
8. 从第 7～15 步运行预览、替换个人信息、创建真实文章并构建，再从第 16 步建立 Git 历史与部署。

Hugo 工具生成网页；主题提供外观；配置决定栏目与基本信息；文章目录承载你的内容；工作流负责在 GitHub 上重建。这些部分共同组成完整博客。

参考：[PaperMod 安装说明](https://github.com/adityatelange/hugo-PaperMod/wiki/Installation)。

## 附录 C：查资料时优先使用这些官方链接

| 资料 | 链接 |
| --- | --- |
| Hugo 项目 | [gohugoio/hugo](https://github.com/gohugoio/hugo) |
| 本教程使用的 Hugo 发布版本 | [Hugo v0.167.0](https://github.com/gohugoio/hugo/releases/tag/v0.167.0) |
| PaperMod 项目 | [adityatelange/hugo-PaperMod](https://github.com/adityatelange/hugo-PaperMod) |
| Hugo 文档 | [Hugo 官方文档](https://gohugo.io/documentation/) |
| Hugo 部署到 GitHub Pages | [官方部署教程](https://gohugo.io/host-and-deploy/host-on-github-pages/) |
| VS Code Git 入门 | [源代码管理教程](https://code.visualstudio.com/docs/sourcecontrol/quickstart) |
| VS Code 与 GitHub | [GitHub 集成说明](https://code.visualstudio.com/docs/sourcecontrol/github) |
| Git 下载 | [Git 官方下载](https://git-scm.com/downloads/win) |
| GitHub Pages 条件与限制 | [官方限制说明](https://docs.github.com/en/pages/getting-started-with-github-pages/github-pages-limits) |
| GitHub Pages 自定义域名 | [官方域名配置](https://docs.github.com/en/pages/configuring-a-custom-domain-for-your-github-pages-site) |
| 仓库备份 | [官方备份方法](https://docs.github.com/en/repositories/archiving-a-github-repository/backing-up-a-repository) |

## 完成记录

- [ ] 已确认 GitHub 用户名与公开主页。
- [ ] 已用 VS Code 打开正确博客目录。
- [ ] 已看到本地预览。
- [ ] 已修改站名、个人介绍与网址。
- [ ] 已完成至少一篇自己的真实文章。
- [ ] 已处理示例内容与草稿状态。
- [ ] 已通过正式构建。
- [ ] 已建立本地 Git 历史。
- [ ] 已把源码上传到自己的公开仓库。
- [ ] 已将 Pages 来源设为 GitHub Actions。
- [ ] 已确认在线部署成功。
- [ ] 已从公开网址检查网站。
- [ ] 已保留独立源码备份。

本教程已按账号 `yintaoc3-collab` 配置完成，站名“一只无辜的银”。文中 `zhangsan` 只用于演示用户名的位置；`YOUR_REPOSITORY` 表示你将来实际发布项目的仓库名，不是博客仓库，看到它属于正常情况。界面名称按当前官方说明整理，不同 VS Code 或 GitHub 界面语言可能略有不同，可按同名功能寻找。

