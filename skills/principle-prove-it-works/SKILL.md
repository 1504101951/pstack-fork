---
name: principle-prove-it-works
description: "在完成任务之后、宣布完成之前适用。对照真实的产物验证（运行功能、读取实际的值、检查 diff），而不是代理指标、自我报告或 'it compiles.'。"
disable-model-invocation: true
---

# Prove It Works

Verify every output by checking the real thing directly: run the feature, read the actual value, inspect the diff. Proxies (file mtimes, self-reports, cached output, "it compiles") do not count. When a check fails, suspect the observation method before the system.

Script the check when you can. A deterministic script that reruns the comparison beats a one-time look. Keep its output where the human can see it, and commit it only when the trail must be auditable later.
