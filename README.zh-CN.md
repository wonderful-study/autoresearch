<div align="center">

# Codex Autoresearch 中文指南

**把 Codex CLI 变成一个目标驱动、可度量、可回滚的自动迭代引擎。**

[English README](README.md) · [Guide Index](guide/README.md) · [Plugin README](plugins/autoresearch/README.md)

</div>

---

## 这是什么

`autoresearch` 是当前仓库提供的一个 Codex 插件包。它把 Karpathy 风格的 autoresearch 思路带到 Codex 里：

- 先定义 `Goal`
- 再定义一个可机械验证的 `Metric`
- 给出 `Verify` 命令
- 然后让 Codex 按循环持续尝试、验证、保留或回滚

它不只是用于“写代码”。只要结果可以被稳定量化，就可以用它做：

- 测试覆盖率提升
- 性能优化
- 类型错误、lint、构建错误修复
- 安全审计
- 发布前检查和交付
- 文档生成和更新
- 场景推演、边界条件探索
- 多专家预判和主观方案辩论

当前仓库包含：

- `10` 个 slash commands
- `10` 个显式 skills
- 一套共享 workflow references
- 一整套 guide、场景 walkthrough 和可复制示例

---

## 在 Codex 中怎么调用

安装插件之后，你可以用 3 种方式调用当前项目能力。

### 1. 直接用 slash commands

这是最推荐的入口，最适合日常使用：

```text
/autoresearch
/autoresearch:plan
/autoresearch:debug
/autoresearch:fix
/autoresearch:security
/autoresearch:ship
/autoresearch:scenario
/autoresearch:predict
/autoresearch:learn
/autoresearch:reason
```

### 2. 用 `@autoresearch` 显式加载插件

适合你想先把插件上下文显式带进对话，再自然描述任务：

```text
@autoresearch
Use autoresearch to improve test coverage in this repo
```

### 3. 用 `$autoresearch` 或具体 skill

适合你明确知道要直达哪个 workflow：

```text
$autoresearch
$autoresearch-plan
$autoresearch-debug
$autoresearch-fix
$autoresearch-security
$autoresearch-ship
$autoresearch-scenario
$autoresearch-predict
$autoresearch-learn
$autoresearch-reason
```

如果你只是想“最快上手”，优先用 slash commands。

---

## 安装方式

### 方式 A：在当前仓库里安装（推荐）

1. 用 Codex CLI 打开这个仓库。
2. 运行 `/plugins`。
3. 从当前仓库的 `.agents/plugins/marketplace.json` 里安装 `autoresearch`。

这个仓库已经提供了 repo-local marketplace：

- [`.agents/plugins/marketplace.json`](.agents/plugins/marketplace.json)
- [`plugins/autoresearch`](plugins/autoresearch)

安装完成后，你就能直接使用上面的 10 个命令。

### 方式 B：手动复制到 home-local 路径

```bash
git clone https://github.com/uditgoenka/autoresearch.git

mkdir -p ~/plugins ~/.agents/plugins
cp -R autoresearch/plugins/autoresearch ~/plugins/autoresearch
cp autoresearch/.agents/plugins/marketplace.json ~/.agents/plugins/marketplace.json
```

如果你已经维护自己的 `~/.agents/plugins/marketplace.json`，不要整文件覆盖，只合并其中的 `autoresearch` 条目。

### 安装后怎么确认

直接在 Codex 里输入：

```text
/autoresearch
```

如果 Codex 先检查仓库，再开始询问缺失的 `Goal`、`Scope`、`Metric`、`Verify` 等字段，说明插件已经可用。

---

## 先理解 4 个核心概念

如果这 4 个概念定义得好，效率会高很多。

| 概念 | 作用 | 例子 |
|---|---|---|
| `Goal` | 你想达到什么结果 | `Increase test coverage from 72% to 90%` |
| `Scope` | 允许 Codex 修改哪些文件 | `src/**/*.ts, src/**/*.test.ts` |
| `Metric` | 用什么数字判断是否变好 | `coverage % (higher is better)` |
| `Verify` | 输出该数字的命令 | `npm test -- --coverage \| grep "All files"` |

还有一个重要但可选的概念：

| 概念 | 作用 | 什么时候必须加 |
|---|---|---|
| `Guard` | 防止优化时引入回归 | 当你的 `Metric` 不是测试本身时 |

例如：

- 你在优化 bundle size，就应该加 `Guard: npm test`
- 你在优化 API 性能，就应该加 `Guard: npm test`
- 你在优化 Lighthouse 分数，就应该加 `Guard: npx playwright test`

### 好的 `Metric / Verify` 应该满足什么

- 可机械提取数字
- 同样输入应有稳定输出
- 最好在 30 秒内完成
- 成功时退出码为 `0`

不要把下面这些当成 metric：

- “看起来更干净了”
- “应该更快了”
- “大概更安全了”

这些描述都不够机械，跑长循环时会直接拖垮效果。

---

## 命令怎么选

如果你不确定先用哪个命令，先看这张表。

| 你想做什么 | 用什么 |
|---|---|
| 提升一个可量化指标 | `/autoresearch` |
| 不知道该怎么写 `Metric / Verify / Scope` | `/autoresearch:plan` |
| 排查 bug、失败用例、间歇性问题 | `/autoresearch:debug` |
| 把 tests / type / lint / build 错误逐步修到 0 | `/autoresearch:fix` |
| 发布前做安全审计 | `/autoresearch:security` |
| 做交付、发布、PR、deployment 检查 | `/autoresearch:ship` |
| 先扩展边界条件、用例、失败场景 | `/autoresearch:scenario` |
| 先让多个专家视角分析一遍 | `/autoresearch:predict` |
| 生成或更新项目文档 | `/autoresearch:learn` |
| 对主观方案做对抗式收敛 | `/autoresearch:reason` |

软件工程里最常见的高效主线通常是：

- `plan -> /autoresearch`
- `debug -> fix`
- `security -> fix -> security`
- `scenario -> debug -> fix`
- `/autoresearch -> ship`

---

## 第一次上手：推荐从 `:plan -> /autoresearch` 开始

很多人第一次用时，不是循环本身出问题，而是配置写错了。最稳的做法是先让 `:plan` 帮你校准。

### Step 1：让 Plan Wizard 帮你生成配置

```text
/autoresearch:plan
Goal: Increase test coverage from 72% to 90%
```

`/autoresearch:plan` 会先扫描仓库，然后帮你：

- 猜测合适的 `Scope`
- 推荐可机械验证的 `Metric`
- 判断是 `higher is better` 还是 `lower is better`
- dry-run `Verify` 命令
- 最后吐出一段可直接运行的 `/autoresearch` 配置

### Step 2：运行主循环

这是一个最典型、也最适合第一次复制试跑的例子：

```text
/autoresearch
Iterations: 20
Goal: Increase test coverage from 72% to 90%
Scope: src/**/*.test.ts, src/**/*.ts
Metric: coverage % (higher is better)
Verify: npm test -- --coverage | grep "All files"
```

Codex 会按下面的节奏循环：

1. 读取上下文和 git 历史
2. 一次只做一个改动
3. 运行 `Verify`
4. 指标提升就保留
5. 指标变差就回滚
6. 记录结果并继续下一轮

### 什么时候用 `Iterations`

- 想快速试跑：`Iterations: 5` 或 `10`
- 想做半小时优化：`Iterations: 10` 到 `20`
- 想长期跑：省略 `Iterations`，让它一直循环直到你中断

第一次使用时，建议先从 bounded run 开始，不要一上来就无限循环。

---

## 高频案例 1：`debug -> fix`

这个链路适合：

- 升级依赖后开始报错
- CI 突然红了
- 一堆 tests / type / lint / build 错误堆在一起
- 有 bug，但还没完全定位

### 先定位

```text
/autoresearch:debug
Scope: src/**/*.ts
Symptom: Multiple test failures after dependency upgrade
Iterations: 15
```

`debug` 的特点不是“修一个 bug 就停”，而是按科学方法连续找问题：

- 收集症状
- 建立假设
- 每轮只验证一个假设
- 记录已证伪和已证实结论
- 给出带代码证据的 findings

### 再自动修

```text
/autoresearch:fix --from-debug
Guard: npm test
Iterations: 30
```

或者一步到位：

```text
/autoresearch:debug --fix
Scope: src/**/*.ts
Iterations: 30
```

这是软件仓库里最常用、最省时间的一条链。

---

## 高频案例 2：发布前安全审计

如果你已经做完功能，但还没放心合并或部署，优先跑一次安全检查。

### PR / 差异审计

```text
/autoresearch:security --diff --fail-on critical
Iterations: 10
```

这个用法适合：

- 只检查最近改动
- 作为 CI / merge gate
- 在发版前快速做一次高风险筛查

### 它会做什么

- 建 STRIDE threat model
- 按 OWASP Top 10 和攻击面做审计
- 给每个 finding 附 `file:line`
- 附攻击场景和修复建议

如果你希望自动修高优问题，可以再加：

```text
/autoresearch:security --fix
Iterations: 15
```

---

## 高频案例 3：功能写完后补边界场景

很多 bug 不是出在 happy path，而是出在：

- 并发
- 异常恢复
- 权限切换
- 大数据量
- 超时和重试
- 边界输入

这时推荐：

```text
/autoresearch:scenario --domain software --format test-scenarios --depth deep
Scenario: Users upload files through the drag-and-drop interface
Iterations: 25
```

`scenario` 会围绕 12 个维度扩展场景，例如：

- edge cases
- failures
- concurrent
- recovery
- temporal
- permission
- scale

然后你可以继续串：

```text
/autoresearch:debug
Scope: src/upload/**/*.ts
Symptom: Edge cases from scenario exploration — concurrent uploads, large files, network interruptions
Iterations: 15
```

接着再修：

```text
/autoresearch:fix --from-debug
Guard: npm test
Iterations: 20
```

这条链非常适合“功能表面能跑，但你不确定边界是否足够稳”的阶段。

---

## 高频案例 4：优化完成后再交付

当你已经完成一轮优化、修复或安全加固后，可以用 `ship` 做最后一层交付检查。

### 只做 readiness 检查

```text
/autoresearch:ship --checklist-only
```

### 自动推进 code PR 交付

```text
/autoresearch:ship --auto
```

适合和这些链配合：

- `plan -> /autoresearch -> ship`
- `debug -> fix -> ship`
- `security -> fix -> ship`

---

## 仓库自带 demo / 示例资源在哪里

这个仓库**没有单独的 `demo/`、`demos/`、`examples/` 代码目录**。

最接近 demo 的内容，实际上在 `guide/` 里，分成两类：

### 1. 可直接复制的配置库

- [guide/examples-by-domain.md](guide/examples-by-domain.md)

这个文件按领域整理了大量可复制配置，包括：

- Software Engineering
- Python & Django
- Go
- Rust
- DevOps & Infrastructure
- Documentation & Knowledge Management
- CI/CD Integration
- Custom Verification Scripts
- MCP Servers

如果你想最快找到“别人已经写好的命令块”，先看它。

### 2. 端到端 walkthrough

- [guide/scenario/README.md](guide/scenario/README.md)

这里整理了 11 个真实场景 walkthrough。对软件工程用户，最值得先看的几个是：

- [guide/scenario/real-time-chat-messaging.md](guide/scenario/real-time-chat-messaging.md)
- [guide/scenario/cicd-pipeline-deployment.md](guide/scenario/cicd-pipeline-deployment.md)
- [guide/scenario/document-collaboration.md](guide/scenario/document-collaboration.md)

这些文档会告诉你：

- 适合用什么 `scenario` 配置
- 会生成哪些场景
- 后续应该怎么接 `debug`、`fix`、`security`、`ship`

### 3. 命令怎么串起来用

- [guide/chains-and-combinations.md](guide/chains-and-combinations.md)

如果你已经知道单个命令是什么，但不确定完整工作流怎么拼，优先看这个文件。

### 4. 高阶提效技巧

- [guide/advanced-patterns.md](guide/advanced-patterns.md)

这里重点覆盖：

- `Guard`
- 自定义 `Verify` 脚本
- MCP Servers
- CI/CD 集成
- 复合指标

---

## 进阶能力：什么时候用

除了软件工程主线里的几个高频命令，这几个命令也很强，只是更偏特定阶段。

### `/autoresearch:predict`

适合“先让多专家视角预判，再决定怎么做”：

```text
/autoresearch:predict --chain debug
```

适用场景：

- 问题复杂，怀疑不是单点故障
- 想在动手前先拿到架构、安全、性能、可靠性等多角度意见

### `/autoresearch:learn`

适合接手新仓库、生成文档、刷新文档：

```text
/autoresearch:learn --mode init
/autoresearch:learn --mode update
/autoresearch:learn --mode check
```

### `/autoresearch:reason`

适合没有客观 metric 的主观决策，比如：

- 架构方案取舍
- 产品方案辩论
- 内容或提案优化

```text
/autoresearch:reason --domain software
Task: Should we use event sourcing for our order management system?
Iterations: 8
```

---

## 怎么用才能更高效

下面这些做法，通常比“直接裸跑”高效得多。

### 1. 先用 `:plan` 校准，再跑长循环

长循环最怕的是：

- `Scope` 太宽
- `Verify` 写错
- `Metric` 不可提取
- 方向设反了

如果你不确定配置，先跑一次 `:plan`，再进入主循环。

### 2. 先小范围、短迭代试跑

建议顺序：

1. 先缩小 `Scope`
2. 先跑 `Iterations: 5` 或 `10`
3. 确认 `Verify` 稳定
4. 再扩大范围或改成 unbounded

### 3. `Metric` 不是测试时，一定加 `Guard`

例如：

```text
/autoresearch
Goal: Reduce production bundle size below 200KB
Scope: src/**/*.tsx, src/**/*.ts
Metric: bundle size in KB (lower is better)
Verify: npm run build 2>&1 | grep "First Load JS"
Guard: npm test
```

否则很容易出现“指标变好了，但功能坏了”的假优化。

### 4. 把命令当成链，而不是孤立功能

高效用户通常不是单跑一个命令，而是按阶段串起来：

- `plan -> /autoresearch`
- `debug -> fix`
- `predict -> debug`
- `scenario -> debug -> fix`
- `security -> fix -> security`
- `/autoresearch -> ship`

### 5. 验证越快，收益越高

如果每轮验证只要几秒，单位时间内能做的实验就会显著增加。

遇到复杂指标时，建议写自定义脚本并输出一个可解析数字。可参考：

- [guide/advanced-patterns.md](guide/advanced-patterns.md)
- [guide/examples-by-domain.md](guide/examples-by-domain.md)

### 6. 有 MCP 时，把真实数据接进来

如果你的 Codex CLI 已经配好 MCP，Autoresearch 可以把真实数据接入验证环节，例如：

- 数据库查询耗时
- GitHub / CI 状态
- Playwright / Lighthouse
- Sentry 错误率
- 外部 API 校验结果

这会显著提升 `Verify` 的现实价值。相关说明在：

- [guide/advanced-patterns.md](guide/advanced-patterns.md)

---

## 常见误区

### 误区 1：把目标写成主观描述

错误示例：

```text
Goal: Make the code cleaner
```

更好的写法：

```text
Goal: Reduce lint errors to zero
Metric: lint error count (lower is better)
Verify: npx eslint src/ 2>&1 | grep "problems"
```

### 误区 2：`Verify` 不能稳定输出数字

如果命令结果忽上忽下，或根本提不出数字，循环就会失真。

### 误区 3：一开始就给过大的 `Scope`

建议先从一个模块开始，例如：

```text
Scope: src/api/**/*.ts
```

而不是直接把整个 monorepo 全开。

### 误区 4：把 `guide/` 当成可执行样例工程

这个仓库没有独立 demo 应用。`guide/` 里的内容是“可复制配置”和“walkthrough 文档”，不是一个能直接 `npm install && npm run dev` 的演示项目。

### 误区 5：优化非测试指标时不加 `Guard`

这是最常见的效率坑之一。

---

## 建议的阅读顺序

如果你是第一次接触这个项目，建议这样看：

1. 先读本页，搞清楚安装、入口和命令选择
2. 再看 [guide/getting-started.md](guide/getting-started.md)
3. 然后看 [guide/examples-by-domain.md](guide/examples-by-domain.md)
4. 开始实际使用时，按需要深入单命令文档

推荐的重点文档：

- [guide/autoresearch-plan.md](guide/autoresearch-plan.md)
- [guide/autoresearch.md](guide/autoresearch.md)
- [guide/autoresearch-debug.md](guide/autoresearch-debug.md)
- [guide/autoresearch-fix.md](guide/autoresearch-fix.md)
- [guide/autoresearch-security.md](guide/autoresearch-security.md)
- [guide/autoresearch-ship.md](guide/autoresearch-ship.md)
- [guide/README.md](guide/README.md)

如果你想更细地看 flags、目录输出、链式模式和完整协议，仍以 `guide/` 下的英文文档为准。

---

## 一句话总结

想用好这个项目，最有效的习惯不是“直接让 Codex 干活”，而是：

1. 用 `:plan` 把配置校准
2. 用机械指标和快速验证驱动循环
3. 用 `Guard` 防回归
4. 用 `debug / fix / security / ship` 组成链式工作流
5. 直接复用仓库里的 guide 和 walkthrough，而不是从零摸索

这样最容易把 Autoresearch 真正变成一个高效率、可复用、可持续迭代的工作流。
