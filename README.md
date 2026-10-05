# UI 新版：银的个人工作台

当前是 2026-10-06 二次元版：银发角色的电子工作台主图 + Q 版小角色。先阅读 [UI 新版方案与使用指南](docs/UI新版方案与使用指南.md)，配图与网上参考见 [二次元配图与参考来源](docs/二次元配图与参考来源.md)。双击 `start-ui-preview.cmd`，打开 http://127.0.0.1:1322/。新版仍采用 Hugo + PaperMod，真实文章尚未录入。

原有完整教程在 `docs/从零搭建个人博客-完整指南.html`。下面保留基础包的通用说明。

---

# 一只无辜的银 · 个人博客

这是一个 Hugo + PaperMod 博客，已按 GitHub 账号 `yintaoc3-collab` 配置完成：站名“一只无辜的银”，网址 `https://yintaoc3-collab.github.io/`。

本包源码是解压后的 `my-blog` 目录；教程放在 `docs\`。本次制作的独立副本位于 `outputs\银的博客-UI新版`，并未替换 `D:\本地博客`。请以本文件开头的新版预览方法为准。

## 先做什么

1. 双击 `start-blog.cmd`，保持窗口打开。
2. 使用 `start-blog.cmd` 时打开 `http://127.0.0.1:1313/`；使用新版 `start-ui-preview.cmd` 时打开 `http://127.0.0.1:1322/`。预览进程只在启动窗口保持打开时运行。
3. 用 VS Code 修改 `hugo.yaml` 和 `content/` 中的文章。
4. 用 `build-blog.cmd` 检查正式构建；删除过文章时加 `--cleanDestinationDir`。
5. 按 `docs\从零搭建个人博客-完整指南.html` 完成 GitHub Pages 上线。

## 工具按钮

| 文件 | 作用 |
| --- | --- |
| `start-blog.cmd` | 本地预览（含草稿） |
| `build-blog.cmd` | 正式构建（不含草稿） |
| `backup-blog.cmd` | 源码备份到 `.backups\`，记得再复制到别的磁盘 |
| `docs\Build-Guide.ps1` | 由 `docs\从零搭建个人博客-完整指南.md` 重新生成教程 HTML |
| `docs\Package-Blog.ps1` | 重新打出交付基础包（同名文件不会被覆盖） |

启动器只为当前 PowerShell 进程设置脚本运行策略，不改系统设置。`.tools\hugo\` 中是校验过的固定版本 Hugo；从 GitHub 重新克隆后该目录不存在，启动器会按固定 SHA-256 下载并校验。

## 主要文件

| 文件或目录 | 用途 |
| --- | --- |
| `hugo.yaml` | 网站名称、介绍、网址、菜单 |
| `content/projects/` | 嵌入式作品 |
| `content/opensource/` | 开源方案 |
| `content/notes/` | 技术笔记 |
| `content/goodies/` | 工具与资源 |
| `content/about.md` | 个人介绍（尚有待填写处） |
| `themes/PaperMod/` | 已固定版本的原始主题 |
| `docs/` | 教程、教程模板与两个脚本 |
| `.github/workflows/hugo.yaml` | GitHub 自动构建与发布流程 |
| `VERSIONS.md` | 版本与下载校验值 |
| `public/` | 自动生成的网页，不手动编辑，也不提交 |

四个栏目的示例文章已经删除，删除前的原文保存在 `.backups\removed-examples-20261005.zip`。

## 许可

PaperMod 的原作者许可保留在 `themes/PaperMod/LICENSE`。本项目未替你给将来的文章、硬件方案或代码选择公开许可证；发布真实开源方案时请单独明确它的授权方式。
