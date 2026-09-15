# 回退 v3.1.1

发布前版本已由远程标签 `backup/pre-v3.1.1-20260915` 固定保存。

## 推荐方式：在 GitHub 回退本次提交

打开本次 v3.1.1 提交，在 GitHub 使用 **Revert**。这会生成一个新的回退提交，保留完整历史，不影响之后的协作提交。

## 精确恢复为发布前版本

仅在确认需要把 `main` 完全恢复到发布前快照时使用：

```bash
git fetch origin --tags
git switch main
git reset --hard backup/pre-v3.1.1-20260915
git push --force-with-lease origin main
```

第二种方式会重写远程分支历史；先确认没有其他人基于当前 `main` 继续提交。一般优先使用 GitHub Revert。
