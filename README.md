# 一只无辜的银 · 个人博客

正式工作目录：`D:\博客正式版\my-blog`。在这一个目录里编辑和写文章。

在线博客：<https://yintaoc3-collab.github.io/my-blog/>

源码仓库：<https://github.com/yintaoc3-collab/my-blog>

博客使用固定版本 Hugo 和 PaperMod，界面已包含二次元插画、明暗切换、手机导航，以及嵌入式作品、开源方案、技术笔记、好物分享四个栏目。真实文章暂时为空。

## 从这里开始

双击 `阅读使用说明.cmd`，阅读 [本地使用说明](docs/开始使用.html)。更详细的步骤在 [完整教程](docs/从零搭建个人博客-完整指南.html)。

| 操作 | 双击的文件 | 结果 |
| --- | --- | --- |
| 预览博客 | `start-blog.cmd` | 自动打开浏览器，默认使用 `http://127.0.0.1:1321/` |
| 预览博客（另一个入口） | `start-ui-preview.cmd` | 与上面的入口相同 |
| 停止正式版预览 | `stop-blog.cmd` | 只停止这份目录启动的 Hugo 预览 |
| 检查正式构建 | `build-blog.cmd` | 清洁生成 `public/`，不发布草稿 |
| 备份源码 | `backup-blog.cmd` | 在 `.backups/` 新建 ZIP，不覆盖旧备份 |
| 阅读说明 | `阅读使用说明.cmd` | 打开离线使用说明 |

端口被其他程序占用时，启动脚本会自动选择附近的空闲端口；以启动窗口显示、自动打开的网址为准。重复启动会复用这份博客已有的预览。

本地预览包含草稿。由启动窗口新开预览时，保持窗口打开；按 `Ctrl+C` 停止。也可以使用 `stop-blog.cmd` 停止已经运行的正式版预览。

## 写自己的内容

用 VS Code 打开整个 `my-blog` 文件夹，从 `docs/templates/` 复制相应模板到下面的栏目。每篇文章放在单独目录中，正文文件名为 `index.md`，图片可以和正文放在一起。

| 内容 | 放在哪里 |
| --- | --- |
| 嵌入式作品 | `content/projects/项目英文名/index.md` |
| 开源方案 | `content/opensource/方案英文名/index.md` |
| 技术笔记 | `content/notes/笔记英文名/index.md` |
| 好物分享 | `content/goodies/资源英文名/index.md` |
| 个人介绍 | `content/about.md` |

写作期间保留 `draft: true`。准备公开时改成 `draft: false`，确认日期不晚于今天，运行正式构建，再在 VS Code 的源代码管理中提交和推送。GitHub Actions 会自动更新网站。

## 保留与恢复

源码备份包含 `.github`、文章、图片、主题、脚本和教程；不含 `.git`、`.tools`、`.cache`、`.build`、`.backups`、`public`、`resources` 或 Hugo 构建锁文件。从源码备份恢复时，可以复制原目录的 `.tools/hugo/`，或由启动脚本下载并校验固定版本 Hugo。

交付基础包额外包含便携 Hugo 和许可证，可以在没有安装 Hugo 的 Windows 电脑上运行。重打包使用 `docs/Package-Blog.ps1`，遇到同名 ZIP 会停止。

## 许可

PaperMod 原作者许可保留在 `themes/PaperMod/LICENSE`。将来发布真实文章、硬件方案或代码时，再为这些内容明确授权方式。
