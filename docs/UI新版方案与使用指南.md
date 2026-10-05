---
title: "银的个人工作台：二次元版 UI 与使用指南"
description: "参考来源、界面设计、运行方法、文章封面与维护说明。"
---

# 银的个人工作台：二次元版 UI 与使用指南

这是一份可以运行的 Hugo 博客源码。账号为 `yintaoc3-collab`，站名为「一只无辜的银」。正式版已整理到 `D:\博客正式版\my-blog` 并上线。日常在这个目录里编辑，旧目录和以前的 ZIP 保留作参考。

## 1. 这次参考了哪些网站

以下链接是查阅的官方网站或项目自己的仓库。表中的「借鉴」是我对它们的设计归纳；新版页面结构与 CSS 为本次编写。2026-10-06 增加了二次元设计参考，以及两张通过内置 image_gen 生成的配套插画；实际配图的保存路径和完整提示词见 `二次元配图与参考来源.md`。

| 来源 | 直接查看 | 本次借鉴的方向 |
| --- | --- | --- |
| 微软 Fluent 2 | [设计系统](https://fluent2.microsoft.design/) · [开源组件](https://github.com/microsoft/fluentui) | 一致的圆角、浅色层次、清楚的按钮和交互状态 |
| Vercel Geist | [设计系统](https://vercel.com/geist/introduction) | 网格对齐、留白、主次文字与开发者风格的等宽小标签 |
| GitHub Primer | [设计系统](https://primer.style/) · [开源组件](https://github.com/primer/react) | 导航、标签、卡片和源码入口的组织方式 |
| 乐鑫 Espressif | [开发者网站](https://developer.espressif.com/) | 封面、文章日期、标签、摘要与硬件技术内容的组合 |
| Fuwari | [实际演示](https://fuwari.vercel.app/) · [GitHub 源码](https://github.com/saicaca/fuwari) · [MIT 许可](https://github.com/saicaca/fuwari/blob/main/LICENSE) | 轻盈的彩色卡片、内容分区和浅色/深色切换 |
| Blowfish | [实际演示](https://blowfish.page/) · [GitHub 源码](https://github.com/nunocoracao/blowfish) · [MIT 许可](https://github.com/nunocoracao/blowfish/blob/main/LICENSE) | Hugo 的封面文章卡片、作品入口和内容展示方式 |
| Shirone | [GitHub 源码](https://github.com/LyraVoid/Shirone) · [项目演示](https://shirone.mysqil.com/) | 二次元插画与安静阅读区域的组合、柔和卡片、配套明暗主题 |
| Redefine | [GitHub 源码](https://github.com/EvanNotFound/hexo-theme-redefine) · [首页横幅文档](https://redefine-docs.ohevan.com/en/home/home_banner) | 用首屏图片建立个人风格，图片与标题分层组织 |

查阅时，Mizuki 仓库已明确宣布即将停止维护、迁移到 Shirone，所以这里把 Shirone 列为更新后的参考入口。参考项目的框架没有装进你的博客；演示站的图片也没有直接复制到包中。网上可免费使用的备选素材另列在配图说明里。

保留原来的 Hugo + PaperMod 基础，所以仍然使用 Markdown、便携 Hugo 和现有 GitHub Actions 部署。没有为这次外观更换新增 Node、npm、React 或 Astro 的构建要求。

## 2. 最终界面设计

### 2.1 首页

1. 顶部：蓝色「银」字标识、站名、五个栏目入口、搜索、主题切换、GitHub。
2. 第一屏：左侧个人介绍与「探索我的作品」按钮；右侧银发角色在电子工作台前调试开发板的二次元插画。蓝白配色和浅色图片边框与界面保持一致。
3. 四张栏目卡片：蓝色作品、绿色开源、紫色笔记、橙色好物。数量来自实际文章，零篇时显示「待收录」。
4. 最近记录：按日期展示最新六篇文章。有文章时出现封面卡片；没有文章时出现完整的待发布提示。
5. GitHub 横幅：同一角色的 Q 版小图与代码主页入口放在一起。小图随正文区域排列，不悬浮遮住内容。

这是嵌入式作品展示博客的版式。两张插画都是 AI 生成的虚构角色，不是你的本人照片或实际作品照片，也不能作为接线图使用。

### 2.2 栏目页与文章页

- 栏目页有标题面板，文章以卡片排列，超过每页八篇会分页。
- 图片未提供时，卡片使用该栏目的图标封面，不出现破图框。
- 文章保留发布时间、阅读信息、标签、代码复制、上一篇/下一篇。
- 有二级标题的文章可显示目录；大屏幕目录放在正文左侧，手机上移到正文前。
- 文章可增加 `repo` 字段，在标题下面显示「查看项目源码」按钮。
- 文章页面的署名等仍来自 `hugo.yaml`，个人经历仍由你自己填写。

### 2.3 配色与尺寸

| 项目 | 当前值 | 用途 |
| --- | --- | --- |
| 主强调色 | `#3263F4` | 按钮、作品栏和链接 |
| 深色文字 | `#17243C` | 标题 |
| 浅色卡片 | `#FFFFFF` | 承载主要内容 |
| 深色主题底色 | `#0D1422` | 夜间阅读 |
| 正文容器 | 最大 1160px | 首页和卡片排版 |
| 桌面文章字号 | 16px | 长文阅读 |
| 手机文章字号 | 15px | 小屏阅读 |
| 卡片圆角 | 14–20px | 保持组件一致 |

中文使用电脑系统字体，图片和图标在本地。页面不需要从外部字体 CDN 下载字体。

## 3. 怎么看这份新版

### 第一步：解压到一个新目录

做法：右键新版 ZIP →「全部解压」→ 选择 `D:\博客UI新版` 等新文件夹。包里的源码文件夹叫 `my-blog`。不要把整个文件夹覆盖到现有博客里。

目的：先独立体验、保留当前版本，也避免解压层级混淆。

检查：打开源码根目录，应该同时看到 `hugo.yaml`、`content`、`layouts`、`docs`、`start-ui-preview.cmd`。如果只看到 `my-blog` 一个文件夹，再点进去一层。

### 第二步：用 VS Code 打开源码根目录

做法：VS Code →「文件」→「打开文件夹」→ 选中刚才含 `hugo.yaml` 的目录。

目的：以后文章和配置都在这一个目录编辑。

### 第三步：启动新版预览

做法：双击 `start-ui-preview.cmd`，或在源码根目录终端执行：

```powershell
powershell -NoProfile -ExecutionPolicy Bypass -File .\scripts\Start-Blog.ps1 -Port 1321
```

目的：让 Hugo 将 Markdown、模板和样式实时生成网页；草稿只在本地预览可见。

检查：浏览器打开 <http://127.0.0.1:1321/>。终端应该显示该网址。关闭终端或按 `Ctrl+C` 后，预览结束。如果 1321 被占用，启动器会自动换到附近的空闲端口。以窗口显示、自动打开的网址为准。重复启动会复用这份目录已有的预览。

正式版的两个预览按钮已统一。停止预览可按 `Ctrl+C`，或双击 `stop-blog.cmd`；只会停止这份目录的预览。

### 第四步：检查界面

1. 点击「嵌入式作品」，应该出现栏目标题和待发布提示。
2. 点击「关于我」，检查自己的介绍。
3. 点击月亮/太阳按钮，检查浅色和深色主题。
4. 缩窄浏览器，点击右上角菜单图标，检查手机导航。
5. 搜索「关于我」，应找到已经存在的介绍页。

目的：先确认自己喜欢页面排版以及操作方式，再开始录入真实内容。

## 4. 怎样发布第一篇真实作品

### 第一步：创建作品目录

在 `content/projects` 中创建一个英文目录，例如 `my-first-project`，在里面新建 `index.md`。文件结构如下：

```text
content/
└─ projects/
   ├─ _index.md              ← 栏目说明，保留
   └─ my-first-project/
      ├─ index.md            ← 文章
      └─ cover.jpg           ← 你的实物照片，可稍后添加
```

目的：文章与照片放在同一目录，更容易复制、备份和维护。

### 第二步：填写文章信息

复制下面的内容到 `index.md`。每个占位内容都改成自己的实际信息。

```yaml
---
title: "你的真实作品名称"
date: 2026-10-05T12:00:00+08:00
draft: true
description: "用一两句话说明这个作品解决什么问题、有哪些功能。"
tags: ["填写芯片平台", "填写技术标签"]
# 有照片后再取消下面三行的注释，图片文件名要完全一致。
# cover:
#   image: "cover.jpg"
#   alt: "作品实物照片的文字描述"
# 有公开项目仓库后再取消下一行注释，并换成真实地址。
# repo: "https://github.com/yintaoc3-collab/你的项目仓库"
---

## 作品简介

写清楚用途、完成程度和目前能演示的功能。

## 硬件与接线

写出芯片、模块、供电、引脚连接；有原理图可一起放进该目录。

## 固件与实现

说明开发环境、关键代码、编译和烧录方法。

## 实际效果

放入实物图片、运行结果和测量数据。

## 复现与已知限制

写明步骤、依赖版本、还没有完成的部分。
```

目的：新界面会从这些字段取标题、日期、摘要、标签和图片，不需要修改首页 HTML。

`draft: true` 代表草稿。预览中可以看到，但正式构建不会发布。`date` 填实际发布时间，未来日期默认也不会发布。

### 第三步：加入真实封面

做法：把一张实物照片命名为 `cover.jpg`，放到 `index.md` 旁边。取消 `cover` 三行的注释。建议 16:9 横图，宽度约 1280px；先压缩成几百 KB，避免大照片拖慢网站。

目的：卡片有实物照片，才能更好地展示你的嵌入式作品。暂时没有照片时，保留注释，新界面会使用默认图标封面。

检查：保存文章后首页出现卡片，点击进入文章。首页只展示最新六篇，每个栏目中可以继续看全部内容。

### 第四步：准备正式发布

做法：检查正文、照片、仓库链接，再将 `draft: true` 改为 `draft: false`，保存后双击 `build-blog.cmd`。

目的：验证真正发布的页面，而不只是含草稿的预览。构建脚本只清理专用 `public` 输出目录里的旧网页，不清理你的正文和照片。

检查：构建成功且目标文章出现在 `public/projects/my-first-project/index.html`。然后按完整教程的 Git 提交、推送和 GitHub Pages 流程发布。

另有四个可复制模板位于 `docs/templates`。它们不在 `content` 中，所以不会作为你的作品公开。

## 5. 如何替换当前博客界面

建议先用新版独立目录试用。确认需要使用时，可把 UI 文件同步到 `D:\博客正式版\my-blog`，内容文件继续沿用原来的目录。

1. 停止准备改动的那份本地预览，避免复制中途反复重建。
2. 先将当前 `D:\博客正式版\my-blog` 做一份目录外备份。
3. 复制新版 `layouts` 目录和 `assets/css/extended` 目录到当前博客对应位置；新版有同名文件，覆盖前以备份为依据。
4. 复制新版 `assets/images/anime-workbench.png` 与 `assets/images/anime-mascot.png` 到同名目录；首页模板会用 Hugo 在构建时生成缩小后的网页图片，漏掉这两张原图会导致构建失败。`static/images/workbench.svg` 为上一版插画，可一并保留。
5. 复制 `scripts/Build-Blog.ps1` 和 `start-ui-preview.cmd`。这次只调整了构建输出清洁规则，现有 Pages 工作流可以继续使用。
6. 如要以后从模板创建文章，复制新版的 `archetypes` 和 `docs/templates`。
7. 用新的 `Start-Blog.ps1 -Port 1321` 命令预览，检查栏目、搜索、手机导航、文章内容。
8. 验证后再提交 Git。正式版已经连接 `yintaoc3-collab/my-blog` 并上线，后续提交和推送即可；「Clone」用于在新电脑上克隆这个已有仓库。

目的：在不搬动文章的情况下替换显示层。若你已经新增内容，不要用新版的空 `content` 目录覆盖自己的内容。

本次交付没有替你修改 D 盘博客、推送 GitHub 或设置线上 Pages。

## 6. 以后怎样调整外观

| 想改什么 | 编辑哪个文件 |
| --- | --- |
| 站名、作者、网址 | `hugo.yaml` |
| 首页大标题、介绍和按钮 | `layouts/home.html` |
| 四个栏目卡片文字 | `layouts/home.html` 中的栏目列表 |
| 可选浏览器与手机图标 | `layouts/_partials/head.html`、`hugo.yaml` 的 `params.assets` |
| 导航与「银」字标识 | `layouts/_partials/header.html` |
| 颜色、圆角、字号、手机布局 | `assets/css/extended/zz-workbench.css` |
| 文章卡片的图片、摘要、标签 | `layouts/_partials/lab-card.html` |
| 文章阅读结构 | `layouts/single.html` |
| 栏目页和分页 | `layouts/list.html` |
| 手机菜单的展开/关闭 | `layouts/_partials/extend_footer.html` |
| 首页二次元场景原图 | `assets/images/anime-workbench.png` |
| GitHub 横幅 Q 版角色 | `assets/images/anime-mascot.png` |

新版通过项目自己的 `layouts` 覆盖 PaperMod，而不修改 `themes/PaperMod` 里的上游源码。以后升级主题时仍需预览复核，因为这些覆盖模板与主题接口有关。

首页只显示最近六篇；旧文章一直保留在栏目和搜索中。没有评论、数据库、登录后台、在线上传或在线编辑器，这些不属于现阶段的个人静态博客需求。

## 7. 验收与长期使用

验收记录另见 `UI验收记录.md`。测试用文章放在工作目录的 `work/ui-qa`，不进入正式源码包；正式内容目前仍是你的介绍页与四个空栏目。

长期使用建议：先发布一篇真实作品、一份真实方案；每次改动先在本地预览，保留 Git 提交和目录外备份。主题和 Hugo 不必追着每次发布升级，升级时保留可恢复的旧版本。免费的 GitHub Pages 仍由其平台规则和服务状态决定，不能承诺永久免费或永远不中断。

保留包内 Hugo 和 PaperMod 的 LICENSE。Fuwari、Blowfish、Shirone 与 Redefine 是研究参考，其代码没有集成到这个包里。手机菜单脚本、新界面模板、样式和配图都随源码交付，可继续修改。

## 8. 二次元配图怎样更换

1. 在源码根目录打开 `assets/images`。先把想替换的原图复制到博客目录外作为备份。
2. 首页场景使用 4:3 横图。把新的图片保存为 `anime-workbench.png`，必须是实际 PNG 文件；不要仅把 JPG 扩展名改成 PNG。场景有明显人物时，保证头部和手部在画面内。
3. Q 版角色使用透明 PNG，保存为 `anime-mascot.png`。建议 2:3 竖图，四周留白；不需要给图片添加背景颜色。
4. 保存后刷新本地预览。首页主图在桌面生成 1120px 宽 JPEG，手机生成 640px 宽 JPEG；Q 版图生成 240px 宽 PNG，保留透明度。原图保留在源码中，浏览器只加载处理后的图片。
5. 点击主题按钮，检查深色边框与角色效果；把浏览器缩窄，确认角色没有挡住按钮。确认后运行 `build-blog.cmd`，再提交 Git。

目的：以后换图片只需要替换这两个文件，图片尺寸和地址由 Hugo 自动处理，不用自己改生成后的 `public` 文件。所有实际配图随网站保存，无需第三方图片链接或外部角色服务。
