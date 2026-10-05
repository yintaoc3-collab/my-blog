# 已固定的依赖版本

核对日期：2026-10-05。

- Hugo：`0.167.0`，官方 Windows x64 标准版。
- Hugo Windows ZIP SHA-256：`f5ed1983b4373e719434cd721bf931907dec8ad33a891a6912903e93cfdcce98`。
- Hugo Linux x64 TAR.GZ SHA-256：`4d84519b9f619e6d4c3fb45a50157abeabeb724f859c60605f44c23def6e1169`。
- PaperMod：`d3768854d00ad003b0a8dbdba254ce9224377a01`。
- PaperMod 已直接放在 `themes/PaperMod/`，保留原作者许可证，不依赖 Git 子模块或在线拉取主题。
- GitHub 官方部署 Actions 固定到具体提交；各自版本在工作流文件的注释中。
- 本站用项目级模板覆盖 `baseof.html`、`rss.xml` 和 Open Graph 局部模板，将主题的旧语言属性改为 Hugo 当前的 `Direction`、`Locale`，原始主题目录保留不改。

来源：

- [Hugo 固定版本](https://github.com/gohugoio/hugo/releases/tag/v0.167.0)
- [PaperMod 固定提交](https://github.com/adityatelange/hugo-PaperMod/tree/d3768854d00ad003b0a8dbdba254ce9224377a01)

升级时先备份，再同时检查本地工具版本、下载脚本和 GitHub 工作流里的版本及校验值；在本地构建通过后再提交。固定版本减少意外变动，仍应定期检查上游维护与安全更新。
