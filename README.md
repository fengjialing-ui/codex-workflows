# Codex Workflows

这是一个用于跨电脑继续 Codex 工作的私有工作区。当前支持 How-to、Top 评测、VS、泛主题、Alternatives 与 What Is & Specs 的新建文章生成；文章回审作为独立下游流程处理最终优化与发布交付。

## 使用方法

1. 在 `brief.md` 写清楚当前任务和输出要求。
2. 让 Codex 读取 `AGENTS.md`、`brief.md` 和 `STATUS.md` 后开始工作；系统会按 `standards/08-多类型文章调度与共享标准_v1.md` 路由到对应模块。
3. 将最终成果保存到 `outputs/`。
4. 更新 `STATUS.md`，然后提交并同步到 GitHub。

## 换电脑后

下载本仓库，打开该文件夹，向 Codex 说明：

> 请阅读 `AGENTS.md`、`brief.md` 和 `STATUS.md`，继续这个项目。

`work/` 用于临时文件，不会上传到 GitHub。
